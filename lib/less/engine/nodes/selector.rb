module Less
  module Node
    class Selector < ::String
      Selectors = {
        :Descendant => '',
        :Child      => '>',
        :Adjacent   => '+',
        :Pseudo     => ':',
        :Sibling    => '~'
      }
  
      def initialize
        super Selectors[ self.class.to_s.split('::').last.to_sym ]
      end
  
      def self.[] key
        Node.const_get(Selectors.find {|k, v| v == key }.first)
      end
    end

    class Descendant < Selector
      def to_css; " " end
    end

    class Child < Selector
      def to_css; " #{self} " end
    end

    class Adjacent < Selector
      def to_css; " #{self} " end
    end

    class Pseudo < Selector
      def to_css; self end
    end
  end
end