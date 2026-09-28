#!/usr/bin/env ruby
# frozen_string_literal: true
#
# scripts/import_disqus_comments.rb
#
# Converts a Disqus XML export into a Jekyll _data file for static comment
# rendering.  Run this once per author who wants to archive their Disqus
# comments; commit the generated _data/comments/<collection>.yml.
#
# Usage:
#   bundle exec ruby scripts/import_disqus_comments.rb <collection> <export-xml>
#
# Example:
#   bundle exec ruby scripts/import_disqus_comments.rb joshuaflanagan \
#     disqus-comments-export-joshuaflanagan.xml
#
# Requirements:
#   - Run from the repo root.
#   - <collection> must match a key under `collections:` in _config.yml and
#     a directory named _<collection>/ at the repo root.
#   - The export XML is the file downloaded from Disqus (Admin › Moderation ›
#     Export).  It is NOT committed to source control; keep it locally.
#   - disqus.xsd in scripts/ documents the export format for reference.
#
# Output:
#   _data/comments/<collection>.yml
#   Keyed by Disqus thread id (string).  Each value is a flat ordered list of
#   non-spam, non-deleted comments with a `depth` integer so Liquid can render
#   threaded replies without recursion.
#
# Filtering:
#   - Posts where <isSpam>true</isSpam> or <isDeleted>true</isDeleted> are
#     skipped.
#   - Posts from threads that are themselves marked <isDeleted>true</isDeleted>
#     are also skipped.
#   - Posts from threads with no matching _<collection>/*.md file are reported
#     as orphans and skipped.
#
# Threading:
#   Reply nesting is reconstructed from <parent dsq:id="..."/> references and
#   emitted as a pre-order depth-first traversal (each parent immediately
#   precedes its children).  Top-level comments and siblings within a thread
#   are sorted by createdAt ascending.
#
# HTML sanitisation:
#   Comment messages are HTML inside CDATA.  They are sanitised through an
#   allowlist (see ALLOWED_TAGS / ALLOWED_ATTRS below) before being written
#   to the data file, so the Liquid template can render them raw.
#   <script>, <style>, <iframe>, and similar dangerous elements are removed
#   completely (including their children).  All event-handler attributes
#   (on*) and style= attributes are stripped.  <a> tags get
#   rel="nofollow noopener" added.

require 'nokogiri'
require 'yaml'
require 'date'
require 'set'
require 'fileutils'

# ---------------------------------------------------------------------------
# HTML sanitisation
# ---------------------------------------------------------------------------
ALLOWED_TAGS  = Set.new(%w[p br a em strong b i blockquote pre code ul ol li
                            h3 h4 h5 h6 img span]).freeze
ALLOWED_ATTRS = {
  'a'   => %w[href title],
  'img' => %w[src alt title width height],
}.freeze

def sanitize_html(html)
  return '' if html.nil? || html.strip.empty?

  frag = Nokogiri::HTML::DocumentFragment.parse(html)

  # 1. Remove dangerous elements (and their children) entirely.
  frag.css('script, style, iframe, object, embed, form').each(&:remove)

  # 2. Iteratively unwrap disallowed tags, keeping their children.
  #    We loop because unwrapping may expose previously nested disallowed tags.
  loop do
    disallowed = frag.css('*').reject { |n| ALLOWED_TAGS.include?(n.name.downcase) }
    break if disallowed.empty?

    disallowed.each { |n| n.replace(n.children) }
  end

  # 3. Strip disallowed attributes and harden <a> tags.
  frag.css('*').each do |node|
    tag     = node.name.downcase
    allowed = ALLOWED_ATTRS[tag] || []

    node.attribute_nodes.each do |attr|
      name = attr.name.downcase
      if name.start_with?('on') || name == 'style' || !allowed.include?(name)
        node.remove_attribute(attr.name)
      end
    end

    node['rel'] = 'nofollow noopener' if tag == 'a'
  end

  frag.to_html.strip
end

# ---------------------------------------------------------------------------
# XML helpers (after remove_namespaces! the dsq:id attribute becomes plain id)
# ---------------------------------------------------------------------------
def child_text(node, tag)
  el = node.at_xpath(tag)
  el ? el.text.strip : nil
end

def child_bool(node, tag, default: false)
  text = child_text(node, tag)
  text.nil? ? default : (text == 'true')
end

# ---------------------------------------------------------------------------
# Arguments
# ---------------------------------------------------------------------------
if ARGV.length < 2
  $stderr.puts "Usage: #{$0} <collection> <export-xml-path>"
  $stderr.puts "Example: bundle exec ruby #{$0} joshuaflanagan disqus-export.xml"
  exit 1
