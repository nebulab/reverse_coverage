# frozen_string_literal: true

require 'bundler/setup'
require 'reverse_coverage'
require 'pry'

RSpec.configure do |config|
  # # Enable flags like --only-failures and --next-failure
  # config.example_status_persistence_file_path = '.rspec_status'

  # # Disable RSpec exposing methods globally on `Module` and `main`
  # config.disable_monkey_patching!

  # config.expect_with :rspec do |c|
  #   c.syntax = :expect
  # end


  # config.before(:suite) do
  #   ReverseCoverage::Main.instance.start Coverage.peek_result do |file_path|
  #     file_path.start_with?(Dir.pwd)
  #   end
  # end

  # config.around do |e|
  #   e.run
  #   ReverseCoverage::Main.instance.add(Coverage.peek_result, e)
  # end

  # config.after(:suite) do
  #   ReverseCoverage::Main.instance.save_results('tmp/reverse_coverage.yml')
  # end

  # config.before(:suite) do
  #   binding.pry
  # end

  # config.after(:suite) do
  #   binding.pry
  # end

  # config.register_ordering :global do |example|
  #   binding.pry
  # end
end

# require File.expand_path('faked_project/lib/faked_project.rb', __dir__)
