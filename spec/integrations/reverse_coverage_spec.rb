# frozen_string_literal: true

require 'spec_helper'

RSpec.describe ReverseCoverage do
  subject(:a_spec) { -> { expect(SomeClass.new('foo').reverse).to eq 'oof' } }

  let(:main_instance) { ReverseCoverage::Main.instance }
  let(:start_reverse_coverage) { main_instance.start }

  before do |e|
    start_reverse_coverage
    require_relative '../../spec/faked_project/lib/faked_project.rb'
    a_spec.call
    main_instance.add(e)
  end

  it 'checks if coverage_matrix is filled with SomeClass Data' do
    # NOTE: by default 'spec' path is filtered out
    expect(main_instance.coverage_matrix).to be_empty
  end

  context 'when faked_project dir is included' do
    let(:start_reverse_coverage) do
      main_instance.config(:file_filter, ->(file_path) {
        file_path.include? 'faked_project'
      })
    end

    it 'checks if coverage_matrix is filled with SomeClass Data' do
      expect(main_instance.coverage_matrix).not_to be_empty
    end
  end
end
