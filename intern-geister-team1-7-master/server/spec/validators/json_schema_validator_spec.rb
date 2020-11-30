require 'rails_helper'

describe JsonSchemaValidator do
  describe '#validate' do
    let(:json_schema) do
      {
        properties: {
          user: {
            properties: {
              name: {
                pattern: /\A[a-z]{4,8}\Z/,
                type: 'string'
              }
            }
          }
        }
      }.to_json
    end

    subject { record }
    before do
      allow(GeisterProtocol).to receive(:to_json_schema).and_return(json_schema)
    end

    let(:model_class) do
      Struct.new(:name) do
        include ActiveModel::Validations
        validates :name, json_schema: { resource: 'user' }
      end
    end

    subject { model_class.new(name) }

    context 'when valid record given' do
      let(:name) { 'alice' }
      it { is_expected.to be_valid }
    end

    context 'when not valid record given' do
      let(:name) { '@@@' }
      it { is_expected.not_to be_valid }
    end

    context 'when resource option not given' do
      let(:model_class) do
        Struct.new do
          include ActiveModel::Validations
          validates :name, json_schema: true
        end
      end

      it { expect { subject }.to raise_error ArgumentError }
    end
  end
end
