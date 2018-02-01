---
id: 42
title: 'Presentation Model: &#8220;Screen&#8221; Store Example'
date: 2007-10-02T18:38:00+00:00
author: Joey Beninghove
layout: post
guid: /blogs/joeydotnet/archive/2007/10/02/presentation-model-quot-screen-quot-store-example.aspx
categories:
  - Uncategorized
---
> _&#8220;It is_ better to trust in the LORD Than to put confidence in man.&#8221; &#8212;
  
> [Psalm
  
> 118:8](http://www.blueletterbible.org/cgi-bin/tools/printer-friendly.pl?book=Psa&chapter=118&version=NKJV#8)

Ok folks.&nbsp; First,&nbsp;a couple disclaimers: 

  * I first heard of this kind of approach from [JP](http://www.jpboodhoo.com/blog/) back during his Richmond boot-camp
  
    tour.&nbsp; 🙂&nbsp; Having said that, I&#8217;m fully expecting folks (including JP) to shoot
  
    holes in the implementation of this example.&nbsp; I&#8217;m merely providing it to better
  
    explain the pieces involved. 
  * A lot of the **patterns and layering** you will see in the
  
    example&nbsp;are&nbsp;**intentionally overdone** for the purposes of showing
  
    the mechanics.

Now that we have that little tidbit out of the way.&nbsp; This post is intended to
  
be read in 2 parts.&nbsp; 

#### First, get the code man&#8230;

You can grab the entire source code (either from my [google code repository](http://code.google.com/p/joeydotnet/source)&nbsp;or
  
in [this
  
convenient little zip file](http://joeydotnet.googlecode.com/files/ScreenStoreExample.zip)).&nbsp; Feel&nbsp;free to browse the&nbsp;code for a bit, but
  
**come back** to this post so I can show an example of adding a
  
new, simple feature using this code base.

Some quick notes regarding the solution:

  * If you open a console to the root directory of the solution you can run
  
    &#8220;build test&#8221; to run all the unit tests and see them succeed (hopefully, :P) 
  * I was lazy in this example and didn&#8217;t include my usual &#8220;build run&#8221; target
  
    which will automatically compile, test and fire open a browser to run the
  
    application [without
  
    opening VS](http://www.jpboodhoo.com/blog/DirectoryStructureForProjects.aspx).&nbsp; So you&#8217;ll have to open up VS and do the old skool Ctrl+F5
  
    (sorry).

#### Second, let&#8217;s add a quick little feature

Right now the&nbsp;monitor search results show brand, size and model.&nbsp; Let&#8217;s say
  
the&nbsp;customer would like to&nbsp;also see whether or not the monitor is in stock from
  
the search results.&nbsp; Let&#8217;s see what that would take.

First off, you may have noticed that I&#8217;m using the very handy [SmartGridComponent](http://using.castleproject.org/display/Contrib/Smart+Grid+Component)&nbsp;from
  
[Ayende](http://ayende.com/)&nbsp;(now included in the [Castle Contrib
  
project](http://using.castleproject.org/display/Contrib/Home)).&nbsp; Here&#8217;s how it&#8217;s used in this example:&nbsp;

<div>
  <pre>&lt;% <br />    component smartGrid, { @source:searchResults, @displayId:<span>false</span> } : <br />    <br />        section more:<br />        %&gt;<br />            &lt;td&gt;${Html.LinkTo(<span>"Details"</span>, <span>"monitor"</span>, <span>"view"</span>, item.Id)}&lt;/td&gt;<br />        &lt;%<br />        end<br />    end   <br />%&gt; </pre>
</div>

As you can see, I don&#8217;t actually have to specify which columns should be
  
shown in the grid, since it&#8217;s &#8220;smart&#8221; enough to figure it out from the object it
  
is bound with.&nbsp; This means we don&#8217;t even have to modify our view to add this
  
feature!

(To learn more about using this component, check out the new [Castle
  
project wiki page on it](http://using.castleproject.org/display/Contrib/Smart+Grid+Component)).

So we know that the object that is used to display our search results is
  
**MonitorSearchResultDTO**.&nbsp; Instead of just adding an IsInStock
  
property to it now, let&#8217;s drive it out via TDD like good little boys and girls.&nbsp;
  
😀

If we glance at our **Monitor** domain object, we see that a
  
**Monitor** already has the ability to check if its in stock or not
  
(whether it _should_ or not is a whole &#8216;nother discussion which is not
  
the point of this post).&nbsp; Well, sounds like all we have to change is our mapper
  
implementation.&nbsp; Let&#8217;s open up our
  
**MonitorToMonitorSearchResultDTOMapperTest**&nbsp;fixture.

Mapper tests are, for the most part, not all that exciting.&nbsp; A lot of value
  
matching and that&#8217;s about it.&nbsp; So let&#8217;s set up our 2 stubbed&nbsp;monitors to return
  
values for their **IsInStock()** methods.

<div>
  <pre><span>// ...</span><br />SetupResult.For(mockDell24InchUltraSharp.IsInStock()).Return(<span>true</span>);<br /><br /><span>// ...</span><br />SetupResult.For(mockApple30InchCinemaDisplay.IsInStock()).Return(<span>false</span>);</pre>
</div>

&nbsp;

Now let&#8217;s add our asserts to make sure the mapper is doing its job of setting
  
the appropriate values on the DTO.&nbsp; (Yes, I realize relying upon indexers in
  
this case&nbsp;is just plain ugly, but you&#8217;ll forgive me this time, won&#8217;t ya?&nbsp; 🙂

<div>
  <pre><span>// ...</span><br />Assert.IsTrue(listOfSearchResults[0].IsInStock);<br /><br /><span>// ...</span><br />Assert.IsFalse(listOfSearchResults[1].IsInStock);</pre>
</div>

&nbsp;

You&#8217;ll probably notice we don&#8217;t have an **IsInStock** property
  
on our **MonitorSearchResultDTO** yet.&nbsp; Simply use ReSharper to add
  
it now.&nbsp; 

(You&#8217;ll probably want to update the constructor for this DTO&nbsp;in order to
  
keep&nbsp;it immutable, since there really isn&#8217;t a&nbsp;reason it should ever need
  
to&nbsp;change once created.)

Now if your run our test suite using &#8220;build test&#8221; from the console, you&#8217;ll
  
probably get a compilation error.&nbsp; That&#8217;s because we need to actually make the
  
necessary changes to get our test to pass.&nbsp; So we just need to update our mapper
  
to use the modified constructor on our DTO.

<div>
  <pre><span>return</span> <span>new</span> MonitorSearchResultDTO(monitor.Id, monitor.Brand, monitor.Model, monitor.Size, monitor.IsInStock());</pre>
</div>

&nbsp;

So, re-run the tests using &#8220;build test&#8221; and we should be <font color="#008000"><strong>green</strong></font>.&nbsp; Now just build the app and refresh
  
the browser.&nbsp; You should see that a new column appears in the search results
  
named &#8220;Is In Stock&#8221;.&nbsp; 

(Note: This feature actually only takes about 30 seconds to add.&nbsp; Needless to
  
say it took much longer to actually write about it and explain it here.)

One last problem though.&nbsp; It&#8217;s using &#8220;true/false&#8221; as the values which makes
  
for a pretty terrible user experience.&nbsp; 

#### Need Something To Do?

So, dear reader.&nbsp; Here&#8217;s a petty little task for you if you&#8217;re interested.&nbsp;
  
**How would you change the search results &#8220;Is In Stock&#8221; column to show
  
&#8220;Y/N&#8221; instead of &#8220;true/false&#8221;?&nbsp;** (Bonus points for leveraging built-in
  
MonoRail features in the solution)

#### In Conclusion

Let the flaming begin.&nbsp; 🙂&nbsp; Seriously though, I hope this example at least
  
has some value and maybe&nbsp;gives a small glimpse into one way to use a
  
presentation model to maintain a nice separation between your presentation and
  
domain.&nbsp; I&#8217;d really like to see other folks post some examples as well.

&nbsp;

&nbsp;

&nbsp;