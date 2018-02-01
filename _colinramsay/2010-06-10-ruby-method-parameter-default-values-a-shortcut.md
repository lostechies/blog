---
id: 4694
title: 'Ruby Method Parameter Default Values &#8211; A Shortcut'
date: 2010-06-10T17:05:00+00:00
author: Colin Ramsay
layout: post
guid: /blogs/colin_ramsay/archive/2010/06/10/ruby-method-parameter-default-values-a-shortcut.aspx
categories:
  - Ruby
---
Today was one of those moments where I thought to myself: &#8220;wouldn&#8217;t it be cool if I could&#8221;&#8230; and it turned out I could. In Ruby, you can give your method parameters default values:

<pre>def my_method(a = 5)
	puts a
end

my_method # outputs: 5
</pre>

So far, so ordinary. But you can also do something a bit more interesting &#8211; populate your parameter defaults from instance variables:

<pre>class MyClass
	def initialize
		@default_a = 5
	end

	def my_method(a = @default_a)
		puts a
	end
end

MyClass.new.my_method # outputs: 5</pre>

There&#8217;s probably some Ruby gurus looking at this and thinking \*OH MY GOD WHAT ARE YOU DOING\* but in my case, it saved me having to create a method which &#8220;seeded&#8221; a second method with some default values; a few lines of code successfully saved.