---
wordpress_id: 27
title: The Shape of the Domain Model
date: 2007-12-01T03:24:18+00:00
author: Evan Hoff
layout: post
wordpress_guid: /blogs/evan_hoff/archive/2007/11/30/the-shape-of-the-domain-model.aspx
categories:
  - Uncategorized
redirect_from: "/blogs/evan_hoff/archive/2007/11/30/the-shape-of-the-domain-model.aspx/"
---
This is a bit of a random thought which I had this morning regarding the relationship between the domain model and data.

An instance of the domain model (or parts of it) is a snapshot of the model at a given point in time.&nbsp; Specifically, the state of the model is the snapshot.&nbsp; The configuration of the pieces of data in the model is the <a href="http://evanhoff.com/archive/2007/10/10/53.aspx" target="_blank">shape</a> of the domain model.

If the shape of the domain model corresponds closely to the database schema, changes in the domain model&#8217;s shape require data migrations in the database.

It&#8217;s not earth shattering, but thinking of the model in terms of shape is an interesting concept to me.&nbsp; Thinking about the evolution of the model&#8217;s shape over the lifetime of the application is also a cool concept (ie..shape in relationship to time).