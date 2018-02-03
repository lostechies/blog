---
wordpress_id: 3168
title: Separating Subversion Repositories using svndumpfilter
date: 2008-03-13T12:00:56+00:00
author: Sean Chambers
layout: post
wordpress_guid: /blogs/sean_chambers/archive/2008/03/13/separating-subversion-repositories-using-svndumpfilter.aspx
dsq_thread_id:
  - "262948011"
categories:
  - Uncategorized
---
About a year ago I setup a Ubuntu machine on an old P2 400 at home to use as a subversion repository. At the time I created one repository to house all of my projects. Over time I was adding more and more projects to it all under one master repository path. This was fine when there was 2 or 3 projects, but after growing to about 15 different projects, performing selective dumps and repository maintenance in general becomes a little cumbersome. I recently decided to break out the large repositories into their own repositories under the same subversion path (/var/svn/project). The original large repository was located at (/var/svn/repos). 

The idea here is that we will first dump the entire repository, and then pipe the output of the dump command to svndumpfilter which will extract only the path that we want. These two commands together is all that is needed to perform selective filtering of paths within a subversion repository and then dump the resulting output to the project.dump file. Unfortunately the svndumpfilter can only take either include or exclude in a command but not both, this limits it&#8217;s usage in advanced scenarios, although it will work for what we are wanting to do here. Easy enough. 

With some piping we can perform all of this in one step: 

> _sean@svnbox:/var/svn$ sudo sh -c &#8216;sudo svnadmin dump /var/svn/repos | svndumpfilter include projectfolder > project.dump&#8217;_ 

The reason for the sudo sh -c &#8221; part, is so the piping of output of dump can be directed to master.dump with superuser permissions. In ubuntu everything is done with sudo instead of switching to root using su, therefore the first part of the command is evaluated using sudo, but the output being piped is evaluated using privileges of the shell. To make a long story short, if you are using ubuntu, you need to execute the command in it&#8217;s own context thus, wrapping the command in it&#8217;s own shell. If you were using any other distribution you could first switch to a root shell using su, then do the above command with the sh part. 

Now we can create the new repository, and load our filtered dumpfile into the new repository 

> _sean@svnbox:/var/svn$ sudo svnadmin create /var/svn/project | sudo svnadmin load project < project.dump_

The only thing that stinks now, is that since the single repository had a folder for each project, the project.dump now has a single folder in the root that is named project. To fix this, you just need to move your branches,tags and trunk folders into the root manually using svn mv or with tortoisesvn. 

In my case, I also had to edit /etc/apache2/mods-enabled/dav_svn.conf in order to accomodate the seperate repositories by adding the following: 

> \# from /etc/apache2/mods-enabled/dav_svn.conf 
> 
> \# Remove/Comment out SVNPath  
> \# SVNPath /var/svn/repos 

> \# Added SVNParentPath  
> SVNParentPath /var/svn 

SVNParentPath tells apache that there are multiple repositories hosted under /var/svn and that should be considered the root of your <Location> tag in the dav_svn.conf file. Clear as mud? 

In the future I will definately think twice about creating everything into one master repository, at the time I was just learning subversion and got started the quick and dirty way. In some cases however, it may make sense to have everything under one repository rather then break it out seperately. 

Hopefully this points someone in the right direction. Most of the above is documented very well in the SVN Book, so finding documentation on the above procedures and svndumpfilter should be easy.