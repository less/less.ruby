module Less  
  class Engine < String
    REGEXP = {
      :path => /([#.][->#.\w]+)?( ?> ?)?@([\w\-]+)/, # #header > .title > @var
      :selector => /[-\w #.>*_:]/,                   # .cow .milk > a
      :values => /[-\w @>\/*+#%.'"]/,                # 10px solid #fff
      :variable => /^@([\w\-]+)/                     # @milk-white
    }
    
    def initialize s
      super
      @tree = Tree.new self.hashify
    end
  
    def compile     
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
        convert = lambda( key, value, node ) do # We declare this as a lambda, for re-use
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
    end
    alias render compile
    
    def to_css
      self.compile.to_css
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
      hash = self.gsub(/([@a-z\-]+):[ \t]*(#{ REGEXP[:values] }+);/, '"\\1" => "\\2",').  # Properties
                  gsub(/\}/, "},").                                                       # Closing }
                  gsub(/([ \t]*)(#{ REGEXP[:selector] }+?)[ \t\n]*\{/m, '\\1"\\2" => {'). # Selectors
                  gsub(/([.#][->\w .#]+);/, '"\\1" => :mixin,').                          # Mixins
                  gsub("\n\n", "\n").                                                     # New-lines
                  gsub(/\/\/.*\n/, '')                                                    # Comments
      eval "{" + hash + "}"                                                               # Return {hash}
    end
  end
end