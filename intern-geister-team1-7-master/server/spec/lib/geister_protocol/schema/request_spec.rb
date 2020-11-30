require 'rails_helper'

describe GeisterProtocol::Schema::Request do
  describe 'params' do
    subject { request.params }

    let(:request) { described_class.new(as_json_schema) }
    let(:as_json_schema) { { method: method, href: href, schema: schema } }
    let(:schema) { { properties: properties } }

    context 'when method is GET' do
      let(:method) { 'GET' }
      let(:href) { '/api/users/:id/pieces/:piece_id' }
      let(:params) { { id: { type: :integer, serialize: false }, piece_id: { type: :integer, serialize: false } } }
      let(:properties) { {} }

      it { is_expected.to eq params }
    end

    context 'when method is not GET' do
      let(:method) { 'PUT' }
      let(:href) { '' }
      let(:params) { { id: { type: :integer, serialize: true }, name: { type: :string, serialize: true } } }
      let(:properties) { { id: { type: 'integer' }, name: { type: 'string' } } }

      it { is_expected.to eq params }
    end
  end

  describe '#to_apiclient_template' do
    subject { request.to_apiclient_template(indent: indent) }

    let(:request) { described_class.new(as_json_schema) }
    let(:as_json_schema) { { method: method, title: title, href: href, schema: schema } }
    let(:schema) { { properties: properties } }
    let(:indent) { 2 }

    let(:api_client_template) do
      [url_template, requester_method_template].join("\n")
    end

    context 'when method is GET' do
      let(:title) { 'show_user' }
      let(:method) { 'GET' }
      let(:href) { '/api/users/:id' }
      let(:properties) { {} }

      let(:url_template) do
        'var url = ipAddr + string.Format ("/api/users/{0}", param.id);'.indent(indent, "\t")
      end

      let(:requester_method_template) do
        'requester.Get<ResponseShowUser> (url, ResponseShowUser);'.indent(indent, "\t")
      end

      it { is_expected.to eq api_client_template }
    end

    context 'when method is not GET' do
      let(:title) { 'create_user' }
      let(:method) { 'DELETE' }
      let(:href) { '/api/users' }
      let(:properties) { {} }

      let(:url_template) do
        %(var url = ipAddr + "/api/users";).indent(indent, "\t")
      end

      let(:requester_method_template) do
        "requester.#{method.downcase.camelize}<RequestCreateUser,ResponseCreateUser> (url, param, ResponseCreateUser);"
          .indent(indent, "\t")
      end

      it { is_expected.to eq api_client_template }
    end
  end
end
