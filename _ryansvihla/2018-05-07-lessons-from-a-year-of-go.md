---
title: 'Lessons from a year of Golang'
date: 2018-05-07T13:16:00+00:00
author: Ryan Svihla
layout: post
categories:
  - Golang
---
I’m hoping to share in a non-negative way help others avoid the pitfalls I ran into with my most recent work building infrastructure software on top of a Kubernetes using Go, it sounded like an awesome job at first but I ran into a lot of problems getting productive. 

This isn’t meant to evaluate if you should pick up Go or tell you what you should think of it, this is strictly meant to help people out that are new to the language but experienced in Java, Python, Ruby, C#, etc and have read some basic Go getting started guide.

## Dependency management

This is probably the feature most frequently talked about by newcomers to Go and with some justification, as dependency management in Go has been a rapidly shifting area that’s nothing like what experienced Java, C#, Ruby or Python developers are used to. 

Today, the default tool	is [Dep][1] all other tools I’ve used such as [Glide][2] or [Godep][3] are	deprecated in favor of Dep, and while Dep has advanced rapidly there are some problems you’ll eventually run into (or I did):

1.  Dep hangs randomly and is slow, which is supposedly network traffic [but it happens to everyone I know with tons of bandwidth][4]. Regardless, I’d like an option to supply a timeout and report an error.
2. Versions and transitive depency conflicts can be a real breaking issue in Go. So without shading or it’s equivalent two package depending on different versions of a given package can break your build, there are a number or proposals to fix this but we’re not there yet.
3. Dep has some goofy ways it resolves transitive dependencies and you may have to add explicit references to them in your Gopkg.toml file. You can see an example [here][5] under **Updating dependencies – golang/dep**.

### My advice

* Avoid hangs by checking in your dependencies directly into your source repository and just using the dependency tool (dep, godep, glide it doesn’t matter) for downloading dependencies.
* Minimize transitive dependencies by keeping stuff small and using patterns like microservices when your dependency tree conflicts.
	  
## GOPATH

Something that takes some adjustment is you check out all your source code in one directory with one path (by default \~/go/src ) and include the path to the source tree to where you check out. Example:

1. I want to use a package I found on github called jim/awesomeness 
2. I have to go to \~/go/src and mkdir -p github.com/jim
3. cd into that and clone the package.
4. When I reference the package in my source file it’ll be literally importing github.com/jim/awesomeness

A better guide to GOPATH and packages is [here][6].

### My advice

Don’t fight it, it’s actually not so bad once you embrace it.

## Code structure

This is a hot topic and there are a few standards for the right way to structure you code from projects that do “file per class” to giant files with general concept names (think like types.go and net.go). Also if you’re used to using a lot of sub package you’re gonna to have issues with not being able to compile if for example you have two sub packages reference one another. 

### My Advice

In the end I was reasonably ok with something like the following:

* myproject/bin for generated executables
* myproject/cmd for command line code
* myproject/pkg for code related to the package

Now whatever you do is fine, this was just a common idiom I saw, but it wasn’t remotely all projects. I also had some luck with just jamming everything into the top level of the package and keeping packages small (and making new packages for common code that is used in several places in the code base). If I ever return to using Go for any reason I will probably just jam everything into the top level directory.

## Debugging

No debugger! There are some projects attempting to add one but Rob Pike finds them a crutch.

### My Advice

Lots of unit tests and print statements. 

## No generics

Sorta self explanatory and it causes you a lot of pain when you’re used to reaching for these.

### My advice

Look at the code generation support which uses pragmas, this is not exactly the same as having generics but if you have some code that has a lot of boiler plate without them this is a valid alternative.  See this official [Go Blog post][7] for more details.
 
 If you don’t want to use generation you really only have reflection left as a valid tool, which comes with all of it’s lack of speed and type safety.
 
## Cross compiling

If you have certain features or dependencies you may find you cannot take advantage of one of Go’s better features cross compilation.

I ran into this when using the confluent-go/kafka library which depends on the C librdkafka library. It basically meant I had to do all my development in a Linux VM because almost all our packages relied on this. 

### My Advice

Avoid C dependencies at all costs.

## Error handling

Go error handling is not exception base but return based, and it’s got a lot of common idioms around it:


	myValue, err := doThing()
	if err != nil {
		return -1, fmt.Errorf(“unable to doThing %v”, err)
  	}


Needless to say this can get very wordy when dealing with deeply nested exceptions or when you’re interacting a lot with external systems.  It is definitely a mind shift if you’re used to the throwing exceptions wherever and have one single place to catch all exceptions where they’re handled appropriately.

### My Advice

I’ll be honest I never totally made my peace with this. I had good training from experienced opensource contributors to major Go projects, read all the right blog posts, definitely felt like I’d heard enough from the community on why the current state of Go error handling was great in their opinions, but the lack of stack traces was a deal breaker for me.  

On the positive side, I found Dave Cheney’s advice on error handling to be the most practical and he wrote [a package][8] containing a lot of that advice, I found it invaluable as it provided those stack traces I missed.

## Summary

A lot of people really love Go and are very productive with it, I just was never one of those people and that’s ok. However, I think the advice in this post is reasonably sound and uncontroversial. So, if you find yourself needing to write some code in Go, give this guide a quick perusal. Hope it helps.

[1]:	https://github.com/golang/dep
[2]:	https://github.com/Masterminds/glide
[3]:	https://github.com/tools/godep
[4]:	https://github.com/golang/dep/blob/c8be449181dadcb01c9118a7c7b592693c82776f/docs/failure-modes.md#hangs
[5]:	https://kubernetes.io/blog/2018/01/introducing-client-go-version-6/
[6]:	https://thenewstack.io/understanding-golang-packages/
[7]:	https://blog.golang.org/generate
[8]:	https://github.com/pkg/errors