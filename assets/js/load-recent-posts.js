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

    feednami.load(feed,function(result){
      if(result.error) {
        //console.log(result.error);
      } else {
        hostElement.innerHTML = null;

        let posts = result.feed.entries.slice(0, 10);
        posts.map(function(post) {
          let li = createNode('li'),
            anchor = createNode('a'),
            span = createNode('span');
          if(post.link.startsWith("{{site.baseurl}}")) {
            anchor.href=post.link;
          } else {
            var collection = collections.find(function(col) {
                return col.postPrefix && post.link.startsWith(col.postPrefix);
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
      }
    });
  }
}
