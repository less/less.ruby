module Less
  #
  # Node::Base
  #
  # TODO: Use delegate class -> @rules
  #
  # Class hierarchy
  #
  # - Base
  #   - Element
  #   - Entity
  #     - Function
  #     - Keyword
  #     - Literal
  #       - Color
  #       - Number
  #       - String
  #       - FontFamily
  #   - Property
  #     - Variable
  #
  module Node
    class Base < ::String
      attr_accessor :parent
    
      def initialize s, parent = nil
        super s.to_s
        @parent = parent
      end

      def path node = self
        path = []
        while node do
          path << node
          node = node.parent
        end
        path
      end
    
      def root
        path.last
      end
    
      def inspect;  to_s  end
      def to_css;   to_s  end
      def to_s;     super end
    end
  
    class Operator < Base
      def to_ruby
        self
      end
    end
  
    Entity = Class.new(Base)
  end
end