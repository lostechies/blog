---
wordpress_id: 65
title: 'SharePoint 2007 Wiki &#8211; not a fan'
date: 2007-09-24T18:09:00+00:00
author: Jimmy Bogard
layout: post
wordpress_guid: /blogs/jimmy_bogard/archive/2007/09/24/sharepoint-2007-wiki-not-a-fan.aspx
dsq_thread_id:
  - "266936929"
categories:
  - Rant
---
> _This post was originally published [here](http://grabbagoft.blogspot.com/2007/09/sharepoint-2007-wiki-not-fan.html)._

Now that I&#8217;ve written a couple large-ish wiki entries on our team&#8217;s SharePoint 2007 wiki, I can reasonably say I&#8217;m not too impressed with the wiki offerings from MOSS 2007.&nbsp; A few complaints so far:

  * No apparent wiki markup language 
  * No documentation, other than one stock page that comes with the wiki 
  * RSS feed for wiki only covers new items, not modifications to existing items 
  * Only two editing options, WYSIWYG or straight-up HTML 
  * WYSIWYG editor not very efficient and produces ugly, non-compliant, deprecated HTML 
  * No auto-linking, back-linking, free-linking, etc.

Basically, most of the features I had grown to love in [FlexWiki](http://www.flexwiki.com/)&nbsp;are not present.&nbsp; My biggest beef is probably the lack of a wiki markup language.&nbsp; The HTML output by the WYSIWYG is pretty terrible, as it&#8217;s mostly deprecated HTML tags like FONT.&nbsp; The whole point of a wiki markup language is to make it easy for non-technical folks to add entries.&nbsp; When using WYSIWYG, styles become corrupted quite fast, as fonts and such are managed at the HTML level.

For example, let&#8217;s say you want to have the following entry in a wiki:

### Current Build Architecture

#### Local Builds

  * Solution-driven builds 
  * IIS vdirs and web site created manually 
  * Packaging steps done manually through a C++ post-build events project 
  * Environment configuration done manually

#### Server Builds

  * Project-driven builds 
  * MSI deployment 
  * Custom scheduler service&nbsp;for daily and deployment builds 
  * Uses a NAnt and an MSBuild build script file 
  * Build scripts manually deployed to build server 
  * Build scripts create workspaces, get sources, compile, create MSI&#8217;s, and deploy 

In MOSS 2007 Wiki, the above structure is possible, but it took a lot of cajoling with the WYSIWIG editor to get it right.&nbsp; I expected the header text to use &#8220;Hxxx&#8221; html tags, and the HTML produced to look reasonable, so I could fine-tune it.&nbsp; Instead, this is what I got:

<pre>&lt;DIV class=ExternalClassF7A8AEC3D2A943AE8A574B6CA3D14B2F&gt;&lt;FONT size=2&gt;&lt;/FONT&gt;&nbsp;&lt;/DIV&gt;<br />&lt;DIV class=ExternalClassF7A8AEC3D2A943AE8A574B6CA3D14B2F&gt;&lt;FONT size=3&gt;&lt;STRONG&gt;Current Architecture&lt;/STRONG&gt;&lt;/FONT&gt;&lt;/DIV&gt;<br />&lt;DIV class=ExternalClassF7A8AEC3D2A943AE8A574B6CA3D14B2F&gt;&lt;FONT size=2&gt;&lt;/FONT&gt;&nbsp;&lt;/DIV&gt;<br />&lt;DIV class=ExternalClassF7A8AEC3D2A943AE8A574B6CA3D14B2F&gt;&lt;STRONG&gt;&lt;FONT size=2&gt;Local Builds&lt;/FONT&gt;&lt;/STRONG&gt;&lt;/DIV&gt;<br />&lt;UL&gt;<br />&lt;LI&gt;<br />&lt;DIV class=ExternalClassF7A8AEC3D2A943AE8A574B6CA3D14B2F&gt;&lt;FONT size=2&gt;Solution-driven builds&lt;/FONT&gt;&lt;/DIV&gt;&lt;/LI&gt;<br />&lt;LI&gt;<br />&lt;DIV class=ExternalClassF7A8AEC3D2A943AE8A574B6CA3D14B2F&gt;&lt;FONT size=2&gt;IIS vdirs and web site created manually&lt;/FONT&gt;&lt;/DIV&gt;&lt;/LI&gt;<br />&lt;LI&gt;<br />&lt;DIV class=ExternalClassF7A8AEC3D2A943AE8A574B6CA3D14B2F&gt;&lt;FONT size=2&gt;Packaging steps done manually through a C++ post-build events project&lt;/FONT&gt;&lt;/DIV&gt;&lt;/LI&gt;<br />&lt;LI&gt;<br />&lt;DIV class=ExternalClassF7A8AEC3D2A943AE8A574B6CA3D14B2F&gt;&lt;FONT size=2&gt;Environment configuration done manually (i.e., SiteInfo guids)&lt;/FONT&gt;&lt;/DIV&gt;&lt;/LI&gt;&lt;/UL&gt;<br />&lt;P class=ExternalClassF7A8AEC3D2A943AE8A574B6CA3D14B2F&gt;&lt;FONT size=2&gt;&lt;STRONG&gt;Server Builds&lt;/STRONG&gt;&lt;/FONT&gt;&lt;/P&gt;<br />&lt;UL&gt;<br />&lt;LI&gt;<br />&lt;DIV class=ExternalClassF7A8AEC3D2A943AE8A574B6CA3D14B2F&gt;&lt;FONT size=2&gt;Project-driven builds&lt;/FONT&gt;&lt;/DIV&gt;&lt;/LI&gt;<br />&lt;LI&gt;<br />&lt;DIV class=ExternalClassF7A8AEC3D2A943AE8A574B6CA3D14B2F&gt;&lt;FONT size=2&gt;MSI deployment&lt;/FONT&gt;&lt;/DIV&gt;&lt;/LI&gt;<br />&lt;LI&gt;<br />&lt;DIV class=ExternalClassF7A8AEC3D2A943AE8A574B6CA3D14B2F&gt;&lt;FONT size=2&gt;Dell Scheduler for daily and deployment builds&lt;/FONT&gt;&lt;/DIV&gt;&lt;/LI&gt;<br />&lt;LI&gt;<br />&lt;DIV class=ExternalClassF7A8AEC3D2A943AE8A574B6CA3D14B2F&gt;&lt;FONT size=2&gt;Uses a NAnt and an MSBuild build script file&lt;/FONT&gt;&lt;/DIV&gt;&lt;/LI&gt;<br />&lt;LI&gt;<br />&lt;DIV class=ExternalClassF7A8AEC3D2A943AE8A574B6CA3D14B2F&gt;&lt;FONT size=2&gt;Build scripts manually deployed to build server&lt;/FONT&gt;&lt;/DIV&gt;&lt;/LI&gt;<br />&lt;LI&gt;<br />&lt;DIV class=ExternalClassF7A8AEC3D2A943AE8A574B6CA3D14B2F&gt;&lt;FONT size=2&gt;Build scripts create workspaces, get sources, compile, create MSI's, and deploy&lt;/FONT&gt;&lt;/DIV&gt;&lt;/LI&gt;&lt;/UL&gt;<br /></pre>

This is not a joke.&nbsp; Non-XTHML compliant markup in a product released in 2006 is unacceptable at this point.&nbsp; Using deprecated HTML tags like &#8220;FONT&#8221; is even less acceptable, almost laughable.&nbsp; I can&#8217;t even read this markup, it&#8217;s giving me a headache.

Here&#8217;s the same markup in FlexWiki:

<pre>!Current Architecture<br /><br />!!Local Builds<br />	* Solution-driven builds<br />	* IIS vdirs and web site created manually<br />	* Packaging steps done manually through a C++ post-build events project<br />	* Environment configuration done manually (i.e., SiteInfo guids)<br />	* Server Builds<br /><br />!!Project-driven builds<br />	* MSI deployment<br />	* Dell Scheduler for daily and deployment builds<br />	* Uses a NAnt and an MSBuild build script file<br />	* Build scripts manually deployed to build server<br />	* Build scripts create workspaces, get sources, compile, create MSI's, and deploy<br /></pre>

Now which markup is more maintainable?&nbsp; Which one is easier to read?&nbsp; Which one is easier to understand, edit, and change?

FlexWiki parses the markup to output HTML, and FlexWiki users don&#8217;t have to worry about the HTML, only simple formatting rules.&nbsp; MOSS 2007 wiki is a good first step in a wiki engine for SharePoint, but it&#8217;s only a first step.&nbsp; Be aware that its features pale in comparison to the more mature wiki engines, which have been around for many years and many versions.

Wizards and designers&nbsp;are useless to me if the code/markup they generate&nbsp;is not maintainable.&nbsp; Also, why is it that tool consolidation means I have to give up a host of features?&nbsp; Seems that instead of doing a few things well, MOSS 2007 does two dozen things not so well.&nbsp; I&#8217;d rather shoot for integration over consolidation and let individual tools shine.&nbsp; Although our CMS/blog/wiki tools are now consolidated on our team/org, I&#8217;m not entirely sure what exactly it bought us to lose our superior wiki and blog engines we used previously.