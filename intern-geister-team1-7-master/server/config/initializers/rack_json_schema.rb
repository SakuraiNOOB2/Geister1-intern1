Rails.application.configure do |config|
  schema = JSON.load(GeisterProtocol.to_json_schema)
  config.middleware.use Rack::JsonSchema::ErrorHandler
  config.middleware.use Rack::JsonSchema::RequestValidation, schema: schema
end
