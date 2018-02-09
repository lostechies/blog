---
wordpress_id: 4735
title: 'Simple NHibernate Example, Part 3: Initial Repository Implementation'
date: 2007-03-30T16:36:00+00:00
author: Nelson Montalvo
layout: post
wordpress_guid: /blogs/nelson_montalvo/archive/2007/03/30/simple-nhibernate-example-part-3-initial-repository-implementation.aspx
categories:
  - NHibernate
redirect_from: "/blogs/nelson_montalvo/archive/2007/03/30/simple-nhibernate-example-part-3-initial-repository-implementation.aspx/"
---
_Repositories_ are our central access point to pre-existing domain objects. Repositories simplify the management of the object&#8217;s life cycle and decouple the domain from data access technologies and strategies. Finally, repositories are domain level, communicating to other domain objects how certain objects can be accessed.


  


I will begin&nbsp;my initial repository implementation by exploring how to save (register) a NEW domain object with our repository, thus giving that object _Identity_ within the context of our domain.


  


Let&#8217;s say that we have a new auto Dealer object. The auto dealer&#8217;s information has been entered into the domain object and we are not ready to persist that information into the domain.


  


Our initial specifications for the repository&nbsp;are the following. For this initial implementation,&nbsp;I am&nbsp;going to use a mocked&nbsp;interface representing the repository.&nbsp;This will allow us&nbsp;to explore the interactions between the domain object and the Repository interface. Eventually, we will replace this mocked interface code with the real NHibernate implementation.


  


