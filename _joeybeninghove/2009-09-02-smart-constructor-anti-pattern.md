---
wordpress_id: 66
title: Smart Constructor Anti-Pattern
date: 2009-09-02T04:46:00+00:00
author: Joey Beninghove
layout: post
wordpress_guid: /blogs/joeydotnet/archive/2009/09/02/smart-constructor-anti-pattern.aspx
categories:
  - 'c# patterns mvp'
redirect_from: "/blogs/joeydotnet/archive/2009/09/02/smart-constructor-anti-pattern.aspx/"
---
If you look at the <a href="http://en.wikipedia.org/wiki/Constructor_(computer_science)" target="_blank">definition of a constructor</a> in the context of software development on Wikipedia (a completely factual and reliable source :), you&#8217;ll find this simple statement of their responsibility&#8230; 

> "Their responsibility is to initialize the object&#8217;s data members and to establish the invariant of the class, failing if the invariant isn&#8217;t valid." 

Simple really.&#160; Just initialize the (usually) private data members and ensure the arguments won&#8217;t put the object in an invalid state.&#160; But so often I see constructors doing so much more than that.&#160; One example I&#8217;ve seen of this recently is in presenters. 

The (perhaps contrived) scenario:   
When a view loads for the first time, you need to load some lookup data that gets populated in a combo box on the view and set the number of logged in users on the view.

Here is our IView interface for reference:

