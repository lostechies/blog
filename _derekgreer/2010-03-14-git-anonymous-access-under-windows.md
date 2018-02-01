---
id: 277
title: 'Git: Anonymous Access Under Windows'
date: 2010-03-14T21:28:09+00:00
author: Derek Greer
layout: post
guid: http://www.aspiringcraftsman.com/?p=277
dsq_thread_id:
  - "326075065"
categories:
  - Uncategorized
tags:
  - Git
---
The <a title="Git Version Control" href="http://git-scm.com/" target="_blank">Git </a>version control system provides a simple protocol for sharing Git repositories anonymously over a TCP port. This can be useful for providing read-only access to a repository, or for facilitating pull-based collaboration within teams. The following is a guide for setting up and sharing a Git repository anonymously under Windows using <a title="Cygwin" href="http://www.cygwin.com/" target="_blank">Cygwin</a>.

**Step 1:** Install <a title="Cygwin" href="http://www.cygwin.com/" target="_blank">Cygwin </a>with the cygrunsrv and desired git packages:

[<img class="alignnone size-full wp-image-278" src="http://www.aspiringcraftsman.com/wp-content/uploads/2010/03/cygwin-search-cygrunsrv-package.png" alt="" width="550" height="208" />](http://www.aspiringcraftsman.com/wp-content/uploads/2010/03/cygwin-search-cygrunsrv-package.png)

[<img class="alignnone size-full wp-image-279" src="http://www.aspiringcraftsman.com/wp-content/uploads/2010/03/cygwin-search-git-package.png" alt="" width="722" height="265" />](http://www.aspiringcraftsman.com/wp-content/uploads/2010/03/cygwin-search-git-package.png)

**Step 2:** Create a file named `gitd` in the `/usr/sbin` directory with the following content:

<pre>#!/bin/bash

git daemon --reuseaddr --base-path=/cygdrive/c/Projects
</pre>



<div class="theme-note">
  Notes:</p> 
  
  <p>
    By default, the git daemon only shares folders under the base path which contain a file named <code>git-daemon-export-ok</code>. If you wish to share all folders under the base path without requiring this file, use the switch <code>--export-all</code>.
  </p>
  
  <p>
    This command assumes the base path of all shared git repositories will be <code>/cygdrive/c/Projects/</code> (i.e. <code>C:Projects</code> under Windows). Change this value if your projects are stored in an alternate location.
  </p>
  
  <p>
    If you wish to enable anonymous push access to your repositories (not advisable), you can add the switch <code>--enable=receive-pack</code>.
  </p>
</div>



<div>
  <strong>Step 3:</strong> From a bash shell prompt, run the following <code>cygrunsrv</code> command to install the script as a service (Note: This command assumes Cygwin is installed at <code>C:Cygwin</code>):</p> 
  
  <pre>
cygrunsrv   --install gitd                        
            --path c:/cygwin/bin/bash.exe         
            --args c:/cygwin/usr/sbin/gitd        
            --desc "Git Daemon"                   
            --neverexits                          
            --shutdown
</pre>
</div>

**Step 4:** From a bash shell prompt, run the following command to start the service:

`cygrunsrv --start gitd`

The gitd service should now be running. To verify that everything is setup properly, here is a quick and dirty script which should establish that the desired repositories are remotely accessible:

<pre>#!/bin/bash

BASEDIR=/cygdrive/c/Projects
REPO_NAME=testapp$$
REPO_PATH=${BASEDIR}/${REPO_NAME}
REMOTE_PATH=${BASEDIR}/remote$$/

echo "Creating a local git repo ..."
mkdir -p ${REPO_PATH}
cd ${REPO_PATH}
git init
touch .git/git-daemon-export-ok
echo "Commiting test file ..."
touch testfile
git add -A
git commit -m 'Test message'

echo "Simulate remote clone ..."
mkdir ${REMOTE_PATH}
cd ${REMOTE_PATH}
git clone git://localhost/${REPO_NAME}

echo "Cleaning up test folders ..."
rm -rf ${REPO_PATH}
rm -rf ${REMOTE_PATH}
</pre>
