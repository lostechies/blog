---
wordpress_id: 989
title: 'AutoMapper 3.3 feature: Projection conversions'
date: 2014-12-23T18:42:09+00:00
author: Jimmy Bogard
layout: post
wordpress_guid: http://lostechies.com/jimmybogard/?p=989
dsq_thread_id:
  - "3353201397"
categories:
  - AutoMapper
---
[AutoMapper 3.3](https://github.com/AutoMapper/AutoMapper/releases/tag/v3.3.0) introduced a few features to complement the mapping capabilities available in normal mapping. Just like you can do ConvertUsing for completely replacing conversion between two types, you can also supply a custom projection expression to replace the mapping expression for two types during projection:

[gist id=843cd241c99dead6ce70]

Occasionally, you don’t want to replace the entire mapping, but there’s just a constructor you need to have some custom logic in:

[gist id=cf6cc67d0752f6ebc114]

AutoMapper can automatically match up source members to destination constructor parameters, but if things don’t quite line up or you need some additional logic, you have a place to do so.

Finally, AutoMapper can automatically convert types to strings (just calling .ToString()) for any time it sees a string on the destination type:

[gist id=aed102fc0024da644f6a]

If you need to do more custom logic for a string conversion, you can either supply a global conversion (ProjectUsing) or a member conversion (MapFrom).

Finally, if you have some custom projection expansions and you only want to expand certain members on the destination, you can supply a series of projection expressions and only those explicitly specified members will be included in the resulting expansion:

[gist id=df576d2ecdc762478480]

I would usually recommend against doing this, but I’ve seen cases such as OData that this sort of scenario is expected. In the next post, I’ll cover one of the more interesting features in 3.3 – parameterized projections. Enjoy!