---
wordpress_id: 3957
title: Adding variable output behavior to your FubuMVC actions
date: 2010-02-08T03:34:34+00:00
author: Joshua Flanagan
layout: post
wordpress_guid: /blogs/joshuaflanagan/archive/2010/02/07/adding-variable-output-behavior-to-your-fubumvc-actions.aspx
dsq_thread_id:
  - "263186350"
categories:
  - FubuMVC
redirect_from: "/blogs/joshuaflanagan/archive/2010/02/07/adding-variable-output-behavior-to-your-fubumvc-actions.aspx/"
---
### Introduction

A question I’ve received multiple times now when discussing <a href="http://fubumvc.com/" target="_blank">FubuMVC</a>’s flexibility: can I make a single controller action render a view, or json, or rss/xml, etc., based on a request header, or some portion of the URL? The short answer is yes, of course, as I imagine it is for just about any web framework. The more interesting questions are around how difficult it will be, how much code do you have to write (and therefore, maintain), and how invasive it will be to the rest of your design. In this post, I’ll demonstrate one potential solution to the problem, and hopefully answer those questions in a way that reflects positively on FubuMVC. All of the code in this post is available in the Ouptuts/VaryByAcceptHeader solution in the <a href="https://github.com/DarthFubuMVC/fubumvc-examples/tree/7c4b2165aedb6754a01538aee956e29d4060654c" target="_blank">fubumvc-examples</a> repository.

I’m going to return to my simple sample application which I discussed in <a href="https://lostechies.com/blogs/joshuaflanagan/archive/2010/01/18/fubumvc-define-your-actions-your-way.aspx" target="_blank">my last FubuMVC post</a>. It allows a user to make a list of movies they want to see. Originally, the movies/list action simply rendered a view to display the current list of movies, as well as a form to add more. I’m going to modify this action so that it can also return the list of movies as json or xml.

### Behaviors

FubuMVC has a great mechanism for adding behavior to actions. We creatively call them Behaviors. A Behavior is just a class that contributes to fulfilling a request for a given route. For example, the movies/list route is currently fulfilled by executing two behaviors: OneInOutOutActionInvoker and RenderFubuWebFormView. To solve the given problem, I’m going to introduce a new Behavior: <a href="https://github.com/DarthFubuMVC/fubumvc-examples/blob/7c4b2165aedb6754a01538aee956e29d4060654c/src/Outputs/VaryByAcceptHeader/SimpleWebsite/Behaviors/RenderVariableOutput.cs" target="_blank">RenderVariableOutput</a>.

RenderVariableOutput is fairly straightforward. It has two dependencies that are injected by the container: the IFubuRequest, and an instance of a ConditionOutput. The IFubuRequest contains all of the information about the request, giving me access to the HTTP headers and query string values. ConditionalOutput is a simple helper class that makes it easy for me to associate a predicate and a Behavior, and store them together in the container. It also holds a reference to another ConditionalOutput which it will pass control to if its own predicate fails. The RenderVariableOutput Behavior effectively gets a chain of these ConditionalOutputs, so that when it calls GetOutputBehavior, it will receive the Behavior for the first predicate that passed. If a matching Behavior is found, it is executed.

<div style="padding-bottom: 0px;margin: 0px;padding-left: 0px;padding-right: 0px;float: none;padding-top: 0px" class="wlWriterEditableSmartContent">
  <pre>protected override DoNext performInvoke()
{
    var detector = _fubuRequest.Get&lt;OutputFormatDetector&gt;();

    var behavior = _outputs.GetOutputBehavior(detector);
    if (behavior != null)
    {
        behavior.Invoke();
    }
    return DoNext.Continue;
}</pre>
</div>

The other class you see in play is OutputFormatDetector. It is passed as to the predicates to determine which Behavior to use. This is a simple class that has two properties: Accept, and RenderFormat. The IFubuRequest has access to the same mechanism that is used for model binding. This means that when I ask it for an instance of an OutputFormatDetector (or any class), it will attempt to create a new instance of the class, and then populate the public properties with any values that it knows about. The Accept property will be populated with the value in the Accept HTTP request header. The RenderFormat property will be populated if it finds a value with that key – possibly from the query string, form post data, route parameters, etc.

