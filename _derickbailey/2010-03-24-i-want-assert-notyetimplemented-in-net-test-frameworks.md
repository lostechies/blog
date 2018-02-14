---
wordpress_id: 122
title: I Want Assert.NotYetImplemented(); In .NET Test Frameworks
date: 2010-03-24T14:22:55+00:00
author: Derick Bailey
layout: post
wordpress_guid: /blogs/derickbailey/archive/2010/03/24/i-want-assert-notyetimplemented-in-net-test-frameworks.aspx
dsq_thread_id:
  - "262068522"
categories:
  - .NET
  - Agile
  - AntiPatterns
  - 'C#'
  - Community
  - Continuous Integration
  - Resharper
  - RSpec
  - Ruby
  - Test Automation
  - Tools and Vendors
  - Unit Testing
redirect_from: "/blogs/derickbailey/archive/2010/03/24/i-want-assert-notyetimplemented-in-net-test-frameworks.aspx/"
---
One of my coworkers recently tweeted this:

[<img style="border-bottom: 0px;border-left: 0px;border-top: 0px;border-right: 0px" border="0" alt="Just wrote a bunch of failing unit tests that describe how a class should work. Leaving them as failing, so I know where to start tomorrow." src="http://lostechies.com/content/derickbailey/uploads/2011/03/image_0207E919.png" width="266" height="87" />](http://twitter.com/RossCode/status/10963796437) 

I do that a lot with c# and nunit. It helps me to figure out where I need to go, what tests are going to be organized where, etc. I certainly don’t expect my first pass at the tests to be the final layout, and I don’t try and get every last test laid out all at once. I just lay down the ones that I know of immediately. I also tend to add new test shells as I am working in the tests and implementation, as I think of scenarios. This gives me a good place to start and a overview of what the code should be doing at a point right in between the user story and the implementation. Leaving the tests failing (with a “throw NotImplementedException()” or an “Assert.Fail(“not yet implemented”)”) gives me the freedom to go about my business and focus in on what i should be doing next, without having to worry about keeping track of the things i will be doing in the future. It’s quite nice, really. I’ve been doing this for a while now, and it works for me.

But… here’s the thing that started bothering me this morning: if I were writing ruby instead of c#, there’s no way I would leave failing tests lying around like this. Worse yet, if I were writing code in collaboration with any of my coworkers, I would not want to burden them with these failing tests. After all, if I commit these test to source control, then I’ll fail the build and that’s definitely not what I want to do. So, instead, I find myself keeping my code locally (in git, of course… local source control safety) and not sharing with anyone else until I’m done with the tests that I laid out.

This is counter to the collaborative, incremental nature of software development that we should be employing. The only time I should horde my code on my local box is when I am in the middle of working on something and it is obviously broken. Otherwise, I should be pushing my changes into the shared source control whenever I have parts of it working.

&#160;

### Taking A Lesson From RSpec

If I were writing ruby and rspec tests, I wouldn’t have this problem. I could simply omit the code block for my tests like this:

<div>
  <div>
    <pre><span style="color: #606060">   1:</span> describe <span style="color: #006080">"when something is happening here"</span> <span style="color: #0000ff">do</span></pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">   2:</span>   it <span style="color: #006080">"should do this thing"</span></pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">   3:</span>   </pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">   4:</span>   it <span style="color: #006080">"should do that thing"</span></pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">   5:</span>   </pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">   6:</span>   it <span style="color: #006080">"should do some other thing"</span></pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">   7:</span> end</pre>
    
    <p>
      <!--CRLF--></div> </div> 
      
      <p>
        by leaving out the “do … end” code blocks in each of the “it” tests, rspec will gracefully produce the type of results that allow me to have my not yet implemented tests, but still share my code and my tests with the rest of the team:
      </p>
      
      <p>
        <img style="border-bottom: 0px;border-left: 0px;border-top: 0px;border-right: 0px" border="0" alt="image" src="http://lostechies.com/content/derickbailey/uploads/2011/03/image_1A978669.png" width="997" height="474" />
      </p>
      
      <p>
        The tests come back as a nice yellow color with a message stating that they are not yet implemented. It is easy for me to see where I should be working next, yet still commit this code to the shared source control and have other team members and the build server run without being clobbered by me failing tests.
      </p>
      
      <p>
        &#160;
      </p>
      
      <h3>
        I Want Assert.NotYetImplemented
      </h3>
      
      <p>
        That’s what I want… I want the ability to have a not yet implemented test, like rspec. It should not be too terribly difficult for the Nunit, xUnit, MBUnit, MSpec, and other test framework crews to add in this code. Something as simple as this would work:
      </p>
      
      <div>
        <div>
          <pre><span style="color: #606060">   1:</span> [Test]</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">   2:</span> <span style="color: #0000ff">public</span> <span style="color: #0000ff">void</span> some_test_that_i_will_care_about_soon()</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">   3:</span> {</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">   4:</span>   Assert.NotYetImplemented();</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">   5:</span> }</pre>
          
          <p>
            <!--CRLF--></div> </div> 
            
            <p>
              And then we can get the CI build servers like CCNet, Hudson, TeamCity, etc, and the test runners like Resharper, Gallio and TestDriven.NET to join in and update how they report tests. It will take time, of course… there are a lot of players in the .NET community that would need to coordinate this type of change… but it’s worth it. It gives us a lot more flexibility in how we operate in our teams.
            </p>