---
wordpress_id: 59
title: 'ActiveSupport.NET &#8211; Namespace Overhaul'
date: 2008-02-09T04:01:45+00:00
author: Joey Beninghove
layout: post
wordpress_guid: /blogs/joeydotnet/archive/2008/02/08/activesupport-net-namespace-overhaul.aspx
categories:
  - activesupport.net
  - 'C#'
  - projects
redirect_from: "/blogs/joeydotnet/archive/2008/02/08/activesupport-net-namespace-overhaul.aspx/"
---
Figured I&#8217;d try and get this nailed down as early as possible.&nbsp; So after some recent feedback, I decided to change the namespacing so that it focused more on &#8220;behavior/concern&#8221; rather than &#8220;types&#8221;.&nbsp; What this means is&#8230;

Instead of:

  * using ActiveSupport.Core.Extensions.String;&nbsp; // containing string extensions for access, conversions, etc. 
      * using ActiveSupport.Core.Extensions.Integer;&nbsp; // containing integer extensions for access, inflections, etc. 
          * &#8230; </ul> 
        > It&#8217;s now just this:
        
          * using ActiveSupport;&nbsp; // just basic extensions 
              * using ActiveSupport.Access // all accessor-based extensions for ALL types 
                  * using ActiveSupport.Conversions // all conversion-based extensions for ALL types 
                      * &#8230; </ul> 
                    I&#8217;m pretty much thinking the accessor based stuff will probably get used the most.&nbsp; But either way, by grouping this way, I&#8217;m hoping they&#8217;ll be a bit easier use.&nbsp; And of course when our R# 4.0 EAP shows up next (right [Ilya](http://resharper.blogspot.com/)? 🙂 all of this namespace&#8217;ry will must magically work for us.&nbsp; 🙂
                    
                    What do you think?&nbsp; Is this a better approach to keeping things clean and organized?