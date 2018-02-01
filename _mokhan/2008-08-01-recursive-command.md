---
id: 4558
title: Recursive Command
date: 2008-08-01T14:38:55+00:00
author: Mo Khan
layout: post
guid: /blogs/mokhan/archive/2008/08/01/recursive-command.aspx
categories:
  - Design Patterns
---
</p> 

**Note**: this entry [has moved](http://mokhan.ca/blog/2008/08/01/Recursive+Command.aspx "New location at Clarius").</p> 

When building up a tree view that represents the directory structure of a file system, like the windows explorer, my first reaction was to use recursion to traverse the file system and build up a tree. I quickly found that doing something like that is a time consuming process, and required some optimization. 

I came up with what I like to call the recursive command. Each Tree Node item on a tree view is bound to a command to execute. The command looks like this&#8230;

<pre><span style="color: blue">public interface </span><span style="color: #2b91af">ITreeNodeClickedCommand </span>{
    <span style="color: blue">void </span>Execute(<span style="color: #2b91af">ITreeNode </span>node);
}</pre>

[](http://11011.net/software/vspaste)When the command is executed, the command gets an opportunity to modify the state of the tree node that was clicked. In this case I wanted to lazy load the sub directories of a node that was clicked. The command implementation looks like this&#8230;

<pre><span style="color: blue">public interface </span><span style="color: #2b91af">IAddFoldersCommand </span>: <span style="color: #2b91af">ITreeNodeClickedCommand </span>{}

<span style="color: blue">public class </span><span style="color: #2b91af">AddFoldersCommand </span>: <span style="color: #2b91af">IAddFoldersCommand </span>{
    <span style="color: blue">private readonly </span><span style="color: #2b91af">DirectoryInfo </span>the_current_directory;
    <span style="color: blue">private bool </span>has_executed;

    <span style="color: blue">public </span>AddFoldersCommand(<span style="color: #2b91af">DirectoryInfo </span>the_current_directory) {
        <span style="color: blue">this</span>.the_current_directory = the_current_directory;
    }

    <span style="color: blue">public void </span>Execute(<span style="color: #2b91af">ITreeNode </span>node) {
        <span style="color: blue">if </span>(!has_executed) {
            <span style="color: blue">foreach </span>(<span style="color: blue">var </span>directory <span style="color: blue">in </span>the_current_directory.GetDirectories()) {
                node.Add(<span style="color: blue">new </span><span style="color: #2b91af">TreeNodeItem</span>(directory.Name, <span style="color: #2b91af">ApplicationIcons</span>.Folder, <span style="color: blue">new </span><span style="color: #2b91af">AddFoldersCommand</span>(directory)));
            }
        }
        has_executed = <span style="color: blue">true</span>;
    }
}</pre>

[](http://11011.net/software/vspaste)

This command is executed each time the tree node that it is bound too is clicked, but will only build up the child tree node items once. Each of the child tree nodes are bound to a new instance of the same command. Hence, what I like to call the recursive command.

[<img style="border-top-width: 0px;border-left-width: 0px;border-bottom-width: 0px;border-right-width: 0px" height="484" alt="recursive_command" src="http://mokhan.ca/blog/content/binary/WindowsLiveWriter/RecursiveCommand_8561/recursive_command_thumb.png" width="628" border="0" />](http://mokhan.ca/blog/content/binary/WindowsLiveWriter/RecursiveCommand_8561/recursive_command_2.png) 

###### 

For more information on the command pattern check out [WikiPedia&#8217;s write up](http://en.wikipedia.org/wiki/Command_pattern).