---
title: "Magical Joy"
date: 2022-05-27T13:00:00+00:00
author: Derek Greer
layout: post
---

In a segment of an interview with host Byron Sommardahl on [The Driven Developer Podcast](https://podcasts.apple.com/us/podcast/all-things-senior-derek-greer/id1584867029?i=1000541910261), recorded in the summer of 2021, Byron and I discussed a bit about a pattern I introduced to our project when we worked together in 2010 which Byron later dubbed “The Magical Joy Bus” 😂. That pattern was the [Command Dispatcher](https://stackoverflow.com/a/65295855/1219618) pattern. We unfortunately didn’t have the time I would have liked to fully unpack my thoughts and experiences with using this pattern over the years, so I thought I’d share that here.

In brief, the Command Dispatcher pattern is one where a central component is used to decouple a message issuer from a message handler. Many .Net developers have become familiar with this pattern through Jimmy Bogard’s open source library: [MediatR](https://www.nuget.org/packages/MediatR/). While I’ve never personally used the MediatR library, I have used a far more simplistic implementation throughout the years. Since my implementation was only ever primarily a single class, I never felt particularly motivated to release it as an open source library. I did, however, share my code with a former colleague a few years ago who has since packaged up a slightly modified version of my original [here](https://github.com/joelbrinkley/dispatch).

Back in 2010 and the following years, my motivation for using the pattern within the context of .Net Web applications was primarily to write clean controller actions, facilitate adherence to the Single Responsibility Principle within the Application Layer, and to eliminate the need for injecting extraneous controller or Application Service dependencies. For earlier versions of ASP.Net MVC, I still see it as a worthwhile pattern to implement. It certainly, however, has its drawbacks.

As alluded to by Byron in my interview, the team I was working with back then didn’t quite like the “magic” involved with the design. The primary issue for my teammates was that you couldn’t easily navigate from a controller action to the message handler directly via Visual Studio’s “Edit.GoToDefinition” (i.e. F12) shortcut. This was an unfortunate shortcoming of this approach, but one over which I've never experienced a large degree of angst as it was, in essence, no different than the process one must go to in locating a controller action being invoked as the result of a given Web request. All convention-over-configuration approaches suffer from some degree of degradation in discoverability and navigation. Of course, the frequency in which developers find themselves needing to navigate from controllers to components within an Application layer is really where the issue lies. A secondary issue with this pattern is the ceremony involved in declaring the messages and handlers such that they can be discovered at run time. It's just a lot of extra typing that can cause frequent mistakes. The application of convention-over-configuration to things such as DI registration or entity registration with Entity Framework are examples for which you perpetually reap the benefits of less friction. Various Command Dispatcher implementations typically result in perpetually _more_ friction.

We didn’t get around to discussing Byron’s intuition about the design all those years ago in the podcast, but Byron and my former colleagues weren’t alone in how they felt about the pattern. Over the years, I've introduced the pattern to two other teams, both of which expressed some of the same feelings of disdain over its impact on the codebase. Eventually, I came to the conclusion that, while I still saw the same benefits in the pattern’s implementation, there really was just too much friction in getting teams on board with its adoption.

Fortunately with the advent of .Net Core which introduced the [FromServices] attribute, we can achieve the same benefits mentioned earlier by injecting handlers directly into Controller Actions:

```csharp
    [HttpGet]
    public async Task<IActionResult> GetWidgets([FromQuery] GetPaginatedWidgetsRequest request, [FromServices] GetWidgetsRequestHandler handler)
    {
        return await handler.Handle(request).ToResult(r => new OkObjectResult(r), r => BadRequest());
    }
```

This is my preferred approach today. While it allows us to keep our controllers clean; to write small, focused Application Layer handler classes; and to avoid injection of unused dependencies; it’s also easy for developers at any level to work with and maintains the standard navigation and debugging experience. Win-win!
