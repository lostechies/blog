#!/usr/bin/env ruby
# frozen_string_literal: true

# One-time migration: Jekyll -> Hugo content tree.
#
# Reads:  migration/jekyll_url_map.txt (source path \t URL, from jekyll_url_map.rb)
# Writes: content/ (Hugo), static/ (media), data/ (comments), migration_report.txt
#
# URL parity strategy:
#   - Posts rely on Hugo permlinks config + filename (date prefix stripped).
#   - Any post whose Jekyll slug differs from its filename gets an explicit `slug`.
#   - Non-post pages keep their exact URL via the `url` front matter key (renamed
#     from Jekyll's `permalink`).
#   - redirect_from -> aliases (string and array forms both valid in Hugo).
#
# Idempotency: this script builds the Hugo tree fresh; re-running overwrites.
# It never deletes Jekyll sources.

require "fileutils"

ROOT = File.expand_path("..", __dir__)
REPORT = File.join(ROOT, "migration", "migration_report.txt")

report = Hash.new(0)
flagged = []

def log(report, key)
  report[key] += 1
end

# ---------------------------------------------------------------------------
# Helpers
# ---------------------------------------------------------------------------

# Split a Jekyll file into [front_matter, body]. Returns ["", content] when no FM.
def split_fm(text)
  m = text.match(/\A---\s*\n(.*?)\n---\s*\n?(.*)\z/m)
  return ["", text] unless m
  [m[1], m[2]]
end

def join_fm(fm, body)
  fm.strip.empty? ? body : "---\n#{fm}\n---\n#{body}"
end

# Front-matter text transforms shared by posts and pages.
def transform_fm(fm, report, flags:, rename: {}, keep: [])
  lines = fm.lines
  out = []
  lines.each do |line|
    key = line[/\A([A-Za-z0-9_-]+):/, 1]
    if flags.include?(key)
      log(report, "fm:dropped #{key}")
      next
    end
    if rename.key?(key)
      out << line.sub(/\A#{key}:/, "#{rename[key]}:")
      log(report, "fm:renamed #{key}->#{rename[key]}")
      next
    end
    keep.each { |k| log(report, "fm:kept #{k}") if key == k }
    out << line
  end
  out.join
end

# Collapse dsq_thread_id arrays (always a 1-element list, occasionally duplicated) to a scalar.
def collapse_dsq(fm, report, source, flagged)
  fm = fm.gsub(/^dsq_thread_id:[ \t]*\n((?:[ \t]*-[ \t]*.*\n)+)/) do
    items = Regexp.last_match(1).scan(/^[ \t]*-[ \t]*(.*)$/).flatten
    flagged << "#{source}: dsq_thread_id had #{items.size} items, kept first (#{items[0]})" if items.size > 1
    log(report, "fm:collapsed dsq_thread_id")
    "dsq_thread_id: #{items[0]}\n"
  end
  # inline array form: dsq_thread_id: ["x"]
  fm = fm.gsub(/^dsq_thread_id:[ \t]*\[(.*)\]\s*$/) do
    inner = Regexp.last_match(1).strip
    items = inner.scan(/"([^"]*)"/).flatten
    items = [inner] if items.empty?
    "dsq_thread_id: \"#{items[0]}\""
  end
  fm
end

