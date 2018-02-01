---
id: 4717
title: Up and Running With SQuirrel SQL and SQL Server Express 2005
date: 2009-08-31T16:14:00+00:00
author: Eric Anderson
layout: post
guid: /blogs/eric/archive/2009/08/31/up-and-running-and-squirrel-sql-and-sql-server-express-2005.aspx
categories:
  - Uncategorized
---
Squirrel SQL provides some nice features that SQL Management Studio does not have out-of-the-box including auto-completion of table and column names.&nbsp; Granted, Red Gate makes tools for Management Studio to get the same functionality, but SQuirrel SQL is open source and free.

There are plenty of articles and blog posts around that cover installing SQuirrel, using JDBC with SQL Server, and connecting to SQL Server Express.&nbsp; However, I ran into enough snags getting SQuirrel to connect to my installation of SQL Server Express that I thought a brief how-to was in order.&nbsp; I will show the basic steps that I used to get SQuirrel talking with the database using integrated Windows security.&nbsp; I will also provide some links to useful articles for further reading.

I assume that the machine is starting with a current installation of SQL Server Express.&nbsp; I have tested the information here against the 2005 version.&nbsp; Some settings may be different for 2008.

# Initial Installs

Download and install the following requirements:

  1. The [Java Runtime](http://www.java.com/en/download/manual.jsp)
  2. [SQuirrel SQL](http://squirrel-sql.sourceforge.net/)
  3. The [Microsoft SQL Server JDBC Driver](http://msdn.microsoft.com/en-us/data/aa937724.aspx)

Follow the installation instructions for each of the above as detailed on the provided web sites.&nbsp; This was all pretty straightforward in my experience.&nbsp; The tricky part was setting up the JDBC URL correctly and getting the right driver .dll files copied around so that the JDBC driver can use integrated security.

&nbsp;

# EDIT:&nbsp; Determining the Port Number For Your SQLEXPRESS Instance  


For the MS JDBC driver to connect through TCP/IP, this protocol must be enabled for the database instance that you wish to connect to.&nbsp; SQL Server Configuration Manager is your friend for this.

  1. Launch SQL Server Configuration Manager
  2. In the left pane, navigate to SQL Server Configuration Manager (Local) -> SQL Server 2005 Network Configuration -> Protocols for <instance>
  3. In the right pane, right-click &#8220;TCP/IP&#8221; and enable this protocol if it is not already enabled.
  4. Double-click &#8220;TCP/IP&#8221;
  5. Click the &#8220;IP Addresses&#8221; tab
  6. Scroll to the bottom
  7. Set a port value in IPAll -> TCP Dynamic Ports

Setting the TCP/IP port forces the instance to use a constant port rather than relying on the SQL Server Browser service for forwarding connections.&nbsp; You&#8217;ll need to know the port number of the instance to connect through TCP/IP

# Configuring the JDBC Driver in SQuirrel

SQuirrel supports connections to any database that has a corresponding JDBC driver.&nbsp; And, there are JDBC drivers available practically every major database as well as plenty of flat file formats.&nbsp; For connecting to SQL Server, SQuirrel must be told where to find the Microsoft driver that was installed above.

  * Start SQuirrel SQL
  * Click on the &ldquo;Drivers&rdquo; tab on the left side
  * Either find the existing entry for the Microsoft JDBC driver or add a new one
  * Setup the example URL.&nbsp; Since I am using Windows security, my example URL looks like this: 
      * jdbc:sqlserver://localhost:8433;instanceName=SQLEXPRESS;integratedSecurity=true;databaseName=[catalog];
  * Click the &ldquo;Extra Class Path&rdquo; tab
  * Click the &ldquo;Add&rdquo; button
  * Navigate to and select the sqljdbc4.jar file in the installation directory of the Microsoft SQL Server JDBC Driver
  * Set the class name to com.microsoft.sqlserver.jdbc.SQLServerDriver
  * Click OK

If you are using SQL Server Authentication or need other options, more detailed information can be found on the [Microsoft web site for this driver](http://msdn.microsoft.com/en-us/library/ms378428(SQL.90).aspx).

# Setting Up for Integrated Security

In order for the JDBC driver to use integrated security, it needs access to a particular .dll file named &ldquo;sqljdbc_auth.dll.&rdquo;&nbsp; The JDBC driver ships with three different versions, and the required version varies <span style="text-decoration: line-through">depending on whether the 32-bit or 64-bit version of Java has been installed</span>.&nbsp; The right .dll can be found under the JDBC driver installation directory at:

> <_installation directory_>auth<JVM type>

**EDIT:** It appears that the required version depends on the architecture of SQLEXPRESS that is installed.&nbsp; So, with a 64-bit JVM and 32-bit SQLEXPRESS, I required the 32-bit auth dll.&nbsp; When I switched to SQLEXPRESS 2008&#215;64, I had to switch to the 64-bit auth dll.

In order for the driver to find the .dll at runtime, copy the appropriate &ldquo;sqljdbc_auth.dll&rdquo; into a folder that is already on the system path or add an entry to the PATH environment variable for the directory that contains the .dll file.&nbsp; Do not put the auth .dll under a path that contains spaces.&nbsp; This will NOT work.

If you get the wrong version of the .dll, or if Squirrel cannot find the .dll, you will see a message like

> JcmsImport: This driver is not configured for integrated authentication.

Correct the problem by shutting down SQuirrel, setting up a different auth .dll on the system path, then relaunching SQuirrel and trying again.

More detailed information about using this driver with integrated security is [available from Microsoft](http://msdn.microsoft.com/en-us/library/ms378428(SQL.90).aspx#Connectingintegrated).

# Configuring The First Alias

In order for the JDBC driver to connect to the correct instance, it needs to know the port for that instance.&nbsp; This was one of the details that I initially overlooked.&nbsp; My SQLEXPRESS instance is NOT at the default port.&nbsp; Rather, I had to look in SQL Server Configuration Manager to find the port number.&nbsp; To determine the port for a particular instance, launch Configuration Manager and click &ldquo;Protocols for <instance> &ndash;> TCP/IP (double click) &ndash;> IP Addresses&rdquo; Scroll to the bottom to see &ldquo;IPAll&rdquo; and note the TCP Port setting.&nbsp; This is the port number that needs to be in the JDBC url.&nbsp; For my installation, I used 8433.

To add a new alias follow these steps:

  1. Click on the &ldquo;Alias&rdquo; tab on the left side of SQuirrel.
  2. Click the &ldquo;+&rdquo; symbol to add an alias.
  3. Set the name
  4. Select the Microsoft JDBC Driver that was configured earlier
  5. Edit the URL to set the initial database catalog
  6. Use the &ldquo;Test&rdquo; button to test the connection to the database.

# Further Reading

  * The [Microsoft site for the JDBC driver](http://msdn.microsoft.com/en-us/library/ms378428(SQL.90).aspx) has pretty good information
  * Some good information about problems with integrated authorization can be found on [this blog post](http://blogs.msdn.com/jdbcteam/archive/2007/06/18/com-microsoft-sqlserver-jdbc-sqlserverexception-this-driver-is-not-configured-for-integrated-authentication.aspx).