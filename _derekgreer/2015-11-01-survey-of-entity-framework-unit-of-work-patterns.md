---
wordpress_id: 851
title: Survey of Entity Framework Unit of Work Patterns
date: 2015-11-01T21:12:48+00:00
author: Derek Greer
layout: post
wordpress_guid: https://lostechies.com/derekgreer/?p=851
dsq_thread_id:
  - "4281389801"
categories:
  - Uncategorized
---
Earlier this year I joined a development team which chose Entity Framework for the persistence needs of a new greenfield project. While I’ve worked on a few projects which used Entity Framework here and there over the years, the bulk of my experience has been with NHibernate and, more recently, Dapper.Net. As a result, there hasn’t been all that much occasion for me to explore it in any level of depth until this year. 

One area I recently took some time to research is how the Unit of Work pattern is best implemented within the context of using Entity Framework. While the topic is still relatively fresh on my mind, I thought I’d use this as an opportunity to create a catalog of various approaches I’ve encountered and include some thoughts about each approach.

## Unit of Work

To start, it may be helpful to give a basic definition of the Unit of Work pattern. A Unit of Work can be defined as a collection of operations that succeed or fail as a single unit. Given a series of operations which need to be executed in response to some interaction with an application, it’s often necessary to ensure that none of the operations cause side-effects if any one of them fails. This is accomplished by having participating operations respond to either a commit or rollback message indicating whether the operation performed should be completed or reverted. 

A Unit of Work can consist of different types of operations such as Web Service calls, Database operations, or even in-memory operations, however, the focus of this article will be on approaches to facilitating the Unit of Work pattern with Entity Framework.

With that out of the way, let’s take a look at various approaches to facilitating the Unit of Work pattern with Entity Framework.

## Implicit Transactions

The first approach to achieving a Unit of Work around a series of Entity Framework operations is to simply create an instance of a DbContext class, make changes to one or more DbSet<T> instances, and then call SaveChanges() on the context. Entity Framework automatically creates an implicit transaction for changesets which include INSERTs, UPDATEs, and DELETEs.

Here’s an example:

```csharp
public Customer CreateCustomer(CreateCustomerRequest request)
{
  Customer customer = null;

  using (var context = new MyStoreContext())
  {
    customer = new Customer { FirstName = request.FirstName, LastName = request.LastName };
    context.Customers.Add(customer);
    context.SaveChanges();
    return customer;
  }
}
```

The benefit of this approach is that a transaction is created only when necessary and is kept alive only for the duration of the SaveChanges() call. Some drawbacks to this approach, however, are that it leads to opaque dependencies and adds a bit of repetitive infrastructure code to each of your applications services.

If you prefer to work directly with Entity Framework then this approach may be fine for simple needs.

## TransactionScope

Another approach is to use the System.Transactions.TransactionScope class provided by the .Net framework. When any of the Entity Framework operations are used which cause a connection to be opened (e.g. SaveChanges()), the connection will enlist in the ambient transaction defined by the TransactionScope class and close the transaction once the TransactionScope is successfully completed. Here’s an example of this approach:

```csharp
public Customer CreateCustomer(CreateCustomerRequest request)
{
  Customer customer = null;

  using (var transaction = new TransactionScope())
  {
    using (var context = new MyStoreContext())
    {
      customer = new Customer { FirstName = request.FirstName, LastName = request.LastName };
      context.Customers.Add(customer);
      context.SaveChanges();
      transaction.Complete();
    }

    return customer;
  }
}
```

In general, I find using TransactionScope to be a good general-purpose solution for defining a Unit of Work around Entity Framework operations as it works with ADO.Net, all versions of Entity Framework, and other ORMs which provides the ability to use multiple libraries if needed. Additionally, it provides a foundation for building a more comprehensive Unit of Work pattern which would allow other types of operations to enlist in the Unit of Work.

Caution should be exercised when using TransactionScope, however, as certain operations can implicitly escalate the transaction to a distributed transaction causing undesired overhead. For those choosing solutions involving TransactionScope, I would recommend educating yourself on how and when transactions are escalated.

While I find using the TransactionScope class to be a good general-purpose solution, using it directly does couple your services to a specific strategy and adds a bit of noise to your code. While it’s a viable choice, I would recommend inverting the concerns of managing the Unit of Work boundary as shown in approaches we&#8217;ll look at later.

## ADO.Net Transactions

