---
wordpress_id: 21
title: Synchronizing UI Operations with Asynchronous Dependencies
date: 2008-05-15T02:14:21+00:00
author: Ray Houston
layout: post
wordpress_guid: /blogs/rhouston/archive/2008/05/14/synchronizing-ui-operations-with-asynchronous-dependencies.aspx
categories:
  - Uncategorized
redirect_from: "/blogs/rhouston/archive/2008/05/14/synchronizing-ui-operations-with-asynchronous-dependencies.aspx/"
---
When working with asynchronous data access such as using a Silverlight client to access data from a server side service, you will inevitably run into the situation where you have two or more calls which have results that need to be processed in a synchronous manner. A simple example is populating a list box from server side data and then making a second call to get the value that needs to be selected. You could wait until the list is populated before making the second call, but that would be a waste.

I built a little helper object that allows you to define Action delegates that will get executed in a specific order once all pending operations have completed. Below is a snippet of how it can be used.

<div>
  <pre style="padding-right: 0px;padding-left: 0px;font-size: 8pt;padding-bottom: 0px;margin: 0em;overflow: visible;width: 100%;color: black;border-top-style: none;line-height: 12pt;padding-top: 0px;font-family: consolas, 'Courier New', courier, monospace;border-right-style: none;border-left-style: none;background-color: #f4f4f4;border-bottom-style: none"><span style="color: #0000ff">private</span> ILoginService loginService;
<span style="color: #0000ff">private</span> ILoginView loginView;
<span style="color: #0000ff">private</span> OperationSync localeOpSync = 
        <span style="color: #0000ff">new</span> OperationSync(LocaleOps.GetLocales, LocaleOps.GetDefaultLocale);

<span style="color: #0000ff">private</span> <span style="color: #0000ff">void</span> PopulateLocales()
{
    loginService.GetLocales(HandleGetLocalesResult);
    loginService.GetDefaultLocale(HandleGetDefaultLocaleResult);
}

<span style="color: #0000ff">private</span> <span style="color: #0000ff">void</span> HandleGetDefaultLocaleResult(<span style="color: #0000ff">string</span> result)
{
    localeOpSync.OpCompleted(LocaleOps.GetDefaultLocale, GetSetSelectedLocaleAction(result));
}

<span style="color: #0000ff">private</span> <span style="color: #0000ff">void</span> HandleGetLocalesResult(<span style="color: #0000ff">string</span>[] result)
{
    localeOpSync.OpCompleted(LocaleOps.GetLocales, GetSetLocaleSelectionAction(result));
}

<span style="color: #0000ff">private</span> Action GetSetSelectedLocaleAction(<span style="color: #0000ff">string</span> result)
{
    <span style="color: #0000ff">return</span> () =&gt; loginView.SetSelectedLocale(result);
}

<span style="color: #0000ff">private</span> Action GetSetLocaleSelectionAction(<span style="color: #0000ff">string</span>[] result)
{
    <span style="color: #0000ff">return</span> ()=&gt; loginView.SetLocaleSelections(result);
}</pre>
</div>

<div>
  &nbsp;
</div>

<div>
  In this example, there are two asynchronous service methods which get called. Their results are passed to handler methods where they are processed by Actions, but those Actions don&#8217;t execute until both OpComplete methods have fired (actually the last OpComplete triggers the execution of all the Actions. It doesn&#8217;t matter which call returns first. Their associated Actions will execute in the order defined by the keys in the creation of the OperationSync object. There are a million different ways to put this together with lambdas and anonymous methods, but I tried to bust it up here so it would be easier to follow.
</div>

To show how it works I&#8217;ve included a subset of the unit tests (with extension methods and other goodies stripped out). The setup for all the specs is at the bottom of the code snippet.

<div>
  <pre style="padding-right: 0px;padding-left: 0px;font-size: 8pt;padding-bottom: 0px;margin: 0em;overflow: visible;width: 100%;color: black;border-top-style: none;line-height: 12pt;padding-top: 0px;font-family: consolas, 'Courier New', courier, monospace;border-right-style: none;border-left-style: none;background-color: #f4f4f4;border-bottom-style: none">[TestFixture]
