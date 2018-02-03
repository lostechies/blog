---
wordpress_id: 937
title: 'Hello, React! &#8211; A Beginner&#8217;s Setup Tutorial'
date: 2017-05-25T08:00:32+00:00
author: Derek Greer
layout: post
wordpress_guid: https://lostechies.com/derekgreer/?p=937
dsq_thread_id:
  - "5863957855"
categories:
  - Uncategorized
tags: [react]
---
React has been around for a few years now and there are quite a few tutorials available. Unfortunately, many are outdated, overly complex, or gloss over configuration for getting started. Tutorials which side-step configuration by using jsfiddle or code generator options are great when you’re wanting to just focus on the framework features itself, but many tutorials leave beginners struggling to piece things together when you’re ready to create a simple react application from scratch. This tutorial is intended to help beginners get up and going with React by manually walking through a minimal setup process.

## A Simple Tutorial

This tutorial is merely intended to help walk you through the steps to getting a simple React example up and running. When you’re ready to dive into actually learning the React framework, a great list of tutorials can be found [here.](http://andrewhfarmer.com/getting-started-tutorials/)

There are a several build, transpiler, or bundling tools from which to select when working with React. For this tutorial, we’ll be using be using Node, NPM, Webpack, and Babel.

## Step 1: Install Node

Download and install Node for your target platform. Node distributions can be obtained [here](https://nodejs.org/en/).

## Step 2: Create a Project Folder

From a command line prompt, create a folder where you plan to develop your example.

<pre>$&gt; mkdir hello-react
</pre>

## Step 3: Initialize Project

Change directory into the example folder and use the Node Package Manager (npm) to initialize the project:

<pre>$&gt; cd hello-react
$&gt; npm init --yes
</pre>

This results in the creation of a package.json file. While not technically necessary for this example, creating this file will allow us to persist our packaging and runtime dependencies.

## Step 4: Install React

React is broken up into a core framework package and a package related to rendering to the Document Object Model (DOM).

From the hello-react folder, run the following command to install these packages and add them to your package.json file:

<pre>$&gt; npm install --save-dev react react-dom
</pre>

## Step 5: Install Babel

Babel is a transpiler, which is to say it’s a tool from converting one language or language version to another. In our case, we&#8217;ll be converting EcmaScript 2015 to EcmaScript 5.

From the hello-react folder, run the following command to install babel:

<pre>$&gt; npm install --save-dev babel-core
</pre>

## Step 6: Install Webpack

Webpack is a module bundler. We’ll be using it to package all of our scripts into a single script we’ll include in our example Web page.

From the hello-react folder, run the following command to install webpack globally:

<pre>$&gt; npm install webpack --global
</pre>

## Step 7: Install Babel Loader

Babel loader is a Webpack plugin for using Babel to transpile scripts during the bundling process.

From the hello-react folder, run the following command to install babel loader:

<pre>$&gt; npm install --save-dev babel-loader
</pre>

## Step 8: Install Babel Presets

Babel presets are collections of plugins needed to support a given feature. For example, the latest version of babel-preset-es2015 at the time this writing will install 24 plugins which enables Babel to transpile ECMAScript 2015 to ECMAScript 5. We’ll be using presets for ES2015 as well as presets for React. The React presets are primarily needed for processing of [JSX](https://facebook.github.io/react/docs/introducing-jsx.html). 

From the hello-react folder, run the following command to install the babel presets for both ES2015 and React:

<pre>$&gt; npm install --save-dev babel-preset-es2015 babel-preset-react
</pre>

## Step 9: Configure Babel

In order to tell Babel which presets we want to use when transpiling our scripts, we need to provide a babel config file. 

Within the hello-react folder, create a file named .babelrc with the following contents:

<pre>{                                    
  "presets" : ["es2015", "react"]    
}                                 
</pre>

## Step 10: Configure Webpack

In order to tell Webpack we want to use Babel, where our entry point module is, and where we want the output bundle to be created, we need to create a Webpack config file.

Within the hello-react folder, create a file named webpack.config.js with the following contents:

<pre>const path = require('path');
 
module.exports = {
  entry: './app/index.js',
  output: {
    path: path.resolve('dist'),
    filename: 'index_bundle.js'
  },
  module: {
    rules: [
      { test: /\.js$/, loader: 'babel-loader', exclude: /node_modules/ }
    ]
  }
}
</pre>

## Step 11: Create a React Component

For our example, we’ll just be creating a simple component which renders the text “Hello, React!”.

First, create an app sub-folder:

<pre>$&gt; mkdir app
</pre>

Next, create a file named app/index.js with the following content:

<pre>import React from 'react';
import ReactDOM from 'react-dom';
 
class HelloWorld extends React.Component {
    render() {
          return (
                  &lt;div&gt;
                    Hello, React!
                  &lt;/div&gt;
                )
        }
};
 
ReactDOM.render(&lt;HelloWorld /&gt;, document.getElementById('root'));
</pre>

Briefly, this code includes the react and react-dom modules, defines a HelloWorld class which returns an element containing the text “Hello, React!” expressed using [JSX syntax](https://facebook.github.io/react/docs/introducing-jsx.html), and finally renders an instance of the HelloWorld element (also using JSX syntax) to the DOM.

If you’re completely new to React, don’t worry too much about trying to fully understand the code. Once you’ve completed this tutorial and have an example up and running, you can move on to one of the aforementioned tutorials, or work through [React’s Hello World example](https://facebook.github.io/react/docs/hello-world.html) to learn more about the syntax used in this example.

<div class="note">
  <p>
    Note: In many examples, you will see the following syntax:
  </p>
  
  <pre>
var HelloWorld = React.createClass( {
    render() {
          return (
                  &lt;div&gt;
                    Hello, React!
                  &lt;/div&gt;
                )
        }
});
</pre>
  
  <p>
    This syntax is how classes were defined in older versions of React and will therefore be what you see in older tutorials. As of React version 15.5.0 use of this syntax will produce the following warning:
  </p>
  
  <p style="color: red">
    Warning: HelloWorld: React.createClass is deprecated and will be removed in version 16. Use plain JavaScript classes instead. If you&#8217;re not yet ready to migrate, create-react-class is available on npm as a drop-in replacement.
  </p>
</div>

## Step 12: Create a Webpage

Next, we’ll create a simple html file which includes the bundled output defined in step 10 and declare a <div> element with the id “root” which is used by our react source in step 11 to render our HelloWorld component.

Within the hello-react folder, create a file named index.html with the following contents:

<pre>&lt;html&gt;
  &lt;div id="root"&gt;&lt;/div&gt;
  &lt;script src="./dist/index_bundle.js"&gt;&lt;/script&gt;
&lt;/html&gt;
</pre>

## Step 13: Bundle the Application

To convert our app/index.js source to ECMAScript 5 and bundle it with the react and react-dom modules we’ve included, we simply need to execute webpack. 

Within the hello-react folder, run the following command to create the dist/index_bundle.js file reference by our index.html file:

<pre>$&gt; webpack
</pre>

## Step 14: Run the Example

Using a browser, open up the index.html file. If you’ve followed all the steps correctly, you should see the following text displayed:

<pre>Hello, React!
</pre>

## Conclusion

Congratulations! After completing this tutorial, you should have a pretty good idea about the steps involved in getting a basic React app up and going. Hopefully this will save some absolute beginners from spending too much time trying to piece these steps together.
