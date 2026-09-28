---
wordpress_id: 4483
title: Hacking Websites with Ruby and Nokogiri
date: 2011-04-11T12:02:51+00:00
author: Rod Paddock
layout: post
wordpress_guid: http://lostechies.com/rodpaddock/?p=18
dsq_thread_id:
  - "276648521"
categories:
  - Ruby
tags:
  - css
  - html
  - ruby
---
Every once and a while we get a chance to use software for the good of others. Last week I had just that opportunity. The story begins with a website called Cinematical. Cinematical is a website dedicated to movies of which I have been an avid reader for a number of years. Flash forward to 2011 Cinematical is now owned by AOL, who just recently purchased the Huffington Post.  HuffPo has made the decision to move away from using freelance writers and editors to using permanent employees. This decision was codified in an e-mail last week where they were essentially told &#8220;We no longer need your skills as a free lancer but you can write for us for&#8230;.. Free&#8221;. Nice touch HuffPo. If you are interested this article does a good job of explaining this situation: <a title="Hollywood News Cinematical History" href="http://www.hollywoodnews.com/2011/04/07/boycott-aol-and-huffington-post-behind-the-untimely-death-of-cinematical/" target="_blank">http://www.hollywoodnews.com/2011/04/07/boycott-aol-and-huffington-post-behind-the-untimely-death-of-cinematical/</a>

UPDATE: A new first person account of the Cinematical Story: [](http://www.ericdsnider.com/snide/leaving-in-a-huff/)

<http://www.ericdsnider.com/snide/leaving-in-a-huff/>

So now we turn to last week. A couple of years ago I moved to Austin and it turns out that a lot of the freelancers who wrote for Cinematial live here and through happenstance I have become friends with a number of them. You can&#8217;t help it when you go to 100+ movies a year and see the same faces in the lobby. Eventually you have to say HI 🙂

Last week I saw a post from a friend of mine (we&#8217;ll call him Author-X) who is one of these free lancers. He was asking if anyone knew how to &#8220;scrape&#8221; all of his articles off of Cinematical&#8217;s web site. You see Author-X (and it turns out a lot of the other writers) didn&#8217;t save copies of their work and wanted copies.

Well I am a hacker and I really didn&#8217;t agree with the decisions of HuffPo so I decided to take on this challenge to see if I could help Author-X.  So I cracked open my handy dandy text editor and started working.

It turns out this was pretty simple thanks to a killer Ruby Gem called Nokogiri ( <a title="Nokogiri" href="http://nokogiri.org/" target="_blank">http://nokogiri.org/</a> ). Nokogiri is a library that makes it very simple to parse HTML pages using CSS style syntax.  So here&#8217;s the thought process behind this.

  1. Query all articles that Author-X had written.
  2. Go to each article and scrape the contents.
  3. Save contents to text file.

So here&#8217;s how it worked:

### Query All Author&#8217;s Articles

Lucky for us Cinematical organized its articles by author. For instance Author-X&#8217;s articles can be found using this link: <http://blog.moviefone.com/bloggers/author-x/> So this was to be our starting point. I opened his page and paged through his articles. They used a pattern of adding &#8220;page\2, page\3&#8221;, at the end of the url. Ok so now I now knew how to retrieve all of his articles. I simply needed to create a URL containing the page number and use that as my source of data. Here is the basic loop for doing this:

<pre>author = 'author-x'
1.upto(300) do |page|
  urltext = 'http://blog.moviefone.com/bloggers/' + author
  urltext &lt;&lt; '/page/' +  page.to_s + '/'
  doc = Nokogiri::HTML(open(urltext))
end</pre>

&nbsp;

The next step was to see if we could pull the links to each article from each page of articles. Well this is where the real power of Nokogiri comes in. The beautiful thing about Nokogiri is that it allows us to parse pages using CSS syntax. Being an avid jQuery coder I was right at home.  The code to pull out all links from this page is as follows:

<pre>doc = Nokogiri::HTML(open(urltext))
doc.css('h2 &gt; a').each do |a_tag|
  puts "========================================"
  puts a_tag.content
  puts a_tag['href']
end</pre>

&nbsp;

As you can see I simply look for all H2 tags with an anchor child item. Another nice thing about the Cinematical site was it&#8217;s consistent layout. Having a consistent layout makes it simpler to parse out. Lucky for us pulling the links to each article was as simple as the code shown above.

The last step was to follow each URL and retrieve the article content.

### Go To Each Article and Scrape Its Content

Now that we had the links to each article we simply needed to load the contents of that page and strip the contents. We did this with another call to Nokogiri.

<pre>doc2 = Nokogiri::HTML(open(a_tag['href']))
  doc2.css('.post-body').each do |article|
  puts article.content
end</pre>

&nbsp;

Once again the consistency of the site assisted. We simply needed to query for a CSS class called  **.post-body** and we were home free.

### The Whole Enchilada

So here&#8217;s the final code. We have a few items in there like saving to the file, exception checking (some of the URL&#8217;s were misformed), and an array of authors we wanted content for. Here ya go:

<pre>require 'rubygems'
require 'open-uri'
require 'nokogiri'

authors = ['author-X','author2','author3',
  'author4','author5']

authors.each do |author|
  f = File.new(author + ".txt",'w')

  1.upto(5) do |page|
    urltext = 'http://blog.moviefone.com/bloggers/' + author
    urltext &lt;&lt; '/page/' +  page.to_s + '/'
    puts urltext
    f.puts urltext
    doc = Nokogiri::HTML(open(urltext))
    doc.css('h2 &gt; a').each do |a_tag|
      begin
        f.puts "==============================="
        f.puts a_tag.content
        f.puts a_tag['href']

        doc2 = Nokogiri::HTML(open(a_tag['href']))
        doc2.css('.post-body').each do |article|
          f.puts article.content
        end
        f.puts "==============================="
      rescue
        puts "ERROR DOWNLOADING:"+ a_tag['href']
        f.puts "ERROR DOWNLOADING:"+ a_tag['href']
      end

    end
  end
end</pre>

<pre></pre>

As you can see this is pretty simple. I was amazed at what I was able to pull off in 38 lines of code.

&nbsp;