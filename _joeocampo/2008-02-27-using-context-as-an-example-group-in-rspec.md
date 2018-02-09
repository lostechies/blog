---
wordpress_id: 105
title: 'Using  Context as an example group in rSpec'
date: 2008-02-27T21:22:00+00:00
author: Joe Ocampo
layout: post
wordpress_guid: /blogs/joe_ocampo/archive/2008/02/27/using-context-as-an-example-group-in-rspec.aspx
dsq_thread_id:
  - "262089650"
categories:
  - RSpec
  - Ruby
redirect_from: "/blogs/joe_ocampo/archive/2008/02/27/using-context-as-an-example-group-in-rspec.aspx/"
---
If you try to do the following in rSpec you will receive a (nil:NilClass) error on the inner context in the &#8216;before&#8217; statement when it tries to use @user.

<div>
  <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;font-size: 8pt;width: 100%;color: black;line-height: 12pt;font-family: consolas,'Courier New',courier,monospace;background-color: #f4f4f4">describe User <span style="color: #0000ff">do</span><br /><br />    before(:each) <span style="color: #0000ff">do</span><br />        @user = User.<span style="color: #0000ff">new</span><br />    end<br /><br />    context <span style="color: #006080">"(adding assigned role)"</span> <span style="color: #0000ff">do</span><br />        before(:each) <span style="color: #0000ff">do</span><br />            @user.assign_role(<span style="color: #006080">"Manager"</span>)<br />        end<br /><br />        specify <span style="color: #006080">"should be in any roles assigned to it"</span> <span style="color: #0000ff">do</span><br />            @user.should be_in_role(<span style="color: #006080">"Manager"</span>)<br />        end<br />       <br />        specify <span style="color: #006080">"should not be in any role not assigned to it"</span> <span style="color: #0000ff">do</span><br />            @user.should_not be_in_role(<span style="color: #006080">"unassigned role"</span>)<br />        end<br />    end<br />   <br />    context <span style="color: #006080">"(adding assigned group)"</span> <span style="color: #0000ff">do</span><br /><br />    end<br />end</pre>
</div>

This perplexed me because the rDoc indicates that [context] method is an alias for [describe] method. Turns out there are two different places where describe is defined. One in main (the outermost layer) and one inside an ExampleGroup. The one in the example group isn&#8217;t aliased.

So to solve that for the short term in your own code you can do this in your spec_helper.rb file:

<div>
  <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;font-size: 8pt;width: 100%;color: black;line-height: 12pt;font-family: consolas,'Courier New',courier,monospace;background-color: #f4f4f4">module Spec::Example::ExampleGroupMethods<br /> alias :context :describe<br />end</pre>
</div>

In your spec file add the following to the header assuming the spec_helper.rb is in the same directory: 

<div>
  <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;font-size: 8pt;width: 100%;color: black;line-height: 12pt;font-family: consolas,'Courier New',courier,monospace;background-color: #f4f4f4">require File.dirname(__FILE__) + <span style="color: #006080">'/spec_helper'</span></pre>
</div>

Now everything should work out great!&nbsp; BDD sweetness!&nbsp; Here is the final user_spec.rb

<div>
  <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;font-size: 8pt;width: 100%;color: black;line-height: 12pt;font-family: consolas,'Courier New',courier,monospace;background-color: #f4f4f4">require <span style="color: #006080">'user'</span><br />require File.dirname(__FILE__) + <span style="color: #006080">'/spec_helper'</span><br /><br />describe User <span style="color: #0000ff">do</span><br />    <br />    before(:each) <span style="color: #0000ff">do</span><br />        @user = User.<span style="color: #0000ff">new</span><br />    end<br /><br />    context <span style="color: #006080">"(adding assigned role)"</span> <span style="color: #0000ff">do</span><br />        before(:each) <span style="color: #0000ff">do</span><br />            @user.assign_role(<span style="color: #006080">"Manager"</span>)<br />        end<br /><br />        specify <span style="color: #0000ff">do</span><br />            @user.should be_in_role(<span style="color: #006080">"Manager"</span>)<br />        end<br />        <br />        specify <span style="color: #0000ff">do</span> <br />            @user.should_not be_in_role(<span style="color: #006080">"unassigned role"</span>)<br />        end<br />    end <br />    <br />    describe <span style="color: #006080">"(adding assigned group)"</span> <span style="color: #0000ff">do</span><br />    end <br />end</pre>
</div>

&nbsp;

Happy coding!