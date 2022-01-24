module Isomorfeus
  module Props
    class ValidateHashProxy
      def initialize
        @validation_hash = { required: true, validate: {} }
      end

      def is
        self
      end
      alias_method :and, :is
      alias_method :has, :is
      alias_method :with, :is

      def allow_nil
        @validation_hash[:allow_nil] = true
        self
      end

      def cast
        @validation_hash[:cast] = true
        self
      end

      def default(v)
        @validation_hash[:required] = false
        @validation_hash[:default] = v
        self
      end

      def ensure(v = nil, &block)
        if block_given?
          @validation_hash[:ensure] = block
        else
          @validation_hash[:ensure] = v
        end
        self
      end

      def exact_class(t_class)
        @validation_hash[:class] = t_class
        self
      end

      def greater_than(v)
        @validation_hash[:validate][:gt] = v
        self
      end
      alias_method :gt, :greater_than

      def is_a(i_class)
        @validation_hash[:is_a] = i_class
        self
      end

      def keys(*keys)
        @validation_hash[:validate][:hash_keys] = keys
        self
      end

      def size(l)
        @validation_hash[:validate][:size] = v
        self
      end
      alias_method :length, :size

      def less_than(v)
        @validation_hash[:validate][:lt] = v
        self
      end
      alias_method :lt, :less_than

      def matches(regexp)
        @validation_hash[:validate][:matches] = regexp
        self
      end

      def max(l)
        @validation_hash[:validate][:max] = l
        self
      end

      def max_size(l)
        @validation_hash[:validate][:max_size] = l
        self
      end
      alias_method :max_length, :max_size

      def min(l)
        @validation_hash[:validate][:min] = l
        self
      end

      def min_size(l)
        @validation_hash[:validate][:min_size] = l
        self
      end
      alias_method :min_length, :min_size

      def negative
        @validation_hash[:validate][:direction] = :negative
        self
      end

      def optional
        @validation_hash[:required] = false
        self
      end

      def positive
        @validation_hash[:validate][:direction] = :positive
        self
      end

      def required
        @validation_hash[:required] = true
        self
      end

      def test(&block)
        @validation_hash[:validate][:test] = block
        self
      end
      alias_method :condition, :test
      alias_method :check, :test

      def validate_block(&block)
        @validation_hash[:validate][:validate_block] = block
        self
      end

      # types

      def Array
        @validation_hash[:class] = Array
        self
      end

      def Boolean
        @validation_hash[:type] = :boolean
        self
      end

      def Enumerable
        @validation_hash[:is_a] = Enumerable
        self
      end

      def Float
        @validation_hash[:class] = Float
        self
      end

      def Hash
        @validation_hash[:class] = Hash
        self
      end

      def Integer
        @validation_hash[:class] = Integer
        self
      end

      def String
        @validation_hash[:class] = String
        self
      end

      # sub types

      def Email
        @validation_hash[:type] = :email
        self
      end

      def Url
        @validation_hash[:type] = :uri
        self
      end

      def to_h
        @validation_hash
      end
    end
  end
end
