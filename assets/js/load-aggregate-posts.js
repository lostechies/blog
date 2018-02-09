---
layout: null
---

function loadAggregatePosts(elementId, feed, loadFullText, collection) {
  const hostElement = document.getElementById(elementId);

  if(hostElement) {
    
    if(!feed) {
      feed = "http://feed.informer.com/digests/ZWDBOR7GBI/feeder.rss";
    }


    feednami.load(feed,function(result){
      if(result.error) {
        //console.log(result.error);
      } else {
        hostElement.innerHTML = null;

        let posts = result.feed.entries;
        posts.map(function(post) {
          let box = createNode('div');
          let external = createNode('div');
          let externalImage = createNode('img');
          let externalLink = createNode('a');
          let titleHeading = createNode('h1');
          let titleLink = createNode('a');
          let titleText = createNode('span');
          let summary = createNode('span');
          let metadata = createNode('span');

          var recentFeed = null;

          box.classList.add("box");

          if(!post.link.startsWith("{{site.baseurl}}")) {
            external.style.color = "blue";
            external.style.position = "relative";
            external.style.float = "right";
            external.style.top = "-8px";
            external.style.right = "-8px";
            externalLink.href = post.link;
            externalImage.setAttribute('src', "{{site.baseurl}}/assets/images/external-link.png");
            externalImage.style.width = "14px";
            externalImage.style.height = "14px";

            append(externalLink, externalImage);
            append(external, externalLink);
            append(box, external);
          }

          titleHeading.classList.add("post-title");
          if(post.link.startsWith("{{site.baseurl}}")) {
            titleLink.href=post.link;
          } else {
            if(!collection) {
              collection = collections.find(function(col) {
                return col.postPrefix && post.link.startsWith(col.postPrefix);
              });
            }

            if(collection) {
              recentFeed = collection.feed;
            }

            var postUrl =`{{site.baseurl}}/external?guid=${post.guid}&feed=${feed}`;

            if(recentFeed) {
              postUrl =`${postUrl}&recentFeed=${recentFeed}`;
            }

            titleLink.href= postUrl;
          }

          titleText.innerHTML = `${post.title}`;
          titleLink.style.color = "#4a4a4a";
          append(titleLink, titleText);
          append(titleHeading, titleLink);
          append(box, titleHeading);

          metadata.innerHTML = `<span class="post-meta">${post.source.title} -  ${new Date(post.date).toLocaleString()} <a style="color:grey" href=${post.link}></a></span><hr/>`;
          append(box, metadata);

          summary.classList.add("post-text");
          if(loadFullText && post["content:encoded"] && post["content:encoded"]["#"]) {
            summary.innerHTML = `${post["content:encoded"]["#"]}`;
          }else {
            summary.innerHTML = `${post.summary} <a href=${post.link}>Continue Reading ...</a>`;
          }
          append(box, summary);

          append(hostElement, box);
        });
      }
    });
  }
}
