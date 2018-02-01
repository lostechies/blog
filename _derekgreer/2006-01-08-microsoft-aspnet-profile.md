---
id: 459
title: The Microsoft ASP.Net Profile
date: 2006-01-08T20:23:00+00:00
author: Derek Greer
layout: post
guid: http://www.aspiringcraftsman.com/2006/01/the-microsoft-asp-net-profile/
dsq_thread_id:
  - "315803055"
categories:
  - Uncategorized
---
Starting with ASP.Net 2.0, Microsoft introduced a new suite of personalization features for managing user profile information. The ProfileBase class was introduced to represent a user’s profile and is used much like the HttpSessionState object to store and retrieve data specific to each user. The following provides an overview of the ASP.Net profile features, discusses the profile initialization lifecycle, and provides some guidance to extending the ASP.Net profile features.

## Profile Overview

While there is a suite of classes which work together to facilitate the Profile features, four main classes are involved in the management of user profile data:

**ProfileBase** &#8211; represents the user’s profile

**ProfileProvider** &#8211; abstract base class for implementing ProfileProviders

**ProfileManager** &#8211; utility class for managing profile information

**ProfileModule** &#8211; an IHttpModule used for auto saving the Profile data, migrating
  
anonymous user information, and facilitating custom user profiles

## ProfileBase

The ProfileBase class is used to create the user’s profile. Depending on the configuration, the user’s profile will be an instance of DefaultProfile, ProfileCommon, or a custom ProfileBase class.

The DefaultProfile class is used by ASP.Net to return a default instance of a user profile when the profile feature is enabled but no properties are defined.

ProfileCommon is a dynamically generated class derived from ProfileBase and provides typed access to the user’s profile data. ProfileCommon may also be configured to inherit from a custom class derived from ProfileBase to define properties not specified in the profile configuration section of the application’s config file. This is done by specifying the custom ProfileBase class in the inherits attribute of the configuration section.

Custom user profiles can also be created by deriving from the ProfileBase class. The custom profile class can be assigned to the Profile property of the HttpContext by subscribing to the Profile event of the ProfileModule class and assigning the ProfileEventArgs.Profile property to an instance of the custom profile class. This is done by providing a Profile_Personalize() method in the Global.asax file of the Web application.

Note: Custom profiles assigned to the HttpContext.Profile property must be of type ProfileCommon to be accessed through the Profile property of the System.Web.UI.Page. It is possible to assign a custom profile to the HttpContext.Profile property which is not of type ProfileCommon, but such instances would have to be accessed directly from the HttpContext.Profile property. It is recommended that custom profile classes be instantiated directly or that the ProfileCommon class be configured to inherit from the custom class.

## ProfileProvider

