---
wordpress_id: 3959
title: Adding git commit information to your assemblies
date: 2010-04-08T04:07:51+00:00
author: Joshua Flanagan
layout: post
wordpress_guid: /blogs/joshuaflanagan/archive/2010/04/08/adding-git-commit-information-to-your-assemblies.aspx
dsq_thread_id:
  - "262097341"
categories:
  - git
  - teamcity
redirect_from: "/blogs/joshuaflanagan/archive/2010/04/08/adding-git-commit-information-to-your-assemblies.aspx/"
---
### The problem

It is a fairly common practice of .NET projects hosted in Subversion to include the repository Revision number as part of the AssemblyVersion. For example, MyWidgets.dll might have a version of 1.2.0.5309, which means it was built from the snapshot of source code at revision 5309. This can be very valuable, as it makes it very easy to trace a binary in the wild back to its original source.

Many projects are now moving towards distributed version control systems (DVCS),&#160; like git, which do not use a simple counter to describe a commit. In git, each commit is represented by a SHA1 hash, which looks something like e5f08d4a9e15943a64014329bd6fd2f348a89b15. Assembly versions in .NET are made up of four 16-bit integers, so it is obvious we cannot include the SHA1 of a commit. We need another way to get a unique number.

### A solution

The solution I’ve been using is to take advantage of the “number of commits since the most recent tag”, as made available through the <a href="http://www.kernel.org/pub/software/scm/git/docs/git-describe.html" target="_blank">git describe</a> command. In order for this to work, you must have at least one tag in your repository. Every time you change the major or minor components of your version, you should create a new tag for that commit. I’ll start by marking commit e5f08d4a9e15943a64014329bd6fd2f348a89b15 as version 1.2.0 (notice I leave off the last version component, as that is the number we will generate):

`$ git tag v1.2.0 e5f08d` 

(Note: tags are not pushed to remotes, by default. Whenever you create a tag that you wish to make public, you must use the &#8211;tags flag when you push. See the <a href="http://progit.org/book/ch2-6.html" target="_blank">Sharing Tags section in Pro Git</a>)

I can now use the describe command like this:

`$ git describe --tags --long` 

which will output:

`v1.2.0-<strong>115</strong>-g4642f26` 

The &#8211;tags flag allows me to use lightweight tags, and the &#8211;long flag makes sure the output is always in the same format. In this example, the number 115 is what we are looking for. That means there have been 115 commits since the most recent tag, which is v1.2.0. The characters after the “g” make up the short version of the current commit’s SHA1. Now its just a simple matter of parsing the describe output so that we can use the number in our assembly version.

### An example

You can see a real world example in <a href="https://github.com/DarthFubuMVC/fubumvc/blob/4bdfd6be1280c700c9f57112eafe7be50ebd7474/rakefile.rb" target="_blank">FubuMVC build script</a>. It is a rake (ruby) script that uses the assemblyinfo task from <a href="http://albacorebuild.net/" target="_blank">Albacore</a> to generate a CommonAssemblyInfo.cs file at build time, which is referenced by all of the projects in the solution. The relevant section is:

<div style="padding-bottom: 0px;margin: 0px;padding-left: 0px;padding-right: 0px;float: none;padding-top: 0px" class="wlWriterEditableSmartContent">
  <pre>desc "Update the version information for the build"
assemblyinfo :version do |asm|
  asm_version = BUILD_NUMBER_BASE + ".0"
  
  begin
	gittag = `git describe --long`.chomp 	# looks something like v0.1.0-63-g92228f4
    gitnumberpart = /-(d+)-/.match(gittag)
    gitnumber = gitnumberpart.nil? ? '0' : gitnumberpart[1]
    commit = (ENV["BUILD_VCS_NUMBER"].nil? ? `git log -1 --pretty=format:%H` : ENV["BUILD_VCS_NUMBER"])
  rescue
    commit = "git unavailable"
    gitnumber = "0"
  end
  build_number = "#{BUILD_NUMBER_BASE}.#{gitnumber}"
  tc_build_number = ENV["BUILD_NUMBER"]
  puts "##teamcity[buildNumber '#{build_number}-#{tc_build_number}']" unless tc_build_number.nil?
  asm.trademark = commit
  asm.product_name = "#{PRODUCT} #{gittag}"
  asm.description = build_number
  asm.version = asm_version
  asm.file_version = build_number
  asm.custom_attributes :AssemblyInformationalVersion =&gt; asm_version
  asm.copyright = COPYRIGHT
  asm.output_file = COMMON_ASSEMBLY_INFO
end
</pre>
</div>

  * Lines 26-27: run the git describe the command, parse the output with a regular expression, and store it in the gitnumberpart variable
  * Line 29: store the full git commit SHA1 number in the commit variable (either using an environment variable available on the build server, or from the git log command)
  * Lines 31-32: just in case the machine running the build does not have the git client installed
  * Line 34: create the full version number by concatenating the BUILD\_NUMBER\_BASE variable with the gitnumber from describe. BUILD\_NUMBER\_BASE can either be hardcoded in the rake script, or read from a VERSION file. It contains the first 3 components of the version (ex: 1.2.0)
  * Lines 35-36: We rewrite our <a href="http://teamcity.codebetter.com/viewType.html?buildTypeId=bt24&tab=buildTypeStatusDiv" target="_blank">TeamCity build number</a> to be the assembly version number followed by the sequence number provided by TeamCity (ex: #1.2.0.115-#330, where 330 is the sequence number from TC)
  * Line 37: We store the full commit SHA1 in the AssemblyTrademark attribute. We use this within the FubuMVC diagnostics pages to provide a link to the github page for the currently executing version of the framework.
  * Line 38: We append the full output of the describe command to the product name and store in AssemblyProduct (ex: FubuMVC v1.2.0-115g4642f26)
  * Lines 40-42: We write the various version attributes. Notice the AssemblyVersion attribute always uses zero for the last component of the version, instead of the ever increasing “commits since tag” number. This is on purpose, since AssemblyVersion is used as part of the assembly name, and should not change unless there are breaking changes. We only adjust the version on every build for AssemblyFileVersion, which is not used by .NET at all, but is visible within the File Properties dialog in Windows Explorer.