---
id: 499
title: Model binding XML in ASP.NET MVC 3
date: 2011-06-24T01:48:24+00:00
author: Jimmy Bogard
layout: post
guid: http://lostechies.com/jimmybogard/2011/06/24/model-binding-xml-in-asp-net-mvc-3/
dsq_thread_id:
  - "340788436"
categories:
  - ASPNETMVC
---
ASP.NET MVC 3 introduced the concepts of [service location](http://bradwilson.typepad.com/blog/2010/07/service-location-pt1-introduction.html) to conditionally build providers and factories for various extension points, such as Value Providers, Model Metadata Providers, and notably, Model Binders. Model binders in ASP.NET MVC are responsible for binding contextual HTTP request data (and any other context information) into the action method parameters.

Most of the time, these values are served up through the DefaultModelBinder class, which in turn leans on a collection of Value Providers to, well, provide values to the Model Binder. Value providers are great for centrally modeling dictionary-centric information, such as HTTP request variables (form POST, query string, cookie values etc.)

Model binders operate at one level of abstraction up from value providers, where we take control of the entire object deserialization/resolution/composition step ourselves. XML is one area where we can easily provide deserialization seamlessly from our controller action knowing about it. Let’s look at a simple example of a controller action accepting XML and responding with XML:

<pre class="code"><span style="color: blue">public class </span><span style="color: #2b91af">MathController </span>: <span style="color: #2b91af">Controller
</span>{
    <span style="color: blue">public </span><span style="color: #2b91af">ActionResult </span>Square(<span style="color: #2b91af">Payload </span>payload)
    {
        <span style="color: blue">var </span>result = <span style="color: blue">new </span><span style="color: #2b91af">Result
        </span>{
            Value = payload.Value * payload.Value
        };

        <span style="color: blue">return new </span><span style="color: #2b91af">XmlResult</span>(result);
    }
}
</pre>

Our input and output models are items easily serializable/deserializable:

<pre class="code"><span style="color: blue">public class </span><span style="color: #2b91af">Payload
</span>{
    <span style="color: blue">public int </span>Value { <span style="color: blue">get</span>; <span style="color: blue">set</span>; }
}

<span style="color: blue">public class </span><span style="color: #2b91af">Result
</span>{
    <span style="color: blue">public int </span>Value { <span style="color: blue">get</span>; <span style="color: blue">set</span>; }
}
</pre>

The XmlResult is from [MvcContrib](http://mvccontrib.codeplex.com/), and encapsulates the serialization for us. However, we don’t have anything to accept XML as an input. We could just accept a string value and do the manual deserialization ourselves, but what’s the fun in that?

We’d also like to have the binding done according to the content type of the request payload, so that “text/xml” is recognized and automatically deserialized, just as “application/json” is currently done out of the box. Using [RestSharp](http://restsharp.org/), we want to get this test to pass:

<pre class="code">[<span style="color: #2b91af">Test</span>]
<span style="color: blue">public void </span>RestSharp_Tester()
{
    <span style="color: blue">var </span>client = <span style="color: blue">new </span><span style="color: #2b91af">RestClient</span>(<span style="color: #a31515">"http://127.0.0.1.:33443"</span>);

    <span style="color: blue">var </span>req = <span style="color: blue">new </span><span style="color: #2b91af">RestRequest</span>(<span style="color: #a31515">"Math/Square"</span>, <span style="color: #2b91af">Method</span>.POST);
    
    <span style="color: blue">var </span>body = <span style="color: blue">new </span><span style="color: #2b91af">Payload
    </span>{
        Value = 5
    };

    req.AddBody(body);

    <span style="color: blue">var </span>resp = client.Execute&lt;<span style="color: #2b91af">Result</span>&gt;(req);

    <span style="color: blue">var </span>value = resp.Data.Value;

    <span style="color: #2b91af">Assert</span>.AreEqual(25, value);
}
</pre>

Just to make sure we’re not pulling any punches, here’s the actual HTTP request from Fiddler:

<pre class="code">POST http://127.0.0.1.:33443/Math/Square HTTP/1.1
Accept: application/json, application/xml, text/json, text/x-json, text/javascript, text/xml
User-Agent: RestSharp 101.3.0.0
Content-Type: text/xml
Host: 127.0.0.1.:33443
Content-Length: 41
Accept-Encoding: gzip, deflate
Connection: Keep-Alive

&lt;Payload&gt;
  &lt;Value&gt;5&lt;/Value&gt;
&lt;/Payload&gt;
</pre>

Not that exciting, I know, but you can see from the request that the content type indicated is “text/xml”. Our model binder should detect this and provide a deserialized object from that XML.

To do this, we’ll first need to build a model binder provider. Model binder providers decide on whether or not for the given type that they can provide a model binder. Instead of looking at the type metadata, let’s look at the content type of the incoming request:

<pre class="code"><span style="color: blue">public class </span><span style="color: #2b91af">XmlModelBinderProvider </span>: <span style="color: #2b91af">IModelBinderProvider
</span>{
    <span style="color: blue">public </span><span style="color: #2b91af">IModelBinder </span>GetBinder(<span style="color: #2b91af">Type </span>modelType)
    {
        <span style="color: blue">var </span>contentType = <span style="color: #2b91af">HttpContext</span>.Current.Request.ContentType;

        <span style="color: blue">if </span>(<span style="color: blue">string</span>.Compare(contentType, <span style="color: #a31515">@"text/xml"</span>, 
            <span style="color: #2b91af">StringComparison</span>.OrdinalIgnoreCase) != 0)
        {
            <span style="color: blue">return null</span>;
        }

        <span style="color: blue">return new </span><span style="color: #2b91af">XmlModelBinder</span>();
    }
}
</pre>

We check the incoming request’s content type, and if it matches our “text/xml” type, we return our XmlModelBinder. The XmlModelBinder is rather simple now, shown below.

<pre class="code"><span style="color: blue">public class </span><span style="color: #2b91af">XmlModelBinder </span>: <span style="color: #2b91af">IModelBinder
</span>{
    <span style="color: blue">public object </span>BindModel(
        <span style="color: #2b91af">ControllerContext </span>controllerContext,
        <span style="color: #2b91af">ModelBindingContext </span>bindingContext)
    {
        <span style="color: blue">var </span>modelType = bindingContext.ModelType;
        <span style="color: blue">var </span>serializer = <span style="color: blue">new </span><span style="color: #2b91af">XmlSerializer</span>(modelType);

        <span style="color: blue">var </span>inputStream = controllerContext.HttpContext.Request.InputStream;

        <span style="color: blue">return </span>serializer.Deserialize(inputStream);
    }
}
</pre>

We simply build up the built-in XML serializer based on the model type we’re binding to, feeding in the raw Stream from the request. Finally, we need to make sure we add our model binder provider to the global providers collection at application startup (Application_Start):

<pre class="code"><span style="color: blue">protected void </span>Application_Start()
{
    <span style="color: #2b91af">AreaRegistration</span>.RegisterAllAreas();

    <span style="color: #2b91af">ModelBinderProviders</span>.BinderProviders
        .Add(<span style="color: blue">new </span><span style="color: #2b91af">XmlModelBinderProvider</span>());

    RegisterGlobalFilters(<span style="color: #2b91af">GlobalFilters</span>.Filters);
    RegisterRoutes(<span style="color: #2b91af">RouteTable</span>.Routes);
}
</pre>

This model binder provider could have been provided through the service location option instead of registered manually. With this model binder provider added, our model is correctly bound, and the response returned matches our expectation:

<pre class="code">HTTP/1.1 200 OK
Server: ASP.NET Development Server/10.0.0.0
Date: Fri, 24 Jun 2011 01:15:55 GMT
X-AspNet-Version: 4.0.30319
X-AspNetMvc-Version: 3.0
Cache-Control: private
Content-Type: text/xml; charset=utf-8
Content-Length: 178
Connection: Close

&lt;?xml version="1.0" encoding="utf-8"?&gt;
&lt;Result&gt;
  &lt;Value&gt;25&lt;/Value&gt;
&lt;/Result&gt;
</pre>

The value coming out is just what was returned from the XmlResult, but what’s neat is that our input model is just a POCO that looks like it could have come from a POST from form encoded values, JSON or XML. In fact, they all work!

With just a few lines of code, we were able to effectively add XML support to our HTTP endpoints. It’s certainly not a full REST framework, but it can serve in a pinch in cases we just need to expose simple endpoints for consumers that want to do RPC but don’t want to go the full SOAP route.

We also leave open the option of supporting alternative content types, all seamless to our controller action (except for content negotiation). All without mucking around with the complications of WCF, using the same deployment, development and configuration model of our normal ASP.NET MVC sites.