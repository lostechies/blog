---
wordpress_id: 4683
title: 'Working with Interfaces Part Three &#8211; Windsor'
date: 2007-11-21T18:00:00+00:00
author: Colin Ramsay
layout: post
wordpress_guid: /blogs/colin_ramsay/archive/2007/11/21/working-with-interfaces-part-three-windsor.aspx
categories:
  - Uncategorized
redirect_from: "/blogs/colin_ramsay/archive/2007/11/21/working-with-interfaces-part-three-windsor.aspx/"
---
[Castle Windsor](http://www.castleproject.org/container/index.html) is an [Inversion of Control](http://www.betaversion.org/%7Estefano/linotype/news/38/) container which uses interfaces as a key concept. When working in the manner I described in my previous articles on interfaces, you get a decoupled application but may end up with a lot of &#8220;wiring-up&#8221; &#8211; instantiating interface implementations then passing them into your classes.

For example, a Controller may often demand an implementation of ILogger, IAuthenticationService, IRepository and IPaymentGateway, which would require a fair bit of code to wire up. Windsor removes the wire up burden from the developer. Using XML configuration, you can easily swap out one implementation for another:

    public interface ISport{}<br>public class Football : ISport{}<br><br><component id="default.sport"<br>	service="ISport, WindsorTest"<br>	type="Football, WindsorTest"/>

In this example, we use the [component element](http://www.castleproject.org/container/documentation/trunk/usersguide/externalconfig.html) to wire up the Football implementation for any usage of ISport. For Windsor to provide this ISport implementation to your consuming classes, the consumer needs to be in the container too:

    public class Consumer<br>{<br>	// Parameter injection<br>	public ISport Sport{ get; set; }<br>	// Constructor injection<br>	public Consumer(ISport sport){} <br>}<br><br><component id="some.consumer" type="Consumer, WindsorTest"/>

So now Consumer will have the configured ISport passed to its constructor or the Sport parameter, depending on your preference. We could also have an ISport parameter on Consumer and Windsor would be able to set it with the configured implementation of ISport.

Using a system like Windsor is a logical extension of the practises I&#8217;ve talked about before. It gives you the flexibility of interfaces without the burden of having to manually instantiate and pass through all of the implementations your classes may depend upon. When thinking about [Domain Driven Design](http://www.domaindrivendesign.org/), you can use Windsor to provide Services to your application, allowing it to [consume](http://omnomnomnom.com/) independent components and create [one awesome whole](http://photos1.blogger.com/blogger/7184/598/1600/DiamondMine031.jpg). Full Windsor documentation can be found on the [Castle website](http://www.castleproject.org/container/documentation/trunk/index.html), and I&#8217;ve also written about Windsor on my [personal blog](http://colinramsay.co.uk/category/windsor/).