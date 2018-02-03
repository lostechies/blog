---
wordpress_id: 4575
title: Deploying .NET Applications – Learning MSBuild and ClickOnce
date: 2009-03-13T19:56:50+00:00
author: Mo Khan
layout: post
wordpress_guid: /blogs/mokhan/archive/2009/03/13/deploying-net-applications-learning-msbuild-and-clickonce.aspx
categories:
  - Books
---
I recently finished reading…

<table>
  <tr>
    <td>
      <a href="http://www.amazon.com/gp/product/1590596528?ie=UTF8&tag=mokhthliofawa-20&linkCode=as2&camp=1789&creative=9325&creativeASIN=1590596528"><img src="https://images-na.ssl-images-amazon.com/images/I/51v5h50rHaL._SL160_.jpg" border="0" /></a><img style="margin: 0px;border-top-style: none! important;border-right-style: none! important;border-left-style: none! important;border-bottom-style: none! important" height="1" alt="" src="http://www.assoc-amazon.com/e/ir?t=mokhthliofawa-20&l=as2&o=1&a=1590596528" width="1" border="0" />
    </td>
    
    <td>
      <a href="http://www.amazon.com/gp/product/1590596528?ie=UTF8&tag=mokhthliofawa-20&linkCode=as2&camp=1789&creative=9325&creativeASIN=1590596528">Deploying .NET Applications: Learning MSBuild and ClickOnce (Expert&#8217;s Voice in .Net)</a><img style="margin: 0px;border-top-style: none! important;border-right-style: none! important;border-left-style: none! important;border-bottom-style: none! important" height="1" alt="" src="http://www.assoc-amazon.com/e/ir?t=mokhthliofawa-20&l=as2&o=1&a=1590596528" width="1" border="0" />
    </td>
  </tr>
</table>

I was interested in this book mainly to find an easier way to deploy ClickOnce applications via an automated build. Most of my build automation experience has been with Nant, so I figured learning MSBuild couldn’t hurt.

This book targets the Visual Studio 2005 time frame, so some of the things that it describes is out dated, mainly in regards to ClickCnce.

There was a little coverage on mage.exe but not as much as I had liked. If you’re looking for a book to get you into the world of Clickonce or MSBuild, this one’s pretty good!

Here are some of the things that I learned straight from the book. 

### MSBuild

Microsoft.Build.Framework and Microsoft.Build.Utilities contains some stuff to help you with your builds. There’s an ITask interface and a Task base class that you can implement if you want to run some custom tasks from MSBuild.

ClickOnce is driven by two XML-based manifest files called the deployment manifest and the application manifest… 

  * Deployment manifest (.application) contains information specific to the deployment of the system. 
  * Application manifest (.manifest) captures information specific to version of the system. 

### ClickOnce Deployment

The ClickOnce technology also has a programmatic interface that you can use to customize deployment and updates. For example, if you have a plug-in where the core of the application is deployed initially and then users are allowed to choose optional features (plug-ins) and have them installed on demand, the ClickOnce API can help.

ClickOnce applications have to be deployed to a Web server, to a file server, and/or to removable media (such as CD/DVD). Moreover, you can deploy these applications in one of two modes: offline or online.

For applications that require finer-grained control over doing updates, application authors can use the ClickOnce APIs to customize installation and updates.

### Code Access Security (CAS)

  * Permission: The authority to do something. 
  * Permission set: A grouping of arbitrary permissions. 
  * Origin based Evidence: Where your code comes from determines what permissions your code gets. 
  * Content base evidence: Your code content is signed and has a publisher certificate, and that determines what permissions you get. 
  * Code Group: Associates evidence with a permission set 
  * Security Policy: Policies define a hierarchy of code groups. 

### On-Demand Download

ClickOnce offers a facility that called on-demand download. The idea is that you create groups of files and then use the ClickOnce APIs to download each group at runtime. The initial download is reduced to what is needs to be downloaded to run the application, and if a piece of functionality is not needed, it is not downloaded.

You can get the path to the Data directory via:

  * <div style="font-size: 14pt;background: black;color: white;font-family: consolas">
      <pre style="margin: 0px"><span style="color: yellow">AppDomain</span>.CurrentDomain.GetData(<span style="color: lime">"DataDirectory"</span>);</pre></p>
    </div>

  * <div style="font-size: 14pt;background: black;color: white;font-family: consolas">
      <pre style="margin: 0px"><span style="color: yellow">ApplicationDeployment</span>.CurrentDeployment.DataDirectory;</pre></p>
    </div>

  * <div style="font-size: 14pt;background: black;color: white;font-family: consolas">
      <pre style="margin: 0px"><span style="color: yellow">Application</span>.LocalUserAppDataPath;</pre></p>
    </div>