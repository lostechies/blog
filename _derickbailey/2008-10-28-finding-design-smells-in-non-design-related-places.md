---
wordpress_id: 14
title: Finding Design Smells In Non-Design Related Places
date: 2008-10-28T17:45:45+00:00
author: Derick Bailey
layout: post
wordpress_guid: /blogs/derickbailey/archive/2008/10/28/finding-design-smells-in-non-design-related-places.aspx
dsq_thread_id:
  - "262067919"
categories:
  - Analysis and Design
  - Data Access
  - Design Patterns
  - Domain Driven Design
  - NHibernate
  - Principles and Patterns
  - Refactoring
redirect_from: "/blogs/derickbailey/archive/2008/10/28/finding-design-smells-in-non-design-related-places.aspx/"
---
In <a href="https://lostechies.com/blogs/derickbailey/archive/2008/10/23/encapsulation-entities-collections-and-business-rules.aspx" target="_blank">my last post</a>, I talked about the idea of encapsulation and using it to ensure that our business rules were enforced correctly. What I didn&#8217;t talk about, though, was the second half of the conversation that my coworker and I had, concerning the patent -> consultation relationship. It turns out that we had the relationship wrong. That&#8217;s not to say that patients don&#8217;t have consultations, but that the logical model we were traveling with had an incorrect perspective and was causing us to create some very ugly workarounds in various parts of the system. What really stuck out in my mind, though, was not the idea that we had the model wrong, but how we came to the conclusion of the model being wrong. It has become apparent to me, upon reflection of the conversations and situation as a whole, that design smells are not always evidenced by design related activities, if ever.

### A Persistent Problem &#8211; Duplicate Redundancy

After some initial coding of the patient -> consultation relationship, we start working on the persistence model via NHibernate. What we have is a patient with a collection of consultations &#8211; this is easy to map with NHibernate&#8217;s one-to-many capabilities. We also have a CurrentConsultation property which needs to be mapped. This property is mapped to the same Consultation table, but only pull one specific consultation based on the business rules that state the current consultation is chronologically the most recent and has not ending date set. 

