---
wordpress_id: 92
title: Record and playback state in ASP.NET
date: 2007-11-02T19:01:53+00:00
author: Jimmy Bogard
layout: post
wordpress_guid: /blogs/jimmy_bogard/archive/2007/11/02/record-and-playback-state-in-asp-net.aspx
dsq_thread_id:
  - "264715402"
categories:
  - ASPdotNET
  - Testing
redirect_from: "/blogs/jimmy_bogard/archive/2007/11/02/record-and-playback-state-in-asp-net.aspx/"
---
Most ASP.NET applications hold various state objects in Session, Application, or other stateful mediums.&nbsp; For regression testing and defect reproducing purposes, often I want to capture the _exact_ state of these objects and replay them back at a later time, without needing to walk through the exact steps needed to setup that state.&nbsp; For many defects, I don&#8217;t know how the state got to where it was, I just know what the state is, so I need a mechanism to record it and play it back.

I can record and playback the state&nbsp;by first&nbsp;capturing the state&nbsp;by downloading a serialized version of the object, and then play it back later by uploading the serialized object file and resuming the application.

### Recording state

The basic principle for recording state is that I&#8217;d like to serialize one of my state objects and allow the client to download the serialized object as a file.&nbsp; With direct access to the output stream of the HttpResponse, this turns out to be fairly trivial.

#### Setting up the state

First, we need some sort of state object.&nbsp; I&#8217;m not too creative, so here&#8217;s a Cart and Item object, optimized for XML serialization:

<div class="CodeFormatContainer">
  <pre><span class="kwrd">public</span> <span class="kwrd">class</span> Item
{
    <span class="kwrd">public</span> Guid Id { get; set; }
    <span class="kwrd">public</span> <span class="kwrd">string</span> Name { get; set; }
    <span class="kwrd">public</span> <span class="kwrd">int</span> Quantity { get; set; }
    <span class="kwrd">public</span> <span class="kwrd">decimal</span> Price { get; set; }
}

<span class="kwrd">public</span> <span class="kwrd">class</span> Cart 
{
    <span class="kwrd">public</span> Guid Id { get; set; }
    <span class="kwrd">public</span> <span class="kwrd">string</span> CustomerName { get; set; }

    [XmlArray(ElementName = <span class="str">"Items"</span>), XmlArrayItem(ElementName = <span class="str">"Item"</span>)]
    <span class="kwrd">public</span> Item[] Items { get; set; }
}</pre>
</div>

Normally I don&#8217;t put read/write arrays, but to demonstrate the easiest possible serialization scenario, that will do.&nbsp; For more difficult scenarios, I usually implement [IXmlSerializable](http://msdn2.microsoft.com/en-us/library/system.xml.serialization.ixmlserializable.aspx)&nbsp;or provide a separate [DTO](http://martinfowler.com/eaaCatalog/dataTransferObject.html) class strictly for serialization concerns.

In my Default.aspx page, I&#8217;ll provide a simple button to download the cart, and some code in the code-behind to create a dummy cart and respond to the button click event:

<div class="CodeFormatContainer">
  <pre><span class="kwrd">public</span> <span class="kwrd">partial</span> <span class="kwrd">class</span> _Default : System.Web.UI.Page
{
    <span class="kwrd">protected</span> <span class="kwrd">void</span> Page_Load(<span class="kwrd">object</span> sender, EventArgs e)
    {
        Cart cart = <span class="kwrd">new</span> Cart();

        cart.Id = Guid.NewGuid();
        cart.CustomerName = <span class="str">"Bob Sacamano"</span>;
       
        Item item = <span class="kwrd">new</span> Item();
        item.Id = Guid.NewGuid();
        item.Name = <span class="str">"Toothpicks"</span>;
        item.Price = 100.50m;
        item.Quantity = 99;

        Item item2 = <span class="kwrd">new</span> Item();
        item2.Id = Guid.NewGuid();
        item2.Name = <span class="str">"Ceramic mug"</span>;
        item2.Price = 5.49m;
        item2.Quantity = 30;

        cart.Items = <span class="kwrd">new</span> Item[] { item, item2 };

        Session[<span class="str">"Cart"</span>] = cart;
    }

    <span class="kwrd">protected</span> <span class="kwrd">void</span> btnDownloadCart_Click(<span class="kwrd">object</span> sender, EventArgs e)
    {
        Response.Redirect(<span class="str">"~/download.aspx"</span>);
    }
}
</pre>
</div>

Now that I have a Cart object, I need to fill in the &#8220;download.aspx&#8221; part to allow downloads of the cart.

#### Outputting state to HttpResponse

