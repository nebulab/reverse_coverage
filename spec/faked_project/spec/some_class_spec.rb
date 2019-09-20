# frozen_string_literal: true

require_relative 'helper'

RSpec.describe SomeClass do
  subject(:described_instance) { described_class.new('foo') }

  it 'is reversible' do
    expect(described_instance.reverse).to eq('oof')
  end

  it 'compares with \'foo\'' do
    expect(described_instance.compare_with('foo')).to be true
  end
end