After some thought, we found that there were a few possibilities for handling the CurrentConsultation property in our current model:

  1. Create a &#8220;CurrentConsultation&#8221; object that is mapped to the Consultation table and use a &#8220;<a href="http://www.hibernate.org/hib_docs/nhibernate/1.2/reference/en/html/mapping.html#mapping-declaration-class" target="_blank">where</a>&#8221; class attribute in the NHibernate mapping that would limit the returned result 
      * Create a &#8220;CurrentConsultation&#8221; object that is mapped to a CurrentConsultation view and have the view coded to return the correct consultation object 
          * Add a CurrentConsultationId field to the Patient table, as a foreign key to the Consultations table, and map to the existing Consultation object</ol> 
        After some additional thought, though, we found that each of these solutions has a few significant problems that were going to cause a lot of trouble. 
        
        **Options 1 and 2** 
        
        Both of these options have the problem of duplicating business rules into more than one language and location. We would either have the business rules of what constitutes the current consultation in the NHibernate mapping (the &#8216;where&#8217; attribute) or in a database view, in addition to the already existing code. Changing the rule would mean changing a minimum of two locations where that rule is handled. This is a bad idea no matter how you look at it.
        
        Both of the options have also created a duplication of knowledge from the concept of a Consultation by creating a &#8220;CurrentConsultation&#8221; class and a separate NHibernate map for it. We would have the original Consultation class and the new CurrentConsultation class both representing the same data, making an artificial distinction in our code. Again, this is a bad idea. We don&#8217;t want duplication of these logical concepts. We&#8217;re also not dealing with a <a href="http://domaindrivendesign.org/discussion/messageboardarchive/BoundedContext.html" target="_blank">bounded context</a> or any other logical <a href="http://en.wikipedia.org/wiki/Separation_of_concerns" target="_blank">separation of concerns</a> at this point, so there is no need to separate the concept of a consultation into multiple classes.
        
        **Option 3** 
        
        This doesn&#8217;t appear to have the duplication issue in code, but there is a potential for duplication of data. When we get down to the implementation of NHibernate, we could easily cause duplicate data in the consultation table by saving the current consultation class. We might be able to get around this by not cascading the saves of the current consultation property, but then we&#8217;d be forced to ensure the consultation collection was persisted prior to the patient so that we could update the current consultation object&#8217;s id before saving the patient. Both of these problems sound like a serious pain to me. I&#8217;m betting it&#8217;s possible, but I&#8217;m also betting that it would be a nightmare of trial and error to get it right and a lot more code than we should really have to write.
        
        ### Changing Perspectives
        
        As <a href="https://lostechies.com/blogs/joe_ocampo" target="_blank">Joe Ocampo</a> pointed out in the comments of my original post, we had a problem in our system that was really caused by our lack of correct perspective in the situation. Rather than forcing the idea of a patient being the root <a href="http://domaindrivendesign.org/discussion/messageboardarchive/Aggregates.html" target="_blank">aggregate</a> in this situation, causing us a lot of headache and frustration in trying to model our persistence layer, a simple change in how we looked at the situation helped us solve the persistence problem and greatly simplified how the application worked. 
        
        Joe&#8217;s comment (with some formatting added):
        
        > _&#8220;One thing I like to challenge developers with when I teach DDD is to flip the aggregate to determine if the model is sound._
        > 
        > _I know this is only an example but work with me here.&nbsp; You indicated you are dealing with a medical system.&nbsp; We can assume there are certain entities such as Patient, Consultations, Doctor and Practice. In your example you created a model where the patient is the aggregate root for consultations but what if the Doctor simply asked what consultations do I have today?&nbsp; In this paradigm the Practice is the aggregate root and Consultations are aggregate within where Patient is an aspect of the consultation.&nbsp; The code would look something like this._
        > 
        > <div style="border-right: gray 1px solid;padding-right: 4px;border-top: gray 1px solid;padding-left: 4px;font-size: 8pt;padding-bottom: 4px;margin: 20px 0px 10px;overflow: auto;border-left: gray 1px solid;width: 97.5%;cursor: text;line-height: 12pt;padding-top: 4px;border-bottom: gray 1px solid;font-family: consolas, 'Courier New', courier, monospace;background-color: #f4f4f4">
        >   <div style="padding-right: 0px;padding-left: 0px;font-size: 8pt;padding-bottom: 0px;overflow: visible;width: 100%;color: black;border-top-style: none;line-height: 12pt;padding-top: 0px;font-family: consolas, 'Courier New', courier, monospace;border-right-style: none;border-left-style: none;background-color: #f4f4f4;border-bottom-style: none">
        >     <pre style="padding-right: 0px;padding-left: 0px;font-size: 8pt;padding-bottom: 0px;margin: 0em;overflow: visible;width: 100%;color: black;border-top-style: none;line-height: 12pt;padding-top: 0px;font-family: consolas, 'Courier New', courier, monospace;border-right-style: none;border-left-style: none;background-color: white;border-bottom-style: none">consultations = practiceService(IConsultationService).GetConsultationsFor(doctor);</pre>
        >   </div>
        > </div>
        > 
        > _This also allows the consultation service to encapsulate its own logic for creating a consultation for creating a consultation. You can’t get any closer than that 🙂_
        > 
        > <div style="border-right: gray 1px solid;padding-right: 4px;border-top: gray 1px solid;padding-left: 4px;font-size: 8pt;padding-bottom: 4px;margin: 20px 0px 10px;overflow: auto;border-left: gray 1px solid;width: 97.5%;cursor: text;line-height: 12pt;padding-top: 4px;border-bottom: gray 1px solid;font-family: consolas, 'Courier New', courier, monospace;background-color: #f4f4f4">
        >   <div style="padding-right: 0px;padding-left: 0px;font-size: 8pt;padding-bottom: 0px;overflow: visible;width: 100%;color: black;border-top-style: none;line-height: 12pt;padding-top: 0px;font-family: consolas, 'Courier New', courier, monospace;border-right-style: none;border-left-style: none;background-color: #f4f4f4;border-bottom-style: none">
        >     <pre style="padding-right: 0px;padding-left: 0px;font-size: 8pt;padding-bottom: 0px;margin: 0em;overflow: visible;width: 100%;color: black;border-top-style: none;line-height: 12pt;padding-top: 0px;font-family: consolas, 'Courier New', courier, monospace;border-right-style: none;border-left-style: none;background-color: white;border-bottom-style: none">consultationService.CreateConsultationFor(patient).with(doctor).at(date);</pre>
        >   </div>
        > </div>
        > 
        > _The point I am trying to make is be careful of aggregate roots.&nbsp; Once you go down that path it is really difficult to back the train up and break it apart.&#8221;_
        
        Though our actual implementation was different, this was the same basic conclusion that we had come to &#8211; our perspective on the situation was simply wrong. When we stepped back from the problem and realized that the consultation was the primary focus of the situation, and that a nurse or doctor would be the primary user of that portion of the system, it became rather obvious that our aggregate was in dire need of rework. 
        
        ### A Reflective Perspective
        
        What we ended up with was a Patient object that dealt with all of it&#8217;s demographics information, billing information, etc, without a CurrentConsultation property or even a Consultations list. Then, on the the separated Consultation object, we added a child property of Patient. Once we realized that our Consultation object was the primary focus and made this distinction in our code, we also realized that the Patient object was carrying far too much information around the system. We found that we actually had two very distinct concepts of a patient, determined by two very distinct bounded contexts. 
        
          * In the &#8216;Billing&#8217; context, we needed all of the address , billing, and other demographics information about the patient &#8211; who they are, where they live, what their insurance is, etc. The existing Patient class filled this need. 
              * In the &#8216;Consultations&#8217; context, we did not need anything from the Billing context, except for the person&#8217;s name and patient id. What we really care about in the consultations is medical information about the patient &#8211; their current prescriptions, allergies, past medical care, etc. So, we created a &#8216; patient&#8217; class to represent these needs.</ul> 
            These changed allowed for a much more clearly defined model that was truly reflective of the systems needs. We could easily see the difference between a &#8216;billing&#8217; patient and a &#8216;medical&#8217; patient, and we were able to code each of these areas of the system without the concerns bleeding into each other. Essentially, we decoupled the system at a module level, not just at a class level.
            
            We also found that the NHibernate mapping problems suddenly went away. Since the Consultation class had a child of Patient, it was a simple many-to-one mapping with no strange sequencing or duplicate data issues. In the screens that deal with the consultation directly, we load the consultation as the aggregate root and go from there. In the screens that need to show patient consultation history, we did a simple query and returned all of the consultations for the given patient. Again, we found a way to decouple our system &#8211; this time, at the persistence model. 
            
            ### Design Smells: Not Just A Design Problem
            
            In the end, we were able to recognize a serious design smell in our system &#8211; not by the design itself, though. After all, the original code had encapsulated the needs quite well. But, as it turns out, it was a bad encapsulation at a higher level. It wasn&#8217;t until we started working with the model we had created, specifically trying to persist the model, that we realized our design was not right. 
            
            This change was a huge breakthrough for us, not necessarily in the code or the system that was being built, but in how we look at our systems and our domain models. The realization that design smells are often evidenced not by the design itself, but by how the design is used in the infrastructure and other supporting roles of the system, has had a profound impact on how we look at system design. I&#8217;m now seeing areas of different systems that are encapsulated incorrectly, at a higher level than class design. Recognizing the problem is the first step &#8211; and we&#8217;re now working to rearrange and invert these models to more accurately reflect reality.
            
            Pay attention to the pain that your application, infrastructure and other supporting services are causing you. You may be staring at evidence of a design problem, without realizing it.