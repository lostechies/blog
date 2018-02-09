---
wordpress_id: 4639
title: 'BDD &#8211; Available Frameworks'
date: 2008-11-12T15:07:00+00:00
author: Colin Jack
layout: post
wordpress_guid: /blogs/colinjack/archive/2008/11/12/bdd-available-frameworks.aspx
categories:
  - Uncategorized
redirect_from: "/blogs/colinjack/archive/2008/11/12/bdd-available-frameworks.aspx/"
---
I&#8217;ve been using the [Astels style of BDD](http://blog.daveastels.com/files/BDD_Intro.pdf) for a while now but so far I&#8217;ve just done it using MSTest/NUnit and a few custom base classes. I think that&#8217;s a good way to start out, as with so many good things in life it doesn&#8217;t require a new whizzy tool/framework.

However I&#8217;ve just joined a new project and we&#8217;ve been looking at different frameworks that are available for unit testing and for BDD so I thought I&#8217;d post about what I&#8217;ve seen so far. Any opinions would be gladly received.

[<span style="font-weight: bold">MSpec</span>](http://codebetter.com/blogs/aaron.jensen/archive/2008/05/08/introducing-machine-specifications-or-mspec-for-short.aspx)  
This project is very cool, not only does it allow you to create superb specifications but you also get some nice reporting. Here&#8217;s a simple example of a sample spec:

<pre><p>
  &nbsp;
</p>

<pre><span style="color: #0000ff">public class </span><span style="color: #2b91af">When_adding_a_contact_to_a_user_with_no_existing_contacts<br /></span>{<br />  <span style="color: #0000ff">private static </span><span style="color: #2b91af">User </span>_user;<br />  <span style="color: #0000ff">private static </span><span style="color: #2b91af">Contact </span>_contact;<br /><br />  <span style="color: #2b91af">Establish </span>context_once =()=&gt;<br />  {<br />      _user = <span style="color: #0000ff">new </span><span style="color: #2b91af">TestUserBuilder</span>().Build();<br />      _contact = <span style="color: #0000ff">new </span><span style="color: #2b91af">ContactBuilder</span>().Build();<br />  };<br /><br />  <span style="color: #2b91af">Because </span>a_context_is_added =()=&gt;<br />      _user.Contacts.Add(_contact);<br /><br />  <span style="color: #0000ff">private </span><span style="color: #2b91af">It </span>should_associate_the_contact_with_the_user = () =&gt;<br />      _user.Contacts.Contains(_contact).ShouldBeTrue();<br />                                                           <br />}</pre>


<p>
  <a href="http://11011.net/software/vspaste"></a>
</p>


<p>
  &nbsp;
</p>


<p>
  One thing to note is if your planning to look at MSpec then you&#8217;ll probably want to download the <a href="http://codebetter.com/blogs/aaron.jensen/archive/2008/10/22/machine-has-moved.aspx">Machine codebase</a> since there aren&#8217;t many examples of using <a href="http://codebetter.com/blogs/aaron.jensen/archive/2008/05/08/introducing-machine-specifications-or-mspec-for-short.aspx">MSpec</a> on the Web the examples with Machine are a good starting point.
</p>


<p>
  So far there&#8217;s no R# integration but that doesn&#8217;t worry me at all as if needed it will come and this is still a very early version. 
</p>


<p>
  The reporting seems to work well, but we primarily use this style for unit/integration tests and so we are unlikely to present the reports outside the development team. Having said that <a href="http://codebetter.com/blogs/aaron.jensen/archive/2008/10/19/bdd-consider-your-audience.aspx">Aaron pointed out</a> that they can be useful within the development team, which makes a lot of sense.
</p>


<p>
  Overall my main worry is the syntax could be a bit much for some people, in particular if you go for the compact style:
</p>


<p>
  <span style="font-weight: bold">NUnit</span><br />I think there&#8217;s a good argument for just using a base class, especially when you are getting going with the approach: 
</p>


<pre><span style="color: #0000ff">public class </span><span style="color: #2b91af">When_adding_a_contact_to_a_user_with_no_existing_contacts </span>: <span style="color: #2b91af">SpecificationBaseNUnit<br /></span>{<br />  <span style="color: #0000ff">private </span><span style="color: #2b91af">User </span>_user;<br />  <span style="color: #0000ff">private </span><span style="color: #2b91af">Contact </span>_contact;<br /><br />  <span style="color: #0000ff">protected override void </span>EstablishContext()<br />  {<br />      _user = <span style="color: #0000ff">new </span><span style="color: #2b91af">TestUserBuilder</span>().Build();<br />      _contact = <span style="color: #0000ff">new </span><span style="color: #2b91af">ContactBuilder</span>().Build();<br />  }<br /><br />  <span style="color: #0000ff">protected override void </span>Act()<br />  {<br />      _user.Contacts.Add(_contact);<br />  }<br /><br />  [<span style="color: #2b91af">Test</span>]<br />  <span style="color: #0000ff">public void </span>should_associate_the_contact_with_the_user()<br />  {<br />      _user.Contacts.Contains(_contact).ShouldBeTrue();<br />  }<br />}</pre>


<p>
  This is a hopelessly naive example but you get the idea. You lose some of the syntax niceness, suddenly the specs themselves take up multiple lines because of all the curlies. You&#8217;ve also lost reporting, unless you put in some work yourself. However it is a little easier to understand and when introducing TDD/BDD that could be important.
</p>


<p>
  <span style="font-weight: bold">XUnit.net</span><br />I&#8217;m no XUnit.net expert but Ben Hall convinced us to give it a shot by recommending it and it is very nice. You can read about an approach that works <a href="http://www.bjoernrochel.de/2008/10/04/introducing-xunitbddextensions/">here</a>. If you use the specification base class described in that post you might end up with this:
</p>


<pre><span style="color: #008000">// Using base class influenced by http://www.bjoernrochel.de/2008/10/04/introducing-xunitbddextensions/<br /></span><span style="color: #0000ff">public class </span><span style="color: #2b91af">When_adding_a_contact_to_a_user_with_no_existing_contacts </span>: <span style="color: #2b91af">SpecificationBase<br /></span>{<br />  <span style="color: #0000ff">private </span><span style="color: #2b91af">User </span>_user;<br />  <span style="color: #0000ff">private </span><span style="color: #2b91af">Contact </span>_contact;<br /><br />  <span style="color: #0000ff">protected override void </span>EstablishContext()<br />  {<br />      _user = <span style="color: #0000ff">new </span><span style="color: #2b91af">TestUserBuilder</span>().Build();<br />      _contact = <span style="color: #0000ff">new </span><span style="color: #2b91af">ContactBuilder</span>().Build();<br />  }<br /><br />  <span style="color: #0000ff">protected override void </span>Because()<br />  {<br />      _user.Contacts.Add(_contact);<br />  }<br /><br />  [<span style="color: #2b91af">Observation</span>]<br />  <span style="color: #0000ff">public void </span>should_associate_the_contact_with_the_user()<br />  {<br />      _user.Contacts.Contains(_contact).ShouldBeTrue();<br />  }<br />}</pre>


<p>
  One aspect of XUnit that might throw you is how <a href="http://www.codeplex.com/xunit/Wiki/View.aspx?title=Comparisons">opinionated</a> it is, which could be an advantage or a disadvantage. An example is that it&#8217;s aiming for each test to run in isolation, so the fixture class is re-created each time and if you really want to reuse the fixture you implement <span style="font-style: italic"><span class="codeInline">IUseFixture. </span></span><span><span class="codeInline">I guess this is a very safe approach because it means tests/specs are extremely unlikely to affect each other, but it actually seems over-kill if you&#8217;re using a style where the specification methods only assert (no side-effects).</p>
  
  
  <p>
    </span></span><span><span class="codeInline">The lack of messages on assertions seems sensible, and it is for small focused BDD specifications, but if you use it for integration testing you would want the option of adding a message in.</span></span><br /><span><span class="codeInline"><br />On the syntax front we could always go for more flexibility:</p>
    
    
    <pre><span style="color: #0000ff">public class </span><span style="color: #2b91af">When_a_user_has_no_contacts </span>: <span style="color: #2b91af">FlexibileGrammarSpecificationBase<br /></span>{<br />  <span style="color: #0000ff">private </span><span style="color: #2b91af">User </span>_user;<br />  <span style="color: #0000ff">private </span><span style="color: #2b91af">Contact </span>_contact;<br /><br />  <span style="color: #0000ff">protected override void </span>EstablishContext()<br />  {<br />      _user = <span style="color: #0000ff">new </span><span style="color: #2b91af">TestUserBuilder</span>().Build();<br />      _contact = <span style="color: #0000ff">new </span><span style="color: #2b91af">ContactBuilder</span>().Build();<br />  }<br /><br />  [<span style="color: #2b91af">Because</span>]<br />  <span style="color: #0000ff">protected void </span>and_we_give_them_a_new_contact()<br />  {<br />      _user.Contacts.Add(_contact);<br />  }<br /><br />  [<span style="color: #2b91af">Observation</span>]<br />  <span style="color: #0000ff">public void </span>the_contact_should_be_associated_with_the_user()<br />  {<br />      _user.Contacts.Contains(_contact).ShouldBeTrue();<br />  }<br />}</pre>
    
    
    <p>
      However this seems a little pointless to me so I&#8217;ve dumped the idea.<br /><span style="font-weight: bold"><br />Summary</span><br />We decided to go with XUnit.net but we also plan to look at Ruby based solutions including RSpec and Cucumber. <a href="http://github.com/aslakhellesoy/cucumber/wikis">Cucumber</a> seems exciting as it lets you specify <a href="http://github.com/aslakhellesoy/cucumber/wikis/using-fit-tables-in-a-feature">table based specifications</a>, theoretically allowing us to get the advantages of a FIT style approach without having to use FIT (or <a href="http://blog.objectmentor.com/articles/2008/10/02/slim">SLIM</a>) itself.
    </p>
    
    
    <p>
      Ultimately there is a lot going on in the BDD space in Ruby-land (and a <a href="http://www.pragprog.com/titles/achbd/the-rspec-book">book</a> on the way) and the language does suit it quite well so we intend to do some playing. </span></span>
    </p>