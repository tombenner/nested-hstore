module ActiveRecord
  module Coders
    if ActiveRecord::VERSION::MAJOR < 4
      require 'activerecord-postgres-hstore'

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
          @nested_serializer.deserialize(super)
        end
      end
    else
      class NestedHstore
        def self.load(hstore)
          new.load(hstore)
        end

        def self.dump(hstore)
          new.dump(hstore)
        end

        def initialize
          @nested_serializer = ::NestedHstore::Serializer.new
        end

        def load(hash)
          @nested_serializer.deserialize(hash)
        end

        def dump(value)
          @nested_serializer.serialize(value)
        end
      end
    end
  end
end
