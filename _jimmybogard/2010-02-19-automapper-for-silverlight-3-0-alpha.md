---
id: 390
title: AutoMapper for Silverlight 3.0 Alpha
date: 2010-02-19T02:31:27+00:00
author: Jimmy Bogard
layout: post
guid: /blogs/jimmy_bogard/archive/2010/02/18/automapper-for-silverlight-3-0-alpha.aspx
dsq_thread_id:
  - "264716422"
categories:
  - AutoMapper
---
In between workshops here at the MVP Summit, I’ve been working on pushing out an early Alpha for an AutoMapper version built against Silverlight 3.0.&#160; Thanks to some existing patches from the community, it was pretty straightforward to get things going.&#160; I’ve also started working against an AutoMapper github repository, which also made some other things much, much easier (which I’ll touch on soon).&#160; To get the alpha, grab the binaries from the CodePlex site:

[AutoMapper for Silverlight 3.0 Alpha](http://automapper.codeplex.com/releases/view/40707)

All existing features of AutoMapper 1.0 are supported, except for:

  * IDataReader
  * IListSource

Neither of which even exist in Silverlight 3.0.&#160; Since I don’t do any Silverlight development, I labeled this one as “Alpha” as I’ll need to rely on folks in the wild to let me know if it actually works or not.

### Supporting two runtimes

Before this whole conversion process, I had almost zero experience with Silverlight 3.0.&#160; I vaguely remembered that there was a separate runtime, but it’s really interesting how it all works out.&#160; To get AutoMapper working with Silverlight, I had several big obstacles:

  * Some assemblies don’t exist in Silverlight
  * Some types don’t exist in Silverlight
  * Some types have only partial members defined
  * Some types only have some method overloads defined

Some goals I have is that going foward:

  * Any feature added to AutoMapper will also get added to the Silverlight version
  * Unit tests are executed against the Silverlight version
  * Any test added to AutoMapper will also get added to the Silverlight version

#### Project setup

To support two runtimes against basically one codebase, I opted for a model where I create Silverlight class libraries, then use linked files to keep the source the same.&#160; Linked files allow me to keep only one source code file on disk (and in source control), but reference the same file from two projects.&#160; I created a new project, AutoMapper.Silverlight, and a new unit tests project as well.&#160; Some files weren’t needed as the feature wouldn’t be supported (such as IDataReader), so I just didn’t link that file in.

#### When things don’t line up

If a whole file isn’t supported, that’s fine, I just don’t add it.&#160; But what if the API is different?&#160; For example, Silverlight has no TypeDescriptor class.&#160; In those cases, I relied on conditional compilation to provide two implementations in one file:

<pre><span style="color: blue">private static </span><span style="color: #2b91af">TypeConverter </span>GetTypeConverter(<span style="color: #2b91af">ResolutionContext </span>context)
        {
<span style="color: blue">#if </span>!SILVERLIGHT
            <span style="color: blue">return </span><span style="color: #2b91af">TypeDescriptor</span>.GetConverter(context.SourceType);
<span style="color: blue">#else
            </span><span style="color: gray">var attributes = context.SourceType.GetCustomAttributes(typeof(TypeConverterAttribute), false);

            if (attributes.Length != 1)
                return new TypeConverter();

            var converterAttribute = (TypeConverterAttribute)attributes[0];
            var converterType = Type.GetType(converterAttribute.ConverterTypeName);

            if (converterType == null)
                return new TypeConverter();

            return Activator.CreateInstance(converterType) as TypeConverter;
</span><span style="color: blue">#endif
        </span>}</pre>

[](http://11011.net/software/vspaste)

Because I opened this file from the regular project, the Silverlight code is grayed out.&#160; Opening the file from the Silverlight project makes all that extra code available, while the top part is commented out.&#160; For places where I just couldn’t support features, I’d just leave them out:

<pre><span style="color: blue">public static </span><span style="color: #2b91af">Func</span>&lt;<span style="color: #2b91af">IEnumerable</span>&lt;<span style="color: #2b91af">IObjectMapper</span>&gt;&gt; AllMappers = () =&gt; <span style="color: blue">new </span><span style="color: #2b91af">IObjectMapper</span>[]
        {
<span style="color: blue">#if </span>!SILVERLIGHT
            <span style="color: blue">new </span><span style="color: #2b91af">DataReaderMapper</span>(),
<span style="color: blue">#endif
            new </span><span style="color: #2b91af">TypeMapMapper</span>(<span style="color: #2b91af">TypeMapObjectMapperRegistry</span>.AllMappers()),
            <span style="color: blue">new </span><span style="color: #2b91af">StringMapper</span>(),
            <span style="color: blue">new </span><span style="color: #2b91af">FlagsEnumMapper</span>(),
            <span style="color: blue">new </span><span style="color: #2b91af">EnumMapper</span>(),
            <span style="color: blue">new </span><span style="color: #2b91af">ArrayMapper</span>(),
            <span style="color: blue">new </span><span style="color: #2b91af">EnumerableToDictionaryMapper</span>(),
            <span style="color: blue">new </span><span style="color: #2b91af">DictionaryMapper</span>(),
<span style="color: blue">#if </span>!SILVERLIGHT
            <span style="color: blue">new </span><span style="color: #2b91af">ListSourceMapper</span>(),
<span style="color: blue">#endif
            new </span><span style="color: #2b91af">EnumerableMapper</span>(),
            <span style="color: blue">new </span><span style="color: #2b91af">AssignableMapper</span>(),
            <span style="color: blue">new </span><span style="color: #2b91af">TypeConverterMapper</span>(),
            <span style="color: blue">new </span><span style="color: #2b91af">NullableMapper</span>()
        };
    }</pre>

[](http://11011.net/software/vspaste)

It’s slightly ugly, but the places where I have to do this are very small.&#160; Luckily, things are reasonably factored out that individual features are usually individual classes.

#### Third-party libraries

AutoMapper uses proxy classes to support mapping to interfaces.&#160; Originally, I went with LinFu to do this dynamic proxy stuff because it was small, targeted and focused on what I needed to do.&#160; Unfortunately, there is not a Silverlight version, so I switched to Castle Dynamic Proxy to get things going.

It was a very straightforward switch, as the APIs are quite similar.&#160; The only big fix I had to do was update the IL Merge business, and make sure that I excluded the right types so that interface mapping worked when everything was merged up.

#### Testing

Silverlight unit testing is…weird.&#160; A lot of the documentation out there talks about executing unit tests in a Silverlight application, which is not what I’m interested in.&#160; For NUnit, I merely create a regular class library, and test runners run the test in whatever environment they want.&#160; I needed to find an NUnit version supported for Silverlight, and that was not easy to find.&#160; I went through around three or four different builds out there before I found one I liked:

<http://wesmcclure.tumblr.com/post/152727000>

I also use NBehave, but I didn’t really feel like porting NBehave over as well, so I just grabbed the source files I needed and included them directly in my testing project.

Executing the tests from NAnt was also completely straightforward, and worked as soon as my TestDriven.NET worked.

#### Packaging

Based on community feedback, I built the Silverlight-based AutoMapper assembly as a new assembly name, “AutoMapper.Silverlight.dll”.&#160; The only other work I needed to do was duplicate the packaging NAnt tasks, and make sure I included the relevant Silverlight assemblies into my source repository so that the automated build would work.&#160; Installing Silverlight on a build machine is just a bad idea.

### Final thoughts

The conversion was smoother than I thought it would be.&#160; The biggest hurdles I had were just getting the unit tests running.&#160; The unit testing framework I use doesn’t have a supported Silverlight build, so I had to do quite a bit of hunting to find one that works.&#160; But other than that, linked files and conditional compilation made things quite easy to do.&#160; Also, playing around on github with easy branching and merging made adding intermittent patches to master very easy to do.&#160; In fact, I was even able to cherry pick a single commit to push back to master from a Silverlight branch…but my git experience should wait for another post.

Thanks again to everyone that sent me patches to get Silverlight working with AutoMapper.