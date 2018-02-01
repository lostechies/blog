---
id: 4392
title: 'EmberJS :: Beyond the tutorials'
date: 2013-10-08T18:23:26+00:00
author: Ryan Rauh
layout: post
guid: http://lostechies.com/ryanrauh/?p=252
dsq_thread_id:
  - "1837076903"
categories:
  - Uncategorized
---
# How I got started with EmberJS

I&#8217;ve been trying to learn and get better at writing good idomatic EmberJS code. At times I&#8217;ve been extremely frustrated and at other times I&#8217;ve been extremely delighted.

For the past 3-4 years ago I&#8217;ve been involved and contributed to an alternate .NET web framework called FubuMVC. Much like EmberJS, FubuMVC was an ambitious project that was primary spearheaded by a few huge open source contributors in .NET. I believed it was a better way and that learning to use the framework would make me a better developer.

But not all of these last 4 years have been what I would consider _fun_. In a lot of respect pinning down a _stable_ version of the framework was frustrating. Things moved fast and API&#8217;s changed often leaving you on a treadmill of upgrading the framework and fixing bugs.

It&#8217;s for these reasons that I avoided EmberJS for a long time, but after spending some time at my [local emberjs meetup](http://emberatx.org). I was told that things had gotten a lot better after the huge router rewrite and that Tom Dale and company had started getting much better about backward compatibility. I&#8217;m not sure how I get attracted to these types of frameworks but I figured I&#8217;d jump in.

With that I&#8217;ll give you the first thing I did

## Joined a local user group

The emberjs meetup is **by far** my favorite meetup group in Austin. It&#8217;s really diverse, there&#8217;s a retired 60+ year that got super excited when he got the TodoMVC app working with ember. It&#8217;s exciting to hang out with everyone at the meetup and it gets me excited to keep coming back and sharing what I&#8217;ve learned. I went to the meetup for the free beer and conversation and stayed for the awesome people and surprisingly awesome framework.

# Super duper level 1 beginner stuff

## Read the doc and getting started guide

The next thing I did was I browsed through some of the material on the homepage, but I&#8217;m a pretty smart guy and I&#8217;ve been around the block a few times. It didn&#8217;t take me long to understand the patterns and I quickly needed more than just a two or three page explanation of how to create a home page, about page and link them with outlets and link-to helpers.

## Free course on tutsplus

Next thing I did was watch the series on [tutsplus](http://freecourses.tutsplus.com/lets-learn-ember/). It&#8217;s a great video series but still left me wanted a little bit more complex concepts.

## Ember101.com

Not a lot of videos but I kept coming back to it from time to time for a refresher on basic syntax things.

## Heretical Guide To Ember JS

[Heretical Guide To Ember JS](http://gilesbowkett.blogspot.com/2013/06/heretical-guide-to-ember-js.html) was good. It was a quick read, but it was still very beginner. In the final chess game example, it was helpful to see something a bit out of the ordinary written in ember. I liked how it wasn&#8217;t route heavy but still had a few controllers and views. It was still super basic and ultimately not what I was looking for. If you don&#8217;t understand what the jankly named classes of the Model+View+Controller+Template+Router (or whatever the hell its called) pattern are supposed to do in Ember this is the book for you. He explains the architecture really really well.

## Peepcode Fire Up Ember (yes I really did watch and read all this stuff)

[Fire up ember](https://peepcode.com/products/emberjs) was again&#8230; very basic, it doesn&#8217;t go much further than the free tutsplus course but it&#8217;s great for getting started.

# What helped me get to level 2, not so beginner nooby shit

## Lurking the #emberjs freenode channel

I lurked the IRC channel for weeks, looked at the crazy questions people were asking and inspected their jsbin snippets that they would send in. It can be a little overwhelming and you&#8217;re not going to see immediate benefit from it but it help me pick up a few things like
    
* How and when to use a CollectionView and what that does for you
    
* Upcoming api tweeks a changes for the link-to helpers

## Read the source code noob

[TravisCI](https://github.com/travis-ci/travis-web) and [Discource](https://github/discourse/discourse) kind of helped but I still have little to no clue whats going on in those code bases. I know they are doing some non-trival things but it a little to much work for a noob to look at the code or get the apps in a running state to debug any of it.

The emberjs [source docs](http://emberjs.com/api/) are awesome and I constantly reference them.

[Nerdyworm](http://nerdyworm.com)&#8216;s [github](https://github.com/nerdyworm) account and blog helped me a lot to do _simple_ things like open dialogs. That&#8217;s where it finally clicked for me on how to pass models around your application using actions

# K now what

So it&#8217;s been about 4 months and I still feel like a beginner in the framework. Maybe it&#8217;s because I knew FubuMVC so well, I&#8217;ve read almost all of the source code and helped write and fix bugs in a big chuck of it. I like having that kind of deep knowledge of a framework. EmberJS is pretty big and the way its organized isn&#8217;t familiar to me yet. It&#8217;s not like BackboneJS where you can read the entire source code in about an hour.

I think the investment will be worth it. I&#8217;ve used a lot of client-side tech (backbone, knockout, requirejs) and ember the best I&#8217;ve used so far. They have solved a lot of the pain points and things that bothered me about (Single Page Apps). It feels like all of the binding power of knockout without the code organization and scoping problems. It really cuts down a lot of the ceremony that I was experiencing with backbone.