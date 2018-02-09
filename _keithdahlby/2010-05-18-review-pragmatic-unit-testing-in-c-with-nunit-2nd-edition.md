---
wordpress_id: 4210
title: 'Review: Pragmatic Unit Testing In C# with NUnit (2nd Edition)'
date: 2010-05-18T01:29:00+00:00
author: Keith Dahlby
layout: post
wordpress_guid: /blogs/dahlbyk/archive/2010/05/17/review-pragmatic-unit-testing-in-c-with-nunit-2nd-edition.aspx
dsq_thread_id:
  - "264955583"
categories:
  - Book Review
  - NUnit
  - Testing
redirect_from: "/blogs/dahlbyk/archive/2010/05/17/review-pragmatic-unit-testing-in-c-with-nunit-2nd-edition.aspx/"
---
<div class="content">
  <div class="snap_preview">
    <p>
      I&rsquo;ve written hundreds of tests, read dozens<br /> of articles and listened to several presentations on unit testing, but<br /> until recently had never actually read a book dedicated to the subject.<br /> In reviewing my options, I was told repeatedly that I should start with <em><a title="Pragmatic Unit Testing in C# with NUnit, 2nd Edition" href="http://pragprog.com/titles/utc2/pragmatic-unit-testing-in-c-with-nunit">Pragmatic<br /> Unit Testing (In C# with NUnit)</a></em> from <a title="The Pragmatic 
Bookshelf" href="http://pragprog.com/">The Pragmatic Programmers</a>,<br /> part of the three-volume Pragmatic Starter Kit. In the context of that<br /> starter kit, I found the book to be an excellent introduction to unit<br /> testing; however, a developer with sufficient experience could probably<br /> get by with a quick glance over the summary provided as Appendix C<br /> (which is <a title="Pragmatic Unit Testing Summary" href="http://media.pragprog.com/titles/utc2/StandaloneSummary.pdf">available<br /> online</a>).
    </p>
    
    <p>
      But before I get into the book, let me start by applauding the idea<br /> of the Pragmatic Starter Kit. As I entered industry after receiving my<br /> degrees in Computer Engineering and Computer Science, it became clear<br /> that I was terribly unprepared for building quality software. Academia<br /> provided a solid foundation of theory and some (basic) techniques to<br /> structure code (OO, FP, etc), but provided precious little guidance for<br /> scaling projects beyond a few thousands lines of code. Version control<br /> was given one lecture and a trivial assignment (in CVS), the unit<br /> testing lecture did little to convince me that it actually had value,<br /> and automated testing was never even mentioned (in fact, build processes<br /> in general were scarcely discussed). These are the gaps that the<br /> Pragmatic Starter Kit aims to fill with practical advice from the field,<br /> and if <em>Pragmatic Unit Testing</em> is any indication the entire<br /> series should be required reading for new graduates (or even sophomores,<br /> really).
    </p>
    
    <p>
      As one would expect from an introductory volume, the book begins with<br /> an excellent overview (<a title="Pragmatic Unit Testing: Introduction" href="http://media.pragprog.com/titles/utc2/intro.pdf">PDF</a>) of what<br /> unit testing is and why it matters. There are also several pages<br /> dedicated to rebuttals to common objections like &ldquo;It takes too much time<br /> to write the tests&rdquo;, &ldquo;It&rsquo;s not my job to test my code&rdquo;, and my personal<br /> favorite &ldquo;I&rsquo;m being paid to write code, not to write tests&rdquo;, which is<br /> answered brilliantly:
    </p>
    
    <blockquote>
      <p>
        By that same logic, we&rsquo;re not being paid to spend all day<br /> in the debugger either. Presumably we are being paid to write <em>working</em><br /> code, and unit tests are merely a tool toward that end, in the same<br /> fashion as an editor, an IDE, or the compiler.
      </p>
    </blockquote>
    
    <p>
      Developers are a proud lot, so the emphasis on testing as a powerful<br /> tool rather than a crutch is crucial.
    </p>
    
    <p>
      Chapters 2 and 3 follow up with an introduction to testing with<br /> NUnit, first with a simple example and then with a closer look at<br /> structured testing with the framework. All the usual suspects are<br /> covered, including classic and constraint-based asserts, setup and<br /> teardown guidance, [Category], [ExpectedException], [Ignore] and more.
    </p>
    
    <p>
      The most valuable chapters to a new tester will be chapters 4 and 5.<br /> The former provides the &ldquo;Right BICEP&rdquo; mnemonic to suggest what to test;<br /> the latter takes a closer look at the &ldquo;CORRECT&rdquo; boundary conditions (the<br /> B in BICEP) to test. The expanded acronyms are included in the<br /> aforementioned summary card (<a title="Pragmatic Unit Testing Summary" href="http://media.pragprog.com/titles/utc2/StandaloneSummary.pdf">PDF</a>).<br /> Even after you have a good handle on what to test, the mnemonics can<br /> still serve as a handy reminder, and starting out the overviews of each<br /> bullet are spot on. I also liked chapters 7&ndash;9, which give good guidance<br /> on qualities of good tests and how testing can be applied effectively to<br /> projects and to improve code, though the refactoring example was a bit<br /> longer than it probably needed to be.
    </p>
    
    <p>
      In my opinion, the weakest parts of the book were chapters 6 and 10,<br /> on mocking and UI testing, respectively. The former starts out strong,<br /> but gets bogged down once it starts talking about tools. The reader<br /> would be better off skipping section 6.3 altogether in favor of a good<br /> Rhino Mocks or Moq introduction. The discussion of UI testing, on the<br /> other hand, covers too little on a number of topics to be of much value<br /> other than to raise awareness that you should test all parts of the<br /> application.
    </p>
    
    <p>
      Overall I was quite pleased with the quantity and quality of material<br /> covered for an introductory volume, awarding four out of five donkeys.<br /> The authors make a good argument for testing and offer sound guidance<br /> for how to do it. However, if you&rsquo;re already familiar with unit testing<br /> you may be better off reading <a title="The Art of Unit Testing" href="http://www.artofunittesting.com/">The Art of Unit Testing</a> or<br /> finding more specific material online.
    </p>
  </div>
</div>