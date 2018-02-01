---
id: 120
title: Application Root is your friend
date: 2008-01-03T18:17:35+00:00
author: Jimmy Bogard
layout: post
guid: /blogs/jimmy_bogard/archive/2008/01/03/application-root-is-your-friend.aspx
dsq_thread_id:
  - "264715478"
categories:
  - ASPdotNET
---
It still surprises me how many ASP.NET developers I run into don&#8217;t know about the different ways to construct path references in ASP.NET.&nbsp; Let&#8217;s say we want to include an image in our website.&nbsp; This image is hosted on our website, in an &#8220;img&#8221; subfolder off of the application root.&nbsp; So how do we create the image HTML, and what do we use as the URL?&nbsp; The wrong answer can lead to big-time maintenance headaches later.

There are three kinds of paths we can use:

  * Absolute
  * Relative
  * Application root (ASP.NET only)

Additionally, we have a few choices on how we chose to create the image in our ASP.NET page:

  * Plain ol&#8217; HTML
  * HTML server control
  * Web server control

Each kind of path can be used for each rendering object type (HTML, server control).&nbsp; It turns out that the path is much more important than the rendering object, as different forces might lend me to use controls over HTML.&nbsp; For posterity, I&#8217;ll just pick plain ol&#8217; HTML as an example.

### Absolute

Absolute paths are fully qualified URL paths that include the domain name in the URL:

<div class="CodeFormatContainer">
  <pre>&lt;img src=<span class="str">"http://localhost/EcommApp/img/blarg.jpg"</span> /&gt;</pre>
</div>

Absolute paths work great for external resources outside of my website, but are poor choices for internal resources.&nbsp; Typically ASP.NET development is done on a development machine, and deployed to a different machine, which means the URLs will most likely change.

For example, the URL above works on my local machine, but breaks when deployed to the server because the &#8220;EcommApp&#8221; now resides at the root, so I need a URL like &#8220;http://ecommapp.com/img/blarg.jpg&#8221;.&nbsp; Since this absolute path is different, my link breaks, and I have to make lots of changes going back and forth between production and development.&nbsp; For internal resources, absolute paths won&#8217;t work.

### Relative

Relative paths don&#8217;t specify the domain name, and come in a few flavors:

  * Site-root relative
  * Current page relative
  * Peer relative

These URL path notations are similar to file path notations.&nbsp; Each is slightly different and carries its own issues.

#### Site-root relative

Here&#8217;s the same img tag used before, now with a site-root relative path:

<div class="CodeFormatContainer">
  <pre>&lt;img src=<span class="str">"/EcommApp/img/blarg.jpg"</span> /&gt;</pre>
</div>

Note the lack of the domain name and the leading slash, that&#8217;s what makes this a site-root relative path.&nbsp; These paths are resolved against the current domain, which means I can go from &#8220;localhost&#8221; to &#8220;ecommapp.com&#8221; with ease.

Again, the problem I run into is that locally, my app is deployed off of an &#8220;EcommApp&#8221; folder, but on the server, it&#8217;s deployed at the root.&nbsp; My image breaks again, so site-root relative paths aren&#8217;t a great choice, either.

#### Current page relative

Now the img tag using a current page relative path:

<div class="CodeFormatContainer">
  <pre>&lt;img src=<span class="str">"img/blarg.jpg"</span> /&gt;</pre>
</div>

This time, I don&#8217;t have the leading slash, nor do I include the &#8220;EcommApp&#8221; folder.&nbsp; This is because current page relative paths are constructed off the URL being requested, which in this case is the &#8220;default.aspx&#8221; page at the root of the application.&nbsp; The request goes from the &#8220;default.aspx&#8221; path, wherever that might be.&nbsp; Now my URL does **not** have to change when I deploy to production, it works in both places.

But I have two problems now:

  * Moving the page means I have to change all of the resource URLs
  * Creating a page in a subfolder means all URLs to the same resource could be different

This leads me to the last kind of relative path.

#### Peer relative

Suppose I want to create the img tag in a site with the following structure:

  * Root
  * img
  * blarg.jpg

  * products
  * default.aspx

Note that default.aspx has to go up one node, then down one node to reference the file in the above tree.&nbsp; Here&#8217;s the img tag to do just that:

