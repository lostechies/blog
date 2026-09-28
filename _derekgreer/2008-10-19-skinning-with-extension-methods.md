---
wordpress_id: 455
title: Skinning with Extension Methods
date: 2008-10-19T17:56:00+00:00
author: Derek Greer
layout: post
wordpress_guid: http://www.aspiringcraftsman.com/2008/10/skinning-with-extension-methods/
dsq_thread_id:
  - "315805881"
categories:
  - Uncategorized
tags:
  - ExtensionMethods
---
## Introduction

One of the new language features introduced with C# 3.0 and Visual Basic.Net 9.0 is [Extension Methods](http://en.wikipedia.org/wiki/Extension_method). Extension methods enable new behaviors to be invoked on otherwise closed types. One application of extension methods that will be discussed here is their use in class library development for enabling multiple styles of interfaces for components. This might be thought of as “skinning” an API.

## Extension Methods Overview

Extension methods are a [syntactic sugar](http://en.wikipedia.org/wiki/Syntax_sugar) approach to enabling the adornment of new behaviors on existing types without requiring the type to be modified or sub-classed. Their use enables coding the invocation of an extension method as if it were a member of the extended type. This is achieved by providing a static method whose first parameter is of the type to be extended, specified with the <span style="color: #3366ff">this </span>modifier. The following is a simple example of an extension method which provides a Reverse() method for System.String:

<pre class="brush:csharp">using System;
using System.Text;

namespace ExtensionMethodConsoleApplication
{
    class Program
    {
        static void Main(string[] args)
        {
            string testString = "This is a test.";
            Console.WriteLine(testString.Reverse());
            Console.ReadLine();
        }
    }

    public static class StringExtensions
    {
        public static String Reverse(this string s)
        {
            var sb = new StringBuilder();

            for (int i = s.Length; i &gt; 0; i--)
            {
                sb.Append(s[i - 1]);
            }

            return sb.ToString();
        }
    }
}
</pre>

Once compiled, this call to string.Reverse() is converted to an invocation of the static Reverse() method with the string instance passed as the first parameter. The following output of ildasm.exe shows the generated code:

<pre class="brush:csharp">.method private hidebysig static void  Main(string[] args) cil managed

  {

    .entrypoint

   // Code size       26 (0x1a)

    .maxstack  1

    .locals init ([0] string testString)

    IL_0000:  nop

    IL_0001:  ldstr      "This is a test."

    IL_0006:  stloc.0

    IL_0007:  ldloc.0

    IL_0008:  call       string ExtensionMethodConsoleApplication.StringExtensions::Reverse(string)

    IL_000d:  call       void [mscorlib]System.Console::WriteLine(string)

    IL_0012:  nop

    IL_0013:  call       string [mscorlib]System.Console::ReadLine()

    IL_0018:  pop

    IL_0019:  ret

  } // end of method Program::Main
</pre>

## Class Library Skins

Class libraries are typically developed to segment a specific set of cohesive behaviors within an application, and are often created for use by multiple consumers. In some cases, the nature of a class library may lend itself to decoupling the consumer API from the interface and behavior implementation, allowing multiple API styles to exist for the same component.

Consider, for example, a class library which contains no inherent behavior of its own, but exists solely for providing a common API which abstracts a choice from among multiple class libraries designed for the same purpose. This is often required within application frameworks needing to provide a common infrastructure while remaining loosely coupled to the specific infrastructure implementation choice.

The usual approach for providing an abstraction API is simply for the author to choose an API style which suites their own tastes. This may be dissimilar to any specific class library, but will sometimes result in an API modeled after the author&#8217;s favored implementation choice &#8230; perhaps to the dismay of those required to consume the API. When the behavior of the class library can be represented fairly concisely, but requires a fair amount of convenience methods to make the API palatable, this presents an excellent opportunity to utilize extension methods to provide API &#8220;skins&#8221;.

For example, consider the common task of logging. For .Net development, there exists several logging APIs to choose from in addition to the native tracing API. Two popular libraries are Log4Net and the Enterprise Library Logging Application Block. While both libraries provide similar features, the APIs provided by each are stylistically very different. Log4Net supplies
  
an API which provides different methods for each message severity type (e.g. Log.Error(&#8230;), Log.Fatal(&#8230;)) while the Logging Application Block provides a number of overloaded Write() methods which follow the Microsoft method naming guidelines whereby verbs are used to name methods.

One approach to providing a concise façade that will accommodate both libraries without choosing one style over another would be to encapsulate the information of each log message into a single type (e.g. an ILogEntry) and to provide an interface which exposes a single Write() method which takes an ILogEntry as its single parameter:

<pre class="brush:csharp">public interface ILoggingService
    {
        void Write(ILogEntry log);
    }

    public interface ILogEntry
    {
        Guid ActivityId { get; set; }
        string AppDomainName { get; set; }
        ICollection&lt;string&gt; Categories { get; set; }
        string Message { get; set; }
        int Priority { get; set; }
        string ProcessId { get; set; }
        string ProcessName { get; set; }
        TraceEventType Severity { get; set; }
        DateTime TimeStamp { get; set; }

        // ... other properties and methods
    }
</pre>

In fairness, this approach does reflect some of characteristics of the Logging Application Block API, as the methods on its Static Logger façade similarly result in a call to a LogWriter.Write(LogEntry entry) method. Nevertheless, following this example of encapsulating the information about a log message into a single type greatly simplifies the interface, resulting in less demands being placed on implementers and allowing extension methods to provide variability in how the service is exercised.

With the ILoggingService defined, two sets of extension methods matching both the Logging Application Block and the Log4Net APIs may be defined, providing the usual set of methods familiar to proponents of each:

<pre class="brush:csharp">public static class EntLibLogServiceExtensions

    {
        public static void Write(this ILoggingService loggingService, object message)
        {
            // ...
        }

        public static void Write(this ILoggingService loggingService, object message, string category)
        {
            // ...
        }

        public static void Write(this ILoggingService loggingService, object message, string category, int priority,
                                 int eventId, TraceEventType severity)
        {
            // ...
        }

        // ... TODO implement remainng Logging Application Block API
    }

    public static class Log4NetLogServiceExtensions
    {
        public static void Debug(this ILoggingService loggingService, object message)
        {
            // ...
        }

        public static void Error(this ILoggingService loggingService, object message)
        {
            // ...
        }

        public static void Fatal(this ILoggingService loggingService, object message)
        {
            // ...
        }

        // ... TODO implement remainng Log4Net API
    }
</pre>

By ensuring each collection of extension methods are scoped in their own namespace, consumers are also free to choose which API style is exposed through the IDE&#8217;s intellisense.

## Conclusion

While the use of extension methods should be used judiciously in general, and their use for providing themed-APIs will certainly not be appropriate in most cases, this feature does provide a nice &#8220;specialty tool&#8221; in the toolbox of class library designers.
