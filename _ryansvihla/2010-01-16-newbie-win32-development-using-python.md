---
wordpress_id: 36
title: Newbie Win32 Development Using Python
date: 2010-01-16T04:35:33+00:00
author: Ryan Svihla
layout: post
wordpress_guid: /blogs/rssvihla/archive/2010/01/15/newbie-win32-development-using-python.aspx
dsq_thread_id:
  - "1075599217"
categories:
  - DotNet
  - Python
---
First a disclaimer. I’m not in anyway shape or form an experienced win32 systems programmer.&#160; I’ve always done application development or systems administration scripting. That in-between area where you get out your C/C++ compiler and start dealing with pointers is completely alien to me.&#160; This has created problems in the past when I need to do something outside of the scope of C# and found myself staring at MSDN docs in C trying to extrapolate the equivalent C# code, and typically being disgusted at having to use hand rolled Structs with calls to Marshall.GetLastWin32Error().

Worse still I end up with a nasty implementation that requires slow, fragile integration tests to verify behavior or very verbose mirror interfaces where I’m testing order of calls. Look at the following code sample to read a reparse point’s target directory from <a href="http://www.codeproject.com/KB/vista/Windows_Vista.aspx" target="_blank">code project</a>:

<div style="padding-bottom: 0px;margin: 0px;padding-left: 0px;padding-right: 0px;float: none;padding-top: 0px" class="wlWriterEditableSmartContent">
  <div style="font-family:consolas,lucida console,courier,monospace">
    &#160;<span style="color:#008000">//&#160;Allocate&#160;a&#160;buffer&#160;for&#160;the&#160;reparse&#160;point&#160;data:<br /> </span>Int32&#160;outBufferSize&#160;=&#160;Marshal.SizeOf(<span style="color:#0000ff">typeof</span>(REPARSE_GUID_DATA_BUFFER));<br /> IntPtr&#160;outBuffer&#160;=&#160;Marshal.AllocHGlobal(outBufferSize);<br /> &#160;<br /> <span style="color:#0000ff">try</span><br /> <span style="color:#0000ff">{</span><br /> &#160;<span style="color:#008000">//&#160;Read&#160;the&#160;reparse&#160;point&#160;data:<br /> </span>Int32&#160;bytesReturned;<br /> <span style="color:#008000">//&#160;WOW&#160;what&#160;a&#160;signature,&#160;it&#8217;s&#160;requiring&#160;blank&#160;data!&#160;<br /> //&#160;Looking&#160;at&#160;MSDN&#160;the&#160;signaure&#160;contains&#160;input&#160;and&#160;output&#160;buffer&#160;and&#160;size<br /> //&#160;for&#160;both,&#160;meaning&#160;I&#8217;m&#160;always&#160;sending&#160;something&#160;as&#160;IntPtr.Zero<br /> </span>Int32&#160;readOK&#160;=&#160;DeviceIoControl(&#160;hFile,FSCTL_GET_REPARSE_POINT,&#160;IntPtr.Zero,&#160;0,<br /> &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;outBuffer,&#160;outBufferSize,&#160;<span style="color:#0000ff">out</span>&#160;bytesReturned,IntPtr.Zero);<br /> <span style="color:#0000ff">if</span>&#160;(readOK&#160;!=&#160;0)<br /> &#160;&#160;&#160;<span style="color:#0000ff">{</span><br /> &#160;&#160;&#160;<span style="color:#008000">//&#160;Get&#160;the&#160;target&#160;directory&#160;from&#160;the&#160;reparse&#160;<br /> </span>&#160;&#160;&#160;<span style="color:#008000">//&#160;point&#160;data:<br /> </span>&#160;&#160;&#160;REPARSE_GUID_DATA_BUFFER&#160;rgdBuffer&#160;=<br /> &#160;&#160;&#160;(REPARSE_GUID_DATA_BUFFER)Marshal.PtrToStructure(outBuffer,&#160;<span style="color:#0000ff">typeof</span>(REPARSE_GUID_DATA_BUFFER));<br /> &#160;&#160;&#160;targetDir&#160;=&#160;Encoding.Unicode.GetString(&#160;rgdBuffer.PathBuffer,rgdBuffer.SubstituteNameOffset,<br /> &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;rgdBuffer.SubstituteNameLength);<br /> &#160;&#160;</p> 
    
    <p>
      <span style="color:#008000">//removed&#160;a&#160;bunch&#160;more&#160;stuff&#160;to&#160;format&#160;the&#160;result<br /> </span>&#160;<br /> <span style="color:#008000">//&#160;Free&#160;the&#160;buffer&#160;for&#160;the&#160;reparse&#160;point&#160;data:<br /> </span>&#160;Marshal.FreeHGlobal(outBuffer);<br /> &#160;<br /> &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160; </div> </div> 
      
      <p>
        &#160;
      </p>
      
      <p>
        In the past when building these kind of things for less complicated code I just would mirror out all the untestable code like Marshal , DeviceIoControl and CloseHandle calls with interfaces, then create a production wrapper.&#160; This however leads to very long tests, with lots of specifics about the internals of the interaction, in the above example the support code looks like:
      </p>
      
      <div style="padding-bottom: 0px;margin: 0px;padding-left: 0px;padding-right: 0px;float: none;padding-top: 0px" class="wlWriterEditableSmartContent">
        <div style="font-family:consolas,lucida console,courier,monospace">
          &#160;&#160;&#160;&#160;<span style="color:#0000ff">public</span>&#160;<span style="color:#0000ff">interface</span>&#160;IMarshal<br /> &#160;&#160;&#160;&#160;<span style="color:#0000ff">{</span></p> 
          
          <p>
            &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;<span style="color:#0000ff">void</span>&#160;FreeHGlobal(IntPtr&#160;buffer);<br /> &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;Object&#160;PtrToStructure(IntPtr&#160;pointer,&#160;Type&#160;structure);<br /> &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;Int32&#160;SizeOf(Type&#160;structure);<br /> &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;IntPtr&#160;AllocHGlobal(<span style="color:#2b91af">int</span>&#160;cb);<br /> &#160;&#160;&#160;&#160;<span style="color:#0000ff">}</span>
          </p>
          
          <p>
            &#160;&#160;&#160;&#160;<span style="color:#0000ff">public</span>&#160;<span style="color:#0000ff">class</span>&#160;<span style="color:#2b91af">ProdMarshal</span>&#160;:&#160;IMarshal<br /> &#160;&#160;&#160;&#160;<span style="color:#0000ff">{</span><br /> &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;<span style="color:#0000ff">public</span>&#160;<span style="color:#0000ff">void</span>&#160;FreeHGlobal(IntPtr&#160;buffer)<span style="color:#0000ff">{</span><br /> &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;<br /> &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;Marshal.FreeHGlobal(buffer);<br /> &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;<span style="color:#0000ff">}</span>
          </p>
          
          <p>
            &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;<span style="color:#008000">//&#160;you&#160;get&#160;the&#160;idea&#160;from&#160;here&#160;<br /> </span>&#160;&#160;&#160;&#160;<span style="color:#0000ff">}</span> </div> </div> 
            
            <p>
              Not terribly pretty mocking and testing this leads to is it?&#160; This isn’t also counting the win32 calls that are needed to setup and finalize the data around this. Before its all said and done to make this “testable” you end up with 2 interfaces, 2 wrapper production classes, and very heavy interaction specific mocking to even handle this basic idea of getting a value from a file system object.&#160; Before you try and point out “well you can reuse that logic later” look at the size of Marshal and ask yourself do you really want to mock all that out?
            </p>
            
            <p>
              Adding insult to injury your mocks have to be very good to replicate the behavior of the actual real thing, and it varies greatly across platforms. Windows 7 and server 2008 r2 allow reparse points (or symlinks in the this case) from directory to directory, but Vista and 2008 r1 are a no go and will fail.
            </p>
            
            <p>
              No wonder the systems developers that I know completely turn there nose up at unit testing and instead focus on slow integration or systems tests. The abstractions take time to make happen and the code itself is just not testable without lots of mirrored interfaces.
            </p>
            
            <p>
              So not wanting to spend all my time just writing mirrored interfaces day in and out for win32 calls, nor liking the idea of turning my back on unit testing, I decided to take a look at dynamic languages win32 support.
            </p>
            
            <p>
              First I looked at Ruby and the win32 libraries I saw didn’t give me the above functionality I needed with the minimal amount of hassle I wanted. DeviceIoControl up there for example with its stunningly bad signature is still pretty rough in Ruby as they have a one to one signature mapping.&#160;
            </p>
            
            <p>
              Python however has had for a very long time strong win32api support and removes some of the awful pain that you have to deal with. Below is the equivalent of the code above, again with items stripped out for brevity before and after it, but they’re roughly computationally equivalent and the Python version wins out more the more I include.
            </p>
            
            <p>
              &#160;
            </p>
            
            <div style="padding-bottom: 0px;margin: 0px;padding-left: 0px;padding-right: 0px;float: none;padding-top: 0px" class="wlWriterEditableSmartContent">
              <div style="font-family:consolas,lucida console,courier,monospace">
                <span style="color:#000000">output_buf</span><span style="color:#ce5c00"><b>=</b></span><span style="color:#000000">win32file</span><span style="color:#ce5c00"><b>.</b></span><span style="color:#000000">AllocateReadBuffer</span><span style="color:#000000"><b>(</b></span><span style="color:#000000">winnt</span><span style="color:#ce5c00"><b>.</b></span><span style="color:#000000">MAXIMUM_REPARSE_DATA_BUFFER_SIZE</span><span style="color:#000000"><b>)</b></span>&#160;<br /> <span style="color:#8f5902"><i>#notice&#160;how&#160;I&#160;don&#8217;t&#160;have&#160;to&#160;pass&#160;in&#160;size&#160;of&#160;the&#160;buffers&#160;now.&#160;I&#160;still&#160;have&#160;the&#160;need&#160;to&#160;</i></span><br /> <span style="color:#8f5902"><i>#&#160;pass&#160;None&#160;in&#160;for&#160;the&#160;input&#160;buffer&#160;here&#160;however</i></span><br /> <span style="color:#000000">buf</span><span style="color:#ce5c00"><b>=</b></span><span style="color:#000000">win32file</span><span style="color:#ce5c00"><b>.</b></span><span style="color:#000000">DeviceIoControl</span><span style="color:#000000"><b>(</b></span><span style="color:#000000">h</span><span style="color:#000000"><b>,</b></span>&#160;<span style="color:#000000">winioctlcon</span><span style="color:#ce5c00"><b>.</b></span><span style="color:#000000">FSCTL_GET_REPARSE_POINT</span><span style="color:#000000"><b>,</b></span><span style="color:#3465a4">None</span><span style="color:#000000"><b>,</b></span><span style="color:#000000">OutBuffer</span><span style="color:#ce5c00"><b>=</b></span><span style="color:#000000">output_buf</span><span style="color:#000000"><b>,</b></span>&#160;<span style="color:#000000">Overlapped</span><span style="color:#ce5c00"><b>=</b></span><span style="color:#3465a4">None</span><span style="color:#000000"><b>)</b></span>&#160;<br /> &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;<br /> <span style="color:#000000">fixed_fmt</span><span style="color:#ce5c00"><b>=</b></span><span style="color:#4e9a06">&#8216;LHHHHHH&#8217;</span>&#160;<br /> <span style="color:#000000">fixed_len</span><span style="color:#ce5c00"><b>=</b></span><span style="color:#000000">struct</span><span style="color:#ce5c00"><b>.</b></span><span style="color:#000000">calcsize</span><span style="color:#000000"><b>(</b></span><span style="color:#000000">fixed_fmt</span><span style="color:#000000"><b>)</b></span>&#160;<br /> <span style="color:#000000">tag</span><span style="color:#000000"><b>,</b></span>&#160;<span style="color:#000000">datalen</span><span style="color:#000000"><b>,</b></span>&#160;<span style="color:#000000">reserved</span><span style="color:#000000"><b>,</b></span>&#160;<span style="color:#000000">target_offset</span><span style="color:#000000"><b>,</b></span>&#160;<span style="color:#000000">target_len</span><span style="color:#000000"><b>,</b></span>&#160;<span style="color:#000000">printname_offset</span><span style="color:#000000"><b>,</b></span>&#160;<span style="color:#000000">printname_len</span>&#160;<span style="color:#ce5c00"><b>=</b></span>&#160;&#160;<br /> &#160;&#160;&#160;&#160;&#160;<span style="color:#000000">struct</span><span style="color:#ce5c00"><b>.</b></span><span style="color:#000000">unpack</span><span style="color:#000000"><b>(</b></span><span style="color:#000000">fixed_fmt</span><span style="color:#000000"><b>,</b></span>&#160;<span style="color:#000000">buf</span><span style="color:#000000"><b>[:</b></span><span style="color:#000000">fixed_len</span><span style="color:#000000"><b>])</b></span>&#160;
              </div>
            </div>
            
            <p>
              &#160;
            </p>
            
            <p>
              It’s still not pretty, but its briefer, and I can actually stub out or test struct.calcsize, AllocateReadBuffer and DeviceIoControl with no need to mess around with setting up lots of test harness code. Using my current mocking framework the test code looks something like this:
            </p>
            
            <p>
              &#160;
            </p>
            
            <div style="padding-bottom: 0px;margin: 0px;padding-left: 0px;padding-right: 0px;float: none;padding-top: 0px" class="wlWriterEditableSmartContent">
              <div style="font-family:consolas,lucida console,courier,monospace">
                <span style="color:#000000">alloc</span>&#160;<span style="color:#ce5c00"><b>=</b></span>&#160;<span style="color:#000000">mock</span><span style="color:#ce5c00"><b>.</b></span><span style="color:#000000">replaceWithMock</span><span style="color:#000000"><b>(</b></span><span style="color:#000000">win32file</span><span style="color:#000000"><b>,</b></span>&#160;<span style="color:#4e9a06">&#8220;AllocateReadBuffer&#8221;</span><span style="color:#000000"><b>)</b></span><br /> <span style="color:#204a87">buffer</span>&#160;<span style="color:#ce5c00"><b>=</b></span>&#160;<span style="color:#204a87">object</span><span style="color:#000000"><b>()</b></span><br /> <span style="color:#000000">alloc</span><span style="color:#ce5c00"><b>.</b></span><span style="color:#000000">stub</span><span style="color:#000000"><b>(</b></span><span style="color:#204a87">buffer</span><span style="color:#000000"><b>)</b></span></p> 
                
                <p>
                  <span style="color:#8f5902"><i>#removed&#160;extra&#160;setup&#160;code&#160;for&#160;calcsize&#160;and&#160;DeviceIoControl</i></span>
                </p>
                
                <p>
                  <span style="color:#000000">getTargetDir</span><span style="color:#000000"><b>()</b></span>
                </p>
                
                <p>
                  <span style="color:#000000">mock</span><span style="color:#ce5c00"><b>.</b></span><span style="color:#000000">assertCalled</span><span style="color:#000000"><b>(</b></span><span style="color:#000000">win32file</span><span style="color:#000000"><b>,</b></span>&#160;<span style="color:#4e9a06">&#8220;AllocateReadBuffer&#8221;</span><span style="color:#000000"><b>)</b></span> </div> </div> 
                  
                  <p>
                    &#160;
                  </p>
                  
                  <p>
                    Much cleaner, much lower friction and so I’m satisfied with Python for win32 development so far.&#160; I’ll give C# another look when I have the dynamic keyword and I don’t have to make explicit mirror interfaces for everything that’s untestable.
                  </p>