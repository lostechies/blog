---
id: 163
title: Building a slack bot with botkit node and docker
date: 2016-04-14T19:29:05+00:00
author: Andrew Siemer
layout: post
guid: http://lostechies.com/andrewsiemer/?p=163
dsq_thread_id:
  - "4747432518"
categories:
  - Bot
  - docker
  - node
---
Recently I have needed to dig deeper into node and docker.  I decided to make a slack bot (easy to do) so that the problem being solved didn&#8217;t require additional learning (making bots is fun).  I ended up finding [botkit](http://howdy.ai/botkit/) (a node based slack integration) and set off building something simple with the intent of hosting it in Docker.  This took me down an interesting path as I tried to fit all these things together to make something small but useful.

I ended up creating a FitBot that gives you a random exercise to do every hour.  My bot got way more complex (code wise) than is needed for this discussion.  I figured we might instead build a simple weather bot using the weather underground.  But first we have to get the plumbing working.

## What will you learn from this post?

  1. How to install node on a mac (will point to windows how-too)
  2. How to use the basics of NPM for node package management
  3. How to write some simple node (javascript) and test it locally
  4. How to create a Slack bot
  5. How to push all of this into a docker container
  6. How to push your docker container over to a bot host
  7. Build a weather bot
  8. What is chatops

This post is &#8220;just enough&#8221; to scratch the surface.  It is intended to get you touching all of these concepts just enough that they are no longer scary unknown topics.  There are many pluralsight videos that take you deep into each of these technologies.  Let&#8217;s get started.

## Node stuff

I was most interested to get my hands dirty with node which ultimately led me down this path.  This then led me to finding a slack SDK for node.  Node is great.  Many web devs naturally know javascript.  Taking your client side javascript skills to the server makes a lot of sense.  Let&#8217;s start by getting node up and running.

### Node pre-requisites for mac

As I started my journey for getting node up and running I bumped over a few articles.  I ultimately found that I needed to install XCode and HomeBrew which would then allow me to get node up and running quickly.

**XCode** allows you to build mac and ios apps.  It also provides you with all the tools you need to compile software for use on a mac.  You can find XCode in the [apple store](https://itunes.apple.com/us/app/xcode/id497799835?mt=12).

**HomeBrew** is the &#8220;package manager that mac forgot&#8221;.  It makes installing various other bits of software on your mac very easy.  For installing node you can simple type out&#8230;

<pre>brew install node</pre>

&#8230;and you have node running!  But first we need to get HomeBrew installed and running.  To get HomeBrew installed just copy and paste the line below in a terminal window:

<pre>ruby -e "$(curl -fsSL https://raw.githubusercontent.com
<span style="color: #222222; font-family: 'Courier 10 Pitch', Courier, monospace; line-height: 21px;">/Homebrew/install/master/install)"</span></pre>

### Installing node

With HomeBrew installed you can now type out the following in a terminal window:

<pre>brew install node</pre>

To verify that node is installed appropriately type these commands to get the version of the installed software:

<pre>node -v</pre>

<pre>npm -v</pre>

