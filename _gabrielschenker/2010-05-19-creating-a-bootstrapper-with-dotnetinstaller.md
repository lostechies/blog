---
wordpress_id: 41
title: Creating a bootstrapper with dotNetInstaller
date: 2010-05-19T15:15:44+00:00
author: Gabriel Schenker
layout: post
wordpress_guid: /blogs/gabrielschenker/archive/2010/05/19/creating-a-bootstrapper-with-dotnetinstaller.aspx
dsq_thread_id:
  - "263908915"
categories:
  - bootstrapper
  - How To
  - installation
  - WIX
---
## Introduction

In previous post I described [how to create a Microsoft Installer package](http://gabrielschenker.lostechies.com/blogs/gabrielschenker/archive/2009/06/26/walking-through-the-creation-of-a-complex-installer-package.aspx) with the WIX framework and [how to create managed custom actions](http://gabrielschenker.lostechies.com/blogs/gabrielschenker/archive/2010/05/19/wix-and-custom-actions.aspx) for an installer created with WIX.

We are distributing our products to clients having different environments. Most often there is no dedicated full-time network administrator or DBA available on client side. Thus our product installer has to account for this fact.

Currently we define our prerequisites for a successful installation to be either a Windows 2003 Server with IIS 6 or a Windows 2008 Server with IIS7. Both 32 Bit or 64 Bit versions of the OS are supported. We do NOT install a database but expect that either a Oracle Database Server or a MS SQL Server is available at the client side inside which our database will be hosted.

Since our application is based on the .NET framework our installer needs to be able to install .NET if required. A standard Microsoft Installer Package (MSI) cannot do this thus we need a bootstrapper application.

Unfortunately the WIX framework does not yet contain such a bootstrapper application. It was planned to release one with WIX 3.5 but it has been postponed to version 4.0

There are different ways how to create a bootstrapper for an MSI package. One is described [here](http://wix.sourceforge.net/manual-wix3/install_dotnet.htm), its provided by the ClickOnce deployment features in Visual Studio. Another approach is to use [dotNetInstaller](http://dotnetinstaller.codeplex.com/), an open source project. This is the approach we chose for our product. What is dotNetInstaller? On its website it is descibed as

> _**dotNetInstaller** is a widely used, general-purpose setup bootstrapper for Microsoft Windows 95, 98, 2000, XP, 2003, Vista, 2008 and Windows 7._
> 
> _dotNetInstaller enables the developer to define the application prerequisites and install the correct version(s) of these components in a predictable order based on the processor architecture, user operating system type and language, allow the user to download these components from the web, install these components directly from a single packaged setup, local media or both. …_

Again documentation about **dotNetInstaller** is sparse like in many other open source projects. Luckily there are some samples contained in the package.

## Creating a configuration file

To create a new bootstrapper we can use the GUI editor **InstallerEditor.exe**. But for maximum control and better understanding I prefer to manually edit the necessary **xml** configuration file. The basic layout of the schema is as follows

<pre><span class="kwrd">&lt;?</span><span class="html">xml</span> <span class="attr">version</span><span class="kwrd">="1.0"</span> <span class="attr">encoding</span><span class="kwrd">="utf-8"</span>?<span class="kwrd">&gt;</span>
<span class="kwrd">&lt;</span><span class="html">configurations</span> <span class="attr">lcid_type</span><span class="kwrd">="UserExe"</span> ...<span class="kwrd">&gt;</span>
    <span class="kwrd">&lt;</span><span class="html">schema</span> <span class="attr">version</span><span class="kwrd">="1.9.5931.0"</span> <span class="attr">generator</span><span class="kwrd">="dotNetInstaller InstallerEditor"</span> <span class="kwrd">/&gt;</span>
    <span class="kwrd">&lt;</span><span class="html">configuration</span> <span class="attr">dialog_caption</span><span class="kwrd">="ACME Product Installer"</span> ...<span class="kwrd">&gt;</span>
        <span class="kwrd">&lt;</span><span class="html">component</span> <span class="attr">command</span><span class="kwrd">="..."</span> ...<span class="kwrd">&gt;</span>
            ...
        <span class="kwrd">&lt;/</span><span class="html">component</span><span class="kwrd">&gt;</span>
    <span class="kwrd">&lt;/</span><span class="html">configuration</span><span class="kwrd">&gt;</span>
<span class="kwrd">&lt;/</span><span class="html">configurations</span><span class="kwrd">&gt;</span></pre>

.csharpcode, .csharpcode pre
  
{
	  
font-size: small;
	  
color: black;
	  
font-family: consolas, &#8220;Courier New&#8221;, courier, monospace;
	  
background-color: #ffffff;
	  
/\*white-space: pre;\*/
  
}
  
.csharpcode pre { margin: 0em; }
  
.csharpcode .rem { color: #008000; }
  
.csharpcode .kwrd { color: #0000ff; }
  
.csharpcode .str { color: #006080; }
  
.csharpcode .op { color: #0000c0; }
  
.csharpcode .preproc { color: #cc6633; }
  
.csharpcode .asp { background-color: #ffff00; }
  
.csharpcode .html { color: #800000; }
  
.csharpcode .attr { color: #ff0000; }
  
.csharpcode .alt
  
{
	  
background-color: #f4f4f4;
	  
width: 100%;
	  
margin: 0em;
  
}
  
.csharpcode .lnum { color: #606060; }

To require installation of .NET framework 3.5.1 if not already present on the target system we can add the following check to the component node

<pre><span class="kwrd">&lt;</span><span class="html">installedcheck</span> <span class="attr">path</span><span class="kwrd">="SOFTWAREMicrosoftNET Framework SetupNDPv3.5"</span> 
        <span class="attr">fieldname</span><span class="kwrd">="Version"</span> 
        <span class="attr">fieldvalue</span><span class="kwrd">="3.5.30729.01"</span> 
        <span class="attr">fieldtype</span><span class="kwrd">="REG_SZ"</span> 
        <span class="attr">comparison</span><span class="kwrd">="version_ge"</span> 
        <span class="attr">rootkey</span><span class="kwrd">="HKEY_LOCAL_MACHINE"</span> 
        <span class="attr">wowoption</span><span class="kwrd">="NONE"</span> 
        <span class="attr">type</span><span class="kwrd">="check_registry_value"</span> 
        <span class="attr">description</span><span class="kwrd">="Installed Check"</span> <span class="kwrd">/&gt;</span></pre>

.csharpcode, .csharpcode pre
  
{
	  
font-size: small;
	  
color: black;
	  
font-family: consolas, &#8220;Courier New&#8221;, courier, monospace;
	  
background-color: #ffffff;
	  
/\*white-space: pre;\*/
  
}
  
.csharpcode pre { margin: 0em; }
  
.csharpcode .rem { color: #008000; }
  
.csharpcode .kwrd { color: #0000ff; }
  
.csharpcode .str { color: #006080; }
  
.csharpcode .op { color: #0000c0; }
  
.csharpcode .preproc { color: #cc6633; }
  
.csharpcode .asp { background-color: #ffff00; }
  
.csharpcode .html { color: #800000; }
  
.csharpcode .attr { color: #ff0000; }
  
.csharpcode .alt
  
{
	  
background-color: #f4f4f4;
	  
width: 100%;
	  
margin: 0em;
  
}
  
.csharpcode .lnum { color: #606060; }

this basically tells the bootstrapper to scan the registry for a Version key in the registry with a value greater than or equal to “3.5.30729.01”. The key is expected to be found at this location

> <font face="Courier New">HKLMSOFTWAREMicrosoftNET Framework SetupNDPv3.5</font>

If we do not find this key we assume that .NET framework 3.5.1 is not installed and we want to download it from the internet. We put the following <downloaddialog> node inside our <component> node

<pre><span class="kwrd">&lt;</span><span class="html">downloaddialog</span> <span class="attr">dialog_caption</span><span class="kwrd">=".NET Runtime 3.5 SP1 - Download Components"</span> 
                <span class="attr">dialog_message</span><span class="kwrd">="Press 'Start' to download the .NET Runtime 3.5 SP1"</span> 
                <span class="attr">dialog_message_downloading</span><span class="kwrd">="Downloading installer ..."</span> 
                <span class="attr">dialog_message_copying</span><span class="kwrd">="Copying ..."</span> 
                <span class="attr">dialog_message_connecting</span><span class="kwrd">="Connecting ..."</span> 
                <span class="attr">dialog_message_sendingrequest</span><span class="kwrd">="Sending request ..."</span> 
                <span class="attr">autostartdownload</span><span class="kwrd">="False"</span> 
                <span class="attr">buttonstart_caption</span><span class="kwrd">="Start"</span> 
                <span class="attr">buttoncancel_caption</span><span class="kwrd">="Cancel"</span><span class="kwrd">&gt;</span>
                 
    <span class="kwrd">&lt;</span><span class="html">download</span> <span class="attr">componentname</span><span class="kwrd">=".NET Runtime 3.5 SP1"</span> 
              <span class="attr">sourceurl</span><span class="kwrd">="http://go.microsoft.com/fwlink/?linkid=118076"</span> 
              <span class="attr">sourcepath</span><span class="kwrd">="#APPPATHdotnetfx35.exe"</span> 
              <span class="attr">destinationpath</span><span class="kwrd">="#TEMPPATHdotNetRuntime_Download_#PID"</span> 
              <span class="attr">destinationfilename</span><span class="kwrd">="dotnetfx35.exe"</span> 
              <span class="attr">alwaysdownload</span><span class="kwrd">="False"</span> 
              <span class="attr">clear_cache</span><span class="kwrd">="False"</span> <span class="kwrd">/&gt;</span>
 
<span class="kwrd">&lt;/</span><span class="html">downloaddialog</span><span class="kwrd">&gt;</span></pre>

.csharpcode, .csharpcode pre
  
{
	  
font-size: small;
	  
color: black;
	  
font-family: consolas, &#8220;Courier New&#8221;, courier, monospace;
	  
background-color: #ffffff;
	  
/\*white-space: pre;\*/
  
}
  
.csharpcode pre { margin: 0em; }
  
.csharpcode .rem { color: #008000; }
  
.csharpcode .kwrd { color: #0000ff; }
  
.csharpcode .str { color: #006080; }
  
.csharpcode .op { color: #0000c0; }
  
.csharpcode .preproc { color: #cc6633; }
  
.csharpcode .asp { background-color: #ffff00; }
  
.csharpcode .html { color: #800000; }
  
.csharpcode .attr { color: #ff0000; }
  
.csharpcode .alt
  
{
	  
background-color: #f4f4f4;
	  
width: 100%;
	  
margin: 0em;
  
}
  
.csharpcode .lnum { color: #606060; }

The important part here is the attribute sourceurl of the <download> node which should point to the correct url. This could be a location on our own server which contains the .NET framework but it is preferable to download it directly from Microsoft. The correct address can be found out by trying to manually download the said component and copying the url from the browser.

## Creating the bootstrapper

Once we have prepared our configuration file we can create the bootstrapper. To do this we use the linker provided by dotNetInstaller. A typical command looks like this _(note that the following command has to be on one single line and has been reformatted here for readability)_

<pre>pathToDotNetInstallerInstallerLinker.exe 
        /Output:Setup.exe 
        /Icon:ACME.ico 
        /Splash:splash.bmp 
        /Banner:banner.bmp 
        /Template:dotNetInstaller.exe 
        /Configuration:Configuration.xml 
        /Embed+</pre>

.csharpcode, .csharpcode pre
  
{
	  
font-size: small;
	  
color: black;
	  
font-family: consolas, &#8220;Courier New&#8221;, courier, monospace;
	  
background-color: #ffffff;
	  
/\*white-space: pre;\*/
  
}
  
.csharpcode pre { margin: 0em; }
  
.csharpcode .rem { color: #008000; }
  
.csharpcode .kwrd { color: #0000ff; }
  
.csharpcode .str { color: #006080; }
  
.csharpcode .op { color: #0000c0; }
  
.csharpcode .preproc { color: #cc6633; }
  
.csharpcode .asp { background-color: #ffff00; }
  
.csharpcode .html { color: #800000; }
  
.csharpcode .attr { color: #ff0000; }
  
.csharpcode .alt
  
{
	  
background-color: #f4f4f4;
	  
width: 100%;
	  
margin: 0em;
  
}
  
.csharpcode .lnum { color: #606060; }

this command as a result creates an exe called **Setup.exe** whose icon is **ACME.ico**. During creation the linker uses the information found in the **Configuration.xml** file. The MSI package is embedded in the Setup.exe since we use the **/Embed+** command line switch. During startup of the Setup.exe the **splash.bmp** will be shown in a splash screen. When the first dialog is displayed it will contain the **banner.bmp** as a banner.

## Running the bootstrapper

When the bootstrapper detects that the .NET framework isn’t installed on the target system the user is asked to first download and install .NET.

[<img style="border-bottom: 0px;border-left: 0px;border-top: 0px;border-right: 0px" border="0" alt="image" src="http://lostechies.com/gabrielschenker/files/2011/03/image_thumb_7B3F8E10.png" width="470" height="283" />](http://lostechies.com/gabrielschenker/files/2011/03/image_69CF2D38.png) 

### Windows 2008 Server

Windows 2008 Server does not allow for an explicit installation of the .NET framework (3.5.1 SP1 in our case). During installation of the framework an error dialog appears telling the user to install the .NET framework by adding a role to the server. The setup is then aborted.

[<img style="border-bottom: 0px;border-left: 0px;border-top: 0px;border-right: 0px" border="0" alt="image" src="http://lostechies.com/gabrielschenker/files/2011/03/image_thumb_532CDEF1.png" width="468" height="353" />](http://lostechies.com/gabrielschenker/files/2011/03/image_5AB84E5E.png)