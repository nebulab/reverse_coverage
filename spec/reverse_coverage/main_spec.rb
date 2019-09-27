# frozen_string_literal: true

# require 'pry'
# require 'rspec/core/rake_task'

require 'spec_helper'

RSpec.describe ReverseCoverage::Main, skip: 'Outdated spec! TODO: remove me' do
  subject(:described_instance) { described_class.instance }

  before do
    described_class.start Coverage.peek_result do |file_path|
      file_path.include? 'faked_project'
    end
    require_relative '../../spec/faked_project/lib/faked_project.rb'
  end

  # after do
  #   # p described_class.coverage_matrix
  #   # described_class.save_results('tmp/reverse_coverage.yml')
  # end

  it 'checks if coverage_matrix is filled' do |e|
    expect(described_instance.coverage_matrix).to be_empty
    expect(SomeClass.new('foo').reverse).to eq 'oof'
    described_class.add(Coverage.peek_result, e)
    expect(described_instance.coverage_matrix).not_to be_empty
  end

  # describe '.start' do
  #   subject(:described_method) { described_class.instance.start }

  #   it { expect{ described_method }.to raise_error(ArgumentError) }

  #   context 'with coverage_result argument' do
  #     subject(:described_method) { described_class.instance.start(Coverage.peek_result) }

  #     it { binding.pry }
  #   end
  # end
end
