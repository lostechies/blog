---
id: 541
title: The Dart Hello World
date: 2011-10-12T13:08:14+00:00
author: Jimmy Bogard
layout: post
guid: http://lostechies.com/jimmybogard/2011/10/12/the-dart-hello-world/
dsq_thread_id:
  - "441124109"
categories:
  - JavaScript
---
Via [@qrush](http://twitter.com/qrush/statuses/124102080095981568), a [nice analysis](http://webreflection.blogspot.com/2011/10/what-is-wrong-about-17259-lines-of-code.html) of the [compiled JavaScript code from a small Dart Hello World gist](https://gist.github.com/1277224). Basically, this Dart code:

<pre>// Copyright (c) 2011, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.
// Simple test program invoked with an option to eagerly
// compile all code that is loaded in the isolate.
// VMOptions=--compile_all

class HelloDartTest {
  static testMain() {
    print("Hello, Darter!");
  }
}


main() {
  HelloDartTest.testMain();
}</pre>

Compiles to 17259 lines of JavaScript code. Now, most of it is just the library core, but it shows what you have to do to bolt static typing on top of a prototype-based, dynamic, truly object-oriented language.

I don’t really understand the point of Dart personally, it seems like all that’s left is some 100K line XML file to drive behavior, and now we’ve built Java executing in the browser.

Be sure you check out the comments on that gist, it’s a gold mine of ready-made memes. My favorite so far:

![](https://a248.e.akamai.net/assets.github.com/img/a0ffc6339b4ee880dcc7448c99369133263148e4/687474703a2f2f696d616765732e6d656d6567656e657261746f722e6e65742f696e7374616e6365732f343030782f31303534353033392e6a7067)

Classic.