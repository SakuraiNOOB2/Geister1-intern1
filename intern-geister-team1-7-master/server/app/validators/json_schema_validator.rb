class JsonSchemaValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    errors = fully_validate(attribute, value)

    return unless errors

    errors.each do |error|
      record.errors[attribute] << error[:message]
    end
  end

  private

  def fully_validate(attribute, value)
    fail ArgumentError.new, 'resource option is required' unless options[:resource]
    property = options[:property] || attribute
    fragment = "#/properties/#{options[:resource]}/properties/#{property}"
    JSON::Validator.fully_validate(json_schema, value, fragment: fragment, errors_as_objects: true)
  end

  def json_schema
    @json_schema ||= GeisterProtocol.to_json_schema
  end
end
