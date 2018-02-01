---
id: 422
title: mvcConf slides and code posted
date: 2010-07-23T13:02:55+00:00
author: Jimmy Bogard
layout: post
guid: /blogs/jimmy_bogard/archive/2010/07/23/mvcconf-slides-and-code-posted.aspx
dsq_thread_id:
  - "264716525"
categories:
  - ASPNETMVC
---
Yesterday, I gave a talk at the virtual ASP.NET MVC conference, [mvcConf](http://mvcconf.com/) on “Putting your controllers on a diet.&#160; You can find the slides and code at the Headspring Labs CodePlex site:

<http://headspringlabs.codeplex.com/>

Just clone the Hg repository, and you’ll find all the code and slides.&#160; In the talk, I showed how to incrementally refactor this:

<pre><span style="color: blue">public class </span><span style="color: #2b91af">ConferenceControllerBefore </span>: <span style="color: #2b91af">DefaultController
</span>{
    <span style="color: blue">private readonly </span><span style="color: #2b91af">IConferenceRepository </span>_repository;

    <span style="color: blue">public </span>ConferenceControllerBefore()
    {
        _repository = <span style="color: blue">new </span><span style="color: #2b91af">ConferenceRepository</span>(<span style="color: #2b91af">Sessions</span>.Current);
    }

    <span style="color: blue">public </span><span style="color: #2b91af">ActionResult </span>Index(<span style="color: blue">int</span>? minSessions)
    {
        minSessions = minSessions ?? 0;

        <span style="color: blue">var </span>list = (<span style="color: blue">from </span>conf <span style="color: blue">in </span>_repository.Query()
                    <span style="color: blue">where </span>conf.SessionCount &gt;= minSessions
                    <span style="color: blue">select new </span><span style="color: #2b91af">ConferenceListModel
                    </span>{
                        Id = conf.Id,
                        Name = conf.Name,
                        SessionCount = conf.SessionCount,
                        AttendeeCount = conf.AttendeeCount
                    }).ToArray();

        <span style="color: blue">return </span>View(list);
    }

    <span style="color: blue">public </span><span style="color: #2b91af">ViewResult </span>Show(<span style="color: blue">string </span>eventName)
    {
        <span style="color: blue">var </span>conf = _repository.GetByName(eventName);

        <span style="color: blue">var </span>model = <span style="color: blue">new </span><span style="color: #2b91af">ConferenceShowModel
        </span>{
            Name = conf.Name,
            Sessions = conf.GetSessions()
                .Select(s =&gt; <span style="color: blue">new </span><span style="color: #2b91af">ConferenceShowModel</span>.<span style="color: #2b91af">SessionModel
                </span>{
                    Title = s.Title,
                    SpeakerFirstName = s.Speaker.FirstName,
                    SpeakerLastName = s.Speaker.LastName,
                }).ToArray()
        };

        <span style="color: blue">return </span>View(model);
    }

    <span style="color: blue">public </span><span style="color: #2b91af">ActionResult </span>Edit(<span style="color: blue">string </span>eventName)
    {
        <span style="color: blue">var </span>conf = _repository.GetByName(eventName);

        <span style="color: blue">var </span>model = <span style="color: blue">new </span><span style="color: #2b91af">ConferenceEditModel
        </span>{
            Id = conf.Id,
            Name = conf.Name,
            Attendees = conf.GetAttendees()
                .Select(a =&gt; <span style="color: blue">new </span><span style="color: #2b91af">ConferenceEditModel</span>.<span style="color: #2b91af">AttendeeEditModel
                </span>{
                    Id = a.Id,
                    FirstName = a.FirstName,
                    LastName = a.LastName,
                    Email = a.Email,
                }).ToArray()
        };

        <span style="color: blue">return </span>View(model);
    }


    [<span style="color: #2b91af">HttpPost</span>]
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
    }
}</pre>

[](http://11011.net/software/vspaste)

Into this:

<pre><span style="color: blue">public class </span><span style="color: #2b91af">ConferenceAfterController </span>: <span style="color: #2b91af">DefaultController
</span>{
    <span style="color: blue">public </span><span style="color: #2b91af">ActionResult </span>Index(<span style="color: blue">int</span>? minSessions)
    {
        <span style="color: blue">return </span>Query&lt;<span style="color: #2b91af">ConferenceListModel</span>[]&gt;(View(<span style="color: blue">new </span><span style="color: #2b91af">ListConferences</span>(minSessions)));
    }

    <span style="color: blue">public </span><span style="color: #2b91af">ActionResult </span>Show(<span style="color: #2b91af">Conference </span>eventName)
    {
        <span style="color: blue">return </span>AutoMapView&lt;<span style="color: #2b91af">ConferenceShowModel</span>&gt;(View(eventName));
    }

    <span style="color: blue">public </span><span style="color: #2b91af">ActionResult </span>Edit(<span style="color: #2b91af">Conference </span>eventname)
    {
        <span style="color: blue">return </span>AutoMapView&lt;<span style="color: #2b91af">ConferenceEditModel</span>&gt;(View(eventname));
    }

    [<span style="color: #2b91af">HttpPost</span>]
    <span style="color: blue">public </span><span style="color: #2b91af">ActionResult </span>Edit(<span style="color: #2b91af">ConferenceEditModel </span>form)
    {
        <span style="color: blue">var </span>success = <span style="color: blue">this</span>.RedirectToAction(c =&gt; c.Index(<span style="color: blue">null</span>), <span style="color: #a31515">"Default"</span>);
        
        <span style="color: blue">return </span>Form(form, success);
    }
}</pre>

[](http://11011.net/software/vspaste)

The recordings for the talks will be posted soon, so stay tuned to the mvcConf website for details.&#160; Thanks again to the organizers ([Eric Hexter](http://www.lostechies.com/blogs/hex/), [Javier Lozano](http://lozanotek.com/blog/), [Jon Galloway](http://weblogs.asp.net/jgalloway/), and some others I know I’m forgetting).&#160; The conference went more smoothly than a lot of non-virtual conferences I’ve been to, so hopefully we have another one soon (well, not TOO soon…)