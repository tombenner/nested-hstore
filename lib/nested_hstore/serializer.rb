module NestedHstore
  class Serializer

    def initialize
      @type_key = '__TYPE__'
      @types_map = {
        array: '__ARRAY__',
        boolean: '__BOOLEAN__',
        float: '__FLOAT__',
        integer: '__INTEGER__',
        string: '__STRING__'
      }
      @types_map_inverted = @types_map.invert
      @value_key = '__VALUE__'
    end

    def serialize(value)
      return nil if value.nil?
      case value
      when Array
        type = :array
        hash = array_to_hash(value)
      when FalseClass, TrueClass
        type = :boolean
        hash = { @value_key => value }
      when Float
        type = :float
        hash = { @value_key => value }
      when Hash
        type = :hash
        hash = standardize_value(value)
      when Integer
        type = :integer
        hash = { @value_key => value }
      when String
        type = :string
        hash = { @value_key => value }
      else
        raise "Unsupported hstore type: #{value.class}"
      end
      hash_to_hstore(type, hash)
    end

    def deserialize(hash)
      return nil if hash.nil?
      raise 'Hstore value should be a hash' unless hash.is_a?(Hash)
      type_value = hash.delete(@type_key)
      type = @types_map_inverted[type_value]
      deserialized = case type
        when :array
          hash.values.map { |v| decode_json_if_json(v) }
        when :boolean
          hash[@value_key] == 'true'
        when :float
          hash[@value_key].to_f
        when :integer
          hash[@value_key].to_i
        when :string
          hash[@value_key]
        else
          hash.each do |k, v|
            hash[k] = decode_json_if_json(v)
          end
          hash
      end
      deserialized
    end

    private

    def hash_to_hstore(type, hash)
      return {} if type == :hash && hash.blank?
      
      hstore = hash.dup
      hstore.each do |k, v|
        if v.is_a?(Array) || v.is_a?(Hash)
          hstore[k] = encode_json(v)
        else
          hstore[k] = v.to_s
        end
      end

      if type != :hash
        hstore.merge!(@type_key => @types_map[type])
      end

      hstore
    end

    def standardize_value(value)
      if value.is_a?(Array)
        value.map! do |v|
          standardize_value(v)
        end
      elsif value.is_a?(Hash)
        value.each do |k, v|
          value[k] = standardize_value(v)
        end
      # Standardize Times to an ISO string, as that's what DateTime#to_s evaluates to
      elsif value.is_a?(Time) || value.is_a?(ActiveSupport::TimeWithZone)
        value = value.iso8601
      end
      value
    end

    def array_to_hash(array)
      hash = {}
      array.each_with_index do |value, index|
        hash[index.to_s] = standardize_value(value)
      end
      hash
    end

    # This isn't ideal: how do we know whether each value in an hstore is JSON or a
    # string/integer/etc?
    def decode_json_if_json(value)
      is_json = (value.start_with?('{') && value.end_with?('}')) ||
        (value.start_with?('[') && value.end_with?(']'))
      return value unless is_json
      ActiveSupport::JSON.decode(value)
    rescue
      value
    end

    def encode_json(value)
      ActiveSupport::JSON.encode(value)
    end
  end
end
