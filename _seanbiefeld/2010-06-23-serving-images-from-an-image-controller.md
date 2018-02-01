---
id: 18
title: Serving Images from an Image Controller
date: 2010-06-23T13:40:00+00:00
author: Sean Biefeld
layout: post
guid: /blogs/seanbiefeld/archive/2010/06/23/serving-images-from-an-image-controller.aspx
dsq_thread_id:
  - "466699914"
categories:
  - .NET
  - ASP.NET MVC
  - 'C#'
---
Found this solution rather simple when you want to serve images from your database.

<pre style="overflow-x:scroll;background-color: #141414;font-family: Lucida Console;padding: 5px;border:solid 1px #333;overflow: auto;color: #BEBEC8;font-size: 8pt"><span style="color: #cda869">public</span> <span style="color: #7386a5">class</span> <span style="color: #7386a5">ImageController</span>
{
	<span style="color: #cda869">readonly</span> <span style="color: #d0da90">IImageQueries</span> Queries;

	<span style="color: #cda869">public</span> ImageController(<span style="color: #d0da90">IImageQueries</span> queries)
	{
		Queries <span style="color: #cda869">=</span> queries;
	}

	<span style="color: #cda869">public</span> FileResult Show(int id)
	{
		<span style="color: #7386a5">DateTime</span><span style="color: #cda869">?</span> dateCreated <span style="color: #cda869">=</span> Queries<span style="color: #cda869">.</span>GetDateCreatedById(id);

		<span style="color: #444">//invalid image, return 404</span>
		<span style="color: #cda869">if</span> (dateCreated <span style="color: #cda869">== null</span>)
		{
			<span style="color: #7386a5">HttpContext</span><span style="color: #cda869">.</span>Response<span style="color: #cda869">.</span>StatusCode <span style="color: #cda869">=</span> 404;

			<span style="color: #cda869">return null</span>;
		}
		<span style="color: #cda869">else</span>
		{
			<span style="color: #cda869">string</span> ifModifiedSince = <span style="color: #7386a5">HttpContext</span><span style="color: #cda869">.</span>Request<span style="color: #cda869">.</span>Headers[<span style="color: #8f9d6a">"If-Modified-Since"</span>];

			<span style="color: #444">//check if image has been modified</span>
			<span style="color: #cda869">if</span> (ifModifiedSince <span style="color: #cda869">!= null &&</span> dateCreated.Value <span style="color: #cda869">&lt;=</span> <span style="color: #7386a5">DateTime</span><span style="color: #cda869">.</span>Parse(ifModifiedSince))
			{
				<span style="color: #7386a5">HttpContext</span><span style="color: #cda869">.</span>Response<span style="color: #cda869">.</span>StatusCode <span style="color: #cda869">=</span> 304;
				<span style="color: #cda869">return null</span>;
			}
			<span style="color: #cda869">else</span>
			{
				<span style="color: #7386a5">HttpContext</span><span style="color: #cda869">.</span>Response<span style="color: #cda869">.</span>Cache<span style="color: #cda869">.</span>SetLastModified(dateCreated<span style="color: #cda869">.</span>Value);

				<span style="color: #cda869">dynamic</span> image = Queries<span style="color: #cda869">.</span>GetById(id);

				<span style="color: #cda869">return new</span> FileContentResult(image<span style="color: #cda869">.</span>Bytes, image<span style="color: #cda869">.</span>MimeType);
			}
		}
	}
}
</pre>