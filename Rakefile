# frozen_string_literal: true

require 'bundler/gem_tasks'
require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:spec)

task default: :spec

namespace :assets do
  desc "Compiles all assets"
  task :compile do
    puts "Compiling assets"
    require "sprockets"
    base_path = 'lib/reverse_coverage/formatters/html'
    assets = Sprockets::Environment.new
    assets.append_path "#{base_path}/assets/javascripts"
    assets.append_path "#{base_path}/assets/stylesheets"
    assets["application.js"].write_to("#{base_path}/public/application.js")
    assets["settings.js"].write_to("#{base_path}/public/settings.js")
    assets["application.css"].write_to("#{base_path}/public/application.css")
  end
end
