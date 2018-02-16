---
layout: null
---
"use strict";

function getParameterByName(name, url) {
  if (!url) url = window.location.href;
  name = name.replace(/[\[\]]/g, "\\$&");
  var regex = new RegExp("[?&]" + name + "(=([^&#]*)|&|#|$)"),
      results = regex.exec(url);
  if (!results) return null;
  if (!results[2]) return '';
  return decodeURIComponent(results[2].replace(/\+/g, " "));
}

function loadPost(id) {
  var postDiv = document.getElementById(id);
  var url = "http://feed.informer.com/digests/ZWDBOR7GBI/feeder.rss";
  var feed = getParameterByName('feed');

  if (feed) {
    url = feed;
  }

  getFeed(url).then(function (result) {
    var posts = result.items;
    var guid = getParameterByName('guid');

    var post = posts.find(function (post) {
      return post.guid === guid;
    });

    var collection = collections.find(function (col) {
      var re = new RegExp(col.postIdentifier, 'g');
      return col.postIdentifier && post.link.match(re);
    });

    var box = createNode('div');
    var external = createNode('div');
    var externalImage = createNode('img');
    var externalLink = createNode('a');
    var titleHeading = createNode('h1');
    var titleLink = createNode('a');
    var titleText = createNode('span');
    var summary = createNode('span');
    var metadata = createNode('span');

    //box.classList.add("box");

    if (!post.link.startsWith("{{site.url}}")) {
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
    titleLink.href = post.link;
    titleText.innerHTML = "" + post.title;
    titleLink.style.color = "#4a4a4a";
    append(titleLink, titleText);
    append(titleHeading, titleLink);
    append(box, titleHeading);

    metadata.innerHTML = "<span class=\"post-meta\">" + (post.author || collection.name) + " -  " + new Date(post.pubDate.replace(/-/g, "/")).toLocaleString() + " <a style=\"color:grey\" href=" + post.link + "></a></span><hr/>";
    append(box, metadata);

    summary.classList.add("post-text");
    summary.innerHTML = post.content;
    append(box, summary);
    postDiv.innerHTML = "";
    append(postDiv, box);
  });
}

