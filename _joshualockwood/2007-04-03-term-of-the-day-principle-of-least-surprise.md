---
wordpress_id: 10
title: 'Term of the Day: Principle Of Least Surprise'
date: 2007-04-03T15:14:00+00:00
author: Joshua Lockwood
layout: post
wordpress_guid: /blogs/joshua_lockwood/archive/2007/04/03/term-of-the-day-principle-of-least-surprise.aspx
categories:
  - Best Practices
  - Principles
redirect_from: "/blogs/joshua_lockwood/archive/2007/04/03/term-of-the-day-principle-of-least-surprise.aspx/"
---
The principle of least surprise (AKA POLS) simply dictates that the interface to any given entity (method, for instance) should exhibit the bevahior that is least suprising to the user/programmer when there are conflicts or ambiguities between members of said interface.


  


Example:&nbsp;<FONT face="Times New Roman" size="3">&nbsp;</FONT>


  


<P class="MsoNormal">
  <FONT size="3"><FONT face="Times New Roman">Let&#8217;s say that the following are true&#8230;</FONT></FONT>
</P>


  


<P class="MsoNormal">
  <FONT size="3"><FONT face="Times New Roman">The following classes exist: Person, Address, People</FONT></FONT>
</P>


  


<P class="MsoNormal">
  <FONT size="3"><FONT face="Times New Roman">Person has the following attributes: SSN, Name, Address</FONT></FONT>
</P>


  


<P class="MsoNormal">
  <FONT size="3"><FONT face="Times New Roman">Person.SSN is used to identify Person instances</FONT></FONT>
</P>


  


<P class="MsoNormal">
  <FONT size="3"><FONT face="Times New Roman">People is a service that manages a set of Person objects</FONT></FONT>
</P>


  


<P class="MsoNormal">
  <FONT size="3"><FONT face="Times New Roman">People has to following methods: Add(Person):void, Get(SSN):Person</FONT></FONT>
</P>


  


<P class="MsoNormal">
  <FONT face="Times New Roman" size="3">&nbsp;</FONT>
</P>


  


<P class="MsoNormal">
  <FONT size="3"><FONT face="Times New Roman">Now let&#8217;s say Joe programmer is using People to describe his blooming social life&#8230;</FONT></FONT>
</P>


  


<P class="MsoNormal">
  <FONT size="3"><FONT face="Times New Roman">Joe says:</FONT></FONT>
</P>


  


<P class="MsoNormal">
  <FONT size="3"><FONT face="Times New Roman">myFriend = new Person()</FONT></FONT>
</P>


  


<P class="MsoNormal">
  <FONT size="3"><FONT face="Times New Roman">myFriend.Name = &#8220;John&#8221;</FONT></FONT>
</P>


  


<P class="MsoNormal">
  <FONT size="3"><FONT face="Times New Roman">myFriend.SSN = 9999999999</FONT></FONT>
</P>


  


<P class="MsoNormal">
  <FONT size="3"><FONT face="Times New Roman">myFriend.Street = 10101 Victory Lane</FONT></FONT>
</P>


  


<P class="MsoNormal">
  <FONT size="3"><FONT face="Times New Roman">myFriend.City = San Mango</FONT></FONT>
</P>


  


<P class="MsoNormal">
  <FONT size="3"><FONT face="Times New Roman">myFriend.Address.State = Texas</FONT></FONT>
</P>


  


<P class="MsoNormal">
  <FONT size="3"><FONT face="Times New Roman">myFriend.Address.Zip = 93940</FONT></FONT>
</P>


  


<P class="MsoNormal">
  <FONT face="Times New Roman" size="3">&nbsp;</FONT>
</P>


  


<P class="MsoNormal">
  <FONT size="3"><FONT face="Times New Roman">Then he says:</FONT></FONT>
</P>


  


<P class="MsoNormal">
  <FONT size="3"><FONT face="Times New Roman">friends = new People()<SPAN>&nbsp; </SPAN></FONT></FONT>
</P>


  


<P class="MsoNormal">
  <FONT size="3"><FONT face="Times New Roman">friends.Add(myFriend)</FONT></FONT>
</P>


  


<P class="MsoNormal">
  <FONT size="3"><FONT face="Times New Roman">&#8230;Now Joe&#8217;s friends include a reference to John&#8230;</FONT></FONT>
