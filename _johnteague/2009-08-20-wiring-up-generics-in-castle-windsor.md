---
wordpress_id: 35
title: Wiring Up Generics In Castle Windsor
date: 2009-08-20T20:49:00+00:00
author: John Teague
layout: post
wordpress_guid: /blogs/johnteague/archive/2009/08/20/wiring-up-generics-in-castle-windsor.aspx
dsq_thread_id:
  - "262055696"
categories:
  - Castle
  - IoC
---
{% raw %}
I&#8217;m working with a new team that has a slightly different technology stack then I&#8217;m used to.&nbsp; On most projects where I am the team lead, StructureMap is my IOC container of choice.&nbsp; I&#8217;ve always thought that this was just laziness on my part because I can wire up most things very quickly. Now I&#8217;m beginning to think that SM has spoiled me 🙂

I like to take advantage of open generic mapping that most of the popular containers support.&nbsp; In this particular case, I&#8217;ve got a Generic Validator that takes in a different array of validations for a given type.

&nbsp;

The constructor for this guy looks like this:

public class ServiceValidationRunner<T> : IServiceValidationRunner<T>  
&nbsp;&nbsp;&nbsp; {  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; private IValidation<T>[] _validations;  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; private readonly IValidationErrorHandler _errorHandler;

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; public ServiceValidationRunner(IValidation<T>[] validations, IValidationErrorHandler errorHandler)  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; {  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; _validations = validations;  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; _errorHandler = errorHandler;  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; }  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &#8230;  
}

Here is how I&#8217;m am setting this up for two different types that have different validations:

container.Register  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; (  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; //wire up the specific types with their validation rules  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Component.For<IServiceValidationRunner<Object1>>().ImplementedBy<ServiceValidationRunner<Object1>>()  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; .DependsOn(new {validations = new[]{new Validator1(),new Validator2}}),  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Component.For<IServiceValidationRunner<Object2>>().ImplementedBy<ServiceValidationRunner<Object2>>()  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; .DependsOn(new {validations = new[]{new Validator1(), new Validator3()}}),  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &#8230;  
);

The code is pretty self explanatory, it&#8217;s a simple matter of wiring up the dependencies for the specific type the generic class is wired up for.
{% endraw %}
