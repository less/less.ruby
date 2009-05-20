module Less  
  class Engine < String
    REGEXP = {
      :path     => /(?>[#.][->#.\w ]+)?(?> ?> ?)?@([-\w]+)/, # #header > .title > @var
      :selector => /[-\w #.>*:]/,                            # .cow .milk > a
      :variable => /^@([-\w]+)/,                             # @milk-white
      :property => /@[-\w]+|[-a-z]+/                         # font-size
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
      # Evaluate variables
      #
      @tree = @tree.traverse :leaf do |key, value, path, node|
        convert = lambda do |key, value, node|             # We declare this as a lambda, for re-use
          if value.is_a?(String) && value.include?('@')    # There's a var to evaluate        
            
            # Find its value
            var = value.delete(' ').match( REGEXP[:path] ).captures.join  
            var = unless var.include? '>'
              node.var( var ) || @tree.var( var )          # Try local first, then global
            else
              @tree.find :var, var.split('>')              # Try finding it in a specific namespace
            end
          
            if var
              node[ key ] = value.gsub REGEXP[:path], var  # Substitute variable with value
            else
              node.delete key                              # Discard the declaration if the variable wasn't found
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
      
      #
      # Evaluate operations (2+2)
      #
      # Units are: 1px, 1em, 1%, #111
      @tree = @tree.traverse :leaf do |key, value, path, node|
        if value.match /[-+\/*]/
          if (unit = value.scan(/(%)|\d+(px)|\d+(em)|(#)/i).flatten.compact.uniq).size <= 1
            unit = unit.join
            value = if unit == '#'
              value.gsub(/#([a-z0-9]+)/i) do
                hex = $1 * ( $1.size == 3 ? 2 : 1 )
                hex.to_i(16)
              end.delete unit
              evaluate = lambda {|v| unit + eval( v ).to_s(16) }
            else
              value.gsub(/px|em|%/, '')
              evaluate = lambda {|v| eval( v ).to_s + unit }
            end.to_s    
            next if value.match /[a-z]/i            
            node[ key ] = evaluate.call value
          else
            raise MixedUnitsError
          end
        end
      end
      
    end
    alias render compile
    
    def to_css
      self.compile.to_css
    end
    
    def hashify
    #
    # Parse the LESS structure into a hash
    #
    ###
      #   less:     color: black;
      #   hashify: "color" => "black"
      #
      hash = self.gsub(/\/\/.*\n/, '').                                                   # Comments //
                  gsub(/\/\*.*?\//m, '').                                                 # Comments /*
                  gsub(/"/, "'").                                                         # " => '
                  gsub(/("|')(.+?)(\1)/) { $1 + CGI.escape( $2 ) + $1 }.                  # Escape string values
                  gsub(/(#{REGEXP[:property]}):[ \t]*(.+?);/, '"\\1" => "\\2",').         # Declarations
                  gsub(/\}/, "},").                                                       # Closing }
                  gsub(/([ \t]*)(#{REGEXP[:selector]}+?)[ \t\n]*\{/m, '\\1"\\2" => {').   # Selectors
                  gsub(/([.#][->\w .#]+);/, '"\\1" => :mixin,')                           # Mixins
      eval "{" + hash + "}"                                                               # Return {hash}
    end
  end
end