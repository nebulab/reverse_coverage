# frozen_string_literal: true

require "erb"
require "cgi"
require "fileutils"
require "digest/sha1"
require "time"

module ReverseCoverage
  module Formatters
    module HTML
      class Formatter
        def format(result)
          public_r = './public/*'
          Dir[File.join(File.dirname(__FILE__), public_r)].each do |path|
            FileUtils.cp_r(path, asset_output_path)
          end

          File.open(File.join(output_path, "index.html"), "wb") do |file|
            file.puts template("layout").result(binding)
          end
          puts output_message(result)
        end

        def output_message(result)
          "Coverage report generated for #{result.count} files to #{output_path}."
        end

        private

        # Returns the an erb instance for the template of given name
        def template(name)
          ERB.new(File.read(File.join(File.dirname(__FILE__), "views", "#{name}.erb")))
        end

        def output_path
          ReverseCoverage::Main.output_path
        end

        def asset_output_path
          return @asset_output_path if defined?(@asset_output_path) && @asset_output_path

          @asset_output_path = File.join(output_path, "assets", ReverseCoverage::VERSION)
          FileUtils.mkdir_p(@asset_output_path)
          @asset_output_path
        end

        def assets_path(name)
          File.join("./assets", ReverseCoverage::VERSION, name)
        end

        # Returns the html for the given source_file
        def formatted_source_file(source_file)
          template("source_file").result(binding)
        rescue Encoding::CompatibilityError => e
          puts "Encoding problems with file #{filename(source_file)}. Simplecov/ERB can't handle non ASCII characters in filenames. Error: #{e.message}."
        end

        def readfile(source_file)
          File.open(filename(source_file), "rb", &:readlines)
        end

        def grouped(files)
          grouped = {}
          grouped_files = []

          groups = {
            'Controllers' => %r{/app/controllers},
            'Channels' => %r{/app/channels},
            'Models' => %r{/app/models},
            'Mailers' => %r{/app/mailers},
            'Helpers' => %r{/app/helpers},
            'Jobs' => %r{/app/jobs|/app/workers},
            'Libraries' => %r{/lib/}
          }

          groups.each do |name, filter|
            grouped[name] = files.select { |source_file| filter.match?(source_file) }
            grouped_files += grouped[name].keys
          end
          if !groups.empty? && !(other_files = files.reject { |source_file| grouped_files.include?(source_file) }).empty?
            grouped["Ungrouped"] = other_files
          end
          grouped
        end

        # Returns a table containing the given source files
        def formatted_file_list(title, source_files)
          title_id = title.gsub(/^[^a-zA-Z]+/, "").gsub(/[^a-zA-Z0-9\-\_]/, "")
          # Silence a warning by using the following variable to assign to itself:
          # "warning: possibly useless use of a variable in void context"
          # The variable is used by ERB via binding.
          title_id = title_id
          template("file_list").result(binding)
        end

        def coverage_css_class(covered_percent)
          if covered_percent > 90
            "green"
          elsif covered_percent > 80
            "yellow"
          else
            "red"
          end
        end

        def strength_css_class(covered_strength)
          if covered_strength > 1
            "green"
          elsif covered_strength == 1
            "yellow"
          else
            "red"
          end
        end

        def filename(source_file)
          source_file.first.to_s
        end

        # Return a (kind of) unique id for the source file given. Uses SHA1 on path for the id
        def id(source_file)
          Digest::SHA1.hexdigest(filename(source_file))
        end

        def timeago(time)
          "<abbr class=\"timeago\" title=\"#{time.iso8601}\">#{time.iso8601}</abbr>"
        end

        def shortened_filename(source_file)
          filename(source_file).sub(Dir.pwd, '.').gsub(%r{^./}, "")
        end

        def link_to_source_file(source_file)
          %(<a href="##{id source_file}" class="src_link" title="#{shortened_filename source_file}">#{shortened_filename source_file}</a>)
        end
      end
    end
  end
end
