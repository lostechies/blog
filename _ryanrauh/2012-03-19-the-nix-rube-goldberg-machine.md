---
id: 81
title: 'The *nix Rube Goldberg Machine!'
date: 2012-03-19T16:57:07+00:00
author: Ryan Rauh
layout: post
guid: http://lostechies.com/ryanrauh/?p=81
dsq_thread_id:
  - "616775304"
categories:
  - Uncategorized
---
# Learn your shell!

Since I&#8217;ve started at Dovetail in June the best tool I&#8217;ve sharpened is my command line skills. My first week at Dovetail we got a surprise visit from @bob_pace and while pairing with him I was amazed by how effective he was with the command line. Well that really motivated me to improve my own skills. 

I&#8217;m gonna run through some basic building blocks that are required to work with files in the command line. 

## `~> find` 

First step is finding the files you want to work with. 

* List all the files in your pwd (present working directory). This will list every file and directory and recursively from the
  
path you have specified

`~> find .`

* List all files with certain extension

`~> find . -name "*.js"`

* List only files and not directories

`~> find . -type f`

* Protip: If you suspect files will spaces in the name (try to never do this!)

`~> find . -type f -print0`

## `~> xargs` 

xargs is your favorite buddy/friend/pal when working will large lists of files. The only thing xargs does, is take whats piped into it and stick it on the end of the next command. 

Try it yourself

`~> find . -name "*.js" | echo` 

Whoops&#8230; WTF, there is no output. Now try

`~> find . -name "*.js" | xargs echo` 

See if put it at the end of the next piped command, simple right!?

## `~> grep` 

ZOMG! grep has changed my life&#8230; 

grep will search a line of input for with a regular expression that you provide it. If you pass it a file name it will search each line of the file and output any matches.

`~> echo "hello" | grep hello` 

See simple right!

The command line is all about chaining inputs and outputs, its magical! Lets do that.

For example if you are using nuget and you want to know what version of FubuMVC you are using

`~> find. -name "packages.config" | xargs grep -h FubuMVC\.References` 

## `~> sed` 

Now lets talk about whats \*really\* awesome about the command line. MUTHA !@#$in sed! stands for stream editor and its amazing. 

Back in the early days of using nuget, we got into a situation where it was adding multiple version of the same dependency in our package configs&#8230;. its was a pain in the ass! Mostly due to the fact we have 30 projects and a lot of them are bottles that are not loaded with the core products solution file. Well if you are using the Visual Studio nuget manager fail sauce POS it would get all messed up and start putting extra references in the package configs. When we switched to our own tool to manage this madness, [ripple](https://github.com/DarthFubuMVC/ripple) it got all sorts of messed up.

So sed to the rescue! So the great thing about the command line is that you can fine tune your command before you actually go through with it

`~> find. -name "packages.config" | xargs grep -h FubuMVC\.References | sed d` 

Bam that should return no output, you are telling sed to delete any line that is passed to it. Now lets say that all of your project have two references to Fubu 0.9.2.722 and 0.9.3.731 and you want to delete the lower one. Lets practice first. 

`~> find. -name "packages.config" | xargs grep -h FubuMVC\.References | sed /FubuMVC\.Reference\..*722/d` 

That should only output the higher version of the two versions. Now that we know it works&#8230; we can put it all together and get destructive. We will just tweek our current command a little. Switch the grep flag to -l (lower case L), this will tell grep to output the filename only. Then we&#8217;ll need to pipe this to sed, but we&#8217;ll need to xargs it to the end since we want sed to modify the file. Then we&#8217;ll need to tell sed to delete the lines that contain the lower version number passing the flag -i will tell sed to modify the file in place.

`~> find. -name "packages.config" | xargs grep -l FubuMVC\.References | xargs sed -i /FubuMVC\.Reference\..*722/d` 

Bam! I just modified 30 files without opening any of them&#8230;. Like I said its the best thing I&#8217;ve learned my entire career!

Herp it don&#8217;t Derp it!

-Ryan