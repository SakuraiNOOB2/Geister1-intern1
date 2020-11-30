module GeisterProtocol
  module Schema
    class Property
      def initialize(schema)
        @schema = schema
      end

      def name
        @schema[:title]
      end

      def attributes
        @schema[:required]
      end

      def links
        @links ||= @schema[:links].map { |link| Link.new(link) }
      end
    end
  end
end
