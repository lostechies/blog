---
id: 69
title: BUILD conference–day 2
date: 2011-09-14T23:42:55+00:00
author: Gabriel Schenker
layout: post
guid: http://lostechies.com/gabrielschenker/2011/09/14/build-conferenceday-2/
dsq_thread_id:
  - "415035448"
categories:
  - BUILD
  - Conference
  - Windows
---
Today was the day of Windows 8 Server and of the Windows runtime (WinRT).

WinRT is the new layer providing a language neutral interface to the underlying operating system. It is written in C++ and consists of purely native code. For me it seems to be the revival of the dinosaurs since WinRT basically is a collection of COM objects. Hello **IUnknown**, nice to meet you again!

C++ developers must feel like in paradise. This old language celebrates a true revival during this conference and with the advent of Windows 8. It seems awkward to me that a language that is not really object oriented in its roots, still can play such an important role. I ask myself why did the project “[Singularity](http://research.microsoft.com/en-us/projects/singularity/)” of Microsoft, which had (amongst others) the goal to create an OS which consists purely of managed code &#8211; except for a very very limited set of low level functionality, which had to be implemented in native code &#8211; not drive Microsoft towards a more managed Windows OS. Why do we still need to rely on COM which is a very old and outdated concept?

On the positive side we can acknowledge that WinRT provides meta information in the same format as the .NET type meta information. As a consequence this API can be accessed from C#, VB.NET and JavaScript in a very natural way. To an e.g. C# developer components of WinRT look 100% alike true managed objects. The availability of this meta data allows Visual Studio to provide true intellisense for all of these components.

Another positive aspect of WinRT is that all functions that take more than 15 milliseconds are now executed asynchronously. This helps to achieve the goal to make all Metro type applications execute “fast an fluid”. From C# (and .NET 4.5) it is very easy to access such asynchronous functions since the compiler provides the concept of **async** and **await**. With these two new keywords we can write fully asynchronous code in a way as if everything was sequential.

JavaScript introduces the concept of **promises** to deal with asynchronous calls. This concept makes it very easy to create applications that remain responsive even if long running functions are called. 

There is one positive change that the Windows team did to COM to avoid unnecessary race conditions when calling asynchronous functions of WinRT. In Windows 8 no method of a COM object is executed as long any other method of the same instance is still pending. Sweet!