---
id: 4189
title: Improve Your Code Golf Game with LINQ
date: 2009-07-23T04:47:00+00:00
author: Keith Dahlby
layout: post
guid: /blogs/dahlbyk/archive/2009/07/23/improve-your-code-golf-game-with-linq.aspx
dsq_thread_id:
  - "265590899"
categories:
  - Functional Programming
  - LINQ
---
I always enjoy a good coding challenge, and variations of code golf are most common. For the uninitiated, code golf provides a problem with the objective of providing a solution that requires the fewest keystrokes or lines. While production code certainly deserves more white space than games tend to afford, there are still some lessons we can learn from the experience.

This particular post comes on the heels of [Scott Hanselman](http://www.hanselman.com/blog/)&#8216;s casual [challenge](http://www.hanselman.com/blog/CheesyASPNETMVCProjectUpgraderForVisualStudio2010Beta1.aspx "Cheesy ASP.NET MVC Project Upgrader for Visual Studio 2010 Beta 1") to clean up some of his code in as few lines as possible. The general requirements are as follows: 

  1. Accept a path to a project
  2. For each of a few files in each project&#8230;
  3. Back up the file
  4. Perform a few string replacements in the file
  5. Save the updated version of the file

As I was looking over his code for some chances to optimize, it quickly became clear that the bulk of the &#8220;hard&#8221; stuff could be solved through some LINQ-supported functional programming. I posted a first draft, upon which others iterated, but his spam filter ate this new version so I thought it might be educational to walk through it here instead.

First, let&#8217;s define a few arrays that will specify the entirety of our configuration, along with the input array of project paths: 

<pre>static void Main(string[] args)<br />{<br />    if (args.Length == 0) Console.WriteLine("Usage: ASPNETMVCUpgrader pathToProject1 [pathToProject2] [pathToProject3]");<br /><br />    var configFiles = new[] { "web.config", @"Viewsweb.config" };<br />    var changes = new[] {<br />        new { Regex = new Regex(@"(?&lt;1&gt;System.Web.Mvc, Version=)1.0(?&lt;2&gt;.0.0,)", RegexOptions.Compiled), Replacement = "${1}1.1${2}"},<br />        new { Regex = new Regex(@"(?&lt;1&gt;System.Web.Routing, Version=)3.5(?&lt;2&gt;.0.0,)", RegexOptions.Compiled), Replacement = "${1}4.0${2}"} };</pre>

The regular expressions are based on those provided by commenter Du&scaron;an Radovanović. Next, we can use some LINQ to build a list of all our files to update: 

<pre>var filesToUpdate = from file in configFiles<br />                        from projectPath in args<br />                        let path = Path.Combine(projectPath, file)<br />                        where File.Exists(path)<br />                        select new { Path = path, Content = File.ReadAllText(path) };</pre>

If you&#8217;re not familiar with C# 3.0, by line this does the following: 

  1. Let `file` be the current item in `configFiles`.
  2. Let `projectPath` be the current item in `args`.
  3. Let `path` be the combined value of `projectPath` and `file`.
  4. Only include `path` values for files that exist.
  5. Create new anonymous objects with `Path` and `Content` properties set to the path and file contents, respectively.

As with most LINQ operations, execution of this code will be deferred until `filesToUpdate` is enumerated.

Now we&#8217;re ready to update our files. First, I&#8217;ll define a sequence of our possible backup file names, which will add &#8220;.backup_XX&#8221; to the file name.* Since the sequence is lazily evaluated, we can just call LINQ&#8217;s `First()` to find an available backup file name. Note that `First()` would throw an exception if all 100 files existed, as the `backupFileNames` sequence would be empty. 

<pre>foreach (var file in filesToUpdate)<br />    {<br />        var backupFileNames = from n in Enumerable.Range(0, 100)<br />                              let backupPath = string.Format("{0}.backup_{1:00}", file.Path, n)<br />                              where !File.Exists(backupPath)<br />                              select backupPath;<br /><br />        File.Move(file.Path, backupFileNames.First());</pre>

Finally, we need to actually update the file content. To do that, we&#8217;ll use LINQ&#8217;s `Aggregate` operator: 

<pre>string newContent = changes.Aggregate(file.Content, (s, c) =&gt; c.Regex.Replace(s, c.Replacement));<br />        File.WriteAllText(file.Path, newContent);<br />        Console.WriteLine("Done converting: {0}", file.Path);<br />    }<br />}</pre>

`Aggregate` takes two parameters: a seed value and a function that defines the aggregation. In our case, the seed value is of type `string` and the function is of type `Func<string, 'a, string>`, where `'a` is our anonymous type with `Regex` and `Replacement` properties. In practice, this call is going to take our original content and apply each of our changes in succession, using the result of one replacement as the input to the next. In functional terminology, `Aggregate` is known as a [left fold](http://en.wikipedia.org/wiki/Fold_(higher-order_function) "Fold (higher-order function)"); for more on `Aggregate` and folds, see [this awesome post](http://community.bartdesmet.net/blogs/bart/archive/2008/08/17/folding-left-right-and-the-linq-aggregation-operator.aspx "Folding left, right and the LINQ aggregation operator") by language guru [Bart de Smet](http://community.bartdesmet.net/blogs/bart/default.aspx).
  
What strikes me about this code is that it&#8217;s both terse and expressive. And for the purposes of the challenge, we can rewrite some of the queries in extension method syntax: 

<pre>static void Main(string[] args)<br />{<br />  if (args.Length == 0) Console.WriteLine("Usage: ASPNETMVCUpgrader pathToProject1 [pathToProject2] [pathToProject3]");<br /><br />  var configFiles = new[] { "web.config", @"Viewsweb.config" };<br />  var changes = new[] {<br />    new { Regex = new Regex(@"(?&lt;1&gt;System.Web.Mvc, Version=)1.0(?&lt;2&gt;.0.0,)", RegexOptions.Compiled), Replacement = "${1}1.1${2}"},<br />    new { Regex = new Regex(@"(?&lt;1&gt;System.Web.Routing, Version=)3.5(?&lt;2&gt;.0.0,)", RegexOptions.Compiled), Replacement = "${1}4.0${2}"} };<br /><br />  var files = from path in configFiles.SelectMany(file =&gt; args, (file, arg) =&gt; Path.Combine(arg, file))<br />              where File.Exists(path) select new { Path = path, Content = File.ReadAllText(path) };<br /><br />  foreach (var file in files)<br />    try<br />    {<br />      File.Move(file.Path, Enumerable.Range(0, 100).Select(n =&gt; string.Format("{0}.backup_{1:00}", file.Path, n)).First(p =&gt; !File.Exists(p)));<br />      File.WriteAllText(file.Path, changes.Aggregate(file.Content, (s, c) =&gt; c.Regex.Replace(s, c.Replacement)));<br />      Console.WriteLine("Done converting: {0}", file.Path);<br />    }<br />    catch (Exception ex) { Console.WriteLine("Error with: {0}" + Environment.NewLine + "Exception: {1}", file.Path, ex.Message); }<br />}<br /><br /></pre>

* The original code had the most recent backup with extension .<span class="content">mvc10backup, with the next oldest backup called .mvc10backup2. My original version extended this concept to &#8220;unlimited&#8221; backups with old backups continuously incremented so the lower values were more recent. It could probably be improved, but I thought I&#8217;d include the adapted code here for completeness:</span>

<pre>foreach (var file in files)<br />    try<br />    {<br />      var backupPaths = Enumerable.Repeat&lt;int?&gt;(null, 1)<br />            .Concat(Enumerable.Range(2, int.MaxValue - 2).Select(i =&gt; (int?)i))<br />            .Select(i =&gt; Path.ChangeExtension(filename, ".mvc10backup" + i));<br />      string toCopy = file.Path;<br />      foreach (var f in backupPaths.TakeWhile(_ =&gt; toCopy != null))<br />      {<br />          string temp = null;<br />          if (File.Exists(f))<br />              File.Move(f, temp = f + "TEMP");<br />          File.Move(toCopy, f);<br />          toCopy = temp;<br />      }<br />      File.WriteAllText(file.Path, changes.Aggregate(file.Content, (s, c) =&gt; c.Regex.Replace(s, c.Replacement)));<br />      Console.WriteLine("Done converting: {0}", file.Path);<br />    }<br />    catch (Exception ex) { Console.WriteLine("Error with: {0}" + Environment.NewLine + "Exception: {1}", file.Path, ex.Message); }<br />}</pre>