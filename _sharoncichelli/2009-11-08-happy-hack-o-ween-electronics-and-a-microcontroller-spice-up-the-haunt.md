---
wordpress_id: 3859
title: 'Happy Hack-o-ween: Electronics and a microcontroller spice up the haunt'
date: 2009-11-08T16:27:00+00:00
author: Sharon Cichelli
layout: post
wordpress_guid: /blogs/sharoncichelli/archive/2009/11/08/happy-hack-o-ween-electronics-and-a-microcontroller-spice-up-the-haunt.aspx
dsq_thread_id:
  - "307177120"
categories:
  - Arduino
  - electronics
redirect_from: "/blogs/sharoncichelli/archive/2009/11/08/happy-hack-o-ween-electronics-and-a-microcontroller-spice-up-the-haunt.aspx/"
---
Ah, Halloween, when a young woman&#8217;s fancy turns to love. And zombies.

I had two personal requirements for the costume I would build this year:

  1. It shall be spooky.
  2. It shall blink.

I&#8217;ll tell you about the final result, the electronics and the software that went into it, plus the techniques I used to achieve wearable electronics. I&#8217;ll introduce you to the [Arduino](http://www.arduino.cc/), an open-source microcontroller prototyping platform, which is an exhilarating tool/toy for making your software skills manifest in the physical world.

My husband and I have been teaching ourselves electronics. A few months ago, Dad taught me to solder. I recently read Syuzi Pakhchyan&#8217;s excellent primer on wearable electronics and smart materials, [_Fashioning Technology_](http://www.librarything.com/work/5874825/book/47829579). And I&#8217;ve been [making things](http://blog.makezine.com/archive/2009/10/ambient_led_flowerpot_clock.html) with my Arduino. All these ideas were swirling and combining in my head to inspire this year&#8217;s Halloween project. Er, _costume_. Same difference.

What was I? I was a nightmare&#8230; the thing under your bed&#8230; the reason for your well developed sense of paranoia&#8230;
  