This approach involves creating an instance of DbTransaction and instructing the participating DbContext instance to use the existing transaction:

```csharp
public Customer CreateCustomer(CreateCustomerRequest request)
{
  Customer customer = null;

  var connectionString = ConfigurationManager.ConnectionStrings["MyStoreContext"].ConnectionString;
  using (var connection = new SqlConnection(connectionString))
  {
    connection.Open();
    using (var transaction = connection.BeginTransaction())
    {
      using (var context = new MyStoreContext(connection))
      {
        context.Database.UseTransaction(transaction);
        try
        {
          customer = new Customer { FirstName = request.FirstName, LastName = request.LastName };
          context.Customers.Add(customer);
          context.SaveChanges();
        }
        catch (Exception e)
        {
          transaction.Rollback();
          throw;
        }
      }

      transaction.Commit();
      return customer;
    }
  }
```

As can be seen from the example, this approach adds quite a bit of infrastructure noise to your code. While not something I’d recommend standardizing upon, this approach provides another avenue for sharing transactions between Entity Framework and straight ADO.Net code which might prove useful in certain situations. In general, I wouldn’t recommend such an approach.

## Entity Framework Transactions

The relative new-comer to the mix is the new transaction API introduced with Entity Framework 6. Here’s a basic example of it’s use:

```csharp
public Customer CreateCustomer(CreateCustomerRequest request)
{
  Customer customer = null;

  using (var context = new MyStoreContext())
  {
    using (var transaction = context.Database.BeginTransaction())
    {
      try
      {
        customer = new Customer { FirstName = request.FirstName, LastName = request.LastName };
        context.Customers.Add(customer);
        context.SaveChanges();
        transaction.Commit();
      }
      catch (Exception e)
      {
        transaction.Rollback();
        throw;
      }
    }
  }

  return customer;
}
```

This is the approach recommended by Microsoft for achieving transactions with Entity Framework going forward. If you’re deploying applications with Entity Framework 6 and beyond, this will be your safest choice for Unit of Work implementations which only require database operation participation. Similar to a couple of the previous approaches we’ve already considered, the drawbacks of using this directly are that it creates opaque dependencies and adds repetitive infrastructure code to all of your application services. This is also a viable option, but I would recommend coupling this with other approaches we&#8217;ll look at later to improve the readability and maintainability of your application services.

## Unit of Work Repository Manager

