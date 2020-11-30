require 'rails_helper'

describe GeisterProtocol::Schema::Attribute do
  before { allow(items).to receive(:fetch).with(:properties, {}).and_return(properties) }

  let(:instance) { described_class.new(name, type, items) }
  let(:items) { double('Item') }
  let(:properties) { double('Properties') }

  describe '#type' do
    subject { instance.type }

    let(:name) { 'user' }

    context 'when schema not given to initialize' do
      let(:instance) { described_class.new(name) }

      it { is_expected.to eq 'string' }
    end

    context 'when type is integer' do
      let(:type) { 'integer' }

      it { is_expected.to eq 'int' }
    end

    context 'when type is array' do
      let(:type) { 'array' }

      it { is_expected.to eq "List<#{name.camelize}Info>" }
    end

    context 'when type is other' do
      let(:type) { 'object' }

      it { is_expected.to eq 'string' }
    end
  end

  describe '#info' do
    subject { instance.info }

    let(:name) { 'user' }
    let(:type) { :array }

    it { is_expected.to be_a GeisterProtocol::Schema::Info }
  end
end
