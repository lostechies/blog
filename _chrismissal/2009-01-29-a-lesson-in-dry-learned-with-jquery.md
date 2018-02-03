---
wordpress_id: 3342
title: A Lesson in DRY Learned with jQuery
date: 2009-01-29T17:55:00+00:00
author: Chris Missal
layout: post
wordpress_guid: /blogs/chrismissal/archive/2009/01/29/a-lesson-in-dry-learned-with-jquery.aspx
dsq_thread_id:
  - "262174813"
categories:
  - DRY
  - JQuery
---
While working on a credit card entry form I decided to add a dynamic block of XHTML to highlight the credit card that is entered by the user, while graying out others. In this code, I attempt to retrieve an image object in the DOM using simple string comparison based on the input of a text field. 

<pre style="background: black"><span style="background: black;color: white">    </span><span style="background: black;color: #ff8000">var </span><span style="background: black;color: white">$card = getCardByNumber($(</span><span style="background: black;color: #ff8000">this</span><span style="background: black;color: white">).val());
    </span><span style="background: black;color: #ff8000">if</span><span style="background: black;color: white">($card) {
        lowlightCards();
        highlightCard($card);
    } </span><span style="background: black;color: #ff8000">else </span><span style="background: black;color: white">{
        highlightCards();
    }
</span></pre>

[](http://11011.net/software/vspaste)

If nothing is found, we ensure that all the cards are highlighted. If a card object is found, gray them all out, but highlight the “found” card.

<table cellspacing="4" cellpadding="2" width="600" border="0">
  <tr>
    <td align="center" width="292">
      <p align="center">
        <a href="http://lostechies.com/chrismissal/files/2011/03/all_cards_on_76CCBF81.png"><img style="border-top-width: 0px;border-left-width: 0px;border-bottom-width: 0px;border-right-width: 0px" height="34" alt="all_cards_on" src="http://lostechies.com/chrismissal/files/2011/03/all_cards_on_thumb_2B00E8C8.png" width="179" border="0" /></a>&#160; <br />The display when no numbers match the card type pattern.
      </p>
    </td>
    
    <td align="center" width="294">
      <a href="http://lostechies.com/chrismissal/files/2011/03/visa_card_on_184BEF11.png"><img style="border-top-width: 0px;border-left-width: 0px;border-bottom-width: 0px;border-right-width: 0px" height="34" alt="visa_card_on" src="http://lostechies.com/chrismissal/files/2011/03/visa_card_on_thumb_6BC7E08C.png" width="179" border="0" /></a>&#160; <br />The display when a number matches the Visa card type pattern.
    </td>
  </tr>
</table>

The two functions that gray out all the cards, or subsequently highlight all the cards, originally looked like this. They were very similar and <a title="The DRY (Don&#039;t Repeat Yourself) Principle" href="http://c2.com/cgi/wiki?DontRepeatYourself" target="_blank">“Don’t Repeat Yourself” (DRY)</a> was screaming out loud. Time to refactor!

<pre style="background: black"><span style="background: black;color: white">    </span><span style="background: black;color: #ff8000">function </span><span style="background: black;color: white">highlightCards() {
        $(</span><span style="background: black;color: lime">".creditcardicon[src^='/Content/images/']"</span><span style="background: black;color: white">).each(</span><span style="background: black;color: #ff8000">function</span><span style="background: black;color: white">() {
            highlightCard($(</span><span style="background: black;color: #ff8000">this</span><span style="background: black;color: white">));
        });
    }
    </span><span style="background: black;color: #ff8000">function </span><span style="background: black;color: white">lowlightCards() { 
        $(</span><span style="background: black;color: lime">".creditcardicon[src^='/Content/images/']"</span><span style="background: black;color: white">).each(</span><span style="background: black;color: #ff8000">function</span><span style="background: black;color: white">() {
            lowlightCard($(</span><span style="background: black;color: #ff8000">this</span><span style="background: black;color: white">));
        });
    }
</span></pre>

[](http://11011.net/software/vspaste)

These worked and I could have left them alone, but a lot of my recent work in <a title="Functional C#" href="http://codebetter.com/blogs/matthew.podwysocki/archive/2008/06/06/functional-c-revisited-into-the-great-void.aspx" target="_blank">C# of passing around Funcs and Actions</a> made it clear to me that there was only one difference here. A difference that JavaScript is totally able to remedy. I’ll just pass into a single function, the difference, which is another function. Good ole’ JavaScript!

<pre style="background: black"><span style="background: black;color: white">    </span><span style="background: black;color: #ff8000">function </span><span style="background: black;color: white">eachCard(action) {
        $(</span><span style="background: black;color: lime">".creditcardicon[src^='/Content/images/']"</span><span style="background: black;color: white">).each(</span><span style="background: black;color: #ff8000">function</span><span style="background: black;color: white">() { action($(</span><span style="background: black;color: #ff8000">this</span><span style="background: black;color: white">)); });
    }
</span></pre>