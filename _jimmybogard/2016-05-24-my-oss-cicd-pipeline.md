---
wordpress_id: 1188
title: My OSS CI/CD Pipeline
date: 2016-05-24T21:39:20+00:00
author: Jimmy Bogard
layout: post
wordpress_guid: https://lostechies.com/jimmybogard/?p=1188
dsq_thread_id:
  - "4854874587"
categories:
  - OSS
---
As far back as I’ve been doing open source, I’ve borrowed other project’s build scripts. Because build scripts are almost always committed with source control, you get to see not only other projects’ code, but how they build, test and package their code as well.

And with any long-lived project, I’ve changed the build process for my projects more times than I care to count. AutoMapper, that I can remember, started off on NAnt (yes, it’s that old).

These days, I try to make the pipeline as simple as possible, and [AppVeyor](http://www.appveyor.com/) has been a big help with that goal.

### The CI Pipeline

For my OSS projects, all work, including my own, goes through a branch and pull request. Some source control hosts allow you to enforce this behavior, including GitHub. I tend to leave this off on OSS, since it’s usually only me that has commit rights to the main project.

All of my OSS projects are now on the [soon-to-be-defunct project.json](https://blogs.msdn.microsoft.com/dotnet/2016/05/23/changes-to-project-json/), and all are either strictly project.json or a mix of main project being project.json and others being regular .csproj. Taking MediatR as the example, it’s entirely project.json, while AutoMapper has a mix for testing purposes.

Regardless, I still rely on a build script to execute a build that happens both on the local dev machine and the server. For MediatR, I opted for just a plain PowerShell script that I borrowed from projects online.&nbsp; The build script really represents my build pipeline in its entirety, and it’s important for me that this build script actually live as part of my source code and not tied up in a build server. Its steps are:

  * Clean
  * Initialize
  * Build
  * Test
  * Package

Not very exciting, and similar to many other pipelines I’ve seen (in fact, I borrow a lot of ideas from Maven, which has a predefined pipeline).

The script for me then looks pretty straightfoward:

{% gist d0fbae2a5d21b1398192f8d4ebb87285 %}

Cleaning is just removing an artifacts folder, where I put completed packages. Initialization is installing required PowerShell modules and running a “dotnet restore” on the root solution.

Building is just msbuild on the solution, executed [through a PS module](https://github.com/ligershark/psbuild), which MSbuild defers to the dotnet CLI as needed. Testing is the “dotnet test” command against xUnit. Finally, packaging is “dotnet pack”, passing in a special version number I get from AppVeyor.

As part of my builds, I include the incremental build number in my packages. Because of how SemVer works, I need to make sure the build number is alphabetical, so I prefix a build number with leading zeroes, and “57” becomes “0057”.

In my project.json file, I’ve set the version up so that the version from the build gets substituted at package time. But my project.json file determines the major/minor/revision:

{% gist 5820fb7329965cf29db33c7646f24ab5 %}

This build script is used not just locally, but on the server as well. That way I can ensure I’m running the exact same build process reproducibly in both places.

### The CD Pipeline

The next part is interesting, as I’m using AppVeyor to be my CI/CD pipeline, depending on how it detects changes. My goal with my CI/CD pipeline are:

  * Pull requests each build, and I can see their status inside GitHub
  * Pull requests do not push a package (but can create a package)
  * Merges to master push packages to MyGet
  * Tags to master push packages to NuGet

I used to push \*all\* packages to NuGet, but what wound up happening is I would have to move slower with changes because things would just “show up” on people before I had a chance to fully think through the changes to the public.

I still have pre-release packages, but these are a bit more thought-out than I have had in the past.

Finally, because I’m using AppVeyor, my entire build configuration lives in an “appveyor.yml” file that lives with my source control. Here’s MediatR’s:

{% gist ef076407b55ab71cd1016e60c4a81d89 %}

First, the build version I set to be just the build number. Because my project.json file drives the package/assembly version, I don’t need anything more complicated here. I also don’t want any other branches built, just master and pull requests. This makes sure that I can still create branches/PRs inside the same repository without having to be forced to use a second repository.

The build/test/artifacts should be self-explanatory, I want everything flowing through the build script so I don’t want AppVeyor discovering and trying to figure things out itself. Explicit is better.

Finally, the deployments. I want every package to go to MyGet, but only tagged commits to go to NuGet. The first deploy configuration is the MyGet configuration, that deploys only on master to my MyGet configuration (with user-specific encrypted API key). The second is the NuGet configuration, to only deploy if AppVeyor sees a tag.

For public releases, I:

  * Update the project.json as necessary, potentially removing the asterisk for the version
  * Commit, tag the commit, and push both the commit and the tag.

With this setup, the MyGet feed contains \*all\* packages, not just the CI ones. The NuGet feed is then just a “curated” feed of packages of more official packages.

The last part of a release, publicizing it, is a little bit more work. I still like GitHub releases but haven’t found yet a great way of automating a “tag the commit and create a release” process. Instead, I use the tool [GitHubReleaseNotes](https://github.com/Particular/GitHubReleaseNotes) to create the markdown of a release based on the tags I apply to my issues for a release. Finally, I’ll make sure that I update any documentation in the wiki for a release.

I like where I’ve ended up so far, and there’s always room for improvement, but it’s a far cry from when I used to have to manually package and push to NuGet.