---
id: 32
title: Getting Your Selected Object From A Telerik MultiColumnComboBox
date: 2009-02-03T20:28:48+00:00
author: Derick Bailey
layout: post
guid: /blogs/derickbailey/archive/2009/02/03/getting-your-selected-object-from-a-telerik-multicolumncombobox.aspx
dsq_thread_id:
  - "264352513"
categories:
  - .NET
  - 'C#'
  - Telerik
---
Wow! I’m actually writing code! 🙂

I thought this little snippet would be useful for anyone that is binding a custom collection of objects to a <a href="http://www.telerik.com/" target="_blank">Telerik</a> MultiColumnComboBox. If you want to get the selected item as your actual class – the custom class that you wrote and bound as a collection to the list, you can use this basic code:

<div>
  <div>
    <pre><span style="color: #0000ff">private</span> <span style="color: #0000ff">void</span> MyComboBox_SelectedIndexChanged(<span style="color: #0000ff">object</span> sender, EventArgs e)</pre>
    
    <pre>{</pre>
    
    <pre>   GridViewDataRowInfo rowInfo = MyComboBox.SelectedItem <span style="color: #0000ff">as</span> GridViewDataRowInfo;</pre>
    
    <pre>   <span style="color: #0000ff">if</span> (rowInfo != <span style="color: #0000ff">null</span>)</pre>
    
    <pre>   {</pre>
    
    <pre>       MyClass myClass = rowInfo.DataBoundItem <span style="color: #0000ff">as</span> MyClass;</pre>
    
    <pre>       <span style="color: #008000">//do something with the 'myClass' variable, here.</span></pre>
    
    <pre>   }</pre>
    
    <pre>}</pre></p>
  </div>
</div>

Hopefully this will save someone else some time in the debugger trying to figure out why ‘SelectedItem’ is not coming back as the class instance that was selected.