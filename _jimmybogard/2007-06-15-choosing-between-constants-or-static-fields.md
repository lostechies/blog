---
wordpress_id: 31
title: Choosing between constants or static fields
date: 2007-06-15T15:09:00+00:00
author: Jimmy Bogard
layout: post
wordpress_guid: /blogs/jimmy_bogard/archive/2007/06/15/choosing-between-constants-or-static-fields.aspx
dsq_thread_id:
  - "265526633"
categories:
  - 'C#'
---
> _This post was originally published [here](http://grabbagoft.blogspot.com/2007/06/choosing-between-constants-or-static.html)._

I recently needed to add some code to our project that pulled some information out of configuration.&nbsp; The configuration is broken into sections and values, and I need to give the API a section name and a key name to retrieve the configuration value:

<div class="CodeFormatContainer">
  <pre><span class="kwrd">string</span> maxCouponLimit = configManager.GetValue(<span class="str">"storeOptions"</span>, <span class="str">"maxCouponLimit"</span>);<br /></pre>
</div>

The &#8220;storeOptions&#8221; configuration section in the config file had several other config values, so when I searched the solution for &#8220;storeOptions&#8221;, I found several dozen references of the exact same code getting different values out of the same section.&nbsp; This was a prime candidate for the [Replace Magic Number with Symbolic Constant](http://www.refactoring.com/catalog/replaceMagicNumberWithSymbolicConstant.html) refactoring.&nbsp; When I look around the Framework Class Library, I couldn&#8217;t find any constants, however.&nbsp; Why is this?

### Refactoring to a constants class

Let&#8217;s say I want to put the &#8220;storeOptions&#8221; value in a constants class:

<div class="CodeFormatContainer">
  <pre><span class="kwrd">public</span> <span class="kwrd">static</span> <span class="kwrd">class</span> ConfigurationSections<br />
{<br />
    <span class="kwrd">public</span> <span class="kwrd">const</span> <span class="kwrd">string</span> STORE_OPTIONS = <span class="str">"storeOptions"</span>;<br />
}<br />
</pre>
</div>

I have defined both a constant and a readonly static field for the configuration value.&nbsp; To illustrate how constants work first, I&#8217;ll change all references to &#8220;storeOptions&#8221; to use &#8220;ConfigurationSections.STORE_OPTIONS&#8221; instead.&nbsp; As it turns out, Joe from the accounting team also uses this configuration section in his assemblies, so I work with Joe to change all of his references to go to the constants class also.

### Now for a change

As we add more and more configuration values throughout development, it becomes clear to our team that the &#8220;storeOptions&#8221; section name has become a little&nbsp;misleading and we want to&nbsp;rename the section to &#8220;storePaymentOptions&#8221;.&nbsp; Since Joe&#8217;s assembly references our configuration assembly, all we need to do is change the constant value, rebuild, and redeploy, right?&nbsp; Wrong.&nbsp; When we redeploy, Joe&#8217;s assembly (which he can&#8217;t rebuild yet for some organizational reasons) breaks, and still references &#8220;storeOptions&#8221;.&nbsp; How is this possible when both of our assemblies are pointing to the same value?

### Compile time versus run time

The problem is that the value of constants are determined at compile time.&nbsp; That means that the value for the constant is actually substituted in the IL during compilation, so the final IL code **never references the original constant**.&nbsp; If I change the constant value, **every single assembly referencing the constant will need to be recompiled**.&nbsp; That&#8217;s not what I&#8217;d like to do.&nbsp; I just want to change the value and have all dependent assemblies pick up the new value.

Instead of using a constant, let&#8217;s use a static field instead:

<div class="CodeFormatContainer">
  <pre><span class="kwrd">public</span> <span class="kwrd">static</span> <span class="kwrd">class</span> ConfigurationSections<br />
{<br />
    <span class="kwrd">public</span> <span class="kwrd">static</span> <span class="kwrd">readonly</span> <span class="kwrd">string</span> StoreOptions = <span class="str">"storeOptions"</span>;<br />
}</pre>
</div>

Static field values are determined at **run-time** instead of compile time.&nbsp; I can change the value of the static field, only recompile the configuration assembly, and now all dependent assemblies referencing my static field will get the correct value!

### Conclusion

So the moral of the story is to always use static fields instead of constants.&nbsp; The compile-time nature of constants is one of those &#8220;gotchas&#8221; that can really kill you with crazy errors at deployment time.&nbsp; Additionally, static fields should be [named using PascalCasing](http://msdn2.microsoft.com/en-us/library/ms229012.aspx).&nbsp; Constants should be reserved for values that can and will never change.