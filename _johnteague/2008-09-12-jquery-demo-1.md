---
wordpress_id: 15
title: jQuery Demo 1
date: 2008-09-12T17:12:31+00:00
author: John Teague
layout: post
wordpress_guid: /blogs/johnteague/archive/2008/09/12/jquery-demo-1.aspx
dsq_thread_id:
  - "262055540"
categories:
  - JavaScript
  - JQuery
redirect_from: "/blogs/johnteague/archive/2008/09/12/jquery-demo-1.aspx/"
---
I did several demonstrations during the [Alamo Coders](http://www.alamocoders.net/) presentation.&nbsp; I am going to walk through two of them that I think are the most interesting.&nbsp; One cool thing about jQuery demonstrations is that you don&#8217;t need very many of them.&nbsp; One or two real world examples will demonstrate 80% of jQuery&#8217;s functionality.&nbsp; Not because the library is not robust, but because it is such a compact library and you can do so much with just a few statements.

## Formatting Table Rows

Those of you who have been doing web development for a long time will really appreciate this.&nbsp; It was always a pain to style alternating rows in a table.&nbsp; jQuery makes this very easy.&nbsp; 

<div style="border-right: gray 1px solid;padding-right: 4px;border-top: gray 1px solid;padding-left: 4px;font-size: 8pt;padding-bottom: 4px;margin: 20px 0px 10px;overflow: auto;border-left: gray 1px solid;width: 97.5%;cursor: text;line-height: 12pt;padding-top: 4px;border-bottom: gray 1px solid;font-family: consolas, 'Courier New', courier, monospace;background-color: #f4f4f4">
  <pre style="padding-right: 0px;padding-left: 0px;font-size: 8pt;padding-bottom: 0px;margin: 0em;overflow: visible;width: 100%;color: black;border-top-style: none;line-height: 12pt;padding-top: 0px;font-family: consolas, 'Courier New', courier, monospace;border-right-style: none;border-left-style: none;background-color: #f4f4f4;border-bottom-style: none">$.ready(<span style="color: #0000ff">function</span>(){
    $(<span style="color: #006080">'tr:even'</span>).css(<span style="color: #006080">'background-color'</span>,<span style="color: #006080">'gray'</span>);
    $(<span style="color: #006080">'tr:odd'</span>).css(<span style="color: #006080">'background-color'</span>,<span style="color: #006080">'#CCCCCC'</span>);
});</pre>
</div>

And that&#8217;s it.&nbsp; All table rows are now formatted.&nbsp; Here is the output.

[<img style="border-top-width: 0px;border-left-width: 0px;border-bottom-width: 0px;border-right-width: 0px" height="42" alt="image" src="http://lostechies.com/johnteague/files/2011/03jQueryDemos_82A0/image_thumb_1.png" width="462" border="0" />](http://lostechies.com/johnteague/files/2011/03jQueryDemos_82A0/image_4.png) 

What is happening here is the <font face="Courier New">$.ready(function(){})</font> statement is the jQuery replacement for window.onload.&nbsp; It fires as soon as the DOM is ready to be acted upon, whereas the window.onload does not fire until the entire page is loaded &#8212; including images.

jQuery uses a CSS Selector style of element retrieval. the **<font face="Courier New">$(&#8216;tr:even&#8217;)</font>** returns back a jQuery object that contains a list of all **<tr>** elements on the page, the :even is a pseudo-selector that returns the even numbered rows.&nbsp; 

Once the elements are selected, jQuery then performs whatever action you need against all of the elements that match the selector.&nbsp; In this case, we are adding a background color via the css styles.

Another important feature in the design of jQuery is that all methods are chainable. You can get a selection of elements and perform several manipulate them in the same operation.&nbsp; You can also stop the chain with the **<font face="Courier New">end()</font>** function, which takes you back to your original selection.&nbsp; This can reduce the statement above to one statement.

<div style="border-right: gray 1px solid;padding-right: 4px;border-top: gray 1px solid;padding-left: 4px;font-size: 8pt;padding-bottom: 4px;margin: 20px 0px 10px;overflow: auto;border-left: gray 1px solid;width: 97.5%;cursor: text;line-height: 12pt;padding-top: 4px;border-bottom: gray 1px solid;font-family: consolas, 'Courier New', courier, monospace;background-color: #f4f4f4">
  <pre style="padding-right: 0px;padding-left: 0px;font-size: 8pt;padding-bottom: 0px;margin: 0em;overflow: visible;width: 100%;color: black;border-top-style: none;line-height: 12pt;padding-top: 0px;font-family: consolas, 'Courier New', courier, monospace;border-right-style: none;border-left-style: none;height: 60px;background-color: #f4f4f4;border-bottom-style: none">$(<span style="color: #006080">'tr'</span>)
    .filter(<span style="color: #006080">':even'</span>).css(<span style="color: #006080">'background-color'</span>,<span style="color: #006080">'grey'</span>).end()
    .filter(<span style="color: #006080">':odd'</span>).css(<span style="color: #006080">'background-color'</span>,'#CCCCCC');
</pre>
</div>

&nbsp;

While this does the same as the first statement, I can keep working with my original list of **<tr>** elements and do things like hover styling. Let&#8217;s assume that we have stopped hacking our CSS and put all of these into CSS classes.

<div style="border-right: gray 1px solid;padding-right: 4px;border-top: gray 1px solid;padding-left: 4px;font-size: 8pt;padding-bottom: 4px;margin: 20px 0px 10px;overflow: auto;border-left: gray 1px solid;width: 97.5%;cursor: text;line-height: 12pt;padding-top: 4px;border-bottom: gray 1px solid;font-family: consolas, 'Courier New', courier, monospace;background-color: #f4f4f4">
  <pre style="padding-right: 0px;padding-left: 0px;font-size: 8pt;padding-bottom: 0px;margin: 0em;overflow: visible;width: 100%;color: black;border-top-style: none;line-height: 12pt;padding-top: 0px;font-family: consolas, 'Courier New', courier, monospace;border-right-style: none;border-left-style: none;background-color: #f4f4f4;border-bottom-style: none">$(<span style="color: #006080">'tr'</span>)
    .filter(<span style="color: #006080">':even'</span>).addClass(<span style="color: #006080">'even-rows'</span>).end()
    .filter(<span style="color: #006080">':odd'</span>).addClass(<span style="color: #006080">'odd-rows'</span>).end()
    .hover(<span style="color: #0000ff">function</span>(){
               $(<span style="color: #0000ff">this</span>).addClass(<span style="color: #006080">'hover'</span>);
           },
           <span style="color: #0000ff">function</span>{
                $(<span style="color: #0000ff">this</span>).removeClass(<span style="color: #006080">'hover'</span>);

            });</pre>
</div>

&nbsp;

Here are the results

[<img style="border-right: 0px;border-top: 0px;border-left: 0px;border-bottom: 0px" height="117" alt="image" src="http://lostechies.com/johnteague/files/2011/03jQueryDemos_82A0/image_thumb_2.png" width="408" border="0" />](http://lostechies.com/johnteague/files/2011/03jQueryDemos_82A0/image_6.png) 

### A slightly Different Outcome with find() method

When writing these demos the first time, I accidentally used the **<font face="Courier New">find() </font>**method instead of **<font face="Courier New">filter()</font>** and got an interesting result that I though would be really useful someday.&nbsp; While filter reduces the original selection, find will select child elements that meet the new selector, so when I did this:

<div style="border-right: gray 1px solid;padding-right: 4px;border-top: gray 1px solid;padding-left: 4px;font-size: 8pt;padding-bottom: 4px;margin: 20px 0px 10px;overflow: auto;border-left: gray 1px solid;width: 97.5%;cursor: text;line-height: 12pt;padding-top: 4px;border-bottom: gray 1px solid;font-family: consolas, 'Courier New', courier, monospace;background-color: #f4f4f4">
  <pre style="padding-right: 0px;padding-left: 0px;font-size: 8pt;padding-bottom: 0px;margin: 0em;overflow: visible;width: 100%;color: black;border-top-style: none;line-height: 12pt;padding-top: 0px;font-family: consolas, 'Courier New', courier, monospace;border-right-style: none;border-left-style: none;background-color: #f4f4f4;border-bottom-style: none">$(<span style="color: #006080">'tr'</span>)
    .find(<span style="color: #006080">':even'</span>).css(<span style="color: #006080">'background-color'</span>,<span style="color: #006080">'grey'</span>).end()
    .find(<span style="color: #006080">':odd'</span>).css(<span style="color: #006080">'background-color'</span>,<span style="color: #006080">'#CCCCCC'</span>);
</pre>
</div>

I got this result:

[<img style="border-right: 0px;border-top: 0px;border-left: 0px;border-bottom: 0px" height="125" alt="image" src="http://lostechies.com/johnteague/files/2011/03jQueryDemos_82A0/image_thumb_6.png" width="397" border="0" />](http://lostechies.com/johnteague/files/2011/03jQueryDemos_82A0/image_14.png) 

Now my colums are alternating.&nbsp; Just something to keep in the back of your head when you need it 🙂

## Conclusion

This is a very simple demo, and you can find plenty of these all over the web.&nbsp; But this exposes you to jQuery selectors, css modification, event handling and traversal.&nbsp; There&#8217;s a lot more in the library, but we just hit a lot of them.