The first approach I encountered when researching how others were facilitating the Unit of Work pattern with Entity Framework was a strategy set forth by Microsoft’s guidance on the topic [here](http://www.asp.net/mvc/overview/older-versions/getting-started-with-ef-5-using-mvc-4/implementing-the-repository-and-unit-of-work-patterns-in-an-asp-net-mvc-application). This strategy involves creating a UnitOfWork class which encapsulates an instance of the DbContext and exposes each repository as a property. Clients of repositories take a dependency upon an instance of UnitOfWork and access each repository as needed through properties on the UnitOfWork instance. The UnitOfWork type exposes a SaveChanges() method to be used when all the changes made through the repositories are to be persisted to the database. Here is an example of this approach:

```csharp
public interface IUnitOfWork
{
  ICustomerRepository CustomerRepository { get; }
  IOrderRepository OrderRepository { get; }
  void Save();
}

public class UnitOfWork : IDisposable, IUnitOfWork
{
  readonly MyContext _context = new MyContext();
  ICustomerRepository _customerRepository;
  IOrderRepository _orderRepository;

  public ICustomerRepository CustomerRepository
  {
    get { return _customerRepository ?? (_customerRepository = new CustomerRepository(_context)); }
  }

  public IOrderRepository OrderRepository
  {
    get { return _orderRepository ?? (_orderRepository = new OrderRepository(_context)); }
  }

  public void Dispose()
  {
    if (_context != null)
    {
      _context.Dispose();
    }
  }

  public void Save()
  {
    _context.SaveChanges();
  }
}

public class CustomerService : ICustomerService
{
  readonly IUnitOfWork _unitOfWork;

  public CustomerService(IUnitOfWork unitOfWork)
  {
    _unitOfWork = unitOfWork;
  }

  public void CreateCustomer(CreateCustomerRequest request)
  {
    customer = new Customer { FirstName = request.FirstName, LastName = request.LastName };
    _unitOfWork.CustomerRepository.Add(customer);
    _unitOfWork.Save();
  }
}
```

It isn’t hard to imagine how this approach was conceived given it closely mirrors the typical implementation of the DbContext instance you find in Entity Framework guidance where public instances of DbSet<T> are exposed for each aggregate root. Given this pattern is presented on the ASP.Net website and comes up as one of the first results when doing a search for “Entity Framework” and “Unit of Work”, I imagine this approach has gained some popularity among .Net developers. There are, however, a number of issues I have with this approach. 

First, this approach leads to opaque dependencies. Due to the fact that classes interact with repositories through the UnitOfWork instance, the client interface doesn’t clearly express the inherent business-level collaborators it depends upon (i.e. any aggregate root collections). 

Second, this violates the Open/Closed Principle. To add new aggregate roots to the system requires modifying the UnitOfWork each time. 

Third, this violates the Single Responsibility Principle. The single responsibility of a Unit of Work implementation should be to encapsulate the behavior necessary to commit or rollback an set of operations atomically. The instantiation and management of repositories or any other component which may wish to enlist in a unit of work is a separate concern. 

Lastly, this results in a nominal abstraction which is semantically coupled with Entity Framework. The example code for this approach sets forth an interface to the UnitOfWork implementation which isn’t the approach used in the aforementioned Microsoft article. Whether you take a dependency upon the interface or the implementation directly, however, the presumption of such an abstraction is to decouple the application from using Entity Framework directly. While such an abstraction might provide some benefits, it reflects Entity Framework usage semantics and as such doesn’t really decouple you from the particular persistence technology you’re using. While you could use this approach with another ORM (e.g. NHibernate), this approach is more of a reflection of Entity Framework operations (e.g. it’s flushing model) and usage patterns. As such, you probably wouldn’t arrive at this same abstraction were you to have started by defining the abstraction in terms of the behavior required by your application prior to choosing a specific ORM (i.e. following The Dependency Inversion Principle). You might even find yourself violating the Liskof Substitution Principle if you actually attempted to provide an alternate ORM implementation. Given these issues, I would advise people to avoid this approach.

## Injected Unit of Work and Repositories

For those inclined to make all dependencies transparent while maintaining an abstraction from Entity Framework, the next strategy may seem the natural next step. This strategy involves creating an abstraction around the call to DbContext.SaveChanges() and requires sharing a single instance of DbContext among all the components whose operations need to participate within the underlying SaveChanges() call as a single transaction.

Here is an example:

```csharp
public class CustomerService : ICustomerService
{
  readonly IUnitOfWork _unitOfWork;
  readonly ICustomerRepository _customerRepository;

  public CustomerService(IUnitOfWork unitOfWork, ICustomerRepository customerRepository)
  {
    _unitOfWork = unitOfWork;
    _customerRepository = customerRepository;
  }

  public void CreateCustomer(CreateCustomerRequest request)
  {
    customer = new Customer { FirstName = request.FirstName, LastName = request.LastName };
    _customerRepository.Add(customer);
    _unitOfWork.Save();
  }
}
```

While this approach improves upon the opaque design of the Repository Manager, there are several issues I find with this approach as well.

Similar to the first example, this UnitOfWork implementation is still semantically coupled to how Entity Framework is urging you to think about things. Entity Framework wants you to call SaveChanges() whenever you’re ready to flush any INSERT, UPDATE, or DELETE operations you’ve issued against the database and this abstraction basically surfaces this behavior. If you were to use an alternate framework that supported a different flushing model (e.g. NHibernate), you likely wouldn’t end up with the same abstraction.

Moreover, this approach has no definitive Unit of Work boundary. With this approach, you aren’t defining a logical Unit of Work, but are merely injecting a UnitOfWork you can participate within. When you invoke the underlying DBContext.SaveChanges() method, it isn’t explicit what work will be committed.

While this approach corrects a few design issues I find with the Repository Manager, overall I like this approach even less. At least with the Repository Manager approach you have a defined Unit of Work boundary which is kind of the whole point. My recommendation would be to avoid this approach as well.

## Repository SaveChanges Method

The next strategy is basically a variation on the previous one. Rather than injecting a separate type whose sole purpose is to provide an indirect way to call the SaveChanges() method, some merely expose this through the Repository:

```csharp
public class CustomerService : ICustomerService
{
  readonly ICustomerRepository _customerRepository;

  public CustomerService(ICustomerRepository customerRepository)
  {
    _customerRepository = customerRepository;
  }

  public void CreateCustomer(CreateCustomerRequest request)
  {
    customer = new Customer { FirstName = request.FirstName, LastName = request.LastName };
    _customerRepository.Add(customer);
    _customerRepository.SaveChanges();
  }
}
```

This approach shares many of the same issues with the previous one. While it reduces a bit of infrastructure noise, it’s still semantically coupled to Entity Framework’s approach and still lacks a defined Unit of Work boundary. Additionally, it lacks clarity as to what happens when you call the SaveChanges() method. Given the Repository pattern is intended to be a virtual collection of all the entities within your system of a given type, one might suppose a method named “SaveChanges” means that you are somehow persisting any changes made to the particular entities represented by the repository (setting aside the fact that doing so is really a subversion of the pattern&#8217;s purpose). On the contrary, it really means “save all the changes made to any entities tracked by the underlying DbContext”. I would also recommend avoiding this approach.

## Unit of Work Per Request

A pattern I’m a bit embarrassed to admit has been characteristic of many projects I’ve worked on in the past (though not with EF) is to create a Unit of Work implementation which is scoped to a Web Application’s Request lifetime. Using this approach, whatever method is used to facilitate a Unit of Work is configured with a DI container using a Per-HttpRequest lifetime scope and the Unit of Work boundary is opened by the first component being injected by the UnitOfWork and committed/rolled-back when the HttpRequest is disposed by the container. 

There are a few different manifestations of this approach depending upon the particular framework and strategy you’re using, but here’s a pseudo-code example of how configuring this might look for Entity Framework with the Autofac DI container:

```csharp
builder.RegisterType<MyDbContext>()
        .As<DbContext>()
        .InstancePerRequest()
        .OnActivating(x =>
        {
          // start a transaction
        })
        .OnRelease(context =>
        {
          try
          {
            // commit or rollback the transaction
          }
          catch (Exception e)
          {
            // log the exception
            throw;
          }
        });

public class SomeService : ISomeService
{
  public void DoSomething()
  {
    // do some work
  }
}
```

While this approach eliminates the need for your services to be concerned with the Unit of Work infrastructure, the biggest issue with this is when an error happens to occur. When the application can’t successfully commit a transaction for whatever reason, the rollback occurs AFTER you’ve typically relinquished control of the request (e.g. You’ve already returned results from a controller). When this occurs, you may end up telling your customer that something happened when it actually didn’t and your client state may end up out of sync with the actual persisted state of the application.

While I used this strategy without incident for some time with NHibernate, I eventually ran into a problem and concluded that the concern of transaction boundary management inherently belongs to the application-level entry point for a particular interaction with the system. This is another approach I’d recommend avoiding.

## Instantiated Unit of Work

The next strategy involves instantiating a UnitOfWork implemented using either the .Net framework TransactionScope class or the transaction API introduced by Entity Framework 6 to define a transaction boundary within the application service. Here’s an example:

```csharp
public class CustomerService : ICustomerService
{
  readonly ICustomerRepository _customerRepository;

  public CustomerService(ICustomerRepository customerRepository)
  {
    _customerRepository = customerRepository;
  }

  public void CreateCustomer(CreateCustomerRequest request)
  {
    using (var unitOfWork = new UnitOfWork())
    {
      try
      {
        customer = new Customer { FirstName = request.FirstName, LastName = request.LastName };
        _customerRepository.Add(customer);        
        unitOfWork.Commit();
      }
      catch (Exception ex)
      {
        unitOfWork.Rollback();
      }
    }
  }
}
```

Functionally, this is a viable approach to facilitating a Unit of Work boundary with Entity Framework. A few drawbacks, however, are that the dependency upon the Unit Of Work implementation is opaque and that it’s coupled to a specific implementation. While this isn’t a terrible approach, I would recommend other approaches discussed here which either surface any dependencies being taken on the Unit of Work infrastructure or invert the concerns of transaction management completely.

## Injected Unit of Work Factory

This strategy is similar to the one presented in the Instantiated Unit of Work example, but makes its dependence upon the Unit of Work infrastructure transparent and provides a point of abstraction which allows for an alternate implementation to be provided by the factory:

```csharp
public class CustomerService : ICustomerService
{
  readonly ICustomerRepository _customerRepository;
  readonly IUnitOfWorkFactory _unitOfWorkFactory;

  public CustomerService(IUnitOfWorkFactory unitOfWorkFactory, ICustomerRepository customerRepository)
  {
    _customerRepository = customerRepository;
    _unitOfWorkFactory = unitOfWorkFactory;
  }

  public void CreateCustomer(CreateCustomerRequest request)
  {
    using (var unitOfWork = _unitOfWorkFactory.Create())
    {
      try
      {
        customer = new Customer { FirstName = request.FirstName, LastName = request.LastName };
        _customerRepository.Add(customer);
        unitOfWork.Commit();
      }
      catch (Exception ex)
      {
        unitOfWork.Rollback();
      }
    }
  }
}
```

While I personally prefer to invert such concerns, I consider this to be a sound approach.

As a side note, if you decide to use this approach, you might also consider utilizing your DI Container to just inject a Func<IUnitOfWork> to avoid the overhead of maintaining an IUnitOfWorkFactory abstraction and implementation.

## Unit of Work ActionFilterAttribute

For those who prefer to invert the Unit of Work concerns as I do, the following approach provides an easy to implement solution for those using ASP.Net MVC and/or Web API. This technique involves creating a custom Action filter which can be used to control the boundary of a Unit of Work at the Controller action level. The particular implementation may vary, but here’s a general template:

```csharp
public class UnitOfWorkFilter : ActionFilterAttribute
{
  public override void OnActionExecuting(ActionExecutingContext filterContext)
  {
    // begin transaction
  }

  public override void OnActionExecuted(ActionExecutedContext filterContext)
  {
    // commit/rollback transaction
  }
}
```

The benefits of this approach are that it’s easy to implement and that it eliminates the need for introducing repetitive infrastructure code into your application services. This attribute can be registered with the global action filters, or for the more discriminant, only placed on actions resulting in state changes to the database. Overall, this would be my recommended approach for Web applications. It’s easy to implement, simple, and keeps your code clean.

## Unit of Work Decorator

A similar approach to the use of a custom ActionFilterAttribute is the creation of a custom decorator. This approach can be accomplished by utilizing a DI container to automatically decorate specific application service interfaces with a class which implements a Unit of Work boundary.

Here is a pseudo-code example of how configuring this might look for Entity Framework with the Autofac DI container which presumes that some form of command/command-handler pattern is being utilized (e.g. frameworks like [MediatR](https://github.com/jbogard/MediatR) , [ShortBus](https://github.com/mhinze/ShortBus), etc.):

```csharp
// DI Registration
builder.RegisterGenericDecorator(
     typeof(TransactionRequestHandler<,>), // the decorator instance
     typeof(IRequestHandler<,>), // the types to decorate
    "requestHandler", // the name of the key to decorate
     null); // the name of the key to this decorator



public class TransactionRequestHandler<TRequest, TResponse> : IRequestHandler<TRequest, TResponse> where TResponse : ApplicationResponse
{
  readonly DbContext _context;
  readonly IRequestHandler<TRequest, TResponse> _decorated;

  public TransactionRequestHandler(IRequestHandler<TRequest, TResponse> decorated, DbContext context)
  {
    _decorated = decorated;
    _context = context;
  }

  public TResponse Handle(TRequest request)
  {
    TResponse response;

    // Open transaction here

    try
    {
      response = _decorated.Handle(request);

      // commit transaction

    }
    catch (Exception e)
    {
      //rollback transaction
      throw;
    }

    return response;
  }
}


public class SomeRequestHandler : IRequestHandler<SomeRequest, ApplicationResponse>
{
  public ApplicationResponse Handle()
  {
    // do some work
    return new SuccessResponse();
  }
}
```

While this approach requires a bit of setup, it provides an alternate means of facilitating the Unit of Work pattern through a decorator which can be used by other consumers of the application layer aside from just ASP.Net (i.e. Windows services, CLI, etc.) It also provides the ability to move the Unit of Work boundary closer to the point of need for those who would rather provide any error handling prior to returning control to the application service client (e.g. the Controller actions) as well as giving more control over the types of operations decorated (e.g. IQueryHandler vs. ICommandHandler). For Web applications, I’d recommend trying the custom Action Filter approach first, as it’s easier to implement and doesn’t presume upon the design of your application layer, but this is certainly a good approach if it fits your needs.

## Conclusion

Out of the approaches I’ve evaluated, there are several that I see as sound approaches which maintain some minimum adherence to good design practices. Of course, which approach is best for your application will be dependent upon the context of what you’re doing and to some extent the design values of your team.
