require 'rails_helper'

describe GeisterProtocol::Schema::Response do
  describe '#attributes' do
    subject { response.attributes }

    let(:response) { described_class.new(as_json_schema) }
    let(:as_json_schema) { {} }

    let(:schema) { { properties: { id: { type: 'integer' } } } }
    let(:target_schema) { { properties: { name: { type: 'string' } } } }

    context 'when targetSchema is exist' do
      let(:as_json_schema) { { targetSchema: target_schema } }

      it { is_expected.to be_a Array }
      it { is_expected.to be_present }
      it { expect(subject.first.name).to eq :name }
    end

    context 'when targetSchema is not exist and schema is exist' do
      let(:as_json_schema) { { schema: schema } }

      it { is_expected.to be_a Array }
      it { is_expected.to be_present }
      it { expect(subject.first.name).to eq :id }
    end

    context 'when targetSchema and schema are not exist' do
      it { is_expected.to be_a Array }
      it { is_expected.to be_empty }
    end
  end
end
