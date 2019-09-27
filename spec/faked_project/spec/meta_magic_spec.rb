# frozen_string_literal: true

require_relative 'helper'

RSpec.describe FakedProject do
  subject(:described_instance) { described_class.new }

  it 'adds a class method to FakedProject' do
    expect(described_class.a_class_method).to eq('this is a mixed-in class method')
  end

  it 'adds a mixed-in instance method to FakedProject' do
    expect(described_instance.an_instance_method).to eq('this is a mixed-in instance method')
  end

  it 'adds a dynamically-defined instance method to FakedProject' do
    expect(described_instance.dynamic).to eq('A dynamically defined instance method')
  end
end
