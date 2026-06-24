# frozen_string_literal: true

source "https://rubygems.org"

plugin "bundler-inject", "~> 2.0"
begin
  require File.join(Bundler::Plugin.index.load_paths("bundler-inject")[0], "bundler-inject")
rescue
  nil
end

# Specify your gem's dependencies in floe-servicenow.gemspec
gemspec
