---
wordpress_id: 356
title: 'Git Branches: A Pointer, With History And Metadata'
date: 2011-05-23T20:29:36+00:00
author: Derick Bailey
layout: post
wordpress_guid: http://lostechies.com/derickbailey/?p=356
dsq_thread_id:
  - "312022239"
categories:
  - git
---
A few months ago, I had an &#8220;AHA!&#8221; moment working with git. I was doing one of my usual fixes for a mistake I had made and I had the realization that a named branch in git can be thought of as a pointer in C or C++ programming. I&#8217;d heard a number of people say similar things in the past, so it certainly wasn&#8217;t an original thought. However, it was an important realization for me and it has begun to influence the way I think about and work with git, and the way I approach teaching git.

 

### Pointers: A Location In Memory

Software systems run in memory, and memory can be accessed through various mechanisms including named variables. Sometimes we don&#8217;t want to access the memory as a data structure or object, though. Sometimes we want to access the location of the memory where the data structure or object exists. To do this, we use a pointer. A pointer is a named location in memory &#8211; a variable who&#8217;s contents are an address in memory. A pointer can also be moved around, too; it can change what it is pointing to.

Of course, this is an over simplification of pointers, purposely. There&#8217;s a lot of nuances to pointers that I don&#8217;t understand anymore (it&#8217;s been 15+ years since I&#8217;ve dealt with them). But the oversimplification gives us a starting point to work with for a perspective on git commits and branches.

 

### Branches: Named Pointers

Take a look at a typical timeline in a git repository, using GitK or GitX:

<img title="Screen shot 2011-05-23 at 8.47.38 PM.png" src="http://lostechies.com/content/derickbailey/uploads/2011/05/Screen-shot-2011-05-23-at-8.47.38-PM.png" border="0" alt="Screen shot 2011 05 23 at 8 47 38 PM" width="175" height="331" />

There&#8217;s nothing special or unusual here&#8230; just a series of commits on a few branches, eventually being merged together. I typically describe this layout as a mass-transit system. Each circle in a mass-transit system is a stop along a route. Each route is defined by colored lines. You can see routes diverging and coming back together &#8211; branches being created and being merged &#8211; flowing form oldest at the bottom to newest at the top. This perspective helps us understand the history of a git repository. We can see the timeline of commits, the divergence and convergence of branches, and how everything is related to everything else.

There are several branches in this screen shot &#8211; but none of them are named. Git knows that these branches exist because of the metadata associated with the various commits, creating divergence in two or more directions from a single commit. These are implicit branches in git and are not addressable as a &#8220;branch&#8221; in the conventional sense.

If you want an explicit branch in git, you need to have a named HEAD (or pointer) that points to the commit you want to address.

<img title="Screen shot 2011-05-23 at 9.03.08 PM.png" src="http://lostechies.com/content/derickbailey/uploads/2011/05/Screen-shot-2011-05-23-at-9.03.08-PM.png" border="0" alt="Screen shot 2011 05 23 at 9 03 08 PM" width="208" height="64" />

Each of the five labels in this screen shot is an explicit branch &#8211; a named pointer that is addressable as a &#8220;branch&#8221; in git, and points to a specific commit. Notice, though, that there are only two commits in this screen shot in spite of 5 named branches being shown. If you think of each of these named branches as a pointer variable, it starts to become a little more clear. We have 5 pointers. 3 of them point to the commit highlighted in the blue line and 2 of them point to a commit just below that one.

 

### Pointers Are Easy To Manipulate

In C/C++, pointers are easy to manipulate. You can assign / reassign the memory address that a pointer points to with very little effort. In git, you can also manipulate branches as if they were pointers. There are several ways to do this, too. You can use the git reset command, for example, to simply move a pointer from one location to another. To do this and to continue the analogy of pointers, think about a commit as a location in memory, and the commit ID is the address of that location.

<img title="Screen shot 2011-05-23 at 8.55.48 PM.png" src="http://lostechies.com/content/derickbailey/uploads/2011/05/Screen-shot-2011-05-23-at-8.55.48-PM1.png" border="0" alt="Screen shot 2011 05 23 at 8 55 48 PM" width="600" height="100" />

The selected commit in this screen shot would have an &#8220;address&#8221; of 5ec76a3&#8230; if we have an existing branch called &#8220;foo&#8221; and we want the foo branch to point to this commit, we can call git reset like this:

<pre>(foo) $: git reset 5ec76a3 --hard
HEAD is now at 5ec76a3 model and color code cardio, resistance and total exercise
</pre>

 

We now have our foo branch pointing at this commit.

<img title="Screen shot 2011-05-23 at 9.17.53 PM.png" src="http://lostechies.com/content/derickbailey/uploads/2011/05/Screen-shot-2011-05-23-at-9.17.53-PM.png" border="0" alt="Screen shot 2011 05 23 at 9 17 53 PM" width="600" height="99" />

There are several other commands that can manipulate pointers directly, too. Even the merge command will sometimes perform pointer manipulation on your branch instead of actually doing a merge. This is referred to as &#8220;tivo source control&#8221; or fast-forward merging. It happens when two branches are on the same timeline with no divergence, and the one that is further behind in the timeline is merged up to the one that is ahead in the timeline.

Additionally, most of the [&#8220;Oops!&#8221; series of posts](http://lostechies.com/derickbailey/category/git/) that I&#8217;ve done on git are nothing more than pointer manipulations in this manner. Not all of them of course, but many of them are.

 

### Analogies Fall Apart, But Branches Are Pointers

Like all analogies, eventually the idea of a branch being a pointer to a memory address will fall apart. Even if a branch is nothing more than a pointer, it doesn&#8217;t actually point to a memory location. it points to a commit ID. Once you wrap your head around the idea of a named branch being a pointer, though, the realization of what it is pointing to can open a world of possibilities for how you think about and approach the use of git&#8217;s branches.