# Body transforms: gist tags -> Hugo shortcodes, strip raw/endraw Liquid tags.
def transform_body(body, report, source, flagged)
  # Literal {{< or {{% in post bodies (e.g. C# collection initializers followed by </span>)
  # would be parsed by Hugo as shortcodes. Entity-encode the braces; browsers render
  # &#123;&#123;< exactly as {{<. Done BEFORE gist conversion so real shortcodes are safe.
  if body.include?("{{<") || body.include?("{{%")
    n_esc = 0
    body = body.gsub("{{<") { n_esc += 1; "&#123;&#123;<" }
    body = body.gsub("{{%") { n_esc += 1; "&#123;&#123;%" }
    flagged << "#{source}: entity-escaped #{n_esc} literal {{</{{% sequences"
  end

  n_gists = 0
  # jekyll-gist cache-busting arg (bump=N) has no Hugo gist-shortcode equivalent: drop it.
  body = body.gsub(/(\{%\s*gist\s+[a-f0-9]+)\s+bump=\d+(\s*%\})/) do
    n_gists += 1
    "#{$1}#{$3}"
  end
  body = body.gsub(/\{%\s*gist\s+id=([a-f0-9]+)\s+([^\s%]+)\s*%\}/) do
    n_gists += 1
    "{{< gist #{$1} \"#{$2}\" >}}"
  end
  # jekyll-gist file= form renders src="...ID.js?file=file=X" (double file= quirk) — preserve byte parity.
  body = body.gsub(/\{%\s*gist\s+([a-f0-9]+)\s+file=([^\s%]+)\s*%\}/) do
    n_gists += 1
    "{{< gist #{$1} \"file=#{$2}\" >}}"
  end
  body = body.gsub(/\{%\s*gist\s+([a-f0-9]+)\s+([^\s%]+)\s*%\}/) do
    n_gists += 1
    "{{< gist #{$1} \"#{$2}\" >}}"
  end
  body = body.gsub(/\{%\s*gist\s+([a-f0-9]+)\s*%\}/) do
    n_gists += 1
    "{{< gist #{$1} >}}"
  end
  report["body:gist converted"] += n_gists if n_gists > 0
  flagged << "#{source}: converted #{n_gists} gist tags" if n_gists > 0

  if body.include?("{% raw %}")
    flagged << "#{source}: stripped {% raw %}/{% endraw %} tags"
    body = body.gsub(/\{%\s*raw\s*%\}/, "").gsub(/\{%\s*endraw\s*%\}/, "")
  end

  # CommonMark ends a raw-HTML block (table/div/ul/...) at its first blank line; the
  # remainder then renders as indented code (kramdown kept it as one HTML block).
  # Blank lines are insignificant inside these elements, so collapse them — except
  # inside <pre>, where whitespace is meaningful.
  tags = "table|div|ul|ol|dl|blockquote|center|dir"
  n_blocks = 0
  body = body.gsub(/<(#{tags})\b[^>]*>.*?<\/\1>/mi) do |block|
    next block if block =~ /<pre\b/i
    collapsed = block.gsub(/\n[ \t]*\n+/, "\n")
    if collapsed != block
      n_blocks += 1
      collapsed
    else
      block
    end
  end
  if n_blocks > 0
    flagged << "#{source}: collapsed blank lines inside #{n_blocks} raw HTML block(s)"
  end
  body
end

def write_file(path, content)
  FileUtils.mkdir_p(File.dirname(path))
  File.write(path, content)
end

# Jekyll processed assets/ JS+CSS through Liquid (front matter + {{site.baseurl}}).
# Hugo copies static/ verbatim, so bake the rendered values in: strip FM, empty the baseurl.
def strip_static_liquid(report)
  Dir["static/assets/**/*.{js,css}"].sort.each do |path|
    text = File.read(path)
    changed = false
    stripped = text.sub(/\A---\s*\nlayout: null\s*\n---\s*\n/, "")
    if stripped != text
      text = stripped
      changed = true
      report["static:stripped FM"] += 1
    end
    no_baseurl = text.gsub("{{ site.baseurl }}", "").gsub("{{site.baseurl}}", "")
    if no_baseurl != text
      text = no_baseurl
      changed = true
      report["static:emptied baseurl"] += 1
    end
    File.write(path, text) if changed
  end
end

# Move media/assets out of the way FIRST so Hugo's content dir starts fresh.
def move_static_assets(report)
  moves = {
    "content" => "static/content",      # WordPress-era media library (NOT Hugo content)
    "wp-content" => "static/wp-content",
    "assets" => "static/assets",
    "_data/comments" => "data/comments",
    "CNAME" => "static/CNAME",
    "package.json" => "static/package.json",
    "package-lock.json" => "static/package-lock.json",
  }
  moves.each do |from, to|
    # Guard: skip when the destination already exists (re-runs) or source is gone.
    next if File.exist?(to)
    next unless File.exist?(from)
    FileUtils.mkdir_p(File.dirname(to))
    system("git mv #{from.inspect} #{to.inspect}")
    report["moved #{from} -> #{to}"] += 1
  end
end

# ---------------------------------------------------------------------------
# Load URL map
# ---------------------------------------------------------------------------

url_map = {}
File.readlines(File.join(ROOT, "migration", "jekyll_url_map.txt")).each do |line|
  src, url = line.chomp.split("\t")
  url_map[src] = url if src && url
end

# Jekyll's URL map reflects the permalink; for extensionless page permalinks
# Jekyll writes the file with .html appended (e.g. /derekgreer/tags -> tags.html).
# Normalize page URLs to the written-file form.
def page_url(url_map, src)
  url = url_map[src]
  return url if url.nil? || url == "/" || url =~ /\.(html|json|xml)$/
  "#{url}.html"
end

Dir.chdir(ROOT)

move_static_assets(report)
strip_static_liquid(report)

# ---------------------------------------------------------------------------
# 1. Collection posts -> content/<coll>/<filename minus date prefix>.md
# ---------------------------------------------------------------------------

posts = url_map.keys.select { |k| k =~ /\A_\w+\/(\d{4})-(\d\d)-(\d\d)-.*\.md\z/ }
posts.each do |src|
  coll = src[/\A_(\w+)\//, 1]
  fm, body = split_fm(File.read(src))
  url = url_map[src]

  # Transform front matter.
  fm = transform_fm(fm, report, flags: ["layout"], rename: { "redirect_from" => "aliases" })
  fm = collapse_dsq(fm, report, src, flagged)

  # Explicit url when Jekyll's slugified filename differs from the raw filename
  # (single known case: a filename containing literal %e2%80%8a characters).
  filename_slug = File.basename(src, ".md").sub(/\A\d{4}-\d\d-\d\d-/, "")
  url_slug = url.chomp("/").split("/").last
  if url_slug != filename_slug
    fm = "url: \"#{url}\"\n#{fm}"
    flagged << "#{src}: explicit url '#{url}' (filename slug was '#{filename_slug}')"
  end

  body = transform_body(body, report, src, flagged)
  write_file("content/#{coll}/#{filename_slug}.md", join_fm(fm, body))
  log(report, "post migrated")
end

# ---------------------------------------------------------------------------
# 2. Collection page files
# ---------------------------------------------------------------------------

# index.html -> _index.md (body dropped; Hugo section template renders the list)
# url comes from the Jekyll URL map (authoritative — Jekyll sometimes appends .html
# to extensionless permalinks, which a naive permalink->url rename would miss).
url_map.keys.select { |k| k =~ /\A_\w+\/index\.html\z/ }.each do |src|
  coll = src[/\A_(\w+)\//, 1]
  fm, _body = split_fm(File.read(src))
  fm = transform_fm(fm, report, flags: ["layout", "index", "permalink"], rename: { "redirect_from" => "aliases" })
  fm = "url: #{page_url(url_map, src)}\n#{fm}"
  write_file("content/#{coll}/_index.md", join_fm(fm, ""))
  log(report, "author index page migrated")
end

# archive.html / tags.html / about.html -> layout-keyed pages (body dropped)
url_map.keys.select { |k| k =~ /\A_\w+\/(archive|tags|about)\.html\z/ }.each do |src|
  coll = src[/\A_(\w+)\//, 1]
  kind = src[/\/(archive|tags|about)\.html\z/, 1]
  fm, _body = split_fm(File.read(src))
  fm = transform_fm(fm, report, flags: ["layout", "index", "permalink"], rename: { "redirect_from" => "aliases" })
  fm = "type: author-pages\nlayout: #{kind}\nurl: #{page_url(url_map, src)}\n#{fm}"
  write_file("content/#{coll}/#{kind}.md", join_fm(fm, ""))
  log(report, "author #{kind} page migrated")
end

url_map.keys.select { |k| k =~ /\A_\w+\/about\.html\z/ }.each do |src|
  coll = src[/\A_(\w+)\//, 1]
  fm, body = split_fm(File.read(src))
  fm = transform_fm(fm, report, flags: ["layout", "index", "permalink"], rename: { "redirect_from" => "aliases" })
  fm = "type: author-pages\nlayout: about\nurl: #{page_url(url_map, src)}\n#{fm}"
  body = transform_body(body, report, src, flagged)
  body = body.gsub("{{ site.baseurl }}", "").gsub("{{site.baseurl}}", "")
             .gsub("{{ site.feed.path }}", "https://feeds.feedburner.com/LosTechies")
  write_file("content/#{coll}/about.md", join_fm(fm, body))
  log(report, "author about page migrated")
end

# recentPosts.json -> JSON-only page (body dropped; template in Phase 3)
url_map.keys.select { |k| k =~ /\A_\w+\/recentPosts\.json\z/ }.each do |src|
  coll = src[/\A_(\w+)\//, 1]
  fm = <<~YAML
    type: author-pages
    layout: recent-posts
    outputs: [json]
    url: #{page_url(url_map, src)}
  YAML
  write_file("content/#{coll}/recentPosts.md", join_fm(fm, ""))
  log(report, "author recentPosts.json migrated")
end

# ---------------------------------------------------------------------------
# 3. Root pages
# ---------------------------------------------------------------------------

# about.md -> content/about.md (layout: simple -> _default/simple.html, Jekyll page.html port)
fm, body = split_fm(File.read("about.md"))
fm = transform_fm(fm, report, flags: ["layout"], rename: {})
fm = "url: \"/about.html\"\nlayout: simple\n#{fm}"
write_file("content/about.md", join_fm(fm, body))
log(report, "root about.md migrated")

# index.md -> content/_index.md (home)
fm, body = split_fm(File.read("index.md"))
fm = transform_fm(fm, report, flags: ["layout"], rename: {})
write_file("content/_index.md", join_fm(fm, body))
log(report, "root index.md migrated")

# external.md -> content/external/_index.md
fm, body = split_fm(File.read("external.md"))
fm = transform_fm(fm, report, flags: ["layout"], rename: { "permalink" => "url" })
body = body.gsub("{{site.baseurl}}", "").gsub("{{ site.baseurl }}", "")
write_file("content/external/_index.md", join_fm(fm, body))
log(report, "root external.md migrated")

# 2022-05-27-magical-joy.md -> content/2022-05-27-magical-joy.md
fm, body = split_fm(File.read("2022-05-27-magical-joy.md"))
fm = transform_fm(fm, report, flags: ["layout"], rename: {})
fm = "url: \"/2022-05-27-magical-joy.html\"\ntype: post\n#{fm}"
write_file("content/2022-05-27-magical-joy.md", join_fm(fm, body))
log(report, "root magical-joy.md migrated")

# data/*.json Liquid templates -> JSON-only content pages (templates in Phase 3)
write_file("content/authors.md", "---\ntype: author-pages\nlayout: authors\noutputs: [json]\nurl: /data/authors.json\n---\n")
write_file("content/recentPosts.md", "---\ntype: author-pages\nlayout: recent-posts\noutputs: [json]\nurl: /data/recentPosts.json\n---\n")
log(report, "root JSON endpoint pages migrated (2)")

# ---------------------------------------------------------------------------
# Report
# ---------------------------------------------------------------------------

File.open(REPORT, "w") do |f|
  report.sort.each { |k, v| f.puts("#{v}\t#{k}") }
  f.puts "\n-- flagged files (#{flagged.size}) --"
  flagged.each { |x| f.puts(x) }
end

puts report.sort.map { |k, v| "#{v}\t#{k}" }
puts "\nflagged: #{flagged.size} (see #{REPORT})"
