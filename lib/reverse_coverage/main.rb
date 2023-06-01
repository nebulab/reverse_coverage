# frozen_string_literal: true
require 'pry'
Coverage.start

module ReverseCoverageRspec
  class Main
    include Singleton
    include ReverseCoverage

    attr_reader :coverage_matrix
    attr_accessor :config, :output_path

    def add(example)
      coverage_result = Coverage.peek_result
      example_data = slice_attributes(example.metadata, *example_attributes)
      example_data[:example_ref] = example_data.hash
      current_state = select_project_files(coverage_result)
      all_changed_files = changed_lines(@last_state, current_state)

      changes = {}

      all_changed_files.each do |file_path, lines|
        lines.each_with_index do |changed, line_index|
          next if changed.nil? || changed.zero?

          file_info = { file_path: file_path, line_index: line_index }

          save_changes(changes, example_data, file_path: file_path, line_index: line_index)
          save_changes(coverage_matrix, example_data, file_path: file_path, line_index: line_index)
        end
      end

      reset_last_state
      changes
    end

    def initialize
      @config = {
        file_filter: ->(file_path) { file_of_project?(file_path) }
      }
      @output_path = 'tmp'
    end

    def reset_last_state(result = Coverage.peek_result)
      @last_state = select_project_files(result)
    end

    def start
      @coverage_matrix = {}
      reset_last_state
    end

    def save_results(file_name: 'reverse_coverage.yml')
      result_and_stop_coverage
      path = File.join(output_path, file_name)
      FileUtils.mkdir_p(output_path)

      File.write(path, @coverage_matrix.sort.to_h.to_yaml)
    end

    def result_and_stop_coverage
      Coverage.result
    end

    class << self
      def method_missing(method, *args, &block)
        instance.respond_to?(method) ? instance.send(method, *args, &block) : super
      end

      def respond_to_missing?(method, include_private = false)
        instance.respond_to?(method) || super
      end
    end
  end
end

module ReverseCoverageMinitest
  def after_setup
    super
    testFile = self.method(self.name).source_location.first
    Main.add(testFile)
  end

  class Main
    include Singleton
    include ReverseCoverage

    attr_reader :coverage_matrix
    attr_accessor :config, :output_path

    def add(test_information)
      coverage_result = Coverage.peek_result
      example_data = test_information
      current_state = select_project_files(coverage_result)
      all_changed_files = changed_lines(@last_state, current_state)

      changes = {}
      all_changed_files.each do |file_path, lines|
        lines.each_with_index do |changed, line_index|
          next if changed.nil? || changed.zero?

          save_changes(changes, example_data, file_path: file_path, line_index: line_index)
          save_changes(coverage_matrix, example_data, file_path: file_path, line_index: line_index)
        end
      end

      reset_last_state
      changes
    end

    def initialize
      @config = {
        file_filter: ->(file_path) { file_of_project?(file_path) }
      }
      @output_path = 'tmp'
    end

    def reset_last_state(result = Coverage.peek_result)
      @last_state = select_project_files(result)
    end

    def start
      @coverage_matrix = {}
      reset_last_state
    end

    def save_results(file_name: 'reverse_coverage.yml')
      result_and_stop_coverage
      path = File.join(output_path, file_name)
      FileUtils.mkdir_p(output_path)

      File.write(path, @coverage_matrix.sort.to_h.to_yaml)
    end

    def result_and_stop_coverage
      Coverage.result
    end

    class << self
      def method_missing(method, *args, &block)
        instance.respond_to?(method) ? instance.send(method, *args, &block) : super
      end

      def respond_to_missing?(method, include_private = false)
        instance.respond_to?(method) || super
      end
    end
  end
end

module ReverseCoverage
  def save_changes(hash, example_data, file_path:, line_index:)
    hash[file_path] ||= {}
    hash[file_path][line_index] ||= []
    hash[file_path][line_index] << example_data
  end

  def slice_attributes(hash, *keys)
    keys.each_with_object({}) { |k, new_hash| new_hash[k] = hash[k] if hash.key?(k) }
  end

  def changed_lines(prev_state, current_state)
    prev_state.merge(current_state) do |_file_path, prev_line, current_line|
      prev_line.zip(current_line).map { |values| values[0] == values[1] ? nil : (values[1] - values[0]) }
    end
  end

  def example_attributes
    %I[description full_description file_path line_number scoped_id type]
  end

  def select_project_files(coverage_result)
    coverage_result.select { |file_path, _lines| @config[:file_filter].call(file_path) }
  end

  def file_of_project?(file_path)
    file_path.start_with?(Dir.pwd) && !file_path.start_with?(Dir.pwd + '/spec')
  end
end