end
collection = ARGV[0]
xml_path   = ARGV[1]

abort "ERROR: Export file not found: #{xml_path}"        unless File.exist?(xml_path)
abort "ERROR: Collection directory not found: _#{collection}/" unless Dir.exist?("_#{collection}")

# ---------------------------------------------------------------------------
# Read collection author name from _config.yml (used for is_author detection)
# ---------------------------------------------------------------------------
config_author_lc = ''
if File.exist?('_config.yml')
  cfg          = YAML.safe_load(File.read('_config.yml', encoding: 'utf-8'))
  author_str   = cfg.dig('collections', collection, 'author').to_s
  config_author_lc = author_str.downcase
  puts "Collection : #{collection}"
  puts "Author     : #{author_str.empty? ? '(not configured)' : author_str}"
end

# A comment is marked is_author when the Disqus username matches the collection
# name OR the display name matches the configured author (case-insensitive).
def author_match?(name, username, collection, config_author_lc)
  (username && username.downcase == collection.downcase) ||
    (!config_author_lc.empty? && name && name.downcase == config_author_lc)
end

# ---------------------------------------------------------------------------
# Read dsq_thread_id values from post front matter
# ---------------------------------------------------------------------------
post_files     = Dir.glob("_#{collection}/*.md").sort
thread_to_post = {}  # thread id (string) => md filename

post_files.each do |path|
  raw = File.read(path, encoding: 'utf-8')
  next unless raw =~ /\A---\r?\n(.*?)\r?\n---/m

  fm = begin
         # date: fields in front matter are YAML timestamps → Time objects;
         # Ruby 3.1+ safe_load requires explicit permission for these.
         YAML.safe_load($1, permitted_classes: [Time, Date, DateTime])
       rescue StandardError
         nil
       end
  next unless fm.is_a?(Hash)

  Array(fm['dsq_thread_id']).map(&:to_s).each do |tid|
    thread_to_post[tid] = File.basename(path)
  end
end

puts "Posts scanned        : #{post_files.size}"
puts "Posts with thread id : #{thread_to_post.size}"

# ---------------------------------------------------------------------------
# Parse Disqus XML
# ---------------------------------------------------------------------------
doc = Nokogiri::XML(File.read(xml_path, encoding: 'utf-8'))
# After remove_namespaces!, the dsq:id attribute becomes a plain `id` attribute.
# All elements lose their namespace prefix but keep their local name.
# XPath `thread` still matches <thread> elements; node['id'] still gets the
# former dsq:id value; the child <id> element is a distinct entity (at_xpath).
doc.remove_namespaces!

# Index real thread definitions: direct children of <disqus>.
# (Self-closing <thread dsq:id="..." /> references live inside <post> elements
#  and are NOT direct children of <disqus>, so they are excluded here.)
threads = {}
doc.root.xpath('thread').each do |t|
  dsq_id = t['id']
  next unless dsq_id

  threads[dsq_id] = {
    link:    child_text(t, 'link'),
    title:   child_text(t, 'title'),
    deleted: child_bool(t, 'isDeleted'),
    closed:  child_bool(t, 'isClosed'),
  }
end
puts "Threads in export    : #{threads.size}"

# ---------------------------------------------------------------------------
# Collect posts (comments) grouped by thread id
# ---------------------------------------------------------------------------
posts_by_thread = Hash.new { |h, k| h[k] = [] }
counts = { kept: 0, deleted: 0, spam: 0, thread_deleted: 0, no_thread: 0 }

doc.root.xpath('post').each do |p|
  if child_bool(p, 'isDeleted')
    counts[:deleted] += 1
    next
  end
  if child_bool(p, 'isSpam')
    counts[:spam] += 1
    next
  end

  thread_ref = p.at_xpath('thread')
  thread_id  = thread_ref ? thread_ref['id'] : nil

  unless thread_id
    counts[:no_thread] += 1
    next
  end

  thread_meta = threads[thread_id]
  if thread_meta.nil? || thread_meta[:deleted]
    counts[:thread_deleted] += 1
    next
  end

  parent_ref = p.at_xpath('parent')
  parent_id  = parent_ref ? parent_ref['id'] : nil

  author_node     = p.at_xpath('author')
  author_name     = author_node ? child_text(author_node, 'name')     : nil
  author_username = author_node ? child_text(author_node, 'username') : nil

  message = sanitize_html(child_text(p, 'message') || '')

  posts_by_thread[thread_id] << {
    dsq_id:     p['id'],
    parent_id:  parent_id,
    created_at: child_text(p, 'createdAt') || '',
    author:     (author_name || author_username || 'Anonymous')
                  .encode('UTF-8', invalid: :replace, undef: :replace),
    is_author:  author_match?(author_name, author_username, collection, config_author_lc),
    message:    message,
  }
  counts[:kept] += 1
