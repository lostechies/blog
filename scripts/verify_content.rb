#!/usr/bin/env ruby
# frozen_string_literal: true

# Phase 5 content verification: compares rendered post bodies (the post-text span)
# and the meta line between the golden Jekyll build (_site) and the Hugo build (public).
#
# Produces migration/content_diff_report.txt with per-file verdicts and writes
# sample diffs for the first few failures.
#
# Usage: ruby scripts/verify_content.rb [max_samples]

require "set"

SITE = File.expand_path("../_site", __dir__)
PUBLIC = File.expand_path("../public", __dir__)
REPORT = File.expand_path("../migration/content_diff_report.txt", __dir__)

MAX_SAMPLES = (ARGV[0] || 8).to_i

def read(path)
  File.exist?(path) ? File.read(path) : nil
end

def extract_post_text(html)
  return nil if html.nil?
  m = html.match(/<span class="post-text">(.*?)<\/span>/m)
  m && m[1]
end

def extract_meta(html)
  m = html.match(/<span class="post-meta">(.*?)<\/span>/m)
  m && m[1]
end

def normalize(s)
  return nil if s.nil?
  # Compare <pre> blocks exactly (whitespace matters); everything else is HTML,
  # where whitespace runs are insignificant. Handles the kramdown-vs-goldmark
  # blank-lines-between-blocks difference.
  s = s.gsub(/\r/, "").gsub(/&#123;/, "{").gsub(/&#125;/, "}")
  parts = s.split(/(<pre\b.*?<\/pre>)/m)
  parts.map do |part|
    if part =~ /\A<pre\b/
      part.strip
    else
      part.gsub(/\s+/, " ").strip
    end
  end.reject(&:empty?).join("\n")
end

# Collect post URLs from golden pages (author/yyyy/mm/dd/slug/ pattern).
golden_posts = Dir.glob("#{SITE}/*/[0-9][0-9][0-9][0-9]/*/*/*/**/index.html").sort
stats = Hash.new(0)
failures = []
samples = []

golden_posts.each do |gpath|
  rel = gpath.sub("#{SITE}/", "")
  hpath = File.join(PUBLIC, rel)
  golden_html = read(gpath)
  hugo_html = read(hpath)

  if hugo_html.nil?
    failures << [rel, "MISSING hugo file"]
    stats[:missing] += 1
    next
  end

  g_body = normalize(extract_post_text(golden_html))
  h_body = normalize(extract_post_text(hugo_html))
  g_meta = normalize(extract_meta(golden_html))
  h_meta = normalize(extract_meta(hugo_html))

  if g_body == h_body
    stats[:body_match] += 1
  else
    stats[:body_diff] += 1
    failures << [rel, "BODY diff"]
    samples << [rel, g_body, h_body] if samples.size < MAX_SAMPLES
  end

  if g_meta == h_meta
    stats[:meta_match] += 1
  else
    stats[:meta_diff] += 1
    failures << [rel, "META diff: golden=#{g_meta.inspect} hugo=#{h_meta.inspect}"]
  end
end

File.open(REPORT, "w") do |f|
  stats.sort.each { |k, v| f.puts("#{v}\t#{k}") }
  f.puts "\n-- failures (#{failures.size}) --"
  failures.each { |rel, why| f.puts("#{why}\t#{rel}") }
  f.puts "\n-- first #{samples.size} body diffs --"
  samples.each do |rel, g, h|
    f.puts "\n=== #{rel} ==="
    require "tempfile"
    Tempfile.open("g") { |tf| g && tf.write(g); tf.flush; g = tf.path }
    f.puts "--- golden (first divergence) ---"
    g_lines = File.readlines(g || "")
    h_lines = h.lines
    g_lines.each_with_index do |line, i|
      if h_lines[i] != line
        f.puts("GOLD[#{i}]: #{line.inspect}")
        f.puts("HUGO[#{i}]: #{h_lines[i].inspect}")
        break
      end
    end
  end
end

puts stats.sort.map { |k, v| "#{v}\t#{k}" }
puts "failures: #{failures.size} -> #{REPORT}"
exit(failures.empty? ? 0 : 1)
