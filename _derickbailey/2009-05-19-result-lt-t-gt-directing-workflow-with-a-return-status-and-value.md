---
id: 54
title: 'Result<T>: Directing Workflow With A Return Status And Value'
date: 2009-05-19T14:35:34+00:00
author: Derick Bailey
layout: post
guid: /blogs/derickbailey/archive/2009/05/19/result-lt-t-gt-directing-workflow-with-a-return-status-and-value.aspx
dsq_thread_id:
  - "262068189"
categories:
  - .NET
  - AppController
  - 'C#'
  - Presentations
  - Principles and Patterns
  - Workflow
---
I often code user interfaces that have some sort of cancel button on them. For example, in my upcoming ‘[Decoupling Workflow](http://www.lostechies.com/blogs/derickbailey/archive/2009/05/18/i-m-presenting-at-austin-code-camp-2009.aspx)’ presentation, I have the following screen:

[<img style="border-right: 0px;border-top: 0px;border-left: 0px;border-bottom: 0px" height="257" alt="New Employee - Info" src="http://lostechies.com/derickbailey/files/2011/03/NewEmployeeInfo_thumb_05BF8DF7.png" width="470" border="0" />](http://lostechies.com/derickbailey/files/2011/03/NewEmployeeInfo_78597AF0.png) 

Notice the nice cancel button on the form. The trick to this situation is that I need to have my workflow code understand whether or not I clicked Next or clicked Cancel. Depending on the button that was clicked, I need to do something different in the workflow.&#160; If I click cancel, throw away all of the data that was entered on the form. If I click next, though, I need to store all of the data and continue on to the next screen. 

### The Result<T> and ServiceResult

In the past, I’ve handled these types of buttons in many, many different ways. I’ve returned null from the form, I’ve checked the DialogResult of the form, I’ve done out parameters for methods, and I’ve done specific properties on the form or the form’s presenter to tell me the status vs the data. Recently, though, I’ve begun to settle into a nice little Result<T> class that does two things for me:

  1. Provides a result status – for example, a ServiceResult enum with Ok and Cancel as the two options
  2. Provides a data object (the <T> generic in Result<T>) for the values I need, if I need them

Here is the code for my ServiceResult and my Result<T> object.

<div>
  <div>
    <pre><span style="color: #0000ff">public</span> <span style="color: #0000ff">enum</span> ServiceResult</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre>{</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre> Ok = 0,</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre> Cancel = 1</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre>}</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre>&#160;</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #0000ff">public</span> <span style="color: #0000ff">class</span> Result&lt;T&gt;</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre>{</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre> <span style="color: #0000ff">public</span> ServiceResult ServiceResult { get; <span style="color: #0000ff">private</span> set; }</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre> <span style="color: #0000ff">public</span> T Data { get; <span style="color: #0000ff">private</span> set; }</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre>&#160;</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre> <span style="color: #0000ff">public</span> Result(ServiceResult serviceResult): <span style="color: #0000ff">this</span>(serviceResult, <span style="color: #0000ff">default</span>(T)){}</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre>&#160;</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre> <span style="color: #0000ff">public</span> Result(ServiceResult serviceResult, T data)</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre> {</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre>   ServiceResult = serviceResult;</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre>   Data = data;</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre> }</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre>}</pre>
    
    <p>
      <!--CRLF--></div> </div> 
      
      <h3>
        Putting Result<T> To Work
      </h3>
      
      <p>
        With this simple little solution, I can create very concise and clear workflow objects that know how to handle the cancel button versus the next button. The code becomes easier to read and understand, and makes the real workflow that much easier to see. The workflow code that runs the “Add New Employee” process for the screen shot above, is this:
      </p>
      
      <div>
        <div>
          <pre><span style="color: #0000ff">public</span> <span style="color: #0000ff">void</span> Run()</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre>{</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre> Result&lt;EmployeeInfo&gt; result = GetNewEmployeeInfo.Get();</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre> <span style="color: #0000ff">if</span> (result.ServiceResult == ServiceResult.Ok)</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre> {</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre>   EmployeeInfo info = result.Data;</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre>   Employee employee = <span style="color: #0000ff">new</span> Employee(info.FirstName, info.LastName, info.Email);</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre>&#160;</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre>   Employee manager = GetEmployeeManager.GetManagerFor(employee);</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre>   manager.Employees.Add(employee);</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre> }</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre>&#160;</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre>}</pre>
          
          <p>
            <!--CRLF--></div> </div> 
            
            <p>
              Notice the use of Result<EmployeeInfo> in this code. I’m checking to see if the result.ServiceResult is Ok before moving on to the use of the data. The GetNewEmployeeInfo class return a Result<EmployeeInfo> object from the .Get() method. The EmployeeInfo object contains the first name, last name, and email address of the employee as simple string values (and in the “real world”, the EmployeeInfo object would probably contain the input validation for these).
            </p>
            
            <p>
              Because Result<T> is a generics class and returns <T> from the .Data property, I can specify any data value that I need and it returned from the presenter in question. This is where the real flexibility of the Result<T> object comes into play. When I have verified that the user clicked OK, via the result.ServiceResult property, I can then grab the real EmployeeInfo object out of the result.Data parameter which isstrongly typed to my EmployeeInfo class. Once I have this data in hand, I can do what I need with it and move on to the next step if there are any.
            </p>
            
            <h3>
              Conclusion
            </h3>
            
            <p>
              Having tried many different approaches to workflow code, I’m fairly well settled into this pattern right now. That doesn’t mean it won’t evolve, though. The basic implementation would cover most of what I need right now, but could easily be extended to include different “status” values instead of just the ServiceResults of OK and Cancel. Overall, though, this simple Result<T> class is saving me a lot of headache and heartache trying to figure out what to return from a method so that a workflow can figure out if the user is continuing, cancelling, or whatever.
            </p>