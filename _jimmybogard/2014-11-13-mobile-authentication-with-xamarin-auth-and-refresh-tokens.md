---
id: 981
title: Mobile authentication with Xamarin.Auth and refresh tokens
date: 2014-11-13T13:46:49+00:00
author: Jimmy Bogard
layout: post
guid: http://lostechies.com/jimmybogard/?p=981
dsq_thread_id:
  - "3220632017"
categories:
  - Xamarin
---
An internal app I’ve been working with for a while needed to use OAuth2 (specifically, [OpenID Connect](http://openid.net/connect/)) to perform authentication against our Google Apps for Your Domain (GAFYD) accounts. Standard OAuth 1.0/2.0 flows are made easy with the [Xamarin.Auth](https://components.xamarin.com/view/xamarin.auth) component. Since OpenID Connect is built on top of OAuth 2.0, the Xamarin.Auth component could suffice.

A basic flow for using OAuth with Google APIs would look like this:

[<img style="border-top: 0px;border-right: 0px;border-bottom: 0px;padding-top: 0px;padding-left: 0px;border-left: 0px;padding-right: 0px" border="0" alt="image" src="http://lostechies.com/jimmybogard/files/2014/11/image_thumb.png" width="364" height="377" />](http://lostechies.com/jimmybogard/files/2014/11/image.png)

But for our purposes, we have a mobile application that connects to _our_ APIs, but we simply want to piggyback on top of Google for authentication. So our flow looks more like:

[<img style="border-top: 0px;border-right: 0px;border-bottom: 0px;padding-top: 0px;padding-left: 0px;border-left: 0px;padding-right: 0px" border="0" alt="image" src="http://lostechies.com/jimmybogard/files/2014/11/image_thumb1.png" width="405" height="333" />](http://lostechies.com/jimmybogard/files/2014/11/image1.png)

This all works great straight out of the box, very nicely. One problem however – the token returned by the Google servers is only valid for a short period of time – 30 minutes or so. You \*could\* ignore this problem in the API we built, and not validate that part of the JWT. However, we don’t want to do that. Because we’re now going over the interwebs with our API calls, and potentially over insecure networks like coffee shop wi-fi, we want a solid verification of the JWT token:

  * The token’s hash matches
  * The issuer is valid (Google)
  * The allowed audience is correct – we only accept client IDs from our app
  * The certificate is signed against Google’s public OAuth certificates
  * The token has not expired

This becomes a bit of a problem – the token expires very soon, and it’s annoying to log in every time you use the app. The Xamarin.Auth component supports storing the token on the device, so that you can authenticate easily across app restarts. However, out-of-the-box, Xamarin.Auth doesn’t support the concept of [refresh tokens](https://developers.google.com/accounts/docs/OAuth2WebServer#refresh):

[<img style="border-top: 0px;border-right: 0px;border-bottom: 0px;padding-top: 0px;padding-left: 0px;border-left: 0px;padding-right: 0px" border="0" alt="image" src="http://lostechies.com/jimmybogard/files/2014/11/image_thumb2.png" width="428" height="428" />](http://lostechies.com/jimmybogard/files/2014/11/image2.png)

Since the refresh token is stored on the device, we just need to ask Google for another refresh token once the current token has expired. To get Xamarin.Auth to request a refresh token, we need to do a couple of things: first, override the GetInitialUrlAsync method to request a refresh token as part of getting an auth token:

[gist id=059d278cb06b1602b959]

The format of the URL is from Google’s documentation, plus looking at the behavior of the [existing Xamarin.Auth component](https://github.com/xamarin/Xamarin.Auth/blob/master/src/Xamarin.Auth/OAuth2Authenticator.cs#L210). Next, we create a method to request our refresh token if we need one:

[gist id=62591cd829477c02e5af]

I have a [pull request open](https://github.com/xamarin/Xamarin.Auth/pull/79) to include this method out-of-the-box, but until then, we’ll just need to code it ourselves. Finally, we just need to call our refresh token as need be before making an API call:

[gist id=77c48524dc801342bf87]

In practice, we’d likely wrap up this behavior around every call to our backend API, checking the expiration date of the token and refreshing as needed. In our app, we just a simple decorator pattern around an API gateway interface, so that refreshing our token was as seamless as possible to the end user.

In your apps, the URL will likely be different in format, but the basic format is the same. With persistent refresh tokens, users of our mobile application log in only once, and the token refreshes as needed. Very easy with Xamarin and the Xamarin.Auth component!

Some minor complaints with the component, however. First, it’s not a Xamarin.Forms component, so all the code around managing accounts and displaying the UI had to be in our platform-specific projects. Second, there’s no support for Windows Phone, even though there are issues and pull requests to fill in the behavior. Otherwise, it’s a great component that makes it simple to add robust authentication through your own OAuth provider or piggybacking on a 3rd party provider.