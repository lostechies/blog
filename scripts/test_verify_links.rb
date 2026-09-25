#!/usr/bin/env ruby
# frozen_string_literal: true

require "set"
require_relative "verify_links"

module LinkVerifier
  def self.assert_equal(expected, actual, label)
    return if expected == actual

    warn "FAIL #{label}: expected #{expected.inspect}, got #{actual.inspect}"
    @failed = true
  end

  def self.assert(condition, label)
    assert_equal(true, condition, label)
  end

  def self.run_tests
    @failed = false

    files = Set.new(%w[
      index.html
      about.html
      jimmybogard/archive.html
      jimmybogard/2017/01/26/new-year-new-blog/index.html
      blogs/chad_myers/index.html
    ])

    assert resolvable?(files, "/"), "/ resolves to index.html"
    assert resolvable?(files, "/about"), "/about resolves to about.html"
    assert_equal false, resolvable?(files, "/about/"), "/about/ does not resolve to about.html"
    assert resolvable?(files, "/jimmybogard/archive"), "/archive resolves to archive.html"
    assert_equal false, resolvable?(files, "/jimmybogard/archive/"), "/archive/ does not resolve to archive.html"
    assert resolvable?(files, "/jimmybogard/2017/01/26/new-year-new-blog"), "extensionless post resolves to index.html"
    assert resolvable?(files, "/jimmybogard/2017/01/26/new-year-new-blog/"), "trailing-slash post resolves to index.html"
    assert resolvable?(files, "/blogs/chad%5Fmyers/"), "percent-encoded directory resolves"
    assert_equal false, resolvable?(files, "/blogs/joe_ocampo/default.aspx"), "missing target stays broken"

    assert_equal [:internal, "/about"], classify("https://lostechies.com/about#top"), "apex host is internal"
    assert_equal [:internal, "/about"], classify("https://www.lostechies.com/about"), "www host is internal"
    assert_equal [:external, "//static.techpines.com/rainbow.css"], classify("//static.techpines.com/rainbow.css"), "protocol-relative external is external"
    assert_equal [:skip, nil], classify("mailto:[EMAIL]"), "mailto is skipped"
    assert_equal [:skip, nil], classify("#section"), "fragment is skipped"

    if @failed
      exit 1
    else
      puts "verify_links tests: OK"
    end
  end
end

LinkVerifier.run_tests