The profile features of ASP.Net follow the Microsoft Provider Model which allows the profile data to be retrieved from different data stores depending on the ProfileProvider used. For instance, the SqlProfileProvider available in the 2.0 .Net framework stores and retrieves profile information from a Microsoft SQL database. To store and retrieve profile information within an Oracle database one would simply implement an OracleProfileProvider and register the new provider in the global machine.config or in the application specific configuration. For more information on the Provider Model, see my previous post: [The Microsoft Provider Model](http://ctrl-shift-b.blogspot.com/2005/10/microsoft-provider-model.html).

## ProfileManager

The ProfileManager class is used to manage user profiles and provides static methods for querying and deleting user profile information. This class is useful for developing global profile management administration.

## ProfileModule

The ProfileModule class is derived from IHttpModule and is used for automatically saving any modified user profile data, for migrating anonymous profile data to an authenticated user’s profile, and for customizing the user profile assigned to the HttpContext.Profile property. By default, the ProfileModule is configured in the global .Net web.config file to handle HttpApplication events. The ProfileModule will be discussed in detail in the profile lifecycle discussion later.

## Profile Configuration

By default, profile information is configured in a configuration section within the application’s configuration file. For example, the following section specifies two properties name “FirstName” and “LastName” to be persisted to and retrieved from the underlying data store.

<pre class="bursh:csharp">&lt;profile&gt;
    &lt;properties&gt;
        &lt;add name="FirstName" type="System.String"/&gt;
        &lt;add name="LastName" type="System.String"/&gt;
    &lt;/properties&gt;
&lt;/profile&gt;
</pre>

The ASP.Net compiler automatically generates a class named ProfileCommon from the settings found within the config file and creates strongly typed properties corresponding to each property specified. This allows code within ASP.Net to get and set profile information with the strongly typed properties:

<pre class="bursh:csharp">protected void Page_Load(object sender, EventArgs e)
{
    Profile.FirstName = "John";
    Profile.LastName = "Doe";
}
</pre>

Because Visual Studio 2005 uses the ASP.Net auto-compilation at design time, the developer can use Intellisense on the generated class to reflect on the available properties during development. Because other project types are not automatically compiled, accessing Profile data through the strongly typed properties is only available when developing within an ASP.Net project. To access the profile data in other project types, it is necessary to use the loosely typed syntax of the ProfileBase indexer:

<pre class="bursh:csharp">protected void SomeMethod()
{
    ProfileBase Profile = ProfileBase.Create();
    Profile["FirstName"] = "John";
    Profile["LastName"] = "Doe";
}
</pre>

## Profile Initialization Lifecycle

For Web applications, the Profile features are initialized through an IHttpModule class named ProfileModule. This is registered in the global web.config file.

On startup, ProfileModule subscribes to the HttpApplication events AcquireRequestState and EndRequest within the ProfileModule.Init() method.

When the HttpApplication.AcquireRequestState event is triggered, the ProfileModule.OnEnter() event handler is called.

In ProfileModule.OnEnter(), if ProfileManager.Enabled is true then the ProfileModule.OnPersonalize() event raise method is called with a new ProfileEventArgs() as its argument.

The ProfileModule.OnPersonalize() method raises an event notification by invoking a private delegate named ProfileEventHandler which triggers the Profile_Personalize() handler within the Global.asax file.

Note: ASP.Net automatically binds all IHttpModule public events to handlers within the Global.asax file using the naming convention modulename\_event. When the Global.asax file contains a Profile\_Personalize() method, this method is automatically registered as a handler to the ProfileModule’s Personalize event.

If present in Global.asax, the Profile\_Personalize() method is called and may set the Profile property of the ProfileEventArgs parameter to provide a custom user Profile class. This property is then checked by OnPersonalize() and is assigned to HttpContext.\_Profile if set. If the Profile property is null then HttpContext._ProfileDelayLoad is set to true. This value is later used to create a new ProfileBase class.

Continuing in ProfileModule.OnEnter(), once the OnPersonalize() event raise method is complete, conditions are checked to see if a previously anonymous user has been authenticated. If an anonymous user has been authenticated and a Profile\_MigrateAnonymous() method has been provided in the Global.asax file, a ProfileMigrateEventArgs class is constructed and the Profile\_MigrateAnonymous() method is called by invoking the private \_MigrateEventHandler delegate. The Profile\_MigrateAnonymous() is then able to retrieve the ProfileCommon instance based on the available ProfileMigrateEventArgs.AnonymousID property and copy any desired properties to the Global.asax Profile instance.

When the HttpContext.Profile property is later accessed within an application, the private \_Profile field is checked to see if an instance of ProfileBase has already been created and is returned if present. If the \_Profile field is null and the \_ProfileDelayLoad field is set to true, the \_Profile field is set to the return value of ProfileBase.Create() and the value of _Profile is returned to the caller.

The ProfileBase.Create() method calls ProfileBase.InitializeStatic() which adds properties from the Web.config file if any exist. If no properties exist after calling InitializeStatic(), a private singleton instance is set to a new instance of the DefaultProfile object and returns the private instance.

<p style="padding-left: 30px">
  <em>Note: The DefaultProfile class represents an empty user profile and is simply an empty extension of the ProfileBase class.</em>
</p>

If properties do exist after returning from InitializeStatic(), ProfileBase.Create() then calls ProfileBase.CreateMyInstance(). ProfileBase.CreateMyInstance() checks to see if the type should be set to a type specified by calling BuildManager.GetProfileType() (which returns “ProfileCommon”) or to the type specified by the inherits attribute specified in Web.config. Reflection is then used to create a new instance of the type and the instance’s Initialize(…) method is called passing in the current username and authentication Boolean value. The resulting object is then returned by the CreateMyInstance() method which is returned by the ProfileBase.Create() method back to the HttpContext.Profile properties get {} block. The private _Profile field is then set to the resulting object and is then returned to the application.

When the HttpApplication.EndRequest event is triggered, the ProfileModule.OnLeave() event handler is called. If a Profile\_ProfileAutoSaving() method is provided within the Global.asax file, this method is called with a new instance of the ProfileAutoSaveEventArgs class given the profile functionality is enabled, the HttpContent.\_Profile field is not null, and profile automatic saving is enabled. The Profile\_ProfileAutoSaving() class may then perform custom profile saving code and may optionally set the ProfileAutoSaveEventArgs.ContinueWithProfileAutoSave property to true or false. When the Profile\_ProfileAutoSaving() event raise method is complete, the ProfileAutoSaveEventArgs.ContinueWithProfileAutoSave property is check. If true, the HttpContent.Profile.Save() method is called which will cause all the underlying Profile property providers to persist any changed values.

## Extending the Profile Functionality

The profile functionality within ASP.Net can be extended both to change the way profile information is persisted to an underlying data store and to change how profile properties are defined.

As stated earlier, the profile functionality follows the Microsoft Provider Model to enable developers to choose how the profile properties are persisted. The .Net Framework comes with a ProfileProvider which persists profile information to a Microsoft SQL database. This provider is configured in the global machine.config file:

<pre class="bursh:csharp">&lt;profile&gt;
    &lt;providers&gt;
        &lt;add name="AspNetSqlProfileProvider" connectionstringname="LocalSqlServer" applicationname="/" type="System.Web.Profile.SqlProfileProvider, System.Web, Version=2.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a"/&gt;
    &lt;providers&gt;
&lt;/profile&gt;
</pre>

The profile configuration is hard-coded to look for the provider “AspNetSqlProfileProvider” by default which can be overridden by using the defaultProvider attribute of the profile configuration section.

To persist profile data to another data store, implement the System.Web.Profile.ProfileProvider abstract class and implement the required methods. The new ProfileProvider can then be registered in the global machine.config file along with the existing AspNetSqlProfileProvider, or may be placed in the application’s local Web.config file.

<pre class="bursh:csharp">&lt;profile&gt;
    &lt;providers&gt;
        &lt;add name="MySourceProfileProvider" connectionstringname="MyODBCServer" applicationname="/" type="MyCompany.Product.Profile.MySourceProfileProvider, MyCompany.Product.Profile, Version=1.0.0.0, Culture=neutral, PublicKeyToken=74b673b3d54dd99a"/&gt;
    &lt;/providers&gt;
&lt;/profile&gt;
</pre>

Each profile property may designate its own provider allowing a user’s profile information to be derived from multiple data stores. To specify a specific provider for a profile property, set the provider attribute of the desired property within the properties element of the profile configuration section:

<pre class="bursh:csharp">&lt;profile&gt;
    &lt;properties&gt;
        &lt;add name="FirstName" type="System.String" provider="”MySourceProfileProvider”/&gt;
        &lt;add name="LastName" type="System.String"/&gt;
    &lt;/properties&gt;
&lt;/profile&gt;
</pre>

In some cases, it may be a requirement to configure profile properties from a location other than the standard config sections such as deriving these values from a database, or allowing components to specify needed profile information from custom config file locations. In this case it is necessary to create a custom ProfileBase class. Unfortunately the public SettingsPropertyCollection property of ProfileBase does not allow classes extending ProfileBase to add to the collection once set to read only. This requires that custom ProfileBase implementations manage a separate collection of profile properties to achieve the desired functionality. Once extended, the ProfileCommon class can be configured to extend this custom ProfileBase class as discussed earlier to add the new profile properties.

## Conclusion

The focus of this posting has been primarily on providing an overview of the new profile features of ASP.Net 2.0, to provide some explanation of the profile initialization life cycle, and to provide some guidance for extending the profile functionality. Happy coding!
