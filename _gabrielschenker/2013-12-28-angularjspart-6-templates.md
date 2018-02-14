---
wordpress_id: 429
title: AngularJS–Part 6, Templates
date: 2013-12-28T16:32:57+00:00
author: Gabriel Schenker
layout: post
wordpress_guid: http://lostechies.com/gabrielschenker/?p=429
dsq_thread_id:
  - "2078822164"
categories:
  - AngularJS
  - How To
  - introduction
---
{% raw %}
# Introduction

This is a series of posts about [AngularJS](http://angularjs.org) and our experiences with it while migrating the client of a complex enterprise application from Silverlight to HTML5/CSS/JavaScript using AngularJS as a framework. Since the migration is a very ambitious undertaken I want to try to chop the overall problem space in much smaller pieces that can be swallowed and digested much more easily by any member of my team. So far I have published the following posts in this series 

  * [AngularJS – Part 1](http://lostechies.com/gabrielschenker/2013/12/05/angularjspart-1/) 
      * [AngularJS – Part 1, Feedback](http://lostechies.com/gabrielschenker/2013/12/07/angularjspart-1-feedback/) 
          * [AngularJS – Part 2, the controller](http://lostechies.com/gabrielschenker/2013/12/09/angularjspart-2-the-controller/) 
              * [AngularJS – Part 3, Inheritance](http://lostechies.com/gabrielschenker/2013/12/10/angularjspart-3-inheritance/) 
                  * [AngularJS – Part 4, Accessing server side resources](http://lostechies.com/gabrielschenker/2013/12/12/angularjspart-4-accessing-server-side-resources/) 
                      * [AngularJS- Part 5, Pushing data to the server](http://lostechies.com/gabrielschenker/2013/12/17/angularjspart-5-pushing-data-to-the-server/)</ul> 
                    In Angular when we talk of a template we really mean the view with the HTML enriched by the various Angular directives and the markup used for data binding (the expressions in double curly braces {{ }}). We can of course go a step further and not only regard a whole HTML document as a template but also any HTML fragment, often called partials. In this post whenever I’m talking about templates I refer to the latter.
                    
                    # A simple sample
                    
                    Whenever we want to display a list of things on a page we can use the **ng-repeat** directive to do so. Let’s assume we have a list of persons that we want to display. We first define a controller that provides a (pre-canned) list of persons on its $scope. Normally we would get this list of persons from the backend by using e.g. the $http service, but here we want to keep it simple and concentrate exclusively on the client side part. Now lets put this code in a file called **app.js**
                    
                    [<img style="border-left-width: 0px;border-right-width: 0px;border-bottom-width: 0px;padding-top: 0px;padding-left: 0px;padding-right: 0px;border-top-width: 0px" border="0" alt="image" src="http://lostechies.com/content/gabrielschenker/uploads/2013/12/image_thumb65.png" width="612" height="184" />](http://lostechies.com/content/gabrielschenker/uploads/2013/12/image67.png)
                    
                    To display the full name of every person in a simple list we can use this template
                    
                    [<img style="border-left-width: 0px;border-right-width: 0px;border-bottom-width: 0px;padding-top: 0px;padding-left: 0px;padding-right: 0px;border-top-width: 0px" border="0" alt="image" src="http://lostechies.com/content/gabrielschenker/uploads/2013/12/image_thumb66.png" width="610" height="188" />](http://lostechies.com/content/gabrielschenker/uploads/2013/12/image68.png)
                    
                    Just to repeat the important elements:
                    
                      * We need the **ng-app** directive somewhere in the HTML DOM to bootstrap Angular. Everything nested inside the element containing the **ng-app** directive is managed by Angular, everything outside is NOT. It is very important to remember this – everything that is defined outside the scope of the **ng-app** directive is ignored by Angular; in our case this would be the whole header of the HTML document. 
                          * We reference the JavaScript files that we need at the bottom of the body tag to allow the browser to render the DOM before it loads the JavaScript files. Loading those files is a blocking operation. Another important best practice is to always use the non-minified versions of the files during development otherwise debugging becomes a nightmare if not impossible. Of course we should not forget to reference the minified versions of our JavaScript files once we are ready to move our app into production. 
                              * We use the **ng-controller** directive to define the HTML fragment which shall be managed by our controller **PersonCtrl**. Again, here the controller manages everything nested inside the element containing the **ng-controller** directive. 
                                  * Whenever we want to display a list of some sort based on a collection of things defined on the $scope in our controller we can use the **ng-repeat** directive. The syntax of the expression in the **ng-repeat** directive is of type “thing in things” or in our case “person in persons”. The **ng-repeat** directive basically iterates over all items of the collection and for each item creates a copy of the HTML element on which it is defined. The respective item “becomes the scope” of each of the repeated elements. We can then use data binding to display values of each item in our view. In our sample the fragment  
                                    [<img style="border-left-width: 0px;border-right-width: 0px;border-bottom-width: 0px;padding-top: 0px;padding-left: 0px;margin: 0px 0px 24px;padding-right: 0px;border-top-width: 0px" border="0" alt="image" src="http://lostechies.com/content/gabrielschenker/uploads/2013/12/image_thumb67.png" width="586" height="79" />](http://lostechies.com/content/gabrielschenker/uploads/2013/12/image69.png)  
                                    is repeated 5 times</ul> 
                                The result of the above
                                
                                [<img style="border-left-width: 0px;border-right-width: 0px;border-bottom-width: 0px;padding-top: 0px;padding-left: 0px;padding-right: 0px;border-top-width: 0px" border="0" alt="image" src="http://lostechies.com/content/gabrielschenker/uploads/2013/12/image_thumb68.png" width="409" height="182" />](http://lostechies.com/content/gabrielschenker/uploads/2013/12/image70.png)
                                
                                # Static templates
                                
                                In a very simple application what we did so far is totally ok and sufficient. If we are looking at more realistic and complex samples we might want to separate structure and layout of the list. Instead of defining what should be output of a given person and how it should be displayed in place we might want to extract this part from the main view and place it somewhere else, maybe in its own file. But before we use separate files we can also just define templates (remember I use the word template as a synonym for HTML fragment) in a different area of the file. Angular gives us the option to define named templates in a special <font face="Courier New">script</font> tag. There are three important boundary conditions that must be fulfilled
                                
                                  * the <font face="Courier New">script</font> tag must be defined inside the scope of the **ng-app** directive otherwise it and its content is ignored by Angular. 
                                      * the <font face="Courier New">type</font> attribute of the <font face="Courier New">script</font> tag must be “text/ng-template” 
                                          * the <font face="Courier New">script</font> tag must contain an <font face="Courier New">id</font> attribute with a unique value.</ul> 
                                        To use the template defined within a <font face="Courier New">script</font> tag we add an **ng-include** directive to the parent element whose value is the ID of the template. Thus if the ID of the template is **person.html** then the directive must be
                                        
                                        [<img style="border-left-width: 0px;border-right-width: 0px;border-bottom-width: 0px;padding-top: 0px;padding-left: 0px;padding-right: 0px;border-top-width: 0px" border="0" alt="image" src="http://lostechies.com/content/gabrielschenker/uploads/2013/12/image_thumb69.png" width="302" height="38" />](http://lostechies.com/content/gabrielschenker/uploads/2013/12/image71.png)
                                        
                                        **Important:** Please not the single quotes around **person.html**. The value of the **ng-include** is an expression and to indicate to Angular that **person.html** is a string value we need to put those single quotes around it.
                                        
                                        That said, our view now looks like this
                                        
                                        [<img style="border-left-width: 0px;border-right-width: 0px;border-bottom-width: 0px;padding-top: 0px;padding-left: 0px;padding-right: 0px;border-top-width: 0px" border="0" alt="image" src="http://lostechies.com/content/gabrielschenker/uploads/2013/12/image_thumb70.png" width="805" height="295" />](http://lostechies.com/content/gabrielschenker/uploads/2013/12/image72.png)
                                        
                                        Structural HTML has been separated from specific layout parts. If you refresh the page in the browser after these changes the output should look exactly the same way as before. Although here in this very simple sample it is not really evident what the benefit should be, just believe me that the true beauty of&nbsp; this principle comes to shine in more complex situations.
                                        
                                        Note that all the templates that you define with the technique shown above are stored in the Angular template cache and they are available to you at any time via the [$templateCache](http://docs.angularjs.org/api/ng.$templateCache) service.
                                        
                                        If we have more and more different templates we want to use and the templates become more and more complex it makes sense to store them in their own individual files. Let’s just do that and extend our sample. On our view we output a second list of the same persons but this time we are using a template **person2.html** stored as a file in a subfolder called **templates**. The HTML we add to our main view (index.html) looks like this
                                        
                                        [<img style="border-left-width: 0px;border-right-width: 0px;border-bottom-width: 0px;padding-top: 0px;padding-left: 0px;padding-right: 0px;border-top-width: 0px" border="0" alt="image" src="http://lostechies.com/content/gabrielschenker/uploads/2013/12/image_thumb71.png" width="611" height="88" />](http://lostechies.com/content/gabrielschenker/uploads/2013/12/image73.png)
                                        
                                        And the content of the file **person2.html** might look like this (to not use the very same boring layout as in the above template)
                                        
                                        [<img style="border-left-width: 0px;border-right-width: 0px;border-bottom-width: 0px;padding-top: 0px;padding-left: 0px;margin: 0px 0px 24px;padding-right: 0px;border-top-width: 0px" border="0" alt="image" src="http://lostechies.com/content/gabrielschenker/uploads/2013/12/image_thumb72.png" width="607" height="77" />](http://lostechies.com/content/gabrielschenker/uploads/2013/12/image74.png)
                                        
                                        Note that I use a CSS class **person** which is defined as 
                                        
                                        [<img style="border-left-width: 0px;border-right-width: 0px;border-bottom-width: 0px;padding-top: 0px;padding-left: 0px;padding-right: 0px;border-top-width: 0px" border="0" alt="image" src="http://lostechies.com/content/gabrielschenker/uploads/2013/12/image_thumb73.png" width="330" height="156" />](http://lostechies.com/content/gabrielschenker/uploads/2013/12/image75.png)
                                        
                                        The above definition resides in a file **app.css** that I reference in the header of my index.html
                                        
                                        [<img style="border-left-width: 0px;border-right-width: 0px;border-bottom-width: 0px;padding-top: 0px;padding-left: 0px;padding-right: 0px;border-top-width: 0px" border="0" alt="image" src="http://lostechies.com/content/gabrielschenker/uploads/2013/12/image_thumb74.png" width="527" height="154" />](http://lostechies.com/content/gabrielschenker/uploads/2013/12/image76.png)
                                        
                                        Finally when refreshing the browser we get this result
                                        
                                        [<img style="border-left-width: 0px;border-right-width: 0px;border-bottom-width: 0px;padding-top: 0px;padding-left: 0px;padding-right: 0px;border-top-width: 0px" border="0" alt="image" src="http://lostechies.com/content/gabrielschenker/uploads/2013/12/image_thumb75.png" width="408" height="404" />](http://lostechies.com/content/gabrielschenker/uploads/2013/12/image77.png)
                                        
                                        The advantage is now that I can go and significantly change the layout of each person item in the list without having to touch the **index.html** view. Let’s just do this for fun and add an icon to each person which is depending on the gender of the person. To make things simple I just went quickly on Bing and searched for small male and female symbols and stored them as **M.jpeg** and **F.jpeg** respectively in the same folder as the **index.html**. Then we can change the template **person2.html** as follows
                                        
                                        [<img style="border-left-width: 0px;border-right-width: 0px;border-bottom-width: 0px;padding-top: 0px;padding-left: 0px;padding-right: 0px;border-top-width: 0px" border="0" alt="image" src="http://lostechies.com/content/gabrielschenker/uploads/2013/12/image_thumb76.png" width="613" height="94" />](http://lostechies.com/content/gabrielschenker/uploads/2013/12/image78.png)
                                        
                                        Please not the usage of the **[ng-src](http://docs.angularjs.org/api/ng.directive:ngSrc)** directive in the <font face="Courier New">img</font> tag. It allows me to use data binding. In my case I use the content of the gender property on our model to determine which image to use. For a nicer looking list I also fix the width of the image to 25 pixels. The result of which is
                                        
                                        [<img style="border-left-width: 0px;border-right-width: 0px;border-bottom-width: 0px;padding-top: 0px;padding-left: 0px;margin: 0px;padding-right: 0px;border-top-width: 0px" border="0" alt="image" src="http://lostechies.com/content/gabrielschenker/uploads/2013/12/image_thumb77.png" width="222" height="244" />](http://lostechies.com/content/gabrielschenker/uploads/2013/12/image79.png)
                                        
                                        # Dynamic templates
                                        
                                        What if we want to display a list of items where we need a different template for each of the items? How can we handle that? Let’s take the sample of a (simple) questionnaire to analyze this problem. A questionnaire is a document that has a series of questions where the user is required to fill in answers for each question. The type of question determine what kind of answer the user has to provide. Is it a plain text, a numeric, a date type or multiple choice answer? Certainly you can imagine many more types or categories of answers. We want to show the questionnaire as a list of questions and have each question display the answer part according to the type or category of question.
                                        
                                        Let’s start with the controller where we define on its $scope a simple pre-canned questionnaire.
                                        
                                        [<img style="border-left-width: 0px;border-right-width: 0px;border-bottom-width: 0px;padding-top: 0px;padding-left: 0px;padding-right: 0px;border-top-width: 0px" border="0" alt="image" src="http://lostechies.com/content/gabrielschenker/uploads/2013/12/image_thumb78.png" width="609" height="123" />](http://lostechies.com/content/gabrielschenker/uploads/2013/12/image80.png)
                                        
                                        Now let’s define the HTML that outputs the questionnaire as a series of <font face="Courier New">div</font> tags. For a first iteration we only want to print the question number, type and text.
                                        
                                        [<img style="border-left-width: 0px;border-right-width: 0px;border-bottom-width: 0px;padding-top: 0px;padding-left: 0px;padding-right: 0px;border-top-width: 0px" border="0" alt="image" src="http://lostechies.com/content/gabrielschenker/uploads/2013/12/image_thumb79.png" width="613" height="184" />](http://lostechies.com/content/gabrielschenker/uploads/2013/12/image81.png)
                                        
                                        The CSS is
                                        
                                        [<img style="border-left-width: 0px;border-right-width: 0px;border-bottom-width: 0px;padding-top: 0px;padding-left: 0px;padding-right: 0px;border-top-width: 0px" border="0" alt="image" src="http://lostechies.com/content/gabrielschenker/uploads/2013/12/image_thumb80.png" width="373" height="132" />](http://lostechies.com/content/gabrielschenker/uploads/2013/12/image82.png)
                                        
                                        Nothing spectacular so far, but at least we get the expected result.
                                        
                                        [<img style="border-left-width: 0px;border-right-width: 0px;border-bottom-width: 0px;padding-top: 0px;padding-left: 0px;padding-right: 0px;border-top-width: 0px" border="0" alt="image" src="http://lostechies.com/content/gabrielschenker/uploads/2013/12/image_thumb81.png" width="448" height="308" />](http://lostechies.com/content/gabrielschenker/uploads/2013/12/image83.png)
                                        
                                        Now comes the interesting part. To each of the questions we want to define an area where the user can answer the corresponding question and as we have noted above each question has a different kind of answer layout, depending on the type of question. Let’s realize this by defining a template per question type. We will create a file per template and will name the file like the type of the question, e.g. **number.html**, **text.html**, etc.
                                        
                                        text.html
                                        
                                        [<img style="border-left-width: 0px;border-right-width: 0px;border-bottom-width: 0px;padding-top: 0px;padding-left: 0px;padding-right: 0px;border-top-width: 0px" border="0" alt="image" src="http://lostechies.com/content/gabrielschenker/uploads/2013/12/image_thumb82.png" width="614" height="29" />](http://lostechies.com/content/gabrielschenker/uploads/2013/12/image84.png)
                                        
                                        number.html
                                        
                                        [<img style="border-left-width: 0px;border-right-width: 0px;border-bottom-width: 0px;padding-top: 0px;padding-left: 0px;margin: 0px 0px 24px;padding-right: 0px;border-top-width: 0px" border="0" alt="image" src="http://lostechies.com/content/gabrielschenker/uploads/2013/12/image_thumb83.png" width="615" height="28" />](http://lostechies.com/content/gabrielschenker/uploads/2013/12/image85.png)
                                        
                                        date.html
                                        
                                        [<img style="border-left-width: 0px;border-right-width: 0px;border-bottom-width: 0px;padding-top: 0px;padding-left: 0px;padding-right: 0px;border-top-width: 0px" border="0" alt="image" src="http://lostechies.com/content/gabrielschenker/uploads/2013/12/image_thumb84.png" width="393" height="36" />](http://lostechies.com/content/gabrielschenker/uploads/2013/12/image86.png)
                                        
                                        singleOption.html
                                        
                                        [<img style="border-left-width: 0px;border-right-width: 0px;border-bottom-width: 0px;padding-top: 0px;padding-left: 0px;padding-right: 0px;border-top-width: 0px" border="0" alt="image" src="http://lostechies.com/content/gabrielschenker/uploads/2013/12/image_thumb85.png" width="320" height="88" />](http://lostechies.com/content/gabrielschenker/uploads/2013/12/image87.png)
                                        
                                        multiOption.html
                                        
                                        [<img style="border-left-width: 0px;border-right-width: 0px;border-bottom-width: 0px;padding-top: 0px;padding-left: 0px;padding-right: 0px;border-top-width: 0px" border="0" alt="image" src="http://lostechies.com/content/gabrielschenker/uploads/2013/12/image_thumb86.png" width="404" height="104" />](http://lostechies.com/content/gabrielschenker/uploads/2013/12/image88.png)
                                        
                                        And we need to modify the main template slightly too
                                        
                                        [<img style="border-left-width: 0px;border-right-width: 0px;border-bottom-width: 0px;padding-top: 0px;padding-left: 0px;padding-right: 0px;border-top-width: 0px" border="0" alt="image" src="http://lostechies.com/content/gabrielschenker/uploads/2013/12/image_thumb87.png" width="612" height="161" />](http://lostechies.com/content/gabrielschenker/uploads/2013/12/image89.png)
                                        
                                        Note specifically how we leverage the fact that the **ng-include** value is interpreted as expression by Angular and as such we can combine data binding (question.type) and string concatenation to generate the URL to the template to load.
                                        
                                        The CSS class **answer** is defined as follows
                                        
                                        [<img style="border-left-width: 0px;border-right-width: 0px;border-bottom-width: 0px;padding-top: 0px;padding-left: 0px;padding-right: 0px;border-top-width: 0px" border="0" alt="image" src="http://lostechies.com/content/gabrielschenker/uploads/2013/12/image_thumb88.png" width="561" height="139" />](http://lostechies.com/content/gabrielschenker/uploads/2013/12/image90.png)
                                        
                                        Once we have defined all these templates the output in the browser is as follows
                                        
                                        [<img style="border-left-width: 0px;border-right-width: 0px;border-bottom-width: 0px;padding-top: 0px;padding-left: 0px;padding-right: 0px;border-top-width: 0px" border="0" alt="image" src="http://lostechies.com/content/gabrielschenker/uploads/2013/12/image_thumb89.png" width="497" height="488" />](http://lostechies.com/content/gabrielschenker/uploads/2013/12/image91.png)
                                        
                                        As expected each question has its own individual answer layout.
                                        
                                        In a real application each template would probably have its own controller containing the workflow logic for the appropriate question; but this lies outside of the scope of this post which is already pretty long.
                                        
                                        # Recursive templates
                                        
                                        Sometimes we want to display templates that in turn reference other templates which again might reference more templates. These are called recursive templates. A very good sample for this is a tree where a root node has children which in turn are nodes and have children and so on. How would we display such a tree? If we hardcode such a tree in HTML it could look like this
                                        
                                        [<img style="border-left-width: 0px;border-right-width: 0px;border-bottom-width: 0px;padding-top: 0px;padding-left: 0px;padding-right: 0px;border-top-width: 0px" border="0" alt="image" src="http://lostechies.com/content/gabrielschenker/uploads/2013/12/image_thumb90.png" width="530" height="515" />](http://lostechies.com/content/gabrielschenker/uploads/2013/12/image92.png)
                                        
                                        That is, just a series of nested unordered list which in the browser are displayed like this
                                        
                                        [<img style="border-left-width: 0px;border-right-width: 0px;border-bottom-width: 0px;padding-top: 0px;padding-left: 0px;padding-right: 0px;border-top-width: 0px" border="0" alt="image" src="http://lostechies.com/content/gabrielschenker/uploads/2013/12/image_thumb91.png" width="254" height="253" />](http://lostechies.com/content/gabrielschenker/uploads/2013/12/image93.png)
                                        
                                        It is evident that this does not work for any arbitrary tree structure e.g. loaded from a backend server. Luckily Angular provides us with the possibility to define recursive templates. Let’s just start and see how to do that. First we define a new **TreeCtrl** controller having a pre-canned tree structure defined on its $scope.
                                        
                                        [<img style="border-left-width: 0px;border-right-width: 0px;border-bottom-width: 0px;padding-top: 0px;padding-left: 0px;padding-right: 0px;border-top-width: 0px" border="0" alt="image" src="http://lostechies.com/content/gabrielschenker/uploads/2013/12/image_thumb96.png" width="564" height="670" />](http://lostechies.com/content/gabrielschenker/uploads/2013/12/image98.png)
                                        
                                        Let’s now do a first implementation of the view. We add the following HTML snippet to the index.html
                                        
                                        [<img style="border-left-width: 0px;border-right-width: 0px;border-bottom-width: 0px;padding-top: 0px;padding-left: 0px;padding-right: 0px;border-top-width: 0px" border="0" alt="image" src="http://lostechies.com/content/gabrielschenker/uploads/2013/12/image_thumb92.png" width="439" height="205" />](http://lostechies.com/content/gabrielschenker/uploads/2013/12/image94.png)
                                        
                                        This of course will only show us the list of parents since we have not yet defined any recursion. To do that we need to use templates. We will define the template directly inside the index.html by using the special script tag
                                        
                                        [<img style="border-left-width: 0px;border-right-width: 0px;border-bottom-width: 0px;padding-top: 0px;padding-left: 0px;padding-right: 0px;border-top-width: 0px" border="0" alt="image" src="http://lostechies.com/content/gabrielschenker/uploads/2013/12/image_thumb93.png" width="611" height="219" />](http://lostechies.com/content/gabrielschenker/uploads/2013/12/image95.png)
                                        
                                        After this modification the result is still the same but now we can start to extend our new node template and add recursion to it. We do not only want to display the name of the current node but also a nested list of all children of the current node. Nothing easier than that
                                        
                                        [<img style="border-left-width: 0px;border-right-width: 0px;border-bottom-width: 0px;padding-top: 0px;padding-left: 0px;margin: 0px 0px 24px;padding-right: 0px;border-top-width: 0px" border="0" alt="image" src="http://lostechies.com/content/gabrielschenker/uploads/2013/12/image_thumb94.png" width="611" height="131" />](http://lostechies.com/content/gabrielschenker/uploads/2013/12/image96.png)
                                        
                                        Note how in the nested list the **ng-repeat** directive is used to iterate over all children of the current node and how the **ng-include** directive is used to self reference the template. And the output is as expected
                                        
                                        [<img style="border-left-width: 0px;border-right-width: 0px;border-bottom-width: 0px;padding-top: 0px;padding-left: 0px;padding-right: 0px;border-top-width: 0px" border="0" alt="image" src="http://lostechies.com/content/gabrielschenker/uploads/2013/12/image_thumb95.png" width="226" height="291" />](http://lostechies.com/content/gabrielschenker/uploads/2013/12/image97.png)
                                        
                                        # Conclusions
                                        
                                        Templates come in very handy whenever we want to separate pure structural or semantic layout from more specific layout of certain UI fragments. In this regard using templates helps us in adhering to the [single responsibility principle](http://lostechies.com/gabrielschenker/2009/01/21/real-swiss-don-t-need-srp-do-they/).
                                        
                                        In this post I have discussed in detail three categories of templates &#8211; static, recursive and dynamic templates. We make heavy use of each category in our complex enterprise solution. In this post I have only scratched on the surface on what is possible when using templates as supported by Angular. 
                                        
                                        The code to this series can be found on [GitHub](https://github.com/gnschenker/HelloAngular).
{% endraw %}
