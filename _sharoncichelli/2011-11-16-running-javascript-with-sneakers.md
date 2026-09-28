---
wordpress_id: 65
title: 'Running JavaScript&#8230; With Sneakers!'
date: 2011-11-16T20:35:34+00:00
author: Sharon Cichelli
layout: post
wordpress_guid: http://lostechies.com/sharoncichelli/?p=65
dsq_thread_id:
  - "474562491"
categories:
  - Arduino
  - JavaScript
  - Refactoring
---
Code-review time. I haven&#8217;t written significant JavaScript in _forevs_, but I hit upon a use case well suited to it, had a blast coding it up, and am confident that I&#8217;ll be completely mystified by it three months from now. That is, unless we refactor it for maintainability (this is where you come in).

I&#8217;ll explain the use case. The [Couch-to-5K](http://www.coolrunning.com/engine/2/2_3/181.shtml) running plan is an excellent exercise regimen for learning to run. I followed it to successfully transform myself from sedentary software developer to 5K finisher. The runners among you know that five kilometers is a beginner-level distance; the sedentary software developers may find it as daunting as I once did. You train in intervals, alternating walking and running, gradually shifting the ratios to more running in successive workouts. If you can walk a moderate distance, following the program is totally doable (or modify it for easy walking/fast walking, if you&#8217;re not up for jogging). Definitely check it out.

The thing is, timing the intervals&mdash;especially at the beginning, where you&#8217;re alternating a minute of running with 90 seconds of walking&mdash;needs a complex timing device (a fancy runners watch), and if you&#8217;re using a treadmill, it is _really annoying_ to your fellow gym users, as your watch is beeping every minute or two. Or, well, maybe gym people don&#8217;t care, but it&#8217;s really annoying to me, since the dang thing is on my own wrist. For running indoors, I want a C25K timer that is tactile or visual. I&#8217;ve been thinking about an Arduino-powered timer that reads from a dip switch to determine which workout you&#8217;re running and signals the changes with a vibration motor (like in a cell phone). Thinking, and not so much doing. Finally one Sunday I forced myself to focus on the problem: what do you have, with a visual display, that is really small and runs code?

My [Nokia N810 internet tablet](http://en.wikipedia.org/wiki/Nokia_N810) has a web browser that runs JavaScript, can open html files stored locally, and can do this while also playing a podcast. Win!

Here&#8217;s what you _can&#8217;t_ do with JavaScript, though: Thread.Sleep(walkInterval). Instead, you use setTimeout() to say &#8220;execute this function _after_ this interval,&#8221; asynchronously. That&#8217;s the part that currently works but I daren&#8217;t touch it. In other words, that&#8217;s the part that needs your code review advice. Remember that the intended scenario is to rest the tablet on the treadmill&#8217;s magazine lip, so the app flashes the background of the page to catch my eye when I&#8217;m not looking directly at it. It&#8217;s high-contrast because it isn&#8217;t meant to be _watched_, just kept at hand, in my periphery.

If you choose to use the app (in addition to reviewing it), please only use it on a treadmill. Stay safe; don&#8217;t try to wrangle something you need to _look_ at while you&#8217;re on the trail.

The [Running Timer code](https://github.com/scichelli/RunningTimer) is on github. A representative sample is below. How would you make it better?

<pre class="brush:javascript">var exercise = function(setup) {
	var workout = getWorkout(setup.week, setup.day);
	doExercise(workout, 0);
}

var cooldown = function() {
	walk('Cool Down');
	window.setTimeout(function() { transition(function() { walk('Done!'); })}, 
		minToMilli(RT.cooldownDuration));
}

var doExercise = function(workout, i) {
	workout[i].mode();
	if (i === workout.length - 1) {
		window.setTimeout(function() { transition(cooldown) }, 
			minToMilli(workout[i].minutes));
	} else {
		window.setTimeout(function() { transition(function() { doExercise(workout, i + 1); })}, 
			minToMilli(workout[i].minutes));
	}
}

var getWorkout = function(week, day) {
	return eval('C25K.W' + week + 'D' + day);
}

var transition = function(callback) {
	var indicatorDiv = $('.runCountdown');
	var body = $(document.body);
	transitionBlink(6, indicatorDiv, body, callback);
}</pre>