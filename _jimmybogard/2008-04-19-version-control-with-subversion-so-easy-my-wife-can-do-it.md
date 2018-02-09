---
wordpress_id: 170
title: 'Version control with Subversion: so easy my wife can do it'
date: 2008-04-19T17:06:00+00:00
author: Jimmy Bogard
layout: post
wordpress_guid: /blogs/jimmy_bogard/archive/2008/04/19/version-control-with-subversion-so-easy-my-wife-can-do-it.aspx
dsq_thread_id:
  - "264715644"
categories:
  - Tools
redirect_from: "/blogs/jimmy_bogard/archive/2008/04/19/version-control-with-subversion-so-easy-my-wife-can-do-it.aspx/"
---
Yes folks, it&#8217;s true.&nbsp; I have converted my wife to be a loyal Subversion user.&nbsp; My wife is not technical, not by a long shot.&nbsp; But the power of [Subversion](http://subversion.tigris.org/) and the simplicity of [TortoiseSVN](http://tortoisesvn.tigris.org/) made the convincing very easy.

![](http://grabbagoftimg.s3.amazonaws.com/caveman_2.jpg)

_Ed. note: that&#8217;s not my wife in the above screen.&nbsp; Please don&#8217;t get me in any **more** trouble than I already am.&nbsp; Thanks._

It wasn&#8217;t even that hard to convince her, either.&nbsp; She doesn&#8217;t do any development, but she has lots of files that need versioning.&nbsp; For example, this was her versioning system before Subversion:

![](http://grabbagoftimg.s3.amazonaws.com/scc_before.PNG)&nbsp;&nbsp; 

She would create many copies of a document, noting the date and sometimes a little comment describing the changes.&nbsp; I noticed that she would even do complex branching, creating new forks of documents where a sweeping change needed to be introduced, but not necessarily affect the &#8220;master&#8221; copy just yet.

### The setup

I mentioned earlier my wife isn&#8217;t technical, but she&#8217;s not a complete beginner around her laptop either.&nbsp; She is comfortable:

  * Organizing documents in her &#8220;My Documents&#8221; folder 
  * Creating, renaming and deleting files and folders 
  * Not spilling Starbucks onto her laptop 
  * Right-clicking to bring up the context menu

To use Subversion, all you really need is the ability to organize and right-click.&nbsp; If your significant other or tech-challenged friend don&#8217;t know what a context menu is, you might have to start at square zero.

I turned my wife onto source control by addressing some pretty common complaints:

  * Those she wrote these documents for changed their mind frequently, leading to a lot of wasted work and backtracking 
  * She would forget to create a new copy occasionally, and closing Word means she lost her &#8220;undo&#8221; history and therefore her starting point 
  * Managing the copies of documents is tedious and time-consuming, resulting in only creating new baseline documents or copies pretty rarely

It took my wife some time to perfect her copy-rename strategy, as before then she would work off of one copy only to be thoroughly defeated when she needed to undo changes and she had closed Word.

### The pitch

I&#8217;ve used source control for far more than just source code files.&nbsp; I&#8217;ve never been a fan of SharePoint, which in my experience is rarely used for more than a glorified file share.&nbsp; It can version documents, but the web interface for doing so is v-e-e-e-r-y clunky and primitive.&nbsp; It takes far too many clicks to edit a document, and even then you&#8217;re in a interface that wasn&#8217;t meant for file and folder browsing (the web).

Source control is perfect for situations where you want to save multiple revisions of a document and be able to restore older versions at any time.&nbsp; I showed my wife one of our trunks from work, where we keep **all project documents including source code** in a single repository.

I explained to her the concepts of a centralized change repository, and the idea of saving your document twice (once to save, once to commit the changes).

But the easiest pitch was to just show it in action.&nbsp; A simple demonstration showing real-world scenarios sealed the deal.

### Sealing the deal

With my wife, I set up a local Subversion repository and trunk.&nbsp; To eliminate the &#8220;magic&#8221;, I walked through these steps with her:

  * Installing Subversion 
  * Installing TortoiseSVN 
  * Creating a local repository using TortoiseSVN 
  * Checking out the new repository using TortoiseSVN

For consistency&#8217;s sake, I checked out the new repository to a folder in her &#8220;My Documents&#8221;, calling it &#8220;Versioned Files&#8221;.&nbsp; A descriptive name helped her remember why this folder was special and had all of those new icons.&nbsp; With the icons TortoiseSVN provides, my wife could easily see if she had changes she needed to commit to the repository.

Next, we walked through a couple of scenarios she runs into frequently:

  * Making changes and setting a new &#8220;baseline&#8221; document 
  * Reverting changes to a previous version

In the first scenario, we walked through:

  * Creating documents and folders 
  * Committing the new documents and folders to the repository using TortoiseSVN 
  * Entering descriptive comments

And in the second scenario, we walked through:

  * Viewing the log, and seeing the changes and comments 
  * Reverting a change

To make it easy to commit changes, I created a shortcut on her Desktop to the &#8220;Versioned Files&#8221; folder.&nbsp; TortoiseSVN&#8217;s context menu works with shortcuts, so she is able to commit and revert straight from her desktop.

Finally, I let her drive some real-world scenarios to make sure she understood all of the concepts and details.&nbsp; She&#8217;s very happy with the results, and it has greatly simplified her document management.&nbsp; Any file that she wants to keep a history of, she drops it into her folder and commits the file to the repository.

### Zero-friction toolset

With any tool I use, in development or otherwise, the less friction it adds to my life, the more valuable it is to me.&nbsp; Any client I talk to, I&#8217;ll always recommend Subversion over any source control provider, simply because it introduces the least amount of friction of any source control provider I&#8217;ve used.&nbsp; I don&#8217;t have to open another application, open a web browser or open an IDE.&nbsp; It&#8217;s all right there in Explorer, in a simple and intuitive interface.

And if the client _still_ won&#8217;t believe me, it&#8217;s hard to argue against a source control provider so easy my wife can do it.&nbsp; Unless they believe a complicated interface implies a more powerful tool, there&#8217;s always [this list of companies](http://www.collab.net/customers/index.html) who are Subversion users.

Next project: get my dad to use Subversion for his Fortran programs&#8230;