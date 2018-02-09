---
wordpress_id: 3949
title: How we handle application configuration
date: 2009-07-13T00:38:15+00:00
author: Joshua Flanagan
layout: post
wordpress_guid: /blogs/joshuaflanagan/archive/2009/07/12/how-we-handle-application-configuration.aspx
dsq_thread_id:
  - "263107816"
categories:
  - infrastructure
  - StructureMap
redirect_from: "/blogs/joshuaflanagan/archive/2009/07/12/how-we-handle-application-configuration.aspx/"
---
We recently overhauled the way we handle configurable settings within our application (server names, email addresses, polling frequencies, etc) . I’m going to present our solution below, but its new enough that I’d like to hear feedback on how others approach the problem.

### The goal

We want a configuration solution with the following traits:

  * **No magic strings**. The configurable values will ultimately be stored with an identifying string key, but we didn’t want client code to have to know and use that string. The potential for typos is high, and maintaining a parallel list of constants is tedious. 
  * **Strongly-typed values**. The configured values will likely be stored as strings in a configuration file, but we never want client code to know that. If the configurable value is numeric, the consumer should get a number. Forcing the consumer to deal with type conversion (and related error handling) would create a lot of duplicate, error prone, “ceremony” code that would obscure the essence of what it is trying to accomplish.
  * **Test friendly.** Client code that depends on a configurable value should not be forced to have any “out of process” dependencies (database, file system, etc.). Ideally, we would like to avoid having to stub expectations or use a test fake for configuration. We would also like to avoid adding any “simple type” (int, bool, string) constructor arguments to our classes, since the <a href="http://www.lostechies.com/blogs/joshuaflanagan/archive/2009/02/03/auto-mocking-explained.aspx" target="_blank">automocker</a> we use cannot handle them. 
  * **Tooling friendly.** We will have a large number of configurable values in many different places around the codebase. Our solution should make it easy to build tooling to generate a sample configuration to document all of the possible settings. We also want to be able to validate an existing configuration to make sure all necessary values have been provided. 

Though not necessary, it would also be nice to have:

  * **Default values.** Users should only have to configure the values that have no sensible default, or values they want to override. It should not be left up to the client code to handle checking for a configured value, or falling back to a hardcoded default. That’s more “ceremony” code, not to mention the fact that multiple clients that use the same configurable settings would all have to know the default. 
  * **App.config/web.config** Storing application configuration settings in an app.config or web.config is a well-established convention in the .NET world. It already has support for encryption, multiple file overrides, and tooling. We should use it if it doesn’t cause too much pain. 

### Our solution in action

To explain our solution, I’ll use the example of a service that associates an uploaded image with a user profile. Users might upload images of all sizes, and in many different formats, but we want to make sure they are all stored in the same size and format. We want to give owner’s of our application the ability to set the standard size and format, so they must be configurable. We also want to make sure the path where images are stored is configurable. Consider the following implementation:

<div style="padding-bottom: 0px;margin: 0px;padding-left: 0px;padding-right: 0px;float: none;padding-top: 0px" class="wlWriterEditableSmartContent">
  <pre>public class AvatarService : IAvatarService
{
    private readonly AvatarSettings _settings;
    private readonly IFileSystem _fileSystem;
    private readonly IImageService _imageService;

    public AvatarService(AvatarSettings settings, IFileSystem fileSystem, IImageService imageService)
    {
        _settings = settings;
        _fileSystem = fileSystem;
        _imageService = imageService;
    }

    public void SaveAvatar(User user, Stream originalImage)
    {
        var extension = _imageService.GetImageExtensionFromMimeType(_settings.PreferredMimeType);
        var pathToSave = Path.Combine(_settings.AvatarStoragePath, user.Id + extension);
        user.AvatarFilePath = pathToSave;
        var scaledImage = _imageService.ScaleImageWithCrop(originalImage,
            _settings.PreferredMimeType,
            _settings.DefaultWidth,
            _settings.DefaultHeight);
        _fileSystem.Write(scaledImage, pathToSave);
    }
}</pre>
</div>

As you can see, in order for the class to make use of these externally configured values, it just needs to take an instance of AvatarSettings in its constructor. At runtime, the settings will be injected by our composition tool (<a href="http://structuremap.sourceforge.net" target="_blank">StructureMap</a>), just like the file system and image services. The AvatarSettings itself is a simple <a href="http://en.wikipedia.org/wiki/Plain_Old_CLR_Object" target="_blank">POCO</a> class:

