---
wordpress_id: 4448
title: Presenter Logic || Domain Service Logic || Repository Logic?
date: 2009-02-19T03:12:00+00:00
author: Sean Biefeld
layout: post
wordpress_guid: /blogs/seanbiefeld/archive/2009/02/18/presenter-logic-domain-service-logic-repository-logic.aspx
dsq_thread_id:
  - "449608047"
categories:
  - 'C#'
  - Domain Driven Design
  - Domain Service
  - Presenter
  - Repository
  - View
---
Obviously the answer to the titular question is yes.

I have recently found myself questioning whether the logic I am coding belongs in a <a href="http://devlicio.us/blogs/casey/archive/2009/02/17/ddd-services.aspx" target="_blank">domain service</a> or in the presenter. I actually found the same logic in the presenter residing the base repository. Something definitely <a href="http://en.wikipedia.org/wiki/Code_smell" target="_blank">smells</a> wrong, almost like the putrid smell of death, lol, nah just a <a href="http://en.wikipedia.org/wiki/Don%27t_repeat_yourself" target="_blank">DRY</a> smell and a hint of mixed responsibility odor. The presenter was calling the Repository directly which was kinda of an indicator, but it is valid to do so, depending on the scenario.

The application that I am currently working in is a web application. That being said, I feel it is valid to consider the web limitations part of the current domain, not just a concern of the presentation. If we need to move to a windows app or something else, it will take a lot of refactoring, so why not just view the web&#8217;s issues as part of what affects the domain. Besides, is the purpose of the domain to be abstract enough to support multiple platforms or to dimish complexity? Anyway, that&#8217;s another discussion altogether, and I&#8217;m digressing.

Here&#8217;s the skinny, that&#8217;s a valid colloquialism isn&#8217;t it. I found string to integer conversion happening in two different places. Once in the presenter, grabbing a string Id from the view, converting it, calling an overloaded GetById method from the repository or throwing an exception if the Id was invalid. The overloaded GetById method was in the base repository, it either accepted a string Id or integer Id, if the string Id was invalid it was throwing an exception. Yikes, this is scary, and to think I was the one that coded all this, frightening, I know. I am recovering so don&#8217;t you worry yourself. Now to the current code (all code below is pseudo code, simplified for example purposes):

### Code to be Refactored:

#### Presenter

<pre style="background-color: #000;font-family: Lucida Console;padding: 5px;border:solid 1px #333;overflow: auto;color: #aaa;font-size: 10pt"><span style="color: #df8000">public virtual void</span> InitializeView()<br />{<br />	<span style="color: #df8000">if</span>(TreatmentIdIsValid())<br />		LoadTreatment();<br />	<span style="color: #df8000">else</span><br />		<span style="color: #df8000">throw new</span> <span style="color: #2091af">ApplicationException</span>(<span style="color: #df8000">string</span>.Format(<span style="color: #800000">"A Record of Waste cannot be completed because of the invalid treatment id: {0}"</span>, View.TreatmentId));<br />}<br /><br /><span style="color: #df8000">private bool</span> TreatmentIdIsValid()<br />{<br />	<span style="color: #df8000">int</span> validTreatmentId; <br /><br />	<span style="color: #df8000">bool</span> treatmentIdIsValid = <span style="color: #df8000">int</span>.TryParse(View.TreatmentId, <span style="color: #df8000">out</span> validTreatmentId); <br /><br />	<span style="color: #df8000">if</span>(treatmentIdIsValid)<br />		CurrentTreatmentId = id; <br /><br />	<span style="color: #df8000">return</span> treatmentIdIsValid;<br />} <br /><br /><span style="color: #df8000">protected virtual void</span> LoadTreatment()<br />{<br />	<span style="color: #df8000">try</span><br />	{<br />		CurrentTreatment = <span style="color: #2091af">Repository</span>&lt;<span style="color: #2091af">ITreatmentRepository</span>&gt;.GetById(CurrentTreatmentId);		<br />	}<br />	<span style="color: #df8000">catch</span><br />	{<br />		<span style="color: #df8000">throw new</span> <span style="color: #2091af">ApplicationException</span>(<span style="color: #800000">"Could not retrieve the specified treatment"</span>);<br />	}<br />}<br /></pre>

#### Base Repository

