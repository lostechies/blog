---
id: 3967
title: Extending GitHub Issues
date: 2010-10-26T14:09:00+00:00
author: Joshua Flanagan
layout: post
guid: /blogs/joshuaflanagan/archive/2010/10/26/extending-github-issues.aspx
dsq_thread_id:
  - "262050154"
categories:
  - git
  - Ruby
  - Sinatra
---
{% raw %}
### The problem

My team recently decided to experiment with using the Issues feature of our private Github repository. We&rsquo;ve avoided a bug tracking tool for a long time, but this one seemed just lightweight enough that it was worth a shot. We really like the feature that allows you to close issues via your commit message (include the text &ldquo;closes gh-3&rdquo; to close issue #3) because the website provides hyperlinks between the commit and issue. However, we weren&rsquo;t crazy about the idea of issues being closed without verification from QA. We wanted the auto-linking capability without the auto-closing functionality. <a href="http://support.github.com/discussions/feature-requests/562-show-related-commits-in-issue-tracker-also-not-only-close-but-also-comment-on-issue-from-commit" target="_blank">Others</a> <a href="http://support.github.com/discussions/issues-issues/155-specifying-issue-number-at-commit-message" target="_blank">have asked</a> for this feature, GitHub acknowledges it is on their TODO list, but it is not currently available. Lucky for us, GitHub exposes enough extension points for us to do it ourselves!

### The plan

We want to automatically re-open any issue that is closed via a commit message, then add the &ldquo;Verify&rdquo; label to the issue. This will give us the links between commit and issue on the website, and provide QA visibility to issues that should be resolved.

### The Code

#### Programmatically re-open an issue

Thankfully, GitHub exposes a well-documented API at <http://develop.github.com/>. Re-opening an issue is just a matter of crafting the correct URL and passing credentials along with the request. The GitHub docs do mention a couple existing Ruby libraries for accessing their API, but for such a simple scenario it was just as easy to write my own (with a little help from <a href="http://railstips.org/blog/archives/2008/07/29/it-s-an-httparty-and-everyone-is-invited/" target="_blank">HTTParty</a>). The relevant parts (or <a href="http://github.com/joshuaflanagan/ghpong/blob/master/github.rb" target="_blank">view the full class</a>):

<div style="padding-bottom: 0px;margin: 0px;padding-left: 0px;padding-right: 0px;float: none;padding-top: 0px" class="wlWriterEditableSmartContent">
  <pre>class GitHub
  include HTTParty
  base_uri "https://github.com/api/v2/json"

  def initialize(repo, user=nil, pass=nil)
    @user = user
    @pass = pass
    @repo = repo
  end

  def reopen_issue(issue)
    self.class.post("/issues/reopen/#{@repo}/#{issue}", options)
  end

  private
    def options
      @options ||= @user.nil? ? {} : { :basic_auth =&gt; {:username =&gt; @user, :password =&gt; @pass}}
    end
end</pre>
</div>

Re-opening an issue is as simple as:

<div style="padding-bottom: 0px;margin: 0px;padding-left: 0px;padding-right: 0px;float: none;padding-top: 0px" class="wlWriterEditableSmartContent">
  <pre>github = GitHub.new "joshuaflanagan/ghpong", "joshuaflanagan", "password"
github.reopen_issue 3</pre>
</div>

#### Watch for commits that close issues

Since we want to re-open issues closed via a commit message, we need a way to keep an eye out for these commits. Again, GitHub makes integration easy by exposing <a href="http://help.github.com/post-receive-hooks/" target="_blank">Post-Recieve Hooks</a>. Within your repository Admin control panel you can specify any number of services you want notified of each push, including any arbitrary URL.

I just needed a simple endpoint that GitHub could call so that I could invoke my API wrapper to re-open any closed issues. This is the perfect scenario for a <a href="http://www.sinatrarb.com/" target="_blank">Sinatra</a> application. In fact, GitHub uses Sinatra for all of their &ldquo;built-in&rdquo; service hooks, and since the <a href="http://github.com/github/github-services" target="_blank">code is freely available</a>, we have plenty of examples to learn from.

My Sinatra route to re-open issues closed by commits (<a href="http://github.com/joshuaflanagan/ghpong/blob/master/app.rb" target="_blank">view the full app</a>):

<div style="padding-bottom: 0px;margin: 0px;padding-left: 0px;padding-right: 0px;float: none;padding-top: 0px" class="wlWriterEditableSmartContent">
  <pre>post '/reopen/:token' do
  respond_to_commits do |commit|
    issue = GitHub.closed_issue(commit["message"])
    github.reopen_issue issue if issue
  end
end</pre>
</div>

This defines a route that will respond to any HTTP POST to /reopen/_sometoken_, where _sometoken_ is a secret I&rsquo;ve hardcoded in my environment. If you were to deploy this code, you would configure your own secret token and use it in your calls (this could easily be made much more robust and support multiple users with their own tokens, but I don&rsquo;t need it yet). _respond\_to\_commits_ is a simple helper method that parses the posted data and calls the supplied block for every commit included in the git push. GitHub.closed\_issue parses commit messages looking for patterns like &ldquo;closes gh-3&rdquo;. If it finds the pattern, it returns the issue number, otherwise, nil. We then call the reopen\_issue API wrapper if an issue was found.

I also wanted to add the &ldquo;Verify&rdquo; label to any issue that was re-opened. This was simply a matter of creating an additionaly which calls my GitHub.label_issue API for any issue closed via a commit message. See the <a href="http://github.com/joshuaflanagan/ghpong/blob/master/app.rb" target="_blank">app.rb</a> and <a href="http://github.com/joshuaflanagan/ghpong/blob/master/github.rb" target="_blank">github.rb</a> for details.

### Deploy

Deploying this app is ludicrously simple using <a href="http://heroku.com/" target="_blank">Heroku</a>:

`<br />
` 

    heroku create
    git push heroku master 
    heroku config:add GH_USER=joshuaflanagan GH_PASSWORD=password TOKEN=sometoken 

`<br />
` 

&nbsp;

(Note that you can use use a GitHub API token for GH\_PASSWORD if you append &ldquo;/token&rdquo; to the end of the username in GH\_USER)

The final step is to tell GitHub about the endpoint.

  1. Go to the repo you want to monitor on github 
  2. Click Admin, select Service Hooks 
  3. In Post-Recieve URLS, specify: <http://myapp.heroku.com/reopen/sometoken> 
  4. Click &ldquo;Add another post-recieve URL&rdquo; and specify: <http://myapp.heroku.com/lable/closed/Verify/sometoken> 

If you think it would be useful, feel free to fork the code <http://github.com/joshuaflanagan/ghpong> and deploy

### Summary

That was really too easy. If any of this was new to you, I strongly encourage you to experiment with <http://develop.github.com>, <a href="http://www.sinatrarb.com/intro" target="_blank">Sinatra</a>, and <a href="http://heroku.com/" target="_blank">Heroku</a>. If you want the functionality described in this article, just grab the code from <http://github.com/joshuaflanagan/ghpong> and deploy it. Send me a pull request if you add anything cool.
{% endraw %}
