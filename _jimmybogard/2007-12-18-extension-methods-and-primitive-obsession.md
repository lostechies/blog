---
wordpress_id: 116
title: Extension methods and primitive obsession
date: 2007-12-18T21:29:30+00:00
author: Jimmy Bogard
layout: post
wordpress_guid: /blogs/jimmy_bogard/archive/2007/12/18/extension-methods-and-primitive-obsession.aspx
dsq_thread_id:
  - "264715468"
categories:
  - 'C#'
  - CodeSmells
redirect_from: "/blogs/jimmy_bogard/archive/2007/12/18/extension-methods-and-primitive-obsession.aspx/"
---
In another water-cooler argument today, a couple of coworkers didn&#8217;t like my [extension method example](http://grabbagoft.blogspot.com/2007/11/string-extension-methods.html).&nbsp; One main problem is that it violates instance semantics, where you expect that a method call off an instance won&#8217;t work if the instance is null.&nbsp; However, extension methods break that convention, leading the developer to question _every_ method call and wonder if it&#8217;s an extension method or not.&nbsp; For example, you can run into these types of scenarios:

<div class="CodeFormatContainer">
  <pre><span class="kwrd">string</span> nullString = <span class="kwrd">null</span>;

<span class="kwrd">bool</span> isNull = nullString.IsNullOrEmpty();
</pre>
</div>

In normal circumstances, the call to IsNullOrEmpty would throw a NullReferenceException.&nbsp; Since we&#8217;re using an extension method, we leave it up to the developer of the extension method to determine what to do with null references.

Since there&#8217;s no way to describe to the user of the API whether or not the extension method handles nulls, or _how_ it handles null references, this can lead to quite a bit of confusion to clients of that API, or later, those maintaining code using extension methods.

