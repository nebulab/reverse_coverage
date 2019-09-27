require 'reverse_coverage'

RSpec.configure do |config|
  config.before(:suite) do
    ReverseCoverage::Main.config[:file_filter] = ->(file_path) { file_path.include? 'faked_project' }
    ReverseCoverage::Main.start
  end

  config.around do |e|
    e.run
    ReverseCoverage::Main.add(e)
  end

  config.after(:suite) do
    ReverseCoverage::Main.save_results
    coverage_matrix = ReverseCoverage::Main.coverage_matrix
    ReverseCoverage::Formatters::HTML::Formatter.new.format(coverage_matrix)
  end
end
