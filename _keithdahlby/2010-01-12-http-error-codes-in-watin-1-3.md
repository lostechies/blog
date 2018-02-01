---
id: 4201
title: HTTP Error Codes in WatiN 1.3
date: 2010-01-12T05:11:00+00:00
author: Keith Dahlby
layout: post
guid: /blogs/dahlbyk/archive/2010/01/12/http-error-codes-in-watin-1-3.aspx
dsq_thread_id:
  - "262493302"
categories:
  - Testing
  - WatiN
---
One of the biggest surprises when I started working with WatiN was
  
the omission of a mechanism to check for error conditions. A partial
  
solution using a subclass has been [posted](http://www.bryancook.net/2008/07/catching-server-errors-with-watin-redux.html "Catching server errors with WatiN: redux")
  
before, but it doesn&#8217;t quite cover all the bases. Specifically, it&#8217;s
  
missing a mechanism to attach existing Internet Explorer instances to
  
objects of the enhanced subtype. Depending on the site under test&#8217;s use
  
of pop-ups, this could be a rather severe limitation. So let&#8217;s see how
  
we can fix it.

As [WatiN](http://watin.sourceforge.net/) is open source, one option is to just patch the existing implementation to include the desired behavior. I&#8217;ve uploaded a [patch with tests here](http://gist.github.com/274920 "gist: WatiN 1.3.1 - HTTP ErrorCode.patch"), but the gist of the patch is quite similar to the solution referenced above:

<pre>protected void AttachEventHandlers()<br />{<br />    ie.BeforeNavigate2 += (object pDisp, ref object URL, ref object Flags, ref object TargetFrameName, ref object PostData, ref object Headers, ref bool Cancel) =&gt;<br />    {<br />        ErrorCode = null;<br />    };<br />    ie.NavigateError += (object pDisp, ref object URL, ref object Frame, ref object StatusCode, ref bool Cancel) =&gt;<br />    {<br />        ErrorCode = (HttpStatusCode)StatusCode;<br />    };<br />}<br /><br />/// &lt;summary&gt;<br />/// HTTP Status Code of last error, or null if the last request was successful<br />/// &lt;/summary&gt;<br />public HttpStatusCode? ErrorCode<br />{<br />    get;<br />    private set;<br />}<br /></pre>

Before every request we clear out the error code, with errors captured as an enum value borrowed from System.Net.

We complete the patch by placing calls to our `AttachEventHandlers()` method in two places:

  1. The constructor that accepts an existing SHDocVw.InternetExplorer handle.
  2. The CreateNewIEAndGoToUri() method used by every other constructor.

At this point we can now assert success:

<pre>using (IE ie = new IE("http://solutionizing.net/"))<br />{<br />    Assert.That(ie.ErrorCode, Is.Null);<br />}</pre>

Or specific kinds of failure:

<pre>using (IE ie = new IE("http://solutionizing.net/4040404040404"))<br />{<br />    Assert.That(ie.ErrorCode, Is.EqualTo(HttpStatusCode.NotFound));<br />}</pre>

See the patch above for a more complete set of example tests.

## Private Strikes Again

It&#8217;s wonderful that we have the option to make our own patched build
  
with the desired behavior, but what if we would rather use the binary
  
distribution? Well through the magic of inheritance we can get most of
  
the way there pretty easily:

<pre>public class MyIE : IE<br />{<br />    public MyIE()<br />    {<br />        Initialize();<br />    }<br />    public MyIE(object shDocVwInternetExplorer)<br />        : base(shDocVwInternetExplorer)<br />    {<br />        Initialize();<br />    }<br />    public MyIE(string url)<br />        : base(url)<br />    {<br />        Initialize();<br />    }<br /><br />    // Remaining c'tors left as an exercise<br /><br />    // Property named ie for consistency with the private field in the parent<br />    protected InternetExplorer ie<br />    {<br />        get { return (InternetExplorer)InternetExplorer; }<br />    }<br /><br />    protected void Initialize()<br />    {<br />        AttachEventHandlers();<br />    }<br /><br />    // AttachEventHandlers() and ErrorCode as defined above<br />}<br /></pre>

But as I suggested before, this is where we run into a bit of a snag. The `IE` class also provides a set of static `AttachToIE()` methods that, as their name suggests, return an `IE`
  
object for an existing Internet Explorer window. These static methods
  
have the downside that they are hard-coded to return objects of type `IE`, not our enhanced `MyIE`
  
type. And because all the relevant helper methods are private and not
  
designed for reuse, we have no choice but to pull them into our
  
subclass in their entirety:

<pre>public new static MyIE AttachToIE(BaseConstraint findBy)<br />    {<br />        return findIE(findBy, Settings.AttachToIETimeOut, true);<br />    }<br />    public new static MyIE AttachToIE(BaseConstraint findBy, int timeout)<br />    {<br />        return findIE(findBy, timeout, true);<br />    }<br />    public new static MyIE AttachToIENoWait(BaseConstraint findBy)<br />    {<br />        return findIE(findBy, Settings.AttachToIETimeOut, false);<br />    }<br />    public new static MyIE AttachToIENoWait(BaseConstraint findBy, int timeout)<br />    {<br />        return findIE(findBy, timeout, false);<br />    }<br /><br />    private static MyIE findIE(BaseConstraint findBy, int timeout, bool waitForComplete)<br />    {<br />        SHDocVw.InternetExplorer internetExplorer = findInternetExplorer(findBy, timeout);<br /><br />        if (internetExplorer != null)<br />        {<br />            MyIE ie = new MyIE(internetExplorer);<br />            if (waitForComplete)<br />            {<br />                ie.WaitForComplete();<br />            }<br /><br />            return ie;<br />        }<br /><br />        throw new IENotFoundException(findBy.ConstraintToString(), timeout);<br />    }<br /><br />    protected static SHDocVw.InternetExplorer findInternetExplorer(BaseConstraint findBy, int timeout)<br />    {<br />        Logger.LogAction("Busy finding Internet Explorer matching constriant " + findBy.ConstraintToString());<br /><br />        SimpleTimer timeoutTimer = new SimpleTimer(timeout);<br /><br />        do<br />        {<br />            Thread.Sleep(500);<br /><br />            SHDocVw.InternetExplorer internetExplorer = findInternetExplorer(findBy);<br /><br />            if (internetExplorer != null)<br />            {<br />                return internetExplorer;<br />            }<br />        } while (!timeoutTimer.Elapsed);<br /><br />        return null;<br />    }<br /><br />    private static SHDocVw.InternetExplorer findInternetExplorer(BaseConstraint findBy)<br />    {<br />        ShellWindows allBrowsers = new ShellWindows();<br /><br />        int browserCount = allBrowsers.Count;<br />        int browserCounter = 0;<br /><br />        IEAttributeBag attributeBag = new IEAttributeBag();<br /><br />        while (browserCounter &lt; browserCount)<br />        {<br />            attributeBag.InternetExplorer = (SHDocVw.InternetExplorer) allBrowsers.Item(browserCounter);<br /><br />            if (findBy.Compare(attributeBag))<br />            {<br />                return attributeBag.InternetExplorer;<br />            }<br /><br />            browserCounter++;<br />        }<br /><br />        return null;<br />    }<br /></pre>

The original version of the first `findInternetExplorer()` is private. Were it protected instead, we would only have had to implement our own `findIE()` to wrap the found `InternetExplorer` object in our subtype.

I won&#8217;t go so far as to say private methods are a [code smell](http://kent.spillner.org/blog/work/2009/11/12/private-methods-stink.html "Private Methods are a Code Smell"), but they certainly can make the O in [OCP](http://en.wikipedia.org/wiki/Open/closed_principle "Open/Closed Principle") more difficult to achieve.

So there you have it, two different techniques for accessing HTTP
  
error codes in WatiN 1.3. At some point I&#8217;ll look at adding similar
  
functionality to 2.0, if it&#8217;s not already there. And if someone on the
  
project team see this, feel free to run with it.