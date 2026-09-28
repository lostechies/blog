---
wordpress_id: 393
title: No silver domain modeling bullets
date: 2010-03-11T13:59:00+00:00
author: Jimmy Bogard
layout: post
wordpress_guid: /blogs/jimmy_bogard/archive/2010/03/11/no-silver-domain-modeling-bullets.aspx
dsq_thread_id:
  - "264716442"
categories:
  - DomainDrivenDesign
redirect_from: "/blogs/jimmy_bogard/archive/2010/03/11/no-silver-domain-modeling-bullets.aspx/"
---
This past week, I attended a presentation on Object-Role Modeling (with the unfortunate acronym ORM) and its application to DDD modeling".&#160; The talk itself was interesting, but more interesting were some of the questions from the audience.&#160; The gist of the tool is to provide a better modeling tool for domain modeling than traditional ERM tools or UML class diagrams.&#160; ORM is a tool for fact-based analysis of informational models, information being data plus semantics.&#160; I’m not an ORM expert, but there are plenty of resources on the web.

One of the outputs of this tool _could_ be a complete database, with all constraints, relationships, tables, columns and whatnot built and enforced.&#160; However, the speaker, Josh Arnold, mentioned repeatedly that it was not a good idea to do so, or at least it doesn’t scale at all.&#160; **It could be used as a starting point, but that’s about it.**

Several times at the end of the talk, the question came up, “can I use this to generate my domain model” or “database”.&#160; Tool-generated applications are a lofty, but extremely flawed goal.&#160; **Code generation is interesting as a one-time, one-way affair.**&#160; But beyond that, code generation does not work.&#160; We’ve seen it time and time again.&#160; Even though the tools get better, the underlying invalid assumption does not change.

The fundamental problem is that **visual code design tools can never and will never be as expressive, flexible and powerful as actual code**.&#160; There will always be a mismatch here, and it is a fool’s errand to try to build anything more.&#160; Instead, the ORM tool looked quite useful as a modeling tool for generating conversation and validating assumptions _about_ their domain, rather than a domain model builder.

**Ultimately, the only validation that our domain is correct is the working code.**&#160; There is no silver bullet for writing code, as there is always some level of complexity in our applications that requires customization.&#160; And there’s nothing that codegen tools hate more than modification of the generated code&#160; However, I’m open to the idea that I’m wrong here, and I would love to be shown otherwise.