<DIV>
  <PRE><SPAN>&nbsp;&nbsp;&nbsp;&nbsp;1</SPAN>&nbsp;<SPAN>using</SPAN> Foo.Domain;</PRE>
  
  <PRE><SPAN>&nbsp;&nbsp;&nbsp;&nbsp;2</SPAN>&nbsp;<SPAN>using</SPAN> Foo.Domain.Repositories;</PRE>
  
  <PRE><SPAN>&nbsp;&nbsp;&nbsp;&nbsp;3</SPAN>&nbsp;<SPAN>using</SPAN> NUnit.Framework;</PRE>
  
  <PRE><SPAN>&nbsp;&nbsp;&nbsp;&nbsp;4</SPAN>&nbsp;<SPAN>using</SPAN> Rhino.Mocks;</PRE>
  
  <PRE><SPAN>&nbsp;&nbsp;&nbsp;&nbsp;5</SPAN>&nbsp;</PRE>
  
  <PRE><SPAN>&nbsp;&nbsp;&nbsp;&nbsp;6</SPAN>&nbsp;<SPAN>namespace</SPAN> Specifications.Foo.Domain</PRE>
  
  <PRE><SPAN>&nbsp;&nbsp;&nbsp;&nbsp;7</SPAN>&nbsp;{</PRE>
  
  <PRE><SPAN>&nbsp;&nbsp;&nbsp;&nbsp;8</SPAN>&nbsp;&nbsp;&nbsp;&nbsp; [<SPAN>TestFixture</SPAN>]</PRE>
  
  <PRE><SPAN>&nbsp;&nbsp;&nbsp;&nbsp;9</SPAN>&nbsp;&nbsp;&nbsp;&nbsp; <SPAN>public</SPAN> <SPAN>class</SPAN> <SPAN>WhenSavingANewDealerToTheDealerRepository</SPAN></PRE>
  
  <PRE><SPAN>&nbsp;&nbsp;&nbsp;10</SPAN>&nbsp;&nbsp;&nbsp;&nbsp; {</PRE>
  
  <PRE><SPAN>&nbsp;&nbsp;&nbsp;11</SPAN>&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; <SPAN>private</SPAN> <SPAN>const</SPAN> <SPAN>int</SPAN> MOCK_DB_ID = 1;</PRE>
  
  <PRE><SPAN>&nbsp;&nbsp;&nbsp;12</SPAN>&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; <SPAN>private</SPAN> <SPAN>Dealer</SPAN> dealer;</PRE>
  
  <PRE><SPAN>&nbsp;&nbsp;&nbsp;13</SPAN>&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; <SPAN>private</SPAN> <SPAN>MockRepository</SPAN> mocks;</PRE>
  
  <PRE><SPAN>&nbsp;&nbsp;&nbsp;14</SPAN>&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; <SPAN>private</SPAN> <SPAN>DealerRepository</SPAN> dealerRepository;</PRE>
  
  <PRE><SPAN>&nbsp;&nbsp;&nbsp;15</SPAN>&nbsp;</PRE>
  
  <PRE><SPAN>&nbsp;&nbsp;&nbsp;16</SPAN>&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; [<SPAN>SetUp</SPAN>]</PRE>
  
  <PRE><SPAN>&nbsp;&nbsp;&nbsp;17</SPAN>&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; <SPAN>public</SPAN> <SPAN>void</SPAN> SetUpContext()</PRE>
  
  <PRE><SPAN>&nbsp;&nbsp;&nbsp;18</SPAN>&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; {</PRE>
  
  <PRE><SPAN>&nbsp;&nbsp;&nbsp;19</SPAN>&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; dealer = <SPAN>new</SPAN> <SPAN>Dealer</SPAN>();</PRE>
  
  <PRE><SPAN>&nbsp;&nbsp;&nbsp;20</SPAN>&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; mocks = <SPAN>new</SPAN> <SPAN>MockRepository</SPAN>();</PRE>
  
  <PRE><SPAN>&nbsp;&nbsp;&nbsp;21</SPAN>&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; dealerRepository = mocks.CreateMock&lt;<SPAN>DealerRepository</SPAN>&gt;();</PRE>
  
  <PRE><SPAN>&nbsp;&nbsp;&nbsp;22</SPAN>&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; }</PRE>
  
  <PRE><SPAN>&nbsp;&nbsp;&nbsp;23</SPAN>&nbsp;</PRE>
  
  <PRE><SPAN>&nbsp;&nbsp;&nbsp;24</SPAN>&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; [<SPAN>Test</SPAN>]</PRE>
  
  <PRE><SPAN>&nbsp;&nbsp;&nbsp;25</SPAN>&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; <SPAN>public</SPAN> <SPAN>void</SPAN> ShouldPopulateAnIdForTheDealerAfterSaving()</PRE>
  
  <PRE><SPAN>&nbsp;&nbsp;&nbsp;26</SPAN>&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; {</PRE>
  
  <PRE><SPAN>&nbsp;&nbsp;&nbsp;27</SPAN>&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; SetupMockExpectations();</PRE>
  
  <PRE><SPAN>&nbsp;&nbsp;&nbsp;28</SPAN>&nbsp;</PRE>
  
  <PRE><SPAN>&nbsp;&nbsp;&nbsp;29</SPAN>&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; <SPAN>Assert</SPAN>.AreEqual(0, dealer.Id, <SPAN>&#8220;The dealer&#8217;s ID should not be set before the save.&#8221;</SPAN>);</PRE>
  
  <PRE><SPAN>&nbsp;&nbsp;&nbsp;30</SPAN>&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; <SPAN>Dealer</SPAN> savedDealer = dealerRepository.Save(dealer);</PRE>
  
  <PRE><SPAN>&nbsp;&nbsp;&nbsp;31</SPAN>&nbsp;</PRE>
  
  <PRE><SPAN>&nbsp;&nbsp;&nbsp;32</SPAN>&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; <SPAN>Assert</SPAN>.IsNotNull(savedDealer, <SPAN>&#8220;A saved dealer reference should be returned from the Repository.&#8221;</SPAN>);</PRE>
  
  <PRE><SPAN>&nbsp;&nbsp;&nbsp;33</SPAN>&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; <SPAN>Assert</SPAN>.AreNotEqual(dealer, savedDealer, <SPAN>&#8220;The saved dealer reference should be different from the one passed into the Save.&#8221;</SPAN>);</PRE>
  
  <PRE><SPAN>&nbsp;&nbsp;&nbsp;34</SPAN>&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; <SPAN>Assert</SPAN>.AreEqual(MOCK_DB_ID, savedDealer.Id, <SPAN>&#8220;A system ID should be generated for the newly saved dealer.&#8221;</SPAN>);</PRE>
  
  <PRE><SPAN>&nbsp;&nbsp;&nbsp;35</SPAN>&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; mocks.VerifyAll();</PRE>
  
  <PRE><SPAN>&nbsp;&nbsp;&nbsp;36</SPAN>&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; }</PRE>
  
  <PRE><SPAN>&nbsp;&nbsp;&nbsp;37</SPAN>&nbsp;</PRE>
  
  <PRE><SPAN>&nbsp;&nbsp;&nbsp;38</SPAN>&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; <SPAN>private</SPAN> <SPAN>void</SPAN> SetupMockExpectations()</PRE>
  
  <PRE><SPAN>&nbsp;&nbsp;&nbsp;39</SPAN>&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; {</PRE>
  
  <PRE><SPAN>&nbsp;&nbsp;&nbsp;40</SPAN>&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; <SPAN>Dealer</SPAN> dealerToReturnInExpectedCall = SetupExpectationThatACallToSaveWillReturnANewDealerReference();</PRE>
  
  <PRE><SPAN>&nbsp;&nbsp;&nbsp;41</SPAN>&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; SetupExpectationThatTheIdOnTheNewDealerReferenceWillBeSet(dealerToReturnInExpectedCall);</PRE>
  
  <PRE><SPAN>&nbsp;&nbsp;&nbsp;42</SPAN>&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; mocks.ReplayAll();</PRE>
  
  <PRE><SPAN>&nbsp;&nbsp;&nbsp;43</SPAN>&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; }</PRE>
  
  <PRE><SPAN>&nbsp;&nbsp;&nbsp;44</SPAN>&nbsp;</PRE>
  
  <PRE><SPAN>&nbsp;&nbsp;&nbsp;45</SPAN>&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; <SPAN>private</SPAN> <SPAN>static</SPAN> <SPAN>void</SPAN> SetupExpectationThatTheIdOnTheNewDealerReferenceWillBeSet(<SPAN>Dealer</SPAN> dealerToReturnInExpectedCall)</PRE>
  
  <PRE><SPAN>&nbsp;&nbsp;&nbsp;46</SPAN>&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; {</PRE>
  
  <PRE><SPAN>&nbsp;&nbsp;&nbsp;47</SPAN>&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; <SPAN>Expect</SPAN>.Call(dealerToReturnInExpectedCall.Id).Return(MOCK_DB_ID);</PRE>
  
  <PRE><SPAN>&nbsp;&nbsp;&nbsp;48</SPAN>&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; }</PRE>
  
  <PRE><SPAN>&nbsp;&nbsp;&nbsp;49</SPAN>&nbsp;</PRE>
  
  <PRE><SPAN>&nbsp;&nbsp;&nbsp;50</SPAN>&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; <SPAN>private</SPAN> <SPAN>Dealer</SPAN> SetupExpectationThatACallToSaveWillReturnANewDealerReference()</PRE>
  
  <PRE><SPAN>&nbsp;&nbsp;&nbsp;51</SPAN>&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; {</PRE>
  
  <PRE><SPAN>&nbsp;&nbsp;&nbsp;52</SPAN>&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; <SPAN>Dealer</SPAN> dealerToReturnInExpectedCall = mocks.PartialMock&lt;<SPAN>Dealer</SPAN>&gt;();</PRE>
  
  <PRE><SPAN>&nbsp;&nbsp;&nbsp;53</SPAN>&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; <SPAN>Expect</SPAN>.Call(dealerRepository.Save(dealer)).Return(dealerToReturnInExpectedCall);</PRE>
  
  <PRE><SPAN>&nbsp;&nbsp;&nbsp;54</SPAN>&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; <SPAN>return</SPAN> dealerToReturnInExpectedCall;</PRE>
  
  <PRE><SPAN>&nbsp;&nbsp;&nbsp;55</SPAN>&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; }</PRE>
  
  <PRE><SPAN>&nbsp;&nbsp;&nbsp;56</SPAN>&nbsp;&nbsp;&nbsp;&nbsp; }</PRE>
  
  <PRE><SPAN>&nbsp;&nbsp;&nbsp;57</SPAN>&nbsp;}<BR /><BR /></PRE>
</DIV>

  

  


As an explanation:&nbsp;

  

  


  

  


  * I am going to make a technical implementation decision (let me know if this is wrong) and return a new Dealer object&nbsp;reference from the save call (line 30). Simliar to NHibernate, I believe, this will allow for the return of the proxied reference, which is &nbsp;managed by NHibernate (mocked on lines 52 and 53). _This is a significant point and I hope to have some time to verify this in another post.  
      
_   
    
  
      * The Dealer.Id property cannot be set externally (please review my previous post on Identity), so on line 47, I used Rhino mocks to partially mock the interface and&nbsp;return a value for that property.   
          
          
        
  
          * On line 33, the expectation is meant to show that the original reference to the Dealer domain object is not the same as the new &#8220;proxied&#8221; version.</UL>
          
        
  
        This defines the basic specification for the interface: 
        
          
        
  
        <DIV>
          <PRE><SPAN>namespace</SPAN> Foo.Domain.Repositories</PRE>
          
          <PRE>{</PRE>
          
          <PRE>&nbsp;&nbsp;&nbsp; <SPAN>public</SPAN> <SPAN>interface</SPAN> <SPAN>DealerRepository</SPAN></PRE>
          
          <PRE>&nbsp;&nbsp;&nbsp; {</PRE>
          
          <PRE>&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; <SPAN>Dealer</SPAN> Save(<SPAN>Dealer</SPAN> dealer);</PRE>
          
          <PRE>&nbsp;&nbsp;&nbsp; }</PRE>
          
          <PRE>}<BR /></PRE>
          
          <PRE>&nbsp;</PRE>
        </DIV>
        
          
        
  
        Time to begin implementation of&nbsp;the repository interface with NHibernate. I&#8217;ll create an NHibernate mapping file to begin with.
        
          
        
  
        Assume that our database (in Sql Server 2005) and Dealer table with a DealerId column&nbsp;are in place. Also,&nbsp;this example uses&nbsp;<A href="http://www.hibernate.org/6.html" target="_blank">NHibernate 1.2.0CR1</A> released on 2/22/07. I <A href="http://sourceforge.net/project/showfiles.php?group_id=73818&package_id=73969" target="_blank">downloaded</A> the latest version for some of the newest functionality, including generics and null types.
        
          
        
  
        The table definition:
        
          
        
  
        <IMG src="http://lh3.google.com/image/nmontalvo/Rf4B-3jpLZI/AAAAAAAAABw/sfyLZohRjjU/DealerTable.jpg" border="0" />
        
          
        
  
        The simplest NHibernate mapping file to match our specifications will look like this:
        
          
        
  
        <DIV>
          <SPAN><?</SPAN><SPAN>xml</SPAN><SPAN> </SPAN><SPAN>version</SPAN><SPAN>=</SPAN><SPAN>&#8220;</SPAN><SPAN>1.0</SPAN><SPAN>&#8220;</SPAN><SPAN> </SPAN><SPAN>encoding</SPAN><SPAN>=</SPAN><SPAN>&#8220;</SPAN><SPAN>utf-8</SPAN><SPAN>&#8220;</SPAN><SPAN> ?><BR /><</SPAN><SPAN>hibernate-mapping</SPAN><SPAN> </SPAN><SPAN>xmlns</SPAN><SPAN>=</SPAN><SPAN>&#8220;</SPAN><SPAN>urn:nhibernate-mapping-2.0</SPAN><SPAN>&#8220;</SPAN><SPAN>><BR />&nbsp;&nbsp;&nbsp;&nbsp;<</SPAN><SPAN>class</SPAN><SPAN> </SPAN><SPAN>name</SPAN><SPAN>=</SPAN><SPAN>&#8220;</SPAN><SPAN>Foo.Domain.Dealer, Foo.Domain</SPAN><SPAN>&#8220;</SPAN><SPAN> </SPAN><SPAN>table</SPAN><SPAN>=</SPAN><SPAN>&#8220;</SPAN><SPAN>Dealer</SPAN><SPAN>&#8220;</SPAN><SPAN>><BR />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<</SPAN><SPAN>id</SPAN><SPAN> </SPAN><SPAN>name</SPAN><SPAN>=</SPAN><SPAN>&#8220;</SPAN><SPAN>Id</SPAN><SPAN>&#8220;</SPAN><SPAN> </SPAN><SPAN>column</SPAN><SPAN>=</SPAN><SPAN>&#8220;</SPAN><SPAN>DealerId</SPAN><SPAN>&#8220;</SPAN><SPAN>><BR />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<</SPAN><SPAN>generator</SPAN><SPAN> </SPAN><SPAN>class</SPAN><SPAN>=</SPAN><SPAN>&#8220;</SPAN><SPAN>assigned</SPAN><SPAN>&#8220;</SPAN><SPAN> /><BR />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</</SPAN><SPAN>id</SPAN><SPAN>><BR />&nbsp;&nbsp;&nbsp;&nbsp;</</SPAN><SPAN>class</SPAN><SPAN>><BR /></</SPAN><SPAN>hibernate-mapping</SPAN><SPAN>></SPAN> <BR /><BR />
        </DIV>
        
          
        
  
        Basically, all this says is to map the **Dealer** domain property, **Id**,&nbsp;to the column **DealerId** in the&nbsp;database table **Dealer**. It also says to&nbsp;utilize the database table&#8217;s &nbsp;identity capabilities to generate the unique ID for the domain object.
        
          
        
  
        Here is how I&#8217;ve structured the project. The Dealer mapping file is called **Dealer.hbm.xml**. There are references to the project containing the domain and the repository interface. There is also a reference to the NHibernate.dll file. The DealerRepository listed below is implementing the DealerRepository interface from the domain (code coming up shortly):
        
          
        
  
        <IMG src="http://lh5.google.com/image/nmontalvo/Rf4LkXjpLcI/AAAAAAAAACI/Bzwct9WjaEY/DataProjectExample.jpg" border="0" />
        
          
        
  
        And be sure to include the Dealer.hbm.xml as an **embedded resource**:
        
          
        
  
        <IMG src="http://lh6.google.com/image/nmontalvo/Rf4D2njpLbI/AAAAAAAAACA/0TWvlTQcSv0/DealerXmlFile.jpg" border="0" />
        
          
        
  
        I&#8217;ve jumped the gun a bit, so in the next posting, I&#8217;ll begin with writing NHibernate unit tests that interface with the database.&nbsp;The process is&nbsp;somewhat involved for the initial implementation, but once setup, it should be reusable for all database unit tests going forward.</p>