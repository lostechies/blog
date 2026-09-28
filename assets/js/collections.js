{{/* Port of Jekyll's Liquid-templated collections.js — embedded author registry.
       Rendered via resources.ExecuteAsTemplate in partials/footer.html, published at /assets/js/collections.js */}}
var collections = [
{{ $labels := slice }}
{{ range $label, $author := site.Params.authors }}{{ $labels = $labels | append $label }}{{ end }}
{{ range $i, $label := sort $labels }}
  {{- $author := index site.Params.authors $label }}
  {
    "label": "{{ $label }}",
      "url": "/{{ $label }}",
      "name": "{{ $author.author }}",
      "postIdentifier": "{{ index $author "post-identifier" | default "" }}",
      "feed": "{{ $author.feed | default "" }}"
  }{{ if lt $i (sub (len $labels) 1) }},{{ end }}
{{ end }}
];
