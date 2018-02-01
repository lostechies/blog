---
id: 132
title: 'The *nix Rube Goldberg Machine &#8211; for f in awesome'
date: 2012-04-03T23:14:29+00:00
author: Ryan Rauh
layout: post
guid: http://lostechies.com/ryanrauh/?p=132
dsq_thread_id:
  - "635592025"
categories:
  - Shell
tags:
  - bash
---
# Learn your shell! 

I can&#8217;t stress enough how important it is to learn what every shell program you prefer. cmd, bash, zsh, powershell, doesn&#8217;t matter pick one and learn it! There is endless productivity and general sanity to be gained by being able to rip out mini rube goldberg machines on a daily basis.

Lets walk through a &#8220;practical&#8221; example of using several commands to make a tedious job easier. Lets convert a bunch of css files into scss files only using the shell.

For the sake of interactivity create a test directory and dump a few css files into it.

 `~/lecode> mkdir f_in_awesome` 
  
 `~/lecode> cd f_in_awesome` 
  
 `~/lecode/f_in_awesome> for f in herp derp nerp blerp; do touch $f.css; done` 
  
Just a simple loop to create some tests files.

Now that we have some files lets practice building out a command to move them.

 `~/lecode/f_in_awesome> find . -maxdepth 1  -name "*.css"` 
  
Find all the css files in the current directory but don&#8217;t go into any subdirectories

Now turn that into a loop
  
 ``~/lecode/f_in_awesome>for f in `find . -maxdepth 1 -name "*.css" `; do echo $f; done`` 

Cool our loops correct now lets practice moving them, notice I said practice! I like to use echo to fine tune my Rube Goldberg machines before I set it off that way I get it right in [one take](http://www.youtube.com/watch?v=K2cYWfq--Nw).

First lets figure out how to get just the filename from the path.

 ``~/lecode/f_in_awesome>for f in `find . -name "*.css" -maxdepth 1`; do echo $(basename $f); done`` 
  
Cool $(basename &#8230;) is a function in bash that will return just the filename

 ``~/lecode/f_in_awesome>for f in `find . -name "*.css" -maxdepth 1`; do echo mv $(basename $f) scss/_${$(basename $f)%.*}.scss; done``
  
Now lets use substitution ${ %.*} to strip off the file extension so that we can change it to scss

Nice! Now remove echo and move them for realsies! 

 ``~/lecode/f_in_awesome>for f in `find . -name "*.css" -maxdepth 1`; do mv $(basename $f) scss/_${$(basename $f)%.*}.scss; done``

OOOPS! Forgot to make the directory

 `~/lecode/f_in_awesome>mkdir scss && !!`

OK! Couple new concepts there&#8230; This is the command line, you are gonna make mistakes! Thats why we have things like \`git reset &#8211;hard\`. Bash makes things nice, you can chain commands together with && and !! is a shortcut to (last command). So mkdir scss && !! will create our directory and run the last command.

We aren&#8217;t quite done. We created some sass partials, now we need to make an &#8220;application&#8221; file that imports all our partials.

 `~/lecode/f_in_awesome>cd scss`

Now lets practice again, I want to print out just the file name without the underscore and stream that into a file
  
 ``~/lecode/f_in_awesome/scss>for f in `find .  -name "_*.scss"`; do echo ${$(basename $f)##*_}; done``
  
Now lets use substitution ${ ##*\_} to take everything after the \_

 ``~/lecode/f_in_awesome/scss>for f in `find .  -name "_*.scss"`; do echo ${${$(basename $f)##*_}%.*}; done``

And then the same substitution we used before to strip off the extension.

 ``~/lecode/f_in_awesome/scss>for f in `find .  -name "_*.scss"`; do echo @import \"${${$(basename $f)##*_}%.*}\"\;; done``

Now add the @import syntax to make sass happy

 ``~/lecode/f_in_awesome/scss>for f in `find .  -name "_*.scss"`; do echo @import \"${${$(basename $f)##*_}%.*}\"\; >> application.scss; done``

Ooops! Forgot to touch the file!
  
 `~/lecode/f_in_awesome/scss>touch application.scss && !!`

There you have it! I was able to take our app from upwards of 40-60 really granular css files into nice sass partials in no time. Sass will even compress them which was a HUGE win on the performance of our latest release!

Can you imagine moving all those files with the file explorer, renaming all of them, then creating the import file by hand??? Hellz to the no! That&#8217;s why learning your shell will be the best things will will ever do!

Don&#8217;t Herp, Learn teh shell!

-Ryan