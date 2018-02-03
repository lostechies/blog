---
wordpress_id: 498
title: Cleaning up POSTs in ASP.NET MVC
date: 2011-06-22T18:43:44+00:00
author: Jimmy Bogard
layout: post
wordpress_guid: http://lostechies.com/jimmybogard/2011/06/22/cleaning-up-posts-in-asp-net-mvc/
dsq_thread_id:
  - "339494740"
categories:
  - ASPNETMVC
---
A lot of folks ask why AutoMapper doesn’t have as much built-in niceties for reverse mapping (DTOs –> Persistent object models). Besides this model promoting, even enforcing anemic, promiscuous domain models, we simply found another way to handle complexity in our form POSTs. 

Looking at a medium-large ASP.NET MVC site, in complexity or size, you’ll start to notice some patterns emerge. You’ll start to see a clear distinction from what your GET actions look like versus POST. That’s to be expected, since GETs are Queries, and POSTs are Commands (if you’re Doing Things Right, that is). You won’t necessarily see a 1:1 form tag to POST action ratio, since a form could still be used to submit a Query (e.g. a search form).

The GET actions, in my opinion, are a solved problem. The GET action builds up a ViewModel and passes it to the View, and uses any number of optimizations/abstractions to do so (AutoMapper, model binding, conventional projections etc.).

POSTs are just a different beast altogether. The complexity vectors in mutating information and accepting/validating commands is so completely orthogonal to GETs that we pretty much need to throw out all of our approaches. What we typically see is something like this:

<pre class="code">[<span style="color: #2b91af">HttpPost</span>]
<span style="color: blue">public </span><span style="color: #2b91af">ActionResult </span>Edit(<span style="color: #2b91af">ConferenceEditModel </span>form)
{
    <span style="color: blue">if </span>(!ModelState.IsValid)
    {
        <span style="color: blue">return </span>View(form);
    }

    <span style="color: blue">var </span>conf = _repository.GetById(form.Id);

    conf.ChangeName(form.Name);

    <span style="color: blue">foreach </span>(<span style="color: blue">var </span>attendeeEditModel <span style="color: blue">in </span>form.Attendees)
    {
        <span style="color: blue">var </span>attendee = conf.GetAttendee(attendeeEditModel.Id);

        attendee.ChangeName(attendeeEditModel.FirstName, attendeeEditModel.LastName);
        attendee.Email = attendeeEditModel.Email;
    }

    <span style="color: blue">return this</span>.RedirectToAction(c =&gt; c.Index(<span style="color: blue">null</span>), <span style="color: #a31515">"Default"</span>);
}</pre>

What we see over and over and over again is a similar pattern of:

<pre class="code">[<span style="color: #2b91af">HttpPost</span>]
<span style="color: blue">public </span><span style="color: #2b91af">ActionResult </span>Edit(<span style="color: red">SomeEditModel </span>form)
{
    <span style="color: blue">if </span>(<span style="color: red">IsNotValid</span>)
    {
        <span style="color: blue">return </span><span style="color: red">ShowAView</span>(form);
    }

    <span style="color: red">DoActualWork</span>();

    <span style="color: blue">return </span><span style="color: red">RedirectToSuccessPage</span>();
}

</pre>

Where all the things in red are things that change from POST action to POST action. 