In addition to problems with dealing with null references (which [Elton](http://eltonomicon.blogspot.com/) pointed out, could be better handled with [design-by-contract](http://research.microsoft.com/specsharp/)), some examples of extension methods online propose examples that show more than a whiff of the &#8220;[Primitive Obsession](http://grabbagoft.blogspot.com/2007/12/dealing-with-primitive-obsession.html)&#8221; code smell:

  * [http://weblogs.asp.net/scottgu/archive/2007/03/13/new-orcas-language-feature-extension-methods.aspx](http://weblogs.asp.net/scottgu/archive/2007/03/13/new-orcas-language-feature-extension-methods.aspx "http://weblogs.asp.net/scottgu/archive/2007/03/13/new-orcas-language-feature-extension-methods.aspx") 
      * [http://davidhayden.com/blog/dave/archive/2006/11/30/ExtensionMethodsCSharp.aspx](http://davidhayden.com/blog/dave/archive/2006/11/30/ExtensionMethodsCSharp.aspx "http://davidhayden.com/blog/dave/archive/2006/11/30/ExtensionMethodsCSharp.aspx")</ul> 
    ### Dealing with primitive obsession
    
    In both of the examples above (Scott cites David&#8217;s example), an extension method is used to determine if a string is an email:
    
    <div class="CodeFormatContainer">
      <pre><span class="kwrd">string</span> email = txtEmailAddress.Text;

<span class="kwrd">if</span> (! email.IsValidEmailAddress())
{
    <span class="rem">// oh noes!</span>
}
</pre>
    </div>
    
    It&#8217;s something I&#8217;ve done a hundred times, taking raw text from user input and performing some validation to make sure it&#8217;s the &#8220;right&#8221; kind of string I want.&nbsp; But where do you stop with&nbsp;validation?&nbsp; Do you assume all throughout the application that this string is the correct kind of string,&nbsp;or do you duplicate the validation?
    
    An alternative approach is accept that classes are your friend, and create a small class to represent your &#8220;special&#8221; primitive.&nbsp; Convert back and forth at the boundaries between your system and customer-facing layers.&nbsp; Here&#8217;s the new Email class:
    
    <div class="CodeFormatContainer">
      <pre><span class="kwrd">public</span> <span class="kwrd">class</span> Email
{
    <span class="kwrd">private</span> <span class="kwrd">readonly</span> <span class="kwrd">string</span> _value;
    <span class="kwrd">private</span> <span class="kwrd">static</span> <span class="kwrd">readonly</span> Regex _regex = <span class="kwrd">new</span> Regex(<span class="str">@"^[w-.]+@([w-]+.)+[w-]{2,4}$"</span>);

    <span class="kwrd">public</span> Email(<span class="kwrd">string</span> <span class="kwrd">value</span>)
    {
        <span class="kwrd">if</span> (!_regex.IsMatch(<span class="kwrd">value</span>))
            <span class="kwrd">throw</span> <span class="kwrd">new</span> ArgumentException(<span class="str">"Invalid email format."</span>, <span class="str">"value"</span>);

        _value = <span class="kwrd">value</span>;
    }

    <span class="kwrd">public</span> <span class="kwrd">string</span> Value
    {
        get { <span class="kwrd">return</span> _value; }
    }

    <span class="kwrd">public</span> <span class="kwrd">static</span> <span class="kwrd">implicit</span> <span class="kwrd">operator</span> <span class="kwrd">string</span>(Email email)
    {
        <span class="kwrd">return</span> email.Value;
    }

    <span class="kwrd">public</span> <span class="kwrd">static</span> <span class="kwrd">explicit</span> <span class="kwrd">operator</span> Email(<span class="kwrd">string</span> <span class="kwrd">value</span>)
    {
        <span class="kwrd">return</span> <span class="kwrd">new</span> Email(<span class="kwrd">value</span>);
    }

    <span class="kwrd">public</span> <span class="kwrd">static</span> Email Parse(<span class="kwrd">string</span> email)
    {
        <span class="kwrd">if</span> (email == <span class="kwrd">null</span>)
            <span class="kwrd">throw</span> <span class="kwrd">new</span> ArgumentNullException(<span class="str">"email"</span>);

        Email result = <span class="kwrd">null</span>;

        <span class="kwrd">if</span> (!TryParse(email, <span class="kwrd">out</span> result))
            <span class="kwrd">throw</span> <span class="kwrd">new</span> FormatException(<span class="str">"Invalid email format."</span>);

        <span class="kwrd">return</span> result;
    }

    <span class="kwrd">public</span> <span class="kwrd">static</span> <span class="kwrd">bool</span> TryParse(<span class="kwrd">string</span> email, <span class="kwrd">out</span> Email result)
    {
        <span class="kwrd">if</span> (!_regex.IsMatch(email))
        {
            result = <span class="kwrd">null</span>;
            <span class="kwrd">return</span> <span class="kwrd">false</span>;
        }

        result = <span class="kwrd">new</span> Email(email);
        <span class="kwrd">return</span> <span class="kwrd">true</span>;
    }
}
</pre>
    </div>
    
    I do a few things to make it easy on developers to use an email class that can play well with strings as well as other use cases:
    
      * Made Email immutable 
          * Defined conversion operators to and from string 
              * Added the [Try-Parse pattern](http://msdn2.microsoft.com/en-us/library/ms229009.aspx)</ul> 
            The usage of the Email class closely resembles usage for other string-friendly types, such as DateTime:
            
            <div class="CodeFormatContainer">
              <pre><span class="kwrd">string</span> inputEmail = txtEmailAddress.Text;

Email email;

<span class="kwrd">if</span> (! Email.TryParse(inputEmail, <span class="kwrd">out</span> email))
{
    <span class="rem">// oh noes!</span>
}

txtEmailAddress.Text = email;
</pre>
            </div>
            
            Now I can go back and forth from strings and my Email class, plus I provided a way to convert without throwing exceptions.&nbsp; This looks very similar to code dealing with textual date representations.
            
            ### Yes, but
            
            The final Email class takes more code to write than the original extension method.&nbsp; However, now that we have a single class that plays nice with primitives, additional Email behavior has a nice home.&nbsp; With a class in place, I can now model more expressive emails, such as ones that include names like &#8220;Ricky Bobby&nbsp;<ricky.bobby@rb.com>&#8221;.&nbsp; Once the home is created, behavior can start moving in.&nbsp; Otherwise, validation would be sprinkled throughout the system at each user boundary, such as importing data, GUIs, etc.
            
            If you find yourself adding logic to primitives to the point of obsession, it&#8217;s&nbsp;a strong indicator you&#8217;re suffering from primitive obsession and a nice, small, specialized class can help eliminate a lot of the duplication primitive obsession tends to create.