---
wordpress_id: 274
title: AngularJS–Part 2, the controller
date: 2013-12-09T09:48:42+00:00
author: Gabriel Schenker
layout: post
wordpress_guid: http://lostechies.com/gabrielschenker/?p=274
dsq_thread_id:
  - "2038333286"
categories:
  - AngularJS
  - introduction
---
# Introduction

This is a series of posts to describe our approach to slowly migrate a Silverlight based client of a huge and complex LOB&nbsp; to an HTML5/CSS3/JavaScript based client. These posts report on the lessons learnt and are meant to be used as a reference for our development teams. The first part of this series can be found [here](http://lostechies.com/gabrielschenker/2013/12/05/angularjspart-1/).

So far we have talked about the view and the model in the last post but we have not yet introduced a controller. A controller contains the (presentation or workflow) logic of our Web client. It is written in JavaScript. AngularJS strongly encourages us to separate concerns and put all logic/code into controllers and keep the view (the html page or html fragment) free from any JavaScript. The model on the other hand is a representation of the data we need to display or change through the user’s input.

We need a place where to put our code and thus we add a new JavaScript file **app.js** to our folder **HelloAngular**. We reference this file in our html page **after** referencing the **angular.js** file.*)

[<img style="border-left-width: 0px;border-right-width: 0px;border-bottom-width: 0px;padding-top: 0px;padding-left: 0px;padding-right: 0px;border-top-width: 0px" border="0" alt="image" src="http://lostechies.com/gabrielschenker/files/2013/12/image_thumb7.png" width="448" height="85" />](http://lostechies.com/gabrielschenker/files/2013/12/image7.png)

*)_I specifically mention this since it happened more than one time to me that I introduced a new file with JavaScript code and forgot to reference it in my view, leaving me wonder why my app would not work as expected…_

# The application

Now it is time to define an (AngularJS) application. Angular defines modules and for the moment our app is an angular module. We can do this as follows

[<img style="border-left-width: 0px;border-right-width: 0px;border-bottom-width: 0px;padding-top: 0px;padding-left: 0px;padding-right: 0px;border-top-width: 0px" border="0" alt="image" src="http://lostechies.com/gabrielschenker/files/2013/12/image_thumb8.png" width="471" height="44" />](http://lostechies.com/gabrielschenker/files/2013/12/image8.png)

Here my application is an Angular module and is called **myApp**. The second parameter in the module definition represents the dependencies**) that my module/app has. In our sample it is an empty array meaning that we have no dependencies so far. 

_**) Angular uses dependency injection similar to what we know from a typical C# application where we use an IoC container._

# The first controller

Ok, finally we are ready to define a first controller. We add the controller to the controller collection of our Angular application as follows

