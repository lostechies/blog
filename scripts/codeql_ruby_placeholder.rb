# frozen_string_literal: true

# Placeholder so CodeQL's default-setup Ruby analysis has source to scan.
#
# CodeQL runs from repository default setup (not a workflow file) and its
# language list still includes `ruby`. This repo no longer has any Ruby: the
# site builds with Hugo, and the verification gates are Node scripts. Without a
# Ruby file, that job fails with:
#
#   Error: CodeQL could not process any code written in Ruby.
#
# Removing `ruby` from Settings -> Code security -> Code scanning -> CodeQL
# analysis -> Languages is the real fix, but it is a repository-wide setting
# change. This file keeps the check green until that happens.
#
# DELETE THIS FILE in the follow-up PR that retires the Ruby language from
# CodeQL default setup. See migration/VERIFICATION.md.

module LosTechies
  # No runtime behavior: this module exists only to give the Ruby analyzer a
  # parseable source file.
  module CodeqlPlaceholder
  end
end
