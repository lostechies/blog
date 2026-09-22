#!/usr/bin/env ruby
# frozen_string_literal: true

# Classifies body diffs between golden (kramdown/rouge) and Hugo (goldmark/chroma)
# into known-benign renderer-difference categories vs. anything needing review.
#
# Usage: ruby scripts/classify_diffs.rb

require "set"

SITE = File.expand_path("../_site", __dir__)
PUBLIC = File.expand_path("../public", __dir__)
REPORT = File.expand_path("../migration/diff_classification.txt", __dir__)

def extract_post_text(html)
  m = html.match(/<span class="post-text">(.*?)<\/span>/m)
  m && m[1]
end

def normalize(s)
  s = s.gsub(/\r/, "").gsub(/&#123;/, "{").gsub(/&#125;/, "}")
  parts = s.split(/(<pre\b.*?<\/pre>)/m)
  parts.map do |part|
    part =~ /\A<pre\b/ ? part.strip : part.gsub(/\s+/, " ").strip
  end.reject(&:empty?).join("\n")
end

# Remove known-benign differences from BOTH sides so any remaining delta is real.
def scrub(html, known)
  s = html.dup
  # 1) heading id generation: kramdown decodes entities, goldmark keeps raw bytes
  known[:entity_ids] += s.scan(/id="[^"]*8217[^"]*"/).size if s =~ /id="[^"]*8217/
  s = s.gsub(/id="([^"]*)"/) { |m| '"' + m.gsub(/&#8217;|&#8220;|&#8221;|&#8216;/, "").gsub(/[^a-z0-9-]+/i, "-") + '"' }
  # 2) inline code classes from rouge (language-plaintext highlighter-rouge)
  known[:code_classes] += 1 if s.include?("language-plaintext")
  s = s.gsub(' class="language-plaintext highlighter-rouge"', "")
  s = s.gsub(/ class="language-\w+ highlighter-rouge"/, "")
  s
end

known = Hash.new(0)
real_diffs = []
counts = Hash.new(0)

golden_posts = Dir.glob("#{SITE}/*/[0-9][0-9][0-9][0-9]/*/*/*/**/index.html").sort
golden_posts.each do |gpath|
  rel = gpath.sub("#{SITE}/", "")
  hpath = File.join(PUBLIC, rel)
  next unless File.exist?(hpath)
  g = normalize(extract_post_text(File.read(gpath)) || "")
  h = normalize(extract_post_text(File.read(hpath)) || "")
  next if g == h
  counts[:total_diff] += 1
  gs = scrub(g, known)
  hs = scrub(h, known)
  if gs == hs
    counts[:benign] += 1
  else
    counts[:real] += 1
    real_diffs << rel
  end
end

File.open(REPORT, "w") do |f|
  counts.sort.each { |k, v| f.puts("#{v}\t#{k}") }
  f.puts "\n-- needing review (#{real_diffs.size}) --"
  real_diffs.each { |r| f.puts(r) }
end
puts counts.sort.map { |k, v| "#{v}\t#{k}" }
puts "review list: #{REPORT}"
