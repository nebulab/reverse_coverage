# frozen_string_literal: true

require_relative 'helper'

RSpec.describe FakedProject do
  it 'returns proper foo' do
    expect(described_class.foo).to eq('bar')
  end

  it 'tests it\'s framework specific method' do
    expect(FrameworkSpecific.rspec).to eq('Only tested in RSpec')
  end
end
