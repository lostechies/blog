---
layout: null
---

function getParameterByName(name, url) {
    if (!url) url = window.location.href;
    name = name.replace(/[\[\]]/g, "\\$&");
    var regex = new RegExp("[?&]" + name + "(=([^&#]*)|&|#|$)"),
        results = regex.exec(url);
    if (!results) return null;
    if (!results[2]) return '';
    return decodeURIComponent(results[2].replace(/\+/g, " "));
}

function createNode(element) {
  return document.createElement(element);
}

function append(parent, el) {
  return parent.appendChild(el);
}

function loadRecentAuthorPosts(elementId, container) {
  const hostElement = document.getElementById(elementId);

  var recentFeed = getParameterByName('recentFeed');

  if(!collectionFeed && !recentFeed) {
    var container = document.getElementById(container);
    container.parentNode.removeChild(container);
    return;
  }

  if(recentFeed) {
    collectionFeed = recentFeed;
  }

  if(collectionFeed) {

    getFeed(collectionFeed)
      .then(function(result) {
        hostElement.innerHTML = null;

        let posts = result.items.slice(0, 10);
        posts.map(function(post) {
          let li = createNode('li'),
            anchor = createNode('a'),
            span = createNode('span');

          if(post.guid) {
            anchor.href=`{{site.baseurl}}/external?guid=${post.guid}&feed=${collectionFeed}`;
          } else {
            anchor.href=post.link;
          }
          span.innerHTML = post.title;
          append(li, anchor);
          append(anchor, span);
          append(hostElement, li);
        });
      });

  } else {
    if(typeof page_collection !== 'undefined' && hostElement) {

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
            append(hostElement, li);
          });
        })
    }
  }
}

