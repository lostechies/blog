---
wordpress_id: 31
title: BDD on Steroids
date: 2009-03-11T20:41:36+00:00
author: Mo Khan
layout: post
wordpress_guid: /blogs/mokhan/archive/2009/03/11/bdd-on-steroids.aspx
categories:
  - TDD
  - Tools
redirect_from: "/blogs/mokhan/archive/2009/03/11/bdd-on-steroids.aspx/"
---
In the last couple of weeks I had a chance to sprinkle some of JP’s syntactic sugar, all over my projects. It’s amazing how much more concise my units test have become. I’ve had a couple of issues where I was mocking out the behavior of some Win Forms controls, but for the most part it’s been an awesome experience!

I just wanted to take a moment to say Thank you JP! I am enjoying using your [BDD (on steroids) extensions](http://subversion.assembla.com/svn/jpboodhoo_bdd/trunk/). If you haven’t already you need to check it out [here…](http://blog.jpboodhoo.com/developwithpassionbdd.aspx) NOW!

Maaad, maaaad props Mr. JP!

&#160;

<div style="font-size: 10pt;background: black;color: white;font-family: consolas">
  <p style="margin: 0px">
    <span style="color: #2b91af">&#160;&#160; 10</span>&#160;&#160;&#160;&#160; <span style="color: #ff8000">public</span> <span style="color: #ff8000">class</span> <span style="color: yellow">behaves_like_save_changes_view_bound_to_presenter</span> : <span style="color: yellow">concerns_for</span><<span style="color: yellow">SaveChangesView</span>>
  </p>
  
  <p style="margin: 0px">
    <span style="color: #2b91af">&#160;&#160; 11</span>&#160;&#160;&#160;&#160; {
  </p>
  
  <p style="margin: 0px">
    <span style="color: #2b91af">&#160;&#160; 12</span>&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160; <span style="color: #2b91af">context</span> c = () => { presenter = an<<span style="color: #2b91af">ISaveChangesPresenter</span>>(); };
  </p>
  
  <p style="margin: 0px">
    <span style="color: #2b91af">&#160;&#160; 13</span>&#160;
  </p>
  
  <p style="margin: 0px">
    <span style="color: #2b91af">&#160;&#160; 14</span>&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160; <span style="color: #2b91af">because</span> b = () => sut.attach_to(presenter);
  </p>
  
  <p style="margin: 0px">
    <span style="color: #2b91af">&#160;&#160; 15</span>&#160;
  </p>
  
  <p style="margin: 0px">
    <span style="color: #2b91af">&#160;&#160; 16</span>&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160; <span style="color: #ff8000">static</span> <span style="color: #ff8000">protected</span> <span style="color: #2b91af">ISaveChangesPresenter</span> presenter;
  </p>
  
  <p style="margin: 0px">
    <span style="color: #2b91af">&#160;&#160; 17</span>&#160;&#160;&#160;&#160; }
  </p>
  
  <p style="margin: 0px">
    <span style="color: #2b91af">&#160;&#160; 18</span>&#160;
  </p>
  
  <p style="margin: 0px">
    <span style="color: #2b91af">&#160;&#160; 19</span>&#160;&#160;&#160;&#160; <span style="color: #ff8000">public</span> <span style="color: #ff8000">class</span> <span style="color: yellow">when_the_save_button_is_clicked</span> : <span style="color: yellow">behaves_like_save_changes_view_bound_to_presenter</span>
  </p>
  
  <p style="margin: 0px">
    <span style="color: #2b91af">&#160;&#160; 20</span>&#160;&#160;&#160;&#160; {
  </p>
  
  <p style="margin: 0px">
    <span style="color: #2b91af">&#160;&#160; 21</span>&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160; <span style="color: #2b91af">it</span> should_forward_the_call_to_the_presenter = () => presenter.was_told_to(x => x.save());
  </p>
  
  <p style="margin: 0px">
    <span style="color: #2b91af">&#160;&#160; 22</span>&#160;
  </p>
  
  <p style="margin: 0px">
    <span style="color: #2b91af">&#160;&#160; 23</span>&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160; <span style="color: #2b91af">because</span> b = () => <span style="color: yellow">EventTrigger</span>.trigger_event<<span style="color: yellow">Events</span>.<span style="color: #2b91af">ControlEvents</span>>(
  </p>
  
  <p style="margin: 0px">
    <span style="color: #2b91af">&#160;&#160; 24</span>&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160; x => x.OnClick(<span style="color: #ff8000">new</span> <span style="color: yellow">EventArgs</span>()),
  </p>
  
  <p style="margin: 0px">
    <span style="color: #2b91af">&#160;&#160; 25</span>&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160; sut.ux_save_button
  </p>
  
  <p style="margin: 0px">
    <span style="color: #2b91af">&#160;&#160; 26</span>&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160; );
  </p>
  
  <p style="margin: 0px">
    <span style="color: #2b91af">&#160;&#160; 27</span>&#160;&#160;&#160;&#160; }
  </p>
  
  <p style="margin: 0px">
    <span style="color: #2b91af">&#160;&#160; 28</span>&#160;
  </p>
  
  <p style="margin: 0px">
    <span style="color: #2b91af">&#160;&#160; 29</span>&#160;&#160;&#160;&#160; <span style="color: #ff8000">public</span> <span style="color: #ff8000">class</span> <span style="color: yellow">when_the_cancel_button_is_clicked</span> : <span style="color: yellow">behaves_like_save_changes_view_bound_to_presenter</span>
  </p>
  
  <p style="margin: 0px">
    <span style="color: #2b91af">&#160;&#160; 30</span>&#160;&#160;&#160;&#160; {
  </p>
  
  <p style="margin: 0px">
    <span style="color: #2b91af">&#160;&#160; 31</span>&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160; <span style="color: #2b91af">it</span> should_forward_the_call_to_the_presenter = () => presenter.was_told_to(x => x.cancel());
  </p>
  
  <p style="margin: 0px">
    <span style="color: #2b91af">&#160;&#160; 32</span>&#160;
  </p>
  
  <p style="margin: 0px">
    <span style="color: #2b91af">&#160;&#160; 33</span>&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160; <span style="color: #2b91af">because</span> b = () => <span style="color: yellow">EventTrigger</span>.trigger_event<<span style="color: yellow">Events</span>.<span style="color: #2b91af">ControlEvents</span>>(
  </p>
  
  <p style="margin: 0px">
    <span style="color: #2b91af">&#160;&#160; 34</span>&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160; x => x.OnClick(<span style="color: #ff8000">new</span> <span style="color: yellow">EventArgs</span>()),
  </p>
  
  <p style="margin: 0px">
    <span style="color: #2b91af">&#160;&#160; 35</span>&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160; sut.ux_cancel_button
  </p>
  
  <p style="margin: 0px">
    <span style="color: #2b91af">&#160;&#160; 36</span>&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160; );
  </p>
  
  <p style="margin: 0px">
    <span style="color: #2b91af">&#160;&#160; 37</span>&#160;&#160;&#160;&#160; }
  </p>
  
  <p style="margin: 0px">
    <span style="color: #2b91af">&#160;&#160; 38</span>&#160;
  </p>
  
  <p style="margin: 0px">
    <span style="color: #2b91af">&#160;&#160; 39</span>&#160;&#160;&#160;&#160; <span style="color: #ff8000">public</span> <span style="color: #ff8000">class</span> <span style="color: yellow">when_the_do_not_save_button_is_clicked</span> : <span style="color: yellow">behaves_like_save_changes_view_bound_to_presenter</span>
  </p>
  
  <p style="margin: 0px">
    <span style="color: #2b91af">&#160;&#160; 40</span>&#160;&#160;&#160;&#160; {
  </p>
  
  <p style="margin: 0px">
    <span style="color: #2b91af">&#160;&#160; 41</span>&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160; <span style="color: #2b91af">it</span> should_forward_the_call_to_the_presenter = () => presenter.was_told_to(x => x.dont_save());
  </p>
  
  <p style="margin: 0px">
    <span style="color: #2b91af">&#160;&#160; 42</span>&#160;
  </p>
  
  <p style="margin: 0px">
    <span style="color: #2b91af">&#160;&#160; 43</span>&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160; <span style="color: #2b91af">because</span> b = () => <span style="color: yellow">EventTrigger</span>.trigger_event<<span style="color: yellow">Events</span>.<span style="color: #2b91af">ControlEvents</span>>(
  </p>
  
  <p style="margin: 0px">
    <span style="color: #2b91af">&#160;&#160; 44</span>&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160; x => x.OnClick(<span style="color: #ff8000">new</span> <span style="color: yellow">EventArgs</span>()),
  </p>
  
  <p style="margin: 0px">
    <span style="color: #2b91af">&#160;&#160; 45</span>&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160; sut.ux_do_not_save_button
  </p>
  
  <p style="margin: 0px">
    <span style="color: #2b91af">&#160;&#160; 46</span>&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160; );
  </p>
  
  <p style="margin: 0px">
    <span style="color: #2b91af">&#160;&#160; 47</span>&#160;&#160;&#160;&#160; }
  </p></p>
</div>