<div>
  <div>
    <pre><span style="color: #606060">   1:</span> <span style="color: #0000ff">public</span> <span style="color: #0000ff">interface</span> IView</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">   2:</span> {</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">   3:</span>     <span style="color: #0000ff">void</span> BindWith(IEnumerable&lt;User&gt; users);</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">   4:</span>     <span style="color: #0000ff">bool</span> HasUserSelected { get; }</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">   5:</span>     <span style="color: #0000ff">void</span> SetNumberOfLoggedInUsersTo(<span style="color: #0000ff">int</span> numberOfUsers);</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">   6:</span> }</pre>
    
    <p>
      <!--CRLF--></div> </div> 
      
      <h3>
        “Smart” Constructor Approach
      </h3>
      
      <p>
        One might be tempted to start writing a spec like the one below.
      </p>
      
      <div>
        <div>
          <pre><span style="color: #606060">   1:</span> <span style="color: #0000ff">public</span> <span style="color: #0000ff">class</span> SmartConstructorPresenterSpecs</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">   2:</span> {</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">   3:</span>     <span style="color: #0000ff">public</span> <span style="color: #0000ff">class</span> when_the_presenter_is_constructed : ContextSpecification</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">   4:</span>     {</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">   5:</span>         <span style="color: #0000ff">private</span> IView View;</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">   6:</span>         <span style="color: #0000ff">private</span> IUserRepository UserRepository;</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">   7:</span>         <span style="color: #0000ff">private</span> IAuthenticationService AuthenticationService;</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">   8:</span>         <span style="color: #0000ff">private</span> SmartConstructorPresenter SUT;</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">   9:</span>         <span style="color: #0000ff">private</span> IEnumerable&lt;User&gt; Users;</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">  10:</span>&#160; </pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">  11:</span>         <span style="color: #0000ff">protected</span> <span style="color: #0000ff">override</span> <span style="color: #0000ff">void</span> When()</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">  12:</span>         {</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">  13:</span>             Users = <span style="color: #0000ff">new</span> List&lt;User&gt; {<span style="color: #0000ff">new</span> User(<span style="color: #0000ff">true</span>), <span style="color: #0000ff">new</span> User(<span style="color: #0000ff">true</span>), <span style="color: #0000ff">new</span> User(<span style="color: #0000ff">false</span>)};</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">  14:</span>&#160; </pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">  15:</span>             View = Mock&lt;IView&gt;();</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">  16:</span>             UserRepository = Mock&lt;IUserRepository&gt;();</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">  17:</span>             AuthenticationService = Mock&lt;IAuthenticationService&gt;();</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">  18:</span>&#160; </pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">  19:</span>             UserRepository.Stub(x =&gt; x.All()).Return(Users);</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">  20:</span>&#160; </pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">  21:</span>             SUT = <span style="color: #0000ff">new</span> SmartConstructorPresenter(View, UserRepository, AuthenticationService);</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">  22:</span>         }</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">  23:</span>&#160; </pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">  24:</span>         [Test]</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">  25:</span>         <span style="color: #0000ff">public</span> <span style="color: #0000ff">void</span> it_should_populate_the_view_with_a_list_of_users()</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">  26:</span>         {</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">  27:</span>             View.AssertWasCalled(x =&gt; x.BindWith(Users));</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">  28:</span>         }</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">  29:</span>&#160; </pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">  30:</span>         [Test]</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">  31:</span>         <span style="color: #0000ff">public</span> <span style="color: #0000ff">void</span> it_should_set_the_number_of_logged_in_users_on_the_view()</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">  32:</span>         {</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">  33:</span>             View.AssertWasCalled(x =&gt; x.SetNumberOfLoggedInUsersTo(2));</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">  34:</span>         }</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">  35:</span>     }</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">  36:</span>&#160; </pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">  37:</span>     <span style="color: #0000ff">public</span> <span style="color: #0000ff">class</span> when_attempting_to_login_and_a_user_is_not_selected : ContextSpecification</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">  38:</span>     {</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">  39:</span>         <span style="color: #0000ff">private</span> IView View;</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">  40:</span>         <span style="color: #0000ff">private</span> IUserRepository UserRepository;</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">  41:</span>         <span style="color: #0000ff">private</span> IAuthenticationService AuthenticationService;</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">  42:</span>         <span style="color: #0000ff">private</span> SmartConstructorPresenter SUT;</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">  43:</span>         <span style="color: #0000ff">private</span> IEnumerable&lt;User&gt; Users;</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">  44:</span>&#160; </pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">  45:</span>         <span style="color: #0000ff">protected</span> <span style="color: #0000ff">override</span> <span style="color: #0000ff">void</span> EstablishContext()</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">  46:</span>         {</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">  47:</span>             Users = <span style="color: #0000ff">new</span> List&lt;User&gt; {<span style="color: #0000ff">new</span> User(<span style="color: #0000ff">true</span>), <span style="color: #0000ff">new</span> User(<span style="color: #0000ff">true</span>), <span style="color: #0000ff">new</span> User(<span style="color: #0000ff">false</span>)};</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">  48:</span>&#160; </pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">  49:</span>             View = Mock&lt;IView&gt;();</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">  50:</span>             UserRepository = Mock&lt;IUserRepository&gt;();</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">  51:</span>             AuthenticationService = Mock&lt;IAuthenticationService&gt;();</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">  52:</span>&#160; </pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">  53:</span>             UserRepository.Stub(x =&gt; x.All()).Return(Users);</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">  54:</span>             View.Stub(x =&gt; x.HasUserSelected).Return(<span style="color: #0000ff">false</span>);</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">  55:</span>&#160; </pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">  56:</span>             SUT = <span style="color: #0000ff">new</span> SmartConstructorPresenter(View, UserRepository, AuthenticationService);</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">  57:</span>         }</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">  58:</span>&#160; </pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">  59:</span>         <span style="color: #0000ff">protected</span> <span style="color: #0000ff">override</span> <span style="color: #0000ff">void</span> When()</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">  60:</span>         {</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">  61:</span>             SUT.Login();</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">  62:</span>         }</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">  63:</span>&#160; </pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">  64:</span>         [Test]</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">  65:</span>         <span style="color: #0000ff">public</span> <span style="color: #0000ff">void</span> it_should_NOT_perform_a_login()</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">  66:</span>         {</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">  67:</span>             AuthenticationService.AssertWasNotCalled(x =&gt; x.Login());</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">  68:</span>         }</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">  69:</span>     }</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">  70:</span> }</pre>
          
          <p>
            <!--CRLF--></div> </div> 
            
            <p>
              And implement the presenter.
            </p>
            
            <div>
              <div>
                <pre><span style="color: #606060">   1:</span> <span style="color: #0000ff">public</span> <span style="color: #0000ff">class</span> SmartConstructorPresenter</pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre><span style="color: #606060">   2:</span> {</pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre><span style="color: #606060">   3:</span>     <span style="color: #0000ff">private</span> <span style="color: #0000ff">readonly</span> IView view;</pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre><span style="color: #606060">   4:</span>     <span style="color: #0000ff">private</span> <span style="color: #0000ff">readonly</span> IAuthenticationService authenticationService;</pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre><span style="color: #606060">   5:</span>&#160; </pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre><span style="color: #606060">   6:</span>     <span style="color: #0000ff">public</span> SmartConstructorPresenter(IView view, IUserRepository userRepository,</pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre><span style="color: #606060">   7:</span>                                      IAuthenticationService authenticationService)</pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre><span style="color: #606060">   8:</span>     {</pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre><span style="color: #606060">   9:</span>         <span style="color: #0000ff">this</span>.view = view;</pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre><span style="color: #606060">  10:</span>         <span style="color: #0000ff">this</span>.authenticationService = authenticationService;</pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre><span style="color: #606060">  11:</span>&#160; </pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre><span style="color: #606060">  12:</span>         var users = userRepository.All();</pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre><span style="color: #606060">  13:</span>&#160; </pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre><span style="color: #606060">  14:</span>         <span style="color: #0000ff">this</span>.view.BindWith(users);</pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre><span style="color: #606060">  15:</span>         <span style="color: #0000ff">this</span>.view.SetNumberOfLoggedInUsersTo(users.Where(x =&gt; x.IsLoggedIn).Count());</pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre><span style="color: #606060">  16:</span>     }</pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre><span style="color: #606060">  17:</span>&#160; </pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre><span style="color: #606060">  18:</span>     <span style="color: #0000ff">public</span> <span style="color: #0000ff">void</span> Login()</pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre><span style="color: #606060">  19:</span>     {</pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre><span style="color: #606060">  20:</span>         <span style="color: #0000ff">if</span> (view.HasUserSelected)</pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre><span style="color: #606060">  21:</span>             authenticationService.Login();</pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre><span style="color: #606060">  22:</span>     }</pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre><span style="color: #606060">  23:</span> }</pre>
                
                <p>
                  <!--CRLF--></div> </div> 
                  
                  <p>
                    And then the view.
                  </p>
                  
                  <div>
                    <div>
                      <pre><span style="color: #606060">   1:</span> <span style="color: #0000ff">public</span> <span style="color: #0000ff">class</span> View : IView</pre>
                      
                      <p>
                        <!--CRLF-->
                      </p>
                      
                      <pre><span style="color: #606060">   2:</span> {</pre>
                      
                      <p>
                        <!--CRLF-->
                      </p>
                      
                      <pre><span style="color: #606060">   3:</span>     <span style="color: #0000ff">private</span> <span style="color: #0000ff">event</span> VoidHandler loginButtonClick = <span style="color: #0000ff">delegate</span> { };</pre>
                      
                      <p>
                        <!--CRLF-->
                      </p>
                      
                      <pre><span style="color: #606060">   4:</span>     <span style="color: #0000ff">private</span> <span style="color: #0000ff">readonly</span> SmartConstructorPresenter presenter;</pre>
                      
                      <p>
                        <!--CRLF-->
                      </p>
                      
                      <pre><span style="color: #606060">   5:</span>&#160; </pre>
                      
                      <p>
                        <!--CRLF-->
                      </p>
                      
                      <pre><span style="color: #606060">   6:</span>     <span style="color: #0000ff">public</span> View()</pre>
                      
                      <p>
                        <!--CRLF-->
                      </p>
                      
                      <pre><span style="color: #606060">   7:</span>     {</pre>
                      
                      <p>
                        <!--CRLF-->
                      </p>
                      
                      <pre><span style="color: #606060">   8:</span>         presenter = <span style="color: #0000ff">new</span> SmartConstructorPresenter(<span style="color: #0000ff">this</span>, <span style="color: #0000ff">null</span>, <span style="color: #0000ff">null</span>);</pre>
                      
                      <p>
                        <!--CRLF-->
                      </p>
                      
                      <pre><span style="color: #606060">   9:</span>&#160; </pre>
                      
                      <p>
                        <!--CRLF-->
                      </p>
                      
                      <pre><span style="color: #606060">  10:</span>         <span style="color: #008000">// simulate a possible login button click</span></pre>
                      
                      <p>
                        <!--CRLF-->
                      </p>
                      
                      <pre><span style="color: #606060">  11:</span>         loginButtonClick += () =&gt; presenter.Login();</pre>
                      
                      <p>
                        <!--CRLF-->
                      </p>
                      
                      <pre><span style="color: #606060">  12:</span>     }</pre>
                      
                      <p>
                        <!--CRLF-->
                      </p>
                      
                      <pre><span style="color: #606060">  13:</span>&#160; </pre>
                      
                      <p>
                        <!--CRLF-->
                      </p>
                      
                      <pre><span style="color: #606060">  14:</span>     <span style="color: #0000ff">public</span> <span style="color: #0000ff">void</span> BindWith(IEnumerable&lt;User&gt; users)</pre>
                      
                      <p>
                        <!--CRLF-->
                      </p>
                      
                      <pre><span style="color: #606060">  15:</span>     {</pre>
                      
                      <p>
                        <!--CRLF-->
                      </p>
                      
                      <pre><span style="color: #606060">  16:</span>         <span style="color: #008000">// bind this stuff to something</span></pre>
                      
                      <p>
                        <!--CRLF-->
                      </p>
                      
                      <pre><span style="color: #606060">  17:</span>     }</pre>
                      
                      <p>
                        <!--CRLF-->
                      </p>
                      
                      <pre><span style="color: #606060">  18:</span>&#160; </pre>
                      
                      <p>
                        <!--CRLF-->
                      </p>
                      
                      <pre><span style="color: #606060">  19:</span>     <span style="color: #0000ff">public</span> <span style="color: #0000ff">bool</span> HasUserSelected</pre>
                      
                      <p>
                        <!--CRLF-->
                      </p>
                      
                      <pre><span style="color: #606060">  20:</span>     {</pre>
                      
                      <p>
                        <!--CRLF-->
                      </p>
                      
                      <pre><span style="color: #606060">  21:</span>         get { <span style="color: #0000ff">return</span> <span style="color: #0000ff">false</span>; }</pre>
                      
                      <p>
                        <!--CRLF-->
                      </p>
                      
                      <pre><span style="color: #606060">  22:</span>     }</pre>
                      
                      <p>
                        <!--CRLF-->
                      </p>
                      
                      <pre><span style="color: #606060">  23:</span>&#160; </pre>
                      
                      <p>
                        <!--CRLF-->
                      </p>
                      
                      <pre><span style="color: #606060">  24:</span>     <span style="color: #0000ff">public</span> <span style="color: #0000ff">void</span> SetNumberOfLoggedInUsersTo(<span style="color: #0000ff">int</span> numberOfUsers)</pre>
                      
                      <p>
                        <!--CRLF-->
                      </p>
                      
                      <pre><span style="color: #606060">  25:</span>     {</pre>
                      
                      <p>
                        <!--CRLF-->
                      </p>
                      
                      <pre><span style="color: #606060">  26:</span>         <span style="color: #008000">// set some label or something</span></pre>
                      
                      <p>
                        <!--CRLF-->
                      </p>
                      
                      <pre><span style="color: #606060">  27:</span>     }</pre>
                      
                      <p>
                        <!--CRLF-->
                      </p>
                      
                      <pre><span style="color: #606060">  28:</span> }</pre>
                      
                      <p>
                        <!--CRLF-->
                      </p>
                      
                      <pre><span style="color: #606060">  29:</span>&#160; </pre>
                      
                      <p>
                        <!--CRLF-->
                      </p>
                      
                      <pre><span style="color: #606060">  30:</span> <span style="color: #0000ff">public</span> <span style="color: #0000ff">delegate</span> <span style="color: #0000ff">void</span> VoidHandler();</pre>
                      
                      <p>
                        <!--CRLF--></div> </div> 
                        
                        <p>
                          If you take a look at the code above, you can see that a the view is being populated with a list of users when the presenter is <strong>constructed</strong>.&#160; While this might seem harmless at first, take a look at the second specification : <strong>when_attempting_to_login_and_a_user_is_not_selected.it_should_NOT_perform_a_login</strong>.
                        </p>
                        
                        <p>
                          Notice that the only thing we care about is verifying that when a user is not selected, that we’re NOT attempting to call login on the authentication service.&#160; But since our constructor has some “smarts”, we’re required to stub out the call to the user repository just to keep the test from breaking.&#160; This may not look like a big deal in a simple case like this.&#160; But as your codebase grows, it can make your specs brittle and harder to understand.
                        </p>
                        
                        <h3>
                          “Dumb” Constructor Approach
                        </h3>
                        
                        <p>
                          Another way this could be done is by delegating the initial operations on the view to an explicit “initialize” method.&#160; Let’s see what that might look like.
                        </p>
                        
                        <p>
                          First the specs of course.&#160; 🙂
                        </p>
                        
                        <div>
                          <div>
                            <pre><span style="color: #606060">   1:</span> <span style="color: #0000ff">public</span> <span style="color: #0000ff">class</span> DumbConstructorPresenterSpecs</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060">   2:</span> {</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060">   3:</span>     <span style="color: #0000ff">public</span> <span style="color: #0000ff">class</span> when_initializing : ContextSpecification</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060">   4:</span>     {</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060">   5:</span>         <span style="color: #0000ff">private</span> IView View;</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060">   6:</span>         <span style="color: #0000ff">private</span> IUserRepository UserRepository;</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060">   7:</span>         <span style="color: #0000ff">private</span> IAuthenticationService AuthenticationService;</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060">   8:</span>         <span style="color: #0000ff">private</span> DumbConstructorPresenter SUT;</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060">   9:</span>         <span style="color: #0000ff">private</span> IEnumerable&lt;User&gt; Users;</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060">  10:</span>&#160; </pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060">  11:</span>         <span style="color: #0000ff">protected</span> <span style="color: #0000ff">override</span> <span style="color: #0000ff">void</span> EstablishContext()</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060">  12:</span>         {</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060">  13:</span>             View = Mock&lt;IView&gt;();</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060">  14:</span>             UserRepository = Mock&lt;IUserRepository&gt;();</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060">  15:</span>             AuthenticationService = Mock&lt;IAuthenticationService&gt;();</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060">  16:</span>&#160; </pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060">  17:</span>             SUT = <span style="color: #0000ff">new</span> DumbConstructorPresenter(View, UserRepository, AuthenticationService);</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060">  18:</span>         }</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060">  19:</span>&#160; </pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060">  20:</span>         <span style="color: #0000ff">protected</span> <span style="color: #0000ff">override</span> <span style="color: #0000ff">void</span> When()</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060">  21:</span>         {</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060">  22:</span>             Users = <span style="color: #0000ff">new</span> List&lt;User&gt; {<span style="color: #0000ff">new</span> User(<span style="color: #0000ff">true</span>), <span style="color: #0000ff">new</span> User(<span style="color: #0000ff">true</span>), <span style="color: #0000ff">new</span> User(<span style="color: #0000ff">false</span>)};</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060">  23:</span>&#160; </pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060">  24:</span>             UserRepository.Stub(x =&gt; x.All()).Return(Users);</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060">  25:</span>&#160; </pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060">  26:</span>             SUT.Initialize();</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060">  27:</span>         }</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060">  28:</span>&#160; </pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060">  29:</span>         [Test]</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060">  30:</span>         <span style="color: #0000ff">public</span> <span style="color: #0000ff">void</span> it_should_populate_the_view_with_a_list_of_users()</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060">  31:</span>         {</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060">  32:</span>             View.AssertWasCalled(x =&gt; x.BindWith(Users));</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060">  33:</span>         }</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060">  34:</span>&#160; </pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060">  35:</span>         [Test]</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060">  36:</span>         <span style="color: #0000ff">public</span> <span style="color: #0000ff">void</span> it_should_set_the_number_of_logged_in_users_on_the_view()</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060">  37:</span>         {</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060">  38:</span>             View.AssertWasCalled(x =&gt; x.SetNumberOfLoggedInUsersTo(2));</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060">  39:</span>         }</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060">  40:</span>     }</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060">  41:</span>&#160; </pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060">  42:</span>     <span style="color: #0000ff">public</span> <span style="color: #0000ff">class</span> when_attempting_to_login_and_a_user_is_not_selected : ContextSpecification</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060">  43:</span>     {</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060">  44:</span>         <span style="color: #0000ff">private</span> IView View;</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060">  45:</span>         <span style="color: #0000ff">private</span> IUserRepository UserRepository;</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060">  46:</span>         <span style="color: #0000ff">private</span> IAuthenticationService AuthenticationService;</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060">  47:</span>         <span style="color: #0000ff">private</span> DumbConstructorPresenter SUT;</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060">  48:</span>&#160; </pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060">  49:</span>         <span style="color: #0000ff">protected</span> <span style="color: #0000ff">override</span> <span style="color: #0000ff">void</span> EstablishContext()</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060">  50:</span>         {</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060">  51:</span>             View = Mock&lt;IView&gt;();</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060">  52:</span>             UserRepository = Mock&lt;IUserRepository&gt;();</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060">  53:</span>             AuthenticationService = Mock&lt;IAuthenticationService&gt;();</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060">  54:</span>&#160; </pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060">  55:</span>             SUT = <span style="color: #0000ff">new</span> DumbConstructorPresenter(View, UserRepository, AuthenticationService);</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060">  56:</span>         }</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060">  57:</span>&#160; </pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060">  58:</span>         <span style="color: #0000ff">protected</span> <span style="color: #0000ff">override</span> <span style="color: #0000ff">void</span> When()</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060">  59:</span>         {</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060">  60:</span>             View.Stub(x =&gt; x.HasUserSelected).Return(<span style="color: #0000ff">false</span>);</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060">  61:</span>&#160; </pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060">  62:</span>             SUT.Login();</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060">  63:</span>         }</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060">  64:</span>&#160; </pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060">  65:</span>         [Test]</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060">  66:</span>         <span style="color: #0000ff">public</span> <span style="color: #0000ff">void</span> it_should_NOT_perform_a_login()</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060">  67:</span>         {</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060">  68:</span>             AuthenticationService.AssertWasNotCalled(x =&gt; x.Login());</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060">  69:</span>         }</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060">  70:</span>     }</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060">  71:</span> }</pre>
                            
                            <p>
                              <!--CRLF--></div> </div> 
                              
                              <p>
                                Then the implementation of the presenter.
                              </p>
                              
                              <div>
                                <div>
                                  <pre><span style="color: #606060">   1:</span> <span style="color: #0000ff">public</span> <span style="color: #0000ff">class</span> DumbConstructorPresenter</pre>
                                  
                                  <p>
                                    <!--CRLF-->
                                  </p>
                                  
                                  <pre><span style="color: #606060">   2:</span> {</pre>
                                  
                                  <p>
                                    <!--CRLF-->
                                  </p>
                                  
                                  <pre><span style="color: #606060">   3:</span>     <span style="color: #0000ff">private</span> <span style="color: #0000ff">readonly</span> IView view;</pre>
                                  
                                  <p>
                                    <!--CRLF-->
                                  </p>
                                  
                                  <pre><span style="color: #606060">   4:</span>     <span style="color: #0000ff">private</span> <span style="color: #0000ff">readonly</span> IUserRepository userRepository;</pre>
                                  
                                  <p>
                                    <!--CRLF-->
                                  </p>
                                  
                                  <pre><span style="color: #606060">   5:</span>     <span style="color: #0000ff">private</span> <span style="color: #0000ff">readonly</span> IAuthenticationService authenticationService;</pre>
                                  
                                  <p>
                                    <!--CRLF-->
                                  </p>
                                  
                                  <pre><span style="color: #606060">   6:</span>&#160; </pre>
                                  
                                  <p>
                                    <!--CRLF-->
                                  </p>
                                  
                                  <pre><span style="color: #606060">   7:</span>     <span style="color: #0000ff">public</span> DumbConstructorPresenter(IView view, IUserRepository userRepository,</pre>
                                  
                                  <p>
                                    <!--CRLF-->
                                  </p>
                                  
                                  <pre><span style="color: #606060">   8:</span>                                     IAuthenticationService authenticationService)</pre>
                                  
                                  <p>
                                    <!--CRLF-->
                                  </p>
                                  
                                  <pre><span style="color: #606060">   9:</span>     {</pre>
                                  
                                  <p>
                                    <!--CRLF-->
                                  </p>
                                  
                                  <pre><span style="color: #606060">  10:</span>         <span style="color: #0000ff">this</span>.view = view;</pre>
                                  
                                  <p>
                                    <!--CRLF-->
                                  </p>
                                  
                                  <pre><span style="color: #606060">  11:</span>         <span style="color: #0000ff">this</span>.userRepository = userRepository;</pre>
                                  
                                  <p>
                                    <!--CRLF-->
                                  </p>
                                  
                                  <pre><span style="color: #606060">  12:</span>         <span style="color: #0000ff">this</span>.authenticationService = authenticationService;</pre>
                                  
                                  <p>
                                    <!--CRLF-->
                                  </p>
                                  
                                  <pre><span style="color: #606060">  13:</span>     }</pre>
                                  
                                  <p>
                                    <!--CRLF-->
                                  </p>
                                  
                                  <pre><span style="color: #606060">  14:</span>&#160; </pre>
                                  
                                  <p>
                                    <!--CRLF-->
                                  </p>
                                  
                                  <pre><span style="color: #606060">  15:</span>     <span style="color: #0000ff">public</span> <span style="color: #0000ff">void</span> Initialize()</pre>
                                  
                                  <p>
                                    <!--CRLF-->
                                  </p>
                                  
                                  <pre><span style="color: #606060">  16:</span>     {</pre>
                                  
                                  <p>
                                    <!--CRLF-->
                                  </p>
                                  
                                  <pre><span style="color: #606060">  17:</span>         var users = userRepository.All();</pre>
                                  
                                  <p>
                                    <!--CRLF-->
                                  </p>
                                  
                                  <pre><span style="color: #606060">  18:</span>&#160; </pre>
                                  
                                  <p>
                                    <!--CRLF-->
                                  </p>
                                  
                                  <pre><span style="color: #606060">  19:</span>         view.BindWith(users);</pre>
                                  
                                  <p>
                                    <!--CRLF-->
                                  </p>
                                  
                                  <pre><span style="color: #606060">  20:</span>         view.SetNumberOfLoggedInUsersTo(users.Where(x =&gt; x.IsLoggedIn).Count());</pre>
                                  
                                  <p>
                                    <!--CRLF-->
                                  </p>
                                  
                                  <pre><span style="color: #606060">  21:</span>     }</pre>
                                  
                                  <p>
                                    <!--CRLF-->
                                  </p>
                                  
                                  <pre><span style="color: #606060">  22:</span>&#160; </pre>
                                  
                                  <p>
                                    <!--CRLF-->
                                  </p>
                                  
                                  <pre><span style="color: #606060">  23:</span>     <span style="color: #0000ff">public</span> <span style="color: #0000ff">void</span> Login()</pre>
                                  
                                  <p>
                                    <!--CRLF-->
                                  </p>
                                  
                                  <pre><span style="color: #606060">  24:</span>     {</pre>
                                  
                                  <p>
                                    <!--CRLF-->
                                  </p>
                                  
                                  <pre><span style="color: #606060">  25:</span>         <span style="color: #0000ff">if</span> (view.HasUserSelected)</pre>
                                  
                                  <p>
                                    <!--CRLF-->
                                  </p>
                                  
                                  <pre><span style="color: #606060">  26:</span>             authenticationService.Login();</pre>
                                  
                                  <p>
                                    <!--CRLF-->
                                  </p>
                                  
                                  <pre><span style="color: #606060">  27:</span>     }</pre>
                                  
                                  <p>
                                    <!--CRLF-->
                                  </p>
                                  
                                  <pre><span style="color: #606060">  28:</span> }</pre>
                                  
                                  <p>
                                    <!--CRLF--></div> </div> 
                                    
                                    <p>
                                      And a slight change to the view implementation.
                                    </p>
                                    
                                    <div>
                                      <div>
                                        <pre><span style="color: #606060">   1:</span> <span style="color: #0000ff">public</span> <span style="color: #0000ff">class</span> View : IView</pre>
                                        
                                        <p>
                                          <!--CRLF-->
                                        </p>
                                        
                                        <pre><span style="color: #606060">   2:</span> {</pre>
                                        
                                        <p>
                                          <!--CRLF-->
                                        </p>
                                        
                                        <pre><span style="color: #606060">   3:</span>     <span style="color: #0000ff">private</span> <span style="color: #0000ff">event</span> VoidHandler loginButtonClick = <span style="color: #0000ff">delegate</span> { };</pre>
                                        
                                        <p>
                                          <!--CRLF-->
                                        </p>
                                        
                                        <pre><span style="color: #606060">   4:</span>     <span style="color: #0000ff">private</span> <span style="color: #0000ff">event</span> VoidHandler load = <span style="color: #0000ff">delegate</span> { };</pre>
                                        
                                        <p>
                                          <!--CRLF-->
                                        </p>
                                        
                                        <pre><span style="color: #606060">   5:</span>     <span style="color: #0000ff">private</span> <span style="color: #0000ff">readonly</span> DumbConstructorPresenter presenter;</pre>
                                        
                                        <p>
                                          <!--CRLF-->
                                        </p>
                                        
                                        <pre><span style="color: #606060">   6:</span>&#160; </pre>
                                        
                                        <p>
                                          <!--CRLF-->
                                        </p>
                                        
                                        <pre><span style="color: #606060">   7:</span>     <span style="color: #0000ff">public</span> View()</pre>
                                        
                                        <p>
                                          <!--CRLF-->
                                        </p>
                                        
                                        <pre><span style="color: #606060">   8:</span>     {</pre>
                                        
                                        <p>
                                          <!--CRLF-->
                                        </p>
                                        
                                        <pre><span style="color: #606060">   9:</span>         presenter = <span style="color: #0000ff">new</span> DumbConstructorPresenter(<span style="color: #0000ff">this</span>, <span style="color: #0000ff">null</span>, <span style="color: #0000ff">null</span>);</pre>
                                        
                                        <p>
                                          <!--CRLF-->
                                        </p>
                                        
                                        <pre><span style="color: #606060">  10:</span>&#160; </pre>
                                        
                                        <p>
                                          <!--CRLF-->
                                        </p>
                                        
                                        <pre><span style="color: #606060">  11:</span>         <span style="color: #008000">// simulate a couple possible events</span></pre>
                                        
                                        <p>
                                          <!--CRLF-->
                                        </p>
                                        
                                        <pre><span style="color: #606060">  12:</span>         load += () =&gt; presenter.Initialize();</pre>
                                        
                                        <p>
                                          <!--CRLF-->
                                        </p>
                                        
                                        <pre><span style="color: #606060">  13:</span>         loginButtonClick += () =&gt; presenter.Login();</pre>
                                        
                                        <p>
                                          <!--CRLF-->
                                        </p>
                                        
                                        <pre><span style="color: #606060">  14:</span>     }</pre>
                                        
                                        <p>
                                          <!--CRLF-->
                                        </p>
                                        
                                        <pre><span style="color: #606060">  15:</span>&#160; </pre>
                                        
                                        <p>
                                          <!--CRLF-->
                                        </p>
                                        
                                        <pre><span style="color: #606060">  16:</span>     <span style="color: #0000ff">public</span> <span style="color: #0000ff">void</span> BindWith(IEnumerable&lt;User&gt; users)</pre>
                                        
                                        <p>
                                          <!--CRLF-->
                                        </p>
                                        
                                        <pre><span style="color: #606060">  17:</span>     {</pre>
                                        
                                        <p>
                                          <!--CRLF-->
                                        </p>
                                        
                                        <pre><span style="color: #606060">  18:</span>         <span style="color: #008000">// bind this stuff to something</span></pre>
                                        
                                        <p>
                                          <!--CRLF-->
                                        </p>
                                        
                                        <pre><span style="color: #606060">  19:</span>     }</pre>
                                        
                                        <p>
                                          <!--CRLF-->
                                        </p>
                                        
                                        <pre><span style="color: #606060">  20:</span>&#160; </pre>
                                        
                                        <p>
                                          <!--CRLF-->
                                        </p>
                                        
                                        <pre><span style="color: #606060">  21:</span>     <span style="color: #0000ff">public</span> <span style="color: #0000ff">bool</span> HasUserSelected</pre>
                                        
                                        <p>
                                          <!--CRLF-->
                                        </p>
                                        
                                        <pre><span style="color: #606060">  22:</span>     {</pre>
                                        
                                        <p>
                                          <!--CRLF-->
                                        </p>
                                        
                                        <pre><span style="color: #606060">  23:</span>         get { <span style="color: #0000ff">return</span> <span style="color: #0000ff">false</span>; }</pre>
                                        
                                        <p>
                                          <!--CRLF-->
                                        </p>
                                        
                                        <pre><span style="color: #606060">  24:</span>     }</pre>
                                        
                                        <p>
                                          <!--CRLF-->
                                        </p>
                                        
                                        <pre><span style="color: #606060">  25:</span>&#160; </pre>
                                        
                                        <p>
                                          <!--CRLF-->
                                        </p>
                                        
                                        <pre><span style="color: #606060">  26:</span>     <span style="color: #0000ff">public</span> <span style="color: #0000ff">void</span> SetNumberOfLoggedInUsersTo(<span style="color: #0000ff">int</span> numberOfUsers)</pre>
                                        
                                        <p>
                                          <!--CRLF-->
                                        </p>
                                        
                                        <pre><span style="color: #606060">  27:</span>     {</pre>
                                        
                                        <p>
                                          <!--CRLF-->
                                        </p>
                                        
                                        <pre><span style="color: #606060">  28:</span>         <span style="color: #008000">// set some label or something</span></pre>
                                        
                                        <p>
                                          <!--CRLF-->
                                        </p>
                                        
                                        <pre><span style="color: #606060">  29:</span>     }</pre>
                                        
                                        <p>
                                          <!--CRLF-->
                                        </p>
                                        
                                        <pre><span style="color: #606060">  30:</span> }</pre>
                                        
                                        <p>
                                          <!--CRLF-->
                                        </p>
                                        
                                        <pre><span style="color: #606060">  31:</span>&#160; </pre>
                                        
                                        <p>
                                          <!--CRLF-->
                                        </p>
                                        
                                        <pre><span style="color: #606060">  32:</span> <span style="color: #0000ff">public</span> <span style="color: #0000ff">delegate</span> <span style="color: #0000ff">void</span> VoidHandler();</pre>
                                        
                                        <p>
                                          <!--CRLF--></div> </div> 
                                          
                                          <p>
                                            I would prefer this approach since I think it keeps the specs and the presenter implementation itself quite a bit cleaner.&#160; Notice now in the spec: <strong>when_attempting_to_login_and_a_user_is_not_selected.it_should_NOT_perform_a_login.</strong>
                                          </p>
                                          
                                          <p>
                                            It cares nothing about retrieving users from the repository.&#160; All it cares about is exactly what the context/spec sentence states.&#160; And if you notice, there is even an opportunity to DRY up these specs, if you prefer, by breaking out a base context class, since they both have identical <strong>EstablishContext()</strong> methods.&#160; This is something that wouldn’t be quite as easy or clean to do in the <strong>SmartConstructorPresenterSpecs</strong> in the previous section.
                                          </p>
                                          
                                          <h3>
                                            Quick Tip : Load/Initialize Convention
                                          </h3>
                                          
                                          <p>
                                            You might be thinking that you don’t want to have to <em>remember</em> to create or call an Initialize() method all the time.&#160; Well recently, a co-worker of mine pointed out a simple way we could leverage some auto-wiring magic + a base presenter class to make it more of a convention that you can use when needed and to negate the need to manually call <strong>Initialize()</strong> all the time.&#160; So here is one approach to make that easier.
                                          </p>
                                          
                                          <p>
                                            NOTE: The presenter specs don’t need to change at all for this refactoring.
                                          </p>
                                          
                                          <p>
                                            First we add a Load event handler to our IView interface:
                                          </p>
                                          
                                          <div>
                                            <div>
                                              <pre><span style="color: #606060">   1:</span> <span style="color: #0000ff">public</span> <span style="color: #0000ff">interface</span> IView</pre>
                                              
                                              <p>
                                                <!--CRLF-->
                                              </p>
                                              
                                              <pre><span style="color: #606060">   2:</span> {</pre>
                                              
                                              <p>
                                                <!--CRLF-->
                                              </p>
                                              
                                              <pre><span style="color: #606060">   3:</span>     <span style="color: #0000ff">void</span> BindWith(IEnumerable&lt;User&gt; users);</pre>
                                              
                                              <p>
                                                <!--CRLF-->
                                              </p>
                                              
                                              <pre><span style="color: #606060">   4:</span>     <span style="color: #0000ff">bool</span> HasUserSelected { get; }</pre>
                                              
                                              <p>
                                                <!--CRLF-->
                                              </p>
                                              
                                              <pre><span style="color: #606060">   5:</span>     <span style="color: #0000ff">void</span> SetNumberOfLoggedInUsersTo(<span style="color: #0000ff">int</span> numberOfUsers);</pre>
                                              
                                              <p>
                                                <!--CRLF-->
                                              </p>
                                              
                                              <pre><span style="color: #606060">   6:</span>     <span style="color: #0000ff">event</span> EventHandler Load;</pre>
                                              
                                              <p>
                                                <!--CRLF-->
                                              </p>
                                              
                                              <pre><span style="color: #606060">   7:</span> }</pre>
                                              
                                              <p>
                                                <!--CRLF--></div> </div> 
                                                
                                                <p>
                                                  Then we introduce a base presenter class (which I’m simply calling Presenter ‘cause I think Base* class naming is the new hungarian notation…. :).
                                                </p>
                                                
                                                <div>
                                                  <div>
                                                    <pre><span style="color: #606060">   1:</span> <span style="color: #0000ff">public</span> <span style="color: #0000ff">class</span> Presenter&lt;T&gt; <span style="color: #0000ff">where</span> T : IView</pre>
                                                    
                                                    <p>
                                                      <!--CRLF-->
                                                    </p>
                                                    
                                                    <pre><span style="color: #606060">   2:</span> {</pre>
                                                    
                                                    <p>
                                                      <!--CRLF-->
                                                    </p>
                                                    
                                                    <pre><span style="color: #606060">   3:</span>     <span style="color: #0000ff">public</span> Presenter(T view)</pre>
                                                    
                                                    <p>
                                                      <!--CRLF-->
                                                    </p>
                                                    
                                                    <pre><span style="color: #606060">   4:</span>     {</pre>
                                                    
                                                    <p>
                                                      <!--CRLF-->
                                                    </p>
                                                    
                                                    <pre><span style="color: #606060">   5:</span>         view.Load += <span style="color: #0000ff">delegate</span> { Initialize(); };</pre>
                                                    
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
                                                    
                                                    <pre><span style="color: #606060">   8:</span>     <span style="color: #0000ff">public</span> <span style="color: #0000ff">virtual</span> <span style="color: #0000ff">void</span> Initialize()</pre>
                                                    
                                                    <p>
                                                      <!--CRLF-->
                                                    </p>
                                                    
                                                    <pre><span style="color: #606060">   9:</span>     {</pre>
                                                    
                                                    <p>
                                                      <!--CRLF-->
                                                    </p>
                                                    
                                                    <pre><span style="color: #606060">  10:</span>     }</pre>
                                                    
                                                    <p>
                                                      <!--CRLF-->
                                                    </p>
                                                    
                                                    <pre><span style="color: #606060">  11:</span> }</pre>
                                                    
                                                    <p>
                                                      <!--CRLF--></div> </div> 
                                                      
                                                      <p>
                                                        Then our <strong>DumbConstructorPresenter </strong>just changes slightly to inherit and override the <strong>Initialize()</strong> method.
                                                      </p>
                                                      
                                                      <div>
                                                        <div>
                                                          <pre><span style="color: #606060">   1:</span> <span style="color: #0000ff">public</span> <span style="color: #0000ff">class</span> DumbConstructorPresenter : Presenter&lt;IView&gt;</pre>
                                                          
                                                          <p>
                                                            <!--CRLF-->
                                                          </p>
                                                          
                                                          <pre><span style="color: #606060">   2:</span> {</pre>
                                                          
                                                          <p>
                                                            <!--CRLF-->
                                                          </p>
                                                          
                                                          <pre><span style="color: #606060">   3:</span>     <span style="color: #0000ff">private</span> <span style="color: #0000ff">readonly</span> IView view;</pre>
                                                          
                                                          <p>
                                                            <!--CRLF-->
                                                          </p>
                                                          
                                                          <pre><span style="color: #606060">   4:</span>     <span style="color: #0000ff">private</span> <span style="color: #0000ff">readonly</span> IUserRepository userRepository;</pre>
                                                          
                                                          <p>
                                                            <!--CRLF-->
                                                          </p>
                                                          
                                                          <pre><span style="color: #606060">   5:</span>     <span style="color: #0000ff">private</span> <span style="color: #0000ff">readonly</span> IAuthenticationService authenticationService;</pre>
                                                          
                                                          <p>
                                                            <!--CRLF-->
                                                          </p>
                                                          
                                                          <pre><span style="color: #606060">   6:</span>&#160; </pre>
                                                          
                                                          <p>
                                                            <!--CRLF-->
                                                          </p>
                                                          
                                                          <pre><span style="color: #606060">   7:</span>     <span style="color: #0000ff">public</span> DumbConstructorPresenter(IView view, IUserRepository userRepository,</pre>
                                                          
                                                          <p>
                                                            <!--CRLF-->
                                                          </p>
                                                          
                                                          <pre><span style="color: #606060">   8:</span>                                     IAuthenticationService authenticationService) : <span style="color: #0000ff">base</span>(view)</pre>
                                                          
                                                          <p>
                                                            <!--CRLF-->
                                                          </p>
                                                          
                                                          <pre><span style="color: #606060">   9:</span>     {</pre>
                                                          
                                                          <p>
                                                            <!--CRLF-->
                                                          </p>
                                                          
                                                          <pre><span style="color: #606060">  10:</span>         <span style="color: #0000ff">this</span>.view = view;</pre>
                                                          
                                                          <p>
                                                            <!--CRLF-->
                                                          </p>
                                                          
                                                          <pre><span style="color: #606060">  11:</span>         <span style="color: #0000ff">this</span>.userRepository = userRepository;</pre>
                                                          
                                                          <p>
                                                            <!--CRLF-->
                                                          </p>
                                                          
                                                          <pre><span style="color: #606060">  12:</span>         <span style="color: #0000ff">this</span>.authenticationService = authenticationService;</pre>
                                                          
                                                          <p>
                                                            <!--CRLF-->
                                                          </p>
                                                          
                                                          <pre><span style="color: #606060">  13:</span>     }</pre>
                                                          
                                                          <p>
                                                            <!--CRLF-->
                                                          </p>
                                                          
                                                          <pre><span style="color: #606060">  14:</span>&#160; </pre>
                                                          
                                                          <p>
                                                            <!--CRLF-->
                                                          </p>
                                                          
                                                          <pre><span style="color: #606060">  15:</span>     <span style="color: #0000ff">public</span> <span style="color: #0000ff">override</span> <span style="color: #0000ff">void</span> Initialize()</pre>
                                                          
                                                          <p>
                                                            <!--CRLF-->
                                                          </p>
                                                          
                                                          <pre><span style="color: #606060">  16:</span>     {</pre>
                                                          
                                                          <p>
                                                            <!--CRLF-->
                                                          </p>
                                                          
                                                          <pre><span style="color: #606060">  17:</span>         var users = userRepository.All();</pre>
                                                          
                                                          <p>
                                                            <!--CRLF-->
                                                          </p>
                                                          
                                                          <pre><span style="color: #606060">  18:</span>&#160; </pre>
                                                          
                                                          <p>
                                                            <!--CRLF-->
                                                          </p>
                                                          
                                                          <pre><span style="color: #606060">  19:</span>         view.BindWith(users);</pre>
                                                          
                                                          <p>
                                                            <!--CRLF-->
                                                          </p>
                                                          
                                                          <pre><span style="color: #606060">  20:</span>         view.SetNumberOfLoggedInUsersTo(users.Where(x =&gt; x.IsLoggedIn).Count());</pre>
                                                          
                                                          <p>
                                                            <!--CRLF-->
                                                          </p>
                                                          
                                                          <pre><span style="color: #606060">  21:</span>     }</pre>
                                                          
                                                          <p>
                                                            <!--CRLF-->
                                                          </p>
                                                          
                                                          <pre><span style="color: #606060">  22:</span>&#160; </pre>
                                                          
                                                          <p>
                                                            <!--CRLF-->
                                                          </p>
                                                          
                                                          <pre><span style="color: #606060">  23:</span>     <span style="color: #0000ff">public</span> <span style="color: #0000ff">void</span> Login()</pre>
                                                          
                                                          <p>
                                                            <!--CRLF-->
                                                          </p>
                                                          
                                                          <pre><span style="color: #606060">  24:</span>     {</pre>
                                                          
                                                          <p>
                                                            <!--CRLF-->
                                                          </p>
                                                          
                                                          <pre><span style="color: #606060">  25:</span>         <span style="color: #0000ff">if</span> (view.HasUserSelected)</pre>
                                                          
                                                          <p>
                                                            <!--CRLF-->
                                                          </p>
                                                          
                                                          <pre><span style="color: #606060">  26:</span>             authenticationService.Login();</pre>
                                                          
                                                          <p>
                                                            <!--CRLF-->
                                                          </p>
                                                          
                                                          <pre><span style="color: #606060">  27:</span>     }</pre>
                                                          
                                                          <p>
                                                            <!--CRLF-->
                                                          </p>
                                                          
                                                          <pre><span style="color: #606060">  28:</span> }</pre>
                                                          
                                                          <p>
                                                            <!--CRLF--></div> </div> 
                                                            
                                                            <p>
                                                              And finally our view implementation.
                                                            </p>
                                                          </p>
                                                          
                                                          <div>
                                                            <div>
                                                              <pre><span style="color: #606060">   1:</span> <span style="color: #0000ff">public</span> <span style="color: #0000ff">class</span> View : IView</pre>
                                                              
                                                              <p>
                                                                <!--CRLF-->
                                                              </p>
                                                              
                                                              <pre><span style="color: #606060">   2:</span> {</pre>
                                                              
                                                              <p>
                                                                <!--CRLF-->
                                                              </p>
                                                              
                                                              <pre><span style="color: #606060">   3:</span>     <span style="color: #008000">// in the context of a winforms app, </span></pre>
                                                              
                                                              <p>
                                                                <!--CRLF-->
                                                              </p>
                                                              
                                                              <pre><span style="color: #606060">   4:</span>     <span style="color: #008000">// this event would be automatically declared and fired</span></pre>
                                                              
                                                              <p>
                                                                <!--CRLF-->
                                                              </p>
                                                              
                                                              <pre><span style="color: #606060">   5:</span>     <span style="color: #0000ff">public</span> <span style="color: #0000ff">event</span> EventHandler Load = <span style="color: #0000ff">delegate</span> { };</pre>
                                                              
                                                              <p>
                                                                <!--CRLF-->
                                                              </p>
                                                              
                                                              <pre><span style="color: #606060">   6:</span>&#160; </pre>
                                                              
                                                              <p>
                                                                <!--CRLF-->
                                                              </p>
                                                              
                                                              <pre><span style="color: #606060">   7:</span>     <span style="color: #0000ff">public</span> <span style="color: #0000ff">event</span> VoidHandler LoginButtonClick = <span style="color: #0000ff">delegate</span> { };</pre>
                                                              
                                                              <p>
                                                                <!--CRLF-->
                                                              </p>
                                                              
                                                              <pre><span style="color: #606060">   8:</span>     <span style="color: #0000ff">private</span> <span style="color: #0000ff">readonly</span> DumbConstructorPresenter presenter;</pre>
                                                              
                                                              <p>
                                                                <!--CRLF-->
                                                              </p>
                                                              
                                                              <pre><span style="color: #606060">   9:</span>&#160; </pre>
                                                              
                                                              <p>
                                                                <!--CRLF-->
                                                              </p>
                                                              
                                                              <pre><span style="color: #606060">  10:</span>     <span style="color: #0000ff">public</span> View()</pre>
                                                              
                                                              <p>
                                                                <!--CRLF-->
                                                              </p>
                                                              
                                                              <pre><span style="color: #606060">  11:</span>     {</pre>
                                                              
                                                              <p>
                                                                <!--CRLF-->
                                                              </p>
                                                              
                                                              <pre><span style="color: #606060">  12:</span>         presenter = <span style="color: #0000ff">new</span> DumbConstructorPresenter(<span style="color: #0000ff">this</span>, <span style="color: #0000ff">null</span>, <span style="color: #0000ff">null</span>);</pre>
                                                              
                                                              <p>
                                                                <!--CRLF-->
                                                              </p>
                                                              
                                                              <pre><span style="color: #606060">  13:</span>&#160; </pre>
                                                              
                                                              <p>
                                                                <!--CRLF-->
                                                              </p>
                                                              
                                                              <pre><span style="color: #606060">  14:</span>         <span style="color: #008000">// simulate a possible login button click</span></pre>
                                                              
                                                              <p>
                                                                <!--CRLF-->
                                                              </p>
                                                              
                                                              <pre><span style="color: #606060">  15:</span>         LoginButtonClick += () =&gt; presenter.Login();</pre>
                                                              
                                                              <p>
                                                                <!--CRLF-->
                                                              </p>
                                                              
                                                              <pre><span style="color: #606060">  16:</span>     }</pre>
                                                              
                                                              <p>
                                                                <!--CRLF-->
                                                              </p>
                                                              
                                                              <pre><span style="color: #606060">  17:</span>&#160; </pre>
                                                              
                                                              <p>
                                                                <!--CRLF-->
                                                              </p>
                                                              
                                                              <pre><span style="color: #606060">  18:</span>     <span style="color: #0000ff">public</span> <span style="color: #0000ff">void</span> BindWith(IEnumerable&lt;User&gt; users)</pre>
                                                              
                                                              <p>
                                                                <!--CRLF-->
                                                              </p>
                                                              
                                                              <pre><span style="color: #606060">  19:</span>     {</pre>
                                                              
                                                              <p>
                                                                <!--CRLF-->
                                                              </p>
                                                              
                                                              <pre><span style="color: #606060">  20:</span>         <span style="color: #008000">// bind this stuff to something</span></pre>
                                                              
                                                              <p>
                                                                <!--CRLF-->
                                                              </p>
                                                              
                                                              <pre><span style="color: #606060">  21:</span>     }</pre>
                                                              
                                                              <p>
                                                                <!--CRLF-->
                                                              </p>
                                                              
                                                              <pre><span style="color: #606060">  22:</span>&#160; </pre>
                                                              
                                                              <p>
                                                                <!--CRLF-->
                                                              </p>
                                                              
                                                              <pre><span style="color: #606060">  23:</span>     <span style="color: #0000ff">public</span> <span style="color: #0000ff">bool</span> HasUserSelected</pre>
                                                              
                                                              <p>
                                                                <!--CRLF-->
                                                              </p>
                                                              
                                                              <pre><span style="color: #606060">  24:</span>     {</pre>
                                                              
                                                              <p>
                                                                <!--CRLF-->
                                                              </p>
                                                              
                                                              <pre><span style="color: #606060">  25:</span>         get { <span style="color: #0000ff">return</span> <span style="color: #0000ff">false</span>; }</pre>
                                                              
                                                              <p>
                                                                <!--CRLF-->
                                                              </p>
                                                              
                                                              <pre><span style="color: #606060">  26:</span>     }</pre>
                                                              
                                                              <p>
                                                                <!--CRLF-->
                                                              </p>
                                                              
                                                              <pre><span style="color: #606060">  27:</span>&#160; </pre>
                                                              
                                                              <p>
                                                                <!--CRLF-->
                                                              </p>
                                                              
                                                              <pre><span style="color: #606060">  28:</span>     <span style="color: #0000ff">public</span> <span style="color: #0000ff">void</span> SetNumberOfLoggedInUsersTo(<span style="color: #0000ff">int</span> numberOfUsers)</pre>
                                                              
                                                              <p>
                                                                <!--CRLF-->
                                                              </p>
                                                              
                                                              <pre><span style="color: #606060">  29:</span>     {</pre>
                                                              
                                                              <p>
                                                                <!--CRLF-->
                                                              </p>
                                                              
                                                              <pre><span style="color: #606060">  30:</span>         <span style="color: #008000">// set some label or something</span></pre>
                                                              
                                                              <p>
                                                                <!--CRLF-->
                                                              </p>
                                                              
                                                              <pre><span style="color: #606060">  31:</span>     }</pre>
                                                              
                                                              <p>
                                                                <!--CRLF-->
                                                              </p>
                                                              
                                                              <pre><span style="color: #606060">  32:</span> }</pre>
                                                              
                                                              <p>
                                                                <!--CRLF--></div> </div> 
                                                                
                                                                <p>
                                                                  Notice in the <strong>Presenter<T></strong> class above, we’re simply wiring up the <strong>Load</strong> event from the <strong>IView</strong> to automatically call the <strong>Initialize()</strong> method for us.&#160; Concrete presenters could then simply just override the <strong>Initialize()</strong> method if necessary.
                                                                </p>
                                                                
                                                                <p>
                                                                  Then notice in the updated view implementation, we don’t have explicitly call the <strong>Initialize() </strong>method anymore in our views, since that’s done for us automatically in the <strong>Presenter<T></strong> class.
                                                                </p>
                                                                
                                                                <p>
                                                                  As I’m writing this I realize that the act of overriding this <strong>Initialize()</strong> method would have to be <em>remembered</em> as well.&#160; But I think what you gain from a convention standpoint and the fact that you don’t have to explicitly call it from the views is enough of a win to warrant this technique.&#160; But as always, I’ll probably change my mind tomorrow when I figure out a better way to do all of this.&#160; 🙂
                                                                </p>
                                                                
                                                                <p>
                                                                  So, putting aside the possibly poor examples and the cloud of MVP in all of this, my goal was just to simply give an example of why it can be a good idea to keep your constructors simple and lean across the board, in many different types of classes.
                                                                </p>
                                                                
                                                                <p>
                                                                  Of course feedback is always welcome.
                                                                </p>