So why do we care about these actions? Why the need to form a common execution path around what we find here? Several reasons we ran into include:

  * POST actions require different dependencies than GETs, and the dichotomy between the two increases controller bloat 
      * Desire to make modifications/enhancements on ALL POST actions, like adding logging, validation, authorization, event notification, etc. 
          * Concerns are thoroughly jumbled up. Actually DOING the work is mixed up with MANAGING the work to be done. It can get ugly.</ul> 
        To get around this, we used a combination of techniques:
        
          * Custom action result to manage the common workflow 
              * Separating the “doing of the work” from the common workflow</ul> 
            We don’t always want to create these abstractions, but it can be helpful to manage complexity of POSTs. First, let’s start building that custom action result.
            
            ### 
            
            ### Defining the common workflow
            
            Before we get too far down the path of building the custom action result, let’s examine the common pattern above. Some things need to be defined in the controller action, but others can be inferred. For example, the “Do work” piece can be inferred based on the form we’re posting. We never have 2 different ways of processing a form action, so let’s define an interface to process the form:
            
            <pre class="code"><span style="color: blue">public interface </span><span style="color: #2b91af">IFormHandler</span>&lt;T&gt;
{
    <span style="color: blue">void </span>Handle(T form);
}</pre>
            
            Simple enough, it’s basically a class that represents “Action<T>”, and a variant of the Command pattern. In fact, if you’re familiar with messaging, it looks just like a message handler. The form is the message, and the handler knows how to handle that form message.
            
            The above abstraction represents what we need to do for the “Do work” piece, and the rest can be pulled out into a common action result:
            
            <pre class="code"><span style="color: blue">public class </span><span style="color: #2b91af">FormActionResult</span>&lt;T&gt; : <span style="color: #2b91af">ActionResult
</span>{        
    <span style="color: blue">public </span><span style="color: #2b91af">ViewResult </span>Failure { <span style="color: blue">get</span>; <span style="color: blue">private set</span>; }
    <span style="color: blue">public </span><span style="color: #2b91af">ActionResult </span>Success { <span style="color: blue">get</span>; <span style="color: blue">private set</span>; }
    <span style="color: blue">public </span>T Form { <span style="color: blue">get</span>; <span style="color: blue">private set</span>; }

    <span style="color: blue">public </span>FormActionResult(T form, <span style="color: #2b91af">ActionResult </span>success, <span style="color: #2b91af">ViewResult </span>failure)
    {
        Form = form;
        Success = success;
        Failure = failure;
    }

    <span style="color: blue">public override void </span>ExecuteResult(<span style="color: #2b91af">ControllerContext </span>context)
    {
        <span style="color: blue">if </span>(!context.Controller.ViewData.ModelState.IsValid)
        {
            Failure.ExecuteResult(context);

            <span style="color: blue">return</span>;
        }

        <span style="color: blue">var </span>handler = <span style="color: #2b91af">ObjectFactory</span>.GetInstance&lt;<span style="color: #2b91af">IFormHandler</span>&lt;T&gt;&gt;();

        handler.Handle(Form);

        Success.ExecuteResult(context);
    }
}
</pre>
            
            We looked at the basic execution pipeline, and found the pieces that vary. Notably, this is the ActionResult to execute upon failure and the ActionResult to execute upon success. The specific form handler to execute is already inferred based on the form type, so we use a modern IoC container to locate the specific form handler to execute (StructureMap in my case). To tell StructureMap to locate implementations of IFormHandler<T> based on implementations, it’s just one line of code:
            
            <pre class="code">Scan(scanner =&gt; 
{
    scanner.TheCallingAssembly();
    scanner.ConnectImplementationsToTypesClosing(<span style="color: blue">typeof</span>(<span style="color: #2b91af">IFormHandler</span>&lt;&gt;));
});
</pre>
            
            The individual “work done” inside our original controller action is then pulled out to a class that is only concerned with processing the form, and not the UI traffic cop parts:
            
            <pre class="code"><span style="color: blue">public class </span><span style="color: #2b91af">ConferenceEditModelFormHandler 
    </span>: <span style="color: #2b91af">IFormHandler</span>&lt;<span style="color: #2b91af">ConferenceEditModel</span>&gt;
{
    <span style="color: blue">private readonly </span><span style="color: #2b91af">IConferenceRepository </span>_repository;

    <span style="color: blue">public </span>ConferenceEditModelFormHandler(
        <span style="color: #2b91af">IConferenceRepository </span>repository)
    {
        _repository = repository;
    }

    <span style="color: blue">public void </span>Handle(<span style="color: #2b91af">ConferenceEditModel </span>form)
    {
        <span style="color: #2b91af">Conference </span>conf = _repository.GetById(form.Id);

        conf.ChangeName(form.Name);

        <span style="color: blue">foreach </span>(<span style="color: blue">var </span>attendeeEditModel <span style="color: blue">in </span>GetAttendeeForms(form))
        {
            <span style="color: #2b91af">Attendee </span>attendee = conf.GetAttendee(attendeeEditModel.Id);

            attendee.ChangeName(attendeeEditModel.FirstName,
                                attendeeEditModel.LastName);
            attendee.Email = attendeeEditModel.Email;
        }
    }

    <span style="color: blue">private </span><span style="color: #2b91af">ConferenceEditModel</span>.<span style="color: #2b91af">AttendeeEditModel</span>[] GetAttendeeForms(<span style="color: #2b91af">ConferenceEditModel </span>form)
    {
        <span style="color: blue">return </span>form.Attendees ??
               <span style="color: blue">new </span><span style="color: #2b91af">ConferenceEditModel</span>.<span style="color: #2b91af">AttendeeEditModel</span>[0];
    }
}
</pre>
            
            This class is now only concerned with processing the success path of a form. Namely, just going back to my domain object and mutating it appropriately. Because I have a largely behavioral domain model, you won’t see an opportunity to “reverse map”. This is intentional.
            
            What’s interesting is that this class’s concerns are quite limited now, and no longer have any kind of ASP.NET action result jockeying going on. We’ve now effectively separated the concerns of doing the work versus directing the work.
            
            ### 
            
            ### Applying to our controller
            
            Now that we’ve built our action result, the last part is to apply this action result to our controller action. Like a lot of folks, we often insert a shim in the controller class hierarchy to be able to apply helper methods across all of our controllers. In this class, we’ll add a helper method for building our custom action result:
            
            <pre class="code"><span style="color: blue">public class </span><span style="color: #2b91af">DefaultController </span>: <span style="color: #2b91af">Controller
