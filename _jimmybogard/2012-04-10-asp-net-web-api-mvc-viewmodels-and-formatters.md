---
wordpress_id: 623
title: ASP.NET Web API, MVC, ViewModels and Formatters
date: 2012-04-10T14:06:32+00:00
author: Jimmy Bogard
layout: post
wordpress_guid: http://lostechies.com/jimmybogard/2012/04/10/asp-net-web-api-mvc-viewmodels-and-formatters/
dsq_thread_id:
  - "643543237"
categories:
  - ASPNETMVC
  - ASPNETWebAPI
---
There are probably a few more terms I can throw in there, but over the past few days, I’ve been struggling to bridge the gap from how I build applications in ASP.NET MVC and how I see folks building them in ASP.NET Web API (and other HTTP-centric frameworks).

These days, the de facto standard for building MVC applications looks something like this for GETs:

[<img style="background-image: none; border-right-width: 0px; padding-left: 0px; padding-right: 0px; display: inline; border-top-width: 0px; border-bottom-width: 0px; border-left-width: 0px; padding-top: 0px" title="image" border="0" alt="image" src="http://lostechies.com/content/jimmybogard/uploads/2012/04/image_thumb4.png" width="644" height="101" />](http://lostechies.com/content/jimmybogard/uploads/2012/04/image4.png)

And for POSTs:

[<img style="background-image: none; border-right-width: 0px; padding-left: 0px; padding-right: 0px; display: inline; border-top-width: 0px; border-bottom-width: 0px; border-left-width: 0px; padding-top: 0px" title="image" border="0" alt="image" src="http://lostechies.com/content/jimmybogard/uploads/2012/04/image_thumb5.png" width="644" height="104" />](http://lostechies.com/content/jimmybogard/uploads/2012/04/image5.png)

We’re using the same ViewModel for both GET and POST, where in one case the ViewModel is used in the View to build a form, and in the other case, the exact same model is used on the POST side to model bind from HTTP variables into something we can reason with.

The ViewModel usually isn’t the [persistence model](http://lostechies.com/jimmybogard/2009/12/03/persistence-model-and-domain-anemia/), as that the concerns of what your persistence layer needs often contradict what your presentation layer needs.

In this model, we have many different pieces at play here:

  * **Controller** – responsible for deciding what to do with a request. Show a view? Redirect? 
      * **ViewModel –** Represents the information model for the View in GET, and a deserialization target in a POST 
          * **View –** Responsible for translating a ViewModel into instructions for generating HTML for the view engines 
              * **ModelBinder** – Responsible for supplying the input model to a controller action</ul> 
            One key piece here I want to highlight is the View. A ViewModel can’t be translated straight to HTML, and shouldn’t. It’s not an object model suited to act as complete instructions on translating the information model to the HTML media type. In fact, you don’t see really any HTML instructions on ViewModels. There are pieces in the ViewModel that can help with HTML generation (like validation attributes), but you don’t see anything like “make this a REALLY HUGE text box”, nor should you. That’s the view’s responsibility.
            
            What’s missing is that View piece in Web API. The piece that takes the model built by a view (that is Media Type-agnostic) and provides instructions on how to then take that into
            
            ### Bridging to ASP.NET Web API
            
            Coming back to ASP.NET Web API, what objects are in play there? We have some familiar, and not so familiar:
            
              * Controller – Responsible for deciding what to do with a request, at the HTTP level 
                  * Media Type Model – Represents the information needed for a specific media type 
                      * Formatter – Responsible for translating a media type model to the specific media type</ul> 
                    What’s bothering me about this model is that I now don’t have that layer to give instructions to the Formatter on _how_ to serialize. Another thing we’ve done here is conflated the responsibilities of the “ViewModel” of this land with not only the _information_ but also _instructions._
                    
                    What do I mean by “instructions”? Putting XML serialization attributes on your model created by your API controller action is mixing the media type in with your model. Having JSON mixed around directly in our controller action. Things like this, that have [Json objects created directly in our actions](http://stephenwalther.com/blog/archive/2012/03/05/introduction-to-the-asp-net-web-api.aspx).
                    
                    I think the above abstractions are the wrong abstractions. We’re coupling the model built inside the controller action with the needs of a generic formatter. We could build a custom formatter, but that’s like building a custom view engine.
                    
                    Going back to MVC, a View bridges the gap from Resource to View Engine. I believe that a Formatter in Web API is a View Engine. It is a generic translator of instructions into a specific media type (HTML). Formatters attempt to be intelligent on how to build out other media types (JSON, XML etc.), but ultimately, making them _too_ smart means embedding media-specific information into our model. So what’s my thought? I’d like to see something like:
                    
                      * **Controller –** Responsible for deciding what to do with a request, at the HTTP level 
                          * **Resource Model** – Represents informational model of the resource, including links (at a conceptual level, not a technical level) 
                              * **Media Type Template –** Responsible for translating a Resource Model into instructions for a specific Media Type Formatter 
                                  * **Formatter** – Responsible for using the media type template and resource model to build the response</ul> 
                                Why the change from Media Type Model to Resource Model? I don’t want to couple the model in my controller action to a specific media type, that’s why! The conneg piece of Web API is what’s supposed to determine this. Imagine if you will that the resource model generated from the controller action is checked against media type templates to see what is _possible_ to return back to the client.
                                
                                You could use custom formatters in Web API, but looking at examples, they’re at the wrong abstraction layer, talking to things straight to streams etc.
                                
                                Do we need generic Media Type Templates? **No!** When we were building views for different media types in MVC, we built the **exact same model** from the controller action that fed Telerik reports, PDF reports and HTML, **all from the same controller action and model**. The _concept_ of views bridged the gap in each case to take the information model from the controller action and provide instructions to the “media type generator” on how to generate that PDF, report, or HTML view.
                                
                                ### My ideal world
                                
                                In my ideal world, my controller action in Web API would care **nothing** about specific media types. It would know how to build my rich, media-type-ignorant resource model, and that’s it. Web API would then try to line up to figure out what potential formatters are available for my resource model, taking into account accept headers and what media type templates (views) are available for this resource model.
                                
                                Because wouldn’t it be nice if I could build a single resource model that could _actually_ be used with multiple media types, not just JSON or XML? How about JSON, XML and HTML, and PDF? To do so, the responsibilities of the model generated by the view should only contain the informational model of the resource, and not have media type concerns leaking in.
                                
                                You could have defaults to make things easier, but what’s really missing here in the Web API landscape is the concept of a view (not the MVC-specific implementation). Something that is responsible for providing (optional) instructions on taking the resource model and telling the formatter how to serialize the model. Looking at Formatters how they are today, you [have to take over too much to bridge that gap](https://github.com/mamund/HypermediaContacts/blob/master/ContactsMediaTypeFormatterXml.cs).
                                
                                **But I could be totally off base here.**