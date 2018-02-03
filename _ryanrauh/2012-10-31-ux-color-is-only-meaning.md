---
wordpress_id: 180
title: 'UX: Color is only meaningful if it&#8217;s different'
date: 2012-10-31T13:41:32+00:00
author: Ryan Rauh
layout: post
wordpress_guid: http://lostechies.com/ryanrauh/?p=180
dsq_thread_id:
  - "908458156"
categories:
  - Uncategorized
---
# Color is important for UX 

On the daily, when I&#8217;m not lurking [imgur](http://imgur.com "click here for lulz"), I work on HR case management software. HR case management isn&#8217;t exactly the sexiest technology sector, but that doesn&#8217;t keep me from trying to provide the best User Experience possible.

Recently I&#8217;ve been working on a light switch type control that can use various colors when they are in the active state

Here&#8217;s the toggle color for making a case &#8220;Sensitive&#8221; in our application. A &#8220;Sensitive&#8221; case is restricted and can not be seen by users in our public facing application.

[<img src="http://clayvessel.org/clayvessel/wp-content/uploads/2012/10/sensitive-control.png" alt="" title="sensitive-control" width="141" height="80" class="aligncenter size-full wp-image-181" />](http://clayvessel.org/clayvessel/wp-content/uploads/2012/10/sensitive-control.png)

Here&#8217;s what it looks like in the app on our case page.

[<img src="http://clayvessel.org/clayvessel/wp-content/uploads/2012/10/case-sensitive.png" alt="" title="case-sensitive" width="381" height="253" class="aligncenter size-full wp-image-184" />](http://clayvessel.org/clayvessel/wp-content/uploads/2012/10/case-sensitive.png)

The color helps the user see from a glance that this Case is different, because the color isn&#8217;t the normal state. That&#8217;s the key here, it wouldn&#8217;t be special if it was always yellow.

The main purpose of our application is to keep track of the entire conversation over the issue. This mostly consists of comments and emails between the employee and their HR rep.

[<img src="http://clayvessel.org/clayvessel/wp-content/uploads/2012/10/internal-inactive.png" alt="" title="internal-inactive" style="max-width:100%" class="aligncenter wp-image-187" srcset="http://clayvessel.org/clayvessel/wp-content/uploads/2012/10/internal-inactive.png 719w, http://clayvessel.org/clayvessel/wp-content/uploads/2012/10/internal-inactive-300x217.png 300w" sizes="(max-width: 719px) 100vw, 719px" />](http://clayvessel.org/clayvessel/wp-content/uploads/2012/10/internal-inactive.png)

[<img src="http://clayvessel.org/clayvessel/wp-content/uploads/2012/10/internal-active.png" alt="" title="internal-active" style="max-width:100%" class="aligncenter wp-image-186" srcset="http://clayvessel.org/clayvessel/wp-content/uploads/2012/10/internal-active.png 718w, http://clayvessel.org/clayvessel/wp-content/uploads/2012/10/internal-active-300x217.png 300w" sizes="(max-width: 718px) 100vw, 718px" />](http://clayvessel.org/clayvessel/wp-content/uploads/2012/10/internal-active.png)

Notice here that I used the same control and color for toggling comments. If the HR rep doesn&#8217;t want a comment or an email to be seen by the employee they can set it to Internal. The logs are created as public so the color is meaningful because it&#8217;s **different.**

Some customers want every log (comment, email, ect.) to be internal by default, so we have a setting they can configure that will create all of the logs as internal. This changes the meaning of the color, if everything is internal by default then the yellow color is no longer special it&#8217;s not **different** so it&#8217;s no longer meaningful.

When that happens the control changes to &#8220;Public&#8221; and the color changes from a warning color to a primary color. 

[<img src="http://clayvessel.org/clayvessel/wp-content/uploads/2012/10/public-inactive.png" alt="" title="internal-inactive" style="max-width:100%" class="aligncenter wp-image-187" />](http://clayvessel.org/clayvessel/wp-content/uploads/2012/10/public-inactive.png)

[<img src="http://clayvessel.org/clayvessel/wp-content/uploads/2012/10/public-active.png" alt="" title="internal-active" style="max-width:100%" class="aligncenter wp-image-186" />](http://clayvessel.org/clayvessel/wp-content/uploads/2012/10/public-active.png)

Color is great in an application, but it&#8217;s only meaningful if it stands out from what&#8217;s normal in your application.

Keep herpin\` while you&#8217;re derpin\`
  
-Ryan