module Less
  #
  # Node::Entity
  #
  # TODO: Use delegate class -> @rules
  #
  # Class hierarchy
  #
  # - Entity
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
    module Entity
      attr_accessor :parent
    
      def initialize value, parent = nil
        super value
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
    
    class Anonymous < ::String
      include Entity
    end
    
    class Operator < ::String
      def to_ruby
        self
      end
    end
  end
end