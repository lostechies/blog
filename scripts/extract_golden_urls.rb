#!/usr/bin/env ruby
# frozen_string_literal: true

# Extracts the golden URL inventory from a fresh Jekyll build (_site/).
# Outputs:
#   migration/golden_pages.txt   - canonical page URLs (site-root-relative, trailing slash for dirs)
#   migration/golden_aliases.txt - alias URL<TAB>canonical URL pairs (from jekyll-redirect-from)
#   migration/golden_files.txt   - every file path in the build output

require "json"
require "fileutils"

SITE = "_site"
MIGRATION = "migration"

FileUtils.mkdir_p(MIGRATION)

# --- Canonical pages: every index.html becomes its directory URL; every other
# --- standalone HTML/XML/JSON file keeps its path (e.g. /chadmyers/archive.html).
pages = []
Dir.glob("#{SITE}/**/*.html").sort.each do |path|
  rel = path.sub("#{SITE}/", "")
  if rel == "index.html" || rel.end_with?("/index.html")
    pages << "/#{rel.sub("index.html", "")}"
  else
    pages << "/#{rel}"
  end
end
%w[feed.xml].each do |endpoint|
  pages << "/#{endpoint}" if File.exist?(File.join(SITE, endpoint))
end
Dir.glob("#{SITE}/**/*.json").sort.each do |path|
  rel = path.sub("#{SITE}/", "")
  pages << "/#{rel}"
end
# The root /data/*.json endpoints are real production URLs; their Liquid sources
# were moved to migration/jekyll-sources/, so add them explicitly.
pages << "/data/authors.json"
pages << "/data/recentPosts.json"
# Production also serves the npm manifests that sit at the repo root.
pages << "/package.json"
pages << "/package-lock.json"
# jekyll-redirect-from's redirects.json is a plugin artifact; not part of the contract.
pages.reject! { |p| p == "/redirects.json" }
pages.uniq!
pages.sort!
File.open("#{MIGRATION}/golden_pages.txt", "w") { |f| pages.each { |p| f.puts(p) } }

# --- Aliases: jekyll-redirect-from writes the complete map to redirects.json.
aliases = []
redirects_json = File.join(SITE, "redirects.json")
if File.exist?(redirects_json)
  map = JSON.parse(File.read(redirects_json))
  map.sort_by { |from, _to| from }.each do |from, to|
    aliases << [from, to]
  end
end
File.open("#{MIGRATION}/golden_aliases.txt", "w") do |f|
  aliases.each { |from, to| f.puts("#{from}\t#{to}") }
end

# --- Full file inventory (for asset parity checks).
# The golden Jekyll build excludes the Hugo tree (media moved to static/), so the
# inventory is: build output + everything under static/ mapped to URL paths
# (static/content/x -> /content/x etc.) + the two Hugo-pipe-rendered JS assets.
files = Dir.glob("#{SITE}/**/*").select { |p| File.file?(p) }.map { |p| p.sub("#{SITE}/", "") }.sort
Dir.glob("static/**/*").select { |p| File.file?(p) }.each do |p|
  files << p.sub("static/", "")
end
%w[assets/js/collections.js assets/js/feed.js].each { |f| files << f }
# Published endpoints whose sources moved out of the golden build tree.
%w[data/authors.json data/recentPosts.json package.json package-lock.json].each { |f| files << f }
# jekyll-redirect-from's redirects.json is a plugin artifact (nothing consumes it);
# it is intentionally NOT reproduced by Hugo.
files.reject! { |f| f == "redirects.json" }
files.uniq!
files.sort!
File.open("#{MIGRATION}/golden_files.txt", "w") { |f| files.each { |x| f.puts(x) } }

puts "pages:   #{pages.size}"
puts "aliases: #{aliases.size}"
puts "files:   #{files.size}"