<div style="padding-bottom: 0px;margin: 0px;padding-left: 0px;padding-right: 0px;float: none;padding-top: 0px" class="wlWriterEditableSmartContent">
  <pre>public class AvatarSettings : DictionaryConvertible
{
    public AvatarSettings()
    {
        PreferredMimeType = System.Net.Mime.MediaTypeNames.Image.Jpeg;
        DefaultWidth = DefaultHeight = 64;
    }

    [ExpandEnvironmentVariables]
    public string AvatarStoragePath { get; set; }
    public int DefaultWidth { get; set; }
    public int DefaultHeight { get; set; }
    public string PreferredMimeType { get; set; }
}

public abstract class DictionaryConvertible
{
    private readonly List&lt;ConvertProblem&gt; _problems = new List&lt;ConvertProblem&gt;();
    public IEnumerable&lt;ConvertProblem&gt; Problems { get { return _problems; } }

    public void AddProblem(ConvertProblem problem)
    {
        _problems.Add(problem);
    }
}</pre>
</div>

I’ll discuss the DictionaryConvertible base class later, but I included it here to show that it does not bring along any extra baggage that would hinder the testability of derived classes. When testing client code like the AvatarService, we can prepare a specific test context by setting configuration values directly on an AvatarSettings instance. This is more natural than stubbing values on a fake. If we are testing a scenario that is not impacted by the configuration values, we can just let the automocker pass in a default instance. 

To set the configurable values for the application, we just need to add corresponding keys to the appSettings section of the app.config/web.config file:

<div style="padding-bottom: 0px;margin: 0px;padding-left: 0px;padding-right: 0px;float: none;padding-top: 0px" class="wlWriterEditableSmartContent">
  <pre>&lt;appSettings&gt;
  &lt;add key="AvatarSettings.AvatarStoragePath" value="%ALLUSERSPROFILE%DovetailCRMAvatars"/&gt;
  &lt;add key="AvatarSettings.DefaultWidth" value="96"/&gt;
  &lt;add key="AvatarSettings.DefaultHeight" value="96"/&gt;
&lt;/appSettings&gt;</pre>
</div>

There are a few things worth noting here. First, I have not included a value for AvatarSettings.PreferredMimeType in the config file. If you look at the source for AvatarSettings, you’ll notice it is set in the constructor. That is how we declare default values. It allows us to avoid cluttering up the config file with a bunch of settings that have reasonable defaults, while still allowing the flexibility to override them if desired. This is illustrated by the DefaultWidth and DefaultHeight settings which have configured values that override the defaults from the constructor. Also notice that the DefaultWidth and DefaultHeight properties are declared as integers (even though the values are strings in the config file) so that client code does not have to do any type conversion. 

The final thing to notice is the [ExpandEnvironmentVariables] attribute that decorates the AvatarStoragePath property. In addition to type conversion, the code that populates a settings object can use additional metadata to do further manipulation of the configured values. In this case, the value “%ALLUSERSPROFILE%DovetailCRMAvatars” will be converted to “c:ProgramDataDovetailCRMAvatars” before any client code ever sees it. This not only simplifies the client code, but eliminates duplication of logic when a settings object has more than one client.

### How it works

So how does this all work? The Settings object needs to be populated from the configuration file, so we define an interface for this responsibility:

<div style="padding-bottom: 0px;margin: 0px;padding-left: 0px;padding-right: 0px;float: none;padding-top: 0px" class="wlWriterEditableSmartContent">
  <pre>public interface ISettingsProvider
{
    DictionaryConvertible PopulateSettings(DictionaryConvertible instance);
}</pre>
</div>

Implementations take in an instance of a DictionaryConvertible derived type, and should return an instance of the same type with all of the settings populated. We have a single implementation, AppSettingsProvider, which gets values from the <appSettings/> section of the app.config/web.config. Under the hood it makes use of a class that knows how to cycle over the properties of an object and set them using values from a dictionary (very similar to the <a href="http://github.com/chadmyers/FubuMVC/blob/58f9aaaa098ca0d652b2c9c2c22f6de5626998e2/src/FubuMVC.Core/Controller/DictionaryConverter.cs" target="_blank">DictionaryConverter</a> in fubumvc). Any problems encountered during the conversion are recorded using the AddProblem method of the DictionaryConvertible, hence the original reason for the base class. We were already using this code to populate the input models for our MVC controller actions (similar to the ModelBinders that were introduced in ASP.NET MVC), so it made sense to re-use it.

The final step is to tell StructureMap how to create instances of the settings classes so that they are properly injected into consumers. In our <a href="http://structuremap.sourceforge.net/RegistryDSL.htm" target="_blank">Registry</a>, we add:

