---
title: 'Surprise Go is ok for me now'
date: 2018-12-13T20:23:00+00:00
author: Ryan Svihla
layout: post
categories:
  - Golang
---

I'm surprised to say this. I am ok using Go now. It's not my style, but I can build almost anything I want to with it, and the tooling around it continues to improve.

About seven months ago, I wrote about all the things I didn't care for in Go and now I either no longer am so bothered by it, or things have improved.

Go Modules so far is a massive improvement over Dep and Glide for dependency management. It's easy to set up, performant and eliminates the GOPATH silliness. I no longer have to check-in the vendor directory to speed up builds. Lesson use Go Modules.

I pretty much stopped using channels for everything but shutdown signals, which fits my preferences pretty well. I use mutex and semaphores for my multithreaded code and feel no guilt about it. The strategy of avoiding channels cut out a lot of pain for me, and with the excellent race detector, I feel comfortable writing multithreaded in Go now. The lesson, don't use channels much.

Lack of generics still sometimes sucks, but I usually implement some crappy casting with dynamic types if I need that. I've made my peace by writing more code and am no longer so hung up. Lesson relax.

With the Error handling in Go, I'm still struggling. I thought about using one of the error Wrap() libraries, but an official one is in the draft spec now, so I'll wait on that. I now tend to have less nesting of functions. As a result, this probably means more extended functions than I like, but my code looks more "normal" now. I am ok with trading off my ideal code; that may not be as ideal as I think it is if it makes my code more widely accepted. Lesson relax more.

I see the main virtue of Go now that it is prevalent in the infrastructure space where I am, and so it's becoming the common tongue (essentially replacing Python for those sorts of tasks). For this, honestly, it's about right. It's easy to rip out command-line tools and deploy binaries for every platform with no runtime install.

The community's conservative attitude I sort of view as a feature now, in that there isn't a bunch of different popular options, and there is no arguing over what file format rules to use. The "one format to rule them all" drove me up the wall initially, but I appreciate how much less time I spend on these things now.

So now I suspect Go will be my "last" programming language. It's not the one I would have chosen, but where I am in my career, where most of my dev work is automation and tooling, it fits the bill pretty well.

Also equally important, most people working with me didn't have full-time careers as developers or spend their time reading "Domain Driven Design" (fantastic book). Therefore, adding in a bunch of nuanced stuff that maybe technically optimal for some situations, which also assumes the reader grasps all of the said nuances, isn't a good tradeoff for anyone.

So I think I get it now. I'll never be a cheerleader for the language, but it solves my problems well enough.
