module Less
  module Node
    #
    # Element
    #
    # div {...}
    #
    # TODO: Look into making @rules its own hash-like class
    # TODO: Look into whether selector should be child by default
    #
    class Element
      include Enumerable
      include Entity

      attr_accessor :rules, :selector, :file,
                    :set,   :imported, :name

      def initialize name = "", selector = ''
        @name = name
        @set, @imported = [], []
        @rules = [] # Holds all the nodes under this element's hierarchy
        @selector = Selector[selector.strip].new  # descendant | child | adjacent
      end

      def class?;     name =~ /^\./ end
      def id?;        name =~ /^#/  end
      def universal?; name == '*'   end

      def tag?
        not id? || class? || universal?
      end

      # Top-most node?
      def root?
        parent.nil?
      end

      def empty?
        @rules.empty?
      end

      def leaf?
        elements.empty?
      end

      # Group similar rulesets together
      # This is horrible, horrible code,
      # but it'll have to do until I find
      # a proper way to do it.
      def group
        elements = self.elements.reject {|e| e.is_a?(Mixin::Def) }
        return self unless elements.size > 1

        stack, result, matched = elements.dup, [], false

        elements.each do
          e = stack.first
          result << e unless matched

          matched = stack[1..-1].each do |ee|
            if e.equiv? ee and e.elements.size == 0
              self[e].set << ee
              stack.shift
            else
              stack.shift
              break false
            end
          end if stack.size > 1
        end
        @rules -= (elements - result)
        self
      end

      #
      # Accessors for the different nodes in @rules
      #
      def identifiers; @rules.select {|r| r.kind_of?     Property   } end
      def properties;  @rules.select {|r| r.instance_of? Property   } end
      def variables;   @rules.select {|r| r.instance_of? Variable   } end
      def elements;    @rules.select {|r| r.kind_of?     Element    } end
      def mixins;      @rules.select {|r| r.instance_of? Mixin::Call} end
      def parameters;  []                                             end

      # Select a child element
      # TODO: Implement full selector syntax & merge with descend()
      def [] key
        case key
          when Entity
            @rules.find {|i| i.eql? key }
          when String
            @rules.find {|i| i.to_s == key }
          else raise ArgumentError
        end
      end

      def == other
        name == other.name
      end

      def eql? other
        super and self.equiv? other
      end

      def equiv? other
        rules.size == other.rules.size and
        !rules.zip(other.rules).map do |a, b|
          a.to_css == b.to_css
        end.include?(false)
      end

      # Same as above, except with a specific selector
      # TODO: clean this up or implement it differently
      def descend selector, element
        if selector.is_a? Child
          s = self[element.name].selector
          self[element.name] if s.is_a? Child or s.is_a? Descendant
        elsif selector.is_a? Descendant
          self[element.name]
        else
          self[element.name] if self[element.name].selector.class == selector.class
        end
      end

      #
      # Add an arbitrary node to this element
      #
      def << obj
        if obj.kind_of? Node::Entity
          obj.parent = self
          @rules << obj
        else
          raise ArgumentError, "argument can't be a #{obj.class}"
        end
      end

      def last;  elements.last  end
      def first; elements.first end
      def to_s; root?? '*' : name end

      #
      # Entry point for the css conversion
      #
      def to_css path = [], env = nil
        path << @selector.to_css << name unless root?

#       puts "to_css env: #{env ? env.variables : "nil"}"
        content = @rules.select do |r|
          r.is_a?(Mixin::Call) || r.instance_of?(Property)
        end.map do |i|
          ' ' * 2 + i.to_css(env)
        end.compact.reject(&:empty?) * "\n"

        content = content.include?("\n") ? "\n#{content}\n" : " #{content.strip} "

        ruleset = if is_a?(Mixin::Def)
          content.strip
        else
          !content.strip.empty??
            "#{[path.reject(&:empty?).join.strip,
            *@set.map(&:name)].uniq * ', '} {#{content}}\n" : ""
        end

        ruleset + elements.reject {|e| e.is_a?(Mixin::Def) }.map do |i|
          i.to_css(path, env)
        end.reject(&:empty?).join

      ensure
        2.times { path.pop }
      end

      #
      # Find the nearest node in the hierarchy or raise a NameError
      #
      def nearest ident, type = nil
        ary = type || ident =~ /^[.#]/ ? :elements : :variables
        path.map do |node|
          node.send(ary).find {|i| i.to_s == ident }
        end.compact.first.tap do |result|
          raise VariableNameError, ("#{ident} in #{self.to_s}") if result.nil? && type != :mixin
        end
      end

      #
      # Traverse the whole tree, returning each leaf (recursive)
      #
      def each path = [], &blk
        elements.each do |element|
          path << element
          yield element, path if element.leaf?
          element.each path, &blk
          path.pop
        end
        self
      end

      def inspect depth = 0
        indent = lambda {|i| '.  ' * i }
        put    = lambda {|ary| ary.map {|i| indent[ depth + 1 ] + i.inspect } * "\n"}

        (root?? "\n" : "") + [
          indent[ depth ] + self.to_s,
          put[ variables ],
          put[ properties ],
          put[ mixins ],
          elements.map {|i| i.inspect( depth + 1 ) } * "\n"
        ].reject(&:empty?).join("\n") + "\n" + indent[ depth ]
      end
    end

    module Mixin
      class Call
        include Entity

        def initialize mixin, params, parent
#          puts "Initializing a Mixin::Call #{mixin}"
          @mixin = mixin
          self.parent = parent
          @params = params.each do |e|
            e.parent = self.parent
          end
        end

        def to_css env = nil
#          puts "\n\n"
#          puts "call .#{@mixin.name} #{@params} <#{@params.class}>"
          @mixin.call(@params.map {|e| e.evaluate(env) })
        end

        def inspect
          "#{@mixin.to_s} (#{@params})"
        end
      end

      class Def < Element
        attr_accessor :params

        def initialize name, params = []
          super name
          @params = params.each do |param|
            param.parent = self
          end
        end

        def call args = []
          if e = @rules.find {|r| r.is_a? Element }
            raise CompileError, "#{e} in #{self.inspect}: can't nest selectors inside a dynamic mixin."
          end

          env = Element.new

          @params.zip(args).each do |param, val|
            env << (val ? Variable.new(param.to_s, Expression.new([val])) : param)
          end

          #b ? Node::Variable.new(a.to_s, Expression.new([b])) : a

#          puts "#{self.inspect}"
#          puts "env: #{env.variables}      root?: #{env.root?}"
#          puts "\nTOCSS"
          to_css([], env)
        end

        def variables
          params + super
        end

        def to_s
          '.' + name
        end

        def inspect
          ".#{name}()"
        end

        def to_css path, env
          super(path, env)
        end
      end
    end
  end
end