[<img src="http://farm3.static.flickr.com/2609/4076005063_851a85338f_m.jpg" width="161" height="240" alt="The thing under your bed" />](http://www.flickr.com/photos/spyderella/sets/72157622735987434/)

I sported a crop of writhing eyeballs erupting from my head. Each eyeball has an LED inside it, and they blink randomly and independently, until I trigger a hidden switch, which causes the blinky ones to go dark and two red eyes to pulse menacingly. In the [Flickr photoset](http://www.flickr.com/photos/spyderella/sets/72157622735987434/), you can see the construction process.

## The Arduino Sketch

The term &#8220;Arduino&#8221; is overloaded to mean:

  1. a particular chip and circuit board which you can buy or build;
  2. the IDE in which you write programs for the chip;
  3. the language, which is C-flavored;
  4. fun.

Arduino programs are called sketches. Every sketch must contain two functions: setup (runs once) and loop (runs continuously). Here&#8217;s my sketch, with extra explanatory comments, that blinks the six regular eyeballs and responds to the switch by pulsing the red eyeballs.

<div style="font-family: Courier New;font-size: 8pt;color: black;background: white;border: 1px solid #ccc;overflow: auto;width: 600px;height: 400px">
  <pre style="margin: 0px"><span style="color: #2b91af">&nbsp;&nbsp;&nbsp;&nbsp;1</span>&nbsp;<span style="color: blue">#define</span> SWITCH 8</pre>
  
  <pre style="margin: 0px"><span style="color: #2b91af">&nbsp;&nbsp;&nbsp;&nbsp;2</span>&nbsp;<span style="color: blue">int</span> ledPins[] = {2, 3, 4, 5, 6, 7};</pre>
  
  <pre style="margin: 0px"><span style="color: #2b91af">&nbsp;&nbsp;&nbsp;&nbsp;3</span>&nbsp;<span style="color: blue">const</span> <span style="color: blue">int</span> ledPinsCount = 6;</pre>
  
  <pre style="margin: 0px"><span style="color: #2b91af">&nbsp;&nbsp;&nbsp;&nbsp;4</span>&nbsp;<span style="color: blue">int</span> redEyePins[] = {10, 11};</pre>
  
  <pre style="margin: 0px"><span style="color: #2b91af">&nbsp;&nbsp;&nbsp;&nbsp;5</span>&nbsp;<span style="color: blue">const</span> <span style="color: blue">int</span> redEyePinsCount = 2;</pre>
  
  <pre style="margin: 0px"><span style="color: #2b91af">&nbsp;&nbsp;&nbsp;&nbsp;6</span>&nbsp;<span style="color: blue">long</span> durations[ledPinsCount];</pre>
  
  <pre style="margin: 0px"><span style="color: #2b91af">&nbsp;&nbsp;&nbsp;&nbsp;7</span>&nbsp;<span style="color: blue">int</span> ledStates[ledPinsCount];</pre>
  
  <pre style="margin: 0px"><span style="color: #2b91af">&nbsp;&nbsp;&nbsp;&nbsp;8</span>&nbsp;<span style="color: blue">long</span> previousTimes[ledPinsCount];</pre>
  
  <pre style="margin: 0px"><span style="color: #2b91af">&nbsp;&nbsp;&nbsp;&nbsp;9</span>&nbsp;<span style="color: blue">int</span> i;</pre>
  
  <pre style="margin: 0px"><span style="color: #2b91af">&nbsp;&nbsp;&nbsp;10</span>&nbsp;</pre>
  
  <pre style="margin: 0px"><span style="color: #2b91af">&nbsp;&nbsp;&nbsp;11</span>&nbsp;<span style="color: blue">void</span> setup()</pre>
  
  <pre style="margin: 0px"><span style="color: #2b91af">&nbsp;&nbsp;&nbsp;12</span>&nbsp;{</pre>
  
  <pre style="margin: 0px"><span style="color: #2b91af">&nbsp;&nbsp;&nbsp;13</span>&nbsp;&nbsp; pinMode(SWITCH, INPUT); <span style="color: green">//Specify the switch pin as an input.</span></pre>
  
  <pre style="margin: 0px"><span style="color: #2b91af">&nbsp;&nbsp;&nbsp;14</span>&nbsp;</pre>
  
  <pre style="margin: 0px"><span style="color: #2b91af">&nbsp;&nbsp;&nbsp;15</span>&nbsp;&nbsp; <span style="color: blue">for</span> (i = 0; i &lt; redEyePinsCount; i++)</pre>
  
  <pre style="margin: 0px"><span style="color: #2b91af">&nbsp;&nbsp;&nbsp;16</span>&nbsp;&nbsp; {</pre>
  
  <pre style="margin: 0px"><span style="color: #2b91af">&nbsp;&nbsp;&nbsp;17</span>&nbsp;&nbsp; &nbsp; pinMode(redEyePins[i], OUTPUT); <span style="color: green">//Specify each red-eye LED pin as an output.</span></pre>
  
  <pre style="margin: 0px"><span style="color: #2b91af">&nbsp;&nbsp;&nbsp;18</span>&nbsp;&nbsp; }</pre>
  
  <pre style="margin: 0px"><span style="color: #2b91af">&nbsp;&nbsp;&nbsp;19</span>&nbsp;</pre>
  
  <pre style="margin: 0px"><span style="color: #2b91af">&nbsp;&nbsp;&nbsp;20</span>&nbsp;&nbsp; <span style="color: blue">for</span>(i = 0; i &lt; ledPinsCount; i++)</pre>
  
  <pre style="margin: 0px"><span style="color: #2b91af">&nbsp;&nbsp;&nbsp;21</span>&nbsp;&nbsp; {</pre>
  
  <pre style="margin: 0px"><span style="color: #2b91af">&nbsp;&nbsp;&nbsp;22</span>&nbsp;&nbsp; &nbsp; pinMode(ledPins[i], OUTPUT); <span style="color: green">//Specify each regular LED pin as an output.</span></pre>
  
  <pre style="margin: 0px"><span style="color: #2b91af">&nbsp;&nbsp;&nbsp;23</span>&nbsp;&nbsp; &nbsp; ledStates[i] = random(1); <span style="color: green">//Randomly set the LEDs to on or off (1 or 0).</span></pre>
  
  <pre style="margin: 0px"><span style="color: #2b91af">&nbsp;&nbsp;&nbsp;24</span>&nbsp;&nbsp; &nbsp; durations[i] = GetRandomDuration(); <span style="color: green">//Define a random duration for each LED to stay in that state.</span></pre>
  
  <pre style="margin: 0px"><span style="color: #2b91af">&nbsp;&nbsp;&nbsp;25</span>&nbsp;&nbsp; &nbsp; previousTimes[i] = 0; <span style="color: green">//At time of setup, the "last time we changed" is at 0 milliseconds, the start of time.</span></pre>
  
  <pre style="margin: 0px"><span style="color: #2b91af">&nbsp;&nbsp;&nbsp;26</span>&nbsp;&nbsp; }</pre>
  
  <pre style="margin: 0px"><span style="color: #2b91af">&nbsp;&nbsp;&nbsp;27</span>&nbsp;}</pre>
  
  <pre style="margin: 0px"><span style="color: #2b91af">&nbsp;&nbsp;&nbsp;28</span>&nbsp;</pre>
  
  <pre style="margin: 0px"><span style="color: #2b91af">&nbsp;&nbsp;&nbsp;29</span>&nbsp;<span style="color: blue">void</span> loop()</pre>
  
  <pre style="margin: 0px"><span style="color: #2b91af">&nbsp;&nbsp;&nbsp;30</span>&nbsp;{</pre>
  
  <pre style="margin: 0px"><span style="color: #2b91af">&nbsp;&nbsp;&nbsp;31</span>&nbsp;&nbsp; <span style="color: blue">if</span> (digitalRead(SWITCH) == HIGH)</pre>
  
  <pre style="margin: 0px"><span style="color: #2b91af">&nbsp;&nbsp;&nbsp;32</span>&nbsp;&nbsp; {</pre>
  
  <pre style="margin: 0px"><span style="color: #2b91af">&nbsp;&nbsp;&nbsp;33</span>&nbsp;&nbsp; &nbsp; TurnOffLeds();</pre>
  
  <pre style="margin: 0px"><span style="color: #2b91af">&nbsp;&nbsp;&nbsp;34</span>&nbsp;&nbsp; &nbsp; PulseRedEyes();</pre>
  
  <pre style="margin: 0px"><span style="color: #2b91af">&nbsp;&nbsp;&nbsp;35</span>&nbsp;&nbsp; }</pre>
  
  <pre style="margin: 0px"><span style="color: #2b91af">&nbsp;&nbsp;&nbsp;36</span>&nbsp;&nbsp; <span style="color: blue">else</span></pre>
  
  <pre style="margin: 0px"><span style="color: #2b91af">&nbsp;&nbsp;&nbsp;37</span>&nbsp;&nbsp; {</pre>
  
  <pre style="margin: 0px"><span style="color: #2b91af">&nbsp;&nbsp;&nbsp;38</span>&nbsp;&nbsp; &nbsp; <span style="color: blue">for</span>(i = 0; i &lt; redEyePinsCount; i++)</pre>
  
  <pre style="margin: 0px"><span style="color: #2b91af">&nbsp;&nbsp;&nbsp;39</span>&nbsp;&nbsp; &nbsp; {</pre>
  
  <pre style="margin: 0px"><span style="color: #2b91af">&nbsp;&nbsp;&nbsp;40</span>&nbsp;&nbsp; &nbsp; &nbsp; digitalWrite(redEyePins[i], LOW); <span style="color: green">//Turn the red eyes all the way off.</span></pre>
  
  <pre style="margin: 0px"><span style="color: #2b91af">&nbsp;&nbsp;&nbsp;41</span>&nbsp;&nbsp; &nbsp; }</pre>
  
  <pre style="margin: 0px"><span style="color: #2b91af">&nbsp;&nbsp;&nbsp;42</span>&nbsp;</pre>
  
  <pre style="margin: 0px"><span style="color: #2b91af">&nbsp;&nbsp;&nbsp;43</span>&nbsp;&nbsp; &nbsp; <span style="color: blue">for</span>(i = 0; i &lt; ledPinsCount; i++) <span style="color: green">//For each LED:</span></pre>
  
  <pre style="margin: 0px"><span style="color: #2b91af">&nbsp;&nbsp;&nbsp;44</span>&nbsp;&nbsp; &nbsp; {</pre>
  
  <pre style="margin: 0px"><span style="color: #2b91af">&nbsp;&nbsp;&nbsp;45</span>&nbsp;&nbsp; &nbsp; &nbsp; <span style="color: blue">if</span> (millis() - previousTimes[i] &gt; durations[i])</pre>
  
  <pre style="margin: 0px"><span style="color: #2b91af">&nbsp;&nbsp;&nbsp;46</span>&nbsp;&nbsp; &nbsp; &nbsp; {</pre>
  
  <pre style="margin: 0px"><span style="color: #2b91af">&nbsp;&nbsp;&nbsp;47</span>&nbsp;&nbsp; &nbsp; &nbsp; &nbsp; ChangeLed(i); <span style="color: green">//If this one's duration is up, then flip it.</span></pre>
  
  <pre style="margin: 0px"><span style="color: #2b91af">&nbsp;&nbsp;&nbsp;48</span>&nbsp;&nbsp; &nbsp; &nbsp; }</pre>
  
  <pre style="margin: 0px"><span style="color: #2b91af">&nbsp;&nbsp;&nbsp;49</span>&nbsp;&nbsp; &nbsp; }</pre>
  
  <pre style="margin: 0px"><span style="color: #2b91af">&nbsp;&nbsp;&nbsp;50</span>&nbsp;&nbsp; }</pre>
  
  <pre style="margin: 0px"><span style="color: #2b91af">&nbsp;&nbsp;&nbsp;51</span>&nbsp;}</pre>
  
  <pre style="margin: 0px"><span style="color: #2b91af">&nbsp;&nbsp;&nbsp;52</span>&nbsp;</pre>
  
  <pre style="margin: 0px"><span style="color: #2b91af">&nbsp;&nbsp;&nbsp;53</span>&nbsp;<span style="color: blue">void</span> TurnOffLeds()</pre>
  
  <pre style="margin: 0px"><span style="color: #2b91af">&nbsp;&nbsp;&nbsp;54</span>&nbsp;{</pre>
  
  <pre style="margin: 0px"><span style="color: #2b91af">&nbsp;&nbsp;&nbsp;55</span>&nbsp;&nbsp; <span style="color: blue">for</span>(i = 0; i &lt; ledPinsCount; i++)</pre>
  
  <pre style="margin: 0px"><span style="color: #2b91af">&nbsp;&nbsp;&nbsp;56</span>&nbsp;&nbsp; {</pre>
  
  <pre style="margin: 0px"><span style="color: #2b91af">&nbsp;&nbsp;&nbsp;57</span>&nbsp;&nbsp; &nbsp; digitalWrite(ledPins[i], LOW);</pre>
  
  <pre style="margin: 0px"><span style="color: #2b91af">&nbsp;&nbsp;&nbsp;58</span>&nbsp;&nbsp; }</pre>
  
  <pre style="margin: 0px"><span style="color: #2b91af">&nbsp;&nbsp;&nbsp;59</span>&nbsp;}</pre>
  
  <pre style="margin: 0px"><span style="color: #2b91af">&nbsp;&nbsp;&nbsp;60</span>&nbsp;</pre>
  
  <pre style="margin: 0px"><span style="color: #2b91af">&nbsp;&nbsp;&nbsp;61</span>&nbsp;<span style="color: blue">void</span> PulseRedEyes()</pre>
  
  <pre style="margin: 0px"><span style="color: #2b91af">&nbsp;&nbsp;&nbsp;62</span>&nbsp;{</pre>
  
  <pre style="margin: 0px"><span style="color: #2b91af">&nbsp;&nbsp;&nbsp;63</span>&nbsp;&nbsp; <span style="color: green">//Fade on, then off.</span></pre>
  
  <pre style="margin: 0px"><span style="color: #2b91af">&nbsp;&nbsp;&nbsp;64</span>&nbsp;&nbsp; <span style="color: blue">int</span> j;</pre>
  
  <pre style="margin: 0px"><span style="color: #2b91af">&nbsp;&nbsp;&nbsp;65</span>&nbsp;&nbsp; <span style="color: blue">for</span>(j = 0; j &lt; 255; j+=5)</pre>
  
  <pre style="margin: 0px"><span style="color: #2b91af">&nbsp;&nbsp;&nbsp;66</span>&nbsp;&nbsp; {</pre>
  
  <pre style="margin: 0px"><span style="color: #2b91af">&nbsp;&nbsp;&nbsp;67</span>&nbsp;&nbsp; &nbsp; <span style="color: blue">for</span>(i = 0; i &lt; redEyePinsCount; i++)</pre>
  
  <pre style="margin: 0px"><span style="color: #2b91af">&nbsp;&nbsp;&nbsp;68</span>&nbsp;&nbsp; &nbsp; {</pre>
  
  <pre style="margin: 0px"><span style="color: #2b91af">&nbsp;&nbsp;&nbsp;69</span>&nbsp;&nbsp; &nbsp; &nbsp; analogWrite(redEyePins[i], j);</pre>
  
  <pre style="margin: 0px"><span style="color: #2b91af">&nbsp;&nbsp;&nbsp;70</span>&nbsp;&nbsp; &nbsp; &nbsp; delay(10);</pre>
  
  <pre style="margin: 0px"><span style="color: #2b91af">&nbsp;&nbsp;&nbsp;71</span>&nbsp;&nbsp; &nbsp; }</pre>
  
  <pre style="margin: 0px"><span style="color: #2b91af">&nbsp;&nbsp;&nbsp;72</span>&nbsp;&nbsp; }</pre>
  
  <pre style="margin: 0px"><span style="color: #2b91af">&nbsp;&nbsp;&nbsp;73</span>&nbsp;&nbsp; <span style="color: blue">for</span>(j = 255; j &gt; 0; j-=5)</pre>
  
  <pre style="margin: 0px"><span style="color: #2b91af">&nbsp;&nbsp;&nbsp;74</span>&nbsp;&nbsp; {</pre>
  
  <pre style="margin: 0px"><span style="color: #2b91af">&nbsp;&nbsp;&nbsp;75</span>&nbsp;&nbsp; &nbsp; <span style="color: blue">for</span>(i = 0; i &lt; redEyePinsCount; i++)</pre>
  
  <pre style="margin: 0px"><span style="color: #2b91af">&nbsp;&nbsp;&nbsp;76</span>&nbsp;&nbsp; &nbsp; {</pre>
  
  <pre style="margin: 0px"><span style="color: #2b91af">&nbsp;&nbsp;&nbsp;77</span>&nbsp;&nbsp; &nbsp; &nbsp; analogWrite(redEyePins[i], j);</pre>
  
  <pre style="margin: 0px"><span style="color: #2b91af">&nbsp;&nbsp;&nbsp;78</span>&nbsp;&nbsp; &nbsp; &nbsp; delay(10);</pre>
  
  <pre style="margin: 0px"><span style="color: #2b91af">&nbsp;&nbsp;&nbsp;79</span>&nbsp;&nbsp; &nbsp; }</pre>
  
  <pre style="margin: 0px"><span style="color: #2b91af">&nbsp;&nbsp;&nbsp;80</span>&nbsp;&nbsp; }</pre>
  
  <pre style="margin: 0px"><span style="color: #2b91af">&nbsp;&nbsp;&nbsp;81</span>&nbsp;}</pre>
  
  <pre style="margin: 0px"><span style="color: #2b91af">&nbsp;&nbsp;&nbsp;82</span>&nbsp;</pre>
  
  <pre style="margin: 0px"><span style="color: #2b91af">&nbsp;&nbsp;&nbsp;83</span>&nbsp;<span style="color: blue">void</span> ChangeLed(<span style="color: blue">int</span> ledPin)</pre>
  
  <pre style="margin: 0px"><span style="color: #2b91af">&nbsp;&nbsp;&nbsp;84</span>&nbsp;{</pre>
  
  <pre style="margin: 0px"><span style="color: #2b91af">&nbsp;&nbsp;&nbsp;85</span>&nbsp;&nbsp; previousTimes[ledPin] = millis(); <span style="color: green">//Update the "last time we changed" to now.</span></pre>
  
  <pre style="margin: 0px"><span style="color: #2b91af">&nbsp;&nbsp;&nbsp;86</span>&nbsp;&nbsp; durations[ledPin] = GetRandomDuration(); <span style="color: green">//Give it a new random duration.</span></pre>
  
  <pre style="margin: 0px"><span style="color: #2b91af">&nbsp;&nbsp;&nbsp;87</span>&nbsp;&nbsp; ledStates[ledPin] = 1 - ledStates[ledPin]; <span style="color: green">//Flip the state between on and off.</span></pre>
  
  <pre style="margin: 0px"><span style="color: #2b91af">&nbsp;&nbsp;&nbsp;88</span>&nbsp;&nbsp; digitalWrite(ledPins[ledPin], ledStates[ledPin]); <span style="color: green">//Set the LED to that state.</span></pre>
  
  <pre style="margin: 0px"><span style="color: #2b91af">&nbsp;&nbsp;&nbsp;89</span>&nbsp;}</pre>
  
  <pre style="margin: 0px"><span style="color: #2b91af">&nbsp;&nbsp;&nbsp;90</span>&nbsp;</pre>
  
  <pre style="margin: 0px"><span style="color: #2b91af">&nbsp;&nbsp;&nbsp;91</span>&nbsp;<span style="color: blue">long</span> GetRandomDuration()</pre>
  
  <pre style="margin: 0px"><span style="color: #2b91af">&nbsp;&nbsp;&nbsp;92</span>&nbsp;{</pre>
  
  <pre style="margin: 0px"><span style="color: #2b91af">&nbsp;&nbsp;&nbsp;93</span>&nbsp;&nbsp; <span style="color: green">//Random number between 1 and 10, then multiplied by 400 to give it a detectable duration.</span></pre>
  
  <pre style="margin: 0px"><span style="color: #2b91af">&nbsp;&nbsp;&nbsp;94</span>&nbsp;&nbsp; <span style="color: blue">return</span> random(1, 10) * 400;</pre>
  
  <pre style="margin: 0px"><span style="color: #2b91af">&nbsp;&nbsp;&nbsp;95</span>&nbsp;}</pre>
</div>

I like the way the eyes blink independently. If they all flashed in unison, they would look like Christmas lights, and you would notice that two were &#8220;special&#8221; because they weren&#8217;t flashing. Instead, the duration that any given eyeball is lit or dark constantly changes.

The blinking is managed by a collection of arrays. One array represents each of my LED pins, so that I can address them in a for loop. The three other arrays hold: the state (on/off) of each LED; the duration each LED should stay in that state; the reading from the millisecond counter when the LED last flipped its state. Each time the loop function executes, if the switch is not connected, then I look at each LED; if the difference between the current time and the time when it previously changed is greater than its duration, flip its state (from off to on, or from on to off), randomly assign it a new duration, and record &#8220;now&#8221; as the new &#8220;previously changed&#8221; time. If the switch _is_ connected, then I make the red eyes fade on and fade off.

## Fading with PWM

PWM (Pulse-Width Modulation) is a technique for making a digital component (one that turns on or off) simulate analog behavior (be a little bit on, and then a little bit more on). If you turn an LED off and on really quickly, you won&#8217;t perceive the flickering, but it will look half as bright, because it is actually off for half the time. If you let it spend a little more time off than on, it will appear even dimmer. So by varying the width of the pulses, you can control how bright the LED looks.

The Arduino comes with built-in PWM functions; some pins are already set up to be PWM pins. If you plug an LED into one of the PWM pins, then you can write to it as if it were an analog component. That&#8217;s why, in my sketch above, I set the brightness of the red eyes using _analogWrite()_, instead of digitalWrite(). My for loop increments the counter j from 0 to 255, and sets the brightness of both red eyes to the value of j. The Arduino takes care of (imperceptibly) flickering the LEDs with the right ratio of on-time and off-time to achieve a j amount of brightness. So the eyes get gradually brighter, then gradually dimmer. (Then control returns to the main loop function, but if my switch is still connected, the red eyes will throb again.)

## Snaps: Wearable Plugs

A metal sewable snap is like a plug for your clothing, an interface between the world of textiles and the world of wires. This is handy when you need the electronics to be separate while you are getting into the clothing, or if you want to wash the clothing. My Arduino hung out at the base of my neck, to be near the LEDs on my head but hidden underneath my wig, but my control switch was near my hip. I could have run a wire down to the switch, but conductive thread was more subtle and more comfortable.

To complete the connection, I soldered a short wire to one side of the snap. That wire plugged into a pin on the Arduino. The conductive thread ran from the switch at my hip up to the back of my dress near the Arduino, and I sewed that conductive thread to the other half of the snap. When the two halves are snapped together, the wire and the thread make a complete connection, as if they were one continuous wire.
  
[<img src="http://farm3.static.flickr.com/2584/4085497865_a50e4e45d1_m.jpg" width="240" height="180" alt="Soldered snaps / Sewn snaps" />](http://www.flickr.com/photos/spyderella/4085497865/ "Soldered snaps / Sewn snaps by Spyderella, on Flickr")

I had two threads (going out to the switch and back), so I encased them each in a bias tape tube, to prevent them from touching each other and shorting out.

I&#8217;ve been saying &#8220;switch,&#8221; but actually, I simplified at the 11th hour. I tied each thread around a safety pin, and stuck the pins to my dress. When the safety pins touched each other, they completed the circuit, which the Arduino sketch interpreted as triggering the switch&mdash;cue red-eye glare.

## What&#8217;s Next

Soldering and sewing are both liberating skills to possess&mdash;they free up your creativity to make wilder and more integrated stuff. If you are currently proficient with only one, ask around and see if you can find a buddy who&#8217;s good at the other, and teach each other.

The Arduino comes with a great community of hackers and makers, lots of people to learn from and collaborate with. Definitely check it out. There is lots of fun to be had, and blinking LEDs is the barest beginning of what it can do.