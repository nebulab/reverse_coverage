
Coverage.start

module ReverseCoverage
  class Main
    include Singleton

    attr_reader :coverage_matrix

    def initialize
      @coverage_matrix = {}
    end

    def add(coverage_result, example)
      example_data = example.metadata.extract!(*example_attributes)

      current_state = select_project_files(coverage_result)

      all_changed_files = changed_lines(@last_state, current_state)

      all_changed_files.each do |file_path, lines|
        lines.each_with_index do |changed, line_index|
          next unless changed.present?

          coverage_matrix[file_path] ||= {}
          coverage_matrix[file_path][line_index] ||= []
          coverage_matrix[file_path][line_index] << example_data
        end
      end

      @last_state = current_state
    end

    def start(coverage_result)
      @last_state = select_project_files(coverage_result)
    end

    def save_results(path = 'tmp/reverse_coverage.yml')
      File.open(path, 'w') do |f|
        results = @coverage_matrix.sort.map { |k, v| [k, v.sort.to_h] }.to_h

        f.write results.to_yaml
      end
    end

    private

    def changed_lines(prev_state, current_state)
      prev_state.merge(current_state) do |_file_path, prev_line, current_line|
        prev_line.zip(current_line).map { |values| values[0] == values[1] ? nil : (values[1] - values[0]) }
      end
    end

    def example_attributes
      %I[description full_description file_path line_number scoped_id type]
    end

    def select_project_files(coverage_result)
      coverage_result.select { |file_path, _lines| file_of_project?(file_path) }
    end

    def file_of_project?(file_path)
      file_path.start_with?(Dir.pwd) && !file_path.start_with?(Dir.pwd + '/spec')
    end
  end
end