<div class="CodeFormatContainer">
  <pre>&lt;img src=<span class="str">"../img/blarg.jpg"</span> /&gt;</pre>
</div>

Similar to folder paths, I use the &#8220;..&#8221; operator to climb up one node in the path, then specify the rest of the path.&nbsp; This path works just fine in production and development, but I still have two main problems:

  * URLs to the same resource are different depending on depth of the source file in the tree
  * Moving a resource forces me to manually fix the relative paths

If I decide to move the &#8220;default.aspx&#8221; page up one level, all of the relative paths must be manually fixed.

**But there&#8217;s one more major issue.**

#### User controls

Now let&#8217;s suppose I have the following setup:

  * Root
  * img
  * blarg.jpg

  * products
  * default.aspx

  * user
  * login.aspx

  * support
  * help.aspx

  * usercontrols
  * header.ascx

  * default.aspx

All of the ASPX files use the same &#8220;header.ascx&#8221; control (I&#8217;m not using master pages on this site).&nbsp; The &#8220;header.ascx&#8221; control needs to reference the img, but note that the relative path is calculated based on the **page requested**, not the **user control requested**.&nbsp; This means that the relative URL will only work if the user control just happens to be included in a page at the correct depth.&nbsp; All other times it will break, and this is a huge problem.

Luckily, ASP.NET includes a handy way to fix all of these problems, deployment and otherwise.

### Application root

A path built with an application root is prefixed with a tilde (~).&nbsp; For example, here&#8217;s a raw application path to the image:

<div class="CodeFormatContainer">
  <pre>~/img/blarg.jpg</pre>
</div>

Note the &#8220;~/&#8221; at the front, that&#8217;s what signifies it as an application root path.&nbsp; Application root paths are constructed starting at the root of the application.&nbsp; For example, both &#8220;http://ecommapp.com&#8221; and &#8220;http://localhost/EcommApp&#8221; are application roots, so I don&#8217;t have to worry about changing paths at deployment.

Additionally, I don&#8217;t have to worry about problems with node depth in the hierarchy, as paths are formed from the root and not relative to a leaf node, so my user control problem disappears.

One issue with application root paths is **only ASP.NET knows about them**.&nbsp; Not browsers.&nbsp; If I do this:

<div class="CodeFormatContainer">
  <pre>&lt;img src=<span class="str">"~/img/blarg.jpg"</span> /&gt;</pre>
</div>

The image breaks, as browsers don&#8217;t know what IIS applications are, they just know URLs.&nbsp; ASP.NET, however, will take this URL and generate the correct relative path for you, as long as I use ASP.NET to generate the path.&nbsp; Server controls, like &#8220;asp:hyperlink&#8221; can handle the application root path.

To use the application root path in raw HTML, I just need to use the [ResolveUrl](http://msdn2.microsoft.com/en-us/library/system.web.ui.control.resolveurl.aspx) method, which is included in the Control class, and therefore available in both my Page and UserControl classes.&nbsp; Combining raw HTML and the ResolveUrl method, I get:

<div class="CodeFormatContainer">
  <pre>&lt;img src=<span class="str">"&lt;%= ResolveUrl("</span>~/img/blarg.jpg<span class="str">") %&gt;"</span> /&gt;</pre>
</div>

The &#8220;<%= %>&#8221; construct is basically a &#8220;Response.Write&#8221;, and allows me to call the ResolveUrl method&nbsp;directly.

Using application root paths allows me to:

  * Develop locally and deploy to production seamlessly
  * Have consistent URL per resource
  * Use raw HTML without&nbsp;the problems of absolute and relative paths

### Some caveats

No matter what I do, I have to change code if either the resource or the page moves.&nbsp; I can minimize the number of changes by externalizing the specific path (the &#8220;~/img/blarg.jpg&#8221; part) to a resource file, constant, or static global variable.&nbsp; This applies for all types of paths, so I like to eliminate as much duplication as possible.

It&#8217;s dangerous to assume that the structure or names of resources and pages won&#8217;t change at some point.&nbsp; As a web site grows, it can become necessary to move resources around and reorganize your site structure.&nbsp; To minimize the impact of deployment and change, use application paths as much as possible, you&#8217;ll save on Excedrin later.