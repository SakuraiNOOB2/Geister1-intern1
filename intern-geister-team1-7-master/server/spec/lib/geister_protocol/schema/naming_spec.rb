require 'rails_helper'

describe GeisterProtocol::Schema::Naming do
  class TestClass
    include GeisterProtocol::Schema::Naming
  end

  describe '#action_name' do
    subject { TestClass.new(schema).action_name }
    let(:schema) { { title: "#{action}_test" } }

    context 'when action is index' do
      let(:action) { 'index' }

      it { is_expected.to eq 'list' }
    end

    context 'when action is destroy' do
      let(:action) { 'destroy' }

      it { is_expected.to eq 'delete' }
    end

    context 'when action in normal' do
      let(:action) { 'show' }

      it { is_expected.to eq action }
    end
  end

  describe '#resource_name' do
    subject { TestClass.new(schema).resource_name }
    let(:schema) { { title: "#{action}_#{resource}" } }
    let(:action) { 'show' }
    let(:resource) { 'test' }

    context 'when action is index' do
      let(:action) { 'index' }

      it { is_expected.to eq resource.pluralize }
    end

    context 'when action is index' do
      let(:action) { 'index' }

      it { is_expected.to eq resource.pluralize }
    end

    context 'when action is not index' do
      it { is_expected.to eq resource }
    end

    context 'when resource name has underscore' do
      let(:resource) { 'test_resource' }

      it { is_expected.to eq resource }
    end
  end

  describe '#to_s' do
    subject { TestClass.new(schema).to_s }
    let(:schema) { { title: 'show_user' } }

    it { is_expected.to eq 'TestClassShowUser' }
  end
end
