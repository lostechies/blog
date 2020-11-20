---
title: 'Conventional Options'
date: 2020-11-20T07:00:00+00:00
author: Derek Greer
layout: post
---

I've really enjoyed working with the Microsoft Configuration libraries introduced with .Net Core approximately 5 years ago.  The older XML-based API was quite a pain to work with, so the ConfigurationBuilder and associated types provided a long overdue need for the platform.  

I had long since adopted a practice of creating discrete configuration classes populated and registered with a DI container over direct use of the ConfigurationManager class within components, so I was pleased to see the platform nudge developers in this direction through the introduction of the IOptions<T> type.

A few aspects surrounded the prescribed use of the IOptions<T> type of which I wasn't particularly fond were needing to inject IOptions<T> rather than the actual options type, taking a dependency upon the Microsoft.Extensions.Options package from my library packages, and the cermony of binding the options to the IConfiguration instance.  To address these concerns, I wrote some extension methods which took care of binding the type to my configuration by convention (i.e. binding a type with a suffix of Options to a section corresponding to the option type's prefix) and registering it with the container. 

I've recently released a new version of these extensions supporting several of the most popular containers as an open source library.  You can find the project [here](http://github.com/derekgreer/conventional-options).

The following are the steps for using these extensions:


### Step 1
Install ConventionalOptions for the target DI container:

```
$> nuget install ConventionalOptions.DependencyInjection
```

### Step 2
Add Microsoft's Options feature and register option types:

```csharp
  services.AddOptions();
  services.RegisterOptionsFromAssemblies(Configuration, Assembly.GetExecutingAssembly());
```

### Step 3
Create an Options class with the desired properties:

```csharp
    public class OrderServiceOptions
    {
        public string StringProperty { get; set; }
        public int IntProperty { get; set; }
    }
```

### Step 4
Provide a corresponding configuration section matching the prefix of the Options class (e.g. in appsettings.json):

```json
{
  "OrderService": {
    "StringProperty": "Some value",
    "IntProperty": 42
  }
}
```

### Step 5
Inject the options into types resolved from the container:

```csharp
    public class OrderService
    {
        public OrderService(OrderServiceOptions options)
        {
            // ... use options
        }
    }
```

Currently ConventionalOptions works with Microsoft's DI Container, Autofac, Lamar, Ninject, and StructureMap.  

Enjoy!
