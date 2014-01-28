module ActiveRecord
  module Coders
    class NestedHstore < Hstore
      def initialize(default=nil)
        super(default)
        @nested_serializer = ::NestedHstore::Serializer.new
      end

      private

      def to_hstore obj
        super(@nested_serializer.serialize(obj))
      end

      def from_hstore hstore
        if ActiveRecord::VERSION::MAJOR >= 4
          @nested_serializer.deserialize(hstore)
        else
          @nested_serializer.deserialize(super)
        end
      end
    end
  end
end
