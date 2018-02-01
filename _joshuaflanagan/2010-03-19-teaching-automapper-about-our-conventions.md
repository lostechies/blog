---
id: 3958
title: Teaching AutoMapper about our conventions
date: 2010-03-19T19:32:04+00:00
author: Joshua Flanagan
layout: post
guid: /blogs/joshuaflanagan/archive/2010/03/19/teaching-automapper-about-our-conventions.aspx
dsq_thread_id:
  - "262081530"
categories:
  - AutoMapper
  - Conventions
---
I often need to send data from my entities to the client in JSON format to enable rich AJAX functionality. It isn’t practical to serialize the entities directly, so they are first flattened to a data transfer object (DTO) before serialization. For example, the Case entity has a reference to a Contact entity, which has a FirstName property. On the Case DTO, I might have a ContactFirstName property to hold that value. We use <a href="http://www.codeplex.com/AutoMapper" target="_blank">AutoMapper</a> to handle the chore of populating the properties of the DTO using values from the original entity.

### Conventions for mapping our DTOs

AutoMapper requires that we declare up front which which entities will be mapped to which DTOs. It has a lot of intelligent defaults, so once we tell it that a Case can be mapped to a CaseDTO, it can figure out how to populate the ContactFirstName property on the DTO from Case.Contact.FirstName. However, there are some properties on the DTO which aren’t so straightforward, so we have to explicitly configure how they are mapped.

Our DTOs generally follow these rules:

  * For every entity reference property on the source entity, the DTO will have a property of the same name, but of type GUID, which holds the entity identifier. Ex: Case.Contact of type Contact maps to CaseDTO.Contact of type GUID.
  * For every entity reference property on the source entity, the DTO will have a property with the name plus the suffix “ViewURL”, which holds the URL for viewing the referenced entity. Ex: CaseDTO.ContactViewUrl holds the URL for the Case.Contact.
  * For every “list value” (think values that show in a drop-down) property on the source entity, the DTO will have a property with the name plus the suffix “Display”, which holds the localized display value. Ex: Case.Contact.Country will map the value “USA” to CaseDTO.ContactCountry, and the value “United States” to CaseDTO.ContactCountryDisplay.

### Implementing our mapping rules with AutoMapper

It was very easy to teach AutoMapper about the first rule. It took just a single line of code in our configuration:

<div style="padding-bottom: 0px;margin: 0px;padding-left: 0px;padding-right: 0px;float: none;padding-top: 0px" class="wlWriterEditableSmartContent">
  <pre>cfg.CreateMap&lt;Entity, Guid&gt;().ConvertUsing(entity =&gt; entity.Id);</pre>
</div>

This tells Automapper that any time it tries to map a property of a type that derives from Entity to a property of type GUID, execute the lambda to get the Id.

The other two rules were not so easy to apply. AutoMapper currently has no built-in support for defining conventions to build mappings based on aspects of the types or their properties (although I hear this is something being considered for the future). Instead, you have to explicitly declare the custom relationship between each type, and each custom property resolution. You end up with code that looks like this:

<div style="padding-bottom: 0px;margin: 0px;padding-left: 0px;padding-right: 0px;float: none;padding-top: 0px" class="wlWriterEditableSmartContent">
  <pre>Mapper.Initialize(cfg =&gt;
{
    cfg.CreateMap&lt;Entity, Guid&gt;().ConvertUsing(entity =&gt; entity.Id);
    cfg.CreateMap&lt;Case, CaseDTO&gt;()
        .ForMember(d =&gt; d.ContactViewUrl, map =&gt; map.ResolveUsing&lt;UrlValueResolver&gt;().FromMember(s =&gt; s.Contact))
        .ForMember(d =&gt; d.SiteViewUrl, map =&gt; map.ResolveUsing&lt;UrlValueResolver&gt;().FromMember(s =&gt; s.Site))
        .ForMember(d =&gt; d.InstalledPartViewUrl, map =&gt; map.ResolveUsing&lt;UrlValueResolver&gt;().FromMember(s =&gt; s.InstalledPart))
        // ... and the rest of the ViewUrl properties
        .ForMember(d =&gt; d.CaseTypeDisplay, map =&gt; map.ResolveUsing&lt;ListValueResolver&gt;().FromMember(s =&gt; s.CaseType))
        .ForMember(d =&gt; d.StatusDisplay, map =&gt; map.ResolveUsing&lt;ListValueResolver&gt;().FromMember(s =&gt; s.Status))
        // ... and the rest of the Display properties
        ;
    cfg.CreateMap&lt;Site, SiteDTO&gt;()
        .ForMember(d =&gt; d.SupportSiteViewUrl, map =&gt; map.ResolveUsing&lt;UrlValueResolver&gt;().FromMember(s =&gt; s.SupportSite))
        // ... and the rest of the ViewUrl properties
        .ForMember(d =&gt; d.PrimaryAddressCountryDisplay, map =&gt; map.ResolveUsing&lt;ListValueResolver&gt;().FromMember(s =&gt; s.PrimaryAddress.Country))
        // ... and the rest of the Display properties
        ;
    cfg.CreateMap&lt;Part, PartDTO&gt;()
        // ... all of the ViewUrl properties
        // ... all of the Display properties
        ;
    // ... and the rest of the Entities
});
</pre>
</div>