[<img style="border-left-width: 0px;border-right-width: 0px;border-bottom-width: 0px;padding-top: 0px;padding-left: 0px;padding-right: 0px;border-top-width: 0px" border="0" alt="image" src="http://lostechies.com/gabrielschenker/files/2013/12/image_thumb9.png" width="496" height="93" />](http://lostechies.com/gabrielschenker/files/2013/12/image9.png)

_As a developer used to code with an OO language like C# or Java we have to be aware of the fact that JavaScript is not an OO language. Yes, we can use it in a similar way as an OO language but this is definitely not its strength. Rather should we embrace the functional aspect of the language and code accordingly._

Most modern JavaScript libraries like JQuery and AngularJS do so and one consequence we see right away in the above definition of our first controller called **FirstCtrl**. In looking at the name of the controller we can identify two conventions typically used in Angular.

  * Names of Controllers are in [Pascal Case](http://en.wikipedia.org/wiki/Pascal_case) 
      * Names of Controllers have a suffix **Ctrl**</ul> 
    The actual controller is a function wrapping all the code and state that make up the controller. In the above snippet we have a function with no parameters. As we will see below usually a controller (constructor) has one to many parameters that will be provided to the controller via dependency injection.
    
    # Data and scope
    
    Lets first define some data in the controller. We want to define an object with properties whose values can be data bound to the view and whose values can also be programmatically set or changed in the controller. Data in a controller is usually defined on the [scope](http://docs.angularjs.org/api/ng.$rootScope.Scope) of a controller. Let’s do this
    
    [<img style="border-top: 0px;border-right: 0px;border-bottom: 0px;padding-top: 0px;padding-left: 0px;margin: 0px 0px 24px;border-left: 0px;padding-right: 0px" border="0" alt="image" src="http://lostechies.com/gabrielschenker/files/2013/12/image24_thumb.png" width="601" height="35" />](http://lostechies.com/gabrielschenker/files/2013/12/image24.png)
    
    But wait a second, what is a scope and how do I get a scope? 
    
    A [scope](http://en.wikipedia.org/wiki/Scope_(computer_science)) as defined by Wikipedia is the part of the program in which a name that refers some entity can be used to find the entity. Here we talk about data, but the same also applies to functions. In JavaScript functions are treated much the same way as data. As we will see when defining an Angular controller we will define the data it deals with and the logic it encapsulates on the scope of the controller.
    
    I get my scope via dependency injection, that is, it is provided to me by Angular. Thus I can just change the definition of my controller as such
    
    [<img style="border-top: 0px;border-right: 0px;border-bottom: 0px;padding-top: 0px;padding-left: 0px;margin: 0px 0px 24px;border-left: 0px;padding-right: 0px" border="0" alt="image" src="http://lostechies.com/gabrielschenker/files/2013/12/image20_thumb.png" width="615" height="52" />](http://lostechies.com/gabrielschenker/files/2013/12/image20.png)
    
    _Note the parameter **$scope** of the function._ _Also note that all Angular services or providers are prefixed with a $ sign._ 
    
    In the above snippet we define an object **model** on the **$scope** which has two properties **firstName** and **lastName**. The properties are initialized with according values. When we now refresh our page we would expect that the property **firstName** of the model object is bound to our view and thus the view displays the value “Gabriel”. Try it out… Ok?
    
    It didn’t work. Why not? It’s not working because we did not yet tell Angular to use our application **myApp** and with it the controller **FirstCtrl**. Let’s do this then. First we add the name of our application as a value to the **ng-app** directive which we had previously added to the <font face="Courier New">body</font> tag.
    
    [<img style="border-left-width: 0px;border-right-width: 0px;border-bottom-width: 0px;padding-top: 0px;padding-left: 0px;padding-right: 0px;border-top-width: 0px" border="0" alt="image" src="http://lostechies.com/gabrielschenker/files/2013/12/image_thumb10.png" width="262" height="34" />](http://lostechies.com/gabrielschenker/files/2013/12/image10.png)
    
    then we wrap our little html fragment with the <font face="Courier New">input</font> and the <font face="Courier New">div</font> tag into another <font face="Courier New">div</font> which contains an **ng-controller** directive. The value of the directive is the name of the controller we have defined.
    
    [<img style="border-left-width: 0px;border-right-width: 0px;border-bottom-width: 0px;padding-top: 0px;padding-left: 0px;padding-right: 0px;border-top-width: 0px" border="0" alt="image" src="http://lostechies.com/gabrielschenker/files/2013/12/image_thumb11.png" width="603" height="109" />](http://lostechies.com/gabrielschenker/files/2013/12/image11.png)
    
    If we now refresh the page our binding works perfectly and the initial value as defined in the controller is displayed both in the text input an the div. And with this we have shown that the binding works from the controller to the view. But does it also work in the opposite direction? To show this we need to add some logic to the controller.
    
    # Logic
    
    Let’s add a button to the view whose click event we bind to a function defined in our controller. In the function we just show an alert with the current content of the **firstName** property of the model object. So let’s first add the logic to the controller. As I mentioned above functions are defined on the **$scope** of the controller similar to the model or data. We can do this just after the definition of the model.
    
    [<img style="border-top: 0px;border-right: 0px;border-bottom: 0px;padding-top: 0px;padding-left: 0px;border-left: 0px;padding-right: 0px" border="0" alt="image" src="http://lostechies.com/gabrielschenker/files/2013/12/image_thumb12.png" width="534" height="90" />](http://lostechies.com/gabrielschenker/files/2013/12/image12.png)
    
    Now we add the <font face="Courier New">button</font> to the view. We use the **ng-click** directive to bind the click event of the button to the **clickMe** function in the controller. 
    
    [<img style="border-top: 0px;border-right: 0px;border-bottom: 0px;padding-top: 0px;padding-left: 0px;border-left: 0px;padding-right: 0px" border="0" alt="image" src="http://lostechies.com/gabrielschenker/files/2013/12/image_thumb13.png" width="538" height="44" />](http://lostechies.com/gabrielschenker/files/2013/12/image13.png)
    
    Note that this is different from the traditional way of doing things, where we would have used the <font face="Courier New">onclick</font> attribute of the <font face="Courier New">button</font> tag to bind the click event to some JavaScript code in the view. When we run the application and enter say “Jack” into the input box and then click on the button an alert box will popup greeting Jack as expected.
    
    [<img style="border-top: 0px;border-right: 0px;border-bottom: 0px;padding-top: 0px;padding-left: 0px;border-left: 0px;padding-right: 0px" border="0" alt="image" src="http://lostechies.com/gabrielschenker/files/2013/12/image_thumb14.png" width="509" height="249" />](http://lostechies.com/gabrielschenker/files/2013/12/image14.png)
    
    As trivial as this example seems and as easy as the code looks it is still a quite important concept that we have explored here. I have shown so far how we can data-bind between the model (defined in the controller) and the view as well how we can bind user actions which trigger events on the view to functions defined in the controller.
    
    We are of course not limited to parameter-less function calls. Instead of using the **$scope** in the **clickMe** function to get the name we can as well define a name parameter on the function and show its content in the alert box
    
    [<img style="border-top: 0px;border-right: 0px;border-bottom: 0px;padding-top: 0px;padding-left: 0px;border-left: 0px;padding-right: 0px" border="0" alt="image" src="http://lostechies.com/gabrielschenker/files/2013/12/image_thumb15.png" width="402" height="86" />](http://lostechies.com/gabrielschenker/files/2013/12/image15.png)
    
    The call in the view has then to be adjusted and we have to pass the **model.firstName** as a parameter in our function call
    
    [<img style="border-top: 0px;border-right: 0px;border-bottom: 0px;padding-top: 0px;padding-left: 0px;margin: 0px 0px 24px;border-left: 0px;padding-right: 0px" border="0" alt="image" src="http://lostechies.com/gabrielschenker/files/2013/12/image_thumb16.png" width="601" height="35" />](http://lostechies.com/gabrielschenker/files/2013/12/image16.png)
    
    # Multiple controllers per view
    
    We can have multiple controllers per view governing different areas of the view. In such a scenario each controller manages a fragment of the overall page. To visualize this lets define a style that we put on each area managed by a controller. Please add a new file **app.css** to your folder **HelloAngular** and reference it from the html page.
    
    [<img style="border-top: 0px;border-right: 0px;border-bottom: 0px;padding-top: 0px;padding-left: 0px;border-left: 0px;padding-right: 0px" border="0" alt="image" src="http://lostechies.com/gabrielschenker/files/2013/12/image_thumb17.png" width="546" height="112" />](http://lostechies.com/gabrielschenker/files/2013/12/image17.png)
    
    Add a style **.scope** to the **app.css**. This style basically draws a black border around the area which is governed by a single controller.
    
    [<img style="border-top: 0px;border-right: 0px;border-bottom: 0px;padding-top: 0px;padding-left: 0px;border-left: 0px;padding-right: 0px" border="0" alt="image" src="http://lostechies.com/gabrielschenker/files/2013/12/image_thumb18.png" width="360" height="139" />](http://lostechies.com/gabrielschenker/files/2013/12/image18.png)
    
    Now duplicate the html fragment in the view managed by the FirstCtrl controller and add a class scope to each of the two fragments. 
    
    [<img style="border-top: 0px;border-right: 0px;border-bottom: 0px;padding-top: 0px;padding-left: 0px;margin: 0px 0px 24px;border-left: 0px;padding-right: 0px" border="0" alt="image" src="http://lostechies.com/gabrielschenker/files/2013/12/image_thumb19.png" width="611" height="231" />](http://lostechies.com/gabrielschenker/files/2013/12/image19.png)
    
    Each of the two html fragments will now be managed by its own instance of the **FirstCtrl** controller. These two fragments are completely independent from each other as you can verify by yourself when refreshing the view in the browser
    
    [<img style="border-top: 0px;border-right: 0px;border-bottom: 0px;padding-top: 0px;padding-left: 0px;border-left: 0px;padding-right: 0px" border="0" alt="image" src="http://lostechies.com/gabrielschenker/files/2013/12/image_thumb20.png" width="427" height="254" />](http://lostechies.com/gabrielschenker/files/2013/12/image21.png)
    
    We can even nest controller instances as shown in the following sample
    
    [<img style="border-top: 0px;border-right: 0px;border-bottom: 0px;padding-top: 0px;padding-left: 0px;border-left: 0px;padding-right: 0px" border="0" alt="image" src="http://lostechies.com/gabrielschenker/files/2013/12/image_thumb21.png" width="426" height="467" />](http://lostechies.com/gabrielschenker/files/2013/12/image22.png)
    
    and the according (complete) html is shown here
    
    [<img style="border-top: 0px;border-right: 0px;border-bottom: 0px;padding-top: 0px;padding-left: 0px;border-left: 0px;padding-right: 0px" border="0" alt="image" src="http://lostechies.com/gabrielschenker/files/2013/12/image_thumb22.png" width="610" height="579" />](http://lostechies.com/gabrielschenker/files/2013/12/image23.png)
    
    # Summary
    
    In this post I have introduced the **AngularJS** controller. With this we have discussed all three pieces of the MVC (model-view-controller) pattern that is commonly used when building an Angular app. I have shown how we can bind data to the controller and we have proven that the data-binding is indeed a two way binding. We have also learned how to bind an event of a view control (such as the click event of a button) to a function defined in the controller. Furthermore we have briefly discussed how we can have multiple instances of a controller managing different, possibly nested parts of the view. In my next post I will look a bit more closely into the inheritance between controllers and child controllers and compare this JavaScript type of inheritance with the familiar one used in C#.