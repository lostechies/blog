---
layout: null
---
var collections = [
  {% assign filtered_collections = ''|split:'' %}
  {% assign unfiltered_collections = site.collections %}
  {% for c in unfiltered_collections %}
  {% if c.label != "posts" %}
  {% assign filtered_collections = filtered_collections|push:c %}
  {% endif %}
  {% endfor %}
  {% for collection in filtered_collections %}
  {% assign label = collection.label %}
  {
    "label": "{{label}}",
      "url": "{{site.baseurl}}/{{label}}",
      "name": "{{collection.author}}",
      "postIdentifier": "{{collection.post-identifier}}",
      "feed": "{{collection.feed}}"
  } {% if forloop.last %}{% else %},{% endif %}
  {% endfor %}
];

{% assign col = site.collections | where: 'label', page.collection | first %}
var page_collection = "{{page.collection}}";
var collectionFeed = "{{col.feed}}";
var collection = collections.find(function(col) {
  return col.label === "{{col.label}}";
});
