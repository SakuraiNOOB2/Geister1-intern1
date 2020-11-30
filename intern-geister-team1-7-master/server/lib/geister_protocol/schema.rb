module GeisterProtocol
  module Schema
    class << self
      def properties
        @properties ||= begin
          GeisterProtocol.as_json_schema.fetch(:properties).values.map do |schema|
            GeisterProtocol::Schema::Property.new(schema)
          end
        end
      end

      def fetch_property(name)
        properties.find { |property| property.name.to_s == name.to_s }
      end
    end
  end
end
