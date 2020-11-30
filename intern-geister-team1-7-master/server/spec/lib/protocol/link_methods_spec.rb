require 'rails_helper'

describe Protocol::LinkMethods do
  module DummyDSL
    extend ActiveSupport::Concern

    module ClassMethods
      def title
        'test'
      end

      def link(name, options)
        dummy_method(name, options)
      end

      def dummy_method(_name, _options); end
    end
  end

  let(:test_class) do
    Class.new do
      include DummyDSL
      include Protocol::LinkMethods
    end
  end

  describe '.link' do
    subject { test_class.link(action_name, options) }

    let(:options) { Hash.new }

    let(:action_name) { :show }
    let(:link_name) { 'show_test' }
    let(:expected_options) { { method: 'GET', rel: 'self' } }

    it 'should correct options give to overrided method' do
      expect(test_class).to receive(:dummy_method).with(link_name, expected_options)
      subject
    end
  end
end
