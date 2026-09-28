---
wordpress_id: 7
title: 'Working with Interfaces Part One &#8211; Contracts'
date: 2007-10-01T21:15:00+00:00
author: Colin Ramsay
layout: post
wordpress_guid: /blogs/colin_ramsay/archive/2007/10/01/working-with-interfaces-part-one-contracts.aspx
categories:
  - 'C#'
redirect_from: "/blogs/colin_ramsay/archive/2007/10/01/working-with-interfaces-part-one-contracts.aspx/"
---
I hold my hands up &#8211; I am a programmer who doesn&#8217;t have a computer science background. My education only skimmed programming and was totally bereft of any architectural considerations. I almost stumbled into my first programming job, and I such I realise I have a lot of to learn about that which I use to earn a crust.


  


One of the things that took me a while to appreciate was the power of interfaces. I specifically remember a conversation I had with my boss in which I said, baffled, &#8220;so&#8230; they don&#8217;t actually \*do\* anything then??&#8221;. And this is kind of true, interfaces don&#8217;t really &#8220;do&#8221; anything. Instead, they&#8217;re an enabler for a couple of really useful techniques.


  


Imagine you&#8217;re creating a series of sub forms in a Windows application. They&#8217;re each supposed to do a similar thing and should always have methods to LoadSettings and SaveSettings. Something like this:

`<PRE>public class NamePrefs : Form<br />
{<br />
	public void LoadSettings(){}<br />
	public void SaveSettings(){}<br />
}</PRE>`
  


However, a new developer jumps in to your project and is instructed to create a new preferences form. They come up with something like this:

`<PRE>public class HeightPrefs : Form<br />
{<br />
	public void ExportConfigData(){}<br />
}</PRE>`
  


For starters they&#8217;ve forgotten that the form needs to load up existing data and so hasn&#8217;t implemented loading functionality. Secondly, they&#8217;ve called their save method something different to the save method in all your other preference forms. Interfaces can provide a possible solution:

`<PRE>public interface IPreferencesForm<br />
{<br />
	void LoadSettings;<br />
	void SaveSettings;<br />
}</PRE>`
  


This interface is specifying a contract which implementing classes can adhere. Our initial example would look like:

`<PRE>public class NamePrefs : Form, IPreferencesForm<br />
{<br />
	&#8230;.<br />
}</PRE>`
  


If our second example also inherited from IPreferencesForm, that implementation would throw compiler errors as neither the LoadSettings or SaveSettings methods specified in the interface contract are present in the HeightPrefs class.


  


Using interfaces only solves one part of the problem &#8211; you&#8217;ve got to make sure that people do actually inherit from them. That&#8217;s an issue which can be solved by enforcing developer policies, or technically, by ensuring only classes which implement the correct interface will get loaded by your main program. However, when interfaces are used in this manner, they can improve consistancy and lead to improved discoverability in your code.