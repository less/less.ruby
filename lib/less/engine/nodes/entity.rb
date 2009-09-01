module Less
  #
  # Node::Entity
  #   
  #   Everything in the tree is an Entity
  #
  # Mixin/Class hierarchy
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
  # TODO: Use delegate class -> @rules
  #
  module Node
    module Entity
      attr_accessor :parent
    
      def initialize value, parent = nil
        super value
        @parent = parent
      end
      
      #
      # Returns the path from any given node, to the root
      #
      #   ex: ['color', 'p', '#header', 'body', '*']
      #
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
    
    #
    # An anonymous node, for all the 'other' stuff
    # which doesn't need any specific functionality.
    #
    class Anonymous < String
      include Entity
    end
    
    #
    # + * - /
    #
    class Operator < String
      def to_ruby
        self
      end
    end
    
    class Paren < String
      def to_ruby
        self
      end
    end
  end
end