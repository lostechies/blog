---
wordpress_id: 116
title: 'Cassandra &#038; Rails: Cequel Batch Support'
date: 2014-07-15T12:15:51+00:00
author: Ryan Svihla
layout: post
wordpress_guid: http://lostechies.com/ryansvihla/?p=116
dsq_thread_id:
  - "2846091548"
categories:
  - Cassandra
  - ORM
  - Rails
---
Cassandra On Rails using Cequel Atomic Batch Support When I first tried to use Cassandra with Rails over a year ago the lack of a good native (IE not thrift) driver and a good mapper was a show stopper for the project I was on. Today the situation has improved markedly with the cql-rb driver proving stable in usage, and the excellent Cequel ActiveModel capable library switching to use cql-rb.

I’d like to cover a common use case that’s not been handled by ORM style mapping libraries very well, atomic batches. Cequel has support for this even though you have to hunt a bit for it and it works well. Consider the following scenario, you’ve got 2 related tables, and you want one to update when the other one changes.

    class Post 
     include Cequel::Record
     belongs_to :blog key :id, :uuid, auto: true
     column :body, :text
     column :author, :text
     column :title, :text 
    end
    
    class Blog 
     include Cequel::Record
     has_many :posts key :id, :uuid, auto: true
     column :author, :text 
    end
    

If I want to say update author name with an Active Record style interface I’m totally out of luck, and have to maintain this state separately.

    post.blog = blog
    post.author = "John Smith"
    blog.author = "John Smith"
    blog.save!
    
    CQL (2ms) UPDATE blogs SET author = 'Ryan Svihla' WHERE id = c5cdd562-0c2e-11e4-bd14-1d762bc51d5b
    

Since I forgot to save my post no updates occur. I can use callbacks to help however, and Cequel is smart enough to wrap all of these in an Atomic Batch for me.

    class Blog 
     include Cequel::Record
     has_many :posts key :id, :uuid, auto: true
     column :author, :text 
    
     after_destroy :delete_all_posts
     after_update :update_author_name
    
     def delete_all_posts
      self.posts.each { |p| p.destroy }
     end
    
     def update_author_name
      self.posts.each { |p| 
       p.author = self.author
       p.save!
      } 
     end 
    end
    

Now an update will have the behavior we want perform an atomic batch across all tables and rows acted on in the callback. This means that even if the client and even the coordinator node fails eventually this will be done.

    post.blog = blog
    post2.blog = blog
    blog.author = "John Smith"
    blog.save!
    
    CQL (2ms) BEGIN BATCH
    UPDATE blogs SET author = ‘John Smith’ WHERE id = 48097216-0c2f-11e4-9d4b-230a125e3b62
    UPDATE posts SET author = ‘John Smith’ WHERE blog_id = 48097216-0c2f-11e4-9d4b-230a125e3b62 AND id = 4d7fe89c-0c2f-11e4-9d4b-230a125e3b62
    UPDATE posts SET author = ‘John Smith’ WHERE blog_id = 48097216-0c2f-11e4-9d4b-230a125e3b62 AND id = 62cc675c-0c2f-11e4-9d4b-230a125e3b62
    APPLY BATCH
    

Likewise if we want to delete the blog, we can rely on all child posts being deleted in a batch manner

    post.blog = blog
    post2.blog = blog
    blog.destroy
    
    CQL (4ms) BEGIN BATCH
    DELETE FROM blogs WHERE id = 48097216-0c2f-11e4-9d4b-230a125e3b62
    DELETE FROM posts WHERE blog_id = 48097216-0c2f-11e4-9d4b-230a125e3b62 AND id = 4d7fe89c-0c2f-11e4-9d4b-230a125e3b62
    DELETE FROM posts WHERE WHERE blog_id = 48097216-0c2f-11e4-9d4b-230a125e3b62 AND id = 62cc675c-0c2f-11e4-9d4b-230a125e3b62
    APPLY BATCH
    

This is all a big step in the right direction and closer to what I’ve envisioned for automatic batch support of related tables than anything I’ve used yet besides my own work (which is on hold for the extended future).

Cequel is the best mapping library I’ve used to date regardless of language for Cassandra. You should check it out, they get the important parts.