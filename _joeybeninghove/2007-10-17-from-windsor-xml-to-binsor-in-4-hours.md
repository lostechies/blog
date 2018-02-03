---
wordpress_id: 47
title: From Windsor XML to Binsor In 4 Hours
date: 2007-10-17T19:31:00+00:00
author: Joey Beninghove
layout: post
wordpress_guid: /blogs/joeydotnet/archive/2007/10/17/from-windsor-xml-to-binsor-in-4-hours.aspx
categories:
  - binsor
  - Boo
  - Castle
  - windsor
---
I&#8217;m getting ready to take a break from my current project and switch gears
  
for a little while, but there were a number of &#8220;clean up&#8221; type tasks I wanted to
  
do before I wrapped things up.&nbsp; 

One of the main things I wanted to do was to get rid of the XML configuration
  
files I had for Windsor and use Boo and [Binsor](http://www.ayende.com/Blog/archive/7268.aspx) instead.&nbsp; Any
  
chance I get to work with Boo is a joy.&nbsp; Almost makes me wish Boo would&#8217;ve taken
  
off instead of C# as the &#8220;default&#8221; .NET language (I can hear all the VB&#8217;ers
  
screaming now&#8230;&nbsp; :).

As of today, I&#8217;ve got 67 components configured for Windsor to manage for me
  
spread across 13 different XML configuration files, just to keep it somewhat
  
organized.&nbsp; Needless to say, I was very much looking forward to nixing the angle
  
brackets and verbosity of XML.&nbsp; So I approached it the same way I do any other
  
time I need to do some refactoring or configuration changes.&nbsp; Make one little
  
change, test, repeat.

About 4 hours later I had everything 100% switched over to Binsor, in a
  
\*single\* file (I still may [break
  
it up into multiple files](http://www.ayende.com/Blog/archive/2007/10/10/Multi-file-DSLs.aspx), but this works for now).&nbsp; This was my very first
  
time even trying out Binsor, so I&#8217;m sure next time I&#8217;ll be able to do this kind
  
of thing much faster.&nbsp; Here are a couple cool&nbsp;things I learned&#8230;

  * When trying to configure the LoggingFacility using Binsor, I figured out
  
    that in order to set the loggingApi attribute correctly&nbsp;you need to use the
  
    brackets syntax like this:

> <div>
>   <pre>Facility(logging_facility, LoggingFacility, { @loggingApi:<span>"log4net"</span> })</pre>
> </div>
> 
> I&#8217;m very familiar with this since I use Brail as my view engine of choice.&nbsp;
  
> 🙂

  * One&nbsp;cool thing I learned was that you don&#8217;t even need brackets when
  
    specifying parameter values and dependency overrides for your components.&nbsp; I&#8217;m
  
    not sure if this is a Boo thing or something Ayende enabled, but you can use a
  
    hash without brackets as the last parameter, similar to how I can in Ruby.&nbsp; An
  
    example might make this more clear&#8230;

> <div>
>   <pre>Component(primary_catalog, ICatalog, Catalog, name:<span>"Primary Catalog"</span>, otherParam1:<span>"blah"</span>, otherParam2:<span>"blah"</span>)</pre>
> </div>

  * In a couple areas&nbsp;I have a set of mappers that just have default
  
    implementations right now and don&#8217;t have any special configuration, so I
  
    used&nbsp;the power of Boo to dynamically configure them for me ([a
  
    technique I first saw Ayende use](http://www.ayende.com/Blog/archive/2007/10/08/Zero-Friction-Configurations.aspx))

> <div>
>   <pre><span>for</span> type <span>in</span> System.Reflection.Assembly.Load(<span>"Service.Implementations"</span>).GetTypes():<br />    <span>continue</span> unless type.Namespace == <span>"Service.Implementations.Mappers"</span><br />    <span>continue</span> <span>if</span> type.IsInterface  or type.IsAbstract or type.GetInterfaces().Length == 0<br />    Component(type.FullName, type.GetInterfaces()[0], type)</pre>
> </div>

  * One gotcha I had to easily work around was specifying decimal values for my
  
    components parameters.&nbsp; I have a couple stubbed out calculation strategy
  
    components that take in a decimal rate during construction.&nbsp; It may just be my
  
    lack of Boo knowledge, but every time I would try to use something like 0.06 or
  
    0.06m I would get cast exceptions.&nbsp; Eventually I remembered that I had the power
  
    of the Boo language&nbsp;so I just cast it myself and it seemed to work.

> <div>
>   <pre>Component(tax_calculation, ITaxCalculationStrategy, TaxCalculationStrategy, taxRate:cast(<span>decimal</span>, 0.06))</pre>
> </div>
> 
> (**If anyone out there can correct me on this, that would be
  
> great!**)&nbsp; 😀

So I&#8217;m pretty happy with how it turned out.&nbsp; Much more concise than its XML
  
counterpart.

&nbsp;