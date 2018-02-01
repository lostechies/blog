---
id: 4690
title: Parsing XML-like Files
date: 2008-12-07T10:23:00+00:00
author: Colin Ramsay
layout: post
guid: /blogs/colin_ramsay/archive/2008/12/07/parsing-xml-like-files.aspx
categories:
  - CSS
  - fizzler
  - HTML
  - XML
  - xpath
---
The quantity of data now stored in XML, HTML, and other similar formats must now be absolutely huge. Fetching that data from XML-like files is largely seen as a solved problem on many platforms, but I&#8217;m going to look at the various alternatives and see where each would be appropriate and how you can improve the development process by using each method.

## The Manual Method

This is the one which makes me go \*yuck\* in a bit way. You can read in a file as a straightforward string or array of line strings, and skip to the part of the document you want. This is most definitely the manual method when it comes to parsing XML, because you&#8217;re not really taking an interest in whether the document&#8217;s XML or not. You&#8217;re not takin advantage of the structure and you&#8217;re treeating the file in the same way you would any flat file.

I saw this approach in a PHP application, and it was being used to parse HTML. In this environment I can kind of understand why you&#8217;d think about the manual method: PHP doesn&#8217;t have a built in means of parsing XML into HTML, so there&#8217;s no way of getting a structured document to even use PHP&#8217;s DOM support with. However, there are third-party libraries which support methods which are a bit less laborious.

## Taming HTML

Many platforms have libraries which parse HTML into a well-formed state to allow further processing. In fact, using HTML Tidy, you can do this manually from pretty much any platform. Some libraries will [wrap HTML Tidy](http://www.devx.com/dotnet/Article/20505/0/page/2) and some will provide [their own method](http://www.codeplex.com/htmlagilitypack), but the bottom line is that you&#8217;re likely to be able to leverage some tool to tame the horrific mess of HTML that is the world wide web.

## XPATH
  


With your HTML under control, or your XML at the ready, you&#8217;ve now got a chance to pull data from your document with some more advanced techniques. Most developers will have touched on XPATH at some time or another, as it&#8217;s commonplace within the ecosystems of most development platforms. The name gives it away &#8211; XPATH is XML Path Language, and allows the use of specialized queries to pull out parts of an XML document:

    //li

This XPATH expression specifies that we wish to find all <li> elements at any level of the document. More complex expressions are available, providing means of selecting elements based on attributes, values of nodes, and much more. The strength of XPATH is its availability. In the .NET world, for example, fast XML processing and XPATH are available as first-class members of the framework, only a using directive away. This makes the use of XPATH common-place.

## CSS Selectors

This alternative approach is less common due to the lack of first-class support in most frameworks. However, choice is good, so let&#8217;s look at the way in which CSS can pull out data from your XML documents. I suspect there are still developers out there with an aversion to CSS, so let&#8217;s be clear: this approach discusses CSS selectors, not layout with CSS. That means all of the strange behavious with comes with floating elements is not applicable here. We&#8217;re also not running CSS in the browser, so there are no incompatibility issues. This is a subset of CSS, working as advertised.

[Hpricot](http://code.whytheluckystiff.net/hpricot/) for Ruby, [phpQuery](http://code.google.com/p/phpquery/) for PHP and [my own Fizzler for .NET](http://code.google.com/p/fizzler/) are examples of this kind of solution. Here&#8217;s a simple sample using Fizzler:

    var engine = new Fizzler.Parser.SelectorEngine(html);
    engine.Parse(".content");

We start up Fizzler by passing in some HTML string, and then select any nodes with a class name of &#8220;content&#8221;. Fizzler uses HTML Agility Pack underneath, so the result comes back as a collection of nodes which you can further manipulate. 

## Conclusion

My rationale for developing Fizzler was a personal dislike of XPATH. Because I was strongly familiar with CSS, and because Fizzler supports some advanced CSS 3 selectors, it&#8217;s possible for me to achieve the same results using CSS selectors without the barrier for entry presented by XPATH. Your mileage may vary, depending on your experience with each technology, but Fizzler fills a gap in the .NET market and I hope some people will find it useful.