---
id: 16
title: Debugging Unit Tests for the iPhone/iPad
date: 2010-07-24T22:21:19+00:00
author: Scott Densmore
layout: post
guid: /blogs/scottdensmore/archive/2010/07/24/debugging-unit-tests-for-the-iphone-ipad.aspx
dsq_thread_id:
  - "269512975"
categories:
  - Uncategorized
---
**Update 8/17/2010**

I changed the Environment Variable arguments to make it easier and remove the unnecessary quotes around the directories. I now just use the SDK_ROOT for both <span>DYLD_FRAMEWORK_PATH and</span> <span>DYLD_LIBRARY_PATH variables.</span>

I have been working my way through a new iPhone app. I have been doing this TDD. One problem that I ran into was one of my tests failed, yet I could not figure out how to get it working easily so I wanted to debug my Unit Tests. This should be straight forward, yet it took me a while to figure out using the metaphors and tools of XCode (built in OCTest). I know that many people will say I should use GHUnit or GTM (Google Toolbox for Mac). I have tried both of these and I really don&#8217;t like them because they don&#8217;t feel as integrated into XCode (not that any of these tools do but that is another story). I spent a good bit of time searching around for how to do this for iPhone/iPad apps. The following articles are the best I found (although didn&#8217;t answer the questions completely):

  * [Apple&#8217;s Documentation on Unit Testing](http://developer.apple.com/iphone/library/documentation/Xcode/Conceptual/iphone_development/135-Unit_Testing_Applications/unit_testing_applications.html#//apple_ref/doc/uid/TP40007959-CH20-SW3) &#8211; This defines the difference between Application and Logic tests.
  * [Chris Hanson&#8217;s Articles on Unit Testing](http://chanson.livejournal.com/182472.html) &#8211; A good overview of unit testing on the Mac with XCode
  * [A good description of how to do this on the Apple Mailing List](http://lists.apple.com/archives/xcode-users/2010/Mar/msg00260.html)
  * [Another good description at Grokking Cocoa](http://www.grokkingcocoa.com/how_to_debug_iphone_unit_te.html)

After reading through these articles and many others I finally came up with the solution. I am using 3.2.3. Most of these articles are talking about earlier versions of XCode. Most of the solutions work (especially the last one). My biggest problem that I wanted to solve is make sure that when I switched SDK (iPhone 4 to iPad 3.2), the custom executable (more on this in a minute), otest, that I used was for the right SDK. Unfortunately, each SDK (Mac OS X 10.x, iPhone and iPad) have their own version of otest. So if I wanted to debug a universal iPad/iPhone application, I needed to point to the right otest.

When you create a UnitTest bundle in XCode, it runs a script to run the Unit Tests when you build that target. If you look at this script (/Developer/Tools/RunUnitTests), you will notice that it figures out what platform you are building for and then calls the RunPlatformUnitTests script. If you go to Terminal and do find /Developer -name RunPlatformUnitTests, you will see that there is one for each platform. Each one of these set specific environment variables and run the correct otest with the bundle passed into the script. Armed with this information and the information I got from the articles I could setup my environment to debug unit tests now.

**How to Setup XCode**

The first thing I did was add a custom executable to my project (that already had a UnitTest bundle target). I named it otest and pointed it to the otest for the iPhone 4 SDK (you could pick the one for iPad if you want). If you do a find for otest in the Developer directory (find /Developer -name otest) you will see that for each SDK, it is located in the Developer/user/bin/ folder. This was the important part of the puzzle. When you open the general table of your Custom Executable information windows, you will see a drop down for Path Type. Instead of Absolute Path you set this to Relative to Current SDK. This will then allow you to run the corrent otest depending on what SDK you pick.

<img src="http://scottdensmore.typepad.com/pictures/General_UnitTests.png" width="573" height="224" alt="General" />

Once you have this part, the rest is just setting the environment variables and the arguments for otest. You will need to pass the name of your unit test bundle (mine is UnitTests.octest). Optionally you could pass what test(s) you want to run, but I take the default to run them all. The only thing about the environment variables is that you will need to use quotes if there are spaces when things get expanded. I am not going to try and discuss each one, I leave that as an exercise for the reader. Here is the setup I have:

<img src="http://scottdensmore.typepad.com/pictures/Arguments_UnitTests.png" width="597" height="435" alt="Arguments" />

Once this is setup, you can debug your Unit Tests. As mentioned in the Grokking Cocoa article, you can clone your unit test bundle and remove the run script so you can build and debug at the same time, I don&#8217;t ever do this. If your tests fail after building, you can just do a run debug and still debug without building again. I find this easier than managing another target.

<table>
  <tr>
    <th>
      Name
    </th>
    
    <th>
      Value
    </th>
  </tr>
  
  <tr>
    <td>
      DYLD_ROOT_PATH
    </td>
    
    <td>
      $(SDKROOT)
    </td>
  </tr>
  
  <tr>
    <td>
      DYLD_FRAMEWORK_PATH
    </td>
    
    <td>
      ${BUILD_PRODUCTS_DIR}:${SDK_ROOT}:${DYLD_FRAMEWORK_PATH}
    </td>
  </tr>
  
  <tr>
    <td>
      IPHONE_SIMULATOR_ROOT
    </td>
    
    <td>
      $(SDKROOT)
    </td>
  </tr>
  
  <tr>
    <td>
      CFFIXED_USER_HOME
    </td>
    
    <td>
      $(HOME)/Library/Application Support/iPhone Simulator/User/
    </td>
  </tr>
  
  <tr>
    <td>
      OBJC_DISABLE_GC
    </td>
    
    <td>
      YES
    </td>
  </tr>
  
  <tr>
    <td>
      DYLD_LIBRARY_PATH
    </td>
    
    <td>
      ${BUILD_PRODUCTS_DIR}:${SDK_ROOT}:${DYLD_LIBRARY_PATH}
    </td>
  </tr>
  
  <tr>
    <td>
      DYLD_NEW_LOCAL_SHARED_REGIONS
    </td>
    
    <td>
      YES
    </td>
  </tr>
  
  <tr>
    <td>
      DYLD_NO_FIX_PREBINDING
    </td>
    
    <td>
      YES
    </td>
  </tr>
</table>

Hope someone finds this a useful.

<div class="itunes_track">
  Listened to: <span class="title">Become The Catalyst</span> from the album &#8220;<span class="album">The Fall Of Ideals</span>&#8221; by <span class="artist"><a href="http://www.google.com/search?q=%22All%20That%20Remains%22">All That Remains</a></span>
</div>

<div class="posttagsblock">
  <a href="http://technorati.com/tag/iPad" rel="tag">iPad</a>
</div>