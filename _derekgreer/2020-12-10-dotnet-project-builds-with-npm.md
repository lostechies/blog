---
title: '.Net Project Builds with Node Package Manager'
date: 2020-12-10T07:00:00+00:00
author: Derek Greer
layout: post
---
A few years ago, I wrote an article entitled [Separation of Concerns: Application Builds & Continuous Integration](http://aspiringcraftsman.com/2016/02/28/separation-of-concerns-application-builds-continuous-integration/) wherein I discussed the benefits of separating project builds from CI/CD concerns by creating a local build script which lives with your project.  Not long after writing that article, I was turned on to what I’ve come to believe is one of the easiest tools I’ve encountered for managing .Net project builds thus far: npm.

Most development platforms provide a native task-based build technology.  Microsoft’s tooling for these needs is MSBuild: a command-line tool whose build files double as Visual Studio’s project and solution definition files.  I used MSBuild briefly for scripting custom build concerns for a couple of years, but found it to be awkward and cumbersome.  Around 2007, I abandoned use of MSBuild for creating builds and began using Rake.  While it had the downside of requiring a bit of knowledge of Ruby, it was a popular choice among those willing to look outside of the Microsoft camp for tooling and had community support for working with .Net builds through the [Albacore](https://www.codemag.com/article/1006101/Building-.NET-Systems-with-Ruby-Rake-and-Albacore) library.  I’ve used a few different technologies since, but about 5 years ago I saw a demonstration of the use of npm for building .Net projects at a conference and I was immediately sold.  When used well, it really is the easiest and most terse way to script a custom build for the .Net platform I’ve encountered.

“So what’s special about npm?” you might ask.  The primary appeal of using npm for building applications is that it’s easy to use.  Essentially, it’s just an orchestration of shell commands. 

Tasks
With other build tools, you’re often required to know a specific language in addition to learning special constructs peculiar to the build tool to create build tasks.  In contrast, npm’s expected package.json file simply defines an array of shell command scripts:


{
  "name": "example",
  "version": "1.0.0",
  "description": "",
  "scripts": {
    "clean": "echo Clean the project.",
    "restore": "echo Restore dependencies.",
    "compile": "echo Compile the project.",
    "test": "echo Run the tests.",
    "dist": "echo Create a distribution."
  },
  "author": "Some author",
  "license": "ISC"
}




As with other build tools, NPM provides the ability to define dependencies between build tasks.  This is done using pre- and post- lifecycle scripts.  Simply, any task issued by NPM will first execute a script by the same name with a prefix of “pre” when present and will subsequently execute a script by the same name with a prefix of “post” when present.  For example:


{
  "name": "example",
  "version": "1.0.0",
  "description": "",
  "scripts": {
    "clean": "echo Clean the project.",
    "prerestore": “npm run clean”,
    "restore": "echo Restore dependencies.",
    "precompile": "npm run restore",
    "compile": "echo Compile the project.",
    "pretest": "npm run compile",
    "test": "echo Run the tests.",
    "prebuild": "npm run test",
    "build": "echo Publish a distribution."
  },
  "author": "Some author",
  "license": "ISC"
}



Based on the above package.json file, issuing “npm run build” will result in running the tasks of clean, restore, compile, test, and build in that order by virtue of each declaring an appropriate dependency.  

Given you’re okay with limiting a fully-specified dependency chain where a subset of the build can be initiated at any stage (e.g. running “npm run test” and triggering clean, restore, and compile first) , the above orchestration can be simplified by installing the npm-run-all node dependency and defining a single pre- lifetime script for the main build target:


{
  "name": "example",
  "version": "1.0.0",
  "description": "",
  "scripts": {
    "clean": "echo Clean the project.",
    "restore": "echo Restore dependencies.",
    "compile": "echo Compile the project.",
    "test": "echo Run the tests.",
    "prebuild": "npm-run-all clean restore compile test",
    "build": "echo Publish a distribution."
  },
  "author": "John Doe",
  "license": "ISC",
  "devDependencies": {
    "npm-run-all": "^4.1.5"
  }
}





In this example, issuing “npm run build” will result in the prebuild script executing npm-run-all with the parameters: clean, restore, compile and test which it will execute in the order listed.

Variables
Aside from understanding how to utilize the pre- and post- lifecycle scripts to denote task dependencies, the only other thing you really need to know is how to work with variables.

Node’s npm command facilitates the definition of variables by command-line parameters as well as declaring package variables.  When npm executes, each of the properties declared within the package.json are flattened and prefixed with “npm_package_”.  For example, the standard “version” property can be used as part of a dotnet build to denote a project version by referencing ${npm_package_version}:


{
  "name": "example",
  "version": "1.0.0",
  "description": "",
  "configuration": "Release",
  "scripts": {
    "build": "dotnet build ./src/*.sln /p:Version=${npm_package_version}"
  },
  "author": "John Doe",
  "license": "ISC",
  "devDependencies": {
    "npm-run-all": "^4.1.5"
  }
}




Command-line parameters can also be passed to npm and are similarly prefixed with “npm_config_” with any dashes (“-”) replaced with underscores (“_”).  For example, the previous version setting could be passed to dotnet.exe in the following version of package.json by issuing the below command:

	npm run build --product-version=2.0.0


{
  "name": "example",
  "version": "1.0.0",
  "description": "",
  "configuration": "Release",
  "scripts": {
    "build": "dotnet build ./src/*.sln /p:Version=${npm_config_product_version}"
  },
  "author": "John Doe",
  "license": "ISC",
  "devDependencies": {
    "npm-run-all": "^4.1.5"
  }
}



(Note: the parameter --version is an npm parameter for printing the version of npm being executed and therefore can’t be used as a script parameter.)

The only other important thing to understand about the use of variables with npm is that the method of dereferencing is dependent upon the shell used.  When using npm on Windows, the default shell is cmd.exe.   If using the default shell on Windows, the version parameter would need to be deference as %npm_config_product_version%:


{
  "name": "example",
  "version": "1.0.0",
  "description": "",
  "configuration": "Release",
  "scripts": {
    "build": "dotnet build ./src/*.sln /p:Version=%npm_config_product_version%"
  },
  "author": "John Doe",
  "license": "ISC",
  "devDependencies": {
    "npm-run-all": "^4.1.5"
  }
}




Until recently, I used a node package named “cross-env” which allows you to normalize how you dereference variables regardless of platform, but for several reasons including cross-env being placed in maintenance mode, the added dependency overhead, syntax noise, and support for advanced variable expansion cases such as default values, I’d recommend any cross-platform execution be supported by just standardizing on a single shell (e.g. “Bash”).  With the introduction of  Windows Subsystem for Linux and the virtual ubiquity of git for version control, most developer Windows systems already contain the bash shell.  To configure npm to use bash at the project level, just create a file named .npmrc at the package root containing the following line:

script-shell=bash


Using Node Packages
While not necessary, there are many CLI node packages that can be easily leveraged for aiding in authoring your builds.  For example, a package named “rimraf”, which functions like Linux’s “rm -rf” command, is a utility you can use to implement a clean script for recursively deleting any temporary build folders created as part of previous builds.  In the following package.json build, a package target builds a NuGet package which it outputs to a dist folder in the package root.  The rimraf command is used to delete this temp folder as part of the build script’s dependencies:


{
  "name": "example",
  "version": "1.0.0",
  "description": "",
  "scripts": {
    "clean": "rimraf dist",
    "prebuild": "npm run clean",
    "build": "dotnet pack ./src/ExampleLibrary/ExampleLibrary.csproj -o dist /p:Version=${npm_package_version}"
  },
  "author": "John Doe",
  "license": "ISC",
  "devDependencies": {
    "npm-run-all": "^4.1.5",
    "rimraf": "^3.0.2"
  }
}





If you’d like to see a more complete example of npm at work, you can check out the [build for ConventionalOptions](https://github.com/derekgreer/conventional-options/blob/master/package.json) which supports tasks for building, testing, packaging, and publishing nuget packages for both release and prerelease versions of the library.