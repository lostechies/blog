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

function loadPost(id) {
  const postDiv = document.getElementById(id);
  var url = "http://feed.informer.com/digests/ZWDBOR7GBI/feeder.rss";
  var feed = getParameterByName('feed');

  if(feed) {
    url = feed;
  }

  feednami.load(url,function(result){
    if(result.error) {
      console.log(result.error);
    } else {

      let posts = result.feed.entries;
      var guid = getParameterByName('guid');

      var post = posts.find(function(post) {
        return post.guid === guid;
      });

      let box = createNode('div');
      let external = createNode('div');
      let externalImage = createNode('img');
      let externalLink = createNode('a');
      let titleHeading = createNode('h1');
      let titleLink = createNode('a');
      let titleText = createNode('span');
      let summary = createNode('span');
      let metadata = createNode('span');

      //box.classList.add("box");

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
      titleLink.href=post.link;
      titleText.innerHTML = `${post.title}`;
      titleLink.style.color = "#4a4a4a";
      append(titleLink, titleText);
      append(titleHeading, titleLink);
      append(box, titleHeading);

      metadata.innerHTML = `<span class="post-meta">getAuthor(post) -  ${new Date(post.date).toLocaleString()} <a style="color:grey" href=${post.link}></a></span><hr/>`;
      append(box, metadata);

      summary.classList.add("post-text");
      summary.innerHTML = getContent(post); 
      append(box, summary);
      postDiv.innerHTML = null;
      append(postDiv, box);
    }
  });
}

function getContent(post) {
  var content = null;

  if(post["content:encoded"] && post["content:encoded"]["#"]) {
    return post["content:encoded"]["#"];
  }else if(post["atom:content"] && post["atom:content"]["#"]) {
    return post["atom:content"]["#"];
  }

  return `${post.summary} <a href=${post.link}>Continue Reading ...</a>`;
}

function getAuthor(post) {
  return post.author || post.source.title;
}


function createNode(element) {
  return document.createElement(element);
}

function append(parent, el) {
  return parent.appendChild(el);
}

