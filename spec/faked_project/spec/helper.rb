# frozen_string_literal: true

require 'bundler/setup'
# require 'reverse_coverage'

# RSpec.configure do |config|
#   config.before(:suite) do
#     ReverseCoverage::Main.instance.start Coverage.peek_result do |file_path|
#       file_path.include? 'faked_project'
#     end
#   end

#   config.around do |e|
#     e.run
#     ReverseCoverage::Main.instance.add(Coverage.peek_result, e)
#   end

#   config.after(:suite) do
#     ReverseCoverage::Main.instance.save_results('tmp/reverse_coverage.yml')
#   end
# end
