# frozen_string_literal: true

Coverage.start

module ReverseCoverage
  class Main
    include Singleton

    attr_reader :coverage_matrix

    def initialize
      @coverage_matrix = {}
      @config = {
        file_filter: ->(file_path) { file_of_project?(file_path) }
      }
    end

    def add(example)
      coverage_result = Coverage.peek_result
      example_data = slice_attributes(example.metadata, *example_attributes)
      current_state = select_project_files(coverage_result)
      all_changed_files = changed_lines(@last_state, current_state)
      all_changed_files.each do |file_path, lines|
        lines.each_with_index do |changed, line_index|
          next if changed.nil? || changed.zero?

          coverage_matrix[file_path] ||= {}
          coverage_matrix[file_path][line_index] ||= []
          coverage_matrix[file_path][line_index] << example_data
        end
      end
      @last_state = current_state
    end

    def config(option, value)
      @config[option] = value
    end

    def start
      @last_state = select_project_files(Coverage.peek_result)
    end

    def save_results(path = 'tmp/reverse_coverage.yml')
      Coverage.result # NOTE: disables coverage measurement
      File.open(path, 'w') do |f|
        results = @coverage_matrix.sort.map { |k, v| [k, v.sort.to_h] }.to_h
        f.write results.to_yaml
      end
    end

    class << self
      def method_missing(method, *args, &block)
        instance.respond_to?(method) ? instance.send(method, *args, &block) : super
      end

      def respond_to_missing?(method, include_private = false)
        instance.respond_to?(method) || super
      end
    end

    private

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
end
