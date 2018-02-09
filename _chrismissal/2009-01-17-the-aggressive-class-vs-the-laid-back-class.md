---
wordpress_id: 3339
title: The Aggressive Class vs The Laid Back Class
date: 2009-01-17T16:08:00+00:00
author: Chris Missal
layout: post
wordpress_guid: /blogs/chrismissal/archive/2009/01/17/the-aggressive-class-vs-the-laid-back-class.aspx
dsq_thread_id:
  - "262174773"
categories:
  - Best Practices
  - Design Principles
redirect_from: "/blogs/chrismissal/archive/2009/01/17/the-aggressive-class-vs-the-laid-back-class.aspx/"
---
Oftentimes it&#8217;s very beneficial to be aggressive. You can be in sales, sports, real estate, marketing,&nbsp; or Hollywood and an agressive attitude will most likely pay off. I think that as developers, having an agressive, &#8220;go-get-em&#8221; demeanor helps us keep on top of the game; we can learn new practices and technologies to help ourselves write better software. In contrast, developers who are laid-back, or even lazy, are going to have a much tougher road ahead as technology (inevitably) advances. It seems odd yet obvious to me that the code we write should be the complete opposite.&nbsp; Take this ComputerBuilder class for example:

<pre>public class ComputerBuilder
{
	private readonly List&lt;Part&gt; monitorList = new List&lt;Part&gt;();
	private readonly List&lt;Part&gt; printerList = new List&lt;Part&gt;();

	public ComputerBuilder(string configFilename)
	{
		var configuration = ConstructConfiguration(configFilename);
		var database = new Database();

		var monitors = database.GetParts(PartType.Monitor);
		var monitorPrice = configuration.GetPrice(PartType.Monitor);
		foreach (var monitor in monitors)
		{
			if (monitor.IsInPriceRange(monitorPrice))
			{
				monitorList.Add(monitor);
			}
		}

		var printers = database.GetParts(PartType.Printer);
		var printerPrice = configuration.GetPrice(PartType.Printer);
		foreach (var printer in printers)
		{
			if (printer.IsInPriceRange(printerPrice))
			{
				monitorList.Add(printer);
			}
		}
	}

	private Configuration ConstructConfiguration(string filename)
	{
		// omitted code to build up a Configuration object from a file
	}

	public List&lt;Part&gt; GetMonitorsInPriceRange()
	{
		return monitorList;
	}

	public List&lt;Part&gt; GetPrintersInPriceRange()
	{
		return printerList;
	}
}
</pre>

Look how &#8220;powerful&#8221; this class is. It accepts a conguration file&#8217;s filename in the constructor, reads some data from it and generates a couple lists of parts for use later. It also reads the file for a connection string to connect to adatabase. This class is very aggressive, it&#8217;s a real &#8220;go-getter&#8221;. There&#8217;s a few problems with this; I call this powerful, but that&#8217;s the wrong word; it&#8217;s messy and does too much. I breaks the [Single Responsibility Principle](/blogs/sean_chambers/archive/2008/03/15/ptom-single-responsibility-principle.aspx) in a most egregious manner. Time to refactor!

<pre>public class ComputerBuilder
{
	private Database database;
	private decimal monitorPrice;
	private decimal printerPrice;

	public ComputerBuilder(Configuration configuration, Database database)
	{
		this.database = database;
		monitorPrice = configuration.GetPrice(PartType.Monitor);
		printerPrice = configuration.GetPrice(PartType.Printer);
	}

	public List&lt;Part&gt; GetMonitorsInPriceRange()
	{
		var list = new List&lt;Part&gt;();
		var monitors = database.GetParts(PartType.Monitor);
		foreach (var monitor in monitors)
		{
			if (monitor.IsInPriceRange(monitorPrice))
			{
				list.Add(monitor);
			}
		}
		return list;
	}

	public List&lt;Part&gt; GetPrintersInPriceRange()
	{
		var list = new List&lt;Part&gt;();
		var printers = database.GetParts(PartType.Printer);
		foreach (var printer in printers)
		{
			if (printer.IsInPriceRange(printerPrice))
			{
				list.Add(printer);
			}
		}
		return list;
	}
}
</pre>

<img alt="The Aggressive Class" style="float: left;margin: 11px 15px" src="//lostechies.com/chrismissal/files/2011/03/aggressive.jpg" />

<img alt="The Laid Back Class" style="float: right;margin-left: 15px;margin-right: 15px" src="//lostechies.com/chrismissal/files/2011/03/laidback.jpg" />

So this is a lot better already. We didn&#8217;t have modify our methods, only the constructor. We don&#8217;t require our ComputerBuilder to know about the file system anymore. We also don&#8217;t need to open a database connection. It has become a little selfish and lazy, and that&#8217;s not necessarily a bad thing in this case. We can get better though. Let&#8217;s see what else we can do if we modify our methods a bit more. Not all the time you&#8217;ll be able to do sufficient refactoring to get your code to a point where it&#8217;s ideal, but the following is an ideal implementation of what our fake code is attempting to do.

<pre>public class ComputerBuilder
{
	private readonly IConfiguration configuration;
	private readonly IPartsRepository partsRepository;

	public ComputerBuilder(IConfiguration configuration, IPartsRepository partsRepository)
	{
		this.configuration = configuration;
		this.partsRepository = partsRepository;
	}

	IEnumerable&lt;PART&gt; GetPartsInPriceRange&lt;PART&gt;() where PART : IPart
	{
		var price = configuration.GetPrice&lt;PART&gt;();
		var parts = partsRepository.GetParts&lt;PART&gt;();
		return parts.Where(x =&gt; x.IsInPriceRange(price));
	}
}
</pre>

The second refactoring is so laid back that it doesn&#8217;t even care what type of part you pass in to get the ones in the configured price range. All it worries about is that the type parameter, PART, fits the contract. Most everything has been abstracted into interfaces to allow for this [chillaxed](http://www.urbandictionary.com/define.php?term=chillaxed) behavior. It&#8217;s not so aggressive anymore and if/when it [throw](http://msdn.microsoft.com/en-us/library/xhcbs8fz.aspx "How to: Explicitly Throw Exceptions (Pun!)")s a fit, you have as hard of a time figuring out why it&#8217;s mad.