The sample is abbreviated because showing all of the entities, and all of the ViewUrl and Display property mappings for each of those entities is just too repetitive to be interesting. Aside from the tedium of having to type it up the first time, it makes maintenance a lot more painful. Any time we add an entity or list value property to an entity, we would have to remember to go add the corresponding mapping to the AutoMapper configuration, or risk introducing bugs.

### Declaring mapping rule conventions

The benefit of establishing conventions in your code is that different parts of the system can rely on those conventions, so you get a lot of functionality that just works the way you would expect. Since we consistently name our DTOs the same way, and we consistently name properties on the DTO the same way, we should be able to rely on the fact that these will always be populated the same way.

With a couple patches to AutoMapper (now available in the <a href="http://github.com/jbogard/automapper" target="_blank">latest source</a>), I was able to build some extension methods that allowed me to express our conventions. The previous (which had to be edited for length) code can now be rewritten as:

<div style="padding-bottom: 0px;margin: 0px;padding-left: 0px;padding-right: 0px;float: none;padding-top: 0px" class="wlWriterEditableSmartContent">
  <pre>Mapper.Initialize(cfg =&gt;
{
    cfg.CreateMap&lt;Entity, Guid&gt;().ConvertUsing(entity =&gt; entity.Id);
    cfg.CreateMapsForSourceTypes(x =&gt; x.CanBeCastTo&lt;Entity&gt;(),
        type =&gt; Type.GetType(typeof (ListItemMethodDTO).Namespace + "." + type.Name + "DTO"),
        (map, source, destination) =&gt;
        {
            map.MapViewUrls(source, destination);
            map.MapDisplayValues(source, destination);
        });
});</pre>
</div>

Now the code expresses our convention: for every type that derives from Entity, map it to a type (in a given namespace) with the same name with a DTO suffix, and map all the ViewUrl and Display members appropriately.

I’ve posted the <a href="http://gist.github.com/338069" target="_blank">full source for our extension methods</a>, but the CreateMapsForSourceTypes method is probably the only one that is generally applicable:

<div style="padding-bottom: 0px;margin: 0px;padding-left: 0px;padding-right: 0px;float: none;padding-top: 0px" class="wlWriterEditableSmartContent">
  <pre>public static void CreateMapsForSourceTypes(this IConfiguration configuration, Func&lt;Type, bool&gt; filter, Func&lt;Type, Type&gt; destinationType, Action&lt;IMappingExpression, Type, Type&gt; mappingConfiguration)
{
    var typesInThisAssembly = typeof (AutoMapperExtensions).Assembly.GetExportedTypes();
    CreateMapsForSourceTypes(configuration, typesInThisAssembly.Where(filter), destinationType, mappingConfiguration);
}

public static void CreateMapsForSourceTypes(this IConfiguration configuration, IEnumerable&lt;Type&gt; typeSource, Func&lt;Type, Type&gt; destinationType, Action&lt;IMappingExpression, Type, Type&gt; mappingConfiguration)
{
    foreach (var type in typeSource)
    {
        var destType = destinationType(type);
        if (destType == null) continue;
        var mappingExpression = configuration.CreateMap(type, destType);
        mappingConfiguration(mappingExpression, type, destType);
    }
}</pre>
</div>

It simply takes a criteria for identifying your source types, a function for determining the destination type based on the source type, and a set of configuration steps that should be applied to each mapping. Goodbye repetitive code!