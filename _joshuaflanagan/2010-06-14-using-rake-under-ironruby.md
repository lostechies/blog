---
wordpress_id: 3961
title: Using rake under IronRuby
date: 2010-06-14T22:22:19+00:00
author: Joshua Flanagan
layout: post
wordpress_guid: /blogs/joshuaflanagan/archive/2010/06/14/using-rake-under-ironruby.aspx
dsq_thread_id:
  - "263133143"
categories:
  - Ruby
---
### Download and install IronRuby

Go to <http://ironruby.codeplex.com/> and click on the Downloads tab. Grab the .zip file that is appropriate for your platform. There is also a Windows Installer, but I don’t know what it does, so I stick with the zip file. Extract it to a folder on your computer – I recommend c:ironruby. Add c:ironrubybin to your path (if you already have a version of ruby installed, I recommend putting IronRuby in the path AFTER your existing ruby).

### Download and install Rake

This is easy, as rubygems comes along with IronRuby. Open a command prompt and type:

<pre>igem install rake</pre>

In your c:ironrubybin folder, there are two new files: rake.bat and rake. I made copies of those files and named them irake.bat and irake, respectively. This is completely unnecessary, but helpful if you already have an existing ruby installed. irake will run a script with IronRuby, and rake will run a script with your existing ruby.

To test it, create a new file named rakefile.rb in a temporary folder. Add the following contents:

<div style="padding-bottom: 0px;margin: 0px;padding-left: 0px;padding-right: 0px;float: none;padding-top: 0px" class="wlWriterSmartContent">
  <pre>task :default do
  puts 'hello world'
end</pre>
</div>

Open a command prompt to the folder containing that file, and type <font size="3" face="Courier New">irake</font>. After an unfortunate pause, you should see the "”hello world” message. You now have a working IronRuby installation that can run rake scripts. If you have another version of ruby installed (and in your path), you can execute the same script by typing <font size="3" face="Courier New">rake</font>. You should see that it also (though much more quickly) puts the greeting message on screen.

### Now for something interesting

If you ran the last demo under both versions of ruby, you witnessed the downside of using rake under IronRuby– the slow startup time. However, IronRuby does have one nice big advantage for .NET developers: the ability to easily call your .NET code from the script.

For example, I recently built a simple website using a Web Application Project, which compiles to a DLL. I wanted to be able to build out the database schema using my Fluent NHibernate configuration. I created a static BuildSchema method that does just that:</p> 

<div>
  <div>
    <pre><span style="color: #606060">   1:</span> <span style="color: #0000ff">public</span> <span style="color: #0000ff">class</span> Database </pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">   2:</span> {</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">   3:</span>     <span style="color: #0000ff">public</span> <span style="color: #0000ff">static</span> <span style="color: #0000ff">void</span> BuildSchema()</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">   4:</span>     {</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">   5:</span>         <span style="color: #0000ff">new</span> SchemaExport(GetConfiguration()).Create(<span style="color: #0000ff">false</span>, <span style="color: #0000ff">true</span>);</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">   6:</span>     }</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">   7:</span>&#160; </pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">   8:</span>     <span style="color: #0000ff">public</span> <span style="color: #0000ff">static</span> Configuration GetConfiguration()</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">   9:</span>     {</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  10:</span>         <span style="color: #0000ff">return</span> Fluently.Configure()</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  11:</span>             .Database(MsSqlConfiguration.MsSql2008.ConnectionString(x =&gt;</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  12:</span>             {</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  13:</span>                 x.Database(<span style="color: #006080">"mydatabse"</span>);</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  14:</span>                 x.Server(<span style="color: #006080">"."</span>);</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  15:</span>                 x.TrustedConnection();</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  16:</span>             }))</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  17:</span>             .Mappings(map =&gt; map.AutoMappings.Add(</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  18:</span>             AutoMap</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  19:</span>             .AssemblyOf&lt;Database&gt;(t =&gt; <span style="color: #0000ff">typeof</span>(Entity).IsAssignableFrom(t))</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  20:</span>             ))</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  21:</span>&#160; </pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  22:</span>         .BuildConfiguration();</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  23:</span>     }</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  24:</span> }</pre>
    
    <p>
      <!--CRLF--></div> </div> 
      
      <p>
        I cannot easily execute the DLL from the command-line (to rebuild the database as part of a build script). Normally I would have to create a separate Console application project, which calls BuildSchema from its Main method. However, with IronRuby, I can invoke this method with the following code:
      </p>
      
      <div>
        <div>
          <pre><span style="color: #606060">   1:</span> desc <span style="color: #006080">"Generate the database (requires IronRuby)"</span></pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">   2:</span> task :db <span style="color: #0000ff">do</span></pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">   3:</span>   $:.unshift(<span style="color: #006080">'.srcMyAppbin'</span>)</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">   4:</span>   require <span style="color: #006080">'MyApp'</span></pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">   5:</span>   MyApp::Database.BuildSchema</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">   6:</span>   puts <span style="color: #006080">'Database rebuilt'</span></pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">   7:</span> end</pre>
          
          <p>
            <!--CRLF--></div> </div> 
            
            <p>
              Most of this is standard rake code. The interesting bits are in:
            </p>
            
            <ul>
              <li>
                Line 3 &#8211; Extend $: (the array of paths that ruby searches for files to load) to include the location of my binary. Otherwise, IronRuby will not be able to find any of the assemblies my assembly depends on.
              </li>
              <li>
                Line 4 &#8211; Load the libary built from the web application project (MyApp.dll)
              </li>
              <li>
                Line 5 &#8211; Invoke the static Database.BuildSchema method
              </li>
            </ul>
            
            <p>
              With IronRuby and Rake, it is trivial to create build script tasks that make use of your existing .NET code. No need to create special task libraries, as you would with NAnt or MSBuild.
            </p>