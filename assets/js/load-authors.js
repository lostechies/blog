---
layout: null
---
"use strict";

/*
 -----------------------------------------------------
  Function for dynamically building list of authors.
  This would normally be done using Liquid templates,
  but the use of templates in an increased build time
  which leads to github build timeouts.
 -----------------------------------------------------
*/
function loadAuthors(elementId) {

  var authorsElement = document.getElementById(elementId);

  if (authorsElement) {
    fetch("{{site.baseurl}}/data/authors.json").then(function (resp) {
      return resp.json();
    }).then(function (data) {
      var authors = data.authors;
      return authors.map(function (author) {
        if (author.active === "true") {
          var li = createNode('li'),
              anchor = createNode('a'),
              span = createNode('span');
          anchor.href = author.url;
          span.innerHTML = "" + author.name;
          append(li, anchor);
          append(anchor, span);
          append(authorsElement, li);
        }
      });
    });
  }
}

