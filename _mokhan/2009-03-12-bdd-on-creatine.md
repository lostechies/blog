---
id: 32
title: BDD on Creatine
date: 2009-03-12T16:47:27+00:00
author: Mo Khan
layout: post
guid: /blogs/mokhan/archive/2009/03/12/bdd-on-creatine.aspx
categories:
  - TDD
  - Windows Forms
---
In an attempt to further understand BDD, I chose to revise the code from my [previous post](http://mokhan.ca/blog/2009/03/11/BDD+On+Steroids.aspx) after receiving some amazing advice from two people I regard highly ([Scott](http://blog.scottbellware.com/) & [JP](http://blog.jpboodhoo.com)). I should state that this is my interpretation of that advice. This may or may not be the direction they were trying to guide me towards.</p> 

<div style="font-family: consolas;background: black;color: white;font-size: 10pt">
  <p style="margin: 0px">
    <span style="color: #2b91af">&#160;&#160; 12</span>&#160;<span style="color: #ff8000">public</span> <span style="color: #ff8000">class</span> <span style="color: yellow">when_prompted_to_save_changes_to_the_project</span> : <span style="color: yellow">concerns_for</span><<span style="color: yellow">SaveChangesView</span>>
  </p>
  
  <p style="margin: 0px">
    <span style="color: #2b91af">&#160;&#160; 13</span> {
  </p>
  
  <p style="margin: 0px">
    <span style="color: #2b91af">&#160;&#160; 14</span>&#160;&#160;&#160;&#160; <span style="color: #2b91af">context</span> c = () => { presenter = an<<span style="color: #2b91af">ISaveChangesPresenter</span>>(); };
  </p>
  
  <p style="margin: 0px">
    <span style="color: #2b91af">&#160;&#160; 15</span>&#160;
  </p>
  
  <p style="margin: 0px">
    <span style="color: #2b91af">&#160;&#160; 16</span>&#160;&#160;&#160;&#160; <span style="color: #2b91af">after_the_sut_has_been_created</span> after = () =>
  </p>
  
  <p style="margin: 0px">
    <span style="color: #2b91af">&#160;&#160; 17</span>&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160; {
  </p>
  
  <p style="margin: 0px">
    <span style="color: #2b91af">&#160;&#160; 18</span>&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160; save_changes_window = sut;
  </p>
  
  <p style="margin: 0px">
    <span style="color: #2b91af">&#160;&#160; 19</span>&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160; save_changes_window.attach_to(presenter);
  </p>
  
  <p style="margin: 0px">
    <span style="color: #2b91af">&#160;&#160; 20</span>&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160; };
  </p>
  
  <p style="margin: 0px">
    <span style="color: #2b91af">&#160;&#160; 21</span>&#160;
  </p>
  
  <p style="margin: 0px">
    <span style="color: #2b91af">&#160;&#160; 22</span>&#160;&#160;&#160;&#160; <span style="color: #ff8000">protected</span> <span style="color: #ff8000">static</span> <span style="color: #2b91af">ISaveChangesPresenter</span> presenter;
  </p>
  
  <p style="margin: 0px">
    <span style="color: #2b91af">&#160;&#160; 23</span>&#160;&#160;&#160;&#160; <span style="color: #ff8000">protected</span> <span style="color: #ff8000">static</span> <span style="color: yellow">SaveChangesView</span> save_changes_window;
  </p>
  
  <p style="margin: 0px">
    <span style="color: #2b91af">&#160;&#160; 24</span> }
  </p>
  
  <p style="margin: 0px">
    <span style="color: #2b91af">&#160;&#160; 25</span>&#160;
  </p>
  
  <p style="margin: 0px">
    <span style="color: #2b91af">&#160;&#160; 26</span>&#160;<span style="color: #ff8000">public</span> <span style="color: #ff8000">class</span> <span style="color: yellow">when_the_save_button_is_pressed</span> : <span style="color: yellow">when_prompted_to_save_changes_to_the_project</span>
  </p>
  
  <p style="margin: 0px">
    <span style="color: #2b91af">&#160;&#160; 27</span> {
  </p>
  
  <p style="margin: 0px">
    <span style="color: #2b91af">&#160;&#160; 28</span>&#160;&#160;&#160;&#160; <span style="color: #2b91af">it</span> should_save_the_current_project = () => presenter.was_told_to(x => x.save());
  </p>
  
  <p style="margin: 0px">
    <span style="color: #2b91af">&#160;&#160; 29</span>&#160;
  </p>
  
  <p style="margin: 0px">
    <span style="color: #2b91af">&#160;&#160; 30</span>&#160;&#160;&#160;&#160; <span style="color: #2b91af">because</span> b = () => save_changes_window.save_button.control_is(x => x.OnClick(<span style="color: #ff8000">new</span> <span style="color: yellow">EventArgs</span>()));
  </p>
  
  <p style="margin: 0px">
    <span style="color: #2b91af">&#160;&#160; 31</span> }
  </p>
  
  <p style="margin: 0px">
    <span style="color: #2b91af">&#160;&#160; 32</span>&#160;
  </p>
  
  <p style="margin: 0px">
    <span style="color: #2b91af">&#160;&#160; 33</span>&#160;<span style="color: #ff8000">public</span> <span style="color: #ff8000">class</span> <span style="color: yellow">when_the_cancel_button_is_pressed</span> : <span style="color: yellow">when_prompted_to_save_changes_to_the_project</span>
  </p>
  
  <p style="margin: 0px">
    <span style="color: #2b91af">&#160;&#160; 34</span> {
  </p>
  
  <p style="margin: 0px">
    <span style="color: #2b91af">&#160;&#160; 35</span>&#160;&#160;&#160;&#160; <span style="color: #2b91af">it</span> should_not_continue_processing_the_previous_action = () => presenter.was_told_to(x => x.cancel());
  </p>
  
  <p style="margin: 0px">
    <span style="color: #2b91af">&#160;&#160; 36</span>&#160;
  </p>
  
  <p style="margin: 0px">
    <span style="color: #2b91af">&#160;&#160; 37</span>&#160;&#160;&#160;&#160; <span style="color: #2b91af">because</span> b = () => save_changes_window.cancel_button.control_is(x => x.OnClick(<span style="color: #ff8000">new</span> <span style="color: yellow">EventArgs</span>()));
  </p>
  
  <p style="margin: 0px">
    <span style="color: #2b91af">&#160;&#160; 38</span> }
  </p>
  
  <p style="margin: 0px">
    <span style="color: #2b91af">&#160;&#160; 39</span>&#160;
  </p>
  
  <p style="margin: 0px">
    <span style="color: #2b91af">&#160;&#160; 40</span>&#160;<span style="color: #ff8000">public</span> <span style="color: #ff8000">class</span> <span style="color: yellow">when_the_do_not_save_button_is_pressed</span> : <span style="color: yellow">when_prompted_to_save_changes_to_the_project</span>
  </p>
  
  <p style="margin: 0px">
    <span style="color: #2b91af">&#160;&#160; 41</span> {
  </p>
  
  <p style="margin: 0px">
    <span style="color: #2b91af">&#160;&#160; 42</span>&#160;&#160;&#160;&#160; <span style="color: #2b91af">it</span> should_not_save_the_project = () => presenter.was_told_to(x => x.dont_save());
  </p>
  
  <p style="margin: 0px">
    <span style="color: #2b91af">&#160;&#160; 43</span>&#160;
  </p>
  
  <p style="margin: 0px">
    <span style="color: #2b91af">&#160;&#160; 44</span>&#160;&#160;&#160;&#160; <span style="color: #2b91af">because</span> b = () => save_changes_window.do_not_save_button.control_is(x => x.OnClick(<span style="color: #ff8000">new</span> <span style="color: yellow">EventArgs</span>()));
  </p>
  
  <p style="margin: 0px">
    <span style="color: #2b91af">&#160;&#160; 45</span> }
  </p></p>
</div>

&#160;

I hope this is slightly more soluble, then my [previous post](http://mokhan.ca/blog/2009/03/11/BDD+On+Steroids.aspx).