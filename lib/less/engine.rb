module Less  
  class Engine < String
    REGEX = {
      :path     => /([#.][->#.\w ]+)?( ?> ?)?@([-\w]+)/,     # #header > .title > @var
      :selector => /[-\w #.,>*:\(\)]/,                       # .cow .milk > a
      :variable => /@([-\w]+)/,                              # @milk-white
      :property => /@[-\w]+|[-a-z]+/,                        # font-size
      :color    => /#([a-zA-Z0-9]{3,6})\b/,                  # #f0f0f0
      :number   => /\d+(?>\.\d+)?/,                          # 24.8
      :unit     => /px|em|pt|cm|mm|%/                        # em
    }
    REGEX[:numeric] = /#{REGEX[:number]}(#{REGEX[:unit]})?/
    REGEX[:operand] = /#{REGEX[:color]}|#{REGEX[:numeric]}/
    
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
        matched = if match = key.match( REGEX[:variable] )          
          node[:variables] ||= Tree.new
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
      
      # Call `evaluate` on variables, such as '@dark: @light / 2'
      @tree = @tree.traverse :branch do |path, node|
        node.vars.each do |key, value|
          evaluate key, value, path, node.vars
        end if node.vars?
      end
      
      # Call `evaluate` on css properties, such as 'font-size: @big'
      @tree = @tree.traverse :leaf do |key, value, path, node|
        evaluate key, value, path, node
      end
      
      #
      # Evaluate operations (2+2)
      #
      # Units are: 1px, 1em, 1%, #111
      @tree = @tree.traverse :leaf do |key, value, path, node| 
        node[ key ] = value.gsub /(#{REGEX[:operand]}(\s?)[-+\/*](\4))+(#{REGEX[:operand]})/ do |operation|
          if (unit = operation.scan(/#{REGEX[:numeric]}|(#)/i).flatten.compact.uniq).size <= 1
            unit = unit.join            
            operation = if unit == '#'
              evaluate = lambda do |v| 
                result = eval v
                unit + ( result.zero?? '000' : result.to_s(16) )
              end
              operation.gsub REGEX[:color] do
                hex = $1 * ( $1.size < 6 ? 6 / $1.size : 1 )
                hex.to_i(16)
              end.delete unit
            else
              evaluate = lambda {|v| eval( v ).to_s + unit }
              operation.gsub REGEX[:unit], ''
            end.to_s                
            next if operation.match /[a-z]/i
            evaluate.call operation
          else
            raise MixedUnitsError
          end
        end
      end
    end
    alias render compile
    
    #
    # Evaluate variables
    #
    def evaluate key, value, path, node               
      if value.is_a? String and value.include? '@'      # There's a var to evaluate    
        value.scan REGEX[:path] do |var|
          var = var.join.delete ' '
          var = if var.include? '>'
            @tree.find :var, var.split('>')             # Try finding it in a specific namespace
          else            
           node.var( var ) or @tree.nearest var, path   # Try local first, then nearest scope            
          end

          if var
            node[ key ] = value.gsub REGEX[:path], var   # Substitute variable with value
          else
            node.delete key                              # Discard the declaration if the variable wasn't found
          end
        end    
      end
    end
    
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
      hash = self.gsub(/\t/, ' ').                                                        # Tabs
                  gsub(/\r\n/, "\n").                                                     # m$
                  gsub(/\/\/.*/, '').                                                     # Comments //
                  gsub(/\/\*.*?\*\//m, '').                                               # Comments /*
                  gsub(/"/, "'").                                                         # " => '
                  gsub(/("|')(.+?)(\1)/) { $1 + CGI.escape( $2 ) + $1 }.                  # Escape string values
                  gsub(/(#{REGEX[:property]}):\s*(.+?)\s*(;|(?=\}))/,'"\1"=>"\2",').      # Rules
                  gsub(/\}/, "},").                                                       # Closing }
                  gsub(/( *)(#{REGEX[:selector]}+?)[ \n]*(?=\{)/m, '\1"\2"=>').           # Selectors
                  gsub(/([.#][->\w .#]+);/, '"\\1" => :mixin,')                           # Mixins
      eval "{" + hash + "}"                                                               # Return {hash}
    end
  end
end