<span style="color: #0000ff">public</span> <span style="color: #0000ff">class</span> when_not_completing_all_ops 
    : behaves_like_setting_up_operation_actions
{
    [Test]
    <span style="color: #0000ff">public</span> <span style="color: #0000ff">void</span> should_not_execute_actions()
    {
        OpSync.OpCompleted(OpKey.One, Action1);
        OpSync.OpCompleted(OpKey.Two, Action2);

        CollectionAssert.IsEmpty(ActionResults);
    }
}

[TestFixture]
<span style="color: #0000ff">public</span> <span style="color: #0000ff">class</span> when_completing_all_ops_in_key_order 
    : behaves_like_setting_up_operation_actions
{
    [Test]
    <span style="color: #0000ff">public</span> <span style="color: #0000ff">void</span> should_execute_actions_in_key_order()
    {
        OpSync.OpCompleted(OpKey.One, Action1);
        OpSync.OpCompleted(OpKey.Two, Action2);
        OpSync.OpCompleted(OpKey.Three, Action3);

        Assert_That_ActionResults_Fire_In_Correct_Order();
    }
}

[TestFixture]
<span style="color: #0000ff">public</span> <span style="color: #0000ff">class</span> when_completing_all_ops_not_in_key_order 
    : behaves_like_setting_up_operation_actions
{
    [Test]
    <span style="color: #0000ff">public</span> <span style="color: #0000ff">void</span> should_execute_actions_in_key_order()
    {
        OpSync.OpCompleted(OpKey.Two, Action2);
        OpSync.OpCompleted(OpKey.Three, Action3);
        OpSync.OpCompleted(OpKey.One, Action1);

        Assert_That_ActionResults_Fire_In_Correct_Order();
    }
}

<span style="color: #0000ff">public</span> <span style="color: #0000ff">abstract</span> <span style="color: #0000ff">class</span> behaves_like_setting_up_operation_actions
{
    <span style="color: #0000ff">protected</span> OperationSync OpSync { get; set; }
    <span style="color: #0000ff">protected</span> Action Action1 { get; set; }
    <span style="color: #0000ff">protected</span> Action Action2 { get; set; }
    <span style="color: #0000ff">protected</span> Action Action3 { get; set; }
    <span style="color: #0000ff">protected</span> List&lt;OpKey&gt; ActionResults { get; set; }

    [SetUp]
    <span style="color: #0000ff">public</span> <span style="color: #0000ff">void</span> Before_Each_Spec()
    {
        OpSync = <span style="color: #0000ff">new</span> OperationSync(OpKey.One, OpKey.Two, OpKey.Three);

        Action1 = () =&gt; ActionResults.Add(OpKey.One);
        Action2 = () =&gt; ActionResults.Add(OpKey.Two);
        Action3 = () =&gt; ActionResults.Add(OpKey.Three);

        ActionResults = <span style="color: #0000ff">new</span> List&lt;OpKey&gt;();
    }

    <span style="color: #0000ff">protected</span> <span style="color: #0000ff">void</span> Assert_That_ActionResults_Fire_In_Correct_Order()
    {
        Assert.That(ActionResults.Count, Is.EqualTo(3));
        Assert.That(ActionResults[0], Is.EqualTo(OpKey.One));
        Assert.That(ActionResults[1], Is.EqualTo(OpKey.Two));
        Assert.That(ActionResults[2], Is.EqualTo(OpKey.Three));
    }

    <span style="color: #0000ff">protected</span> <span style="color: #0000ff">enum</span> OpKey
    {
        One,
        Two,
        Three
    }
}
</pre>
</div>

The keys can be anything. I have just been creating a private enum in the class where I need them. Here&#8217;s the OperationSync class that handles it all:

<div>
  <pre style="padding-right: 0px;padding-left: 0px;font-size: 8pt;padding-bottom: 0px;margin: 0em;overflow: visible;width: 100%;color: black;border-top-style: none;line-height: 12pt;padding-top: 0px;font-family: consolas, 'Courier New', courier, monospace;border-right-style: none;border-left-style: none;background-color: #f4f4f4;border-bottom-style: none"><span style="color: #0000ff">public</span> <span style="color: #0000ff">class</span> OperationSync
{
    <span style="color: #0000ff">private</span> <span style="color: #0000ff">static</span> <span style="color: #0000ff">readonly</span> <span style="color: #0000ff">object</span> syncRoot = <span style="color: #0000ff">new</span> <span style="color: #0000ff">object</span>();

    <span style="color: #0000ff">private</span> <span style="color: #0000ff">readonly</span> <span style="color: #0000ff">object</span>[] keys;
    <span style="color: #0000ff">private</span> <span style="color: #0000ff">readonly</span> Dictionary&lt;<span style="color: #0000ff">object</span>, <span style="color: #0000ff">bool</span>&gt; keyKeepActionAfterExecute = 
        <span style="color: #0000ff">new</span> Dictionary&lt;<span style="color: #0000ff">object</span>, <span style="color: #0000ff">bool</span>&gt;();

    <span style="color: #0000ff">private</span> <span style="color: #0000ff">readonly</span> Dictionary&lt;<span style="color: #0000ff">object</span>, Action&gt; keyActions = 
        <span style="color: #0000ff">new</span> Dictionary&lt;<span style="color: #0000ff">object</span>, Action&gt;();

    <span style="color: #0000ff">public</span> OperationSync(<span style="color: #0000ff">params</span> <span style="color: #0000ff">object</span>[] operationKeys)
    {
        keys = operationKeys;

        <span style="color: #0000ff">foreach</span> (var o <span style="color: #0000ff">in</span> operationKeys)
        {
            keyActions.Add(o, <span style="color: #0000ff">null</span>);
        }
    }

    <span style="color: #0000ff">public</span> <span style="color: #0000ff">void</span> OpCompleted(<span style="color: #0000ff">object</span> key, Action action)
    {
        OpCompleted(key, action, <span style="color: #0000ff">false</span>);
    }

    <span style="color: #0000ff">public</span> <span style="color: #0000ff">void</span> OpCompleted(<span style="color: #0000ff">object</span> key, Action action, <span style="color: #0000ff">bool</span> keepActionAfterExecute)
    {
        <span style="color: #0000ff">lock</span> (syncRoot)
        {
            <span style="color: #0000ff">if</span> (!keyActions.ContainsKey(key))
                <span style="color: #0000ff">throw</span> <span style="color: #0000ff">new</span> UIException(<span style="color: #006080">"Key '{0}' not found."</span>);

            keyActions[key] = action;
            keyKeepActionAfterExecute[key] = keepActionAfterExecute;

            <span style="color: #0000ff">if</span> (AllOpsComplete())
                ProcessActions();
        }
    }

    <span style="color: #0000ff">private</span> <span style="color: #0000ff">void</span> ProcessActions()
    {
        ExecuteEachAction();

        ClearActionsIfIndicated();
    }

    <span style="color: #0000ff">private</span> <span style="color: #0000ff">void</span> ExecuteEachAction()
    {
        <span style="color: #0000ff">foreach</span> (var key <span style="color: #0000ff">in</span> keys)
        {
            keyActions[key]();
        }
    }

    <span style="color: #0000ff">private</span> <span style="color: #0000ff">void</span> ClearActionsIfIndicated()
    {
        <span style="color: #0000ff">foreach</span> (var key <span style="color: #0000ff">in</span> keys)
        {
            <span style="color: #0000ff">if</span> (!keyKeepActionAfterExecute[key])
                keyActions[key] = <span style="color: #0000ff">null</span>;
        }
    }

    <span style="color: #0000ff">private</span> <span style="color: #0000ff">bool</span> AllOpsComplete()
    {
        <span style="color: #0000ff">return</span> keyActions.All(pair =&gt; pair.Value != <span style="color: #0000ff">null</span>);
    }
}
</pre>
</div>

There&#8217;s probably a fancy smancy AJAX pattern name for this sort of thing. Let me know if you come across one.

<div class="wlWriterSmartContent" style="padding-right: 0px;padding-left: 0px;padding-bottom: 0px;margin: 0px;padding-top: 0px">
  Technorati Tags: <a href="http://technorati.com/tags/C#" rel="tag">C#</a>,<a href="http://technorati.com/tags/Silverlight" rel="tag">Silverlight</a>,<a href="http://technorati.com/tags/AJAX" rel="tag">AJAX</a>,<a href="http://technorati.com/tags/UI" rel="tag">UI</a>
</div>