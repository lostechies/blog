---
wordpress_id: 457
title: Versioning strategies for the sane
date: 2011-02-23T03:14:51+00:00
author: Jimmy Bogard
layout: post
wordpress_guid: /blogs/jimmy_bogard/archive/2011/02/22/versioning-strategies-for-the-sane.aspx
dsq_thread_id:
  - "264776681"
categories:
  - 'C#'
redirect_from: "/blogs/jimmy_bogard/archive/2011/02/22/versioning-strategies-for-the-sane.aspx/"
---
I don’t know why I didn’t think of this one earlier, it makes so much sense.&#160; A coworker of mine shared a fantastic assembly versioning strategy that eliminates all of the decisions about major/minor version numbers we have to make up.

If I’m not shipping an assembly for a product, the actual version of an assembly doesn’t matter for any kind of marketing reasons.&#160; For AutoMapper, the version numbers do indicate the level of feature increments, and we see this with products like jQuery, the .NET Framework etc.

However, if I’m building something where no one cares if the version is 1.0 or 2.0, then we can embed a little more information that might actually be useful to us.&#160; We can [tag the assembly with a changeset hash](https://lostechies.com/blogs/jimmy_bogard/archive/2011/01/25/tagging-assemblies-with-mercurial-changeset-hash.aspx) to determine exactly which commit this assembly was built from.&#160; But that still leaves us to make up something for the actual assembly version.&#160; But my buddy Glenn shared this brilliant strategy: use a format based entirely on dates, that always increases, is easy to read and understand, and never hits any kind of wonky overflow exceptions:

**yyyy.mm.dd.hhmm**

Brilliant.&#160; So today it would be:

2011.02.22.2110

Tomorrow:

2011.02.23.0

Because it uses a sortable date format, I guarantee that my version numbers always go up.&#160; With a timestamp, I can easily tell _when_ the build was, so it’s easy to know when a piece of software was last deployed and what changes are in production.&#160; With whatever automated build you use (psake, NAnt, Albacore, Rake, whatever), it’s trivial these days to spit out an AssemblyInfo.cs file that’s built with all of your projects.

Pretty sweet, just wish I did this years ago.