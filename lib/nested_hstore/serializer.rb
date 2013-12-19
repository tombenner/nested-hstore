module NestedHstore
  class Serializer

    def initialize
      @type_key = '__TYPE__'
      @types_map = {
        array: '__ARRAY__',
        float: '__FLOAT__',
        hash: '__HASH__',
        integer: '__INTEGER__',
        string: '__STRING__'
      }
      @types_map_inverted = @types_map.invert
      @value_key = '__VALUE__'
    end

    def serialize(value)
      return nil if value.nil?
      if value.is_a?(Array)
        type = :array
        hash = array_to_hash(value)
      elsif value.is_a?(Float)
        type = :float
        hash = { @value_key => value }
      elsif value.is_a?(Hash)
        type = :hash
        hash = standardize_value(value)
      elsif value.is_a?(Integer)
        type = :integer
        hash = { @value_key => value }
      elsif value.is_a?(String)
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
        when :float
          hash[@value_key].to_f
        when :hash
          hash.each do |k, v|
            hash[k] = decode_json_if_json(v)
          end
          hash
        when :integer
          hash[@value_key].to_i
        when :string
          hash[@value_key]
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
      hstore.merge(@type_key => @types_map[type])
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
      return value unless value.start_with?('{') && value.end_with?('}')
      ActiveSupport::JSON.decode(value)
    rescue
      value
    end

    def encode_json(value)
      ActiveSupport::JSON.encode(value)
    end
  end
end
