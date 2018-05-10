---
wordpress_id: 685
title: AngularJS–Part 12, Multi language support
date: 2014-02-11T11:44:56+00:00
author: Gabriel Schenker
layout: post
wordpress_guid: http://lostechies.com/gabrielschenker/?p=685
dsq_thread_id:
  - "2252566337"
categories:
  - AngularJS
  - introduction
---
# Introduction

Our application is a product used by many global companies and thus we support multiple languages like English, French, Spanish, German and more. The question is now, how does AngularJS help us to provide our product in all the necessary languages? It turns out that Angular itself does only have [limited support](http://docs.angularjs.org/guide/i18n) for globalization and localization (also called [internationalization and localization](http://en.wikipedia.org/wiki/Internationalization_and_localization)). But a quick research on the web quickly leads to the following three implementations helping with translating texts into different languages depending on the [locale](http://en.wikipedia.org/wiki/Locale) of the user. Here are the links

  * <http://angular-gettext.rocketeer.be/> 
      * <https://pascalprecht.github.io/angular-translate/> 
          * <http://www.novanet.no/blog/hallstein-brotan/dates/2013/10/creating-multilingual-support-using-angularjs/></ul> 
        I am sure there exist other implementations out there but for our purposes the first approach which is based on the [Gettext](http://en.wikipedia.org/wiki/Gettext) format is the favorite one due to the fact that we do not have to use keywords as placeholders for texts but can just use plain English texts in code, and the rich ecosystem around it. Specifically of interest is the [Potedit](http://www.poedit.net/) application which provides a very user friendly way of translating texts.
        
        # Preparing the system
        
        Since this time we need a couple of more libraries than just AngularJS we will use [Bower](http://bower.io/) to install all our dependencies. Bower is a package management system for the client similar to the nodeJS package manager [npm](https://npmjs.org/) which is used to manage server side packages. If you do not have node installed then please do it now from [here](http://nodejs.org/).
        
        Open a command prompt as Administrator or a bash console and enter the following command
        
        [<img style="border-left-width: 0px;border-right-width: 0px;border-bottom-width: 0px;padding-top: 0px;padding-left: 0px;margin: 0px 0px 24px;padding-right: 0px;border-top-width: 0px" border="0" alt="image" src="http://lostechies.com/content/gabrielschenker/uploads/2014/02/image_thumb19.png" width="277" height="36" />](http://lostechies.com/content/gabrielschenker/uploads/2014/02/image19.png)
        
        This will install Bower globally such as that it is available in any directory of the system. Now we create a new folder for our sample app. In my case I will call it **c:\samples\translation**. In your console navigate to this directory. 
        
        To install Angular locally in the current directory enter
        
        [<img style="border-left-width: 0px;border-right-width: 0px;border-bottom-width: 0px;padding-top: 0px;padding-left: 0px;padding-right: 0px;border-top-width: 0px" border="0" alt="image" src="http://lostechies.com/content/gabrielschenker/uploads/2014/02/image_thumb20.png" width="274" height="35" />](http://lostechies.com/content/gabrielschenker/uploads/2014/02/image20.png)
        
        To install Bootstrap (which we use for our layout) locally enter
        
        [<img style="border-left-width: 0px;border-right-width: 0px;border-bottom-width: 0px;padding-top: 0px;padding-left: 0px;padding-right: 0px;border-top-width: 0px" border="0" alt="image" src="http://lostechies.com/content/gabrielschenker/uploads/2014/02/image_thumb21.png" width="292" height="33" />](http://lostechies.com/content/gabrielschenker/uploads/2014/02/image21.png)
        
        Finally we want to install the [angular-gettext](http://angular-gettext.rocketeer.be/) module, thus enter
        
        [<img style="border-left-width: 0px;border-right-width: 0px;border-bottom-width: 0px;padding-top: 0px;padding-left: 0px;padding-right: 0px;border-top-width: 0px" border="0" alt="image" src="http://lostechies.com/content/gabrielschenker/uploads/2014/02/image_thumb22.png" width="359" height="37" />](http://lostechies.com/content/gabrielschenker/uploads/2014/02/image22.png)
        
        Bower has created a sub folder **bower_components** in our current directory and placed the downloaded components into it. The folder structure should look like this
        
        [<img style="border-left-width: 0px;border-right-width: 0px;border-bottom-width: 0px;padding-top: 0px;padding-left: 0px;padding-right: 0px;border-top-width: 0px" border="0" alt="image" src="http://lostechies.com/content/gabrielschenker/uploads/2014/02/image_thumb23.png" width="167" height="137" />](http://lostechies.com/content/gabrielschenker/uploads/2014/02/image23.png)
        
        As we can see Bower has created four folders, one for angular, one for bootstrap, one for angular-gettext and one for the implicitly downloaded jQuery (bootstrap depends on jQuery). Now we need one more install. We need to install [Grunt](http://gruntjs.com/) which is a JavaScript task runner. We need Grunt to help us automate the extraction of texts to translate from the source code. We will install Grunt globally such as that it is available for all projects on our system. Still in the console enter the following command
        
        [<img style="border-left-width: 0px;border-right-width: 0px;border-bottom-width: 0px;padding-top: 0px;padding-left: 0px;padding-right: 0px;border-top-width: 0px" border="0" alt="image" src="http://lostechies.com/content/gabrielschenker/uploads/2014/02/image_thumb24.png" width="323" height="35" />](http://lostechies.com/content/gabrielschenker/uploads/2014/02/image24.png)
        
        This uses **npm** to install the Grunt command line interface. Now we install Grunt locally with this command
        
        [<img style="border-left-width: 0px;border-right-width: 0px;border-bottom-width: 0px;padding-top: 0px;padding-left: 0px;padding-right: 0px;border-top-width: 0px" border="0" alt="image" src="http://lostechies.com/content/gabrielschenker/uploads/2014/02/image_thumb25.png" width="231" height="32" />](http://lostechies.com/content/gabrielschenker/uploads/2014/02/image25.png)
        
        and then we also need the node module containing the Grunt tasks for text extraction and compilation
        
        [<img style="border-left-width: 0px;border-right-width: 0px;border-bottom-width: 0px;padding-top: 0px;padding-left: 0px;padding-right: 0px;border-top-width: 0px" border="0" alt="image" src="http://lostechies.com/content/gabrielschenker/uploads/2014/02/image_thumb26.png" width="406" height="33" />](http://lostechies.com/content/gabrielschenker/uploads/2014/02/image26.png)
        
        # Sample application
        
        Finally after all this setup we can start to implement a sample application which shows the various aspects affected by globalization and localization. Using your favorite code editor (in my case Sublime Text 3) create a new file **app.js** which will contain the JavaScript code. Create a new Angular module and define a controller **TestCtrl** as follows
        
        [<img style="border-left-width: 0px;border-right-width: 0px;border-bottom-width: 0px;padding-top: 0px;padding-left: 0px;padding-right: 0px;border-top-width: 0px" border="0" alt="image" src="http://lostechies.com/content/gabrielschenker/uploads/2014/02/image_thumb27.png" width="448" height="85" />](http://lostechies.com/content/gabrielschenker/uploads/2014/02/image27.png)
        
        Now add another file **index.html** which will contain the template for our sample application. Add the base HTML to make it an Angular application
        
        [<img style="border-left-width: 0px;border-right-width: 0px;border-bottom-width: 0px;padding-top: 0px;padding-left: 0px;padding-right: 0px;border-top-width: 0px" border="0" alt="image" src="http://lostechies.com/content/gabrielschenker/uploads/2014/02/image_thumb28.png" width="813" height="316" />](http://lostechies.com/content/gabrielschenker/uploads/2014/02/image28.png)
        
        Note how on line 5 we have added a link to the **bootstrap** CSS file and on line 12 through 14 we have included the **angular**, **angular-gettext** and our own **app** JavaScript file.
        
        Now lets add some simple texts that later on we want to have translated into the language of the user. Add this code snippet to the div of the template
        
        [<img style="border-left-width: 0px;border-right-width: 0px;border-bottom-width: 0px;padding-top: 0px;padding-left: 0px;padding-right: 0px;border-top-width: 0px" border="0" alt="image" src="http://lostechies.com/content/gabrielschenker/uploads/2014/02/image_thumb29.png" width="538" height="86" />](http://lostechies.com/content/gabrielschenker/uploads/2014/02/image29.png)
        
        Now open index.html in your favorite browser. The result is very unspectacular yet expected. We will just see two paragraphs with the texts as entered above.
        
        To enable translation support we have to add the directive **translate** to the two paragraph tags.
        
        [<img style="border-left-width: 0px;border-right-width: 0px;border-bottom-width: 0px;padding-top: 0px;padding-left: 0px;padding-right: 0px;border-top-width: 0px" border="0" alt="image" src="http://lostechies.com/content/gabrielschenker/uploads/2014/02/image_thumb30.png" width="631" height="87" />](http://lostechies.com/content/gabrielschenker/uploads/2014/02/image30.png)
        
        If we refresh the browser nothing changes at all. This is clear since we did not yet initialize **angular-gettext**. Lets do this now. We use the [run](http://docs.angularjs.org/guide/module) function of the Angular module to do so
        
        [<img style="border-left-width: 0px;border-right-width: 0px;border-bottom-width: 0px;padding-top: 0px;padding-left: 0px;padding-right: 0px;border-top-width: 0px" border="0" alt="image" src="http://lostechies.com/content/gabrielschenker/uploads/2014/02/image_thumb31.png" width="433" height="88" />](http://lostechies.com/content/gabrielschenker/uploads/2014/02/image31.png)
        
        On line 3 we ask the Angular injector service to provide us the **gettextCatalog** service defined in the **angular-gettext** library. Then on line 4 we use this service and declare that we want to use the language German (code ‘de’) as the current language. On line 5 we declare that we want the service to help us to easily spot missing translations by marking the (original) text with a [Missing] prefix. After adding this code snippet save and refresh the browser. Nothing changed so far and the text is still in English as we have added it in code.
        
        # Extracting and translating
        
        Now we need to extract all texts that need a translation from our source code. If we have a lot of texts that would be a nightmare if we did have to do it by hand. But don’t worry, we can easily automate this daunting task. We will use **Grunt** for this. Still within your favorite text editor create a new file called **Gruntfile.js** in the sample folder. This file will contain the instructions for the Grunt task runner (for an introduction on how to write a Grunt file see [this tutorial](http://gruntjs.com/getting-started)).&nbsp; The base structure of a simple Grunt file always looks like this
        
        [<img style="border-left-width: 0px;border-right-width: 0px;border-bottom-width: 0px;padding-top: 0px;padding-left: 0px;padding-right: 0px;border-top-width: 0px" border="0" alt="image" src="http://lostechies.com/content/gabrielschenker/uploads/2014/02/image_thumb32.png" width="362" height="69" />](http://lostechies.com/content/gabrielschenker/uploads/2014/02/image32.png)
        
        That is, we export a function containing the various tasks that Grunt can execute. Inside the above function we first need to load the Grunt tasks provided by the node module **grunt-angular-gettext**
        
        [<img style="border-left-width: 0px;border-right-width: 0px;border-bottom-width: 0px;padding-top: 0px;padding-left: 0px;padding-right: 0px;border-top-width: 0px" border="0" alt="image" src="http://lostechies.com/content/gabrielschenker/uploads/2014/02/image_thumb33.png" width="487" height="57" />](http://lostechies.com/content/gabrielschenker/uploads/2014/02/image33.png)
        
        Now we want to use the first task provided by **grunt-angular-gettext** module and configure it. This task will parse all our source files and extract the texts we want to have translated – the ones that have an associated **translate** directive – and add them to a so called **pot** file. We do this by adding the following snippet to the **Gruntfile.js**
        
        [<img style="border-left-width: 0px;border-right-width: 0px;border-bottom-width: 0px;padding-top: 0px;padding-left: 0px;padding-right: 0px;border-top-width: 0px" border="0" alt="image" src="http://lostechies.com/content/gabrielschenker/uploads/2014/02/image_thumb34.png" width="522" height="182" />](http://lostechies.com/content/gabrielschenker/uploads/2014/02/image34.png)
        
        On line 5 we define the task name we want to configure or initialize. On line 8 we declare that we want the task to parse all html files in the current directory or any sub directory of it and output the result of the task into a file called **template.pot** residing in the sub folder **po** of the current directory.
        
        Once we have saved the Grunt file we can issue the following command in the console
        
        [<img style="border-left-width: 0px;border-right-width: 0px;border-bottom-width: 0px;padding-top: 0px;padding-left: 0px;margin: 0px 0px 24px;padding-right: 0px;border-top-width: 0px" border="0" alt="image" src="http://lostechies.com/content/gabrielschenker/uploads/2014/02/image_thumb35.png" width="294" height="36" />](http://lostechies.com/content/gabrielschenker/uploads/2014/02/image35.png)
        
        If we have done everything right then we should see the following output
        
        [<img style="border-top: 0px;border-right: 0px;border-bottom: 0px;padding-top: 0px;padding-left: 0px;margin: 0px 0px 24px;border-left: 0px;padding-right: 0px" border="0" alt="image" src="http://lostechies.com/content/gabrielschenker/uploads/2014/02/image_thumb36.png" width="612" height="76" />](http://lostechies.com/content/gabrielschenker/uploads/2014/02/image36.png)
        
        and we will have a new subfolder **po** containing a file **template.pot**. We can open this file in our text editor and it should look like this
        
        [<img style="border-left-width: 0px;border-right-width: 0px;border-bottom-width: 0px;padding-top: 0px;padding-left: 0px;padding-right: 0px;border-top-width: 0px" border="0" alt="image" src="http://lostechies.com/content/gabrielschenker/uploads/2014/02/image_thumb37.png" width="562" height="248" />](http://lostechies.com/content/gabrielschenker/uploads/2014/02/image37.png)
        
        We can see on line 7 and 11 that the two texts to translate have been correctly identified and extracted. This file will be used as input by one of the many editors available that are able to handle the **gettext** format. In this sample we will use the (free) **Poedit** application. Please head to [this site](http://www.poedit.net/download.php) and download and install the application on your system.
        
        Run **Poedit** and create a new catalog from pot file. Select the **template.pot** file just created when asked for it. Select the language – **German** in our case. And then translate the texts
        
        [<img style="border-left-width: 0px;border-right-width: 0px;border-bottom-width: 0px;padding-top: 0px;padding-left: 0px;padding-right: 0px;border-top-width: 0px" border="0" alt="image" src="http://lostechies.com/content/gabrielschenker/uploads/2014/02/image_thumb38.png" width="612" height="478" />](http://lostechies.com/content/gabrielschenker/uploads/2014/02/image38.png)
        
        Hit **Save** when done. Save the result as suggested with the name **de.po** in the **po** subdirectory of our working folder. We can then once again (just for curiosity) open the saved file with our text editor just to see this
        
        [<img style="border-left-width: 0px;border-right-width: 0px;border-bottom-width: 0px;padding-top: 0px;padding-left: 0px;padding-right: 0px;border-top-width: 0px" border="0" alt="image" src="http://lostechies.com/content/gabrielschenker/uploads/2014/02/image_thumb39.png" width="610" height="393" />](http://lostechies.com/content/gabrielschenker/uploads/2014/02/image39.png)
        
        Now this although human readable is not the format we need in our Angular application. But no worries, we have another task provided by the **grunt-angular-gettext** module called **nggettext_compile** which will compile the output of the **Poedit** application into a format that we can consume in our Angular application. Let’s configure this task in the Grunt file. Add the following snippet right after the first task configuration and save the file.
        
        [<img style="border-left-width: 0px;border-right-width: 0px;border-bottom-width: 0px;padding-top: 0px;padding-left: 0px;padding-right: 0px;border-top-width: 0px" border="0" alt="image" src="http://lostechies.com/content/gabrielschenker/uploads/2014/02/image_thumb40.png" width="516" height="146" />](http://lostechies.com/content/gabrielschenker/uploads/2014/02/image40.png)
        
        On line 12 we define the task we want to configure and on line 15 we declare that we want this task to load all **po** files in the subfolder **po** of the current directory and compile them into a resulting file **translations.js** located in the current directory.
        
        In the console run this command
        
        [<img style="border-left-width: 0px;border-right-width: 0px;border-bottom-width: 0px;padding-top: 0px;padding-left: 0px;padding-right: 0px;border-top-width: 0px" border="0" alt="image" src="http://lostechies.com/content/gabrielschenker/uploads/2014/02/image_thumb41.png" width="294" height="31" />](http://lostechies.com/content/gabrielschenker/uploads/2014/02/image41.png)
        
        Again, if we did everything correctly the console output should show this
        
        [<img style="border-left-width: 0px;border-right-width: 0px;border-bottom-width: 0px;padding-top: 0px;padding-left: 0px;margin: 0px 0px 24px;padding-right: 0px;border-top-width: 0px" border="0" alt="image" src="http://lostechies.com/content/gabrielschenker/uploads/2014/02/image_thumb42.png" width="611" height="75" />](http://lostechies.com/content/gabrielschenker/uploads/2014/02/image42.png)
        
        Opening the **translations.js** file in our text editor we get a (halfway minified) version of a new Angular module called **gettext** which contains the configuration of the **gettextCatalog** service with the various translations provided (in our case its only German so far).
        
        [<img style="border-left-width: 0px;border-right-width: 0px;border-bottom-width: 0px;padding-top: 0px;padding-left: 0px;padding-right: 0px;border-top-width: 0px" border="0" alt="image" src="http://lostechies.com/content/gabrielschenker/uploads/2014/02/image_thumb43.png" width="868" height="99" />](http://lostechies.com/content/gabrielschenker/uploads/2014/02/image43.png)
        
        Back in our **index.html** we have to include the above file.
        
        [<img style="border-left-width: 0px;border-right-width: 0px;border-bottom-width: 0px;padding-top: 0px;padding-left: 0px;padding-right: 0px;border-top-width: 0px" border="0" alt="image" src="http://lostechies.com/content/gabrielschenker/uploads/2014/02/image_thumb44.png" width="455" height="69" />](http://lostechies.com/content/gabrielschenker/uploads/2014/02/image44.png)
        
        And as a last step in the **app.js** file we have to declare that our **app** module depends on the **gettext** module.
        
        [<img style="border-left-width: 0px;border-right-width: 0px;border-bottom-width: 0px;padding-top: 0px;padding-left: 0px;padding-right: 0px;border-top-width: 0px" border="0" alt="image" src="http://lostechies.com/content/gabrielschenker/uploads/2014/02/image_thumb45.png" width="456" height="37" />](http://lostechies.com/content/gabrielschenker/uploads/2014/02/image45.png)
        
        Go back to your browser and refresh the page. Hurray our text has been translated!
        
        [<img style="border-left-width: 0px;border-right-width: 0px;border-bottom-width: 0px;padding-top: 0px;padding-left: 0px;padding-right: 0px;border-top-width: 0px" border="0" alt="image" src="http://lostechies.com/content/gabrielschenker/uploads/2014/02/image_thumb46.png" width="394" height="75" />](http://lostechies.com/content/gabrielschenker/uploads/2014/02/image46.png)
        
        Let’s now see how the translation plugin handles missing translations. Add another paragraph to the template
        
        [<img style="border-left-width: 0px;border-right-width: 0px;border-bottom-width: 0px;padding-top: 0px;padding-left: 0px;padding-right: 0px;border-top-width: 0px" border="0" alt="image" src="http://lostechies.com/content/gabrielschenker/uploads/2014/02/image_thumb47.png" width="485" height="33" />](http://lostechies.com/content/gabrielschenker/uploads/2014/02/image47.png)
        
        After saving refresh the browser and you should see this
        
        [<img style="border-left-width: 0px;border-right-width: 0px;border-bottom-width: 0px;padding-top: 0px;padding-left: 0px;padding-right: 0px;border-top-width: 0px" border="0" alt="image" src="http://lostechies.com/content/gabrielschenker/uploads/2014/02/image_thumb48.png" width="389" height="101" />](http://lostechies.com/content/gabrielschenker/uploads/2014/02/image48.png)
        
        The application gives us a hint by prefixing the text whose translation could not be found with [MISSING]. This is very helpful, QA can easily spot missing translations. We can even write an end-to-end test (by using [protractor](https://github.com/angular/protractor)) to find missing translations.
        
        # More advanced scenarios
        
        What about scenarios where we have dynamic values in the text whose value is only known at runtime through data binding? Something like this
        
        [<img style="border-left-width: 0px;border-right-width: 0px;border-bottom-width: 0px;padding-top: 0px;padding-left: 0px;padding-right: 0px;border-top-width: 0px" border="0" alt="image" src="http://lostechies.com/content/gabrielschenker/uploads/2014/02/image_thumb49.png" width="683" height="32" />](http://lostechies.com/content/gabrielschenker/uploads/2014/02/image49.png)
        
        will translate just fine.
        
        Now what about situations where the usage of the **translate** directive is not evident like the value of the **placeholder** attribute of a textbox (an input of type text). Can we also have this value translated? It turns out that this can indeed be achieved by using Angular [expressions](http://docs.angularjs.org/guide/expression) and [filters](http://docs.angularjs.org/guide/filter). Let’s assume that we have a login dialog where we display an input box for the username and password. For both we want to display a placeholder text if they are empty. Here’s how we do it
        
        [<img style="border-top: 0px;border-right: 0px;border-bottom: 0px;padding-top: 0px;padding-left: 0px;border-left: 0px;padding-right: 0px" border="0" alt="image" src="http://lostechies.com/content/gabrielschenker/uploads/2014/02/image_thumb50.png" width="613" height="104" />](http://lostechies.com/content/gabrielschenker/uploads/2014/02/image50.png)
        
        Please note how the expression is written using inner (single) quotes to delimit the text to be translated and outer (double) quotes do delimit the value of the placeholder attribute which is an expression.
        
        [<img style="border-top: 0px;border-right: 0px;border-bottom: 0px;padding-top: 0px;padding-left: 0px;border-left: 0px;padding-right: 0px" border="0" alt="image" src="http://lostechies.com/content/gabrielschenker/uploads/2014/02/image_thumb51.png" width="342" height="29" />](http://lostechies.com/content/gabrielschenker/uploads/2014/02/image51.png)
        
        In the above case the filter **translate** is applied to the text **Enter your username**.
        
        ## Pluralization
        
        An important case is the situation where we want to correctly translate the singular and plural form of a text. Take the sample
        
          * John gets assigned **one task** [singular] – e.g. in German **einen Auftrag**
          * John gets assigned **3 tasks** [plural] – in German **3 Aufträge**
        
        Our translation library also handles this situation. We can write
        
        [<img style="border-top: 0px;border-right: 0px;border-bottom: 0px;padding-top: 0px;padding-left: 0px;border-left: 0px;padding-right: 0px" border="0" alt="image" src="http://lostechies.com/content/gabrielschenker/uploads/2014/02/image_thumb52.png" width="566" height="104" />](http://lostechies.com/content/gabrielschenker/uploads/2014/02/image52.png)
        
        We directly write the singular (one task) in the <font face="Courier New"><span></font> and use the two directives **translate-n** and **translate-plural** to define which is the counter/number and which is the plural form when using the counter/number.
        
        Now we use the **nggettext_extract** grunt task again to extract all new texts
        
        [<img style="border-top: 0px;border-right: 0px;border-bottom: 0px;padding-top: 0px;padding-left: 0px;margin: 0px;border-left: 0px;padding-right: 0px" border="0" alt="image" src="http://lostechies.com/content/gabrielschenker/uploads/2014/02/image_thumb53.png" width="294" height="36" />](http://lostechies.com/content/gabrielschenker/uploads/2014/02/image53.png)
        
        we can use **Poedit** to translate the new values. In **Poedit** open your existing catalog (**de.po** in my case) and then click the menu **Catalog –> Update from pot file** and select the **template.pot** file generated by the previous grunt task. You should see this
        
        [<img style="border-top: 0px;border-right: 0px;border-bottom: 0px;padding-top: 0px;padding-left: 0px;border-left: 0px;padding-right: 0px" border="0" alt="image" src="http://lostechies.com/content/gabrielschenker/uploads/2014/02/image_thumb54.png" width="612" height="175" />](http://lostechies.com/content/gabrielschenker/uploads/2014/02/image54.png)
        
        The new not yet translated texts are in bold. Translate the values as follows
        
        [<img style="border-top: 0px;border-right: 0px;border-bottom: 0px;padding-top: 0px;padding-left: 0px;border-left: 0px;padding-right: 0px" border="0" alt="image" src="http://lostechies.com/content/gabrielschenker/uploads/2014/02/image_thumb55.png" width="611" height="297" />](http://lostechies.com/content/gabrielschenker/uploads/2014/02/image55.png)
        
        After saving we need to update our controller as follows
        
        [<img style="border-top: 0px;border-right: 0px;border-bottom: 0px;padding-top: 0px;padding-left: 0px;border-left: 0px;padding-right: 0px" border="0" alt="image" src="http://lostechies.com/content/gabrielschenker/uploads/2014/02/image_thumb56.png" width="464" height="107" />](http://lostechies.com/content/gabrielschenker/uploads/2014/02/image56.png)
        
        and now you can display the page in the browser
        
        [<img style="border-top: 0px;border-right: 0px;border-bottom: 0px;padding-top: 0px;padding-left: 0px;border-left: 0px;padding-right: 0px" border="0" alt="image" src="http://lostechies.com/content/gabrielschenker/uploads/2014/02/image_thumb57.png" width="423" height="217" />](http://lostechies.com/content/gabrielschenker/uploads/2014/02/image57.png)&nbsp;
        
        If we now change the model value **count** to say 5 we get this
        
        [<img style="border-top: 0px;border-right: 0px;border-bottom: 0px;padding-top: 0px;padding-left: 0px;border-left: 0px;padding-right: 0px" border="0" alt="image" src="http://lostechies.com/content/gabrielschenker/uploads/2014/02/image_thumb58.png" width="337" height="104" />](http://lostechies.com/content/gabrielschenker/uploads/2014/02/image58.png)
        
        # Changing the language on the fly
        
        Can we change the language during run-time? Yes we can and it is very easy. Let’s first create another translation, say French using Poedit.
        
        Add an array **languages** and a variable **lang** to the controller as follows
        
        [<img style="border-top: 0px;border-right: 0px;border-bottom: 0px;padding-top: 0px;padding-left: 0px;border-left: 0px;padding-right: 0px" border="0" alt="image" src="http://lostechies.com/content/gabrielschenker/uploads/2014/02/image_thumb59.png" width="363" height="52" />](http://lostechies.com/content/gabrielschenker/uploads/2014/02/image59.png)
        
        Also add a function to the controller to change the current language
        
        [<img style="border-top: 0px;border-right: 0px;border-bottom: 0px;padding-top: 0px;padding-left: 0px;border-left: 0px;padding-right: 0px" border="0" alt="image" src="http://lostechies.com/content/gabrielschenker/uploads/2014/02/image_thumb60.png" width="463" height="72" />](http://lostechies.com/content/gabrielschenker/uploads/2014/02/image60.png)
        
        In order to make this function work we have to inject the gettextCatalog service into our controller.
        
        [<img style="border-top: 0px;border-right: 0px;border-bottom: 0px;padding-top: 0px;padding-left: 0px;border-left: 0px;padding-right: 0px" border="0" alt="image" src="http://lostechies.com/content/gabrielschenker/uploads/2014/02/image_thumb61.png" width="571" height="33" />](http://lostechies.com/content/gabrielschenker/uploads/2014/02/image61.png)
        
        Add a drop-down bound to the **languages** array to the view
        
        [<img style="border-top: 0px;border-right: 0px;border-bottom: 0px;padding-top: 0px;padding-left: 0px;border-left: 0px;padding-right: 0px" border="0" alt="image" src="http://lostechies.com/content/gabrielschenker/uploads/2014/02/image_thumb62.png" width="596" height="149" />](http://lostechies.com/content/gabrielschenker/uploads/2014/02/image62.png)
        
        This is the result when selecting French as the target language
        
        [<img style="border-top: 0px;border-right: 0px;border-bottom: 0px;padding-top: 0px;padding-left: 0px;border-left: 0px;padding-right: 0px" border="0" alt="image" src="http://lostechies.com/content/gabrielschenker/uploads/2014/02/image_thumb63.png" width="417" height="264" />](http://lostechies.com/content/gabrielschenker/uploads/2014/02/image63.png)
        
        # Conclusion
        
        In this post I have shown how we can get first class support in Angular for globalization and localization using the **angular-gettext** extension. All scenarios that we encounter in our large application are covered. Translating texts is straight forward and very user friendly when using a (free) tool like **Poedit**. The extraction of texts that need to be translated from source code can be fully automated as well as the compilation of the translated texts into a JavaScript library.