---
id: 111
title: 'Don&#8217;t hide the ugly'
date: 2007-12-06T13:51:29+00:00
author: Jimmy Bogard
layout: post
guid: /blogs/jimmy_bogard/archive/2007/12/06/don-t-hide-the-ugly.aspx
dsq_thread_id:
  - "264715456"
categories:
  - Misc
---
I wanted to take some time to highlight the difference between encapsulation and subterfuge.&nbsp; Just so we&#8217;re on the same page:

  * **Encapsulation**: The ability to provide users with a well-defined interface to a set of functions in a way which hides their internal workings. 
      * **Subterfuge**: An artifice or expedient used to evade a rule, escape a consequence, hide something, etc.</ul> 
    When related to code, both of these techniques hide internal details of the system.&nbsp; The key difference is _who_ we&#8217;re hiding the details from.&nbsp; With encapsulation, we&#8217;re hiding details from end-users or consumers of our API, which is a good thing.&nbsp; With subterfuge, we&#8217;re hiding ugly from developers needing to change the API, which can be disastrous.
    
    Subterfuge hides the ugly, and for ugly to get fixed, I want it front and center.&nbsp; Subterfuge comes in many varieties, but all achieve the same end result of **hiding** the ugly instead of **fixing** the ugly.
    
    ### Region directives
    
    Region directives in C# and VB.Net let you declare a region of code that can be collapsed or hidden.&nbsp; I&#8217;ve used them in the past to partition a class based on visibility or structure, so I&#8217;ll have a &#8220;.ctor&#8221; region or maybe a &#8220;Public Members&#8221; region.&nbsp; Other regions can be collapsed so I don&#8217;t need to look at them.
    
    For example, our DataGateway class seems nice and concise, and it looks like it has only about 10-20 lines of code:
    
     ![](http://grabbagoftimg.s3.amazonaws.com/region.PNG)
    
    One small problem, note the region &#8220;Legacy db access code&#8221;.&nbsp; By applying a region to some nasty code, I&#8217;ve hidden the ugliness away from the developer who otherwise might think it was a problem.&nbsp; The developer doesn&#8217;t know about the problem, as I&#8217;ve collapsed over 5000 lines of code into one small block.
    
    If a class is big and nasty, then just let it all hang out.&nbsp; If it&#8217;s really bothersome, extract the bad code into a different class.&nbsp; At least you&#8217;ll have separation between ugly and nice.&nbsp; Hiding ugly code in region directives doesn&#8217;t encourage anyone to fix it, and it tends to deceive those glancing at a class how crazy it might be underneath.
    
    ### One type per file, please
    
    Nothing irks me more than looking at a solution in the solution explorer, seeing a relatively small number of files, and then realizing that each file has a zillion types.&nbsp; A file called &#8220;DataGateway.cs&#8221; hides all sorts of nuttiness:
    
    <div class="CodeFormatContainer">
      <pre><span class="kwrd">public</span> <span class="kwrd">enum</span> DataGatewayType
{

}

<span class="kwrd">public</span> <span class="kwrd">abstract</span> <span class="kwrd">class</span> DataGateway
{
    <span class="kwrd">public</span> <span class="kwrd">abstract</span> <span class="kwrd">int</span>[] GetCustomerIDs();
}

<span class="kwrd">public</span> <span class="kwrd">class</span> SqlDataGateway : DataGateway
{
    <span class="kwrd">public</span> <span class="kwrd">override</span> <span class="kwrd">int</span>[] GetCustomerIDs()
    {
        <span class="rem">// sproc's for all!!!</span>

        <span class="kwrd">return</span> <span class="kwrd">new</span> <span class="kwrd">int</span>[] { };
    }
}

<span class="kwrd">public</span> <span class="kwrd">class</span> OracleDataGateway : DataGateway
{
    <span class="kwrd">public</span> <span class="kwrd">override</span> <span class="kwrd">int</span>[] GetCustomerIDs()
    {
        <span class="rem">// now we're getting enterprise-y </span>

        <span class="kwrd">return</span> <span class="kwrd">new</span> <span class="kwrd">int</span>[] { };
    }
}

<span class="kwrd">public</span> <span class="kwrd">class</span> MySqlGateway : DataGateway
{
    <span class="kwrd">public</span> <span class="kwrd">override</span> <span class="kwrd">int</span>[] GetCustomerIDs()
    {
        <span class="rem">// we don't support hippies </span>

        <span class="kwrd">return</span> <span class="kwrd">null</span>;
    }
}
</pre>
    </div>
    
    Java, as I understand it, has a strict convention of one type per file.&nbsp; I really like that convention (if I&#8217;m correct), as it forces the developer to match their file structure to their package (assembly) structure.&nbsp; No such luck in .NET, although there may be some FxCop or ReSharper rules to generate warnings.
    
    The problem with combining multiple types to one file is that it makes it very difficult for the developer to gain any understanding of the code they&#8217;re working with.&nbsp; Incorrect assumptions start to arise when I see a file name that doesn&#8217;t match the internal structure.&nbsp; Some of the rules I use are:
    
      * One type per file (enum, delegate, class, interface, struct) 
          * Project name matches assembly name (or root namespace name) 
              * File name matches type name 
                  * Folder structure matches namespaces 
                      * i.e. <root>Security == RootNamespace.Security</ul> 
                With these straightforward rules, a developer can look at the folder structure or the solution explorer and know exactly what types are in the project, how they are organized, and maybe even understand responsibilities and architecture.&nbsp; Even slight deviations from the above rules can cause unnecessary confusion for developers.&nbsp; You&#8217;re not doing anyone any favors by cramming 10 classes into one file, so don&#8217;t do it.
                
                ### Letting it all hang out
                
                When I was young, my mom would insist on me cleaning my room once a week (the horror!).&nbsp; Being the resourceful chap that I was, I found I could get the room _resembling_ clean by cramming everything just out of sight, into the closet, under the bed, even _in_ the bed.&nbsp; This strategy worked great until I actually needed something I stashed away, and couldn&#8217;t find it.&nbsp; I had created the illusion of organization, but the monster was lurking just out of sight.
                
                So instead of hiding the problem, I forced myself to deal with the mess until I cared enough to clean it up.&nbsp; Eventually this led me to fix problems early and often, so they don&#8217;t snowball into a disastrous mess.&nbsp; This wasn&#8217;t out of self-satisfaction or anything like that, but laziness, as I found it was more work to deal with hidden messes than it was to clean it up in the first place.
                
                If my code is a mess, I&#8217;ll just let it be ugly.&nbsp; Ugly gets annoying and ugly gets fixed, but ugly swept under the rug gets overlooked, until it pounces on the next unsuspecting developer.