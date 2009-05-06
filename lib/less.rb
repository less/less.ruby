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
      
      puts
      puts  
      
      # Parsing
      # 'node' is the branch currently being traversed
      @tree = @tree.traverse do |key, value, node|
        matched = -> do 
          if match = key.match( REGEXP[:variable] )
            node[:variables] ||= {}
            node[:variables][ match.captures.first ] = value
          elsif value == :mixin
            node[:mixins] ||= []
            node[:mixins] << key
          end
        end.call
        node.delete key if matched
      end
            
      puts 
      puts
      
      # Converting variables
      @tree = @tree.traverse do |key, value, node|
        if value.is_a?( String ) && value.include?('@') #var        
          # find value for var
          variable = value.delete(' ').match( REGEXP[:path] ).captures.join
          
          variable = unless variable.include?('>')
            node.var( variable ) || @tree.var( variable ) # try local, then global
          else
            @tree.find( variable.split('>') )
          end
          
          if variable
            node[ key ] = value.gsub( REGEXP[:path], variable ) # substitute variable
          else
            node.delete key
          end
        end
      end
      
      puts 
      @tree.to_s
    end
    alias render compile
    
    def evaluate s
      eval( s )
    end
    
    def hashify
    #
    # Parse the LESS structure into a hash
    #
    ###
      # ex:
      #   less:     color: black;
      #   hashify: "color" => "black"
      #
      hsh = self.gsub(/([@a-z\-]+):[ \t]*(#{ REGEXP[:values] }+);/, '"\\1" => "\\2",')  # Properties
                .gsub(/\}/, "},")                                                       # Closing }
                .gsub(/([ \t]*)(#{ REGEXP[:selector] }+?)[ \t\n]*\{/m, '\\1"\\2" => {') # Selectors
                .gsub(/([.#][->\w .#]+);/, '"\\1" => :mixin,')                          # Mixins
                .gsub("\n\n", "\n")                                                     # New-lines
                .gsub(/\/\/.*\n/, '')                                                   # Comments
      eval("{" + hsh + "}")                                                             # Return {hash}
    end
  end
  
  class Tree < Hash
    def initialize init = {}  
      self.replace init
    end
    
    def var k
      self[:variables] ? self[:variables][ k ] : nil
    end
    
    def find path
    #
    # Find a variable in the tree, given a path such as ["#header", ".title", "var"]
    #
      if path.size == 1                # We arrived at the end of the path (the variable)
        self.var path.join             # Return the value of the variable
      else
        self.each do |key, value|                   
          if path.first == key && value.is_a?(Hash) # Have we found our selector?
            value.to_tree.find path[1..-1]          # Convert the hash to a Tree and recurse,
          end                                       # dropping the first element of the path
        end
        nil                                         # Nothing was found, return nil
      end
    end
    
    def traverse &blk
    #
    # Traverse the whole tree, returning each leaf (recursive)
    #
      self.each do |key, value|         # `self` is the current node, starting with the trunk
        if value.is_a? Hash             # If the node is a branch, we can go deeper
          self[ key ] = 
            value.to_tree.traverse &blk # Recurse, with the current node becoming `self`
        elsif key == :mixins            # Mixins
          next
        else
          yield key, value, self        # The node is a leaf, yeild it to the block, with the branch (self)
        end
      end
      self
    end
    
    def to_css
      self.traverse do |key, value, node|
      
      
      end
    end
  end
end

class Hash
  # Convert a hash into a Tree  
  def to_tree
    Less::Tree.new self
  end
end