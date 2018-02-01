---
---
// https://github.com/jgthms/bulma/issues/238 thanks!
document.getElementById("nav-toggle").addEventListener("click", toggleNav);
function toggleNav() {
    var nav = document.getElementById("nav-menu");
    var className = nav.getAttribute("class");
    if(className == "nav-right nav-menu") {
        nav.className = "nav-right nav-menu is-active";
    } else {
        nav.className = "nav-right nav-menu";
    }
}

// for the random quote in the header
/*
var txtFile = new XMLHttpRequest();
txtFile.open("GET", "/quotes.txt", true);
txtFile.onreadystatechange = function () {
    if (txtFile.readyState === 4) {
        if (txtFile.status === 200) {
            allText = txtFile.responseText;
            lines = txtFile.responseText.split("\n");
            randLine = lines[Math.floor((Math.random() * lines.length) + 1)];
            document.getElementById('quote').innerHTML = randLine ||
                "Intelligence is the ability to adapt to change."; // fallback quote
        }
    }
};
txtFile.send(null);
*/

function createNode(element) {
  return document.createElement(element);
}

function append(parent, el) {
  return parent.appendChild(el);
}

/*
 -----------------------------------------------------
  Function for dynamically building list of authors.
  This would normally be done using Liquid templates,
  but this results in an increased build time which
  leads to github build timeouts.
 -----------------------------------------------------
*/

const authorsUl = document.getElementById('authors');

if(authorsUl) {
fetch("{{site.baseurl}}/data/authors.json")
.then((resp) => resp.json())
  .then(function(data) {
    let authors = data.authors;
    return authors.map(function(author) {
      if(author.active === "true") {
        let li = createNode('li'),
          anchor = createNode('a'),
          span = createNode('span');
        anchor.href=author.url;
        span.innerHTML = `${author.name}`;
        append(li, anchor);
        append(anchor, span);
        append(authorsUl, li);
      }
    })
  })
}

const recentAuthorPostsUl = document.getElementById('recentAuthorPosts');

if(typeof page_collection !== 'undefined' && recentAuthorPostsUl) {

  fetch("{{site.baseurl}}/" + page_collection + "/data/recentPosts.json")
    .then((resp) => resp.json())
    .then(function(data) {
      let posts = data.posts;
      posts.map(function(post) {
        let li = createNode('li'),
          anchor = createNode('a'),
          span = createNode('span');
        anchor.href=post.url;
        span.innerHTML = `${post.title}`;
        append(li, anchor);
        append(anchor, span);
        append(recentAuthorPostsUl, li);
      });
    })
}

const recentPostsUl = document.getElementById('recentPosts');

if(recentPostsUl) {

  fetch("{{site.baseurl}}/data/recentPosts.json")
    .then((resp) => resp.json())
    .then(function(data) {
      let posts = data.posts;
      posts.map(function(post) {
        let li = createNode('li'),
          anchor = createNode('a'),
          span = createNode('span');
        anchor.href=post.url;
        span.innerHTML = `${post.title}`;
        append(li, anchor);
        append(anchor, span);
        append(recentPostsUl, li);
      });
    })
}

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
