---
layout: null
---
function getFeed(feed) {
  var params = {
    rss_url: feed,
    api_key: '{{site.rss2json_api_key}}'
  };
  var esc = encodeURIComponent;
  var query = Object.keys(params)
    .map(k => esc(k) + '=' + esc(params[k]))
    .join('&');

  return fetch(`https://api.rss2json.com/v1/api.json?${query}`)
    .then(response => response.json()
      .then(function(data) {
        return data;
      })
    );
}

