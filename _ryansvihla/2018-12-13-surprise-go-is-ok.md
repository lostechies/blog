---
title: 'Surprise Go is ok for me now'
date: 2018-12-13T20:23:00+00:00
author: Ryan Svihla
layout: post
categories:
  - Golang
---

I’m surprised to say this, I am ok using Go now. It’s not my style but I am able to build most anything I want to with it, and the tooling around it continues to improve.

About 7 months ago I wrote about all the things I didn’t really care for in Go and now I either no longer am so bothered by it or things have improved.

Go Modules so far is a huge improvement over Dep and Glide for dependency management. It’s easy to setup, performant and eliminates the GOPATH silliness. I haven’t tried it yet with some of the goofier libraries that gave me problems in the past (k8s api for example) so the jury is out on that, but again pretty impressed. I now longer have to check in vendor to speed up builds. Lesson use Go Modules.

I pretty much stopped using channels for everything but shutdown signals and that fits my preferences pretty well, I use mutex and semaphores for my multithreaded code and feel no guilt about it. This cut out a lot of pain for me, and with the excellent race detector I feel really comfortable writing multi-threaded in Go now. Lesson, don’t use channels much.

Lack of generics still sometimes sucks but I usually implement some crappy casting with dynamic types if I need that. I’ve sorta made my piece with just writing more code, and am no longer so hung up. Lesson relax.

Error handling I’m still struggling with, I thought about using one of the error Wrap() libraries but an official one is in draft spec now, so I’ll wait on that. I now tend to have less nesting of functions as a result, this probably means longer functions than I like, but my code looks more "normal" now. This is a trade off I’m ok with. Lesson relax more.

I see the main virtue of Go now that it is very popular in the infrastructure space where I am and so it’s becoming the common tongue (largely replacing Python for those sorts of tasks). For this, honestly it’s about right. It’s easy to rip out command line tools and deploy binaries for every platform with no runtime install.

The community’s conservative attitude I sort of view as a feature now, in that there isn’t a bunch of different options that are popular and there is no arguing over what file format is used. This drove me up the wall initially, but I appreciate how much less time I spend on these things now.

So now I suspect Go will be my "last" programming language. It’s not the one I would have chosen, but where I am at in my career, where most of my dev work is automation and tooling it fits the bill pretty well.

Also equally important most of the people working with me didn’t have full time careers as developers or spend their time reading "Domain Driven Design" (amazing book) so adding in a bunched of nuanced stuff that maybe technically optimal but assumes the reader grasps all that nuance isn’t a good tradeoff for me.

So I think I sorta get it now. I’ll never be a cheerleader for the language but it definitely solves my problems well enough.