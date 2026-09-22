#!/usr/bin/env ruby
# frozen_string_literal: true

# Uses the Jekyll API to emit an exact source-file -> URL map for every doc.
# Output: migration/jekyll_url_map.txt with lines: <relative source path>\t<URL>

require "jekyll"

config = Jekyll.configuration({
  "config" => ["_config.yml", "_config_golden.yml"], # golden overlay excludes the Hugo tree
  "source" => File.expand_path("..", __dir__),
  "destination" => File.expand_path("../_site_map_tmp", __dir__),
  "quiet" => true,
  "incremental" => false,
})

site = Jekyll::Site.new(config)
site.read # urls are computed at read time; no rendering (avoids gist network calls)

out = File.expand_path("../migration/jekyll_url_map.txt", __dir__)
FileUtils = nil unless defined?(FileUtils)
require "fileutils"
FileUtils.mkdir_p(File.dirname(out))

File.open(out, "w") do |f|
  [site.pages, site.collections.values.map(&:docs).flatten].flatten.compact.each do |item|
    rel = item.respond_to?(:relative_path) ? item.relative_path : item.path
    next unless rel
    rel = rel.sub(%r{^\./}, "")
    f.puts("#{rel}\t#{item.url}")
  end
end

puts "wrote #{out} (#{File.readlines(out).size} entries)"
