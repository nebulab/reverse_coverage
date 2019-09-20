# frozen_string_literal: true

require 'spec_helper'

RSpec.describe ReverseCoverage do
  let(:reverse_coverage) { ReverseCoverage::Main }

  around do |e|
    config = reverse_coverage.config.dup

    e.run

    reverse_coverage.config = config
  end

  describe '#add' do
    subject(:described_method) { ->(e) { reverse_coverage.add(e) } }

    let(:example) { -> { expect(SomeClass.new('foo').reverse).to eq 'oof' } }
    let(:start_reverse_coverage) { reverse_coverage.start }

    before do
      start_reverse_coverage
      require_relative '../../spec/faked_project/lib/faked_project.rb'
      example.call
    end

    context 'when faked_project dir path is excluded' do
      it "doesn't fill the coverage_matrix" do |e|
        expect(described_method.call(e)).to be_empty
        expect(reverse_coverage.coverage_matrix).to be_empty
      end
    end

    context 'when faked_project dir path is included' do
      let(:start_reverse_coverage) do
        reverse_coverage.config[:file_filter] = ->(file_path) { file_path.include? 'faked_project' }
        reverse_coverage.start
      end

      it 'fills the coverage_matrix with SomeClass Data' do |e|
        expect(described_method.call(e)).not_to be_empty
        expect(reverse_coverage.coverage_matrix).not_to be_empty
      end
    end
  end

  describe '#reset_last_state' do
    subject(:described_method) { reverse_coverage.reset_last_state }

    before do
      reverse_coverage.config[:file_filter] = ->(file_path) { file_path.include? 'faked_project' }
      reverse_coverage.start
      require_relative '../../spec/faked_project/lib/faked_project.rb'
    end

    it 'returns only the lines executed after reset' do |e|
      SomeClass.new('foo').reverse
      diff = reverse_coverage.add(e)

      key = diff.keys.detect { |file_path| file_path.end_with?('/some_class.rb') }
      expect(diff).to match(hash_including(key => hash_including(7, 11)))

      described_method

      SomeClass.new('FOO').downcase
      diff = reverse_coverage.add(e)
      key = diff.keys.detect { |file_path| file_path.end_with?('/some_class.rb') }
      expect(diff).to match(hash_including(key => hash_including(7, 15)))
      expect(diff).not_to match(hash_including(key => hash_including(11)))
    end
  end
end
