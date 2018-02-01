---
id: 4563
title: Parsing The Payload
date: 2008-08-15T02:16:59+00:00
author: Mo Khan
layout: post
guid: /blogs/mokhan/archive/2008/08/14/parsing-the-payload.aspx
categories:
  - ASP.NET MVC
  - TDD
---
[<img style="border-top-width: 0px;border-left-width: 0px;border-bottom-width: 0px;border-right-width: 0px" height="244" alt="project_references" src="http://lostechies.com/mokhan/files/2011/03ParsingThePayload_122CB/project_references_thumb.png" width="174" align="right" border="0" />](http://lostechies.com/mokhan/files/2011/03ParsingThePayload_122CB/project_references_2.png)So this week we got to start working a brand spanking new MVC project. So far we&#8217;re leveraging Castle Windsor, NHibernate, Fluent Nhibernate, and kind of running Linq to NHibernate. It&#8217;s amazing how quickly you can get a project up and running in such a short amount of time. (BTW, Fluent NHibernate rocks!) When you&#8217;re building off the trunk of these projects, it&#8217;s almost like the contributors to all these great projects are extended members of the team. Thank you all!

Moving on&#8230; One of the things that are cool, but also slightly annoying, is how the MVC framework parses out items from the http payload to populate any input arguments on controller actions. 

It&#8217;s great how it just works, but it&#8217;s a little annoying if it&#8217;s under test and you have to add more fields, or remove fields from a form, then you have to go update the signature of the action then go update the test&#8230;. yada yada The changes just ripple down&#8230;

So one thing we tried out this week was to create a payload parser. What this guy does is take a [DTO](http://martinfowler.com/eaaCatalog/dataTransferObject.html) parse out the values for each of the properties on the [DTO](http://martinfowler.com/eaaCatalog/dataTransferObject.html) from the current requests payload and fill it. This makes it easy to package up the form parameters in a nicely packaged [DTO](http://martinfowler.com/eaaCatalog/dataTransferObject.html) and fire it off down to a service layer to do some work.

So instead of declaring an action method on a controller that looks like this, where the signature would have to change based on what fields are submitted on a form:

<pre><span>viewresult</span> register_new_account(<span>string</span> user_name, <span>string</span> first_name,<span>string</span> last_name)</pre>

[](http://11011.net/software/vspaste)

we can write this&#8230;

<pre><span>public</span> <span>viewresult</span> register_new_account() {
    <span>var</span> accountsubmissiondto = parser.mapfrompayloadto&lt;<span>accountsubmissiondto</span>&gt;();
    <span>var</span> validationresult = task.validate(accountsubmissiondto);
    <span>if</span> (validationresult.isvalid) {
        task.submit(accountsubmissiondto);
        <span>return</span> view(<span>"Success"</span>, accountsubmissiondto);
    }

    <span>return</span> view(<span>"Index"</span>, validationresult.brokenrules);
}
</pre>

this better allows us to adhere to the [ocp](http://en.wikipedia.org/wiki/Open/closed_principle). if we need to include additional fields on the form, we can add them to the form as long as the control name is the same as the name of the property on the [dto](http://martinfowler.com/eaaCatalog/dataTransferObject.html) that it will be bound to. the implementation of the payload parser is quite primitive for now, but at the moment it&#8217;s all that we needed.

first up the specs&#8230; simple enough, for now!

<pre><span>public</span> <span>class</span> <span>when_parsing_the_values_from_the_current_request_to_populate_a_dto</span> : <span>context_spec</span>&lt;<span>ipayloadparser</span>&gt; {
    [<span>test</span>]
    <span>public</span> <span>void</span> should_return_a_fully_populated_dto() {
        result.name.should_be_equal_to(<span>"adam"</span>);
        result.age.should_be_equal_to(15);
        result.birthdate.should_be_equal_to(<span>new</span> <span>datetime</span>(1982, 11, 25));
        result.id.should_be_equal_to(1);
    }

    <span>protected</span> <span>override</span> <span>ipayloadparser</span> undertheseconditions() {
        <span>var</span> current_request = dependency&lt;<span>iwebrequest</span>&gt;();
        <span>var</span> payload = <span>new</span> <span>namevaluecollection</span>();

        payload[<span>"Name"</span>] = <span>"adam"</span>;
        payload[<span>"Age"</span>] = <span>"15"</span>;
        payload[<span>"Birthdate"</span>] = <span>new</span> <span>datetime</span>(1982, 11, 25).tostring();
        payload[<span>"Id"</span>] = <span>"1"</span>;

        current_request.setup_result_for(r =&gt; r.payload).return(payload);

        <span>return</span> <span>new</span> <span>payloadparser</span>(current_request);
    }

    <span>protected</span> <span>override</span> <span>void</span> becauseof() {
        result = sut.mapfrompayloadto&lt;<span>somedto</span>&gt;();
    }

    <span>private</span> <span>somedto</span> result;
}

<span>public</span> <span>class</span> <span>when_parsing_values_from_the_request_that_is_missing_values_for_a_properties_on_the_dto</span> :
    <span>context_spec</span>&lt;<span>ipayloadparser</span>&gt; {
    <span>private</span> <span>accountsubmissiondto</span> result;

    [<span>test</span>]
    <span>public</span> <span>void</span> it_should_supress_any_errors() {
        result.lastname.should_be_null();
        result.emailaddress.should_be_null();
    }

    <span>protected</span> <span>override</span> <span>ipayloadparser</span> undertheseconditions() {
        <span>var</span> current_request = dependency&lt;<span>iwebrequest</span>&gt;();

        <span>var</span> payload = <span>new</span> <span>namevaluecollection</span>();

        payload[<span>"FirstName"</span>] = <span>"Joel"</span>;
        current_request.setup_result_for(x =&gt; x.payload).return(payload);

        <span>return</span> <span>new</span> <span>payloadparser</span>(current_request);
    }

    <span>protected</span> <span>override</span> <span>void</span> becauseof() {
        result = sut.mapfrompayloadto&lt;<span>accountsubmissiondto</span>&gt;();
    }
    }
</pre>

<pre><span>public</span> <span>class</span> <span>somedto</span> {
    <span>public</span> <span>long</span> id { <span>get</span>; <span>set</span>; }
    <span>public</span> <span>string</span> name { <span>get</span>; <span>set</span>; }
    <span>public</span> <span>int</span> age { <span>get</span>; <span>set</span>; }
    <span>public</span> <span>datetime</span> birthdate { <span>get</span>; <span>set</span>; }
}
</pre>

[](http://11011.net/software/vspaste)

the current implementation:</p> 

<pre><span>public</span> <span>interface</span> <span>IPayloadParser</span> {
    TypeToProduce MapFromPayloadTo&lt;TypeToProduce&gt;() <span>where</span> TypeToProduce : <span>new</span>();
}

<span>public</span> <span>class</span> <span>PayloadParser</span> : <span>IPayloadParser</span> {
    <span>private</span> <span>readonly</span> <span>IWebRequest</span> current_request;

    <span>public</span> PayloadParser(<span>IWebRequest</span> current_request) {
        <span>this</span>.current_request = current_request;
    }

    <span>public</span> TypeToProduce MapFromPayloadTo&lt;TypeToProduce&gt;() <span>where</span> TypeToProduce : <span>new</span>() {
        <span>var</span> dto = <span>new</span> TypeToProduce();
        <span>foreach</span> (<span>var</span> propertyInfo <span>in</span> <span>typeof</span> (TypeToProduce).GetProperties()) {
            <span>var</span> value = <span>Convert</span>.ChangeType(current_request.Payload[propertyInfo.Name], propertyInfo.PropertyType);
            propertyInfo.SetValue(dto, value, <span>null</span>);
        }

        <span>return</span> dto;
    }
}
</pre>

[](http://11011.net/software/vspaste)