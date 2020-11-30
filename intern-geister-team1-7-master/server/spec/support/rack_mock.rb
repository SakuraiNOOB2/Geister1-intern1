shared_context 'rack mock' do
  let(:app) do
    local_schema = schema
    Rack::Builder.new do
      use Rack::JsonSchema::ErrorHandler
      use Rack::JsonSchema::RequestValidation, schema: JSON.parse(local_schema)
      use Rack::JsonSchema::ResponseValidation, schema: JSON.parse(local_schema)
      use Rack::JsonSchema::Mock, schema: JSON.parse(local_schema)
      run ->() { [500, {}, ['Internal Server Error']] }
    end
  end
  let(:schema) { described_class.to_json_schema }
end
