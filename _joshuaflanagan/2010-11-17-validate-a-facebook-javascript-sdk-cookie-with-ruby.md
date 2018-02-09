---
wordpress_id: 3968
title: Validate a Facebook JavaScript SDK cookie with Ruby
date: 2010-11-17T04:05:00+00:00
author: Joshua Flanagan
layout: post
wordpress_guid: /blogs/joshuaflanagan/archive/2010/11/16/validate-a-facebook-javascript-sdk-cookie-with-ruby.aspx
dsq_thread_id:
  - "262225205"
categories:
  - facebook
  - Ruby
redirect_from: "/blogs/joshuaflanagan/archive/2010/11/16/validate-a-facebook-javascript-sdk-cookie-with-ruby.aspx/"
---
<span style="color:red;font-weight:bold">UPDATE:</span> The Facebook API has changed since this article was posted. The code below will no longer work with the cookies provided by Facebook (which now looks like &#8220;fbsr\_#{@fb\_app_id}&#8221;). There is some [sample code in the comments below](#comment-628598633) that is working for me now (Aug 26, 2012).

You’ve authenticated a user using the Facebook <a href="http://developers.facebook.com/docs/reference/javascript/" target="_blank">JavaScript SDK</a> and now you want your server-side code to know about the user and their login status. The JavaScript SDK makes this possible by creating a cookie for the user which is sent with each request to your application. However, if you are using Facebook to control access in your application, you’ll want to make sure the cookie is valid, and hasn’t been tampered with by the user. It would be way too easy for the user to use a tool like <a href="https://addons.mozilla.org/en-US/firefox/addon/6683/" target="_blank">FireCookie</a> to change values in the cookie to indicate they are a different user, or to lie about their Facebook authentication status. To solve this problem, the cookie includes a signature based on a secret shared between your application and Facebook, which your server-side code can validate. Unfortunately, the only documentation I could find for the cookie verification algorithm was some sample PHP code. This wasn’t very helpful to me since a) I don’t know PHP, and b) I’m writing my application in Ruby (<a href="http://www.sinatrarb.com/" target="_blank">Sinatra</a>!). I didn’t have any luck finding a Ruby implementation, so I’m throwing mine out there so I can find it in the future, and maybe someone else can use it.

Facebook will provide you with an Application ID and Application Secret when you <a href="http://developers.facebook.com/setup/" target="_blank">register your application</a>. This sample code will assume they are available in instance variables @fb\_app\_id and @fb\_app\_secret.

First, get the value of the Facebook cookie. It is named “fbs__your\_application\_id_”. In Sinatra, I would get the cookie value like this:

<div style="padding-bottom: 0px;margin: 0px;padding-left: 0px;padding-right: 0px;float: none;padding-top: 0px" class="wlWriterEditableSmartContent">
  <pre>cookie = request.cookies["fbs_#{@fb_app_id}"]</pre>
</div>

The cookie value will look something like this (note the double quotes on the ends are included in the value):

<font face="Courier New">"access_token=abcdefg1235&secret=j8675309&session_key=453xyz&sig=3d4f461d9f9e958c344a1671fbb3f931&uid=1001"</font>

(The example cookie value was generated using @fb\_app\_secret = “password1234”)

The next step is to turn the key/value pairs into a hash:

<div style="padding-bottom: 0px;margin: 0px;padding-left: 0px;padding-right: 0px;float: none;padding-top: 0px" class="wlWriterEditableSmartContent">
  <pre>def cookie_values(cookie)
  cookie[1..-2].split('&').reduce({}) do |hash, val|
    parts = val.split('=')
    hash[parts[0]] = parts[1]
    hash
  end
end

fb_info = cookie_values(cookie)</pre>
</div>

(Technically you can validate the cookie without building the hash, but the hash will be useful when you want to later retrieve values such as the access_token or uid)

Now calculate the signature:

<div style="padding-bottom: 0px;margin: 0px;padding-left: 0px;padding-right: 0px;float: none;padding-top: 0px" class="wlWriterEditableSmartContent">
  <pre>def signature(info)
  Digest::MD5.hexdigest(info.keys.reject{|k| k=="sig"}.sort.reduce(""){|out,k| "#{out}#{k}=#{info[k]}"}.to_s + @fb_app_secret)
end
</pre>
</div>

And compare it with the signature in the cookie. If the values are the same, you can trust the cookie has not been manipulated.

<div style="padding-bottom: 0px;margin: 0px;padding-left: 0px;padding-right: 0px;float: none;padding-top: 0px" class="wlWriterEditableSmartContent">
  <pre>valid = fb_info[“sig”] == signature(fb_info)</pre>
</div>