The [HttpResponse](http://msdn2.microsoft.com/en-us/library/system.web.httpresponse.aspx) object has a couple of ways to access the raw byte stream sent to the client.&nbsp; The first is the [OutputStream](http://msdn2.microsoft.com/en-us/library/system.web.httpresponse.outputstream.aspx) property, which gives me access to a raw Stream object.&nbsp; Streams are used by a multitude of objects to write raw bytes, such as serializers, etc.

I don&#8217;t normally use it when I want the end-user to save the file.&nbsp; If I&#8217;m creating a dynamic image or such, I can go directly against the OutputStream, but an alternate way is to use the [HttpResponse.BinaryWrite](http://msdn2.microsoft.com/en-us/library/system.web.httpresponse.binarywrite.aspx) method.&nbsp; This will allow me to buffer content as needed, and more importantly, provide buffer size information to the end user.&nbsp; That&#8217;s especially important for the various browser &#8220;download file&#8221; dialogs.

Here&#8217;s my Page_Load event handler for the &#8220;download.aspx&#8221; page:

<div class="CodeFormatContainer">
  <div class="csharpcode">
    <pre><span class="lnum">   1:  </span><span class="kwrd">protected</span> <span class="kwrd">void</span> Page_Load(<span class="kwrd">object</span> sender, EventArgs e)</pre>
    
    <pre><span class="lnum">   2:  </span>{</pre>
    
    <pre><span class="lnum">   3:  </span>    Cart cart = Session[<span class="str">"Cart"</span>] <span class="kwrd">as</span> Cart;</pre>
    
    <pre><span class="lnum">   4:  </span>&nbsp;</pre>
    
    <pre><span class="lnum">   5:  </span>    <span class="kwrd">if</span> (cart == <span class="kwrd">null</span>)</pre>
    
    <pre><span class="lnum">   6:  </span>    {</pre>
    
    <pre><span class="lnum">   7:  </span>        Response.Write(<span class="str">"cart is null"</span>);</pre>
    
    <pre><span class="lnum">   8:  </span>        Response.End();</pre>
    
    <pre><span class="lnum">   9:  </span>        <span class="kwrd">return</span>;</pre>
    
    <pre><span class="lnum">  10:  </span>    }</pre>
    
    <pre><span class="lnum">  11:  </span>&nbsp;</pre>
    
    <pre><span class="lnum">  12:  </span>    <span class="kwrd">try</span></pre>
    
    <pre><span class="lnum">  13:  </span>    {</pre>
    
    <pre><span class="lnum">  14:  </span>        MemoryStream ms = <span class="kwrd">new</span> MemoryStream();</pre>
    
    <pre><span class="lnum">  15:  </span>        XmlSerializer xmlSerializer = <span class="kwrd">new</span> XmlSerializer(<span class="kwrd">typeof</span>(Cart));</pre>
    
    <pre><span class="lnum">  16:  </span>&nbsp;</pre>
    
    <pre><span class="lnum">  17:  </span>        XmlTextWriter outputXML = <span class="kwrd">new</span> XmlTextWriter(ms, Encoding.UTF8);</pre>
    
    <pre><span class="lnum">  18:  </span>        xmlSerializer.Serialize(outputXML, cart);</pre>
    
    <pre><span class="lnum">  19:  </span>        outputXML.Flush();</pre>
    
    <pre><span class="lnum">  20:  </span>        ms.Seek(0, SeekOrigin.Begin);</pre>
    
    <pre><span class="lnum">  21:  </span>&nbsp;</pre>
    
    <pre><span class="lnum">  22:  </span>        <span class="kwrd">byte</span>[] output = ms.ToArray();</pre>
    
    <pre><span class="lnum">  23:  </span>        outputXML.Close();</pre>
    
    <pre><span class="lnum">  24:  </span>        ms.Close();</pre>
    
    <pre><span class="lnum">  25:  </span>&nbsp;</pre>
    
    <pre><span class="lnum">  26:  </span>        Response.ContentType = <span class="str">"application-octetstream"</span>;</pre>
    
    <pre><span class="lnum">  27:  </span>        Response.Cache.SetCacheability(HttpCacheability.NoCache);</pre>
    
    <pre><span class="lnum">  28:  </span>        Response.AppendHeader(<span class="str">"Content-Length"</span>, output.Length.ToString());</pre>
    
    <pre><span class="lnum">  29:  </span>        Response.AppendHeader(<span class="str">"Content-Disposition"</span>, <span class="str">"attachment; filename=cart.xml; size="</span> + output.Length);</pre>
    
    <pre><span class="lnum">  30:  </span>        Response.AppendHeader(<span class="str">"pragma"</span>, <span class="str">"no-cache"</span>);</pre>
    
    <pre><span class="lnum">  31:  </span>        Response.BinaryWrite(output);</pre>
    
    <pre><span class="lnum">  32:  </span>        Response.Flush();</pre>
    
    <pre><span class="lnum">  33:  </span>    }</pre>
    
    <pre><span class="lnum">  34:  </span>    <span class="kwrd">catch</span> (Exception ex)</pre>
    
    <pre><span class="lnum">  35:  </span>    {</pre>
    
    <pre><span class="lnum">  36:  </span>        Response.Clear();</pre>
    
    <pre><span class="lnum">  37:  </span>        Response.ContentType = <span class="str">"text/html"</span>;</pre>
    
    <pre><span class="lnum">  38:  </span>        Response.Write(ex.ToString());</pre>
    
    <pre><span class="lnum">  39:  </span>    }</pre>
    
    <pre><span class="lnum">  40:  </span>}</pre>
  </div>
</div>

In the first section through line 10, I retrieve the state object (cart) from Session and make sure it actually exists.&nbsp; If it doesn&#8217;t, I&#8217;ll just send an error message back to the client.

In lines 14 through 24, I create the XmlSerializer to serialize the &#8220;cart&#8221; variable, and call Serialize to serialize the cart out to the MemoryStream object.&nbsp; MemoryStream provides an in-memory Stream object that doesn&#8217;t require you to write to files, etc. for stream actions.&nbsp; Instead, it basically uses an internal byte array to store stream data.

I could have passed the HttpResponse.OutputStream directly to the XmlTextWriter&#8217;s constructor, but I would lose the ability to buffer or give size information back to the client, so I just dump it all into a byte array.

Finally, in lines 26 through 32, I set up the Response object appropriately and call BinaryWrite to write the raw byte array out to the client.&nbsp; I disable caching as I want the client to bypass any server or client cache and always download the latest Cart.&nbsp; Also, I set the appropriate headers to direct the client to download instead of just view the XML.&nbsp; If I didn&#8217;t include the &#8220;Content-Disposition&#8221; header, most likely the client would simply view the XML in their browser.&nbsp; That&#8217;s done through the value &#8220;attachment&#8221;.

I can also control what filename gets created on the client side with the &#8220;filename&#8221; value in the &#8220;Content-Disposition&#8221; header.&nbsp; Without that, a dummy or blank filename would be shown.&nbsp; Here&#8217;s what it looks like after I click the &#8220;Download cart&#8221; button:

![](http://s3.amazonaws.com/grabbagoftimg/download_cart.PNG)

Notice that both the filename and file size are populated&nbsp;correctly.&nbsp; I&nbsp;can save this&nbsp;serialized&nbsp;Cart object anywhere I like now as a perfect snapshot of our&nbsp;state object, ready to be played back.&nbsp; Also, the &#8220;cart.xml&#8221; file doesn&#8217;t exist anywhere on the server.&nbsp; It only exists in server memory and is streamed directly to the client.

### Playing it back

Now that I have a page that allows me to download my Cart from Session, I need a page where I can upload it back up and continue through the application.&nbsp; This can be accomplished through the [FileUpload](http://msdn2.microsoft.com/en-us/library/system.web.ui.webcontrols.fileupload.aspx) control and some de-serialization magic.

#### Uploading the saved state

First, I&#8217;ll need to add a couple of controls to my &#8220;Replay.aspx&#8221; page to handle the file upload&nbsp;and to initiate the replay:

<pre>&lt;asp:fileupload id="fuCart" runat="server" /&gt;
&lt;br /&gt;
&lt;asp:button id="btnReplay" onclick="btnReplay_Click" runat="Server" text="Replay" /&gt;
</pre>

In the click&nbsp;handler, I need to read the file from the FileUpload control and deserialize that into a Cart object:

<div class="CodeFormatContainer">
  <pre><span class="kwrd">protected</span> <span class="kwrd">void</span> btnReplay_Click(<span class="kwrd">object</span> sender, EventArgs e)
{
    XmlSerializer xmlSerializer = <span class="kwrd">new</span> XmlSerializer(<span class="kwrd">typeof</span>(Cart));
    Cart cart = (Cart)xmlSerializer.Deserialize(fuCart.PostedFile.InputStream);
    Session[<span class="str">"Cart"</span>] = cart;

    Response.Redirect(<span class="str">"~/ShoppingCart.aspx"</span>);
}
</pre>
</div>

Once the cart is downloaded and deserialized, I set the Session variable to the new cart instance and proceed directly&nbsp;to the ShoppingCart.aspx page.&nbsp; I can verify that my Cart object has the exact same state as the one I saved earlier by&nbsp;examining it in the debugger:

![](http://s3.amazonaws.com/grabbagoftimg/download_done.PNG)

I can see&nbsp;all of the IDs are correct, the number of items are correct, and all of the&nbsp;data&nbsp;values match the original cart saved out.&nbsp; When I proceed to the cart&nbsp;page, my state will be exactly where it was when I originally downloaded the&nbsp;cart.

### Conclusion

If&nbsp;one of our QA people encountered a defect, they can now save off their state and attach it to our defect tracking system, allowing us to&nbsp;replay exactly what their state was and reproduce the defect.&nbsp; Record/playback is also perfect for regression test suites, which sometimes need to rely on specific inputs (instead of workflows) to reproduce defects.&nbsp; Combining this ability with [WatiN](http://watin.sourceforge.net/) or [Selenium](http://www.openqa.org/selenium/) can&nbsp;give me a very powerful testing tool.

When defects are found, we can download the state of the user when replaying their workflow is difficult, impossible, or we just don&#8217;t know what happened.&nbsp; Through replaying a user&#8217;s exact state, we can quickly determine root causes for failures and create regression tests to ensure the&nbsp;defects do not surface again.

Just make sure you take care to secure the &#8220;record&#8221; and &#8220;playback&#8221; pages appropriately.&nbsp; You _probably_ won&#8217;t want that shown to customers.