### Conventions

I now have a Behavior that can execute one of many potential output Behaviors, based on the Accept header or a RenderFormat parameter. There are two remaining tasks: declare the conditions for each potential output, and declare which routes should be able to render different formats.

One way to associate a Behavior with a route is by creating a Convention. A Convention in FubuMVC is a class that implements IConfigureAction. It has a single method, Configure(), which gives it access to the BehaviorGraph. The BehaviorGraph is the semantic model that represents everything needed to satisfy all of the routes in the application. By manipulating the BehaviorGraph, you can modify how each route is fulfilled.

For my sample application, I’m going to declare the following convention:

> Apply the RenderVariableOutput behavior to every action (route) that returns an IEnumerable model, and is currently configured to render a view.

_Note that this is just the convention I picked for this sample. The Behavior itself does not require an IEnumerable output model, I could have just as easily stated “every action that starts with the letter ‘G’. IEnumerable just seemed like good indicator of the kind of data someone might want to see in JSON or XML format._

I implemented this convention in a class named <a href="https://github.com/DarthFubuMVC/fubumvc-examples/blob/7c4b2165aedb6754a01538aee956e29d4060654c/src/Outputs/VaryByAcceptHeader/SimpleWebsite/Behaviors/VariableOutputConvention.cs" target="_blank">VariableOutputConvention</a>. The convention also declares the conditions that would trigger the different outputs:

<div style="padding-bottom: 0px;margin: 0px;padding-left: 0px;padding-right: 0px;float: none;padding-top: 0px" class="wlWriterEditableSmartContent">
  <pre>variableOut.AddOutput(a =&gt; a.RenderFormat == "json", json);
variableOut.AddOutput(a =&gt; a.RenderFormat == "xml", xml);
variableOut.AddOutput(a =&gt; a.AcceptsFormat("text/html"), view);
variableOut.AddOutput(a =&gt; a.AcceptsFormat("application/xml"), xml);
variableOut.AddOutput(a =&gt; a.AcceptsFormat("application/json"), json);</pre>
</div>

It uses the RenderFormat parameter as a manual override mechanism, before falling back to the Accept header. This allows me to test the behavior by appending a “?RenderFormat=json” query string, since it is more difficult to manipulate the Accept header sent by a browser.

As a final step, I apply the convention to my application by adding the following line to <a href="https://github.com/DarthFubuMVC/fubumvc-examples/blob/7c4b2165aedb6754a01538aee956e29d4060654c/src/Outputs/VaryByAcceptHeader/SimpleWebsite/SimpleWebsiteFubuRegistry.cs" target="_blank">my FubuRegistry</a>:

<font face="Courier New">ApplyConvention<VariableOutputConvention>(); </font>

### See it in action

We’ve created the Behavior and tied it to some routes. To see it in action:

  * Run the website from the sample code and go to <http://localhost:59187/movies/list>. Note that it renders a view, as it used to. 
  * Add a few movies to the list. 
  * Go to <http://localhost:59187/movies/list?renderformat=json>. You should see the list in JSON format.
  * Go to <http://localhost:59187/movies/list?renderformat=xml>. You should see the list, serialized as XML.

### Conclusion

As you can see, adding multiple output capability to a web application built on FubuMVC is not very hard. The hardest part was in trying to figure out how to represent the predicates and their output behaviors in the semantic model so that they would flow out of the container properly. Beyond that, the functionality is implemented entirely in a few small classes.

The best part is how I was able to implement this new functionality without impacting the rest of my application design. I added a new capability to existing actions (well, one action in this example, but it could have applied to multiple actions, if more existed that matched the criteria) without changing the actions _at all_. I just applied a new _behavior_ to the action. With a little work (for example, make the list of conditions/outputs configurable via a DSL), the code could be packaged up and re-used across multiple projects. You could just add an assembly to your application project, wire up the convention in your FubuRegistry, and enjoy the new functionality. Hopefully this helped demonstrate the power of FubuMVC’s conventionally applied behaviors.