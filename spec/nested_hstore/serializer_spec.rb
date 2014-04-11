require 'spec_helper'

describe NestedHstore::Serializer do
  let(:serializer) { NestedHstore::Serializer.new }

  def it_serializes
    serialized = serializer.serialize(@deserialized)
    serialized.should == @serialized
  end

  def it_deserializes
    deserialized = serializer.deserialize(@serialized)
    deserialized.should == @deserialized
  end


  context 'with a nested hash' do
    before :each do
      @deserialized = {
        'a' => {
          'b' => {
            'c' => 'String 1',
            'd' => 'String 2'
          }
        },
        'e' => {
          'f' => 'String 3'
        }
      }
      @serialized = {
       "a"=>"{\"b\":{\"c\":\"String 1\",\"d\":\"String 2\"}}",
       "e"=>"{\"f\":\"String 3\"}",
      }
    end

    describe '#serialize' do
      it('serializes') { it_serializes }
    end

    describe '#deserialize' do
      it('deserializes') { it_deserializes }
    end

    context 'with a type attribute' do
      before :each do
        @deserialized = {
          'a' => {
            'b' => {
              'c' => 'String 1',
              'd' => 'String 2'
            }
          },
          'e' => {
            'f' => 'String 3'
          }
        }
        @serialized = {
         "a"=>"{\"b\":{\"c\":\"String 1\",\"d\":\"String 2\"}}",
         "e"=>"{\"f\":\"String 3\"}",
         "__TYPE__"=>"__HASH__"
        }
      end

      describe '#deserialize' do
        it('deserializes') { it_deserializes }
      end
    end
  end

  context 'with an array' do
    before :each do
      @deserialized = ('0'..'10').to_a
      @serialized = {
       "0"=>"0",
       "1"=>"1",
       "2"=>"2",
       "3"=>"3",
       "4"=>"4",
       "5"=>"5",
       "6"=>"6",
       "7"=>"7",
       "8"=>"8",
       "9"=>"9",
       "10"=>"10",
       "__TYPE__"=>"__ARRAY__"
      }
    end
    
    describe '#serialize' do
      it('serializes') { it_serializes }
    end

    describe '#deserialize' do
      it('deserializes') { it_deserializes }
    end
  end

  context 'with an array of arrays' do
    before do
      @deserialized = [
        ['a', 'b', 'c'],
        [1, 2]
      ]
      @serialized = {
       "0"=>"[\"a\",\"b\",\"c\"]",
       "1"=>"[1,2]",
       "__TYPE__"=>"__ARRAY__"
      }
    end
    
    describe '#serialize' do
      it('serializes') { it_serializes }
    end

    describe '#deserialize' do
      it('deserializes') { it_deserializes }
    end
  end

  context 'with an array of nested hashes' do
    before do
      @deserialized = [
        {
          'a' => {
            'b' => 'String 1'
          },
          'c' => 'String 2'
        },
        {
          'd' => 'String 3'
        }
      ]
      @serialized = {
       "0"=>"{\"a\":{\"b\":\"String 1\"},\"c\":\"String 2\"}",
       "1"=>"{\"d\":\"String 3\"}",
       "__TYPE__"=>"__ARRAY__"
      }
    end
    
    describe '#serialize' do
      it('serializes') { it_serializes }
    end

    describe '#deserialize' do
      it('deserializes') { it_deserializes }
    end
  end

  context 'with a float' do
    before do
      @deserialized = 43.1
      @serialized = {
       "__VALUE__"=>"43.1",
       "__TYPE__"=>"__FLOAT__"
      }
    end
    
    describe '#serialize' do
      it('serializes') { it_serializes }
    end

    describe '#deserialize' do
      it('deserializes') { it_deserializes }
    end
  end

  context 'with an integer' do
    before do
      @deserialized = 43
      @serialized = {
       "__VALUE__"=>"43",
       "__TYPE__"=>"__INTEGER__"
      }
    end
    
    describe '#serialize' do
      it('serializes') { it_serializes }
    end

    describe '#deserialize' do
      it('deserializes') { it_deserializes }
    end
  end

  context 'with a string' do
    before do
      @deserialized = 'String 1'
      @serialized = {
       "__VALUE__"=>"String 1",
       "__TYPE__"=>"__STRING__"
      }
    end
    
    describe '#serialize' do
      it('serializes') { it_serializes }
    end

    describe '#deserialize' do
      it('deserializes') { it_deserializes }
    end
  end
end
