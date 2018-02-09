---
wordpress_id: 27
title: Walking through the creation of a complex installer package
date: 2009-06-26T12:05:21+00:00
author: Gabriel Schenker
layout: post
wordpress_guid: /blogs/gabrielschenker/archive/2009/06/26/walking-through-the-creation-of-a-complex-installer-package.aspx
dsq_thread_id:
  - "263908879"
categories:
  - installation
  - NSIS
  - tutorial
  - WIX
redirect_from: "/blogs/gabrielschenker/archive/2009/06/26/walking-through-the-creation-of-a-complex-installer-package.aspx/"
---
## Introduction

In this post I want to describe the issues and pain points I had when trying to generate a setup package for a complex product with many thousand of files. This is a post mainly for self documenting purposes but hopefully it might add some other people trying to create a complex product installer.

I received the following list of requirements

  * The install process must be transactional
  * Repair of a corrupt installation must be possible
  * Patching and Upgrading must be possible
  * Some files (mainly config files) must be backed up during an upgrade
  * Must be able to automatically launch an application at the end of the install
  * Must support localization
  * Can automatically create a virtual directory and an application pool for IIS
  * Can assign write permissions for specific folders to users/groups

In the past our company had used Install Shield to generate the setup packages. But this was overly complex and became a maintenance burden with the time. Not to mention that Install Shield is rather expensive compared to the two products discussed in this post which are both – ahhh – free! The products I want to have a look at in this post are WIX and NSIS.

## WIX – Windows Installer XML

