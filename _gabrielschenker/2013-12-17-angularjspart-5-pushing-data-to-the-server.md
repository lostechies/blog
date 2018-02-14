---
wordpress_id: 365
title: AngularJS–Part 5, pushing data to the server
date: 2013-12-17T22:47:19+00:00
author: Gabriel Schenker
layout: post
wordpress_guid: http://lostechies.com/gabrielschenker/?p=365
dsq_thread_id:
  - "2057704045"
categories:
  - AngularJS
  - CQRS
  - introduction
  - REST
---
# Introduction

This is a series of posts to describe our approach to slowly migrate a Silverlight based client of a huge and complex LOB&nbsp; to an HTML5/CSS3/JavaScript based client. These posts report on the lessons learnt and are meant to be used as a reference for our development teams. The first few post can be found here 

  * [AngularJS – Part 1](http://lostechies.com/gabrielschenker/2013/12/05/angularjspart-1/) 
      * [AngularJS – Part 1, Feedback](http://lostechies.com/gabrielschenker/2013/12/07/angularjspart-1-feedback/) 
          * [AngularJS – Part 2, the controller](http://lostechies.com/gabrielschenker/2013/12/09/angularjspart-2-the-controller/) 
              * [AngularJS – Part 3, Inheritance](http://lostechies.com/gabrielschenker/2013/12/10/angularjspart-3-inheritance/)
              * [AngularJS – Part 4, Accessing server side resources](http://lostechies.com/gabrielschenker/2013/12/12/angularjspart-4-accessing-server-side-resources/)</ul> 
            In my last [post](http://lostechies.com/gabrielschenker/2013/12/12/angularjspart-4-accessing-server-side-resources/) I introduced the [$http](http://docs.angularjs.org/api/ng.$http)**** service that can be used to access server side resources. So far we have looked at how we can query data on the server by using the HTTP GET method. In many web applications the HTTP GET method is used a lot more often than any other method. But from time to time we want to push some data gathered from the user to the server. Here we have various methods to do so. the most common methods are the HTTP POST, PUT or DELETE methods.
            
            In this post I will also for the first time discuss some specifics of the architecture of our enterprise application and what that means for the design of our Web client. But lets first start with the basics.
            
            # Sample
            
            We will create a simple sample to demonstrate the use of the [$http](http://docs.angularjs.org/api/ng.$http) service to send data to the server. In this sample we will use pretty much all the techniques that we have learned so far. In our sample we want to display a list of existing tasks with their status. We also want a Refresh button which we can click to get the latest list of tasks if we think that our currently displayed task list is stale. The list of tasks shall be provided by a [RESTful](http://en.wikipedia.org/wiki/RESTful) service.
            
            Let’s open our **HelloAngular** sample in Visual Studio. Add another HTML page called **step5.html** to the solution. Also add a JavaScript file **step5.js** to the solution. In the JavaScript file define an AngularJS application called **MyApp**. Add a controller **TaskListCtrl** to the AngularJS application. In the controller constructor use the **$http** service to access the list of defined tasks at the URI **api/tasks**. When the call successfully return assign the data of the response to the variable **tasks** defined on the **$scope**. So far our JavaScript file should look like this
            
            [<img style="border-left-width: 0px;border-right-width: 0px;border-bottom-width: 0px;padding-top: 0px;padding-left: 0px;margin: 0px 0px 24px;padding-right: 0px;border-top-width: 0px" border="0" alt="image" src="http://lostechies.com/content/gabrielschenker/uploads/2013/12/image_thumb47.png" width="613" height="163" />](http://lostechies.com/content/gabrielschenker/uploads/2013/12/image49.png)
            
            The HTML snippet to display the list of tasks looks like this
            
            [<img style="border-top: 0px;border-right: 0px;border-bottom: 0px;padding-top: 0px;padding-left: 0px;border-left: 0px;padding-right: 0px" border="0" alt="image" src="http://lostechies.com/content/gabrielschenker/uploads/2013/12/image_thumb48.png" width="457" height="133" />](http://lostechies.com/content/gabrielschenker/uploads/2013/12/image50.png)
            
            It is simply an unordered list with a list item for each task in the **tasks** collection of the controller. The above HTML snippet is nested in a <font face="Courier New">div</font> tag which has the ng-controller directive as an attribute. Just as a reminder: the whole part of the view which is nested inside a tag with a **ng-controller** directive is managed by the respective controller. Below the list of tasks we also want a <font face="Courier New">button</font> which when clicked will reload the tasks from the server in case our data has become stale. The button click event is linked to a **refresh()** method of the controller via the **ng-click** directive. All in all the complete view area managed by our **TaskListCtrl** controller looks like this
            
            [<img style="border-top: 0px;border-right: 0px;border-bottom: 0px;padding-top: 0px;padding-left: 0px;border-left: 0px;padding-right: 0px" border="0" alt="image" src="http://lostechies.com/content/gabrielschenker/uploads/2013/12/image_thumb49.png" width="601" height="253" />](http://lostechies.com/content/gabrielschenker/uploads/2013/12/image51.png)
            
            Now we need to define the **refresh** function on the **$scope** of the controller. Thus our controller looks like this
            
            [<img style="border-top: 0px;border-right: 0px;border-bottom: 0px;padding-top: 0px;padding-left: 0px;margin: 0px 0px 24px;border-left: 0px;padding-right: 0px" border="0" alt="image" src="http://lostechies.com/content/gabrielschenker/uploads/2013/12/image_thumb50.png" width="610" height="250" />](http://lostechies.com/content/gabrielschenker/uploads/2013/12/image52.png)
            
            The body of the function is just a copy of the **$http.get** call that we had already implemented earlier. We can now run the application (assuming we have a RESTful service listening at **api/tasks** and providing us a JSON-formatted list of tasks)
            
            It is of course bad to have such a code duplication and we should refactor the controller. This is what we get
            
            [<img style="border-top: 0px;border-right: 0px;border-bottom: 0px;padding-top: 0px;padding-left: 0px;border-left: 0px;padding-right: 0px" border="0" alt="image" src="http://lostechies.com/content/gabrielschenker/uploads/2013/12/image_thumb51.png" width="611" height="296" />](http://lostechies.com/content/gabrielschenker/uploads/2013/12/image53.png)
            
            # Sample REST service
            
            When using Visual Studio 2012/2013 we can simply add a Web API controller to our project. In this controller we only need to implement the Get method so far. In our simple sample the Get method shall return a pre-canned list of sample tasks.
            
            [<img style="border-top: 0px;border-right: 0px;border-bottom: 0px;padding-top: 0px;padding-left: 0px;border-left: 0px;padding-right: 0px" border="0" alt="image" src="http://lostechies.com/content/gabrielschenker/uploads/2013/12/image_thumb52.png" width="609" height="222" />](http://lostechies.com/content/gabrielschenker/uploads/2013/12/image54.png)
            
            where the class **Task** is defined like this
            
            [<img style="border-top: 0px;border-right: 0px;border-bottom: 0px;padding-top: 0px;padding-left: 0px;border-left: 0px;padding-right: 0px" border="0" alt="image" src="http://lostechies.com/content/gabrielschenker/uploads/2013/12/image_thumb53.png" width="438" height="161" />](http://lostechies.com/content/gabrielschenker/uploads/2013/12/image55.png)
            
            and the **TaskStatus** enumeration like this
            
            [<img style="border-top: 0px;border-right: 0px;border-bottom: 0px;padding-top: 0px;padding-left: 0px;margin: 0px;border-left: 0px;padding-right: 0px" border="0" alt="image" src="http://lostechies.com/content/gabrielschenker/uploads/2013/12/image_thumb54.png" width="244" height="186" />](http://lostechies.com/content/gabrielschenker/uploads/2013/12/image56.png)
            
            We need to bootstrap the REST service thus we add a **Global.asax** file to the project and define the code behind as follows
            
            [<img style="border-top: 0px;border-right: 0px;border-bottom: 0px;padding-top: 0px;padding-left: 0px;border-left: 0px;padding-right: 0px" border="0" alt="image" src="http://lostechies.com/content/gabrielschenker/uploads/2013/12/image_thumb55.png" width="608" height="153" />](http://lostechies.com/content/gabrielschenker/uploads/2013/12/image57.png)
            
            In the **GlobalConfiguration** class we just define the server routing such as that the URI **api/tasks** that we use in our **AngularJS** client maps to the **Get** method of the **TasksController** class.
            
            [<img style="border-top: 0px;border-right: 0px;border-bottom: 0px;padding-top: 0px;padding-left: 0px;border-left: 0px;padding-right: 0px" border="0" alt="image" src="http://lostechies.com/content/gabrielschenker/uploads/2013/12/image_thumb56.png" width="615" height="302" />](http://lostechies.com/content/gabrielschenker/uploads/2013/12/image58.png)
            
            # Creating a new task
            
            In our view lets define a new region where we can create a new task by entering a task name and pushing this new task to the server when clicking a create button. This area shall be managed by its own controller **NewTaskCtrl** and the controller shall be a child of the **TaskListCtrl**. Thus we nest the area inside the div that contains the **ng-controller** directive for the **TaskListCtrl** controller.
            
            [<img style="border-top: 0px;border-right: 0px;border-bottom: 0px;padding-top: 0px;padding-left: 0px;border-left: 0px;padding-right: 0px" border="0" alt="image" src="http://lostechies.com/content/gabrielschenker/uploads/2013/12/image_thumb57.png" width="587" height="133" />](http://lostechies.com/content/gabrielschenker/uploads/2013/12/image59.png)
            
            When looking at the above snippet we can see that we need to define a new Angular controller having a **taskName** property and a **createTask** function defined on the **$scope**.
            
            [<img style="border-top: 0px;border-right: 0px;border-bottom: 0px;padding-top: 0px;padding-left: 0px;border-left: 0px;padding-right: 0px" border="0" alt="image" src="http://lostechies.com/content/gabrielschenker/uploads/2013/12/image_thumb58.png" width="611" height="171" />](http://lostechies.com/content/gabrielschenker/uploads/2013/12/image60.png)
            
            In the body of the **createTask** function we have to put the logic which takes the task name entered by the user and pushes this value to the server. We will use the **$http.post** method to send our task to the backend. If everything goes well the server responds with a location entry in the response header. This location entry will contain the URI to the newly created task. We will then use **$http.get** with this URI to retrieve the new task and once we get it from the server append it to our tasks collection. Since the **tasks** collection is defined on the $scope of the **TaskListCtrl** controller and we are in the **NewTaskCtrl** controller we only have access to this collection if the **NewTaskCtrl** is a child controller of the **TaskListCtrl**.
            
            [<img style="border-top: 0px;border-right: 0px;border-bottom: 0px;padding-top: 0px;padding-left: 0px;margin: 0px 0px 24px;border-left: 0px;padding-right: 0px" border="0" alt="image" src="http://lostechies.com/content/gabrielschenker/uploads/2013/12/image_thumb59.png" width="606" height="163" />](http://lostechies.com/content/gabrielschenker/uploads/2013/12/image61.png)
            
            The post method accepts the URI as a first and the payload (content) as a second parameter. The post method is again an asynchronous method and thus returns a promise. We can register a **success** function&nbsp; (and optionally also an **error** function) with the promise. As detailed in the documentation the success callback function has the three parameters **data**, **status** and **headers** where **data** represents the content of the response, **status** represents the status code returned by the server in the response and **headers** is a collection of name value pairs as found in the header of the server response. From the headers collection we extract the **location** value which we use in the subsequent **$http.get** method call.
            
            Lets look at the server side and extend our REST service. We add a **Post** method to the **TasksController** which will just create a new **Task** instance with the data received from the client and append this task to the list of per-canned tasks. The response to the client is then enriched with a location header entry which will contain the URI to the newly created task, e.g. **app/tasks/7** if the new tasks has ID=7.
            
            [<img style="border-top: 0px;border-right: 0px;border-bottom: 0px;padding-top: 0px;padding-left: 0px;margin: 0px 0px 24px;border-left: 0px;padding-right: 0px" border="0" alt="image" src="http://lostechies.com/content/gabrielschenker/uploads/2013/12/image_thumb60.png" width="612" height="158" />](http://lostechies.com/content/gabrielschenker/uploads/2013/12/image62.png)
            
            We also need to provide a method in our REST service to handle Get requests for a single task. This is simple
            
            [<img style="border-top: 0px;border-right: 0px;border-bottom: 0px;padding-top: 0px;padding-left: 0px;border-left: 0px;padding-right: 0px" border="0" alt="image" src="http://lostechies.com/content/gabrielschenker/uploads/2013/12/image_thumb61.png" width="468" height="108" />](http://lostechies.com/content/gabrielschenker/uploads/2013/12/image63.png)
            
            And now we are ready to run our application and create some new tasks.
            
            # Can we improve?
            
            Not only should we push the data to the server but also we should tell the server the context, that is, we send a command to it. 
            
            > <font size="2"><font>If we provide context to the server, then</font> the server knows what to do with the data. This kind of operation is very different from a classical CRUD approach where the client just tells the server to CREATE/INSERT or UPDATE something. Insert and update (or even more general SAVE) methods are very generic and they do not reveal the intent of the client. The “why does the client want me to do something?” question goes lost when only using generic save operations.</font>
            
            # CQRS and REST
            
            There is a lot of discussion about whether the two concepts of [REST](http://en.wikipedia.org/wiki/Representational_state_transfer) and [CQRS](http://martinfowler.com/bliki/CQRS.html) can be combined in a meaningful application. As we will see the answer is yes, of course. Others have written some profound articles about combining REST with CQRS. Thus I invite you dear reader to read those articles if you want to dig a little bit deeper. I specifically want to point out [this](http://www.infoq.com/articles/rest-api-on-cqrs) article which was just published a couple of days ago on [InfoQ](http://www.infoq.com/).
            
            I can see 3 ways of combining a RESTful API with CQRS
            
              * Send the command as payload to a URI containing the command type, e.g.  
                <font face="Courier New">URI: api/tasks/1/complete</font> 
                  * The request body contains the command type as well as the command itself, e.g.  
                    <font face="Courier New">URI: api/tasks<br />Body: { CommandType: “CompleteTask”, Command: {} } or<br />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; { CommandType: “ChangeDueDate”, <br />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Command: { DueDate: “1/1/2014” } }<br /></font> 
                      * The request header contains the command type and the body contains the command  
                        <font face="Courier New">URI: api/tasks<br />Header: Command-Type: “ChangeDueDate”<br />Body: { DueDate: “1/1/2014” }</font></ul> 
                    <font face="Courier New"><font face="Georgia">Personally I favor the last variant and will use it in our sample.</font></font>
                    
                    That said, lets adjust out code. To define a custom header in our POST request we can use the optional **config** parameter and within define our custom header **CommandType**. We want to create a new task and thus we change our **createTask** function as follows.
                    
                    [<img style="border-top: 0px;border-right: 0px;border-bottom: 0px;padding-top: 0px;padding-left: 0px;margin: 0px 0px 24px;border-left: 0px;padding-right: 0px" border="0" alt="image" src="http://lostechies.com/content/gabrielschenker/uploads/2013/12/image_thumb62.png" width="613" height="229" />](http://lostechies.com/content/gabrielschenker/uploads/2013/12/image64.png)
                    
                    Note that the **config** parameter is optional and it is the third parameter of the post method. On the server side we have to unwrap the custom header and can the use it to determine what the context of the POST request is. In our sample we will reject any command type other than **CreateTask**.
                    
                    [<img style="border-top: 0px;border-right: 0px;border-bottom: 0px;padding-top: 0px;padding-left: 0px;border-left: 0px;padding-right: 0px" border="0" alt="image" src="http://lostechies.com/content/gabrielschenker/uploads/2013/12/image_thumb63.png" width="612" height="219" />](http://lostechies.com/content/gabrielschenker/uploads/2013/12/image65.png)<font face="Courier New"></font>
                    
                    <font face="Courier New"><font face="Georgia">In a more complex situation with many possible command types we would probably use the <a href="http://en.wikipedia.org/wiki/Strategy_pattern">strategy pattern</a> to handle the individual commands.</font></font>
                    
                    Using the developer tools of the browser we can see that the header of our POST request indeed contains the custom entry **CommandType** and the header of the response contains the **Location** header with the URI pointing to the newly created task.
                    
                    [<img style="border-top: 0px;border-right: 0px;border-bottom: 0px;padding-top: 0px;padding-left: 0px;margin: 0px 0px 24px;border-left: 0px;padding-right: 0px" border="0" alt="image" src="http://lostechies.com/content/gabrielschenker/uploads/2013/12/image_thumb64.png" width="610" height="508" />](http://lostechies.com/content/gabrielschenker/uploads/2013/12/image66.png)<font face="Courier New"><font face="Georgia"></p> 
                    
                    <p>
                      </font></font>
                    </p>
                    
                    <h1>
                      Summary
                    </h1>
                    
                    <p>
                      I have discussed how we can transfer data entered by a user to the server by using the $http service. Since our enterprise solution is not the typical CRUD type application we use CQRS as an architectural pattern. Our client sends intention revealing commands to the backend instead of just very generic “save” requests. I have shown how we can create such a command in AngularJS and send it to the server. Finally I have also shown how a simple implementation of a RESTful service backing our Angular client can look like.
                    </p>
                    
                    <p>
                      I have added the code that I presented so far in my series about AngularJS to GitHub. It can be found <a href="https://github.com/gnschenker/HelloAngular">here</a>.
                    </p>