<div style="padding-bottom: 0px;margin: 0px;padding-left: 0px;padding-right: 0px;float: none;padding-top: 0px" class="wlWriterEditableSmartContent">
  <pre>For&lt;AvatarSettings&gt;()
  .Use&lt;AvatarSettings&gt;()
  .EnrichWith((session, original) =&gt; 
      session.GetInstance&lt;ISettingsProvider&gt;().PopulateSettings(original));
</pre>
</div>

This is a good example of making use of the advanced power of your composition tool (and a good argument against trying to make a <a href="http://www.codeplex.com/CommonServiceLocator" target="_blank">Common Service Locator</a> equivalent for service registration). We use the <a href="http://structuremap.sourceforge.net/Interception.htm#section3" target="_blank">EnrichWith</a> statement to tell StructureMap “when I ask you for an AvatarSettings instance, before returning it to me, you should first pass it through the PopulateSettings method of my configured ISettingsProvider.”

Of course, it wasn’t long before we started adding a number of these Settings classes to our codebase, and it became a tedious extra step to add this same registration code for each class. The next logical step was to create a <a href="http://structuremap.sourceforge.net/ScanningAssemblies.htm#section11" target="_blank">custom type scanner</a>:

<div style="padding-bottom: 0px;margin: 0px;padding-left: 0px;padding-right: 0px;float: none;padding-top: 0px" class="wlWriterEditableSmartContent">
  <pre>public class SettingsScanner : ITypeScanner
{
    public void Process(Type type, PluginGraph graph)
    {
        if (!type.Name.EndsWith("Settings") || !typeof (DictionaryConvertible).IsAssignableFrom(type)) return;
        graph.Configure(r =&gt; r.For(type).EnrichWith((session, original) =&gt;
        {
            return session.GetInstance&lt;ISettingsProvider&gt;().PopulateSettings((DictionaryConvertible)original);
        }).TheDefaultIsConcreteType(type));
    }
}</pre>
</div>

We could now remove the previous code from our Registry that registered a single class (AvatarSettings), and replace it with this code which has the same effect for ALL Settings classes in our codebase:</p> 

<div style="padding-bottom: 0px;margin: 0px;padding-left: 0px;padding-right: 0px;float: none;padding-top: 0px" class="wlWriterEditableSmartContent">
  <pre>Scan(x =&gt;
{
    x.TheCallingAssembly();
    x.With&lt;SettingsScanner&gt;();
});</pre>
</div>

### Tooling support

One of our goals was that the configurable settings should be easy to document. With a growing number of Settings classes all over the codebase, it could be very easy to lose track of which values are needed in the configuration file. However, since all of the Settings class follow a convention (derive from DictionaryConvertible, and named with the “Settings” suffix), it is trivial to write a little utility to reflect over the code and write out a sample <appSettings /> section.

<div style="padding-bottom: 0px;margin: 0px;padding-left: 0px;padding-right: 0px;float: none;padding-top: 0px" class="wlWriterEditableSmartContent">
  <pre>public void Execute(string[] args)
{
    var settingTypes = _container.Model.PluginTypes
        .Where(t =&gt; t.PluginType.Name.EndsWith("Settings") && t.PluginType.BaseType == typeof(DictionaryConvertible))
        .Select(t =&gt; t.PluginType);

    dumpSettings(settingTypes, Console.Out);
    Console.WriteLine();
}

private void dumpSettings(IEnumerable&lt;Type&gt; settingTypes, TextWriter output)
{
    var xml = new XmlTextWriter(output) {Formatting = Formatting.Indented};
    xml.WriteStartElement("appSettings");
    settingTypes.Each(t =&gt;
    {
        var settings = Activator.CreateInstance(t);
        var properties = t.GetProperties(BindingFlags.Instance | BindingFlags.DeclaredOnly | BindingFlags.Public);

        properties.Each(p =&gt;
        {
            var key = AppSettingsProvider.DefaultNamingStrategy(p);
            var value = p.GetValue(settings, null);

            xml.WriteStartElement("add");
            xml.WriteAttributeString("key", key);
            xml.WriteAttributeString("value", value == null ? "" : value.ToString());
            xml.WriteEndElement();
        });
    });
    xml.WriteEndElement();
    xml.Close();
}</pre>
</div>

### Summary

All of this comes together to allow a very natural workflow when we decide we need to make a value in our code configurable:

  1. Create a new Settings class (or append to an existing class) that derives from DictionaryConvertible&#160; and add the properties for each of the configurable values we need. Optionally initialize the properties with a default value in the constructor. 
  2. Add the Settings class as a constructor parameter in the client class that needs the configurable value. 
  3. After the client class is done and tested, add an <appSettings /> entry to the application configuration file for each setting without a default value.