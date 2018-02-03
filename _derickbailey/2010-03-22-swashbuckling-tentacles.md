---
wordpress_id: 119
title: Swashbuckling Tentacles
date: 2010-03-22T16:34:19+00:00
author: Derick Bailey
layout: post
wordpress_guid: /blogs/derickbailey/archive/2010/03/22/swashbuckling-tentacles.aspx
dsq_thread_id:
  - "262068520"
categories:
  - AntiPatterns
  - Brownfield
  - Continuous Improvement
  - Model-View-Presenter
  - Principles and Patterns
  - Semantics
---
Surrounded by the wriggling tentacles of the beast that had attached itself to the ship, Ed – the lone surviving member of the ship’s crew – brandishes he sword and lunges toward the nearest of the appendages. With a cry of both fear and determination, Ed slices halfway through the tentacle before he is knocked backward by the convulsing of the wounded creature. Gathering his feet under himself and recovering from the blow, he rushes back toward the gaping wound that his weapon had created and separates the tentacle with another slice. As the now separated arm of the creature convulses, the planks of the ship that it had attached itself to begin to crack and pull apart. Undaunted by the flying debris, Ed side-steps a board flying toward his chest and moves in for other attack. A second tentacle is removed with a single slice and Ed hardly notices the additional cracking and crumbling of the planks and boards that this tentacle had wrapped around. His focus is set on the next of the beasts many appendages, with a single goal in mind: destroy the towering arms that are now flailing about the ship, and send his foe to the bottom of the sea.

The battle rages on as Ed continues to hack away at the beat’s tentacles, dodging the continuous onslaught of debris and narrowly escaping the clutches of the beast on occasion. After what seemed to be an eternity of fighting, the creature below the ship convulses for a final time, shaking the entirety of the wooden vessel that Ed is standing on. As the last of the tentacles snap the remaining masts, the beast frees itself from the ship. No longer burdened by the giant squid, the ship rights self in the water and Ed is tossed to the side, slamming into what little is left of the wooden railing. He screams out in agony as his several ribs on his left side are crushed, and falls on to the deck in pain. It’s only then that he notices the sea water lapping across the deck of his once great ship.

Hauling himself to his feet and leaning against the jagged edges of the railing that had only wounded him only moments ago, Ed surveys the ship one last time. Every mast has been destroyed – torn in half or ripped from their mounts. Half of the deck is torn to shreds and there gaping holes in the side of ship from the tentacles that had attached and convulsed so violently upon separation from their owner’s body. Water is rushing around him and the boat is nearly sunk. Ed’s eyes fill with despair as his fate sets in and his ship is submerged into the deep, cold waters. With the last of his strength and every ounce of life in him, Ed cries out toward the heavens flailing his sword about, before succumbing to the same fate as his enemy.

&#8230;

“Ahem.” A subtle cough if heard from behind as Ed – a software developer in the company’s product development division – snaps out of his imagination. He slowly lowers his keyboard back down to his desk as he sees several reflections of coworkers in his monitor. Embarrassed, he swivels his chair around and sheepishly smiles at Tom, his neighboring cubicle worker.

“Everything ok, Ed?” asks Tom, with a half smirking half concerned look on his face.

Ed quietly replies, “Um… yeah… you know… I, uh”

“I’m a little concerned buddy,” Tom interrupts. “The usual mumbling and grumbling about bad code seems to have turned into you screaming at your computer and brandishing your keyboard like a weapon.”&#160; The other developers, gathered behind Tom try to conceal their laughs as he flails his arms above his head, mocking a half-crazy person.

“Yeah. Sorry.”, Ed replies, realizing just how ridiculous the situation was. “It’s just this dumb code… I mean… who would have ever thought to use _that_,” pointing at a region of code on his monitor, “as an integration point between these two parts of the system.”

Tom nods in understanding “mmm-hmm. It’s certainly not the best code our team has produced. Fortunately, the guy that wrote that doesn’t work here anymore.”

“Yeah,” Ed pipes in, “but we still have to maintain this mess.” 

With his frustration growing and his embarrassment eating his pride, he cries out “who would do _that_?” Fingers tapping on the screen rapidly, Ed continues. ”Who would violate such obvious semantics between this interface and the rest of the code? This is not just another point of interaction! _It’s a view interface! It should never be referenced by anything other than the presenter that controls it!”_

Ed sighs, realizing that he’s letting his emotions get the better of him. Shaking off the embarrassment and frustration momentarily, he turns back to Tom, who is now sitting on the edge of the desk in Ed’s cubicle, listening patiently. The other developers have moved on and are back to their own concerns by now.

“It’s like tentacles,” Ed continues. “It’s as if this interface definition is growing tentacles and reaching out from some deep, dark, salt-water abyss. How am I supposed to restructure and rebuild this control when I can’t see all of the places that it reaches out to, to understand the functionality that is based on it?” Ed shakes his head, the frustration re-emerging in him, “especially in the time frame that I’ve been given?!”

Tom sighs, “I know, Ed. Believe me, I know.” Pausing for a moment to formulate a response and direction for Ed to continue, Tom tries to calm his frustrated friend by saying “We’ve all been dealing with tightly coupled, leaky abstractions like that for years, now. I don’t think anyone expects you to completely re-write everything that touches this control. Just clean up what you can in the time you have and put the leaky methods and properties back in place where you have to.” 

“Just make sure you keep the software functioning“, Tom adds. “I know it’s not pretty, but its gets us a few steps closer to pretty.”

Ed slowly turns his chair back to face his computer, letting out a deflating sigh and begrudgingly says “yeah, ok… I’ll do what I can.”

&#8230;

Duct-tape in hand, Ed – the swashbuckling hero of the once mighty ship – begins to gather the now lifeless tentacles of the beast that he has slain. With most of the planks and other boards still stuck to the suction pads of the slimy appendages, he begins to reconstruct the monster, tacking them back to the hull of his boat and the body of the foul creature. Slowly and steadily the wrecked ship begins to float again, listing sideways under the weight of the giant squid’s carcass. 

With one last sigh, Ed reluctantly gives in to the reality that sometimes the tentacles of tightly coupled code are all that hold a ship together.