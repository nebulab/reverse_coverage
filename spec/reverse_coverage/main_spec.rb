# frozen_string_literal: true

require 'pry'

RSpec.describe ReverseCoverage::Main do
  subject(:described_instance) { described_class.instance }

  it { expect(described_instance.coverage_matrix).to be_empty }

  describe '.start' do
    subject(:described_method) { described_class.instance.start }

    it { expect{ described_method }.to raise_error(ArgumentError) }

    # context 'with coverage_result argument' do
    #   subject(:described_method) { described_class.instance.start(coverage_result) }

    #   let(:coverage_result) {}

    #   # it { binding.pry }
    # end
  end
end
