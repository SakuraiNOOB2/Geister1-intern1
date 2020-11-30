require 'rails_helper'

describe GeisterProtocol::Schema::Info do
  let(:name) { 'user' }
  let(:properties) do
    {
      id: { type: 'integer' },
      name: { type: 'string' },
      password: { type: 'string' }
    }
  end

  describe '#to_s' do
    subject { described_class.new(name, properties).to_s }

    it { is_expected.to eq 'UserInfo' }
  end

  describe '#attributes' do
    subject { described_class.new(name, properties).attributes }

    it { is_expected.to be_a Array }
    it { is_expected.to all(be_a(GeisterProtocol::Schema::Attribute)) }
  end
end
