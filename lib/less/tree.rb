module Less
  class Tree < Hash
    def initialize init = {}  
      self.replace init
    end
    
    def var k
      self[:variables] ? self[:variables][ k ] : nil
    end
    
    def vars?
      self.include? :variables
    end
    
    def vars
      self[:variables] ? self[:variables] : nil
    end
    
    #
    # Find a variable or mixin from a specific path
    #
    def find what = :var, path = []
      path.inject(self) do |branch, k|        
        if what == :var && k == path.last
          branch[:variables][ k ]
        else
          branch = branch[ k ] or raise PathError, path.join(' > ')
        end
      end
    end
    
    #
    # Find the nearest variable in the hierarchy
    #
    def nearest var, path
      values = []
      path.inject(self) do |branch, k|
        values << branch.var( var )
        branch[ k ]
      end
      values.compact.last
    end
    
    def traverse by = :leaf, path = [], &blk
    #
    # Traverse the whole tree, returning each leaf or branch (recursive)
    #
    ###
      #   Aside from the key & value, we yield the full path of the leaf,  
      #   aswell as the branch which contains it (self).
      #   Note that in :branch mode, we only return 'twigs', branches which contain leaves.
      #
      self.each do |key, value|                        # `self` is the current node, starting with the trunk
        if value.is_a? Hash and key != :variables      # If the node is a branch, we can go deeper
          path << key                                  # Add the current branch to the path
          yield path, self[ key ] if by == :branch     # The node is a branch, yield it to the block  
          self[ key ] = value.to_tree.                 # Make sure any change is saved to the main tree
                        traverse by, path, &blk        # Recurse, with the current node becoming `self`                       
          path.pop                                     # We're returning from a branch, pop the last path element
        elsif by == :leaf and key.is_a? String
          yield key, value, path, self                 # The node is a leaf, yield it to the block
        else
          next
        end
      end
      self
    end
    
    #
    # Convert the tree to css, using full paths
    #
    def to_css chain, css = []
      self.traverse :branch do |path, node|
        properties = node.inject("") do |s, (k, v)|          
          v.is_a?(String) ? (s + "#{k}: #{CGI.unescape(v)}; ") : s                # Add the property to the list
        end
        css << path * ( chain == :desc ? ' ' : ' > ') + " { " + properties + "}" unless properties.empty? # Add the rule-set to the CSS
      end
      css.join "\n"
    end
  end
end