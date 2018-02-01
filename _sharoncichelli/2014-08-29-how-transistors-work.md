---
id: 319
title: 'How transistors work: Illustrated'
date: 2014-08-29T09:54:48+00:00
author: Sharon Cichelli
layout: post
guid: http://lostechies.com/sharoncichelli/?p=319
dsq_thread_id:
  - "2969978574"
categories:
  - Uncategorized
---
After fruitless searches in electronics books, electrical engineering textbooks, even physics, trying to find a way to _understand_ transistors (not just [where to put one in a circuit](http://en.wikipedia.org/wiki/Transistor#Simplified_operation)), I stumbled upon the answer when I wasn&#8217;t looking for it. 

Chemistry. The answer is in chemistry. Specifically, it is in [The Joy of Chemistry](http://www.amazon.com/The-Joy-Chemistry-Amazing-Familiar-ebook/dp/B004F9QGTQ/) by Cathy Cobb and Monty L. Fetterolf. 

I draw pictures when I want to understand something, so here you go.

One way to [imagine an atom](http://en.wikipedia.org/wiki/Bohr_model) looks like a solar system, with a positive nucleus at the center, orbited by negatively charged electrons in discrete shells, with rules about how many electrons can go in each shell. The periodic table is laid out according to this idea. As you march to the right, each atom has one more electron in its outermost shell, until you hit a big ol&#8217; carriage return and start filling the next shell.

The outermost electron shell of an atom is called its valence shell, and how full it is determines the chemical properties of the atom.

<p style="text-align:center;">
  <a href="http://clayvessel.org/clayvessel/wp-content/uploads/2014/08/transistor001.png"><img src="http://clayvessel.org/clayvessel/wp-content/uploads/2014/08/transistor001.png" alt="Oxygen has room for two more electrons in its valence shell. Hydrogen has one electron; a second would fill its shell." title="Atoms share electrons to fill their valence shells." width="450" style="box-shadow: 7px 7px 5px 0px rgba(50, 50, 50, 0.58);" /></a>
</p>

An atom with a filled valence shell is stable and inert. The noble gases, the rightmost column of the periodic table, sit where they are and behave the way they do because their valence shells are filled. Atoms without a filled outer shell will swap and share electrons with other atoms to get to that state.

<p style="text-align:center;">
  <a href="http://clayvessel.org/clayvessel/wp-content/uploads/2014/08/transistor002.png"><img src="http://clayvessel.org/clayvessel/wp-content/uploads/2014/08/transistor002.png" alt="One oxygen atom and two hydrogen atoms share electrons to make a molecule of water." title="When atoms share electrons, their bond is called a covalent bond." width="450" style="box-shadow: 7px 7px 5px 0px rgba(50, 50, 50, 0.58);" /></a>
</p>

When atoms _swap_ electrons and then stick to each other like oppositely charged magnets, that&#8217;s an ionic bond. When they share electrons, it&#8217;s called a covalent bond (as in, co-sharing valence electrons).

Copper is interesting.

<p style="text-align:center;">
  <a href="http://clayvessel.org/clayvessel/wp-content/uploads/2014/08/transistor003.png"><img src="http://clayvessel.org/clayvessel/wp-content/uploads/2014/08/transistor003.png" alt="Copper has three filled shells, plus one lone electron starting a fourth shell." title="Copper has three filled shells, plus one lone electron starting a fourth shell" width="450" style="box-shadow: 7px 7px 5px 0px rgba(50, 50, 50, 0.58);" /></a>
</p>

For one thing, it&#8217;s a metal, so that means it&#8217;s shiny, bendy, and ready to make metallic bonds. (That&#8217;s the third kind of bond.) Metallic bonds are like covalent bonds, only a whole lot more so.

<p style="text-align:center;">
  <a href="http://clayvessel.org/clayvessel/wp-content/uploads/2014/08/transistor004.png"><img src="http://clayvessel.org/clayvessel/wp-content/uploads/2014/08/transistor004.png" alt="Many copper atoms together share electrons so readily, the electrons form a conduction band encompassing all the atoms. This makes copper a great conductor of electricity." title="Copper atoms share electrons with each other to form a conduction band" width="450" style="box-shadow: 7px 7px 5px 0px rgba(50, 50, 50, 0.58);" /></a>
</p>

When many copper atoms get together, they share electrons so readily the electrons form a conduction band encompassing all the atoms. This makes copper a great conductor of electricity, since electricity is the flow of charged particles (such as electrons). So we make the wires in our houses out of copper. (Or aluminum, if your house was built in the 70s. Sigh.)

We make the transistors in our computers, on the other hand, out of silicon.

<p style="text-align:center;">
  <a href="http://clayvessel.org/clayvessel/wp-content/uploads/2014/08/transistor005.png"><img src="http://clayvessel.org/clayvessel/wp-content/uploads/2014/08/transistor005.png" alt="Silicon has four valence electrons." title="Silicon has four valence electrons" width="350" style="box-shadow: 7px 7px 5px 0px rgba(50, 50, 50, 0.58);" /></a>
</p>

Silicon has four valence electrons, but its shell would be filled if it had eight. This lets silicon atoms bond with other silicon atoms in a complex lattice, fancier than what I could draw here in 2D.

<p style="text-align:center;">
  <a href="http://clayvessel.org/clayvessel/wp-content/uploads/2014/08/transistor006.png"><img src="http://clayvessel.org/clayvessel/wp-content/uploads/2014/08/transistor006.png" alt="Silicon can share its four valence electrons with four other silicon atoms, making a crystal lattice." title="Silicon atoms bond with each other into a crystal lattice" width="350" style="box-shadow: 7px 7px 5px 0px rgba(50, 50, 50, 0.58);" /></a>
</p>

Crystals don&#8217;t conduct. But if we swapped out one of those silicon atoms with something else, something that had an extra electron, or maybe something that had a spare spot to accept an electron, then we&#8217;d have something that could conduct. Some of the time, anyway. It would be a&#8230; _semi_conductor.

<p style="text-align:center;">
  <a href="http://clayvessel.org/clayvessel/wp-content/uploads/2014/08/transistor007.png"><img src="http://clayvessel.org/clayvessel/wp-content/uploads/2014/08/transistor007.png" alt="The zigzag divider drawn on the periodic table separates metals to the left, non-metals to the right, and inbetweener metalloids right along the zigzag." title="The dividing line between metals and non-metals" width="450" style="box-shadow: 7px 7px 5px 0px rgba(50, 50, 50, 0.58);" /></a>
</p>

Adding impurities to silicon to change its electrical properties is called [doping](http://en.wikipedia.org/wiki/Doping_(semiconductor)). Good choices for doping silicon are the atoms sitting on either side of it on the periodic table.

<p style="text-align:center;">
  <a href="http://clayvessel.org/clayvessel/wp-content/uploads/2014/08/transistor008.png"><img src="http://clayvessel.org/clayvessel/wp-content/uploads/2014/08/transistor008.png" alt="Aluminum is one spot to the left of silicon, so it has one fewer electron. Phosphorus is one spot to the right, so it has one more electron." title="Aluminum and phosphorus sit to either side of silicon on the periodic table" width="350" style="box-shadow: 7px 7px 5px 0px rgba(50, 50, 50, 0.58);" /></a>
</p>

Aluminum is one spot to the left of silicon, because it has one fewer electron. Phosphorus is one spot to the right, because it has one more electron. Having extra electrons that are easy to knock free, plus &#8220;holes&#8221; where spare electrons can go, makes a material able to move those electrons along. In other words, conduct electricity.

<p style="text-align:center;">
  <a href="http://clayvessel.org/clayvessel/wp-content/uploads/2014/08/transistor009.png"><img src="http://clayvessel.org/clayvessel/wp-content/uploads/2014/08/transistor009.png" alt="Four silicon atoms with a phosphorus atom have an extra valence electron. Four silicon atoms with an aluminum atom have a hole for an electron." title="Doped silicon will conduct electricity" width="450" style="box-shadow: 7px 7px 5px 0px rgba(50, 50, 50, 0.58);" /></a>
</p>

<p style="text-align:center;">
  <a href="http://clayvessel.org/clayvessel/wp-content/uploads/2014/08/transistor010.png"><img src="http://clayvessel.org/clayvessel/wp-content/uploads/2014/08/transistor010.png" alt="Silicon plus phosphorus is an n-type semiconductor. (N for negative, because of the extra electron.) Silicon plus aluminum is a p-type semiconductor. (P for positive.)" title="Semiconductors are n-type or p-type" width="450" style="box-shadow: 7px 7px 5px 0px rgba(50, 50, 50, 0.58);" /></a>
</p>

Silicon doped with phosphorus makes an _n_-type semiconductor. Silicon doped with aluminum makes a _p_-type semiconductor. Side-by-side, they make a component called a diode.

<p style="text-align:center;">
  <a href="http://clayvessel.org/clayvessel/wp-content/uploads/2014/08/transistor011.png"><img src="http://clayvessel.org/clayvessel/wp-content/uploads/2014/08/transistor011.png" alt="N-type plus p-type makes a diode, which allows current to flow in only one direction." title="Diodes are made of n-type and p-type semiconductors" width="450" style="box-shadow: 7px 7px 5px 0px rgba(50, 50, 50, 0.58);" /></a>
</p>

Diodes are useful when you want to ensure current can flow through your circuit in only one direction. One practical application is circuits with electromagnets. Electromagnets when they&#8217;re shut off can kick current back and damage your microcontroller, so you put a diode between the two, letting the microcontroller send current to the electromagnet but protecting it from this [flyback](http://en.wikipedia.org/wiki/Flyback_diode).

If a diode is an _n_ plus a _p_, what do you get with _n_, _p_, and another _n_ (or _p_, _n_, and _p_)?

<p style="text-align:center;">
  <a href="http://clayvessel.org/clayvessel/wp-content/uploads/2014/08/transistor012.png"><img src="http://clayvessel.org/clayvessel/wp-content/uploads/2014/08/transistor012.png" alt="Transistors are N-P-N or P-N-P sandwiches. No current can flow in this state, but changing the properties of the middle segment, flipping from N to P or vice-versa, makes the transistor conduct electricity." title="Transistors are N-P-N or P-N-P sandwiches" width="450" style="box-shadow: 7px 7px 5px 0px rgba(50, 50, 50, 0.58);" /></a>
</p>

Transistors are like two diodes stuck back-to-back. Since diodes let current flow in only one direction, this is like attaching a valve that lets liquid flow only from right to left to a valve that allows flow only from left to right; i.e., no flow at all. That sounds kind of useless.

<p style="text-align:center;">
  <a href="http://clayvessel.org/clayvessel/wp-content/uploads/2014/08/transistor013.png"><img src="http://clayvessel.org/clayvessel/wp-content/uploads/2014/08/transistor013.png" alt="Applying a current to the middle segment switches the transistor to N-N-N (or P-P-P). Now it will conduct." title="Current flips the middle segment" width="350" style="box-shadow: 7px 7px 5px 0px rgba(50, 50, 50, 0.58);" /></a>
</p>

Applying a current to the p-type semiconductor in the middle segment knocks some electrons free, switching it to behave like an n-type semiconductor. Now the transistor is N-N-N instead of N-P-N, and current can flow through it.

<p style="text-align:center;">
  <a href="http://clayvessel.org/clayvessel/wp-content/uploads/2014/08/transistor014.png"><img src="http://clayvessel.org/clayvessel/wp-content/uploads/2014/08/transistor014.png" alt="A small power source can control whether or not the transistor allows a big power source to flow through it. For example, an arduino (5 volts) can control a motor (12 volts)." title="A small current controls the flow of a big current" width="450" style="box-shadow: 7px 7px 5px 0px rgba(50, 50, 50, 0.58);" /></a>
</p>

In this way, the transistor acts like an on/off switch. A small current can flip the switch, either allowing or blocking a big current. This is exactly what you need when you want your arduino microcontroller, which can only pump 5 volts out of its output pins, to decide when to switch on something with a bigger power draw, like a motor or a fountain pump.

Combining transistors into a computer is left as an exercise for the reader.

<p style="text-align:center;">
  <a href="http://clayvessel.org/clayvessel/wp-content/uploads/2014/08/transistor015.png"><img src="http://clayvessel.org/clayvessel/wp-content/uploads/2014/08/transistor015.png" alt="The Joy of Chemistry: The Amazing Science of Familiar Things" title="The Joy of Chemistry: The Amazing Science of Familiar Things" width="350" style="box-shadow: 7px 7px 5px 0px rgba(50, 50, 50, 0.58);" /></a>
</p>

Check out [The Joy of Chemistry](http://www.amazon.com/The-Joy-Chemistry-Amazing-Familiar-ebook/dp/B004F9QGTQ/). It makes not only transistors but a lot of other things make sense (like, _how_ does your toilet actually flush?). It has illustrative experiments and then, because the authors know their audience are grown-ups, descriptions of what _would have happened_ if you&#8217;d done the experiment. And I love that this book knows that science is fun all on its own and doesn&#8217;t need cutesy distractions or wisecracks to make the book &#8220;engaging.&#8221;

Now, can anybody tell me what it means&mdash;_means_-means, not just the effects you observe&mdash;when a microcontroller pin is &#8220;floating&#8221;?
  
**UPDATE:** Andy Philips [explains &#8220;float&#8221;](http://lostechies.com/sharoncichelli/2014/08/29/how-transistors-work/#comment-1573681038) in the comments.