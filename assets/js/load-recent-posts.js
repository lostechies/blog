---
layout: null
---
function createNode(element) {
  return document.createElement(element);
}

function append(parent, el) {
  return parent.appendChild(el);
}

function loadRecentPosts(elementId) {
  const hostElement = document.getElementById(elementId);

  if(hostElement) {

    var feed = "http://feed.informer.com/digests/ZWDBOR7GBI/feeder.rss";
    var recentFeed = feed;

    getFeed(feed)
    .then(function(result) {
        hostElement.innerHTML = null;

        let posts = result.items.slice(0, 10);
        posts.map(function(post) {
          let li = createNode('li'),
            anchor = createNode('a'),
            span = createNode('span');
          if(post.link.startsWith("{{site.baseurl}}")) {
            anchor.href=post.link;
          } else {
            var collection = collections.find(function(col) {
              var re = new RegExp(col.postIdentifier, 'g');
              return col.postIdentifier && post.link.match(re);
            });

            if(collection) {
              recentFeed = collection.feed;
            }

            // this creates a mis-match between the guid and the feed
            anchor.href=`{{site.baseurl}}/external?guid=${post.guid}&feed=${feed}&recentFeed=${recentFeed}`;
          }

          span.innerHTML = post.title;
          append(li, anchor);
          append(anchor, span);
          append(hostElement, li);
        });
    });
  }
}