</P>


  


<P class="MsoNormal">
  <FONT face="Times New Roman" size="3">&nbsp;</FONT>
</P>


  


<P class="MsoNormal">
  <FONT size="3"><FONT face="Times New Roman">Later Joe wants to write a letter to his friend, so he says:</FONT></FONT>
</P>


  


<P class="MsoNormal">
  <FONT size="3"><FONT face="Times New Roman">myFriend = friends.Get(999999999)</FONT></FONT>
</P>


  


<P class="MsoNormal">
  <FONT face="Times New Roman" size="3">&nbsp;</FONT>
</P>


  


<P class="MsoNormal">
  <FONT size="3"><FONT face="Times New Roman">If the People class adheres to the POLS, the address of myFriend should be that same as it was when he added it to friends.<SPAN>&nbsp; </SPAN></FONT></FONT>
</P>


  


<P class="MsoNormal">
  <FONT face="Times New Roman" size="3">&nbsp;</FONT>
</P>


  


<P class="MsoNormal">
  <FONT size="3"><FONT face="Times New Roman">Now here&#8217;s a scenario that we see on occasion that will give Joe a nasty surprise.<SPAN>&nbsp; </SPAN>The author of People decided that states are implied by zip codes.<SPAN>&nbsp; </SPAN>Instead of bothering with the State value that&#8217;s passed into People, it just stores the Zip code and gets the appropriate state based on the Zip repository that People&#8217;s author went through so much trouble to create.<SPAN>&nbsp; </SPAN>Unfortunately for Joe, when Joe entered the data he had been reminiscing on his own address in central California and he accidentally entered his own Zip.&nbsp; Now Joe&#8217;s lost contact with his only friend (poor Joe).</FONT></FONT>
</P>


  


<P class="MsoNormal">
  <FONT face="Times New Roman" size="3">&nbsp;</FONT>
</P>


  


<P class="MsoNormal">
  <FONT size="3"><FONT face="Times New Roman">As a result, myFriend looks like this:</FONT></FONT>
</P>


  


<P class="MsoNormal">
  <FONT size="3"><FONT face="Times New Roman">myFriend = new Person()</FONT></FONT>
</P>


  


<P class="MsoNormal">
  <FONT size="3"><FONT face="Times New Roman">myFriend.Name = &#8220;John&#8221;</FONT></FONT>
</P>


  


<P class="MsoNormal">
  <FONT size="3"><FONT face="Times New Roman">myFriend.SSN = 9999999999</FONT></FONT>
</P>


  


<P class="MsoNormal">
  <FONT size="3"><FONT face="Times New Roman">myFriend.Street = 10101 Victory Lane</FONT></FONT>
</P>


  


<P class="MsoNormal">
  <FONT size="3"><FONT face="Times New Roman">myFriend.City = San Mango</FONT></FONT>
</P>


  


<P class="MsoNormal">
  <FONT size="3"><FONT face="Times New Roman">myFriend.Address.State = California</FONT></FONT>
</P>


  


<P class="MsoNormal">
  <FONT size="3"><FONT face="Times New Roman">myFriend.Address.Zip = 93940</FONT></FONT>
</P>


  


<P class="MsoNormal">
  <FONT face="Times New Roman" size="3">&nbsp;</FONT>
</P>


  


<P class="MsoNormal">
  <FONT size="3"><FONT face="Times New Roman">Person&#8217;s Add() looks like a setter and the Get() looks like a getter.<SPAN>&nbsp; </SPAN>The interface does nothing to communicate that somewhere in between there is an implied mutation&nbsp;based on Zip.<SPAN>&nbsp; </SPAN>This behavior would therefore violate the POLS.</FONT></FONT>
</P>


  


<P class="MsoNormal">
  <FONT face="Times New Roman" size="3">&nbsp;</FONT>
</P>


  


<P class="MsoNormal">
  <FONT face="Times New Roman" size="3">The example may seem a bit silly, but I&#8217;m sure we&#8217;ve all run into similar scenarios more than we&#8217;d like to admit.<SPAN>&nbsp; </SPAN>This concept isn&#8217;t new, just often ignored.</FONT>
</P>


  


&nbsp;