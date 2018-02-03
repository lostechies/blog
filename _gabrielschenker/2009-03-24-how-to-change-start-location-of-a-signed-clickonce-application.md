---
wordpress_id: 18
title: 'How To: Change start location of a signed ClickOnce Application'
date: 2009-03-24T08:51:16+00:00
author: Gabriel Schenker
layout: post
wordpress_guid: /blogs/gabrielschenker/archive/2009/03/24/how-to-change-start-location-of-a-signed-clickonce-application.aspx
dsq_thread_id:
  - "263908829"
categories:
  - ClickOnce
  - How To
  - Setup
---
Lately I had to fix a ClickOnce application for a customer who changed the **start location** of the application. Since the path of the start location of the ClickOnce application is part of the (signed) manifest the setup does not work any more if you change it.

The following steps are needed to fix the setup.

  * Open the Visual Studio command prompt.
  * Run the **mage.exe** tool (Manifest Generator Tool).
  * Open the **.manifest** file of the (latest) setup. This file can be located in the directory with the highest version number in the &#8220;**Application Files**&#8221; sub folder of your deployment directory (e.g. c:your\_new\_deployment\_folderapplication filesyour\_application\_1\_2\_3\_11)
  * Save this file and when asked to sign the file select &#8220;**Sign with certificate file**&#8220;. Localize your certificate file (e.g. your_application.pfx)  
    **Note**: a new .pfx file can be created either by the mage tool or by Visual Studio
  * Now open the .application file which is located in your deployment folder (e.g. c:your\_new\_deployment_folder)
  * Select the &#8220;Deployment Options&#8221; section and enter the new &#8220;Start Location&#8221; (e.g. c:your\_new\_deployment\_folderyour\_application.application)
  * Switch to the &#8220;Application Reference&#8221; section and select the .manifest file that you changed/saved previously.
  * Save the .application file and when asked to sign the file again select &#8220;Sign with certificate file&#8221; and localize your certificate file.

That&#8217;s it. The application can now again be installed from the **new** start location.