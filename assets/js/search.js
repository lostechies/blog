---
layout: null
---

document.getElementById("search-text").addEventListener("keydown", function(e) {
  // search
  if (e.keyCode == 13) { searchHandler(); }
}, false);

function searchHandler() {
  var searchInput = document.getElementById('search-text');
  var text = searchInput.value;
  // add site:example.com in the placeholder
  window.location.href = "https://www.google.com/search?q=site:lostechies.com " + text;
}
