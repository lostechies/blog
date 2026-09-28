---
wordpress_id: 4049
title: 'How We Do Things &#8211; Who we are, Where we were, Where we stand'
date: 2009-10-05T03:16:23+00:00
author: Scott Reynolds
layout: post
wordpress_guid: /blogs/scottcreynolds/archive/2009/10/05/how-we-do-things-who-we-are-where-we-were-where-we-stand.aspx
categories:
  - how we do it
  - Management
  - team
redirect_from: "/blogs/scottcreynolds/archive/2009/10/05/how-we-do-things-who-we-are-where-we-were-where-we-stand.aspx/"
---
_This content comes solely from my experience, study, and a lot of trial and error (mostly error). I make no claims stating that which works for me will work for you. As with all things, your mileage may vary, and you will need to apply all knowledge through the filter of your context in order to strain out the good parts for you. Also, feel free to call BS on anything I say. I write this as much for me to learn as for you._

_This is part 1 of the [How We Do Things](https://lostechies.com/blogs/scottcreynolds/archive/2009/10/04/how-we-do-things-preamble-and-contents.aspx) series._

Allow me to introduce our team. We are an IT development shop in a rapidly growing corporate laboratory. Our company functions as a lab (your doctor takes a biopsy, sends it to us for diagnosis) and as a laboratory services company. We are a sales-driven medical organization with priorities split between medical and patient care concerns and sales and corporate priorities (with the ever-annoying regulatory concerns mixed in for good measure). In my 5+ years here our volume in case load alone has grown over 2,000%, and we have steadily (or maybe exponentially) increased our number of product lines and service offerings to our client physicians. I don&#8217;t take credit for all of this, but, our team has been an integral part in enabling this growth.

When I started we had myself, our Director of IT, and a DBA/Report Specialist as the entire IT department. Now I have 8 developers, a DBA, a QA tester, and two Business Analysts in my department alone, and an equivalent number of network and support staff.

My time here started with the goal of facilitating augmentation of our purchased Lab Information System (LIS). That turned into trying to buy a new one that would grow with us. An unsuccessful search there led to creating our own. The system we created has been called &#8220;the best in the industry&#8221; by our doctors and external parties. It has been in successful operation for almost 3 years, and is undergoing constant new development to facilitate new product lines and changing offerings, new and changing regulatory requirements, and the standard &#8220;wishlist enhancements&#8221; that come with any enterprise software. In addition to our LIS we provide data integrations with a large number of external systems, from state departments of health to commercial electronic medical records (EMR) packages. We also provide web-based tools for multiple levels of clients to interact with us. At present we are undergoing a massive effort to extend our software to support our growing services, but I can&#8217;t go into much detail about that yet 😉

Our LIS was designed in a waterfall-ish way, beginning in late 2004. We broke ground on code in late 2005. The entirety of the release version of the system was coded by myself and a junior programmer fresh out of high school. The suite of applications is composed of client applications for medical and lab personnel, sales support and client service users, IT users, billing users, and a slew of back-end services. In truth, lab management is probably only half of the picture, and it&#8217;s a full-on enterprise application suite. Deployment consisted of the entire team being on-site at our lab facility 1500 miles from home for a month working 22 hour days on average. It was not fun times.

To say I&#8217;ve learned a lot from the development of this system, and what has happened since, is an understatement. Since that time I&#8217;ve added a large number of staff, and found myself transitioning from developer to full-time manager. We have had to learn to accommodate rapidly changing priorities and capitalize on business opportunities in rapid-fire mode while maintaining a no-exceptions stance on quality and correctness. After all, we&#8217;re dealing with people&#8217;s lives.

The LIS system was not built with TDD (and we pay for that every friggin day), and has a lot of technical debt that we deal with. We rolled our own data access for God&#8217;s sake, and it&#8217;s still there. We were not agile when we started. We worked hard, very hard, to earn every ounce of trust that the business has gained in our ability to deliver, and we&#8217;ve traded on that trust to implement the changes and improvements we&#8217;ve made along the way. Sometimes the path to improvement has been easy and obvious, and sometimes we&#8217;ve just had to say &#8220;trust us&#8221;. Without establishing that trust first, without establishing that we are a team that can deliver value and is in tune with the organization as a whole, we wouldn&#8217;t have been able to make the improvements we&#8217;ve made.

I can&#8217;t stress this enough. An organization has no reason to trust you unless you earn that trust. And let&#8217;s be honest, a lot of the practices I&#8217;m going to talk about, such as Pair Programming, non-traditional project management, and TDD, aren&#8217;t sold on the numbers. They&#8217;re sold on trust and post-practice verification.

The team today is very different in form and function than it was five years ago. Apart from being larger, we operate as a lean software team utilizing kanban for workflow and just-in-time planning and design. We hold many XP practices dear that we&#8217;ve adopted along the way, including pair programming and TDD. We deliver continuously and we do so at extremely high quality. The story of how we got from there to here is the focus of this series. Come along for the ride.