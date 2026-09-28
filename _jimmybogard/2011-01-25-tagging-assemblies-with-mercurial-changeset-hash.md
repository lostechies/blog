---
wordpress_id: 449
title: Tagging assemblies with Mercurial changeset hash
date: 2011-01-25T18:30:37+00:00
author: Jimmy Bogard
layout: post
wordpress_guid: /blogs/jimmy_bogard/archive/2011/01/25/tagging-assemblies-with-mercurial-changeset-hash.aspx
dsq_thread_id:
  - "264785096"
categories:
  - ContinuousIntegration
  - Mercurial
redirect_from: "/blogs/jimmy_bogard/archive/2011/01/25/tagging-assemblies-with-mercurial-changeset-hash.aspx/"
---
Once you move to a [distributed version control system](http://en.wikipedia.org/wiki/Distributed_revision_control) such as [Git](http://git-scm.com/) or [Hg](http://mercurial.selenic.com/), the concept of incremental commit numbers begins to lose its meaning as exists in centralized version control systems such as SVN or TFS.&#160; In centralized VCS, version numbers are kept as an incremental revision number.&#160; Since only one commit can occur against the central repository at a time, it’s easy to keep track of this number.

With distributed VCS, there is no central repository.&#160; The repository is distributed and duplicated to each local machine, with only some external repository metadata pointing to upstream repositories.

As an approximation for revision numbers, many DVCS solutions include a local incremental revision number.&#160; However, this number is not tied to the actual commit/changeset.&#160; Once the local commits are pushed upstream, those local revision numbers don’t travel along.&#160; The upstream repository will have its _own_ local revision numbers.

### Alternates to versioning

A common practice in centralized VCS was to include the revision number as part of the assembly version, so the “revision” part of “Major.Minor.Build.Revision” was the actual VCS revision number.&#160; With DVCS, this number is misleading at the least at completely wrong in general.&#160; The revision number of the upstream repository is completely local to that repository, and has no connection to the individual remote repository’s revision numbers.&#160; That they might be the same is possible, but shouldn’t be counted on.

The whole plan is to tag our assemblies with metadata information that allow us to tie that assembly back to the specific commit whose build produced that artifact.&#160; Because the commit hashes don’t change, those are the best bet to pick for a cross-repository representation of what specific commit produced that assembly.

Now that we have a reliable, cross-repository method to identify a commit, the next question is where to put it.

One option is to include this information in the AssemblyDescriptionAttribute.&#160; It doesn’t really matter, other than deciding on what your convention should be.&#160; Anything in the [System.Reflection](http://msdn.microsoft.com/en-us/library/136wx94f.aspx) namespace should work with the exception of the version attributes, which require a specific format.

### Retrieving the hash

To get the current hash, we can use the “hg log” command, or more easily, the “[hg tip](http://mercurial.selenic.com/wiki/Tip)” command.&#160; We can use the styling to retrieve just the hash of the tip of the current repository: 

<pre>C:devworking [default]&gt; hg tip --template "{node}n"
3f71b6267c8c88ac0585cfa886b1bd533b5607ea</pre>

Because all modern build solutions allow us to call out to command-line tools, all we need to do now is incorporate this into our current assembly-info-generation strategy.&#160; My NAnt solution is:

<pre><span style="color: blue">&lt;</span><span style="color: #a31515">if </span><span style="color: red">test</span><span style="color: blue">=</span>"<span style="color: blue">${environment::variable-exists('BUILD_NUMBER')}</span>"<span style="color: blue">&gt;
        &lt;</span><span style="color: #a31515">property </span><span style="color: red">name</span><span style="color: blue">=</span>"<span style="color: blue">project.fullversion</span>" <span style="color: red">value</span><span style="color: blue">=</span>"<span style="color: blue">${environment::get-variable('BUILD_NUMBER')}</span>" <span style="color: blue">/&gt;
    &lt;/</span><span style="color: #a31515">if</span><span style="color: blue">&gt;
    &lt;</span><span style="color: #a31515">exec </span><span style="color: red">program</span><span style="color: blue">=</span>"<span style="color: blue">hg</span>" <span style="color: red">commandline</span><span style="color: blue">=</span>"<span style="color: blue">tip --template {node}</span>" <span style="color: red">output</span><span style="color: blue">=</span>"<span style="color: blue">changeset.txt</span>" <span style="color: blue">/&gt;
    &lt;</span><span style="color: #a31515">loadfile </span><span style="color: red">file</span><span style="color: blue">=</span>"<span style="color: blue">changeset.txt</span>" <span style="color: red">property</span><span style="color: blue">=</span>"<span style="color: blue">hg.changeset</span>" <span style="color: blue">/&gt;

    &lt;</span><span style="color: #a31515">echo </span><span style="color: red">message</span><span style="color: blue">=</span>"<span style="color: blue">MARKING THIS BUILD AS VERSION ${project.fullversion}</span>" <span style="color: blue">/&gt;
    &lt;</span><span style="color: #a31515">delete </span><span style="color: red">file</span><span style="color: blue">=</span>"<span style="color: blue">${dir.solution}/CommonAssemblyInfo.cs</span>" <span style="color: red">failonerror</span><span style="color: blue">=</span>"<span style="color: blue">false</span>"<span style="color: blue">/&gt;
    &lt;</span><span style="color: #a31515">asminfo </span><span style="color: red">output</span><span style="color: blue">=</span>"<span style="color: blue">${dir.solution}/CommonAssemblyInfo.cs</span>" <span style="color: red">language</span><span style="color: blue">=</span>"<span style="color: blue">CSharp</span>"<span style="color: blue">&gt;
        &lt;</span><span style="color: #a31515">imports</span><span style="color: blue">&gt;
            &lt;</span><span style="color: #a31515">import </span><span style="color: red">namespace</span><span style="color: blue">=</span>"<span style="color: blue">System</span>" <span style="color: blue">/&gt;
            &lt;</span><span style="color: #a31515">import </span><span style="color: red">namespace</span><span style="color: blue">=</span>"<span style="color: blue">System.Reflection</span>" <span style="color: blue">/&gt;
            &lt;</span><span style="color: #a31515">import </span><span style="color: red">namespace</span><span style="color: blue">=</span>"<span style="color: blue">System.Runtime.InteropServices</span>" <span style="color: blue">/&gt;
        &lt;/</span><span style="color: #a31515">imports</span><span style="color: blue">&gt;
        &lt;</span><span style="color: #a31515">attributes</span><span style="color: blue">&gt;
            &lt;</span><span style="color: #a31515">attribute </span><span style="color: red">type</span><span style="color: blue">=</span>"<span style="color: blue">ComVisibleAttribute</span>" <span style="color: red">value</span><span style="color: blue">=</span>"<span style="color: blue">false</span>" <span style="color: blue">/&gt;
            &lt;</span><span style="color: #a31515">attribute </span><span style="color: red">type</span><span style="color: blue">=</span>"<span style="color: blue">AssemblyVersionAttribute</span>" <span style="color: red">value</span><span style="color: blue">=</span>"<span style="color: blue">${project.fullversion}</span>" <span style="color: blue">/&gt;
            &lt;</span><span style="color: #a31515">attribute </span><span style="color: red">type</span><span style="color: blue">=</span>"<span style="color: blue">AssemblyFileVersionAttribute</span>" <span style="color: red">value</span><span style="color: blue">=</span>"<span style="color: blue">${project.fullversion}</span>" <span style="color: blue">/&gt;
            &lt;</span><span style="color: #a31515">attribute </span><span style="color: red">type</span><span style="color: blue">=</span>"<span style="color: blue">AssemblyCopyrightAttribute</span>" <span style="color: red">value</span><span style="color: blue">=</span>"<span style="color: blue">Copyright © ${company.name} ${datetime::get-year(datetime::now())}</span>" <span style="color: blue">/&gt;
            &lt;</span><span style="color: #a31515">attribute </span><span style="color: red">type</span><span style="color: blue">=</span>"<span style="color: blue">AssemblyProductAttribute</span>" <span style="color: red">value</span><span style="color: blue">=</span>"<span style="color: blue">${project::get-name()}</span>" <span style="color: blue">/&gt;
            &lt;</span><span style="color: #a31515">attribute </span><span style="color: red">type</span><span style="color: blue">=</span>"<span style="color: blue">AssemblyCompanyAttribute</span>" <span style="color: red">value</span><span style="color: blue">=</span>"<span style="color: blue">${company.name}</span>" <span style="color: blue">/&gt;
            &lt;</span><span style="color: #a31515">attribute </span><span style="color: red">type</span><span style="color: blue">=</span>"<span style="color: blue">AssemblyConfigurationAttribute</span>" <span style="color: red">value</span><span style="color: blue">=</span>"<span style="color: blue">${project.config}</span>" <span style="color: blue">/&gt;
            &lt;</span><span style="color: #a31515">attribute </span><span style="color: red">type</span><span style="color: blue">=</span>"<span style="color: blue">AssemblyInformationalVersionAttribute</span>" <span style="color: red">value</span><span style="color: blue">=</span>"<span style="color: blue">${project.fullversion}</span>" <span style="color: blue">/&gt;
            &lt;</span><span style="color: #a31515">attribute </span><span style="color: red">type</span><span style="color: blue">=</span>"<span style="color: blue">AssemblyDescriptionAttribute</span>" <span style="color: red">value</span><span style="color: blue">=</span>"<span style="color: blue">${string::trim(hg.changeset)}</span>" <span style="color: blue">/&gt;
        &lt;/</span><span style="color: #a31515">attributes</span><span style="color: blue">&gt;
        &lt;</span><span style="color: #a31515">references</span><span style="color: blue">&gt;
            &lt;</span><span style="color: #a31515">include </span><span style="color: red">name</span><span style="color: blue">=</span>"<span style="color: blue">System.dll</span>" <span style="color: blue">/&gt;
        &lt;/</span><span style="color: #a31515">references</span><span style="color: blue">&gt;
    &lt;/</span><span style="color: #a31515">asminfo</span><span style="color: blue">&gt;

</span></pre>

It’s a bit generic.&#160; First, I use the “exec” task to execute the “hg tip” command and place the output into a file.&#160; I then use the “loadfile” task to read the file into a variable.&#160; I have to jump through these hoops because NAnt doesn’t allow me to place the output of a command directly into a property.

After that, it’s just a matter of modifying my current assembly-info-generation method, in this case the “asminfo” task.&#160; With PSake, it’s slightly different but more of the same.&#160; The calling out to command is different, the common-assembly-info-generation method is different, but the approach is the same.

If you want to get even more interesting, for internal web application projects, I’ll include a hyperlink at the bottom of the screen showing the version, but linking directly to our remote Hg server’s commit in BitBucket.&#160; I know exactly what is deployed without even needing to look at tags, the build server or anything.&#160; Just click the deployed commit hash to see what’s in production.