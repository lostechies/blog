---
wordpress_id: 908
title: 'Missing EF Feature Workarounds: Encapsulated collections'
date: 2014-05-09T13:21:02+00:00
author: Jimmy Bogard
layout: post
wordpress_guid: http://lostechies.com/jimmybogard/?p=908
dsq_thread_id:
  - "2672365010"
categories:
  - EntityFramework
---
The list of missing EF features is quite long, but several of the items in the list do have workarounds. For encapsulated domain models that enforce their own consistency boundary, [encapsulating a collection](https://lostechies.com/jimmybogard/2010/03/10/strengthening-your-domain-encapsulated-collections/) is quite important to ensure your domain model stays consistent. We might have an operation that needs to invoke some side effects as the result of adding or removing from the collection:

{% gist 9d2b64c2052fb6360a45 %}

But since we expose the collection directly, we can run into some inconsistencies:

{% gist 6934725d2a48246156af %}

To address this issue and only expose operations which we want to allow, we invoke the [encapsulate collection refactoring](http://refactoring.com/catalog/encapsulateCollection.html):

{% gist 643b105b4eec02c74a52 %}

Our collection is now fully encapsulated, however, EF doesn’t support mapping to private fields. You can do tricks to trick EF to map to a field, but underneath the covers, it won’t be able to do things like tracked entities, lazy loading or eager fetching.

So we’re stuck using a property. But what if we used a protected property instead? Or exposed the expression in other ways? One way is to use expression tree rewriting to refer to the public readonly property in one way, but [trick EF into looking at a protected property instead](https://gist.github.com/hazzik/c08eabc7dffdca83eb55) (thanks [hazzik](http://hazzik.ru/)). First, let’s add our protected backing property instead of that private field (protected to get lazy loading etc):

{% gist 7f0cff9d933bd3a77471 %}

We’ve encapsulated our private field into a protected property with the same naming scheme, so only my Order class (or the proxy subclass) can access the full collection. None of my other code needed to change. Next, we’ll use the [DelegateDecompiler](https://github.com/hazzik/DelegateDecompiler) project to help rewrite our expressions that refer to the IEnumerable property. First, our DelegateDecompiler configuration:

{% gist d80b25c65ae8512ca4e0 %}

Then we’ll need to expose our own custom HasMany EF Code First extension method that redirects the property from our IEnumerable one to the backing field. DelegateDecompiler peers into the property of my IEnumerable, recognizes that it’s referring to another property, and then we swap out our IEnumerable property with the found ICollection one:

{% gist d51c490282c33b370aab %}

When we configure EF Code First, our custom HasMany method will be called instead of the EF Code First one, which only accepts ICollection. From inside an EntityTypeConfiguration class:

{% gist 54eddc04c551d663bfcc %}

EF will now use the protected property to load behind the scenes, even though we’re referring to the public property. There is a catch, however, in that if we filter based on that property or use Include, we’ll need to run through the same expression redirection process. Since my EF queries flow through AutoMapper projections, I made sure that I call the DelegateDecompiler’s Decompile method in my extensions:

{% gist b40cdc443c62c881c536 %}

And finally, I need to create my own Include method that replaces EF:

{% gist b27e7f559ba806027216 %}

Now in my code, I’ve injected my expression replacing into the mapping configuration and query pipeline so that if I refer to the collection property, the expression gets redirected to the backing protected property. If I had naming conventions, I could just use reflection to load the property myself, but with the DelegateDecompiler method, it will use whatever the public IEnumerable property accesses.

This certainly [isn’t the only way to encapsulate collections in EF](http://owencraig.com/mapping-but-not-exposing-icollections-in-entity-framework/), but it does allow me to have minimal impact to the surface API of my domain model.&nbsp; While EF doesn’t support encapsulated collections out of the box, with some extensions and redirection, I can continue on with an encapsulated domain model.