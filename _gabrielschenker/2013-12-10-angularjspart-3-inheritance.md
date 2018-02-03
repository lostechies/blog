---
wordpress_id: 305
title: AngularJS–Part 3, Inheritance
date: 2013-12-10T23:08:07+00:00
author: Gabriel Schenker
layout: post
wordpress_guid: http://lostechies.com/gabrielschenker/?p=305
dsq_thread_id:
  - "2042787696"
categories:
  - AngularJS
  - introduction
---
# Introduction

This is a series of posts to describe our approach to slowly migrate a Silverlight based client of a huge and complex LOB&nbsp; to an HTML5/CSS3/JavaScript based client. These posts report on the lessons learnt and are meant to be used as a reference for our development teams. The first few post can be found here

  * [AngularJS – Part 1](http://lostechies.com/gabrielschenker/2013/12/05/angularjspart-1/)
  * [AngularJS &#8211; Part 1, Feedback](http://lostechies.com/gabrielschenker/2013/12/07/angularjspart-1-feedback/)
  * [AngularJS – Part 2, the controller](http://lostechies.com/gabrielschenker/2013/12/09/angularjspart-2-the-controller/)

I have been surprised by the positive feedback to my first few posts. This encourages me to continue my series full steam. Thanks to all readers sharing their thoughts!

In this post I want to discuss the aspect of controller inheritance.

# JavaScript is not an OO language

Once again it is important to remind ourselves that JavaScript is not one of the classical OO computer languages. Yes, we can write object oriented code in JavaScript but this is certainly not the best language to do so. Much more should we embrace the functional aspect of JavaScript. Many of the popular libraries do this. jQuery seems to be the most prominent example and also AngularJS follows this line clearly. In this regard when talking about inheritance we should not expect the same behavior as we know from C# or Java, which are two of the most popular OO languages.

# Controller inheritance

What can I expect then from controller inheritance? Let’s look at a sample right away. We create two controllers, a parent and a child controller. We can add the necessary code to the **app.js** file of our sample application. Let’s just start with the definition of the empty controllers

[<img style="border-top: 0px;border-right: 0px;border-bottom: 0px;padding-top: 0px;padding-left: 0px;border-left: 0px;padding-right: 0px" border="0" alt="image" src="http://lostechies.com/gabrielschenker/files/2013/12/image_thumb23.png" width="532" height="88" />](http://lostechies.com/gabrielschenker/files/2013/12/image25.png)

Whenever we define a new controller we give it a name and add it to the controller collection of our Angular app. The controller itself is a function which wraps the data (or the model) and the logic which constitute the controller. So far our two new controllers are just empty hulls.

## Simple variables

Let’s start by defining a simple variable **title** in the parent controller and **content** in the child controller. It is important that these are simple (string) variables and not objects.

[<img style="border-top: 0px;border-right: 0px;border-bottom: 0px;padding-top: 0px;padding-left: 0px;border-left: 0px;padding-right: 0px" border="0" alt="image" src="http://lostechies.com/gabrielschenker/files/2013/12/image_thumb24.png" width="564" height="187" />](http://lostechies.com/gabrielschenker/files/2013/12/image26.png)

Now we need a view where we use these two new controllers. Let’s create a new HTML page called **part3.html**. As we have learned in the [previous](http://lostechies.com/gabrielschenker/2013/12/09/angularjspart-2-the-controller/) post a controller manages part of a view. Often this is a <font face="Courier New">div</font> tag containing the Angular directive **ng-controller** whose value is set to the name of the controller. To make the child controller **ChildCtrl** a true child of the parent controller **ParentCtrl** the area managed by the parent needs to wrap the area managed by the child controller, or said differently, the child controller must be wrapped by the parent controller. This is a typical layout

[<img style="border-top: 0px;border-right: 0px;border-bottom: 0px;padding-top: 0px;padding-left: 0px;border-left: 0px;padding-right: 0px" border="0" alt="image" src="http://lostechies.com/gabrielschenker/files/2013/12/image_thumb25.png" width="619" height="436" />](http://lostechies.com/gabrielschenker/files/2013/12/image27.png)

As you can see, the outer parent <font face="Courier New">div</font> wraps the inner child <font face="Courier New">div</font> . Make sure you don’t forget to also add the **ng-app** directive referencing our application called **myApp**. Usually we add the directive to the <font face="Courier New">body</font> tag. Also make sure you have referenced the Angular JavaScript **angular.js** file and our application JavaScript file **app.js**. Furthermore we also need our **app.css** file containing the layout defined so far. I have added the **scope** class to the two <font face="Courier New">div</font> tags to be able to visually see the parent and the child context or scope on the view.

Now let’s add some <font face="Courier New">input</font> tags that bind to the **title** and the **content** values defined in the controllers. We add

  * an <font face="Courier New">input</font> bound to **title** to the parent <font face="Courier New">div</font> 
  * an <font face="Courier New">input</font> also bound to **title** (defined in the parent controller) to the child <font face="Courier New">div</font> 
  * an <font face="Courier New">input</font> bound to **content** to the child <font face="Courier New">div</font> 

[<img style="border-top: 0px;border-right: 0px;border-bottom: 0px;padding-top: 0px;padding-left: 0px;border-left: 0px;padding-right: 0px" border="0" alt="image" src="http://lostechies.com/gabrielschenker/files/2013/12/image_thumb26.png" width="558" height="225" />](http://lostechies.com/gabrielschenker/files/2013/12/image28.png)

Save and open the view **part3.html** in your favorite browser. You should see something similar to this

[<img style="border-top: 0px;border-right: 0px;border-bottom: 0px;padding-top: 0px;padding-left: 0px;border-left: 0px;padding-right: 0px" border="0" alt="image" src="http://lostechies.com/gabrielschenker/files/2013/12/image_thumb27.png" width="447" height="244" />](http://lostechies.com/gabrielschenker/files/2013/12/image29.png)

We can nicely see how the child area is nested inside the parent area. We can also see how the binding works as we see the texts displayed as we have defined them in the controllers. It is important to note how the child inherits the **title** value from its parent.

Now type something into the first input box (owned by the parent controller) and observe how the text in the input box owned by the child controller changes too.

[<img style="border-top: 0px;border-right: 0px;border-bottom: 0px;padding-top: 0px;padding-left: 0px;border-left: 0px;padding-right: 0px" border="0" alt="image" src="http://lostechies.com/gabrielschenker/files/2013/12/image_thumb28.png" width="447" height="219" />](http://lostechies.com/gabrielschenker/files/2013/12/image30.png)

That’s what we expect, right? But now to the interesting part, change the text in the input box in the child area and observe the outcome.

[<img style="border-top: 0px;border-right: 0px;border-bottom: 0px;padding-top: 0px;padding-left: 0px;border-left: 0px;padding-right: 0px" border="0" alt="image" src="http://lostechies.com/gabrielschenker/files/2013/12/image_thumb29.png" width="447" height="219" />](http://lostechies.com/gabrielschenker/files/2013/12/image31.png)

Apparently my changes entered in the child area did not affect the value displayed in the parent area! And if you now change the value in the parent area again, the child value won’t change anymore.

What happened here? The **title** variable – a simple variable of type string &#8211; was defined on the parent **$scope**. At first the child inherited this value. But then, once the user changes the **title** value in a control bound to **title** located in the child area Angular creates a new variable **title** on the child **$scope** and from this moment on child and parent **title** are decoupled. Each controller has its own instance.

## Complex types

If we want to avoid this behavior of having a local instance in the child scope we need to use complex types, that is objects. Let’s change our definition in the parent controller as follows

[<img style="border-top: 0px;border-right: 0px;border-bottom: 0px;padding-top: 0px;padding-left: 0px;border-left: 0px;padding-right: 0px" border="0" alt="image" src="http://lostechies.com/gabrielschenker/files/2013/12/image_thumb30.png" width="606" height="97" />](http://lostechies.com/gabrielschenker/files/2013/12/image32.png)

Our **title** is now a property of a variable **model** which in turn is an object. We also have to adjust our binding in the view as shown below

[<img style="border-top: 0px;border-right: 0px;border-bottom: 0px;padding-top: 0px;padding-left: 0px;border-left: 0px;padding-right: 0px" border="0" alt="image" src="http://lostechies.com/gabrielschenker/files/2013/12/image_thumb31.png" width="602" height="182" />](http://lostechies.com/gabrielschenker/files/2013/12/image33.png)

If we refresh the browser and play with the two input boxes we can verify that this time **model.title** does not get redefined on the client scope and remains a property of the parent scope inherited by the child scope. This is a very important difference in behavior that we need to be aware of.

Now the clever person might ask: “And what happens if I reset the **model** object all together from the client $scope?”. Ah, good question I say to myself. Let’s try it. Add a <font face="Courier New">button </font>to the child <font face="Courier New">div</font> and bind the <font face="Courier New">click</font> event to a function called **setModel**.

[<img style="border-top: 0px;border-right: 0px;border-bottom: 0px;padding-top: 0px;padding-left: 0px;border-left: 0px;padding-right: 0px" border="0" alt="image" src="http://lostechies.com/gabrielschenker/files/2013/12/image_thumb32.png" width="596" height="132" />](http://lostechies.com/gabrielschenker/files/2013/12/image34.png)

define the **setModel** on the child $scope as follows

[<img style="border-top: 0px;border-right: 0px;border-bottom: 0px;padding-top: 0px;padding-left: 0px;border-left: 0px;padding-right: 0px" border="0" alt="image" src="http://lostechies.com/gabrielschenker/files/2013/12/image_thumb33.png" width="547" height="63" />](http://lostechies.com/gabrielschenker/files/2013/12/image35.png)

Refresh the browser and verify that after clicking the button once again the two input boxes are disconnected. We have now our own instance of **model** defined on the child $scope.

# Inheriting functions

Now we want to explore how functions are inherited. For this purpose we define a function **greet** on the parent $scope. This function when called just shows an alert box greeting the user.

[<img style="border-top: 0px;border-right: 0px;border-bottom: 0px;padding-top: 0px;padding-left: 0px;border-left: 0px;padding-right: 0px" border="0" alt="image" src="http://lostechies.com/gabrielschenker/files/2013/12/image_thumb34.png" width="368" height="85" />](http://lostechies.com/gabrielschenker/files/2013/12/image36.png)

We then add a <font face="Courier New">button</font> to the parent&nbsp; and one to the child area and bind both <font face="Courier New">click</font> events to this newly defined function

[<img style="border-top: 0px;border-right: 0px;border-bottom: 0px;padding-top: 0px;padding-left: 0px;border-left: 0px;padding-right: 0px" border="0" alt="image" src="http://lostechies.com/gabrielschenker/files/2013/12/image_thumb35.png" width="558" height="156" />](http://lostechies.com/gabrielschenker/files/2013/12/image37.png)

Please refresh the browser and confirm that no matter which of the two buttons you click the application will always show the same alert box. With this we have proven that a child controller can indeed inherit functions from its parent controller.

But what happens if we redefine the function **greet** on the child $scope? Let’s try and define such a function which shows an alert box with a different text. 

[<img style="border-top: 0px;border-right: 0px;border-bottom: 0px;padding-top: 0px;padding-left: 0px;border-left: 0px;padding-right: 0px" border="0" alt="image" src="http://lostechies.com/gabrielschenker/files/2013/12/image_thumb36.png" width="356" height="85" />](http://lostechies.com/gabrielschenker/files/2013/12/image38.png)

Ok, when doing that we realize that now the button defined in the child area displays the new alert message. This means that we have just broken the inheritance chain and the child has now its very own definition of a function with name **greet**. 

# Summary

We have discussed how inheritance works in the context of Angular controllers. In Angular we talk of a child controller if the view area that is managed by the child controller is nested inside the view area that is managed by the parent controller. Simple values (e.g. strings, numbers, booleans, etc.) are only inherited by a child controller as long as they are not redefined on the child $scope. Properties of object on the other hand are always inherited by the child controller as long as we do not redefine the whole object on the client $scope. A child controller also inherits functions defined on the parent controller as long as they are not redefined on the child $scope. 

In the next post I will have a look on how we get data from a server by using the $http service provided by AngularJS.