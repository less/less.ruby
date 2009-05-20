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
    
    def find what = :var, path = []
      path.inject(self) do |branch, k|        
        if what == :var && k == path.last
          branch[:variables][ k ]
        else
          branch = branch[ k ]
        end
      end
    end
    
    def traverse by = :leaf, path = [], &blk
    #
    # Traverse the whole tree, returning each leaf or branch (recursive)
    #
    ###
      #   Aside from the key & value, 
      #   we yield the full path of the leaf, aswell as
      #   the branch which contains it (self).
      #
      self.each do |key, value|                        # `self` is the current node, starting with the trunk
        if value.is_a? Hash and key != :variables      # If the node is a branch, we can go deeper
          path << key                                  # Add the current branch to the path
          self[ key ] = value.to_tree.                 # Make sure any change is saved to the main tree
                        traverse by, path, &blk        # Recurse, with the current node becoming `self`
          if by == :branch             
            yield path, self[ key ]                    # The node is a branch, yield it to the block
            path.pop
          end
        elsif by == :leaf and key.is_a? String
          yield key, value, path, self                 # The node is a leaf, yield it to the block
          path.pop
        else
          next
        end
      end
      self
    end

    def to_css css = []
      self.traverse :branch do |path, node|
        properties = node.inject("") do |s, (k, v)|          
          v.is_a?(String) ? (s + "#{k}: #{CGI.unescape(v)}; ") : s   # Add the property to the list
        end
        css << path * ' > ' + " { " + properties + "}" # Add the rule-set to the CSS
      end
      css.join "\n"
    end
  end
end