---
wordpress_id: 168
title: 'Guidelines aren&#8217;t rules'
date: 2008-04-15T11:24:15+00:00
author: Jimmy Bogard
layout: post
wordpress_guid: /blogs/jimmy_bogard/archive/2008/04/15/guidelines-aren-t-rules.aspx
dsq_thread_id:
  - "264715647"
categories:
  - ASPNETMVC
  - DomainDrivenDesign
redirect_from: "/blogs/jimmy_bogard/archive/2008/04/15/guidelines-aren-t-rules.aspx/"
---
I&#8217;m a huge fan of the Framework Design Guidelines book.&nbsp; It provides great instruction on creating reusable libraries, based on Microsoft&#8217;s design on the .NET Framework.

But it&#8217;s important to remember that **guidelines aren&#8217;t rules**.&nbsp; Guidelines are recommendations based on a set of perceived best practices.&nbsp; Even a &#8220;DO&#8221; or &#8220;MUST&#8221; guideline can be broken in rare cases where following the guideline creates a negative user experience.&nbsp; In these cases, you need a pretty overwhelming case against the guideline to not follow it.

### ASP.NET MVC Example

Looking at [Action Filters](http://www.davidhayden.com/blog/dave/archive/2008/03/21/ActionFilterAttributeExamplesASPNETMVCFrameworkPreview2.aspx) in ASP.NET MVC (Preview 2), I found an&#8230;interesting naming convention for creating action filters:

<pre><span style="color: blue">public class </span><span style="color: #2b91af">AdminRoleAttribute </span>: <span style="color: #2b91af">ActionFilterAttribute
</span>{
    <span style="color: blue">public override void </span>OnActionExecuting(<span style="color: #2b91af">FilterExecutingContext </span>filterContext)
    {
        <span style="color: blue">if </span>(!filterContext.HttpContext.User.IsInRole(<span style="color: #a31515">"Administrator"</span>))
            <span style="color: blue">throw new </span><span style="color: #2b91af">ApplicationException</span>(<span style="color: #a31515">"For cool dudes only."</span>);
    }
}
</pre>

[](http://11011.net/software/vspaste)

In the ASP.NET MVC framework, we&#8217;re required to create a custom attribute to create action filters.&nbsp; Taking a look at the method I override, when exactly does this method get executed?&nbsp; Is it before, after or during?&nbsp; The present tense of the verb implies that it&#8217;s during, but that&#8217;s not possible.&nbsp; I have to deduce that it gets executed before the action.

The naming convention here is a little strange, with &#8220;OnActionExecuting&#8221; the method for &#8220;before&#8221; and &#8220;OnActionExecuted&#8221; for &#8220;after&#8221;.&nbsp; This naming style is normally used for event raising, where you&#8217;d create protected &#8220;On<EventName>&#8221; methods that would in turn raise the event.

In the ActionFilterAttribute, there are no events being raised, so this guideline shouldn&#8217;t apply. That&#8217;s where more clear names like say, &#8220;**BeforeAction**&#8221; and &#8220;**AfterAction**&#8221; would be far more explicit about when these methods get called.

### Other frameworks

Action filters are fairly common in MVC frameworks.&nbsp; I wouldn&#8217;t want to call out this design choice without looking at a few others, so let&#8217;s check out what the other cool kids are doing.

#### MonoRail

To create a custom filter in MonoRail, you don&#8217;t need to create a new attribute type.&nbsp; In the ASP.NET MVC example, I&#8217;d decorate my controllers with the specific &#8220;AdminRole&#8221; attribute.&nbsp; The filters in MonoRail are somewhat decoupled from when they&#8217;re executed:

<pre><span style="color: blue">public class </span><span style="color: #2b91af">AdminRoleFilter </span>: <span style="color: #2b91af">IFilter
</span>{
    <span style="color: blue">public bool </span>Perform(<span style="color: #2b91af">ExecuteEnum </span>exec, <span style="color: #2b91af">IRailsEngineContext </span>context, <span style="color: #2b91af">Controller </span>controller)
    {
        <span style="color: blue">if </span>(!context.CurrentUser.IsInRole(<span style="color: #a31515">"Administrator"</span>))
        {
            controller.Flash.Add(<span style="color: #a31515">"For cool dudes only."</span>);
            controller.Redirect(<span style="color: #a31515">""</span>, <span style="color: #a31515">"login"</span>, <span style="color: #a31515">"login"</span>);
            <span style="color: blue">return false</span>;
        }

        <span style="color: blue">return true</span>;
    }
}
</pre>

[](http://11011.net/software/vspaste)

You then decorate your controller with the FilterAttribute, specifying when the filter gets executed:

<pre>[<span style="color: #2b91af">Filter</span>(<span style="color: #2b91af">ExecuteEnum</span>.BeforeAction, <span style="color: blue">typeof</span>(<span style="color: #2b91af">AdminRoleFilter</span>))]
    <span style="color: blue">public class </span><span style="color: #2b91af">AdminController </span>: <span style="color: #2b91af">SmartDispatcherController
</span></pre>

[](http://11011.net/software/vspaste)

Note the nice pretty name, &#8220;BeforeAction&#8221;.&nbsp; Other values for the ExecuteEnum include &#8220;AfterAction&#8221;, &#8220;Around&#8221;, &#8220;AfterRendering&#8221;, etc.&nbsp; These names are very expressive for exactly when this action should get executed.&nbsp; I don&#8217;t get names like &#8220;OnViewRendered&#8221; or &#8220;OnActionExecutingOhAndByTheWayOnActionExecutedAlso&#8221;.

#### Non-.NET frameworks

Rails has equally expressive manner of doing actions.&nbsp; This makes sense as MonoRail was heavily influenced by Rails.&nbsp; In Rails, you can specify then name of the methods to be executed:

<pre>class BankController &lt; ActionController::Base
    before_filter :audit

    private
      def audit
        # record the action and parameters in an audit log
      end
  end

  class VaultController &lt; BankController
    before_filter :verify_credentials

    private
      def verify_credentials
        # make sure the user is allowed into the vault
      end
  end</pre>

Rails provides many descriptive methods (which can be chained) to modify the filters for a particular controller: &#8220;before\_filter&#8221;, &#8220;after\_filter&#8221;, &#8220;around_filter&#8221; and others.&nbsp; Note again the obviously named methods, where the time the filter executes is explicitly named &#8220;before&#8221; or &#8220;after&#8221;.

Finally, in Django, filter-like features are created through the [Decorator pattern](http://www.dofactory.com/Patterns/PatternDecorator.aspx), where you explicitly wrap a controller action in another method that adds functionality:

<pre>from django.contrib.auth.decorators import login_required

def my_view(request):
    # ...
my_view = login_required(my_view)</pre>

Instead of specifying when the filter is executed, it&#8217;s up to the implementer of the decorator to determine when to call the underlying action.&nbsp; This gives quite a bit of flexibility to the designers of the decorator, but takes it away from the developer, as they can no longer specify when the filter should execute.

### Intention-revealing interfaces

In the end, the difference between a good and not-so-good framework can be found in its success in creating [Intention-revealing interfaces](http://www.amazon.com/Domain-Driven-Design-Tackling-Complexity-Software/dp/0321125215).&nbsp; If you can&#8217;t look at a component or class and infer its responsibility and purpose _without exercising the component_, chances are good that you have an intention-revealing interface.

In the ASP.NET MVC filters, I had to guess which one executed before the action, as the word &#8220;before&#8221; was nowhere to be seen.&nbsp; When guidelines directly contradict a clear, intention-revealing interface, it&#8217;s safe to choose to not follow the guideline.&nbsp; If we had an ActionFilterAttribute that had only &#8220;BeforeFilter&#8221; and &#8220;AfterFilter&#8221;, I don&#8217;t think the FDG police will come knocking at anyone&#8217;s door.