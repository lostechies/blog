---
id: 3148
title: Versioning with Cruise Control, Nant and Subversion
date: 2007-11-05T23:58:00+00:00
author: Sean Chambers
layout: post
guid: /blogs/sean_chambers/archive/2007/11/05/versioning-with-cruise-control-nant-and-subversion.aspx
dsq_thread_id:
  - "262262863"
categories:
  - svn nant cruisecontrol
---
I haven&#8217;t had a chance to post any of my other posts sitting in the queue lately with the newborn and all so I figured I would post this topic as it didn&#8217;t take long to perform the task at hand.


  


There are a slew of versioning options. I won&#8217;t even go into detail as to how many options you have. You could do date of the build, build number, SCM revision, the list goes on an on. A good discussion of your options have already be outlined by <A class="" href="http://www.codinghorror.com/blog/archives/000793.html" target="_blank">Jeff Atwood in this&nbsp;posting</A> at <A class="" href="http://www.codinghorror.com/" target="_blank">codinghorror.com</A>&nbsp;I chose to version like so:


  


&#8211; MajorNumber.MinorNumber.BuildNumber.RevisionNumber


  


So for instance: 1.5.182.5543 would be version 1.5, CC.Net build number 182 and SVN revision number 5543. Simple enough.


  


After reviewing all of my options I felt this was most relevant. This tells me what build and revision the assembly is from which gives me a pretty good review of what code i&#8217;m looking at. Date on the version number is redundant as I can look up the date of the revision in subversion.


  


Now, after reviewing a number of blog posts I found that there wasn&#8217;t many options to version CC.Net builds with a specific SVN revision number. It is possible to automatically generate the AssemblyInfo.cs file with Nant, but how would I get the SVN revision number? That&#8217;s what I came across <A class="" href="http://www.syntactic.org/2007/6/7/major-minor-cclabel-svn-revision" target="_blank">Eugene&#8217;s NAnt.SvnFunctions code</A>. I have placed the code I modified on my <A class="" href="http://schambers.googlecode.com/svn/trunk/NAnt.SvnFunctions/" target="_blank">Google Code Repository which you can find here</A>. Just checkout the code and compile. <A class="" href="http://www.syntactic.org/2007/6/7/major-minor-cclabel-svn-revision" target="_blank">The credit for the class goes to Eugen Anghel from Syntactic.org</A>. All this class is really doing is just wrapping some basic SVN command line calls and parsing the output to use as a return parameter


  


The function that I am using within his class&nbsp;from NAnt to get the SVN revision number is GetRevisionNumber(string path, string username, string password), since my SVN repository requires a username and password to access it. The original code did not have this capability. I also added IDictionary overloads to pass command line arguments to subversion.


  


Now, before I did any of the steps below you&nbsp;have to create a SolutionInfo.cs file as a Solution Item.&nbsp;I placed at least the&nbsp;AssemblyVersionAttribute in the file so you can have all of your projects reference this one SolutionInfo.cs. This will version all of your assemblies in your solution with the same version number. I used a static build number like 1.0.0.0 in the SolutionInfo.cs file. This way, if you see this version in any build, you will know that it is from a developer machine and not your build server.


  


Then in each of your projects, you have to remove the AssemblyVersion attribute from the AssemblyInfo.cs file&nbsp;so it does override the SolutionInfo.cs attribute. Within each project, you have to &#8220;Add an existing Item&#8221; > Select SolutionInfo.cs from your solution root and instead of&nbsp;clicking &#8220;Add&#8221;, you have to click the little arrow next to&nbsp;&#8220;Add&#8221; and choose &#8220;Add as link&#8221;. This will&nbsp;create a shortcut to&nbsp;SolutionInfo.cs. Once this is done for all projects, you can continue.&nbsp;


  


First compile the SvnFunctions class and place it on your build server somewhere. I place mine under the libtoolsnant folder. Then add a &#8220;loadtask&#8221; element to your nant build file like so:


  


&nbsp;<loadtasks assembly=&#8221;pathtolibtoolsnantNant.SvnFunctions.dll&#8221;/>


  


This gives us access to all the functions within SvnFunctions.cs. Next you have to add the asminfo task BEFORE you build your application in your nant build file. This is what mine looks like:


  


&nbsp;&nbsp;<asminfo output=&#8221;${build.dir}srcSolutionInfo.cs&#8221; language=&#8221;CSharp&#8221;>  
&nbsp;&nbsp;&nbsp;<attributes>  
&nbsp;&nbsp;&nbsp;&nbsp;<attribute type=&#8221;System.Reflection.AssemblyVersionAttribute&#8221; value=&#8221;1.5.${CCNetLabel}.${svn::get-revision-number(&#8216;http://SVN-Server/svn/someproject&#8217;, &#8216;svn\_username&#8217;, &#8216;svn\_password&#8217;)}&#8221;/>  
&nbsp;&nbsp;&nbsp;&nbsp;<attribute type=&#8221;System.Reflection.AssemblyCompanyAttribute&#8221; value=&#8221;SomeCompany&#8221; />  
&nbsp;&nbsp;&nbsp;&nbsp;<attribute type=&#8221;System.Reflection.AssemblyCopyrightAttribute&#8221; value=&#8221;Copyright &#8211;&nbsp;SomeCompany 2007&#8243; />  
&nbsp;&nbsp;&nbsp;</attributes>  
&nbsp;&nbsp;</asminfo>


  


As you can see, what we are doing here is first telling nant that we want it to generate the SolutionInfo.cs file. Then we define what attributes to place into the file. In my example we have AssemblyVersion, AssemblyCompany and AssemblyCopyright. You can place more or less, this is what was generic for me across all projects.


  


Notice in the AssemblyVersionAttribute we have 1.5.${CCNetLabel}. This places the CCNet Build number in ${CCNetLabel}. Then at the end we are calling the GetRevisionNumber method from the SvnFunctions class we compiled earlier passing in the repository address, username and password.


  


The next time you build, you will notice all output assemblies from your solution will be versioned with the appropriate cc.net build number and revision number. This gives you a clear paper trail to be able to track down problems in a production assembly. Pretty useful.


  


Thanks goes to Eugen Anghel that created the SvnFunction class to perform all the hard work. Please feel free to post problems you find or any questions you may have. Hope that helps someone!