end

puts "Comments kept        : #{counts[:kept]}"
puts "  spam skipped       : #{counts[:spam]}"
puts "  deleted skipped    : #{counts[:deleted]}"
puts "  thread-deleted skip: #{counts[:thread_deleted]}" if counts[:thread_deleted] > 0
puts "  no thread ref skip : #{counts[:no_thread]}"      if counts[:no_thread] > 0

# ---------------------------------------------------------------------------
# Reconstruct threading and build output data structure
# ---------------------------------------------------------------------------
output               = {}  # thread id => flat ordered list of comment hashes
no_comments_posts    = []
matched_thread_count = 0

thread_to_post.each do |tid, post_file|
  raw_posts = posts_by_thread[tid]
  if raw_posts.nil? || raw_posts.empty?
    no_comments_posts << post_file
    next
  end

  # Build look-up and parent→children index.
  by_id    = raw_posts.each_with_object({}) { |p, h| h[p[:dsq_id]] = p }
  children = Hash.new { |h, k| h[k] = [] }

  raw_posts.each do |p|
    pid = p[:parent_id]
    if pid && by_id.key?(pid)
      children[pid] << p
    else
      children[nil] << p  # top-level comment
    end
  end

  # Sort each sibling group chronologically.
  children.each_value { |kids| kids.sort_by! { |c| c[:created_at] } }

  # Pre-order DFS → flat list with depth integers.
  # Each parent is immediately followed by its reply chain.
  flat  = []
  stack = (children[nil] || []).map { |c| [c, 0] }

  until stack.empty?
    post, depth = stack.shift
    flat << {
      'author'    => post[:author],
      'date'      => post[:created_at],
      'depth'     => depth,
      'is_author' => post[:is_author],
      'message'   => post[:message],
    }
    kids = (children[post[:dsq_id]] || []).map { |c| [c, depth + 1] }
    stack.unshift(*kids) unless kids.empty?
  end

  output[tid] = flat
  matched_thread_count += 1
end

# ---------------------------------------------------------------------------
# Print summary
# ---------------------------------------------------------------------------
total_output_comments = output.values.sum(&:size)
known_thread_ids      = Set.new(thread_to_post.keys)
orphan_thread_ids     = Set.new(threads.keys) - known_thread_ids

puts "\n=== Summary ==="
puts "Posts with archived comments : #{matched_thread_count}"
puts "Posts with no comments       : #{no_comments_posts.size}"
puts "Total comments written       : #{total_output_comments}"
puts "Orphan export threads        : #{orphan_thread_ids.size} (no matching post — skipped)"

if no_comments_posts.any?
  puts "\nPosts with no comments:"
  no_comments_posts.each { |f| puts "  #{f}" }
end

if orphan_thread_ids.any?
  puts "\nOrphan export threads (skipped):"
  orphan_thread_ids.first(10).each do |tid|
    t = threads[tid]
    puts "  #{tid}: #{t[:link] || t[:title] || '(no link/title)'}"
  end
  puts "  ... and #{orphan_thread_ids.size - 10} more" if orphan_thread_ids.size > 10
end

# ---------------------------------------------------------------------------
# Write _data/comments/<collection>.yml
# ---------------------------------------------------------------------------
output_dir  = '_data/comments'
output_path = "#{output_dir}/#{collection}.yml"
FileUtils.mkdir_p(output_dir)

File.open(output_path, 'w', encoding: 'utf-8') do |f|
  f.puts "# Auto-generated by scripts/import_disqus_comments.rb — do not edit by hand."
  f.puts "# #{total_output_comments} archived comments across #{matched_thread_count} posts."
  f.puts "# Source: #{File.basename(xml_path)}"
  f.puts "---"

  output.each do |tid, comments|
    # Single-quote the key: without quotes, a numeric-looking YAML key is
    # parsed as an integer, which would break the Liquid string look-up.
    f.puts "'#{tid}':"

    # Serialize the comment array via Psych, strip its "---\n" header, then
    # indent every line by 2 spaces so it nests properly under the key.
    yaml_inner = YAML.dump(comments).sub(/\A---\n/, '')
    yaml_inner.each_line { |line| f.print "  #{line}" }
    f.puts unless yaml_inner.end_with?("\n")
  end
end

puts "\nWrote: #{output_path}"
puts "Done."
