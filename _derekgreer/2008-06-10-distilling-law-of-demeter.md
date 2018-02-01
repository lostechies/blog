---
id: 454
title: Distilling the Law of Demeter
date: 2008-06-10T15:33:00+00:00
author: Derek Greer
layout: post
guid: http://www.aspiringcraftsman.com/2008/06/distilling-the-law-of-demeter/
dsq_thread_id:
  - "334901434"
categories:
  - Uncategorized
tags:
  - Law of Demeter
---
Separation of Concerns is a fundamental design principle within the field of software engineering and is vital for achieving maintainable systems of any substantial complexity. One characteristic shared by designs possessing good separation of concerns is minimized coupling. Coupling occurs when one component creates a dependency upon another within a system, thus reducing the change tolerance of the dependent component. Ensuring that coupling between components is kept to a bare minimum maximizes the change tolerance of the system and in turn improves overall maintainability.

One set of design guidelines developed by Ian Holland at Northeastern University in 1987 purposed for minimizing coupling within software systems is The Law of Demeter. The Law of Demeter seeks to reduce unnecessary coupling by prescribing a set of limiting guidelines governing when one object may access another.

## Demeter Defined

The Law of Demeter can be defined as follows:

For any class C, a method M belonging to C may only invoke other methods belonging to the following:

  * Class C
  * Members of C
  * Parameters of M
  * Objects created by M
  * Objects created by other methods of class C called by M
  * Globally accessible objects

<p style="padding-left: 30px">
  <em>Note: In keeping with the spirit of the Law of Demeter, this restriction would also extend to any member types of objects belonging to any of the above.</em>
</p>

That is to say, an object should only understand the internal structure of objects it creates directly, objects passed as method parameters, or objects which are otherwise globally accessible within an application. By observing these guidelines, developers are forced to create shallow relationships between objects which in turn reduce the number of classes which may be affected by changes within a system.

The following diagram represents the restrictions imposed by the Law of Demeter:

[<img class="aligncenter size-full wp-image-293" src="http://www.aspiringcraftsman.com/wp-content/uploads/2010/03/DemeterBoundary.png" alt="" width="558" height="216" />](http://www.aspiringcraftsman.com/wp-content/uploads/2010/03/DemeterBoundary.png)

In this diagram, Object A has a dependency on Object B which composes Object C. Under the Law of Demeter, Object A is permitted to invoke methods on Object B, but is not permitted to invoke methods on Object C.

## The Paperboy Example

One example set forth by David Bock to help explain the Law of Demeter is an interaction between a customer and a paperboy. The following presents the paperboy example in C#.

Consider an application which consists of the types Paperboy, Customer, and Wallet:

<pre class="brush:csharp">public class Paperboy
    {
        decimal fundsCollected;

        public Paperboy()
        {
            Customers = new List();
        }

        public List Customers { get; set; }

        // ...
    }

    public class Customer
    {
        public Customer() : this(null)
        {
        }

        public Customer(Wallet wallet)
        {
            Wallet = wallet;
        }

        public Wallet Wallet { get; set; }
    }

    public class Wallet
    {
        public Wallet(decimal money)
        {
            Money = money;
        }

        public decimal Money { get; set; }
    }
</pre>

Now, consider the following Paperboy method for collecting the sum of $2.00 from all customers:

<pre class="brush:csharp">public void CollectPayments()
        {
            // Paper costs $2.00
            decimal payment = 2m;

            foreach (Customer customer in Customers)
            {
                if (customer.Wallet.Money &gt;= payment)
                {
                    customer.Wallet.Money -= payment;
                    fundsCollected += payment;
                }
            }
        }
</pre>

Within the CollectPayments() method, the Wallet of each Customer is accessed in order to collect the payment amount required by the Paperboy. Since the Wallet class is not a member of the Paperboy class, is not passed in as a parameter to the Paperboy method, is not created within a Paperboy method, and is not globally accessible, this code violates the Law of Demeter according to the guidelines established above. By allowing the Paperboy class to access the Wallet class directly, the Paperboy class becomes coupled to both the Customer class and to the Wallet class. Changes to the Wallet class may result in the need to change both the Customer and Paperboy classes.

To solve this problem, the payment method can be encapsulated within a new MakePayment() method of Customer:

<pre class="brush:csharp">public decimal MakePayment(decimal amount)
        {
            if (Wallet.Money &gt;= amount)
            {
                Wallet.Money -= amount;
                return amount;
            }

            return 0m;
        }
</pre>

The CollectPayment() method could then be rewritten as follows:

<pre class="brush:csharp">public void CollectPayments()
        {
            decimal charge = 2m;

            foreach (Customer customer in Customers)
            {
                decimal payment = customer.MakePayment(charge);

                if (payment != 0m)
                {
                    fundsCollected += payment;
                }
            }
        }
</pre>

By observing the guidelines set forth by the Law of Demeter, the desired functionality has been achieved while reducing the coupling within the application. If the Wallet class changes, it will now only require that the Customer class be modified to accommodate any changes.

## Demeter Consequences

While the approach to achieving low coupling prescribed by the Law of Demeter within an application will always result in a minimal dependency tree depth, there are a few negative consequences that can result from its adherence.

One consequence of adhering strictly to the Law of Demeter is the inability to properly model some real-world interactions when desired. For example, imagine an application which seeks to model the interactions required between a heart surgeon and their patient &#8230;

[<img class="aligncenter size-full wp-image-88" src="http://www.aspiringcraftsman.com/wp-content/uploads/2010/01/DemeterHeart.png" alt="" width="254" height="255" />](http://www.aspiringcraftsman.com/wp-content/uploads/2010/01/DemeterHeart.png)

If the same course of action were taken as prescribed within the Paperboy example, what might be the logical outcome? One result might be: &#8220;Patient, heal thyself!&#8221;

In some cases, the problem domain makes more sense to be modeled with a dependency graph consistent with reality. Personally, I know very little about how my heart works. I don&#8217;t know its weight, I don&#8217;t know its size, and I certainly wouldn&#8217;t be much help in the operating room as the patient. In this case, it&#8217;s good that HeartSurgeon is not only knowledgeable about the Patient, but that it is also knowledgeable about the Heart, PulmonaryValve, Aorta, and all the other parts of the heart I wouldn&#8217;t care to assist with during my own operation.

Other consequences that may result from the increase of methods used to encapsulate the behavior of composed objects are an increase in the overall complexity of the code and a decrease in application performance.

## The Demeter Monkey Experiment

One of the potential pitfalls inherent to the creation of rules is the tendency for some to focus more on the adherence to the rule rather than understanding the ultimate purpose behind the rule. While the ultimate goal behind the Law of Demeter is to minimize coupling within an application, the restrictions set forth by the Law of Demeter are not optimal in every case. For this reason, it is important to stress the value of the objective over the value of the rules themselves, and to encourage weighing the adherence to these prescriptions along with other design goals of a given application.

## A Better Name: The Principle of Least Knowledge

The term &#8220;Principle of Least Knowledge&#8221; has been set forth as both an alternate name for
  
the Law of Demeter and as a more general principle. If taken merely as a synonym, the name itself still implies some degree of nuance. To quote the book Head First Design Patterns:

<p style="padding-left: 30px">
  <em>We prefer to use the [term] Principle of Least Knowledge for a couple of reasons: (1) the name is more intuitive and (2) the use of the word &#8220;Law&#8221; implies we always have to apply this principle. In fact, no principle is a law, and all principles should be used when and where they are helpful.</em>
</p>

Denoting a more general principle, the term &#8220;Principle of Least Knowledge&#8221; could be defined as follows:

<p style="padding-left: 30px">
  <strong>Principle of Least Knowledge:</strong> A component should take on no more knowledge about another than is absolutely necessary to perform an inherent concern.
</p>

Given this definition, the Law of Demeter would be seen as a specific application of this principle within object-oriented systems.

Whether understood as a more general principle or as merely a synonym, the name Principle of Least Knowledge certainly is more intuitive and less presumptuous.

## Conclusion

While not appropriate in every case, the Law of Demeter nonetheless establishes a great set of guidelines which can aid in one&#8217;s endeavor to maximize the change tolerance within a system. One would do well to examine their systems in light of these guidelines, giving close consideration to any areas deviating from these prescriptions.
