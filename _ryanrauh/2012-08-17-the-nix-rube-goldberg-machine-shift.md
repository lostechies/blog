---
id: 168
title: 'The *nix Rube Goldberg machine &#8211; shift'
date: 2012-08-17T18:48:15+00:00
author: Ryan Rauh
layout: post
guid: http://lostechies.com/ryanrauh/?p=168
dsq_thread_id:
  - "809224431"
categories:
  - Shell
  - Uncategorized
tags:
  - bash
---
# Learn your shell! 

If you have been following along, I love bash and use it all the TIME! I&#8217;ll go as far as to say its the greatest thing I&#8217;ve learned in my entire career. 

In my last bash post I talked about how you can write functions to alias complex tasks. One of the most common things you do in bash is grep through files.

`~/lecode>find -name *.js | xargs grep "fn\.somePlugin"`

I can&#8217;t tell you how many times I&#8217;ve typed find -name &#8230;. | xargs grep &#8230;.

<blockquote style="overflow:hidden;">
  <p>
    <img src="http://cl.ly/3b1n2i321K1H0h3p2N3G/trollface.jpg" width="64px" style="float:left;padding:0;margin:5px;" /> &#8220;LUL WTF, noob haven&#8217;t you ever heard of ack?&#8221;
  </p>
</blockquote>

<blockquote style="overflow:hidden;">
  <p>
    <img src="http://www.gravatar.com/avatar/29283ede6c447fdc62f0ceac42df33ea?s=64" width="64px" style="float:right;padding:0;margin:5px;" /> &#8220;Of course I have, but you have to install that shit and I&#8217;m lazy&#8230; So shut up troll&#8221;
  </p>
</blockquote>

So&#8230; finally I decided to save myself some keystrokes and make a function.

`~/lecode>function ff() {<br />
  arg1=$1<br />
  arg2=$2<br />
  shift 2<br />
  find -name $arg1 -type f -print0 | xargs -0 grep $arg2 $@<br />
}</p>
<p>`

shift is really cool, it lets me capture off the first two arguments

 `arg1=$1`
  
 `arg2=$2`

then call  `shift 2` which will remove the first two arguments from the \`splat\` (\`$@\`) so that I can pass those off to grep. This saves me a bunch of keystrokes when working with grep.

`ff *.js "fn\.somePlugin"`

That will search all js files for that regex.

By shifting the splat I can give extra flags to grep like -l (only the file name)

`ff *.js "fn\.somePlugin" -l`

or -h for just the match 

`ff *.js "fn\.somePlugin" -h`

Don&#8217;t herp it, just derp it

-Ryan