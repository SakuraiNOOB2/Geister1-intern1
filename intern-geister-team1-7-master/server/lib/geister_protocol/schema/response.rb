module GeisterProtocol
  module Schema
    class Response
      include Naming

      def attributes
        @attributes ||= begin
          properties = (@schema[:targetSchema] || @schema[:schema] || {}).fetch(:properties, {})
          properties.map { |key, value| Attribute.new(key, value[:type], value[:items]) } || []
        end
      end

      def info_definitions
        attributes.map(&:info).compact
      end
    end
  end
end
