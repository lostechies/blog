---
wordpress_id: 236
title: AngularJS–Part 1, Feedback
date: 2013-12-07T13:22:13+00:00
author: Gabriel Schenker
layout: post
wordpress_guid: http://lostechies.com/gabrielschenker/?p=236
dsq_thread_id:
  - "2033440021"
categories:
  - AngularJS
  - developer
  - didactics
  - learning
  - methodology
---
# Introduction

This is a series of posts to describe our approach to slowly migrate a Silverlight based client of a huge and complex LOB&nbsp; to an HTML5/CSS3/JavaScript based client. These posts report on the lessons learnt and are meant to be used as a reference for our development teams. The first part of this series can be found [here](https://lostechies.com/gabrielschenker/2013/12/05/angularjspart-1/).

To my own surprise I already got a lot of interesting feedback to my first introductory post in the series. Instead of replying directly to the individual comments I prefer to write a specific blog post and reason a bit about my motivation.

# Some Answers

I want to take a minute and reflect on some of the comments. I allow myself to paraphrase some of the comments

> <font size="3">don’t concentrate on the basic stuff about AngularJS but rather dive into the more specific implementation.</font>

I am fully aware that in this series I will discuss some of the basics that can be found elsewhere too, that’s how I learnt about all the new stuff. But I also know from my own experience in teaching, guiding and mentoring developers of all levels (from absolute beginner to experts) that the real understanding and mastering of a topic doesn’t come from reading or discussing but from “digesting” the new knowledge. Learning and mastering something new can be categorized by using a model of six levels. The six levels are in ascending order (from simple to sophisticated)

  1. learning something by heart 
      * being able to retell something just learnt by using my own words or analogies 
          * being able to solve an isolated problem 
              * being able to analyze a complex scenario 
                  * being able to synthesize multiple techniques to create something new 
                      * being able to judge a given scenario or situation</ol> 
                    The first three levels represent basic skillset and do not involve any creativity. Even animals can be trained to master the first three levels. Real mastery starts with level 4 and is perfected when reaching level 6. The sad reality is (according to many international studies and meta studies) that at school and later in our job we mostly remain stuck on the first 3 levels. My own experience with several hundred of developers is, that the vast majority of these developers are struggling to ever go beyond level 3. So many times I was told that I should not talk about the basic but rather talk about the more complex and specific stuff. Basic or fundamental knowledge seems to be unattractive and boring. But then when those same developers are given a somewhat tricky problem to solve they most always struggle; and they struggle because they do not really understand the basics. They just use certain techniques or tools and never ask themselves why they use them and how exactly they work. Let me just give some examples to not remain in the abstract:
                    
                    Some of the questions that I frequently ask and most often do not get answered correctly or not answered at all
                    
                      * How does data binding work (e.g. in Silverlight/WPF, AngularJS or Knockout)? 
                          * Why does “this” even work? How does Angular or Silverlight initialize itself and what happens there? 
                              * When comparing coding in C# and JavaScript, what are some of the fundamental differences to be aware of, such as that we use (and not abuse) each language in an optimal way. 
                                  * How does the Web work? More particularly, what exactly happens when a browser communicates with a web server? 
                                      * Explain the main differences between asynchronous and synchronous operations and give a few samples when it makes most sense to use either of them. </ul> 
                                    Don’t you think that we are all better developers if we are able to understand and answer the above questions? And by answering I do not mean to repeat what we have read in a book, article, blog post or heard from a colleague but by explaining the subject to an interested laymen using our own words and analogies such as that this laymen can grasp what we are talking about. Also we should be able to answer those questions in the context of the business domain we are working in and reflect on how and where those topics appear or are relevant. Ideally we should be able to provide a well-founded judgment on the WHY we favor certain things or techniques over others.
                                    
                                    Woaw, sorry, … are you still with me? 
                                    
                                    I have taken you on a quick journey into the area of learning. With this lengthy excursion I wanted to explain why I think talking or writing about basic or fundamental things is so important to me. The important thing is though, that I do not just copy other people’s work or reproduce one to one what I have learnt from other sources but use my very own way to elaborate on those topics. If I am able to do this then it personally helps me to come to a deeper understanding of the subject. As a trainer I have learnt by far the most when I had to answer so called stupid, basic or trivial questions. It is my firm belief that there are no stupid questions but only stupid answers. If someone blocks your next question with the words “why are you asking me such a stupid question?” then just insist and don’t let yourself getting discouraged, probably the other person is not really able to sufficiently answer your question due to lack of understanding or proficiency.
                                    
                                    > <font size="3">AngularJS cannot solve all your problems</font>
                                    
                                    For us AngularJS is just one of many tools we use to get the job done. We use a tool as long as in fits and have no problem to use a different tool/library/technique whenever the subject at hand requires it. Every good craftsman has a tool belt full of meaningful tools and not only a single tool. We want to avoid putting ourselves into a situation where “if I only have a hammer then everything looks like a nail”…
                                    
                                    > You are dealing with a large and complex LOB application consisting of hundreds of screens. Will AngularJS scale well?
                                    
                                    For us AngularJS is just a tool. How well we can master our complex business domain has little to do with the fact about which tool we use and much more with the fact whether we have developed a deep understanding of the domain itself and then how we partition the overall domain in to smaller, manageable chunks (often called bound contexts). The whole application should be seen as a composition of many small and loosely coupled parts. That said, once we have partitioned our problem domain most reasonable tools are able to handle an individual partition or bound context rather well.
                                    
                                    > We are mostly interested in your experiences of migrating a complex LOB from Silverlight to HTML5/CSS3/JavaScript
                                    
                                    It is my intent and I will try hard to talk as much as possible about specific experiences of me and my teams during this migration.