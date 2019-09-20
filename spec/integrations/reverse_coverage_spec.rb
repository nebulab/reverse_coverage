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
end