WIX is an open source project of Microsoft. It is based on the Microsoft Windows Installer technology. Everything about WIX (download and documentation) can be found [here](http://wix.sourceforge.net/index.html).

### Tutorial

If you are new to WIX I absolutely recommend to read [this](http://www.tramontana.co.hu/wix/) wonderful and extensive tutorial.

> “… Instead of a tool with a graphical interface that allows the developers to collect the files and other related tasks making up the installation process manually, it is much more like a programming language. _Integrating perfectly with the usual process of creating applications,_ it uses a text file (based on the increasingly popular XML format) to describe all the elements of the installation process. The toolset has a compiler and a linker that will create the setup program just like our usual compiler creates our application from the source files. Therefore, WiX can be made part of any automated application build process very easily, be that based either on the classical technology of makefiles or the similar features of contemporary integrated development environments. …”

### Analyze an existing MSI package with ORCA

If you ever want to analyze the .msi package created by WIX there is a tool called **ORCA** available in the Microsoft Windows SDK. With this tool any detail of such a package can be analyzed in details, e.g. the components included, the icon used or the install execution sequence.

[<img style="border-right-width: 0px;border-top-width: 0px;border-bottom-width: 0px;border-left-width: 0px" border="0" alt="image" src="http://lostechies.com/gabrielschenker/files/2011/03/image_thumb_6DF956D2.png" width="644" height="424" />](http://lostechies.com/gabrielschenker/files/2011/03/image_4C0120D9.png) 

Let’s now have a look at various elements of a setup project in WIX.</p> 

### Defining Variables

If you are used to e.g. [Nant](http://nant.sourceforge.net/) or MSBuild you certainly define properties which later on you use in the script instead of hard coded values. WIX has a similar concept of _variables_. With the aid of pre-processor <?define …> statements we can define variables that later on can be used at the place of hard coded values

<div>
  <div>
    <pre><span style="color: #0000ff">&lt;?</span><span style="color: #800000">define</span> <span style="color: #ff0000">BuildPath</span> = <span style="color: #0000ff">".......build"</span> ?<span style="color: #0000ff">&gt;</span></pre>
    
    <pre><span style="color: #0000ff">&lt;?</span><span style="color: #800000">define</span> <span style="color: #ff0000">Help</span> = <span style="color: #0000ff">"$(var.BuildPath)Help"</span> ?<span style="color: #0000ff">&gt;</span></pre>
    
    <pre><span style="color: #0000ff">&lt;?</span><span style="color: #800000">define</span> <span style="color: #ff0000">Skin</span> = <span style="color: #0000ff">"$(var.Help)Skin"</span> ?<span style="color: #0000ff">&gt;</span></pre>
    
    <pre><span style="color: #0000ff">&lt;?</span><span style="color: #800000">define</span> <span style="color: #ff0000">Data</span> = <span style="color: #0000ff">"$(var.Help)Data"</span> ?<span style="color: #0000ff">&gt;</span></pre></p>
  </div>
</div>

Note that once a variable is defined it can be used by applying the following syntax: $(var._VariableName_). It took me a while to find this all out since unfortunately it is not well documented in the WIKI.

### Properties

To define a property and assign a (constant) value use a statement similar to this

<div>
  <div>
    <pre><span style="color: #0000ff">&lt;</span><span style="color: #800000">Property</span> <span style="color: #ff0000">Id</span><span style="color: #0000ff">='NOTEPAD'</span><span style="color: #0000ff">&gt;</span>Notepad.exe<span style="color: #0000ff">&lt;/</span><span style="color: #800000">Property</span><span style="color: #0000ff">&gt;</span></pre></p>
  </div>
</div>

Note that when using an all caps id for the property the property is considered to be global and can be used every where in the setup files.

To define the value of a property with a nested statement like a registry search

<div>
  <div>
    <pre><span style="color: #0000ff">&lt;</span><span style="color: #800000">Property</span> <span style="color: #ff0000">Id</span><span style="color: #0000ff">="IIS"</span><span style="color: #0000ff">&gt;</span></pre>
    
    <pre>  <span style="color: #0000ff">&lt;</span><span style="color: #800000">RegistrySearch</span> <span style="color: #ff0000">Id</span><span style="color: #0000ff">="IISInstalledVersion"</span></pre>
    
    <pre>                  <span style="color: #ff0000">Root</span><span style="color: #0000ff">="HKLM"</span></pre>
    
    <pre>                  <span style="color: #ff0000">Key</span><span style="color: #0000ff">="SOFTWAREMicrosoftInetStp"</span></pre>
    
    <pre>                  <span style="color: #ff0000">Type</span><span style="color: #0000ff">="raw"</span> <span style="color: #ff0000">Name</span><span style="color: #0000ff">="MajorVersion"</span> <span style="color: #0000ff">/&gt;</span></pre>
    
    <pre><span style="color: #0000ff">&lt;/</span><span style="color: #800000">Property</span><span style="color: #0000ff">&gt;</span></pre></p>
  </div>
</div>

In the above snippet the property **IIS** is assigned the value of the registry key **HKLMSOFTWAREMicrosoftInetStpMajorVersion** which is a **DWORD** in this case. If IIS 7.0 is installed the property **IIS** would contain the value “#7”.

Such a property can then e.g. be used in a condition. The following condition tests whether IIS 6.0 or 7.0 is installed on the current machine

<div>
  <div>
    <pre><span style="color: #0000ff">&lt;</span><span style="color: #800000">Condition</span> <span style="color: #ff0000">Message</span><span style="color: #0000ff">="This setup requires IIS 6.0 or 7.0 is installed."</span><span style="color: #0000ff">&gt;</span></pre>
    
    <pre>  <span style="color: #0000ff">&lt;!</span>[CDATA[IIS="#7" OR IIS="#6"]]<span style="color: #0000ff">&gt;</span></pre>
    
    <pre><span style="color: #0000ff">&lt;/</span><span style="color: #800000">Condition</span><span style="color: #0000ff">&gt;</span></pre></p>
  </div>
</div>

Use environment variables to set properties, e.g.

<div>
  <div>
    <pre><span style="color: #0000ff">&lt;</span><span style="color: #800000">Property</span> <span style="color: #ff0000">Id</span><span style="color: #0000ff">='ROOTDRIVE'</span> <span style="color: #ff0000">Value</span><span style="color: #0000ff">='$(env.SystemDrive)'</span> <span style="color: #0000ff">/&gt;</span></pre></p>
  </div>
</div>

For a full list of all possible system directory values take a look [here](http://msdn.microsoft.com/en-us/library/aa372057(VS.85).aspx).

### Components

The component is the atomic unit of things to be installed. It consists of resources—files, registry keys, shortcuts or anything else—that should always be installed as a single unit. Installing a component should never influence other components, removing one should never damage another component or leave any orphaned resource on the target machine. As a consequence, components cannot share files: the same file going to the same location must never be included in more than one component.

A component has to have its own **Id** identifier as well as its own **GUID**.

<div>
  <div>
    <pre><span style="color: #0000ff">&lt;</span><span style="color: #800000">Component</span> <span style="color: #ff0000">Id</span><span style="color: #0000ff">='Component 1'</span> <span style="color: #ff0000">Guid</span><span style="color: #0000ff">='170A4245-9DE3-4bd7-B68A-110000000010'</span><span style="color: #0000ff">&gt;</span></pre>
    
    <pre>    ...</pre>
    
    <pre><span style="color: #0000ff">&lt;/</span><span style="color: #800000">Component</span><span style="color: #0000ff">&gt;</span></pre></p>
  </div>
</div>

Once defined a component can be referenced by its **id**, e.g.

<div>
  <div>
    <pre><span style="color: #0000ff">&lt;</span><span style="color: #800000">ComponentRef</span> <span style="color: #ff0000">Id</span><span style="color: #0000ff">='Component 1'</span> <span style="color: #0000ff">/&gt;</span></pre></p>
  </div>
</div>

### Component Groups

A component group is a handy way to tie together a group of related components.

<div>
  <div>
    <pre><span style="color: #0000ff">&lt;</span><span style="color: #800000">ComponentGroup</span> <span style="color: #ff0000">Id</span><span style="color: #0000ff">='Help'</span><span style="color: #0000ff">&gt;</span></pre>
    
    <pre>    <span style="color: #0000ff">&lt;</span><span style="color: #800000">ComponentRef</span> <span style="color: #ff0000">Id</span><span style="color: #0000ff">='Help'</span><span style="color: #0000ff">/&gt;</span></pre>
    
    <pre>    <span style="color: #0000ff">&lt;</span><span style="color: #800000">ComponentRef</span> <span style="color: #ff0000">Id</span><span style="color: #0000ff">='Help.Content'</span><span style="color: #0000ff">/&gt;</span></pre>
    
    <pre>    <span style="color: #0000ff">&lt;</span><span style="color: #800000">ComponentRef</span> <span style="color: #ff0000">Id</span><span style="color: #0000ff">='Help.Content.Administration'</span><span style="color: #0000ff">/&gt;</span></pre>
    
    <pre>    ...</pre>
    
    <pre><span style="color: #0000ff">&lt;/</span><span style="color: #800000">ComponentGroup</span><span style="color: #0000ff">&gt;</span></pre></p>
  </div>
</div>

later on in the setup package this group of components can be easily referenced, e.g.

<div>
  <div>
    <pre><span style="color: #0000ff">&lt;</span><span style="color: #800000">Feature</span> <span style="color: #ff0000">Id</span><span style="color: #0000ff">='Core'</span> <span style="color: #ff0000">Title</span><span style="color: #0000ff">='Core'</span> <span style="color: #ff0000">Level</span><span style="color: #0000ff">='1'</span><span style="color: #0000ff">&gt;</span></pre>
    
    <pre>    ...</pre>
    
    <pre>    <span style="color: #0000ff">&lt;</span><span style="color: #800000">ComponentGroupRef</span> <span style="color: #ff0000">Id</span><span style="color: #0000ff">='Help'</span> <span style="color: #0000ff">/&gt;</span></pre>
    
    <pre>    ...</pre>
    
    <pre><span style="color: #0000ff">&lt;/</span><span style="color: #800000">Feature</span><span style="color: #0000ff">&gt;</span></pre></p>
  </div>
</div>

### Conditions

Often we need to define some conditions, e.g. launch conditions, conditional installation of some components, etc. For this purpose we have the <Condition Message=’…’>Inner text</Condition> construct. Here at the place of ‘Inner text’ one would define the condition (logic). If the condition is a launch condition and the evaluation of the condition logic result in false then the install process would be aborted and the text in the Message attribute would be reported. Typical launch conditions are

Request for sufficient privileges

<div>
  <div>
    <pre>&lt;Condition Message=<span style="color: #006080">"You need to be an administrator to install this product."</span>&gt;</pre>
    
    <pre>  Privileged</pre>
    
    <pre>&lt;/Condition&gt;</pre></p>
  </div>
</div>

a specific version of a framework (e.g. .NET 3.5) must be installed

<div>
  <div>
    <pre>&lt;Condition Message=<span style="color: #006080">"This application requires .NET Framework 3.5. Please install the .NET Framework then run this installer again."</span>&gt;</pre>
    
    <pre>  &lt;![CDATA[Installed OR NETFRAMEWORK35]]&gt;</pre>
    
    <pre>&lt;/Condition&gt;</pre></p>
  </div>
</div>

IIS 6.0 or above must be installed

<div>
  <div>
    <pre>&lt;Condition Message=<span style="color: #006080">"This setup requires IIS 6.0 or 7.0 is installed."</span>&gt;</pre>
    
    <pre>  &lt;![CDATA[IIS=<span style="color: #006080">"#7"</span> OR IIS=<span style="color: #006080">"#6"</span>]]&gt;</pre>
    
    <pre>&lt;/Condition&gt;</pre></p>
  </div>
</div>

For the above condition to work we have to define the property IIS since this is a custom property. We can do so with the following snippet

<div>
  <div>
    <pre><span style="color: #0000ff">&lt;</span><span style="color: #800000">Property</span> <span style="color: #ff0000">Id</span><span style="color: #0000ff">="IIS"</span><span style="color: #0000ff">&gt;</span></pre>
    
    <pre>  <span style="color: #0000ff">&lt;</span><span style="color: #800000">RegistrySearch</span> <span style="color: #ff0000">Id</span><span style="color: #0000ff">="IISInstalledVersion"</span></pre>
    
    <pre>                  <span style="color: #ff0000">Root</span><span style="color: #0000ff">="HKLM"</span></pre>
    
    <pre>                  <span style="color: #ff0000">Key</span><span style="color: #0000ff">="SOFTWAREMicrosoftInetStp"</span></pre>
    
    <pre>                  <span style="color: #ff0000">Type</span><span style="color: #0000ff">="raw"</span> <span style="color: #ff0000">Name</span><span style="color: #0000ff">="MajorVersion"</span> <span style="color: #0000ff">/&gt;</span></pre>
    
    <pre><span style="color: #0000ff">&lt;/</span><span style="color: #800000">Property</span><span style="color: #0000ff">&gt;</span></pre></p>
  </div>
</div>

here the value of the property IIS is set by the nested registry search which looks for a required key in the registry.

### Permissions on folders

If we want to create a folder during setup which has special permissions we can use the following snippet inside a component

<div>
  <div>
    <pre><span style="color: #0000ff">&lt;</span><span style="color: #800000">CreateFolder</span> <span style="color: #ff0000">Directory</span><span style="color: #0000ff">='index'</span><span style="color: #0000ff">&gt;</span></pre>
    
    <pre>  <span style="color: #008000">&lt;!-- pay attention when using on non-english system! --&gt;</span></pre>
    
    <pre>  <span style="color: #0000ff">&lt;</span><span style="color: #800000">Permission</span> <span style="color: #ff0000">User</span><span style="color: #0000ff">="Everyone"</span> <span style="color: #ff0000">GenericAll</span><span style="color: #0000ff">="yes"</span> <span style="color: #0000ff">/&gt;</span></pre>
    
    <pre><span style="color: #0000ff">&lt;/</span><span style="color: #800000">CreateFolder</span><span style="color: #0000ff">&gt;</span></pre></p>
  </div>
</div>

### Permissions and globalization/localization issues

Regarding localization issues have a look at [this](http://social.msdn.microsoft.com/Forums/en-US/vssetup/thread/39d9e905-2b35-4ce9-a544-4564f6b5a376) article.

The following snippet would cause problems on a computer having a say German Windows operating installed

<div>
  <div>
    <pre><span style="color: #0000ff">&lt;</span><span style="color: #800000">CreateFolder</span> <span style="color: #ff0000">Directory</span><span style="color: #0000ff">='index'</span><span style="color: #0000ff">&gt;</span></pre>
    
    <pre>  <span style="color: #0000ff">&lt;</span><span style="color: #800000">Permission</span> <span style="color: #ff0000">User</span><span style="color: #0000ff">="Users"</span> <span style="color: #ff0000">GenericAll</span><span style="color: #0000ff">="yes"</span> <span style="color: #0000ff">/&gt;</span></pre>
    
    <pre><span style="color: #0000ff">&lt;/</span><span style="color: #800000">CreateFolder</span><span style="color: #0000ff">&gt;</span></pre></p>
  </div>
</div>

since the group ‘Users’ is called ‘Benutzer’ in German. Thus we need a more sophisticated way using custom actions and conditions. First we define a global(!) property with a default value

<div>
  <div>
    <pre><span style="color: #0000ff">&lt;</span><span style="color: #800000">Property</span> <span style="color: #ff0000">Id</span><span style="color: #0000ff">="USERGROUP_USERS"</span> <span style="color: #ff0000">Value</span><span style="color: #0000ff">="Users"</span><span style="color: #0000ff">/&gt;</span></pre></p>
  </div>
</div>

then we define a custom action to apply the localized name for the group ‘Users’

<div>
  <div>
    <pre><span style="color: #0000ff">&lt;</span><span style="color: #800000">CustomAction</span> <span style="color: #ff0000">Id</span><span style="color: #0000ff">="SetUserGroup_Users_De"</span></pre>
    
    <pre>              <span style="color: #ff0000">Property</span><span style="color: #0000ff">="USERGROUP_USERS"</span></pre>
    
    <pre>              <span style="color: #ff0000">Value</span><span style="color: #0000ff">="Benutzer"</span></pre>
    
    <pre>              <span style="color: #ff0000">Return</span><span style="color: #0000ff">="check"</span> <span style="color: #0000ff">/&gt;</span></pre></p>
  </div>
</div>

and then we execute the correct custom action based on the condition on which system language the operating system uses

<div>
  <div>
    <pre><span style="color: #0000ff">&lt;</span><span style="color: #800000">InstallUISequence</span><span style="color: #0000ff">&gt;</span></pre>
    
    <pre>&#160;</pre>
    
    <pre>    <span style="color: #0000ff">&lt;</span><span style="color: #800000">Custom</span> <span style="color: #ff0000">Action</span><span style="color: #0000ff">="SetUserGroup_Users_De"</span> <span style="color: #ff0000">After</span><span style="color: #0000ff">="LaunchConditions"</span><span style="color: #0000ff">&gt;</span></pre>
    
    <pre>        SystemLanguageID = "1031"</pre>
    
    <pre>    <span style="color: #0000ff">&lt;/</span><span style="color: #800000">Custom</span><span style="color: #0000ff">&gt;</span></pre>
    
    <pre>&#160;</pre>
    
    <pre>    <span style="color: #0000ff">&lt;</span><span style="color: #800000">Custom</span> <span style="color: #ff0000">Action</span><span style="color: #0000ff">="SetUserGroup_Users_Fr"</span> <span style="color: #ff0000">After</span><span style="color: #0000ff">="LaunchConditions"</span><span style="color: #0000ff">&gt;</span></pre>
    
    <pre>        SystemLanguageID = "1036"</pre>
    
    <pre>    <span style="color: #0000ff">&lt;/</span><span style="color: #800000">Custom</span><span style="color: #0000ff">&gt;</span></pre>
    
    <pre>&#160;</pre>
    
    <pre>    ...</pre>
    
    <pre>&#160;</pre>
    
    <pre><span style="color: #0000ff">&lt;/</span><span style="color: #800000">InstallUISequence</span><span style="color: #0000ff">&gt;</span></pre></p>
  </div>
</div>

finally the Permission tag uses our global property which now should contain the correct value

<div>
  <div>
    <pre><span style="color: #0000ff">&lt;</span><span style="color: #800000">CreateFolder</span> <span style="color: #ff0000">Directory</span><span style="color: #0000ff">='index'</span><span style="color: #0000ff">&gt;</span></pre>
    
    <pre>  <span style="color: #0000ff">&lt;</span><span style="color: #800000">Permission</span> <span style="color: #ff0000">User</span><span style="color: #0000ff">="[USERGROUP_USERS]"</span> <span style="color: #ff0000">GenericAll</span><span style="color: #0000ff">="yes"</span> <span style="color: #0000ff">/&gt;</span></pre>
    
    <pre><span style="color: #0000ff">&lt;/</span><span style="color: #800000">CreateFolder</span><span style="color: #0000ff">&gt;</span></pre></p>
  </div>
</div>

Wow, this is a lot of work. Way too complicated in my opinion. If somebody know a more elegant way to do it, I am open for any suggestions!

### Extensions

WIX provides some useful extension for common tasks. The namespace of an extension must be defined in the file where the respective functionality is used. If we want to use the IIS extensions then use the following definition

<div>
  <div>
    <pre><span style="color: #0000ff">&lt;</span><span style="color: #800000">Wix</span> <span style="color: #ff0000">xmlns</span><span style="color: #0000ff">='http://schemas.microsoft.com/wix/2006/wi'</span></pre>
    
    <pre>     <span style="color: #ff0000">xmlns:iis</span><span style="color: #0000ff">="http://schemas.microsoft.com/wix/IIsExtension"</span><span style="color: #0000ff">&gt;</span></pre>
    
    <pre>  ...</pre>
    
    <pre><span style="color: #0000ff">&lt;/</span><span style="color: #800000">Wix</span><span style="color: #0000ff">&gt;</span></pre></p>
  </div>
</div>

Now the commands provided by the extensions can be used like this

<div>
  <div>
    <pre><span style="color: #008000">&lt;!-- Create an application pool on IIS --&gt;</span></pre>
    
    <pre><span style="color: #0000ff">&lt;</span><span style="color: #800000">iis:WebAppPool</span> <span style="color: #ff0000">Id</span><span style="color: #0000ff">='TestAppPool'</span> <span style="color: #ff0000">Name</span><span style="color: #0000ff">='Test Application Pool'</span> <span style="color: #ff0000">Identity</span><span style="color: #0000ff">='networkService'</span><span style="color: #0000ff">/&gt;</span></pre></p>
  </div>
</div>

which creates a new application pool for IIS during installation.

### Define an application pool for IIS

On task of our setup package is to create a new application pool for IIS during installation. It comes handy that WIX provides an extension providing IIS related tasks which among other tasks allows us to just do that. First we have to define the namespace for the extension

<div>
  <div>
    <pre><span style="color: #0000ff">&lt;</span><span style="color: #800000">Wix</span> <span style="color: #ff0000">xmlns</span><span style="color: #0000ff">='http://schemas.microsoft.com/wix/2006/wi'</span></pre>
    
    <pre>     <span style="color: #ff0000">xmlns:iis</span><span style="color: #0000ff">="http://schemas.microsoft.com/wix/IIsExtension"</span><span style="color: #0000ff">&gt;</span></pre></p>
  </div>
</div>

then we can use all available commands. In our case this is the one we need

<div>
  <div>
    <pre><span style="color: #0000ff">&lt;</span><span style="color: #800000">iis:WebAppPool</span> <span style="color: #ff0000">Id</span><span style="color: #0000ff">='SampleAppPool'</span> <span style="color: #ff0000">Name</span><span style="color: #0000ff">='Sample Application Pool'</span> <span style="color: #ff0000">Identity</span><span style="color: #0000ff">='networkService'</span><span style="color: #0000ff">/&gt;</span></pre></p>
  </div>
</div>

The above command creates a new application pool and assigns it the network service identity. Note that the command has to be a child of a **component**.

### Create a virtual directory for IIS

Not only do we have to create a new application pool but also we need a new virtual directory for IIS. With the same extension we can use this fragment to do just that

<div>
  <div>
    <pre><span style="color: #0000ff">&lt;</span><span style="color: #800000">iis:WebVirtualDir</span> <span style="color: #ff0000">Id</span><span style="color: #0000ff">="MyWebApp"</span> <span style="color: #ff0000">Alias</span><span style="color: #0000ff">="MyWebApp"</span></pre>
    
    <pre>                   <span style="color: #ff0000">Directory</span><span style="color: #0000ff">="INSTALLDIR"</span></pre>
    
    <pre>                   <span style="color: #ff0000">WebSite</span><span style="color: #0000ff">="DefaultWebSite"</span><span style="color: #0000ff">&gt;</span></pre>
    
    <pre>  <span style="color: #0000ff">&lt;</span><span style="color: #800000">iis:WebApplication</span> <span style="color: #ff0000">Id</span><span style="color: #0000ff">="SampleWebApplication"</span> <span style="color: #ff0000">Name</span><span style="color: #0000ff">="Sample"</span> <span style="color: #ff0000">WebAppPool</span><span style="color: #0000ff">="SampleAppPool"</span> <span style="color: #0000ff">/&gt;</span></pre>
    
    <pre><span style="color: #0000ff">&lt;/</span><span style="color: #800000">iis:WebVirtualDir</span><span style="color: #0000ff">&gt;</span></pre></p>
  </div>
</div>

The above command creates a new virtual directory for the physical folder [INSTALLDIR] and calls it MyWebApp. The new virtual directory is defined for the **DefaultWebSite**. It then creates an Web application and assigns this application to the application pool created previously. Again this command has to be a child of a component.

Now finally we have to define what is our **DefaultWebSite**. This is done with the following command

<div>
  <div>
    <pre><span style="color: #0000ff">&lt;</span><span style="color: #800000">iis:WebSite</span> <span style="color: #ff0000">Id</span><span style="color: #0000ff">='DefaultWebSite'</span> <span style="color: #ff0000">Description</span><span style="color: #0000ff">='Default Web Site'</span> <span style="color: #ff0000">Directory</span><span style="color: #0000ff">='TARGETDIR'</span><span style="color: #0000ff">&gt;</span></pre>
    
    <pre>  <span style="color: #0000ff">&lt;</span><span style="color: #800000">iis:WebAddress</span> <span style="color: #ff0000">Id</span><span style="color: #0000ff">="AllUnassigned"</span> <span style="color: #ff0000">Port</span><span style="color: #0000ff">="80"</span> <span style="color: #0000ff">/&gt;</span></pre>
    
    <pre><span style="color: #0000ff">&lt;/</span><span style="color: #800000">iis:WebSite</span><span style="color: #0000ff">&gt;</span></pre></p>
  </div>
</div>

Note that the above command usually should not be put inside a Component otherwise if put it inside the Component, a new Web Site will be created and uninstall will remove it.

### Modularize the setup

When building a complex setup package it is advisable to modularize it. [SRP](http://lostechies.com/blogs/gabrielschenker/archive/2009/01/21/real-swiss-don-t-need-srp-do-they.aspx) anybody…? We have modules, includes and fragments for this purpose. There will be one main .wxs file and several satellite .wxs or .wxi files.

#### The main installation file

We have to have one main wxs file which defines our overall setup package. The schema of this file contains the following main parts

<div>
  <div>
    <pre><span style="color: #606060">   1:</span> <span style="color: #0000ff">&lt;?</span><span style="color: #800000">xml</span> <span style="color: #ff0000">version</span><span style="color: #0000ff">="1.0"</span> <span style="color: #ff0000">encoding</span><span style="color: #0000ff">="utf-8"</span>?<span style="color: #0000ff">&gt;</span></pre>
    
    <pre><span style="color: #606060">   2:</span> <span style="color: #0000ff">&lt;</span><span style="color: #800000">Wix</span> <span style="color: #ff0000">xmlns</span><span style="color: #0000ff">='http://schemas.microsoft.com/wix/2006/wi'</span><span style="color: #0000ff">&gt;</span></pre>
    
    <pre><span style="color: #606060">   3:</span>&#160; </pre>
    
    <pre><span style="color: #606060">   4:</span>   <span style="color: #0000ff">&lt;</span><span style="color: #800000">Product</span> <span style="color: #ff0000">Id</span><span style="color: #0000ff">='170A4245-9DE3-4bd7-B68A-100000000000'</span></pre>
    
    <pre><span style="color: #606060">   5:</span>            <span style="color: #ff0000">UpgradeCode</span><span style="color: #0000ff">='170A4245-9DE3-4bd7-B68A-200000000000'</span> ...<span style="color: #0000ff">&gt;</span></pre>
    
    <pre><span style="color: #606060">   6:</span>&#160; </pre>
    
    <pre><span style="color: #606060">   7:</span>     <span style="color: #0000ff">&lt;</span><span style="color: #800000">Package</span> ...<span style="color: #0000ff">/&gt;</span></pre>
    
    <pre><span style="color: #606060">   8:</span>&#160; </pre>
    
    <pre><span style="color: #606060">   9:</span>     <span style="color: #008000">&lt;!-- Define the directory structure on target computer --&gt;</span></pre>
    
    <pre><span style="color: #606060">  10:</span>     <span style="color: #0000ff">&lt;</span><span style="color: #800000">Directory</span> <span style="color: #ff0000">Id</span><span style="color: #0000ff">='TARGETDIR'</span> <span style="color: #ff0000">Name</span><span style="color: #0000ff">='SourceDir'</span><span style="color: #0000ff">&gt;</span></pre>
    
    <pre><span style="color: #606060">  11:</span>       <span style="color: #0000ff">&lt;</span><span style="color: #800000">Directory</span> <span style="color: #ff0000">Id</span><span style="color: #0000ff">='ProgramFilesFolder'</span> <span style="color: #0000ff">&gt;</span></pre>
    
    <pre><span style="color: #606060">  12:</span>         <span style="color: #0000ff">&lt;</span><span style="color: #800000">Directory</span> <span style="color: #ff0000">Id</span><span style="color: #0000ff">='INSTALLDIR'</span> <span style="color: #ff0000">Name</span><span style="color: #0000ff">='TOPAZ TE6'</span><span style="color: #0000ff">&gt;</span></pre>
    
    <pre><span style="color: #606060">  13:</span>             <span style="color: #008000">&lt;!-- define more (sub-) directories if needed --&gt;</span></pre>
    
    <pre><span style="color: #606060">  14:</span>             ...</pre>
    
    <pre><span style="color: #606060">  15:</span>         <span style="color: #0000ff">&lt;/</span><span style="color: #800000">Directory</span><span style="color: #0000ff">&gt;</span></pre>
    
    <pre><span style="color: #606060">  16:</span>       <span style="color: #0000ff">&lt;/</span><span style="color: #800000">Directory</span><span style="color: #0000ff">&gt;</span></pre>
    
    <pre><span style="color: #606060">  17:</span>     <span style="color: #0000ff">&lt;/</span><span style="color: #800000">Directory</span><span style="color: #0000ff">&gt;</span></pre>
    
    <pre><span style="color: #606060">  18:</span>&#160; </pre>
    
    <pre><span style="color: #606060">  19:</span>     <span style="color: #008000">&lt;!-- Define the components and component groups --&gt;</span></pre>
    
    <pre><span style="color: #606060">  20:</span>     <span style="color: #0000ff">&lt;</span><span style="color: #800000">DirectoryRef</span> <span style="color: #ff0000">Id</span><span style="color: #0000ff">="INSTALLDIR"</span><span style="color: #0000ff">&gt;</span></pre>
    
    <pre><span style="color: #606060">  21:</span>       <span style="color: #0000ff">&lt;</span><span style="color: #800000">Component</span> <span style="color: #ff0000">Id</span><span style="color: #0000ff">='Component 1'</span> <span style="color: #ff0000">Guid</span><span style="color: #0000ff">='170A4245-9DE3-4bd7-B68A-110000000010'</span><span style="color: #0000ff">&gt;</span></pre>
    
    <pre><span style="color: #606060">  22:</span>         ...</pre>
    
    <pre><span style="color: #606060">  23:</span>       <span style="color: #0000ff">&lt;/</span><span style="color: #800000">Component</span><span style="color: #0000ff">&gt;</span></pre>
    
    <pre><span style="color: #606060">  24:</span>     <span style="color: #0000ff">&lt;/</span><span style="color: #800000">DirectoryRef</span><span style="color: #0000ff">&gt;</span></pre>
    
    <pre><span style="color: #606060">  25:</span>     </pre>
    
    <pre><span style="color: #606060">  26:</span>     <span style="color: #008000">&lt;!-- Define the list of features available to install --&gt;</span></pre>
    
    <pre><span style="color: #606060">  27:</span>     <span style="color: #0000ff">&lt;</span><span style="color: #800000">Feature</span> <span style="color: #ff0000">Id</span><span style="color: #0000ff">='Complete'</span> <span style="color: #ff0000">Level</span><span style="color: #0000ff">='1'</span><span style="color: #0000ff">&gt;</span></pre>
    
    <pre><span style="color: #606060">  28:</span>       </pre>
    
    <pre><span style="color: #606060">  29:</span>       <span style="color: #0000ff">&lt;</span><span style="color: #800000">Feature</span> <span style="color: #ff0000">Id</span><span style="color: #0000ff">='Feature 1'</span> <span style="color: #ff0000">Title</span><span style="color: #0000ff">='Feature 1'</span> <span style="color: #ff0000">Level</span><span style="color: #0000ff">='1'</span><span style="color: #0000ff">&gt;</span></pre>
    
    <pre><span style="color: #606060">  30:</span>         <span style="color: #0000ff">&lt;</span><span style="color: #800000">ComponentGroupRef</span> <span style="color: #ff0000">Id</span><span style="color: #0000ff">='Group 1'</span><span style="color: #0000ff">/&gt;</span></pre>
    
    <pre><span style="color: #606060">  31:</span>             ...</pre>
    
    <pre><span style="color: #606060">  32:</span>         <span style="color: #0000ff">&lt;</span><span style="color: #800000">ComponentRef</span> <span style="color: #ff0000">Id</span><span style="color: #0000ff">='Component 1'</span><span style="color: #0000ff">/&gt;</span></pre>
    
    <pre><span style="color: #606060">  33:</span>         <span style="color: #0000ff">&lt;</span><span style="color: #800000">MergeRef</span> <span style="color: #ff0000">Id</span><span style="color: #0000ff">='Merge Module 1'</span><span style="color: #0000ff">/&gt;</span></pre>
    
    <pre><span style="color: #606060">  34:</span>       <span style="color: #0000ff">&lt;/</span><span style="color: #800000">Feature</span><span style="color: #0000ff">&gt;</span></pre>
    
    <pre><span style="color: #606060">  35:</span>       </pre>
    
    <pre><span style="color: #606060">  36:</span>       <span style="color: #0000ff">&lt;</span><span style="color: #800000">Feature</span> <span style="color: #ff0000">Id</span><span style="color: #0000ff">='Feature 2'</span> <span style="color: #ff0000">Title</span><span style="color: #0000ff">='Feature 2'</span> <span style="color: #ff0000">Level</span><span style="color: #0000ff">='1000'</span><span style="color: #0000ff">&gt;</span></pre>
    
    <pre><span style="color: #606060">  37:</span>         ...</pre>
    
    <pre><span style="color: #606060">  38:</span>       <span style="color: #0000ff">&lt;/</span><span style="color: #800000">Feature</span><span style="color: #0000ff">&gt;</span></pre>
    
    <pre><span style="color: #606060">  39:</span>       </pre>
    
    <pre><span style="color: #606060">  40:</span>     <span style="color: #0000ff">&lt;/</span><span style="color: #800000">Feature</span><span style="color: #0000ff">&gt;</span></pre>
    
    <pre><span style="color: #606060">  41:</span>   <span style="color: #0000ff">&lt;/</span><span style="color: #800000">Product</span><span style="color: #0000ff">&gt;</span></pre>
    
    <pre><span style="color: #606060">  42:</span> <span style="color: #0000ff">&lt;/</span><span style="color: #800000">Wix</span><span style="color: #0000ff">&gt;</span></pre></p>
  </div>
</div>

The root node on line 2 is <**Wix**> and we have to define at least the root namespace “http://schemas.microsoft.com/wix/2006/wi”. 

The wix node has a single child node <**Product**> which defines such things as the name of the product, the manufacturer, the version, etc. Very important are also the **Id** and the **UpgradeCode** of the product tag which uniquely define an installed product. Both of them are GUIDs. The **UpgradeCode** is very important if you plan to patch or upgrade an installation in the future since (to work properly) the patch- or upgrade package will have to reference this **UpgradeCode**.

On line 7 we define the (setup-) package in more details. There we define the required version of the Microsoft Windows installer, whether or not the package is compressed, the manufacturer and other things.

Starting from line 10 we have the definition of the directory structure we want to create on the target computer.

Starting from line 20 we define the components that shall be included in our setup package.

On line 27 and following we define the list of features this setup package provides. This list is visible to the user during the setup and he can enable or disable certain features. Normally during a setup the user is presented with 3 choices

[<img style="border-bottom: 0px;border-left: 0px;border-top: 0px;border-right: 0px" border="0" alt="image" src="http://lostechies.com/gabrielschenker/files/2011/03/image_thumb_511F9623.png" width="497" height="364" />](http://lostechies.com/gabrielschenker/files/2011/03/image_6BCC323C.png) 

The **Level** attribute of a feature determines whether a feature is included in the typical or only in the complete setup. In our sample Level=’1’ means that the feature is included in the typical setup whilst Level=’1000’ means it is not included.

#### Include Files

The content found in an Include file is just imported and placed at the position where you put an <font face="Courier New"><?include …></font> pre-processor directive, e.g.

<div>
  <div>
    <pre><span style="color: #0000ff">&lt;?</span><span style="color: #800000">include</span> <span style="color: #ff0000">MyIncludeFile</span>.<span style="color: #ff0000">wsi</span>?<span style="color: #0000ff">&gt;</span></pre></p>
  </div>
</div>

A include file usually has the extension .wsi. As an example I have defined an include file which contains (some of) the launch conditions of our setup

<div>
  <div>
    <pre><span style="color: #0000ff">&lt;?</span><span style="color: #800000">xml</span> <span style="color: #ff0000">version</span><span style="color: #0000ff">='1.0'</span>?<span style="color: #0000ff">&gt;</span></pre>
    
    <pre>&#160;</pre>
    
    <pre><span style="color: #0000ff">&lt;</span><span style="color: #800000">Include</span> <span style="color: #ff0000">xmlns</span><span style="color: #0000ff">='http://schemas.microsoft.com/wix/2006/wi'</span></pre>
    
    <pre>     <span style="color: #ff0000">xmlns:iis</span><span style="color: #0000ff">="http://schemas.microsoft.com/wix/IIsExtension"</span><span style="color: #0000ff">&gt;</span></pre>
    
    <pre>&#160;</pre>
    
    <pre>  <span style="color: #008000">&lt;!-- check whether .NET 3.5 SP1 is installed --&gt;</span></pre>
    
    <pre>  <span style="color: #0000ff">&lt;</span><span style="color: #800000">PropertyRef</span> <span style="color: #ff0000">Id</span><span style="color: #0000ff">="NETFRAMEWORK35"</span><span style="color: #0000ff">/&gt;</span></pre>
    
    <pre>  <span style="color: #0000ff">&lt;</span><span style="color: #800000">PropertyRef</span> <span style="color: #ff0000">Id</span><span style="color: #0000ff">="NETFRAMEWORK35_SP_LEVEL"</span><span style="color: #0000ff">/&gt;</span></pre>
    
    <pre>&#160;</pre>
    
    <pre>  <span style="color: #0000ff">&lt;</span><span style="color: #800000">Condition</span> <span style="color: #ff0000">Message</span><span style="color: #0000ff">="This application requires .NET Framework 3.5. Please install the .NET Framework then run this installer again."</span><span style="color: #0000ff">&gt;</span></pre>
    
    <pre>    <span style="color: #0000ff">&lt;!</span>[CDATA[Installed OR NETFRAMEWORK35]]<span style="color: #0000ff">&gt;</span></pre>
    
    <pre>  <span style="color: #0000ff">&lt;/</span><span style="color: #800000">Condition</span><span style="color: #0000ff">&gt;</span></pre>
    
    <pre>&#160;</pre>
    
    <pre>  <span style="color: #0000ff">&lt;</span><span style="color: #800000">Condition</span> <span style="color: #ff0000">Message</span><span style="color: #0000ff">="This application requires .NET Framework 3.5 SP1. Please install the .NET Framework then run this installer again."</span><span style="color: #0000ff">&gt;</span></pre>
    
    <pre>    <span style="color: #0000ff">&lt;!</span>[CDATA[Installed OR (NETFRAMEWORK35_SP_LEVEL and NOT NETFRAMEWORK35_SP_LEVEL = "#0")]]<span style="color: #0000ff">&gt;</span></pre>
    
    <pre>  <span style="color: #0000ff">&lt;/</span><span style="color: #800000">Condition</span><span style="color: #0000ff">&gt;</span></pre>
    
    <pre>&#160;</pre>
    
    <pre>  <span style="color: #0000ff">&lt;</span><span style="color: #800000">Condition</span> <span style="color: #ff0000">Message</span><span style="color: #0000ff">="You need to be an administrator to install this product."</span><span style="color: #0000ff">&gt;</span></pre>
    
    <pre>    Privileged</pre>
    
    <pre>  <span style="color: #0000ff">&lt;/</span><span style="color: #800000">Condition</span><span style="color: #0000ff">&gt;</span></pre>
    
    <pre>&#160;</pre>
    
    <pre>  ...</pre>
    
    <pre><span style="color: #0000ff">&lt;</span><span style="color: #800000">Include</span><span style="color: #0000ff">&gt;</span></pre></p>
  </div>
</div>

Please note that the root tag of an include file has to be <**Include**> and not <Wix>

#### Fragment

Useful if you want to define a component or component group that later on is referenced in the main .wxs file. As an example I take the component responsible to install the online help for the product

<div>
  <div>
    <pre><span style="color: #0000ff">&lt;?</span><span style="color: #800000">xml</span> <span style="color: #ff0000">version</span><span style="color: #0000ff">='1.0'</span>?<span style="color: #0000ff">&gt;</span></pre>
    
    <pre>&#160;</pre>
    
    <pre><span style="color: #0000ff">&lt;?</span><span style="color: #800000">define</span> <span style="color: #ff0000">BuildPath</span> = <span style="color: #0000ff">".......build"</span> ?<span style="color: #0000ff">&gt;</span></pre>
    
    <pre><span style="color: #0000ff">&lt;?</span><span style="color: #800000">define</span> <span style="color: #ff0000">Help</span> = <span style="color: #0000ff">"$(var.BuildPath)Help"</span> ?<span style="color: #0000ff">&gt;</span></pre>
    
    <pre><span style="color: #0000ff">&lt;?</span><span style="color: #800000">define</span> <span style="color: #ff0000">Skin</span> = <span style="color: #0000ff">"$(var.Help)Skin"</span> ?<span style="color: #0000ff">&gt;</span></pre>
    
    <pre><span style="color: #0000ff">&lt;?</span><span style="color: #800000">define</span> <span style="color: #ff0000">Data</span> = <span style="color: #0000ff">"$(var.Help)Data"</span> ?<span style="color: #0000ff">&gt;</span></pre>
    
    <pre>&#160;</pre>
    
    <pre><span style="color: #0000ff">&lt;</span><span style="color: #800000">Wix</span> <span style="color: #ff0000">xmlns</span><span style="color: #0000ff">='http://schemas.microsoft.com/wix/2006/wi'</span><span style="color: #0000ff">&gt;</span></pre>
    
    <pre>  <span style="color: #0000ff">&lt;</span><span style="color: #800000">Fragment</span> <span style="color: #ff0000">Id</span><span style="color: #0000ff">='FragmentHelp'</span><span style="color: #0000ff">&gt;</span></pre>
    
    <pre>    </pre>
    
    <pre>    <span style="color: #0000ff">&lt;</span><span style="color: #800000">ComponentGroup</span> <span style="color: #ff0000">Id</span><span style="color: #0000ff">='Help'</span><span style="color: #0000ff">&gt;</span></pre>
    
    <pre>      <span style="color: #0000ff">&lt;</span><span style="color: #800000">ComponentRef</span> <span style="color: #ff0000">Id</span><span style="color: #0000ff">='Help'</span><span style="color: #0000ff">/&gt;</span></pre>
    
    <pre>      <span style="color: #0000ff">&lt;</span><span style="color: #800000">ComponentRef</span> <span style="color: #ff0000">Id</span><span style="color: #0000ff">='Help.Skin'</span><span style="color: #0000ff">/&gt;</span></pre>
    
    <pre>      <span style="color: #0000ff">&lt;</span><span style="color: #800000">ComponentRef</span> <span style="color: #ff0000">Id</span><span style="color: #0000ff">='Help.Data'</span><span style="color: #0000ff">/&gt;</span></pre>
    
    <pre>    <span style="color: #0000ff">&lt;/</span><span style="color: #800000">ComponentGroup</span><span style="color: #0000ff">&gt;</span></pre>
    
    <pre>    </pre>
    
    <pre>    <span style="color: #0000ff">&lt;</span><span style="color: #800000">DirectoryRef</span> <span style="color: #ff0000">Id</span><span style="color: #0000ff">="Help"</span><span style="color: #0000ff">&gt;</span></pre>
    
    <pre>      </pre>
    
    <pre>      <span style="color: #0000ff">&lt;</span><span style="color: #800000">Component</span> <span style="color: #ff0000">Id</span><span style="color: #0000ff">="Help"</span> <span style="color: #ff0000">Guid</span><span style="color: #0000ff">="170A4245-9DE3-4bd7-B68A-110000000003"</span><span style="color: #0000ff">&gt;</span></pre>
    
    <pre>        <span style="color: #0000ff">&lt;</span><span style="color: #800000">File</span>  <span style="color: #ff0000">Id</span><span style="color: #0000ff">='Reviews.pdf'</span> <span style="color: #ff0000">Name</span><span style="color: #0000ff">='Reviews.pdf'</span> <span style="color: #ff0000">Source</span><span style="color: #0000ff">='$(var.Help)Reviews.pdf'</span> <span style="color: #ff0000">DiskId</span><span style="color: #0000ff">='1'</span><span style="color: #0000ff">/&gt;</span></pre>
    
    <pre>      <span style="color: #0000ff">&lt;/</span><span style="color: #800000">Component</span><span style="color: #0000ff">&gt;</span></pre>
    
    <pre>      </pre>
    
    <pre>      <span style="color: #0000ff">&lt;</span><span style="color: #800000">Directory</span> <span style="color: #ff0000">Id</span><span style="color: #0000ff">='Help.Skin'</span> <span style="color: #ff0000">Name</span><span style="color: #0000ff">='Skin'</span><span style="color: #0000ff">&gt;</span></pre>
    
    <pre>        <span style="color: #0000ff">&lt;</span><span style="color: #800000">Component</span> <span style="color: #ff0000">Id</span><span style="color: #0000ff">="Help.Skin"</span> <span style="color: #ff0000">Guid</span><span style="color: #0000ff">="170A4245-9DE3-4bd7-B68A-110000000013"</span><span style="color: #0000ff">&gt;</span></pre>
    
    <pre>          <span style="color: #0000ff">&lt;</span><span style="color: #800000">File</span>  <span style="color: #ff0000">Id</span><span style="color: #0000ff">='Blank.htm'</span> <span style="color: #ff0000">Name</span><span style="color: #0000ff">='Blank.htm'</span> <span style="color: #ff0000">Source</span><span style="color: #0000ff">='$(var.Skin)Blank.htm'</span> <span style="color: #ff0000">DiskId</span><span style="color: #0000ff">='1'</span> <span style="color: #0000ff">/&gt;</span></pre>
    
    <pre>          <span style="color: #0000ff">&lt;</span><span style="color: #800000">File</span>  <span style="color: #ff0000">Id</span><span style="color: #0000ff">='BrowseSequences.htm'</span> <span style="color: #ff0000">Name</span><span style="color: #0000ff">='BrowseSequences.htm'</span> <span style="color: #ff0000">Source</span><span style="color: #0000ff">='$(var.Skin)BrowseSequences.htm'</span> <span style="color: #ff0000">DiskId</span><span style="color: #0000ff">='1'</span> <span style="color: #0000ff">/&gt;</span></pre>
    
    <pre>          <span style="color: #0000ff">&lt;</span><span style="color: #800000">File</span>  <span style="color: #ff0000">Id</span><span style="color: #0000ff">='Favorites.htm'</span> <span style="color: #ff0000">Name</span><span style="color: #0000ff">='Favorites.htm'</span> <span style="color: #ff0000">Source</span><span style="color: #0000ff">='$(var.Skin)Favorites.htm'</span> <span style="color: #ff0000">DiskId</span><span style="color: #0000ff">='1'</span> <span style="color: #0000ff">/&gt;</span></pre>
    
    <pre>          <span style="color: #0000ff">&lt;</span><span style="color: #800000">File</span>  <span style="color: #ff0000">Id</span><span style="color: #0000ff">='Index.htm'</span> <span style="color: #ff0000">Name</span><span style="color: #0000ff">='Index.htm'</span> <span style="color: #ff0000">Source</span><span style="color: #0000ff">='$(var.Skin)Index.htm'</span> <span style="color: #ff0000">DiskId</span><span style="color: #0000ff">='1'</span> <span style="color: #0000ff">/&gt;</span></pre>
    
    <pre>          ...</pre>
    
    <pre>        <span style="color: #0000ff">&lt;/</span><span style="color: #800000">Component</span><span style="color: #0000ff">&gt;</span></pre>
    
    <pre>      <span style="color: #0000ff">&lt;/</span><span style="color: #800000">Directory</span><span style="color: #0000ff">&gt;</span></pre>
    
    <pre>      </pre>
    
    <pre>      <span style="color: #0000ff">&lt;</span><span style="color: #800000">Directory</span> <span style="color: #ff0000">Id</span><span style="color: #0000ff">='Help.Data'</span> <span style="color: #ff0000">Name</span><span style="color: #0000ff">='Data'</span><span style="color: #0000ff">&gt;</span></pre>
    
    <pre>        <span style="color: #0000ff">&lt;</span><span style="color: #800000">Component</span> <span style="color: #ff0000">Id</span><span style="color: #0000ff">="Help.Data"</span> <span style="color: #ff0000">Guid</span><span style="color: #0000ff">="170A4245-9DE3-4bd7-B68A-110000000023"</span><span style="color: #0000ff">&gt;</span></pre>
    
    <pre>          <span style="color: #0000ff">&lt;</span><span style="color: #800000">File</span>  <span style="color: #ff0000">Id</span><span style="color: #0000ff">='Alias.xml'</span> <span style="color: #ff0000">Name</span><span style="color: #0000ff">='Alias.xml'</span> <span style="color: #ff0000">Source</span><span style="color: #0000ff">='$(var.Data)Alias.xml'</span> <span style="color: #ff0000">DiskId</span><span style="color: #0000ff">='1'</span> <span style="color: #0000ff">/&gt;</span></pre>
    
    <pre>          ...</pre>
    
    <pre>        <span style="color: #0000ff">&lt;/</span><span style="color: #800000">Component</span><span style="color: #0000ff">&gt;</span></pre>
    
    <pre>      <span style="color: #0000ff">&lt;/</span><span style="color: #800000">Directory</span><span style="color: #0000ff">&gt;</span></pre>
    
    <pre>    <span style="color: #0000ff">&lt;/</span><span style="color: #800000">DirectoryRef</span><span style="color: #0000ff">&gt;</span></pre>
    
    <pre>&#160;</pre>
    
    <pre>  <span style="color: #0000ff">&lt;/</span><span style="color: #800000">Fragment</span><span style="color: #0000ff">&gt;</span></pre>
    
    <pre><span style="color: #0000ff">&lt;/</span><span style="color: #800000">Wix</span><span style="color: #0000ff">&gt;</span></pre></p>
  </div>
</div>

At the top I define a component group which in turn is then referenced in the main .wxs file by its it (here ‘Help’). Below I define the components with their content. In this case I want to install some files in a **Help** subfolder of the installation folder. The help subfolder in turn has two child folders **Skin** and **Data** which in turn will contain other files. The whole definition is wrapped by a Fragment tag.

#### Merge Module

Merge modules are used to deliver shared code, files, resources, registry entries, and setup logic to applications as a single compound file.However, a merge module cannot be installed alone, it must be merged into an installation package.&#160; A very basic module definition is given below

<div>
  <div>
    <pre><span style="color: #0000ff">&lt;?</span><span style="color: #800000">xml</span> <span style="color: #ff0000">version</span><span style="color: #0000ff">='1.0'</span>?<span style="color: #0000ff">&gt;</span></pre>
    
    <pre>&#160;</pre>
    
    <pre><span style="color: #0000ff">&lt;</span><span style="color: #800000">Wix</span> <span style="color: #ff0000">xmlns</span><span style="color: #0000ff">='http://schemas.microsoft.com/wix/2006/wi'</span><span style="color: #0000ff">&gt;</span></pre>
    
    <pre>   <span style="color: #0000ff">&lt;</span><span style="color: #800000">Module</span> <span style="color: #ff0000">Id</span><span style="color: #0000ff">='TestModule'</span> <span style="color: #ff0000">Language</span><span style="color: #0000ff">='1033'</span> <span style="color: #ff0000">Version</span><span style="color: #0000ff">='1.0.0.0'</span><span style="color: #0000ff">&gt;</span></pre>
    
    <pre>     </pre>
    
    <pre>      <span style="color: #0000ff">&lt;</span><span style="color: #800000">Package</span> <span style="color: #ff0000">Id</span><span style="color: #0000ff">='170A4245-9DE3-4bd7-B68A-100000000000'</span> </pre>
    
    <pre>               <span style="color: #ff0000">Description</span><span style="color: #0000ff">='Basic Merge Module'</span>                </pre>
    
    <pre>               <span style="color: #ff0000">Comments</span><span style="color: #0000ff">='A basic Windows Installer Merge Module'</span></pre>
    
    <pre>               <span style="color: #ff0000">Manufacturer</span><span style="color: #0000ff">='TOPAZ Techonlogies'</span> </pre>
    
    <pre>               <span style="color: #ff0000">InstallerVersion</span><span style="color: #0000ff">='200'</span> <span style="color: #0000ff">/&gt;</span></pre>
    
    <pre> </pre>
    
    <pre>      <span style="color: #0000ff">&lt;</span><span style="color: #800000">Directory</span> <span style="color: #ff0000">Id</span><span style="color: #0000ff">='TARGETDIR'</span> <span style="color: #ff0000">Name</span><span style="color: #0000ff">='SourceDir'</span><span style="color: #0000ff">&gt;</span></pre>
    
    <pre>         <span style="color: #0000ff">&lt;</span><span style="color: #800000">Directory</span> <span style="color: #ff0000">Id</span><span style="color: #0000ff">='MyModuleDirectory'</span> <span style="color: #ff0000">Name</span><span style="color: #0000ff">='.'</span><span style="color: #0000ff">&gt;</span></pre>
    
    <pre>            <span style="color: #0000ff">&lt;</span><span style="color: #800000">Component</span> <span style="color: #ff0000">Id</span><span style="color: #0000ff">='MyModuleComponent'</span> <span style="color: #ff0000">Guid</span><span style="color: #0000ff">='170A4245-9DE3-4bd7-B68A-100000000001'</span><span style="color: #0000ff">&gt;</span></pre>
    
    <pre>               <span style="color: #0000ff">&lt;</span><span style="color: #800000">File</span> <span style="color: #ff0000">Id</span><span style="color: #0000ff">='readme2'</span> <span style="color: #ff0000">Name</span><span style="color: #0000ff">='readme2.txt'</span> <span style="color: #ff0000">Source</span><span style="color: #0000ff">='readme2.txt'</span> <span style="color: #0000ff">/&gt;</span></pre>
    
    <pre>            <span style="color: #0000ff">&lt;/</span><span style="color: #800000">Component</span><span style="color: #0000ff">&gt;</span></pre>
    
    <pre>         <span style="color: #0000ff">&lt;/</span><span style="color: #800000">Directory</span><span style="color: #0000ff">&gt;</span></pre>
    
    <pre>      <span style="color: #0000ff">&lt;/</span><span style="color: #800000">Directory</span><span style="color: #0000ff">&gt;</span></pre>
    
    <pre>     </pre>
    
    <pre>   <span style="color: #0000ff">&lt;/</span><span style="color: #800000">Module</span><span style="color: #0000ff">&gt;</span></pre>
    
    <pre><span style="color: #0000ff">&lt;/</span><span style="color: #800000">Wix</span><span style="color: #0000ff">&gt;</span></pre></p>
  </div>
</div>

The above merge module just installs a single file ‘readme2.txt’ into the target directory. The main difference between the wxs file of an normal install and the wxs file of a merge module is that the former has a <Product> tag whereas the latter has a <Module> tag.

### Standard Actions

There are many standard actions available but not scheduled by default. **ScheduleReboot**, for instance, will instruct the user to reboot after the installation:

<div>
  <div>
    <pre><span style="color: #0000ff">&lt;</span><span style="color: #800000">InstallExecuteSequence</span><span style="color: #0000ff">&gt;</span></pre>
    
    <pre>  <span style="color: #0000ff">&lt;</span><span style="color: #800000">ScheduleReboot</span> <span style="color: #ff0000">After</span><span style="color: #0000ff">='InstallFinalize'</span> <span style="color: #0000ff">/&gt;</span></pre>
    
    <pre><span style="color: #0000ff">&lt;/</span><span style="color: #800000">InstallExecuteSequence</span><span style="color: #0000ff">&gt;</span></pre></p>
  </div>
</div>

If the need to reboot depends on a condition (for instance, the operating system the installer is running on), we can use a condition:

<div>
  <pre><span style="color: #0000ff">&lt;</span><span style="color: #800000">InstallExecuteSequence</span><span style="color: #0000ff">&gt;</span></pre>
  
  <pre>  <span style="color: #0000ff">&lt;</span><span style="color: #800000">ScheduleReboot</span> <span style="color: #ff0000">After</span><span style="color: #0000ff">='InstallFinalize'</span><span style="color: #0000ff">&gt;</span>VersionNT = 400<span style="color: #0000ff">&lt;/</span><span style="color: #800000">ScheduleReboot</span><span style="color: #0000ff">&gt;</span></pre>
  
  <pre><span style="color: #0000ff">&lt;/</span><span style="color: #800000">InstallExecuteSequence</span><span style="color: #0000ff">&gt;</span></pre>
</div>

A reboot will be required if the OS is Windows NT 4.0.

### Custom Actions

It&#8217;s not only these so-called standard actions that you can schedule and re-schedule. There are a couple of custom actions as well (custom here means that they don&#8217;t appear in the standard course of events but we can use them wherever and whenever we like). A very common need is to launch the application we have just installed or to show a readme.txt file in Notepad.exe at the end of the installation? To do the latter we just add the following code to the .wxs file

<div>
  <div>
    <pre><span style="color: #008000">&lt;!-- show the readme.txt file at the end of the installation --&gt;</span></pre>
    
    <pre><span style="color: #0000ff">&lt;</span><span style="color: #800000">Property</span> <span style="color: #ff0000">Id</span><span style="color: #0000ff">='NOTEPAD'</span><span style="color: #0000ff">&gt;</span>Notepad.exe<span style="color: #0000ff">&lt;/</span><span style="color: #800000">Property</span><span style="color: #0000ff">&gt;</span></pre>
    
    <pre><span style="color: #0000ff">&lt;</span><span style="color: #800000">CustomAction</span> <span style="color: #ff0000">Id</span><span style="color: #0000ff">='LaunchFile'</span> <span style="color: #ff0000">Property</span><span style="color: #0000ff">='NOTEPAD'</span> <span style="color: #ff0000">ExeCommand</span><span style="color: #0000ff">='[SourceDir]readme.txt'</span> <span style="color: #ff0000">Return</span><span style="color: #0000ff">='asyncNoWait'</span> <span style="color: #0000ff">/&gt;</span></pre>
    
    <pre>&#160;</pre>
    
    <pre><span style="color: #0000ff">&lt;</span><span style="color: #800000">InstallExecuteSequence</span><span style="color: #0000ff">&gt;</span></pre>
    
    <pre>  <span style="color: #0000ff">&lt;</span><span style="color: #800000">Custom</span> <span style="color: #ff0000">Action</span><span style="color: #0000ff">='LaunchFile'</span> <span style="color: #ff0000">After</span><span style="color: #0000ff">='InstallFinalize'</span><span style="color: #0000ff">&gt;</span>NOT Installed<span style="color: #0000ff">&lt;/</span><span style="color: #800000">Custom</span><span style="color: #0000ff">&gt;</span></pre>
    
    <pre><span style="color: #0000ff">&lt;/</span><span style="color: #800000">InstallExecuteSequence</span><span style="color: #0000ff">&gt;</span></pre></p>
  </div>
</div>

The “NOT Installed” condition means that the action is only executed if the product has not already been installed at a previous time.

### Features

When installing an application we usually are presented with a list of features we can install. Some of them are mandatory and some of them are optional. The list 

<div>
  <div>
    <pre><span style="color: #0000ff">&lt;</span><span style="color: #800000">Feature</span> <span style="color: #ff0000">Id</span><span style="color: #0000ff">='Complete'</span></pre>
    
    <pre>         <span style="color: #ff0000">Title</span><span style="color: #0000ff">='TOPAZ Enterprise 6.0'</span> </pre>
    
    <pre>         <span style="color: #ff0000">Description</span><span style="color: #0000ff">='The complete package'</span> </pre>
    
    <pre>         <span style="color: #ff0000">Display</span><span style="color: #0000ff">='expand'</span></pre>
    
    <pre>         <span style="color: #ff0000">ConfigurableDirectory</span><span style="color: #0000ff">='INSTALLDIR'</span></pre>
    
    <pre>         <span style="color: #ff0000">Level</span><span style="color: #0000ff">='1'</span><span style="color: #0000ff">&gt;</span></pre>
    
    <pre>    ...</pre>
    
    <pre><span style="color: #0000ff">&lt;/</span><span style="color: #800000">Feature</span><span style="color: #0000ff">&gt;</span></pre></p>
  </div>
</div>

Please note the attribute **ConfigurableDirectory** which defines the directory that can be configured by the user during setup. In our case this would be the INSTALLDIR which by default points to the sub-folder “TOPAZ TE6” of the program files folder (refer to chapter: the main installation file).

The attribute Level=’1’ indicates that this feature is included in the typical installation.

The features can be (hierarchically) nested. That is each feature can have as many child features as needed. Inside a feature tag we have to reference the components, component groups or merge modules which pertain to the said feature. E.g.

<div>
  <div>
    <pre><span style="color: #0000ff">&lt;</span><span style="color: #800000">Feature</span> <span style="color: #ff0000">Id</span><span style="color: #0000ff">='Core'</span> <span style="color: #ff0000">Title</span><span style="color: #0000ff">='Core'</span> <span style="color: #ff0000">Level</span><span style="color: #0000ff">='1'</span><span style="color: #0000ff">&gt;</span></pre>
    
    <pre>  <span style="color: #0000ff">&lt;</span><span style="color: #800000">ComponentRef</span> <span style="color: #ff0000">Id</span><span style="color: #0000ff">='Backup'</span> <span style="color: #0000ff">/&gt;</span></pre>
    
    <pre>  ...</pre>
    
    <pre>  <span style="color: #0000ff">&lt;</span><span style="color: #800000">ComponentGroupRef</span> <span style="color: #ff0000">Id</span><span style="color: #0000ff">='Help'</span> <span style="color: #0000ff">/&gt;</span></pre>
    
    <pre>  ...</pre>
    
    <pre>  <span style="color: #0000ff">&lt;</span><span style="color: #800000">MergeRef</span> <span style="color: #ff0000">Id</span><span style="color: #0000ff">='MyModule'</span> <span style="color: #0000ff">/&gt;</span></pre>
    
    <pre><span style="color: #0000ff">&lt;/</span><span style="color: #800000">Feature</span><span style="color: #0000ff">&gt;</span></pre></p>
  </div>
</div>

In the above case the feature ‘**Core’** would contain the component **Backup**, the component group **Help** and the merge module **MyModule** amongst others.

### Compile and link the installation package</p> </p> </p> </p> 

The creation of an .msi package is a two step process. First we have to compile the .wxs and .wxi files and then link them. The compiler is called candle.exe and the linker light.exe.

Assuming we only have one .wsx file called **Product.wxs** and we use functionality of the two extensions **IISExtension** and **WixUtilExtension** the creation would be

<div>
  <div>
    <pre>candle.exe Product.wxs -ext IISExtension -ext WixUtilExtension</pre>
    
    <pre>light.exe Product.wixobj -ext IISExtension -ext WixUtilExtension</pre></p>
  </div>
</div></p> 

which results in a **Product.msi** file.

If our Product.wxs file references components or component groups defined in another fragment file (e.g. called FramgmentHelp.wxs) then our calls have to be modified as follows

<div>
  <div>
    <pre>candle.exe Product.wxs FragmentHelp.wxs -ext IISExtension -ext WixUtilExtension</pre>
    
    <pre>light.exe Product.wixobj FragmentHelp.wixobj –out Product.msi -ext IISExtension -ext WixUtilExtension</pre></p>
  </div>
</div>

Please note the **“–out Product.msi**” part of the second command. Since we have more than one input file for the linker we have to define the name for the output file.

If we have many include- and fragment files and/or merge modules to include in our compile and link process then we can also define a (text) file from where the candle.exe and the light.exe take their input and thus our commands will be

<div>
  <div>
    <pre>candle.exe @candleInput.txt</pre>
    
    <pre>light.exe @lightInput.txt</pre></p>
  </div>
</div>

### Dealing with many files

Our setup package contains many hundred files. It would be a tedious task to add them all manually to the respective wxs files. Unfortunately it is not possible to use file names with wildcards (IMHO this is one of the major disadvantages of WIX compared to NSIS). Each file has to be explicitly added to the setup. Thus I decided to write a small application that automatically creates those entries for me.

Starting from a given base directory the program loops through all files and recursively through all sub-folders and creates the appropriate XML fragments. Having a directory structure like this

<div>
  <div>
    <pre>ParentFolder</pre>
    
    <pre>    File1</pre>
    
    <pre>    File2</pre>
    
    <pre>    ChildFolder1</pre>
    
    <pre>        File3</pre>
    
    <pre>        GrandChildFolder1</pre>
    
    <pre>            File4</pre>
    
    <pre>            File5</pre>
    
    <pre>    ChildFolder2</pre>
    
    <pre>        File6</pre></p>
  </div>
</div>

the application creates an XML fragment like this

<div>
  <div>
    <pre><span style="color: #0000ff">&lt;</span><span style="color: #800000">ComponentGroup</span> <span style="color: #ff0000">Id</span><span style="color: #0000ff">='ParentFolder'</span><span style="color: #0000ff">&gt;</span></pre>
    
    <pre>  <span style="color: #0000ff">&lt;</span><span style="color: #800000">ComponentRef</span> <span style="color: #ff0000">Id</span><span style="color: #0000ff">='ParentFolder'</span><span style="color: #0000ff">/&gt;</span></pre>
    
    <pre>  <span style="color: #0000ff">&lt;</span><span style="color: #800000">ComponentRef</span> <span style="color: #ff0000">Id</span><span style="color: #0000ff">='ParentFolder.ChildFolder1'</span><span style="color: #0000ff">/&gt;</span></pre>
    
    <pre>  <span style="color: #0000ff">&lt;</span><span style="color: #800000">ComponentRef</span> <span style="color: #ff0000">Id</span><span style="color: #0000ff">='ParentFolder.ChildFolder1.GrandChildFolder1'</span><span style="color: #0000ff">/&gt;</span></pre>
    
    <pre>  <span style="color: #0000ff">&lt;</span><span style="color: #800000">ComponentRef</span> <span style="color: #ff0000">Id</span><span style="color: #0000ff">='ParentFolder.ChildFolder2'</span><span style="color: #0000ff">/&gt;</span></pre>
    
    <pre><span style="color: #0000ff">&lt;/</span><span style="color: #800000">ComponentGroup</span><span style="color: #0000ff">&gt;</span></pre>
    
    <pre>&#160;</pre>
    
    <pre><span style="color: #0000ff">&lt;</span><span style="color: #800000">DirectoryRef</span> <span style="color: #ff0000">Id</span><span style="color: #0000ff">='ParentFolder'</span><span style="color: #0000ff">&gt;</span></pre>
    
    <pre>  <span style="color: #0000ff">&lt;</span><span style="color: #800000">Component</span> <span style="color: #ff0000">Id</span><span style="color: #0000ff">='ParentFolder'</span> <span style="color: #ff0000">Guid</span><span style="color: #0000ff">='...'</span><span style="color: #0000ff">&gt;</span></pre>
    
    <pre>    <span style="color: #0000ff">&lt;</span><span style="color: #800000">File</span> <span style="color: #ff0000">Id</span><span style="color: #0000ff">='...'</span> <span style="color: #ff0000">Name</span><span style="color: #0000ff">='File1'</span> <span style="color: #ff0000">Source</span><span style="color: #0000ff">='$(var.ParentFolder)File1'</span> <span style="color: #ff0000">DiskId</span><span style="color: #0000ff">='1'</span> <span style="color: #0000ff">/&gt;</span></pre>
    
    <pre>    <span style="color: #0000ff">&lt;</span><span style="color: #800000">File</span> <span style="color: #ff0000">Id</span><span style="color: #0000ff">='...'</span> <span style="color: #ff0000">Name</span><span style="color: #0000ff">='File2'</span> <span style="color: #ff0000">Source</span><span style="color: #0000ff">='$(var.ParentFolder)File2'</span> <span style="color: #ff0000">DiskId</span><span style="color: #0000ff">='1'</span> <span style="color: #0000ff">/&gt;</span></pre>
    
    <pre>  <span style="color: #0000ff">&lt;/</span><span style="color: #800000">Component</span><span style="color: #0000ff">&gt;</span></pre>
    
    <pre>  <span style="color: #0000ff">&lt;</span><span style="color: #800000">Directory</span> <span style="color: #ff0000">Id</span><span style="color: #0000ff">='ParentFolder.ChildFolder1'</span> <span style="color: #ff0000">Name</span><span style="color: #0000ff">='ChildFolder1'</span><span style="color: #0000ff">&gt;</span></pre>
    
    <pre>    <span style="color: #0000ff">&lt;</span><span style="color: #800000">Component</span> <span style="color: #ff0000">Id</span><span style="color: #0000ff">='ParentFolder.ChildFolder1'</span> <span style="color: #ff0000">Guid</span><span style="color: #0000ff">='...'</span><span style="color: #0000ff">&gt;</span></pre>
    
    <pre>      <span style="color: #0000ff">&lt;</span><span style="color: #800000">File</span> <span style="color: #ff0000">Id</span><span style="color: #0000ff">='...'</span> <span style="color: #ff0000">Name</span><span style="color: #0000ff">='File3'</span> <span style="color: #ff0000">Source</span><span style="color: #0000ff">='$(var.ParentFolder)ChildFolder1File3'</span> <span style="color: #ff0000">DiskId</span><span style="color: #0000ff">='1'</span> <span style="color: #0000ff">/&gt;</span></pre>
    
    <pre>    <span style="color: #0000ff">&lt;/</span><span style="color: #800000">Component</span><span style="color: #0000ff">&gt;</span></pre>
    
    <pre>    <span style="color: #0000ff">&lt;</span><span style="color: #800000">Directory</span> <span style="color: #ff0000">Id</span><span style="color: #0000ff">='ParentFolder.ChildFolder1.GrandChildFolder1'</span> <span style="color: #ff0000">Name</span><span style="color: #0000ff">='GrandChildFolder1'</span><span style="color: #0000ff">&gt;</span></pre>
    
    <pre>      <span style="color: #0000ff">&lt;</span><span style="color: #800000">Component</span> <span style="color: #ff0000">Id</span><span style="color: #0000ff">='ParentFolder.ChildFolder1.GrandChildFolder1'</span> <span style="color: #ff0000">Guid</span><span style="color: #0000ff">='...'</span><span style="color: #0000ff">&gt;</span></pre>
    
    <pre>        <span style="color: #0000ff">&lt;</span><span style="color: #800000">File</span> <span style="color: #ff0000">Id</span><span style="color: #0000ff">='...'</span> <span style="color: #ff0000">Name</span><span style="color: #0000ff">='File4'</span> <span style="color: #ff0000">Source</span><span style="color: #0000ff">='$(var.ParentFolder)ChildFolder1GrandChildFolder1File4'</span> <span style="color: #ff0000">DiskId</span><span style="color: #0000ff">='1'</span> <span style="color: #0000ff">/&gt;</span></pre>
    
    <pre>        <span style="color: #0000ff">&lt;</span><span style="color: #800000">File</span> <span style="color: #ff0000">Id</span><span style="color: #0000ff">='...'</span> <span style="color: #ff0000">Name</span><span style="color: #0000ff">='File5'</span> <span style="color: #ff0000">Source</span><span style="color: #0000ff">='$(var.ParentFolder)ChildFolder1GrandChildFolder1File5'</span> <span style="color: #ff0000">DiskId</span><span style="color: #0000ff">='1'</span> <span style="color: #0000ff">/&gt;</span></pre>
    
    <pre>      <span style="color: #0000ff">&lt;/</span><span style="color: #800000">Component</span><span style="color: #0000ff">&gt;</span></pre>
    
    <pre>    <span style="color: #0000ff">&lt;/</span><span style="color: #800000">Directory</span><span style="color: #0000ff">&gt;</span></pre>
    
    <pre>  <span style="color: #0000ff">&lt;/</span><span style="color: #800000">Directory</span><span style="color: #0000ff">&gt;</span></pre>
    
    <pre>  <span style="color: #0000ff">&lt;</span><span style="color: #800000">Directory</span> <span style="color: #ff0000">Id</span><span style="color: #0000ff">='ParentFolder.ChildFolder2'</span> <span style="color: #ff0000">Name</span><span style="color: #0000ff">='ChildFolder2'</span><span style="color: #0000ff">&gt;</span></pre>
    
    <pre>    <span style="color: #0000ff">&lt;</span><span style="color: #800000">Component</span> <span style="color: #ff0000">Id</span><span style="color: #0000ff">='ParentFolder.ChildFolder2'</span> <span style="color: #ff0000">Guid</span><span style="color: #0000ff">='...'</span><span style="color: #0000ff">&gt;</span></pre>
    
    <pre>      <span style="color: #0000ff">&lt;</span><span style="color: #800000">File</span> <span style="color: #ff0000">Id</span><span style="color: #0000ff">='...'</span> <span style="color: #ff0000">Name</span><span style="color: #0000ff">='File6'</span> <span style="color: #ff0000">Source</span><span style="color: #0000ff">='$(var.ParentFolder)ChildFolder2File6'</span> <span style="color: #ff0000">DiskId</span><span style="color: #0000ff">='1'</span> <span style="color: #0000ff">/&gt;</span></pre>
    
    <pre>    <span style="color: #0000ff">&lt;/</span><span style="color: #800000">Component</span><span style="color: #0000ff">&gt;</span></pre>
    
    <pre>  <span style="color: #0000ff">&lt;/</span><span style="color: #800000">Directory</span><span style="color: #0000ff">&gt;</span></pre>
    
    <pre><span style="color: #0000ff">&lt;/</span><span style="color: #800000">DirectoryRef</span><span style="color: #0000ff">&gt;</span></pre></p>
  </div>
</div>

where at the place of the ‘…’ the application puts a GUID. The code is really simple; it’s just a recursive walk through the directory structure and its files.

In the main wxs file I then just reference the component group e.g.

<div>
  <div>
    <pre><span style="color: #0000ff">&lt;</span><span style="color: #800000">ComponentGroupRef</span> <span style="color: #ff0000">Id</span><span style="color: #0000ff">='ParentFolder'</span> <span style="color: #0000ff">/&gt;</span></pre></p>
  </div>
</div>

## Nullsoft Scriptable Install System – NSIS

I will touch this framework only briefly since in the end we decided to take WIX for our purposes. Everything about NSIS (download and documentation) can be found [here](http://nsis.sourceforge.net/Main_Page).

> “… NSIS is a professional open source system to create Windows installers. It is designed to be as small and flexible as possible and is therefore very suitable for internet distribution. …
> 
> NSIS is script-based and allows you to create the logic to handle even the most complex installation tasks. Many plug-ins and scripts are already available: you can create web installers, communicate with Windows and other software components, install or update shared components and more. …”

NSIS is **NOT** based on the **Microsoft Windows Installer** technology! Thus no msi files are produced but rather exe files. My first impression of the product was very good. I especially liked the speed of an installation. Even complex installations take a fraction of the time a MS Windows Installer based installation needs.

### The Installer Script File

As said above NSIS is a script base install system. Our installation script we have to place in a file with the extension **nsi**.

Such a file can be compiled to a setup package with this simple command line

<div>
  <div>
    <pre>makensis.exe TOPAZ.nsi</pre></p>
  </div>
</div>

where **TOPAZ.nsi** contains our installation scripts. The compilation is very quick. The creation of a setup package can thus be very easily integrated in an automated build.

### Define Variables

We can define variables for further usage as follows

<div>
  <div>
    <pre>!define COMPANY <span style="color: #006080">"TOPAZ Technologies"</span></pre>
    
    <pre>!define COMPANYLEGAL <span style="color: #006080">"Ldt"</span></pre>
    
    <pre>!define URL <span style="color: #006080">"http://www.topazti.com"</span></pre>
    
    <pre>!define PRODUCT <span style="color: #006080">"TE6"</span></pre></p>
  </div>
</div>

we can also conditionally define a variable depending on the fact whether or not the variable has already been defined e.g. as a command line parameter when calling the NSIS make

<div>
  <div>
    <pre>!ifndef VERSION</pre>
    
    <pre>  !define VERSION <span style="color: #006080">"0.1.0"</span></pre>
    
    <pre>!endif</pre></p>
  </div>
</div>

later on a variable can be referenced by using the ${_VariableName_} syntax, e.g.

<div>
  <div>
    <pre>;Set <span style="color: #0000ff">default</span> installation folder</pre>
    
    <pre>InstallDir <span style="color: #006080">"$PROGRAMFILES${COMPANY}${PRODUCT}"</span></pre></p>
  </div>
</div>

This is very similar to what we are used from tools like [Nant](http://nant.sourceforge.net/).

Predefined variables are accessed with the syntax $_VariableName_; that is no curly braces are needed. An example would be

<pre>SetOutPath <span style="color: #006080">"$INSTDIR"</span></pre>

which sets the output directory to the content of the pre-defined variable INSTDIR.

### Sections

A nsi file consists of several sections. At least two of them are needed; one to define the install actions and one to define the un-install actions.

  * Each section contains zero or more instructions. 
  * Sections are executed in order by the resulting installer, and if ComponentText is set, the user will have the option of disabling/enabling each visible section. 
  * If a section&#8217;s name is &#8216;Uninstall&#8217; or is prefixed with &#8216;un.&#8217;, it&#8217;s an uninstaller section.

<div>
  <div>
    <pre>Section <span style="color: #006080">"Core"</span> SEC_CORE</pre>
    
    <pre>    ...</pre>
    
    <pre>    SetOutPath <span style="color: #006080">"$INSTDIR"</span></pre>
    
    <pre>    ...</pre>
    
    <pre>SectionEnd</pre></p>
  </div>
</div>

### Adding Files to the Setup Package

To add a single file to the setup package use a command similar to this

<div>
  <div>
    <pre>File readme.txt</pre></p>
  </div>
</div>

To add a whole tree of files (while maintaining the hierarchy) I use a command similar to this

<div>
  <div>
    <pre>File /r /x .svn /x index /x log ....build*.*</pre></p>
  </div>
</div>

The above command starts from a base directory (here a relative path ‘&#8230;.build\*.\*’) and traverses the whole sub-tree and adds all files found including their relative folders. By using the ‘/x _folderName’_ command line parameter I can exclude certain files or folders. _Compared to how much effort is needed with WIX to accomplish the same thing is is really a “killer feature”._

### Creating Directories on the target machine

to conditionally create a directory on the target machine I use the following syntax

<div>
  <div>
    <pre>IfFileExists $INSTDIRindex +2 0</pre>
    
    <pre>  CreateDirectory $INSTDIRindex</pre></p>
  </div>
</div>

### User Interface

There are several different UI available for the installer; standard, modern UI and ultra modern UI. In the sample we will use the modern UI. To use this UI we have to include the corresponding library with this command

<div>
  <div>
    <pre>!include <span style="color: #006080">"MUI2.nsh"</span></pre></p>
  </div>
</div>

later in the script file we have e.g.

<div>
  <div>
    <pre>!insertmacro MUI_PAGE_WELCOME</pre>
    
    <pre>!insertmacro MUI_PAGE_LICENSE <span style="color: #006080">".Eula.rtf"</span></pre>
    
    <pre>!insertmacro MUI_PAGE_COMPONENTS</pre>
    
    <pre>!insertmacro MUI_PAGE_DIRECTORY</pre>
    
    <pre>!insertmacro MUI_PAGE_INSTFILES</pre>
    
    <pre>&#160;</pre>
    
    <pre>!define MUI_FINISHPAGE_NOAUTOCLOSE</pre>
    
    <pre>!define MUI_FINISHPAGE_SHOWREADME <span style="color: #006080">"$INSTDIRreadme.txt"</span></pre>
    
    <pre>  </pre>
    
    <pre>!insertmacro MUI_PAGE_FINISH</pre>
    
    <pre>&#160;</pre>
    
    <pre>!insertmacro MUI_UNPAGE_WELCOME</pre>
    
    <pre>!insertmacro MUI_UNPAGE_CONFIRM</pre>
    
    <pre>!insertmacro MUI_UNPAGE_INSTFILES</pre>
    
    <pre>&#160;</pre>
    
    <pre>!define MUI_UNFINISHPAGE_NOAUTOCLOSE</pre>
    
    <pre>!insertmacro MUI_UNPAGE_FINISH</pre></p>
  </div>
</div>

The above fragment defines that we want to have a set of pages defined in the modern UI library included during our setup and during the uninstall of the product. Of course we should not forget to provide resources of the desired language used by the installer. This can be done by adding this statement

<div>
  <div>
    <pre>!insertmacro MUI_LANGUAGE <span style="color: #006080">"English"</span></pre></p>
  </div>
</div>

### Functions

We can define functions in our installer file. As an example I provide the function used to detect whether IIS is installed and whether it is at least IIS 6.0.

<div>
  <div>
    <pre>Function CheckIISVersion</pre>
    
    <pre> </pre>
    
    <pre>    ClearErrors</pre>
    
    <pre>    ReadRegDWORD $0 HKLM <span style="color: #006080">"SOFTWAREMicrosoftInetStp"</span> <span style="color: #006080">"MajorVersion"</span></pre>
    
    <pre>    ReadRegDWORD $1 HKLM <span style="color: #006080">"SOFTWAREMicrosoftInetStp"</span> <span style="color: #006080">"MinorVersion"</span></pre>
    
    <pre> </pre>
    
    <pre>    IfErrors 0 NoAbort</pre>
    
    <pre>    Abort <span style="color: #006080">"Setup could not detect Microsoft Internet Information Server v5 or later; this is required for installation. Setup will abort."</span></pre>
    
    <pre> </pre>
    
    <pre>    IntCmp $0 6 NoAbort IISMajVerLT6 NoAbort</pre>
    
    <pre> </pre>
    
    <pre>    NoAbort:</pre>
    
    <pre>        DetailPrint <span style="color: #006080">"Found Microsoft Internet Information Server v$0.$1"</span></pre>
    
    <pre>        Goto ExitFunction</pre>
    
    <pre> </pre>
    
    <pre>    IISMajVerLT6:</pre>
    
    <pre>        Abort <span style="color: #006080">"Setup could not detect Microsoft Internet Information Server v6 or later; this is required for installation. Setup will abort."</span></pre>
    
    <pre> </pre>
    
    <pre>    ExitFunction:</pre>
    
    <pre> </pre>
    
    <pre>FunctionEnd</pre></p>
  </div>
</div>

The script language is simple but powerful. It remembers a little bit the old days we still used to develop in assembler.

A function like the above one can then be called from a section of the installation file

<div>
  <div>
    <pre>Section <span style="color: #006080">"Install Virtual Directory"</span> SEC_IIS</pre>
    
    <pre>    Call CheckIISVersion</pre>
    
    <pre>    Call ...</pre>
    
    <pre>    ...</pre>
    
    <pre>SectionEnd</pre></p>
  </div>
</div>

### Register Product and prepare Uninstaller

NSIS does not automatically register an installed product on the system such as that it is visible in the list of installed products. We have to manually do this. I use the following section to just accomplish this task. The section creates some registry keys and finally creates an uninstaller exe in the install directory.

<div>
  <div>
    <pre>Section <span style="color: #006080">"-Common Items"</span> SEC_COM</pre>
    
    <pre>&#160;</pre>
    
    <pre>  ;Store installation folder</pre>
    
    <pre>  WriteRegStr HKCU <span style="color: #006080">"Software${COMPANY}${PRODUCT}"</span> <span style="color: #006080">""</span> $INSTDIR</pre>
    
    <pre>&#160;</pre>
    
    <pre>  ;Add uninstall information to Add/Remove Programs</pre>
    
    <pre>  WriteRegStr HKLM <span style="color: #006080">"SoftwareMicrosoftWindowsCurrentVersionUninstall${COMPANY} ${PRODUCT}"</span> </pre>
    
    <pre>                 <span style="color: #006080">"DisplayName"</span> <span style="color: #006080">"${COMPANY} ${PRODUCT}"</span></pre>
    
    <pre>  WriteRegStr HKLM <span style="color: #006080">"SoftwareMicrosoftWindowsCurrentVersionUninstall${COMPANY} ${PRODUCT}"</span> </pre>
    
    <pre>                 <span style="color: #006080">"URLInfoAbout"</span> <span style="color: #006080">"${URL}"</span></pre>
    
    <pre>  WriteRegStr HKLM <span style="color: #006080">"SoftwareMicrosoftWindowsCurrentVersionUninstall${COMPANY} ${PRODUCT}"</span> </pre>
    
    <pre>                 <span style="color: #006080">"Publisher"</span> <span style="color: #006080">"${COMPANY} ${COMPANYLEGAL}"</span></pre>
    
    <pre>  WriteRegStr HKLM <span style="color: #006080">"SoftwareMicrosoftWindowsCurrentVersionUninstall${COMPANY} ${PRODUCT}"</span> </pre>
    
    <pre>                 <span style="color: #006080">"DisplayVersion"</span> <span style="color: #006080">"${VERSION}"</span></pre>
    
    <pre>  WriteRegStr HKLM <span style="color: #006080">"SoftwareMicrosoftWindowsCurrentVersionUninstall${COMPANY} ${PRODUCT}"</span> </pre>
    
    <pre>                 <span style="color: #006080">"UninstallString"</span> <span style="color: #006080">"$"$INSTDIRuninstall.exe$""</span></pre>
    
    <pre>  </pre>
    
    <pre>  ;Create uninstaller</pre>
    
    <pre>  WriteUninstaller <span style="color: #006080">"$INSTDIRUninstall.exe"</span></pre>
    
    <pre>&#160;</pre>
    
    <pre>SectionEnd</pre></p>
  </div>
</div>

In my opinion this puts an unnecessary burden onto the shoulders of the developer since every single installed product has to be registered. Thus I would expect that this happens automatically. Also there is no such thing as an automatic repair functionality. Compared to WIX we have a clear disadvantage here.

## Summary

In this post I have shown in detail the various steps needed to create a setup package with WIX for a product consisting of many hundreds of files. The setup package also assigns write access for certain folders to specific users and/or groups. It creates a virtual directory for the application and defines a new application pool to which the virtual directory is assigned. Furthermore the setup creates a backup of pre-existing configuration files when upgrading a previous version of the product. The whole setup is fully transactional and can be changed or repaired at a later time. The product is ready for patches or upgrades if needed. I have also shown how the setup can be localized.

We use WIX to create our setup packages. WIX is free and open source. Some tasks could be simpler or more streamlined (like e.g. the usage of properties) and the documentation could be more detailed. Once all missing pieces of information are collected the creation of a setup package is straight forward and easy to do.

IMHO comparing NSIS with WIX is similar to comparing C++ (no .NET) with C# on .NET. With NSIS you have much more fine grain control of the installation process than with WIX. On the other hand you have to invest more time in providing such useful features as transactional install and repair functionality as well as fail-safe de-installation. This was the main reason that we finally decided to take WIX as our tool for the creation of setup packages. Still I think NSIS is a very powerful and mature product with lightening speed.