---
id: 10
title: NCommons Rules Engine
date: 2010-06-28T00:15:14+00:00
author: Derek Greer
layout: post
guid: /blogs/derekgreer/archive/2010/06/27/ncommons-rules-engine.aspx
dsq_thread_id:
  - "262468830"
categories:
  - Uncategorized
---
I recently decided to invest some time in learning how my team might leverage the <a href="http://mvccontrib.codeplex.com/" target="_blank">MvcContrib</a> rules engine for our projects at work. I discovered this feature after browsing the <a href="http://codecampserver.codeplex.com/" target="_blank">CodeCampServer</a> source which seems to be the only publicly available example of the rules engine in use. I was impressed at how clean the controller actions were as a result of leveraging this feature in conjunction with some additional infrastructure sugar the CodeCampServer adds. 

While I liked the capabilities of the MvcContrib rules engine overall, there were a few aspects I wanted to change.&#160; One of those things was the coupling to the validation strategy provided by the rules engine and another was the need for a bit of additional infrastructure code to help parse the results when mapping validation errors back to their corresponding UI elements.

I also recently became aware of the <a href="http://fluentvalidation.codeplex.com/" target="_blank">Fluent Validation</a> library by Jeremy Skinner and thought to myself: "_I wonder how long it would take to just create my own rules engine leveraging the Fluent Validation framework_", so I sat down last weekend to find out. Well, after getting something up and going, I thought I might as well share my results. I should note that given my effort was inspired by the MvcContrib rules engine, some of the same concepts are reflected in my effort (though perhaps with a more naive implementation).

## Overview 

The basic rules engine works as follows: 

  1. A user invokes some Controller action. 
  2. The Controller takes the action&#8217;s parameter and invokes the RulesEngine.Process() method. 
  3. The RulesEngine invokes an injected implementation of IRuleValidator.Validate() on the object. 
  4. The IRulesValidator returns a RuleValidationResult denoting the status of the validation as well as containing any validation error messages. 
  5. The RulesEngine uses the Common Service Locator to find implementations of ICommand<T> where T matches the type of the object. 
  6. The implementations of ICommand<T> are executed and any results accumulated. 
  7. The RulesEngine returns a ProcessResult which contains the process status and any validation messages and return items. 
  8. The Controller uses the status to determine which action to display. In the event of a validation failure, the error messages are added to the ModelState with their associated property names. 

&#160;

Here is an example usage: 

<pre class="brush:java; gutter:false; wrap-lines:false; tab-size:2;">[HttpPost] 
public ActionResult Create(ProductInput productInput) 
{ 
	ProcessResult results = _rulesEngine.Process(productInput);
 
	if (!results.Successful) 
	{ 
		CopyValidationErrors(results); 
		return View(productInput); 
	}
 
	return RedirectToAction("Index"); 
} 

void CopyValidationErrors(ProcessResult results) 
{ 
	foreach (RuleValidationFailure failure in results.ValidationFailures) 
	{ 
		ModelState.AddModelError(failure.PropertyName, failure.Message); 
	} 
}</pre>

In an example application I&#8217;ve included with the source, I created an implementation of the IRulesValidator which adapts to the Fluent Validation library: 

<pre class="brush:java; gutter:false; wrap-lines:false; tab-size:2;">public class FluentValidationRulesValidator : IRulesValidator 
{ 
	public RuleValidationResult Validate(object message) 
	{ 
		var result = new RuleValidationResult(); 
		Type validatorType = typeof (AbstractValidator&lt;&gt;).MakeGenericType(message.GetType()); 
		var validator = (IValidator) ServiceLocator.Current.GetInstance(validatorType); 
		ValidationResult validationResult = validator.Validate(message);

		if (!validationResult.IsValid) 
		{ 
			foreach (ValidationFailure error in validationResult.Errors) 
			{ 
				var failure = new RuleValidationFailure(error.ErrorMessage, error.PropertyName); 
				result.AddValidationFailure(failure); 
			} 
		}

		return result; 
	} 
}</pre>

This uses the Common Service Locator to find types closing the Fluent Validation AbstractValidator<T> generic type, validates the message with the validator, and adds any validation error messages to the RuleValidationResult.

## Mapping

I also included the ability to map UI types to domain types using a library such as <a href="http://automapper.codeplex.com/" target="_blank">AutoMapper</a>. To express this as an optional feature, I created a MappingRulesEngine which has a dependency on an IMessageMapper. At first I went back and forth between expressing an IMessageMapper as an optional dependency to the RulesEngine, but I don&#8217;t really like property injection and the notion of using constructor injection for optional dependencies was a bit distasteful, so using inheritance felt like the cleanest and most expressive option.

The MappingRulesEngine uses the Common Service Locator to find a type closing AssociationConfiguration<T> which provides the type to be converted to as well as configuration used by the MappingRulesEngine to associate validation error messages on the domain type back to the origin properties on the UI type. The following is an example usage: 

<pre class="brush:java; gutter:false; wrap-lines:false; tab-size:2;">public class ProductInputAssociationConfiguration : AssociationConfiguration&lt;ProductInput&gt; 
{ 
	public ProductInputAssociationConfiguration() 
	{ 
		ConfigureAssociationsFor&lt;Product&gt;(x =&gt; 
			{ 
				x.For(output =&gt; output.Id).Use(input =&gt; input.Id); 
				x.For(output =&gt; output.Description).Use(input =&gt; input.Description); 
				x.For(output =&gt; output.Price).Use(input =&gt; input.Price); 
			}); 
	} 
}</pre>

&#160;

That&#8217;s about it. You can get the source at <a href="http://github.com/derekgreer/ncommons" target="_blank">http://github.com/derekgreer/ncommons</a>.