For windows go [grab an installer from nodejs.org](https://nodejs.org/en/download/) and run through the installer.

#### Testing node on your box

With node installed on your machine you can now run a node server.  Doing this is also pretty easy.  Open up your preferred text editor and type in the following code and save it as program.js.

[gist id=ad6c96b384faabe83949359b8a7c1ac8]

Then open up a terminal window and cd into the directory with your program.js file.  Then type the following on a command line.

<pre>node program.js</pre>

You should see:

<pre>Server running at http://127.0.0.1:8124/</pre>

Now you can open a browser window at that url and port number.  The page should load with &#8220;Hello World&#8221;.

### Install botkit

Now that we know that we have node installed and we have set up our first node server we can move on to building up a Slack bot using node.  We will use [botkit provided by howdyai](https://github.com/howdyai/botkit).

According to their instructions on their github page we can use npm to install botkit.

    npm install --save botkit

## Slack stuff

Now we are ready to install a bot into Slack.  To get started you need to have a [Slack team](http://www.slack.com) you want to attach your bot too.  Inside your slack team go manage your apps and add a Bots integration: https://{your team}.slack.com/apps/manage/custom-integrations.  Then search for Bots and add a Slack Real Time Messaging bot.  Give your bot a name and then copy and paste the API Token (looks like a gobble-d-guck string &#8211; GUIDish).

## Bot stuff

With your API key in hand you can now create a new file in your preferred text editor called robot.js and enter the following code:

[gist id=2181a1ca5a1a6e1b73b1a0289b14aaf0]

Make sure you replace the <my\_slack\_bot_token> with your API token.

Then in a terminal window you can cd your way to the directory that has your robot.js file.  Then run the following command.

<pre>node robot.js</pre>

You should now have a bot user (named what you named it when you created it) showing as an active user in your team.  You can now direct message that bot user or mention the user saying &#8220;hello&#8221;.  The bot should response with &#8220;Hello yourself.&#8221;.

If anything goes wrong you will see some output in your terminal window that is running your robot.

## Another node tidbit

Now that we have a node app that can be a slack bot let&#8217;s add another tidbit that will make our node app operate more like a node app.  We need this primarily to support the ability to shove our app into docker to run it as a node app.

Specifically we need to add a package.json file which is basically a configuration and meta data file.  This is a json file that houses the name of the application, its version, a description, etc.  But it also defines dependencies, how scripts wire up, and so on.  Here is a link that describes all the various pieces you can stuff into this file.

<http://browsenpm.org/package.json>

Here is the contents of the file I am currently using for my bot.

[gist id=c69236b390c30093e3a5b2601a43ec38]

With this file named package.json and living next to your robot.js file you can now use the following command to start your node app.

<pre>npm start</pre>

The start command points at your start script in the package file and executes the appropriate commands.  This means who ever is running your app doesn&#8217;t really have to understand how to get it running.

Ultimately, we want this so that we can issue simple commands in our docker bits to get our node app running.

Moving right along&#8230;

## Docker stuff

If you haven&#8217;t taken a deep dive into docker yet&#8230;oh my!  This technology recently turned three and has turned out world on its head as far as how to develop, test, deploy, and manage our applications.  The statement &#8220;works on my machine&#8221; sort of disappears.  Vendor lock in with a virtualization layer, or even a cloud provider, can largely be removed as well.  You can push docker instances just about anywhere these days.  And when it comes to not treating your servers as pets docker is the king.  Spin them up, tear them down.  Spin up many of them to handle load.  Docker is great.

So let&#8217;s host our bot in a docker container and see how all this works.

### Install docker tools

The local story for docker has changed now and then.  The current iteration is pretty easy actually.  But there is an even better story coming soon.  Let&#8217;s see how docker tools works.

First off &#8211; I am not going to detail all the steps needed for getting Docker running on your mac or windows machines.  They do a great job of this already.  [For mac folks go here](https://docs.docker.com/mac/).  [For windows folks go here](https://docs.docker.com/windows/).  [Grab your installers here](https://www.docker.com/products/docker-toolbox).

As long as you have the Docker Quickstart Terminal running you should be good to go.

### Dockerize your node app

Once you have installed docker and have touched their simple tutorials (understanding the basics) you will need to understand the Dockerfile (capital D is important for some reason).  Start by creating a file named Dockerfile.  This is just an empty text file with no file extension.  This is the configuration for your docker image.  Here is the one I am using for my bot.

[gist id=45ff51c7621589e22f8d43e499f06ab7]

[Here is the formal docs for Dockerfile](https://docs.docker.com/engine/reference/builder/) if you really want to dig deep on this.

But let me give you the quick overview.  All docker containers start from a base image using the keyword _FROM {image name}_.  I chose to start from the node:argon image which is a lightweight node base.  You can start from many of the different node ready containers.  [Search through the docker hub](https://hub.docker.com/search/?isAutomated=0&isOfficial=0&page=1&pullCount=0&q=node&starCount=0) to find one that suites you.

Then we need to create a location to host our node app.  I chose to put my app in /user/src/app using _RUN mkdir -p /usr/src/app_.  Then I set that to the working directory with _WORKDIR /usr/src/app_.

Next we need to run some commands inside our image to get it ready to host our node app.  _RUN npm install botkit &#8211;save_ is the same as we did when readying our development environment up above.  We have to repeat this in our docker image.  The same work is done installing botkit in the container.  This gets us ready to take a dependency on botkit.

And then we can copy in our script and package.json file.  This is done with _COPY bot.js /usr/src/app/_ and _COPY package.json /usr/src/app/_.

Finally we set the command to be issued when the container starts up with _CMD [ &#8220;npm&#8221;, &#8220;start&#8221; ] _

### Building your image

Now that you have a Dockerfile in your app we can build a docker image.  We do this by opening up the Docker Quickstart Terminal.  Then cd your way into the folder that has your robot application (and Dockerfile) in it.  Then issue this command:

<pre>$ docker build -t &lt;your username&gt;/&lt;image name&gt; .</pre>

The _-t_ flag allows you to tag your image so that you can easily find it in a long list of images.

<your username>: this can be anything.  I use first initial last name &#8216;asiemer&#8217;

<image name>: this can also be anything.  I use the app that I am putting in the image.  So your bots purpose is good.

To follow along with what we have done so far you could use something like this:

<pre>$ docker build -t asiemer/robot .</pre>

When you hit enter you will see a long list of information stream by as your image is created for you.  When that is all done you can list out your images.  You should see your freshly built image in the list.

<pre>$ docker images</pre>

### Running your image

Next we can run the image.  We do this with the following entry.

<pre>$ docker run -p 49160:8080 -d asiemer/robot</pre>

-p is a port mapping (which isn&#8217;t entirely needed by your bot unless you intend to have some management screen as part of your node app).  In this case we mapped 8080 inside the container to 49160 on your physical machine.

-d runs the container in detached mode which leaves the container running in the background (so that you can run your bot and continue to work in docker).

Now that we have the robot running in the background we need to be able to see what it is doing.  We can do this by locating our running container and then tapping into its logs.

<pre>$ docker ps</pre>

You should see your running container _asiemer/robot._  Next we can print the logs to the screen by getting the logs from the running container by its container id._ _ Thankfully you don&#8217;t have to type out the entire container id.  Just the first few characters to make it unique.

<pre>$ docker logs &lt;container id&gt;</pre>

This should show any output from your robot.

To stop the docker container that is running we can use the same container id and issue this command.

<pre>$ docker stop &lt;container id&gt;</pre>

## Hosting your bot stuff

Now that we have done all the leg work of setting up node, getting a slack bot running, and hosting it locally in docker &#8211; we are ready to push this bot somewhere that it can live for a longer time than just when your laptop is running.  There are many great platforms for hosting a docker application.  But I also found a specific bot hosting platform that gives you hosting for cheap, but also gives you a complete CI/CD set up in seconds.

### BeepBoopHQ

BeepBoop is a slack bot hosting company.  They run your bot on the google cloud.  They integrate the CI/CD story through github with docker.  Perfect for us!

To get started you need to create a github repository and push all your bot bits into that new repository.  Reminder: robot.js, package.json, Dockerfile.  You can sync this repository to your local computer or you can just upload those files directly to your new repository.

_You will want to sync this to you machine at some point&#8230;but not needed for now._

Now you can sign into BeepBoopHQ using your github credentials.  This will prompt you for some additional information.  And you should recieve a beepboophq.slack.com invite.  Add this to your slack app as all the magic of their CI/CD story happens directly in slack (pure magic).

Then create a new project (my projects at the top).  Clicking on create a new project will list all your code repositories.  Select the repository that has your bot in it.  There are various details you can set about your bot but those aren&#8217;t important just now.

As soon as you wire a github repository into beepboop you should see some slack activity in their team.

<pre>New Project Created
<span style="color: #222222; font-family: 'Courier 10 Pitch', Courier, monospace; line-height: 21px;">Github Webhook Registered </span><span style="color: #222222; font-family: 'Courier 10 Pitch', Courier, monospace; line-height: 21px;">Build Requested</span></pre>

If you have a Dockerfile (and your other files) in the github repository and all your code was working locally you should see other messages too about the image being built and deployed.  If there are any errors you will see very detailed messaging in the slack channel around what you are missing or what broke.

Once everything is running you will have a bot in your slack team that you can do all sorts of things with.

## Build a weather bot

Now that all of our plumbing is configured let&#8217;s build a quick weather bot.  To use this bot you will have to create a free account with [Weather Underground](https://www.wunderground.com/weather/api/d/docs?d=index&MR=1) so that you can get an API key. With the API key in hand you can then create a simple bot that queries the forecast for a given city and writes the weather back to slack.

You can find [the source for this weather bot here](https://github.com/asiemer/weather-bot).

[gist id=00841a242eb4a69316084db2e0a51e1a]

## Chat ops

Now you are ready to start tackling the concept of ChatOps.  Hopefully your team (dev team, business team, marketing team, family, slack is great for everybody) is using Slack or similar already.  Now you just need to figure out what could make working together better?  And how to weave your bot above into the conversation.

According to StackStorm chat ops is:

> ChatOps is a new operational paradigm where work that is already happening in the background today is brought into a common chatroom. By doing this, you are unifying the communication about what work should get done with actual history of the work being done. Things like deploying code from chat, viewing graphs from a TSDB or logging tool, or creating new Jira tickets&#8230; all of these are examples of tasks that can be done via ChatOps.
> 
> Not only does ChatOps reduce the feedback loop of work output, it also empowers others to accomplish complex self-service tasks that they otherwise would not be able to do. Combining ChatOps and StackStorm is an ideal combination, where from Chat users will be able to execute actions and workflows to accelerate the IT delivery pipeline.

There are all sorts of presentations on ChatOps.

Here is a getting started presentation on ChatOps and why.



<div style="margin-bottom: 5px;">
  <strong> <a title="Chat ops .. a beginner's guide" href="//www.slideshare.net/jhand2/chat-ops-a-beginners-guide" target="_blank">Chat ops .. a beginner&#8217;s guide</a> </strong> from <strong><a href="//www.slideshare.net/jhand2" target="_blank">Jason Hand</a></strong>
</div>

And here is one of the first ChatOps videos around HuBot at github.



##