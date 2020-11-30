require 'rails_helper'

describe GeisterProtocol::Schema do
  describe '.properties' do
    subject { described_class.properties }

    it { is_expected.to be_a Array }
    it { is_expected.to all(be_a(GeisterProtocol::Schema::Property)) }
  end

  describe '.fetch_property' do
    subject { described_class.fetch_property(name) }

    before do
      allow(property).to receive(:name).and_return(name)
      allow(described_class).to receive(:properties).and_return([property])
    end

    let(:property) { double('Property') }
    let(:name) { 'alice' }

    it { is_expected.to eq property }
  end
end
