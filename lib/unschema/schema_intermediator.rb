module Unschema
  class SchemaIntermediator
    attr_reader :root

    def process(*args, &block)
      @root = Call.new(:root, *args)
      root.instance_eval(&block)
    end

    def calls
      root.calls
    end

    class Call
      attr_reader :name, :args, :block, :calls
      def initialize(name, *args, &block)
        @name = name
        @args = args
        @calls = []

        process_block!(block) if block
      end

      def method_missing(name, *args, &block)
        @calls << Call.new(name, *args, &block)
      end

      private
      def process_block!(block)
        @block = self.class.new("t")
        block.call(@block)
      end
    end
  end
end