</span>{
    <span style="color: blue">protected </span><span style="color: #2b91af">FormActionResult</span>&lt;TForm&gt; Form&lt;TForm&gt;(
        TForm form, 
        <span style="color: #2b91af">ActionResult </span>success)
    {
        <span style="color: blue">var </span>failure = View(form);

        <span style="color: blue">return new </span><span style="color: #2b91af">FormActionResult</span>&lt;TForm&gt;(form, success, failure);
    }

</pre>
            
            It just wraps up some of the default paths we often define. Failure almost always shows the same view we just came from, for example. Finally, we can modify our original POST controller action:
            
            <pre class="code"><span style="color: blue">public class </span><span style="color: #2b91af">ConferenceController </span>: <span style="color: #2b91af">DefaultController
</span>{
    [<span style="color: #2b91af">HttpPost</span>]
    <span style="color: blue">public </span><span style="color: #2b91af">ActionResult </span>Edit(<span style="color: #2b91af">ConferenceEditModel </span>form)
    {
        <span style="color: blue">var </span>successResult = 
            <span style="color: blue">this</span>.RedirectToAction(c =&gt; c.Index(<span style="color: blue">null</span>), <span style="color: #a31515">"Default"</span>);

        <span style="color: blue">return </span>Form(form, successResult);
    }
</pre>
            
            We’ve reduced the controller action to truly being a description of what to do, but the how is now pushed down. It’s a classic example of OO composition at work, we’ve composed the different execution paths of a form POST into an action result and a supporting form handler. We didn’t really reduce the code we write, but just moved it around and made it a little easier to reason about.
            
            Another interesting side effect is that we now build unit/integration tests around the form handler, but the controller action is largely left alone. What exactly is there to test here? Not much logic going on, so not a real big impetus to write a test.
            
            When looking at these large-scale patterns to apply, it’s important to investigate the compositional routes first. That lets us be a little bit more flexible in putting pieces together than the inheritance routes take us.
            
            Although this is a somewhat complex example, in the next post we’ll look at what more complex POST actions might look like, where our validation starts moving beyond the simple items we have here and our POST handlers become even more complicated.