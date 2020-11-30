module Protocol
  module DefinitionMethods
    extend ActiveSupport::Concern

    module ClassMethods
      def definition(name, value)
        definitions[name] = value
      end

      def definitions
        @definitions ||= {}
      end

      def ref(name)
        definitions[name]
      end

      def examples
        definitions.each_with_object({}) do |(key, value), hash|
          hash[key] = value[:example]
        end
      end

      def example_hash(*keys)
        keys.each_with_object({}) do |key, hash|
          hash[key.to_s.downcase] = examples[key]
        end
      end

      def example(name)
        ref(name)[:example]
      end
    end
  end
end
