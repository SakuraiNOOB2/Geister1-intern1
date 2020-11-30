module GeisterProtocol
  module Schema
    class Info
      attr_reader :name

      def initialize(name, properties)
        @name = name
        @properties = properties
      end

      def to_s
        "#{name.to_s.singularize.camelize}Info"
      end

      def attributes
        @attributes ||= begin
          return [] unless @properties
          @properties.map { |key, value| Attribute.new(key, value[:type]) }
        end
      end
    end
  end
end
