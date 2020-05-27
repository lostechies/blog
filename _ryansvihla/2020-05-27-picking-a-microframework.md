# Picking a web microframework for an existing Scala codebase

I've had to use this at work the last couple of weeks. We had a "home grown" framework for a new application 
we're working and the first thing I did was try and rip that out (new project so didn't have URL and parameter sanitization
anyway to do routes, etc).

However, being that the group I was working with is pretty "anti framework" I had to settle on something that was light weight, integrated
with jetty and allowed us to work the way that was comfortable for us as team (also it had to work with Scala).

## Microframeworks

The team had shown a lot of disdain for Play (which I had actually quite a lot when I last was leading a JVM based tech stack) and Spring Boot as being too heavy weight, so these
were definitely out.

Fortunately, in the JVM world there is a big push back now on heavy web frameworks so meant I had lots of choices for "non frameworks" but could
still do some basic security, routing, authentication but not hurt the existing team's productivity. 

There are probably 3 dozen microframeworks to choose from with varying degrees of value but the two that seemed to easiest to start with today were:

* [Scalatra](https://scalatra.org)
* [Javalin](https://javalin.io)
* [Quarkus](https://quarkus.io)

### My Attempt with Quarkus

[Quarkus](https://quarkus.io/) has a really great getting started story but it's harder to get started on an existing project with it, it was super trivial to add, and after a couple of days of figuring out the magic incantation I just decided to punt on it.
I think because of it's popularity in the Cloud Native space (which we're trying to target), the backing of [Red Hat](https://developers.redhat.com/blog/2019/03/07/quarkus-next-generation-kubernetes-native-java-framework/), and the pluggable nature of the stack there are a lot of reasons to want this to work. 
In the end because of the timeline it didn't make the cut. But it may come back.

### My Attempt with Javalin

Javalin despite being a less popular project than Quarkus it is getting some buzz. It also looks like it just slides into the team's existing Servlet code base. I wanted this to work very badly but stopped before 
I even started because of [this issue](https://github.com/tipsy/javalin/issues/931) so this was out despite being on paper a really execellent framework.

### My Attempt with Scalatra

[Scalatra](https://scalatra.org/) has been around for a number of years and is inspired by [Sinatra](http://sinatrarb.com/) which I used quite a bit in my Ruby years. 
This took a few minutes to get going just following their [standalone directions](https://scalatra.org/guides/2.7/deployment/standalone.html) and then some more to successful convert the routes
and account for learning curves with routes.

Some notes:

* The routing API and parameters etc are very nice to work with IMO.
* It was [very easy](https://scalatra.org/guides/2.7/formats/json.html) to get json by default support setup.
* Metrics were [very easy](https://scalatra.org/guides/2.7/monitoring/metrics.html) to wire up.
* Swagger integration was pretty rough, while it looks good on paper I could not get an example to show up, and it is unable to [handle case classes or enums](https://github.com/scalatra/scalatra/issues/343) which we use.
* Benchmark performance when I've [looked](https://johnykov.github.io/bootzooka-akka-http-vs-scalatra.html) around the web was pretty bad, I've not done enough to figure out if this is real or not. I've seen first hand a lot of benchmarking are just wrong.
* Integration with JUnit has been rough and I cannot seem to get the correct port to fire, I suspect I have to stop using the @Test annotation is all (which I'm not enjoying).
* Http/2 support is still lacking despite being available in the version of Jetty they're on, I've read a few places that an issue is keeping [web sockets working](https://github.com/eclipse/jetty.project/issues/1364) but either way there is [no official support in the project yet](https://github.com/scalatra/scalatra/issues/757).

## Conclusion

I think we're going to stick with Scalatra for the time being as it is a muture framework that works well for our current goals. However, the lack of http/2 support maybe a deal breaker in the medium term.
