module Less
  class Engine < String
    REGEXP = {
      :path => /([#.][->#.\w]+)?( ?> ?)?@([\w\-]+)/, # #header > .title > @var
      :selector => /[-\w #.>*_:]/,                   # .cow .milk > a
      :values => /[-\w @>\/*+#%.'"]/,                # 10px solid #fff
      :variable => /^@([\w\-]+)/                     # @milk-white
    }
    
    def initialize s
      @tree = nil
      super
    end
  
    def compile
      @tree = Tree.new self.hashify
      
      #
      # Parse the variables and mixins
      #
      # We use symbolic keys, such as :mixins, to store LESS-only data,
      # each branch has its own :mixins => [], and :variables => {}
      # Once a declaration has been recognised as LESS-specific, it is copied 
      # in the appropriate data structure in that branch. The declaration itself
      # can then be deleted.
      #
      @tree = @tree.traverse do |key, value, path, node|
        matched = if match = key.match( REGEXP[:variable] )
          node[:variables] ||= {}
          node[:variables][ match.captures.first ] = value
        elsif value == :mixin
          node[:mixins] ||= []
          node[:mixins] << key
        end
        node.delete key if matched # Delete the property if it's LESS-specific
      end
      
      #
      # Evaluate the variables and mixins
      #
      @tree = @tree.traverse do |key, value, path, node|
        convert = ->( key, value, node ) do # We declare this as a lambda, for re-use
          if value.is_a?(String) && value.include?('@') # There's a var to evaluate        
            
            # Find its value
            var = value.delete(' ').match( REGEXP[:path] ).captures.join  
            var = unless var.include? '>'
              node.var( var ) || @tree.var( var ) # Try local first, then global
            else
              @tree.find var.split('>')           # Try finding it in a specific namespace
            end
          
            if var
              node[ key ] = value.gsub REGEXP[:path], var # substitute variable with value
            else
              node.delete key # discard the declaration if the variable wasn't found
            end
          end
        end
        
        # Call `convert` on css properties, such as 'font-size: @big'
        convert.call key, value, node
        
        # Call `convert` on variables, such as '@dark: @light / 2'
        if node.vars? 
          node.vars.each do |key, value|
            convert.call key, value, node
          end
        end
      end
      
      @tree.to_css
    end
    alias render compile
    
    def to_css
      @tree.to_css
    end
    
    def evaluate s
      eval( s )
    end
    
    def hashify
    #
    # Parse the LESS structure into a hash
    #
    ###
      #   less:     color: black;
      #   hashify: "color" => "black"
      #
      hsh = self.gsub(/([@a-z\-]+):[ \t]*(#{ REGEXP[:values] }+);/, '"\\1" => "\\2",')  # Properties
                .gsub(/\}/, "},")                                                       # Closing }
                .gsub(/([ \t]*)(#{ REGEXP[:selector] }+?)[ \t\n]*\{/m, '\\1"\\2" => {') # Selectors
                .gsub(/([.#][->\w .#]+);/, '"\\1" => :mixin,')                          # Mixins
                .gsub("\n\n", "\n")                                                     # New-lines
                .gsub(/\/\/.*\n/, '')                                                   # Comments
      eval "{" + hsh + "}"                                                              # Return {hash}
    end
    
  end
  
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
    
    def find path
    #
    # Find a variable in the tree, given a path such as ["#header", ".title", "var"]
    #
      if path.size == 1                                # We arrived at the end of the path (the variable)
        self.var path.join                             # Return the value of the variable
      else
        self.each do |key, value|                   
          if path.first == key && value.is_a?(Hash)    # Have we found our selector?
            value.to_tree.find path[1..-1]             # Convert the hash to a Tree and recurse,
          end                                          # dropping the first element of the path
        end
        nil                                            # Nothing was found, return nil
      end
    end
    
    def traverse path = [], &blk
    #
    # Traverse the whole tree, returning each leaf (recursive)
    #
    ###
      #   Aside from the key & value, 
      #   we yield the full path of the leaf, aswell as
      #   the branch which contains it (self).
      #
      self.each do |key, value|                        # `self` is the current node, starting with the trunk
        if value.is_a?(Hash) && key != :variables      # If the node is a branch, we can go deeper
          path << key                                  # Add the current branch to the path
          self[ key ] = value.to_tree.                 # Make sure any change is saved to the main tree
                        traverse path, &blk            # Recurse, with the current node becoming `self`
        elsif key == :mixins                       
          next
        elsif key == :variables
          next
        else
          yield key, value, path, self                 # The node is a leaf, so yield it to the block
        end
      end
      path.pop                                         # We're coming out of a branch, so drop the last element
      self
    end
    
    def to_css css = []
      self.traverse do |key, value, path, node|
        properties = node.inject("") do |s, (k, v)|          
          v.is_a?(String) ? (s + "#{k}: #{v}; ") : s   # Add the property to the list
        end
        css << path * ' > ' + " { " + properties + "}" # Add the rule-set to the CSS
      end
      css.join "\n"
    end
  end
end

class Hash
  # Convert a hash into a Tree  
  def to_tree
    Less::Tree.new self
  end
end