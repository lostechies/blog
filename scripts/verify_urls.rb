#!/usr/bin/env ruby
# frozen_string_literal: true

# Phase 5 verification: compares the Hugo build (public/) against the golden
# Jekyll contract in migration/.
#
# Checks:
#   1. Canonical pages: every golden page URL must exist in the Hugo build.
#   2. Aliases: every golden alias URL must exist as an alias page in Hugo.
#   3. Files: media/asset parity.
#
# Usage: ruby scripts/verify_urls.rb

require "set"

MIGRATION = File.expand_path("../migration", __dir__)
PUBLIC = File.expand_path("../public", __dir__)

golden_pages = File.readlines(File.join(MIGRATION, "golden_pages.txt")).map(&:chomp).to_set
golden_aliases = File.readlines(File.join(MIGRATION, "golden_aliases.txt")).map(&:chomp).map { |l| l.split("\t") }
golden_files = File.readlines(File.join(MIGRATION, "golden_files.txt")).map(&:chomp).to_set

# Enumerate the Hugo build the same way the golden set was extracted from _site.
hugo_pages = Set.new
hugo_files = Set.new
Dir.glob("#{PUBLIC}/**/*").sort.each do |path|
  rel = path.sub("#{PUBLIC}/", "")
  next if File.directory?(path)
  hugo_files << rel
  hugo_pages << "/#{rel}" if rel.end_with?(".html", ".xml", ".json") && !rel.end_with?("index.html")
end
Dir.glob("#{PUBLIC}/**/index.html").sort.each do |path|
  hugo_pages << "/#{path.sub("#{PUBLIC}/", "").sub("index.html", "")}"
end

missing_pages = golden_pages - hugo_pages
extra_pages = hugo_pages - golden_pages

alias_urls = golden_aliases.map(&:first).to_set
missing_aliases = alias_urls - hugo_pages

# Files: golden was the Jekyll _site inventory. Some plugin artifacts are consciously
# not reproduced (documented in the migration report).
skip_files = [/^https:/]                                     # broken jekyll-feed artifact (garbage on live site)

missing_files = golden_files - hugo_files - skip_files.map { |r| golden_files.grep(r) }.flatten.to_set
extra_files = hugo_files - golden_files

puts "== pages =="
puts "golden: #{golden_pages.size}  hugo: #{hugo_pages.size}"
puts "MISSING in Hugo (#{missing_pages.size}):"
missing_pages.sort.first(30).each { |u| puts "  #{u}" }
puts "EXTRA in Hugo (#{extra_pages.size}):"
extra_files_pages = extra_pages.sort.first(30)
extra_files_pages.each { |u| puts "  #{u}" }

puts "== aliases =="
puts "golden: #{alias_urls.size}  missing: #{missing_aliases.size}"
missing_aliases.sort.first(30).each { |u| puts "  MISSING #{u}" }

puts "== files =="
puts "golden: #{golden_files.size}  hugo: #{hugo_files.size}"
puts "MISSING in Hugo (#{missing_files.size}):"
missing_files.sort.first(30).each { |u| puts "  #{u}" }
puts "EXTRA in Hugo (#{extra_files.size}):"
extra_files.sort.first(30).each { |u| puts "  #{u}" }

exit(missing_pages.empty? && missing_aliases.empty? && missing_files.empty? ? 0 : 1)
