{{/* Port of Jekyll's Liquid-templated collections.js — embedded author registry.
       Rendered via resources.ExecuteAsTemplate in partials/footer.html, published at /assets/js/collections.js */}}
var collections = [
{{ $labels := slice }}
{{ range $label, $author := site.Params.authors }}{{ $labels = $labels | append $label }}{{ end }}
{{ range $i, $label := sort $labels }}
  {
    "label": "{{ $label }}",
      "url": "/{{ $label }}",
      "name": "{{ index site.Params.authors $label "author" }}",
      "postIdentifier": "{{ index site.Params.authors $label "post-identifier" }}",
      "feed": "{{ index site.Params.authors $label "feed" }}"
  }{{ if lt $i (sub (len $labels) 1) }},{{ end }}
{{ end }}
];
