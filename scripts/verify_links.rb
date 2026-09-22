#!/usr/bin/env ruby
# frozen_string_literal: true

# Phase 5 link verification: extracts every internal link from the Hugo build
# (both post bodies and templates) and confirms each target exists as a page,
# file, or alias. Cross-references the golden build so pre-existing broken
# links (broken on the live Jekyll site too) are reported separately from
# regressions introduced by the migration.
#
# Usage: ruby scripts/verify_links.rb

require "set"

SITE = File.expand_path("../_site", __dir__)
PUBLIC = File.expand_path("../public", __dir__)
GOLDEN_PAGES = File.expand_path("../migration/golden_pages.txt", __dir__)
GOLDEN_ALIASES = File.expand_path("../migration/golden_aliases.txt", __dir__)
REPORT = File.expand_path("../migration/link_report.txt", __dir__)

def inventory(dir)
  pages = Set.new
  files = Set.new
  Dir.glob("#{dir}/**/*").each do |p|
    next if File.directory?(p)
    rel = p.sub("#{dir}/", "")
    files << rel
    pages << "/#{rel}" unless rel.end_with?("index.html")
  end
  Dir.glob("#{dir}/**/index.html").each do |p|
    pages << "/#{p.sub("#{dir}/", "").sub("index.html", "")}"
  end
  [pages, files]
end

hugo_pages, hugo_files = inventory(PUBLIC)
golden_pages, golden_files = inventory(SITE)
golden_pages += File.readlines(GOLDEN_PAGES).map(&:chomp)
golden_alias_urls = File.readlines(GOLDEN_ALIASES).map { |l| l.split("\t").first.chomp }.to_set

# Existing-on-live = resolvable through golden pages/files/aliases.
golden_resolvable = golden_pages + golden_files.map { |f| "/#{f}" } + golden_alias_urls
hugo_resolvable = hugo_pages + hugo_files.map { |f| "/#{f}" }

links = Hash.new(0) # link -> count
broken_hugo = Set.new
broken_both = Set.new

Dir.glob("#{PUBLIC}/**/*.html").sort.each do |path|
  html = File.read(path)
  html.scan(/href="([^"]+)"/).flatten.each do |raw|
    next if raw =~ /\A(#|mailto:|javascript:)/
    url = raw.sub(%r{\A(https?:)?//lostechies\.com}, "").sub(/(#|\?).*/, "")
    next if url.empty?
    next unless url.start_with?("/") # external links skipped
    links[url] += 1
  end
end

links.keys.sort.each do |url|
  target = url.end_with?("/") ? url : url
  # a link resolves if the dir page, the exact file, or file + /index.html exists
  ok = hugo_resolvable.include?(target) ||
       hugo_resolvable.include?("#{target}/") ||
       hugo_resolvable.include?("#{target}/index.html") ||
       hugo_resolvable.include?("#{target.sub(%r{/\z}, "")}/index.html")
  next if ok
  broken_hugo << url
  was_ok_on_live = golden_resolvable.include?(target) ||
                   golden_resolvable.include?("#{target}/") ||
                   golden_resolvable.include?("#{target}/index.html") ||
                   golden_resolvable.include?("#{target.sub(%r{/\z}, "")}/index.html")
  broken_both << url if was_ok_on_live
end

File.open(REPORT, "w") do |f|
  f.puts "total internal link targets: #{links.size}"
  f.puts "broken in Hugo build: #{broken_hugo.size}"
  f.puts "  of which ALSO broken on live Jekyll (pre-existing): #{broken_hugo.size - broken_both.size}"
  f.puts "  REGRESSIONS (worked on live, broken in Hugo): #{broken_both.size}"
  f.puts "\n-- regressions --"
  broken_both.sort.each { |u| f.puts "#{links[u]}\t#{u}" }
  f.puts "\n-- pre-existing broken (on live too) --"
  (broken_hugo - broken_both).sort.each { |u| f.puts "#{links[u]}\t#{u}" }
end

puts "targets: #{links.size}  broken in hugo: #{broken_hugo.size}  regressions: #{broken_both.size}"
puts "report: #{REPORT}"
exit(broken_both.empty? ? 0 : 1)
