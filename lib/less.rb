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
      @tree = @tree.traverse :leaf do |key, value, path, node|
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
      # Evaluate mixins
      #
      @tree = @tree.traverse :branch do |path, node|
        if node.include? :mixins
          node[:mixins].each do |m|
            @tree.find( :mixin, m.delete(' ').split('>') ).each {|k, v| node[ k ] = v }
          end
        end
      end
      
      #
      # Evaluate the variables
      #
      @tree = @tree.traverse :leaf do |key, value, path, node|
        convert = ->( key, value, node ) do # We declare this as a lambda, for re-use
          if value.is_a?(String) && value.include?('@') # There's a var to evaluate        
            
            # Find its value
            var = value.delete(' ').match( REGEXP[:path] ).captures.join  
            var = unless var.include? '>'
              node.var( var ) || @tree.var( var ) # Try local first, then global
            else
              @tree.find :var, var.split('>')           # Try finding it in a specific namespace
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
      hash = self.gsub(/([@a-z\-]+):[ \t]*(#{ REGEXP[:values] }+);/, '"\\1" => "\\2",')  # Properties
                 .gsub(/\}/, "},")                                                       # Closing }
                 .gsub(/([ \t]*)(#{ REGEXP[:selector] }+?)[ \t\n]*\{/m, '\\1"\\2" => {') # Selectors
                 .gsub(/([.#][->\w .#]+);/, '"\\1" => :mixin,')                          # Mixins
                 .gsub("\n\n", "\n")                                                     # New-lines
                 .gsub(/\/\/.*\n/, '')                                                   # Comments
      eval "{" + hash + "}"                                                              # Return {hash}
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
    
    def find what = :var, path
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