#!/usr/bin/env ruby
# frozen_string_literal: true

# Phase 5 link verification: extracts every internal link from the Hugo build
# (both post bodies and templates) and confirms each target resolves as a page,
# file, or alias. Cross-references the golden build so pre-existing broken links
# (broken on the live Jekyll site too) are reported separately from regressions
# introduced by the migration.
#
# Resolution mirrors GitHub Pages:
#   /foo    -> /foo, /foo.html, or /foo/index.html
#   /foo/   -> /foo/index.html
#
# Percent-encoded paths are decoded before lookup, and links to either the apex
# or www host are treated as internal (www redirects to the apex deployment).
#
# Usage: ruby scripts/verify_links.rb

require "set"
require "uri"

module LinkVerifier
  SITE = File.expand_path("../_site", __dir__)
  PUBLIC = File.expand_path("../public", __dir__)
  GOLDEN_PAGES = File.expand_path("../migration/golden_pages.txt", __dir__)
  GOLDEN_ALIASES = File.expand_path("../migration/golden_aliases.txt", __dir__)
  GOLDEN_FILES = File.expand_path("../migration/golden_files.txt", __dir__)
  REPORT = File.expand_path("../migration/link_report.txt", __dir__)

  module_function

  def inventory(dir)
    files = Set.new
    Dir.glob("#{dir}/**/*").each do |path|
      files << path.sub("#{dir}/", "") unless File.directory?(path)
    end
    files
  end

  def resolvable?(files, target)
    path = URI::DEFAULT_PARSER.unescape(target.sub(%r{\A/}, ""))
    return files.include?("#{path}index.html") if target.end_with?("/")

    files.include?(path) || files.include?("#{path}.html") || files.include?("#{path}/index.html")
  end

  # Returns [kind, url], where kind is :internal, :external, or :skip.
  def classify(raw)
    return [:skip, nil] if raw =~ /\A(#|mailto:|javascript:)/

    url = raw.sub(%r{\A(https?:)?//(?:www\.)?lostechies\.com(?=/|\z)}, "").sub(/(#|\?).*/, "")
    return [:skip, nil] if url.empty?
    return [:external, url] if url.start_with?("//")
    return [:skip, nil] unless url.start_with?("/")

    [:internal, url]
  end

  def run
    hugo_files = inventory(PUBLIC)
    golden_files = inventory(SITE) |
                   File.readlines(GOLDEN_FILES).map(&:chomp) |
                   File.readlines(GOLDEN_PAGES).map { |line| line.chomp.sub(%r{\A/}, "") } |
                   File.readlines(GOLDEN_ALIASES).map { |line| line.split("\t").first.chomp.sub(%r{\A/}, "") }

    links = Hash.new(0) # link -> count
    broken_hugo = Set.new
    broken_both = Set.new
    external = Set.new

    Dir.glob("#{PUBLIC}/**/*.html").sort.each do |path|
      File.read(path).scan(/href="([^"]+)"/).flatten.each do |raw|
        kind, url = classify(raw)
        case kind
        when :external
          external << url
        when :internal
          links[url] += 1
        end
      end
    end

    links.keys.sort.each do |url|
      next if resolvable?(hugo_files, url)

      broken_hugo << url
      broken_both << url if resolvable?(golden_files, url)
    end

    File.open(REPORT, "w") do |file|
      file.puts "total internal link targets: #{links.size}"
      file.puts "broken in Hugo build: #{broken_hugo.size}"
      file.puts "  of which ALSO broken on live Jekyll (pre-existing): #{broken_hugo.size - broken_both.size}"
      file.puts "  REGRESSIONS (worked on live, broken in Hugo): #{broken_both.size}"
      file.puts "protocol-relative external targets skipped: #{external.size}"
      file.puts "\n-- regressions --"
      broken_both.sort.each { |url| file.puts "#{links[url]}\t#{url}" }
      file.puts "\n-- pre-existing broken (on live too) --"
      (broken_hugo - broken_both).sort.each { |url| file.puts "#{links[url]}\t#{url}" }
    end

    puts "targets: #{links.size}  broken in hugo: #{broken_hugo.size}  regressions: #{broken_both.size}"
    puts "external targets skipped: #{external.size}"
    puts "report: #{REPORT}"
    exit(broken_both.empty? ? 0 : 1)
  end
end

LinkVerifier.run if $PROGRAM_NAME == __FILE__
