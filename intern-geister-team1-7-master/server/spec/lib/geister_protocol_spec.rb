require 'rails_helper'

describe GeisterProtocol do
  subject { described_class.to_json_schema }

  let(:user_json) { JSON.parse(GeisterProtocol::User.to_json_schema) }

  it 'include basic values' do
    is_expected.to be_json_including('title' => 'API for Geister')
    is_expected.to be_json_including('description' => 'API for Geister in DOKIDOKI GROOVEWORKS')
    is_expected.to be_json_including('properties' => { 'user' => user_json })
    is_expected.to be_json_including('required' => ['user'])
  end

  describe 'schema.json' do
    let(:generated_json) { File.read(Rails.root.join('schema.json')) }

    it 'should updated schema.json' do
      is_expected.to eq generated_json
    end
  end

  describe 'schema.md' do
    subject { Jdoc::Generator.call(JSON.parse(described_class.to_json_schema)) }
    let(:generated_md) { File.read(Rails.root.join('schema.md')) }

    it 'should updated schema.json' do
      is_expected.to eq generated_md
    end
  end
end
