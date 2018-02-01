---
id: 3232
title: FluentMigrator getting started
date: 2011-04-02T12:17:10+00:00
author: Sean Chambers
layout: post
guid: http://lostechies.com/seanchambers/?p=127
dsq_thread_id:
  - "269318930"
categories:
  - fluentmigrator
---
I realized on the fluent migrator mailing list today that even though it&#8217;s been around for nearly two years, I&#8217;ve never written any blog posts describing what it is or example of how it works.

There is some documentation with a very basic walkthrough here: <https://github.com/schambers/fluentmigrator/wiki>

**Brief history of FluentMigrator**

When Ruby on Rails first became big everyone grew accustomed to their migration framework that was baked in called [Rails migrations](http://guides.rubyonrails.org/migrations.html). Migration frameworks quickly popped up in other areas and languages. Fast forward a brief time and [Nate Kohari](http://kohari.org/), [Justin Etheredge](http://www.codethinked.com/) and myself threw together [FluentMigrator](https://github.com/schambers/fluentmigrator). Initially, the three of us never took it to completion and some gracious community members took it to working completion.  Around the same time I was finally in a position to use it myself at a new workplace.

Over the last 12 months, there has been several new contributors and many bug fixes from the community. The community and usage of FluentMigrator has finally reached a place where it&#8217;s a living open source project.

**What is a migration framework?**

First things first. Many people aren&#8217;t really familiar with what a migration framework is or if they need one. Many shops I&#8217;ve been at have come up with their own way to version the database, many times only forward through time.

The concept is fairly straightforward. Any modification to your database warrants a &#8220;Migration&#8221;. This migration has both an &#8220;Up&#8221; method (forward through time), and a &#8220;Down&#8221; method (backwards through time). With the use of commandline, nant, msbuild you can automate the migration process during deployments to different environments. The migration framework stores a table in each database (by default FluentMigrator calls it&#8217;s table &#8220;VersionInfo&#8221;, in which it stores what migrations have been applied to that database), with this information, the framework can determine what migrations need to be applied to that database (along with what version you told it to go to on the commandline) and will then execute each migration in succession that it needs to apply.

This has some interesting benefits. Now that we have both a forward direction and a back direction, rolling back a database change is as easy as asking the migration framework to go &#8220;back&#8221; one or more versions. You could even go all the way back to version 0 (a completely empty database) if you wanted to.

FluentMigrator has a fluent interface for manipulating the database at an abstracted level. Because of this database abstraction we&#8217;re able to convert the semantic model built with the fluent interface into database commands on multiple different vendors. Currently FluentMigrator supports MSSQL 2000, 2005, 2008, Jet (Access), MySQL, Sqlite, PostgreSql and Oracle. Implementing a new vendor is as simple as adding your own visitee that gets called via the visitor when a migration is interpeted.

Enough with the jibber jabber. How about some samples?

**Creating a table with columns, one of them being a primary key**

<pre>[Migration(201104021153)]
public class CreateUsersTable : Migration
{
	public override void Up()
	{
		Create.Table("Users")
			.WithColumn("UserId").AsInt32().PrimaryKey().Identity()
			.WithColumn("Name").AsString()
			.WithColumn("PhoneNumber").AsString();
	}

	public override void Down()
	{
		Delete.Table("Users");
	}
}</pre>

Some things to note here:

Every migration is a normal csharp class. I usually place all my migrations in one assembly, I&#8217;ve seen other people place them where their data related code is. It&#8217;s up to you where they go.

Every migration needs a unique identifier in the Migration attribute. This number is interpeted as a long, so we usually use the format of YYYYMMDDHHMM, the chances of two developers creating a migration at the same exact minute are very slim. If we had just normal incremental numbers, we run the chance of two developers of stepping on each other with migration numbers.

Each migration must derive from the &#8220;Migration&#8221; class. This will make you implement both the Up() and Down() methods. As you can see, Up contains the migration code to go forward in time, Down() is the code that is what you would need to do, to undo the Up migration. Simple enough.

**Changing a column name on Users table from &#8220;Name&#8221; to &#8220;FirstName&#8221;**

<pre>[Migration(201104021208)]
public class RenameColumn : Migration
{
	public override void Up()
	{
		Rename.Column("Name").OnTable("Users").To("FirstName");
	}

	public override void Down()
	{
		Rename.Column("FirstName").OnTable("Users").To("Name");
	}
}</pre>

As you can see, on the Migration base class, there is a number of properties that allow you to begin the fluent interface chain. The most common hooks are Create, Delete, Rename, Insert and Execute.

We use the Execute command to call into sql scripts in instances where we need to do something more complex that the fluent interface doesn&#8217;t handle. Usually this is some form of changing data or moving data around that would be difficult with the fluent interface. Execute has two methods: Execute.Sql(&#8220;sql string&#8221;) and Execute.Script(&#8220;myscript.sql&#8221;).

That&#8217;s enough for a primer now, next time we can dive deeper into how we can run the migrations from commandline/nant.

In closing, here&#8217;s some links to FluentMigrator:

  * [FluentMigrator Google Group](http://groups.google.com/group/fluentmigrator-google-group?pli=1)
  * [Project on Github](https://github.com/schambers/fluentmigrator)
  * [Sources on TeamCity.CodeBetter.com](http://teamcity.codebetter.com/viewType.html?buildTypeId=bt82&tab=buildTypeStatusDiv)
  * [Issue Tracker](https://github.com/schambers/fluentmigrator/issues)

Till next time!