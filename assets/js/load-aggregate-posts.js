---
layout: null
---

function loadAggregatePosts(elementId, feed, loadFullText, collection) {
  const hostElement = document.getElementById(elementId);

  if(hostElement) {

    if(!feed) {
      feed = "http://feed.informer.com/digests/ZWDBOR7GBI/feeder.rss";
    }


    getFeed(feed)
      .then(function(result) {
        hostElement.innerHTML = null;

        let posts = result.items;
        posts.map(function(post) {
          let box = createNode('div');
          let external = createNode('div');
          let externalImage = createNode('img');
          let externalLink = createNode('a');
          let titleHeading = createNode('h1');
          let titleLink = createNode('a');
          let titleText = createNode('span');
          let content = createNode('span');
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

          collection = collections.find(function(col) {
            var re = new RegExp(col.postIdentifier, 'g');
            return col.postIdentifier && post.link.match(re);
          });

          titleHeading.classList.add("post-title");
          if(post.link.startsWith("{{site.baseurl}}")) {
            titleLink.href=post.link;
          } else {

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

          metadata.innerHTML = `<span class="post-meta">${post.author || collection.name} -  ${new Date(post.pubDate.replace(/-/g, "/")).toLocaleString()} <a style="color:grey" href=${post.link}></a></span><hr/>`;
          append(box, metadata);

          if(loadFullText) {
            content.innerHTML = post.content;
          }else {
            let postSummary = post.content.replace(/<(?:.|\n)*?>/gm, '').split(/\s+/).slice(0, 40).join(' ').trim();
            content.innerHTML = `${postSummary} ... <a href=${postUrl}>Continue reading →</a>`;
          }
          content.classList.add("post-text");
          append(box, content);

          append(hostElement, box);
        });
      });
  }
}
