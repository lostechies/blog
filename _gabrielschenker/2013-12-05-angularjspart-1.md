---
wordpress_id: 234
title: AngularJS–Part 1
date: 2013-12-05T22:31:09+00:00
author: Gabriel Schenker
layout: post
wordpress_guid: http://lostechies.com/gabrielschenker/?p=234
dsq_thread_id:
  - "2028871421"
categories:
  - AngularJS
  - introduction
---
{% raw %}
This is an introduction to [AngularJS](http://angularjs.org) and is mainly meant as a internal reference for our development team. More posts on the topic will follow.

# Why AngularJS?

[AngularJS](angularjs.org) is one of the most popular Open Source JavaScript frameworks. It is developed by Google and has a huge community surrounding and supporting it. We use AngularJS to migrate the MS Silverlight based client of our complex enterprise application to HTML5/CSS/JavaScript.

Several factors were deciding in the choice of the framework. Alternatives that we have considered were

  * no framework, just use various libraries and build our own infrastructure
  * [Ember](http://emberjs.com/)
  * [Durandel](http://durandaljs.com/)
  * [AngularJS](http://angularjs.org)

We have been developing a lot of infrastructure on our own in the past. In the beginning this was a (sometimes huge) advantage but became more and more a burden over time. Thus we decided not to go this route this time and as a consequence to exclude variant one.

Base on our experience with Silverlight we also wanted to avoid a proprietary or closed source solution.

[AngularJS](http://angularjs.org) seems to have the biggest and most active community. For pretty much any question in and around [AngularJS](http://angularjs.org) one can find answers on [StackOverflow](http://stackoverflow.com/). This is a very important point for a team where not every member is an expert. Quick accessibility of help and insight is a big plus. It is easy to find new developers that have a working knowledge of AngularJS.

[AngularJS](angularjs.org) is extremely simple to start with. Let’s just do it

# Let’s start with AngularJS

To start coding with angular we need nothing else then download the **angular.js** file (stable branch, uncompressed) from [here](angularjs.org) and use a text editor like Notepad++, Vim or Sublime to name just a few.

  1. Create a new folder **HelloAngular**.
  2. Download the **angular.js** file.
  3. Copy the downloaded JavaScript file **angular.js** into the above folder.
  4. Using your favorite text editor create a new file **step1.html** in the same folder.
  5. Add the necessary html tags for a standard HTML5 web page  
    [<img style="border-top: 0px;border-right: 0px;border-bottom: 0px;padding-top: 0px;padding-left: 0px;margin: 0px 0px 24px;border-left: 0px;padding-right: 0px" border="0" alt="image" src="http://lostechies.com/content/gabrielschenker/uploads/2013/12/image_thumb.png" width="501" height="227" />](http://lostechies.com/content/gabrielschenker/uploads/2013/12/image.png)
  6. Add **angular.js** to the page by adding a <font face="Courier New"><script></font> tag at the end of the <font face="Courier New"><body><br /></font>[<img style="border-top: 0px;border-right: 0px;border-bottom: 0px;padding-top: 0px;padding-left: 0px;margin: 0px 0px 24px;border-left: 0px;padding-right: 0px" border="0" alt="image" src="http://lostechies.com/content/gabrielschenker/uploads/2013/12/image_thumb1.png" width="444" height="87" />](http://lostechies.com/content/gabrielschenker/uploads/2013/12/image1.png)  
    Note: It is considered best practice to include your JavaScript files not in the <font face="Courier New"><header></font> but rather at the end of the <font face="Courier New"><body></font>
  7. Load the web page with you favorite browser to make sure everything is ok.
  8. Add an input of type text to the body and use the first AngularJS directive, the attribute **ng-model**. As an attribute value we choose **model.firstName**.  
    [<img style="border-top: 0px;border-right: 0px;border-bottom: 0px;padding-top: 0px;padding-left: 0px;border-left: 0px;padding-right: 0px" border="0" alt="image" src="http://lostechies.com/content/gabrielschenker/uploads/2013/12/image_thumb2.png" width="549" height="41" />](http://lostechies.com/content/gabrielschenker/uploads/2013/12/image2.png)
  9. Add a <font face="Courier New"><div></font> after the above <font face="Courier New"><input></font> and use the so called mustache syntax to display the value of **model.firstName** inside the <font face="Courier New"><div><br /><a href="http://lostechies.com/content/gabrielschenker/uploads/2013/12/image3.png"><img style="border-top: 0px;border-right: 0px;border-bottom: 0px;padding-top: 0px;padding-left: 0px;border-left: 0px;padding-right: 0px" border="0" alt="image" src="http://lostechies.com/content/gabrielschenker/uploads/2013/12/image_thumb3.png" width="359" height="42" /></a><br /></font>
 10. Save the file and refresh the browser. Type something into the textbox. Note that where we defined the <font face="Courier New"><div></font> we see the mustache template <font face="Courier New">{{model.firstName}}</font> instead of the (expected) value of the model. The reason is that we did not yet bootstrap Angular and thus up to now Angular just sits there inactive on our page.  
    [<img style="border-top: 0px;border-right: 0px;border-bottom: 0px;padding-top: 0px;padding-left: 0px;border-left: 0px;padding-right: 0px" border="0" alt="image" src="http://lostechies.com/content/gabrielschenker/uploads/2013/12/image_thumb4.png" width="336" height="178" />](http://lostechies.com/content/gabrielschenker/uploads/2013/12/image4.png)
 11. Add the **ng-app** directive to the <font face="Courier New"><body></font> tag. When Angular sees this attribute on the page it starts to parse and compile the page upon loading.  
    [<img style="border-top: 0px;border-right: 0px;border-bottom: 0px;padding-top: 0px;padding-left: 0px;border-left: 0px;padding-right: 0px" border="0" alt="image" src="http://lostechies.com/content/gabrielschenker/uploads/2013/12/image_thumb5.png" width="178" height="44" />](http://lostechies.com/content/gabrielschenker/uploads/2013/12/image5.png)
 12. Save the page the refresh you browser. Type your name into the input box. Notice that the value now gets reproduced inside the <font face="Courier New"><div></font>.  
    [<img style="border-top: 0px;border-right: 0px;border-bottom: 0px;padding-top: 0px;padding-left: 0px;border-left: 0px;padding-right: 0px" border="0" alt="image" src="http://lostechies.com/content/gabrielschenker/uploads/2013/12/image_thumb6.png" width="264" height="122" />](http://lostechies.com/content/gabrielschenker/uploads/2013/12/image6.png)

# Summary

I have shown that it is extremely easy to start a new AngularJS based web application. We just need one single JavaScript file (angular.js) and a text editor. AngularJS is mostly used as a client side MVC (model view controller) framework. I have introduced the view (the html page) and a basic model (model.firstName) so far. AngularJS uses directives to provide data binding. We saw how to data bind an input box by using the **ng-model** directive and how to display model values by using the so called mustache syntax. Angular is bootstrapped by using the **ng-app** directive. We can only have one such directive per page. If AngularJS sees this directive on the page it parses the page and compiles it. It is during this stage where the directives are interpreted or executed and the data binding is established.

In my next post I will introduce controllers.
{% endraw %}
