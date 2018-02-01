---
id: 3871
title: An Object Lesson in Binary Compatibility
date: 2011-08-22T09:46:10+00:00
author: Sharon Cichelli
layout: post
guid: http://lostechies.com/sharoncichelli/?p=45
dsq_thread_id:
  - "393005334"
categories:
  - Open Source Software
  - Refactoring
---
A riddle for you, friends: When is changing a method from `return void` to `return Something` a breaking change?

If you already know the answer, then why hadn&#8217;t you told me? Could&#8217;ve saved me a fair bit of embarrassment. Ah well, maybe I missed your call.

## First, a story

I had the opportunity to contribute to the [HtmlTags](https://github.com/DarthFubuMVC/htmltags) open-source project<super>[1](#footnote1)</super>. They needed some unit test coverage, and I <3 unit testing and wanted to try my hand at contributing to open-source software. As I got my bearings, I got more confident and started to reach beyond the unit test project into refactoring the application code.

That&#8217;s when I [found the AddStyle and AddJavaScript methods](https://github.com/scichelli/htmltags/commit/f8103728490297bec21d8ccc0e27d890ad39ec98). Their friends returned an HtmlTag, but they returned void. They would be easier to test if they returned an HtmlTag, but that&#8217;s not a good justification for changing a method. But they would be more _consistent_ if they behaved like their neighbors, and that is a sufficient justification to consider it.

HtmlTags is a library meant to be consumed by other applications. It was already in use in the wild. Therefore, it was important not to change its API. It had to work like it always had, else we&#8217;d cause considerable grief to the developers using our code. I&#8217;ve been the consumer of a service that made breaking changes to its API, and I have choice things to say about the team that saddled me with that noise.

I thought really carefully. I was contemplating changing the return type of a public method in an in-use API. But all those uses would be calling it as if it returned nothing, and you can invoke a method without using its return value. This would be just like that. I asked a coder-buddy for advice. We convinced each other: What harm could it do?

## What about the riddle?

Here we come to the answer to the riddle. If you&#8217;re changing a library that will be called by other applications, then there are [_many_ seemingly harmless changes that are actually breaking changes](http://stackoverflow.com/questions/1456785/a-definite-guide-to-api-breaking-changes-in-net), including [changing a method&#8217;s return type](http://stackoverflow.com/questions/1456785/a-definite-guide-to-api-breaking-changes-in-net/1472967#1472967). When the consuming assembly is compiled, it is built with instructions to find a method named `Whatever` that returns void, but the changed [assembly&#8217;s manifest](http://www.akadia.com/services/dotnet_assemblies.html#Assemblies) contains only a method named `Whatever` that returns string. No match.

Computers. They&#8217;re so literal.

To fix it, you merely need to recompile the consuming application, but you don&#8217;t discover the problem until assemblies are loaded at run-time, an annoying time to discover exceptions. I coded up a simple example that illustrates the problem. Feel free to follow along at home.

## See the problem in action

Make two separate solutions, a class library called MessageOutputter and a console application called ConsoleMessager that references MessageOutputter. First, build MessageOutputter with a `return void` method.

<pre class="brush:csharp">namespace MessageOutputter
{
  public class Outputter
  {
    private string _message = "This is the outputter, version 1.";

    public string Emit()
    {
      return _message;
    }

    public void UpdateVersion(string versionNumber)
    {
      _message = string.Format("I've been altered by the UpdateVersion method. I am version {0}.", versionNumber);
    }
  }
}
</pre>

UpdateVersion modifies a private field but does not return a value. Compile that solution and put its dll into a lib folder from which you will reference it in ConsoleMessager. Open the ConsoleMessager solution and add a reference to the MessageOutputter.dll. Write a method that uses the MessageOutputter.

<pre class="brush:csharp">namespace ConsoleMessager
{
  class Program
  {
    static void Main(string[] args)
    {
      var outputter = new MessageOutputter.Outputter();
      Console.WriteLine("Calling the outputter:");
      Console.WriteLine(outputter.Emit());
      Console.WriteLine("Asking the outputter to update, then calling it again.");
      outputter.UpdateVersion("Updated 1");
      Console.WriteLine(outputter.Emit());
      Console.Read();
    }
  }
}
</pre>

The UpdateVersion method is called, not expecting a return value. Build and run the ConsoleMessager.

[<img src="http://lostechies.com/sharoncichelli/files/2011/08/RunWithVersion1-300x67.png" alt="The ConsoleMessager calls the MessageOutputter for its message." title="RunWithVersion1" width="300" height="67" class="alignnone size-medium wp-image-53" srcset="http://clayvessel.org/clayvessel/wp-content/uploads/2011/08/RunWithVersion1-300x67.png 300w, http://clayvessel.org/clayvessel/wp-content/uploads/2011/08/RunWithVersion1-768x172.png 768w, http://clayvessel.org/clayvessel/wp-content/uploads/2011/08/RunWithVersion1.png 843w" sizes="(max-width: 300px) 100vw, 300px" />](http://clayvessel.org/clayvessel/wp-content/uploads/2011/08/RunWithVersion1.png)

Return to the MessageOutputter solution and modify the UpdateVersion method to return the message after it modifies it.

<pre class="brush:csharp">namespace MessageOutputter
{
  public class Outputter
  {
    private string _message = "This is the outputter, version 2.";

    public string Emit()
    {
      return _message;
    }

    public string UpdateVersion(string versionNumber)
    {
      _message = string.Format("I've been altered by the UpdateVersion method. I am version {0}.", versionNumber);
      return _message;
    }
  }
}
</pre>

Now UpdateVersion returns a string. Build the solution and copy its new dll back into the lib folder, and into the Debug or Release folder under ConsoleMessager/bin, so that the ConsoleMessager will run with your new version of the dll. Run ConsoleMessager and you will encounter the error:

<div style="margin-left: 3em; margin-bottom: 1em;">
  Unhandled Exception: System.MissingMethodException: Method not found: &#8216;Void MessageOutputter.Outputter.UpdateVersion(System.String)&#8217; at ConsoleMessager.Program.Main(String[] args)
</div>

[<img src="http://lostechies.com/sharoncichelli/files/2011/08/ErrorWithVersion2-300x81.png" alt="MissingMethodException" title="ErrorWithVersion2" width="300" height="81" class="alignnone size-medium wp-image-52" />](http://clayvessel.org/clayvessel/wp-content/uploads/2011/08/ErrorWithVersion2.png)

The MissingMethodException indicates that ConsoleMessager, when looking within the MessageOutputter library, could not find an UpdateVersion method that returns void. Reopen the ConsoleMessager solution. Before you even build, IntelliSense will tell you that UpdateVersion returns a string now. Build ConsoleMessager and run it again, to see that it works successfully.

[<img src="http://lostechies.com/sharoncichelli/files/2011/08/RunWithVersion2-300x60.png" alt="After rebuilding, ConsoleMessager successfully calls the new MessageOutputter." title="RunWithVersion2" width="300" height="60" class="alignnone size-medium wp-image-54" srcset="http://clayvessel.org/clayvessel/wp-content/uploads/2011/08/RunWithVersion2-300x60.png 300w, http://clayvessel.org/clayvessel/wp-content/uploads/2011/08/RunWithVersion2-768x154.png 768w, http://clayvessel.org/clayvessel/wp-content/uploads/2011/08/RunWithVersion2.png 843w" sizes="(max-width: 300px) 100vw, 300px" />](http://clayvessel.org/clayvessel/wp-content/uploads/2011/08/RunWithVersion2.png)

## Wiser now

No one raked me over the coals&mdash;in fact, my intro-to-OSS experience was thoroughly positive, and I can&#8217;t wait to do more&mdash;but I know I caused some time-consuming inconvenience to my fellow devs. I have now learned that [Binary Compatibility is not the same as Source Compatibility](http://blogs.msdn.com/b/jmstall/archive/2008/03/10/binary-vs-source-compatibility.aspx). Conflating the two is like saying, &#8220;Works on _my_ machine.&#8221; I hope this write-up can help you avoid a similar goof.

<p style="font-size:.8em; border-top: 1px solid #ccc">
  <a name="footnote1"></a><super>1</super> The nice thing about open-source projects is that everyone has the opportunity to contribute. But I had the especially good fortune to have willing help from <a href="http://lostechies.com/joshuaflanagan/">Josh Flanagan</a> in finding my way through my first OSS pull request.
</p>