<pre style="background-color: #000;font-family: Lucida Console;padding: 5px;border:solid 1px #333;overflow: auto;color: #aaa;font-size: 10pt"><span style="color: #df8000">public virtual</span> Entity GetById(<span style="color: #df8000">string</span> id)<br />{<br />	<span style="color: #df8000">int</span> parsedId;<br /><br />	<span style="color: #df8000">if</span> (!<span style="color: #df8000">int</span>.TryParse(id, <span style="color: #df8000">out</span> parsedId))<br />		<span style="color: #df8000">throw new</span> <span style="color: #2091af">ApplicationException</span>(<span style="color: #800000">"Could not convert the given id: "</span> + id + <span style="color: #800000">" into an integer"</span>);<br /><br />	<span style="color: #df8000">return</span> GetById(parsedId);<br />}<br /><br /><span style="color: #df8000">public virtual</span> Entity GetById(<span style="color: #df8000">int</span> id)<br />{<br />	<span style="color: #df8000">return</span> Session.Get&lt;Entity&gt;(id);<br />}<br /></pre>

I think that there is no place for logic in the repository it should be left to the domain service. You could even argue that this functionality is common and can be moved to a domain utility. For ease I am going to move it to a domain service. Now, lettuce see the refactoring to the code above:

### Refactored Code:

#### Presenter

<pre style="background-color: #000;font-family: Lucida Console;padding: 5px;border:solid 1px #333;overflow: auto;color: #aaa;font-size: 10pt"><span style="color: #df8000">public virtual void</span> InitializeView()<br />{<br />	LoadTreatment();<br />}<br /><br /><span style="color: #df8000">protected virtual void</span> LoadTreatment()<br />{	<br />	CurrentTreatment = <span style="color: #2091af">RecordOfWasteService</span>.GetParentTreatmentById(CurrentTreatmentId);	<br />}<br /></pre>

#### Domain Service

<pre style="background-color: #000;font-family: Lucida Console;padding: 5px;border:solid 1px #333;overflow: auto;color: #aaa;font-size: 10pt"><span style="color: #df8000">public virtual</span> <span style="color: #2091af">Treatment</span> GetParentTreatmentById(<span style="color: #df8000">string</span> id)<br />{<br />	<span style="color: #df8000">int</span> validTreatmentId;<br /><br />	<span style="color: #df8000">if</span> (!<span style="color: #df8000">int</span>.TryParse(id, <span style="color: #df8000">out</span> validTreatmentId))<br />		<span style="color: #df8000">throw new</span> <span style="color: #2091af">ApplicationException</span>(<span style="color: #800000">"Could not convert the given treatment id: "</span> + id + <span style="color: #800000">" into an integer"</span>);<br /><br />	<span style="color: #df8000">return</span> GetParentTreatmentById(validTreatmentId);<br />}<br /><br /><span style="color: #df8000">protected virtual </span><span style="color: #2091af">Treatment</span> GetParentTreatmentById(<span style="color: #df8000">int</span> treatmentId)<br />{<br />	<span style="color: #df8000">try</span><br />	{<br />		CurrentTreatment = <span style="color: #2091af">Repository</span>&lt;<span style="color: #2091af">ITreatmentRepository</span>&gt;.GetById(treatmentId);		<br />	}<br />	<span style="color: #df8000">catch</span><br />	{<br />		<span style="color: #df8000">throw new</span> <span style="color: #2091af">ApplicationException</span>(<span style="color: #800000">"Could not retrieve the specified treatment"</span>);<br />	}<br />}<br /></pre>

#### Base Repository

<pre style="background-color: #000;font-family: Lucida Console;padding: 5px;border:solid 1px #333;overflow: auto;color: #aaa;font-size: 10pt"><span style="color: #df8000">public virtual</span> Entity GetById(<span style="color: #df8000">int</span> id)<br />{<br />	<span style="color: #df8000">return</span> Session.Get&lt;Entity&gt;(id);<br />}<br /></pre>

Alrighty then, we got any logic out of the repository, I&#8217;m feeling better already, my face has gone from grimace to grin, and no not the McDonlad&#8217;s character Grimace. <a href="http://www.youtube.com/watch?v=xf69EEL3WBk" target="_blank">Super serial</a>, a la Al Gore about ManBearPig, what was <a href="http://sbiefeld.com/Stuff/grimace.jpg" target="_blank">Grimace</a>, was he what you turn in to if you only eat McDonalds and nothing else?

The responsibility of the repository should be to read and write to persistence/web services/messages etc. The string validation logic is in the domain service, I may pull it out to a base service or utility service. Our presenter is so much simpler now, and not worried about logic that it shouldn&#8217;t have to worry about. Hmm, the cleanliness is delightful. There is no more duplication of logic in the presenter and repository, w00t! Now let me know your thoughts, comments, opinions etc. of dissent or agreement, it will help me and hopefully others learn and grow. I&#8217;m off to watch the some <a href="http://en.wikipedia.org/wiki/Teenage_Mutant_Ninja_Turtles_(1987_TV_series)" target="_blank">Teenage Mutant Ninja Turtle original series</a>, wow, I&#8217;m a nerd.