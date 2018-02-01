---
id: 338
title: 'Mongoid: Polymorphic Find Or Create New On Embedded Document Collections'
date: 2011-05-19T07:15:55+00:00
author: Derick Bailey
layout: post
guid: http://lostechies.com/derickbailey/?p=338
dsq_thread_id:
  - "307931359"
categories:
  - Mongoid
  - Ruby
---
In the old v2.0.beta.20 version of Mongoid, I was able to call .find\_or\_create_by on an embedded document collection and pass a type as a second parameter to the method. This would allow me to create a document of a specific type when I needed to, instead of creating a document of the type specified in the original relationship.

For example, given this entity structure:

<pre class="brush:ruby">class Assessment
  include Mongoid::Document

  embeds_many :questions
end

class Question
  include Mongoid::Document
  
  embedded_in :assessment

  field :name
end

class YesNoQuestion &lt; Question
  field :yes, :type =&gt; Boolean
end
</pre>

 

I would be able to call this:

<pre class="brush:ruby">assessment.questions.find_or_create_by({:name =&gt; "Some name"}, YesNoQuestion)
</pre>

 

and it would create the YesNoQuestion type and add it to the assesment.questions collection, instead creating the base question type.

 

### Rolling My Own

Well, we upgraded to v2.0.1 recently, and the .find\_or\_create_by method signature has changed. It no longer supports creation of a specified type. In fact, it doesn&#8217;t want me to pass a second parameter to the method at all. But I need to be able to do this in the same way, for the same reasons, as I was doing it with beta.20. I asked [on the mailing list](http://groups.google.com/group/mongoid/browse_thread/thread/a4fe12e25b5a2809) and [on stackoverflow](http://stackoverflow.com/questions/5922705/polymorphic-find-or-create-by-with-mongoid-2-0-1-on-embedded-document-collectio), but didn&#8217;t get a good answer, so I rolled my own.

The good news is the source code for Mongoid is fairly easy to follow. I figured out that there is a module the Mongoid::Relations namespaced called Many and that this module is included in all embeds_many relationships. With that in mind, I added my own method to it (being sure not to accidentally monkey-patch any existing methods) to find or add-new with a specified type.

<pre class="brush:ruby">module Mongoid::Relations
  class Many
    def find_or_new(attrs, type, &block)
      inst = self.where(attrs).first

      unless inst
        inst = type.new
        inst.write_attributes attrs
        self &lt;&lt; inst
      end

      inst
    end
  end
end
</pre>

 

Now I can call this on my model:

<pre class="brush:ruby">assessment.questions.find_or_new({:name =&gt; "Some name"}, YesNoQuestion)</pre>

 

and it works the way I need it to work.

Note that I specifically called this find\_or\_new for several reasons. This is no longer a find\_or\_create\_by, because I&#8217;m not calling &#8220;create&#8221;. Calling create on the Question or YesNoQuestion object directly throws an exception because it&#8217;s an embedded document. Also, find\_or\_initialize\_by already exists and like find\_or\_create_by, it does not let me specify the type to initialize.