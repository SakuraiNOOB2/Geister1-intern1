module GeisterProtocol
  module Schema
    class Attribute
      attr_reader :type

      def initialize(name, type = :string, items = nil, serialize = true)
        @name = name.to_s.singularize.to_sym
        @properties = items&.fetch(:properties, {})
        @type = convert_to_csharp(type)
        @serialize = serialize
      end

      def name
        array? ? @name.to_s.pluralize.to_sym : @name
      end

      def array?
        type.start_with? 'List'
      end

      def info
        @info ||= @properties ? Info.new(name, @properties) : nil
      end

      def serializable?
        @serialize
      end

      private

      def convert_to_csharp(type)
        case type.to_sym
        when :integer then 'int'
        when :boolean then 'bool'
        when :array then "List<#{@name.to_s.camelize}Info>"
        else 'string'
        end
      end
    end
  end
end
