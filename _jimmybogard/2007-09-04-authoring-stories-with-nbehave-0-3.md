---
wordpress_id: 59
title: Authoring stories with NBehave 0.3
date: 2007-09-04T21:39:00+00:00
author: Jimmy Bogard
layout: post
wordpress_guid: /blogs/jimmy_bogard/archive/2007/09/04/authoring-stories-with-nbehave-0-3.aspx
dsq_thread_id:
  - "265153437"
categories:
  - 'Behave#'
  - NBehave
redirect_from: "/blogs/jimmy_bogard/archive/2007/09/04/authoring-stories-with-nbehave-0-3.aspx/"
---
> _This post was originally published [here](http://grabbagoft.blogspot.com/2007/09/authoring-stories-with-nbehave-03.html)._

As [Joe](http://www.lostechies.com/blogs/joe%5Focampo/) [already mentioned](http://www.lostechies.com/blogs/joe_ocampo/archive/2007/09/03/behave-merges-with-nbehave.aspx), Behave# has merged with NBehave.&nbsp; The merged NBehave will still be hosted on [CodePlex](http://www.codeplex.com/), and the [old project site](http://www.codeplex.com/BehaveSharp) will redirect to the new [CodePlex NBehave site](http://www.codeplex.com/NBehave).&nbsp; With the announcement of the merge comes the first release of our merging efforts (0.3), which you can find [here](http://www.codeplex.com/NBehave/Release/ProjectReleases.aspx?ReleaseId=6849).

The new release added quite a few features over the previous release, including:

  * Pending scenarios 
      * Console runner 
          * Decorate your tests with &#8220;Theme&#8221; and &#8220;Story&#8221; attributes 
              * Scenario result totals 
                  * Dry run output</ul> </ul> 
            The major addition is the console runner feature.&nbsp; One problem we always ran into was that as developers, we wanted to get pass/fail totals based on scenarios (not tests) so that we could have more meaningful totals that matched our original stories.&nbsp; A single story could have several scenarios, but would only report as one &#8220;Pass&#8221; or &#8220;Fail&#8221; to NUnit.&nbsp; Additionally, this is the first release that compares fairly evenly with the first release of [rbehave](http://rubyforge.org/projects/rbehave/).
            
            So how can we use NBehave to accomplish this?&nbsp; As always, we&#8217;ll start with the story.
            
            #### The Story
            
            I&#8217;ve received a few comments for&nbsp;a different example than the &#8220;Account&#8221; example.&nbsp; I&#8217;ll just pull an example from [Jimmy Nilsson&#8217;s](http://jimmynilsson.com/blog/) excellent [Applying Domain-Driven Design and Patterns book](http://www.amazon.com/Applying-Domain-Driven-Design-Patterns-Examples/dp/0321268202)&nbsp;(from page 118):
            
            <pre>List customers by applying a flexible and complex filter.</pre>
            
            Not story-friendly, but a&nbsp;description below lets me create a meaningful story:
            
            <pre>As a customer support staff
I want to search for customers in a very flexible manner
So that I can find a customer record and provide them meaningful support.</pre>
            
            I&#8217;m playing both developer and business owner, but normally these stories would be written by the customer.&nbsp; Otherwise, so far so good.&nbsp; What about a scenario for this story?&nbsp; Looking further into the book, I found a suitable scenario on page 122.&nbsp; Reworded in the BDD syntax, I arrive at:
            
            <pre>Scenario: Find by name

Given a set of valid customers
When I ask for an existing name
Then the correct customer is found and returned.</pre>
            
            Right now, I only care about finding&nbsp;by name.&nbsp; It could be argued&nbsp;that the original story is too&nbsp;broad, but it will suffice for this example.&nbsp;&nbsp;I&#8217;m confident those conversations will take place during iteration planning meetings in any case.
            
            Now that we have a story and a scenario, I can author the story in NBehave.&nbsp; First, I&#8217;ll need to set up my environment to use NBehave.
            
            #### Setting up the environment
            
            I use a fairly common source tree for most projects:
            
            ![](http://s3.amazonaws.com/grabbagoftimg/NBehaveExample_SourceTree.PNG)
            
            All&nbsp;dependencies (i.e.&nbsp;assemblies in&nbsp;the References of my project) go into the &#8220;lib&#8221; folder.&nbsp; All tools,&nbsp;like&nbsp;NAnt, NUnit, etc. that are used as part of the build go into the&nbsp;&#8220;tools&#8221; folder.&nbsp;&nbsp;For NBehave, I&#8217;ve copied the &#8220;NBehave.Framework.dll&#8221; into the &#8220;lib&#8221; folder, and the entire NBehave release goes into its own folder in the &#8220;tools&#8221; folder.&nbsp; For more information about this setup, check out [Tree Surgeon](http://www.codeplex.com/treesurgeon).
            
            Now that I have NBehave in my project, I&#8217;m ready to write some NBehave stories and scenarios.
            
            #### The initial scenario
            
            Before I get started authoring the story and scenario, I need to create a project for these scenarios.&nbsp; If I have a project named MyProject, its scenarios will be in a MyProject.Scenarios project.&nbsp; Likewise, its specifications will be in a MyProject.Specifications project.&nbsp; You can combine the stories and specifications into one project if you like.&nbsp; Finally, I create a class that will contain all of the stories in my &#8220;customer search&#8221; theme.
            
            I don&#8217;t name the class after the **class** it might be testing, instead I name it after the **theme**.&nbsp; The reason is that the implementation of the stories and scenarios can (and will) change independently of the story and scenario definition.&nbsp; **Stories and scenarios shouldn&#8217;t be tied to implementation details.**
            
            After adding a reference to NBehave and NUnit from the &#8220;lib&#8221; folder, Here&#8217;s what my solution tree looks like at this point:
            
            ![](http://s3.amazonaws.com/grabbagoftimg/NBehaveExample_SolutionTree.PNG)
            
            Note that I&nbsp;named my&nbsp;file after the theme, not&nbsp;the class I&#8217;m likely to test (CustomerRepository).&nbsp; Here&#8217;s my entire&nbsp;story file:
            
            <div class="CodeFormatContainer">
              <pre><span class="kwrd">using</span> NBehave.Framework;

<span class="kwrd">namespace</span> NBehaveExample.Core.Specifications
{
    [Theme(<span class="str">"Customer search"</span>)]
    <span class="kwrd">public</span> <span class="kwrd">class</span> CustomerSearchSpecs
    {
        [Story]
        <span class="kwrd">public</span> <span class="kwrd">void</span> Should_find_customers_by_name_when_name_matches()
        {
            Story story = <span class="kwrd">new</span> Story(<span class="str">"List customers by name"</span>);

            story.AsA(<span class="str">"customer support staff"</span>)
                .IWant(<span class="str">"to search for customers in a very flexible manner"</span>)
                .SoThat(<span class="str">"I can find a customer record and provide meaningful support"</span>);

            story.WithScenario(<span class="str">"Find by name"</span>)
                .Pending(<span class="str">"Search implementation"</span>)

                .Given(<span class="str">"a set of valid customers"</span>)
                .When(<span class="str">"I ask for an existing name"</span>)
                .Then(<span class="str">"the correct customer is found and returned"</span>);
        }
    }
}
</pre>
            </div>
            
            A few things to note here:
            
              * Theme classes are decorated with the **Theme attribute** 
                  * Themes have a mandatory title
                  * Story methods are decorated&nbsp;with the **Story attribute** 
                      * The initial story is marked **Pending**, with an included reason</ul> 
                    The attributes are identical in function to the &#8220;TestFixture&#8221; and &#8220;Test&#8221; attributes of NUnit, where they inform NBehave that this class is a Theme class and it contains Story methods.&nbsp; NBehave finds classes marked with the Theme attribute, and executes methods marked with the Story attribute.
                    
                    Now that we have a skeleton story definition in place, I can run the stories as part of my build
                    
                    #### Using the console runner
                    
                    New in NBehave 0.3 is the console runner, which runs the Themes and Stories and collects metrics from those runs.&nbsp; To run the above stories, I use the following command:
                    
                    <pre>NBehave-Console.exe NBehaveExample.Core.Scenarios.dll</pre>
                    
                    From the console runner, I get the following output:
                    
                    <pre>NBehave version 0.3.0.0
Copyright (C) 2007 Jimmy Bogard.
All Rights Reserved.

Runtime Environment -
   OS Version: Microsoft Windows NT 5.2.3790 Service Pack 1
  CLR Version: 2.0.50727.1378

P
Scenarios run: 1, Failures: 0, Pending: 1

Pending:
1) List customers by name (Find by name): Search implementation</pre>
                    
                    I only have one scenario thus far, but NBehave tells me several things so far:
                    
                      * Dot results 
                          * A series of one character results shows me I have one scenario pending (similar to the dots NUnit outputs)
                          * Result totals 
                              * Includes total scenarios run, number of failures, and number of pending scenarios
                              * Individual&nbsp;summary result 
                                  * List of&nbsp;failing and pending scenarios 
                                      * Name of&nbsp;story, scenario, and pending/failing reason</ul> 
                                
                                Let&#8217;s say I want a dry-run of the scenario output for documentation purposes:
                                
                                <pre>NBehave-Console.exe NBehaveExample.Core.Scenarios.dll /dryRun /storyOutput:stories.txt</pre>
                                
                                I&#8217;ve set two switches for the console runner, one to do a dry run and one to have a file where the stories will be output.&nbsp; Story output can be turned on regardless if I&#8217;m doing&nbsp;a dry run or not.&nbsp; Here&#8217;s the contents of &#8220;stories.txt&#8221; after I run the statement above:
                                
                                <pre>Theme: Customer search

	Story: List customers by name
	
	Narrative:
		As a customer support staff
		I want to search for customers in a very flexible manner
		So that I can find a customer record and provide meaningful support
	
		Scenario 1: Find by name
			Pending: Search implementation
			Given a set of valid customers
			When I ask for an existing name
			Then the correct customer is found and returned
</pre>
                                
                                This output provides a nice, human-readable format describing the stories that make up my system.
                                
                                Now that I have a story, let&#8217;s make the story pass, using TDD with Red-Green-Refactor.
                                
                                #### Make it fail
                                
                                First, I&#8217;ll add just enough to my story implementation to make it compile:
                                
                                <div class="CodeFormatContainer">
                                  <pre>[Story]
<span class="kwrd">public</span> <span class="kwrd">void</span> Should_find_customers_by_name_when_name_matches()
{
    Story story = <span class="kwrd">new</span> Story(<span class="str">"List customers by name"</span>);

    story.AsA(<span class="str">"customer support staff"</span>)
        .IWant(<span class="str">"to search for customers in a very flexible manner"</span>)
        .SoThat(<span class="str">"I can find a customer record and provide meaningful support"</span>);

    CustomerRepository repo = <span class="kwrd">null</span>;
    Customer customer = <span class="kwrd">null</span>;

    story.WithScenario(<span class="str">"Find by name"</span>)
        .Given(<span class="str">"a set of valid customers"</span>,
            <span class="kwrd">delegate</span> { repo = CreateDummyRepo(); })
        .When(<span class="str">"I ask for an existing name"</span>, <span class="str">"Joe Schmoe"</span>,
            <span class="kwrd">delegate</span>(<span class="kwrd">string</span> name) { customer = repo.FindByName(name); })
        .Then(<span class="str">"the correct customer is found and returned"</span>,
            <span class="kwrd">delegate</span> { Assert.That(customer.Name, Is.EqualTo(<span class="str">"Joe Schmoe"</span>)); });
}
</pre>
                                </div>
                                
                                All I&#8217;ve done is removed the Pending call on the scenario and added the correct actions for the Given, When, and Then fragments.&nbsp; The &#8220;CreateDummyRepo&#8221; method is just&nbsp;a helper method to set up a CustomerRepository:
                                
                                <div class="CodeFormatContainer">
                                  <pre><span class="kwrd">private</span> CustomerRepository CreateDummyRepo()
{
    Customer joe = <span class="kwrd">new</span> Customer();
    joe.CustomerNumber = 1;
    joe.Name = <span class="str">"Joe Schmoe"</span>;

    Customer bob = <span class="kwrd">new</span> Customer();
    bob.CustomerNumber = 1;
    bob.Name = <span class="str">"Bob Schmoe"</span>;

    CustomerRepository repo = <span class="kwrd">new</span> CustomerRepository(<span class="kwrd">new</span> Customer[] { joe, bob });

    <span class="kwrd">return</span> repo;
}
</pre>
                                </div>
                                
                                I compile successfully and run NBehave, and get a failure as expected:
                                
                                <pre>F
Scenarios run: 1, Failures: 1, Pending: 0

Failures:
1) List customers by name (Find by name) FAILED
  System.NullReferenceException : Object reference not set to an instance of an object.
   at NBehaveExample.Core.Specifications.CustomerSearchSpecs.&lt;&gt;c__DisplayClass3.b__2() in C:devNBehaveExamplesrcNBehaveExample.Core.SpecificationsCustomerSearchSpecs.cs:line 28
   at NBehave.Framework.Story.&lt;&gt;c__DisplayClass1.b__0()
   at NBehave.Framework.Story.InvokeActionBase(String type, String message, Object originalAction, Action actionCallback, String outputMessage, Object[] messageParameters)
</pre>
                                
                                Now that I&#8217;ve made it fail, let&#8217;s calibrate the test and put only enough code in the FindByName method to make the test pass.
                                
                                #### Make it pass
                                
                                To make the test pass, I&#8217;ll just return a hard-coded Customer object:
                                
                                <div class="CodeFormatContainer">
                                  <pre><span class="kwrd">public</span> Customer FindByName(<span class="kwrd">string</span> name)
{
    Customer customer = <span class="kwrd">new</span> Customer();
    customer.Name = <span class="str">"Joe Schmoe"</span>;
    <span class="kwrd">return</span> customer;
}
</pre>
                                </div>
                                
                                NBehave now tells me that I have 1 scenario run with 0 failures:
                                
                                <pre>.
Scenarios run: 1, Failures: 0, Pending: 0
</pre>
                                
                                The dot signifies a passing scenario.&nbsp; Now I can make the code correct and put in some implementation.
                                
                                #### Make it right
                                
                                Since CustomerRepository is just sample code for now, it only uses a List<Customer> for its backing store.&nbsp; Searching isn&#8217;t that difficult as I&#8217;m not involving the database at this time:
                                
                                <div class="CodeFormatContainer">
                                  <pre><span class="kwrd">public</span> Customer FindByName(<span class="kwrd">string</span> name)
{
    <span class="kwrd">return</span> _customers.Find(<span class="kwrd">delegate</span>(Customer customer) { <span class="kwrd">return</span> customer.Name == name; });
}
</pre>
                                </div>
                                
                                With this implementation in place, NBehave tells me I&#8217;m still green:
                                
                                <pre>.
Scenarios run: 1, Failures: 0, Pending: 0
</pre>
                                
                                I can now move on to the next scenario.&nbsp; If I had additional specifications for CustomerRepository not captured in the story, I can go to my Specifications project to detail them there.
                                
                                #### Where we&#8217;re going
                                
                                With NBehave&#8217;s console runner, I can now easily include NBehave as part of my build.&nbsp; I&#8217;m not piggy-backing NUnit for executing and reporting tests, as I&#8217;m writing Stories and Scenarios, not Tests.&nbsp; This option is still available to me and I can create stories inside of tests, so we&#8217;re not forcing anyone to use the Theme and Story attributes if they don&#8217;t want to.
                                
                                It&#8217;s a good start, but there are a few things still lacking:
                                
                                  * Integration with testing/specification frameworks 
                                      * The story for authoring the &#8220;Then&#8221; part of the scenario still isn&#8217;t that great
                                      * Features targeted for automated builds/CI 
                                          * XML output 
                                              * A nice XSLT formatter for XML output 
                                                  * HTML output of stories in addition to raw text 
                                                      * Integration with CC.NET</ul> 
                                                      * Setup/Teardown for stories/themes, with appropriate BDD names 
                                                          * Not sure, since having everything encapsulated in the story can direct my API better</ul> 
                                                    Happy coding!