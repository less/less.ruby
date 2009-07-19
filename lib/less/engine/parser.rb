module Less
  include Treetop::Runtime

  def root
    @root || :primary
  end

  def _nt_primary
    start_index = index
    if node_cache[:primary].has_key?(index)
      cached = node_cache[:primary][index]
      @index = cached.interval.end if cached
      return cached
    end

    i0 = index
    s1, i1 = [], index
    loop do
      i2 = index
      r3 = _nt_declaration
      if r3
        r2 = r3
      else
        r4 = _nt_ruleset
        if r4
          r2 = r4
        else
          r5 = _nt_import
          if r5
            r2 = r5
          else
            r6 = _nt_comment
            if r6
              r2 = r6
            else
              @index = i2
              r2 = nil
            end
          end
        end
      end
      if r2
        s1 << r2
      else
        break
      end
    end
    if s1.empty?
      @index = i1
      r1 = nil
    else
      r1 = instantiate_node(Builder,input, i1...index, s1)
    end
    if r1
      r0 = r1
    else
      s7, i7 = [], index
      loop do
        r8 = _nt_declaration
        if r8
          s7 << r8
        else
          break
        end
      end
      r7 = instantiate_node(Builder,input, i7...index, s7)
      if r7
        r0 = r7
      else
        s9, i9 = [], index
        loop do
          r10 = _nt_import
          if r10
            s9 << r10
          else
            break
          end
        end
        r9 = instantiate_node(Builder,input, i9...index, s9)
        if r9
          r0 = r9
        else
          s11, i11 = [], index
          loop do
            r12 = _nt_comment
            if r12
              s11 << r12
            else
              break
            end
          end
          r11 = instantiate_node(SyntaxNode,input, i11...index, s11)
          if r11
            r0 = r11
          else
            @index = i0
            r0 = nil
          end
        end
      end
    end

    node_cache[:primary][start_index] = r0

    r0
  end

  module Comment0
  end

  module Comment1
    def ws
      elements[0]
    end

    def ws
      elements[4]
    end
  end

  module Comment2
  end

  module Comment3
    def ws
      elements[0]
    end

    def ws
      elements[4]
    end
  end

  def _nt_comment
    start_index = index
    if node_cache[:comment].has_key?(index)
      cached = node_cache[:comment][index]
      @index = cached.interval.end if cached
      return cached
    end

    i0 = index
    i1, s1 = index, []
    r2 = _nt_ws
    s1 << r2
    if r2
      if has_terminal?('/*', false, index)
        r3 = instantiate_node(SyntaxNode,input, index...(index + 2))
        @index += 2
      else
        terminal_parse_failure('/*')
        r3 = nil
      end
      s1 << r3
      if r3
        s4, i4 = [], index
        loop do
          i5, s5 = index, []
          i6 = index
          if has_terminal?('*/', false, index)
            r7 = instantiate_node(SyntaxNode,input, index...(index + 2))
            @index += 2
          else
            terminal_parse_failure('*/')
            r7 = nil
          end
          if r7
            r6 = nil
          else
            @index = i6
            r6 = instantiate_node(SyntaxNode,input, index...index)
          end
          s5 << r6
          if r6
            if index < input_length
              r8 = instantiate_node(SyntaxNode,input, index...(index + 1))
              @index += 1
            else
              terminal_parse_failure("any character")
              r8 = nil
            end
            s5 << r8
          end
          if s5.last
            r5 = instantiate_node(SyntaxNode,input, i5...index, s5)
            r5.extend(Comment0)
          else
            @index = i5
            r5 = nil
          end
          if r5
            s4 << r5
          else
            break
          end
        end
        r4 = instantiate_node(SyntaxNode,input, i4...index, s4)
        s1 << r4
        if r4
          if has_terminal?('*/', false, index)
            r9 = instantiate_node(SyntaxNode,input, index...(index + 2))
            @index += 2
          else
            terminal_parse_failure('*/')
            r9 = nil
          end
          s1 << r9
          if r9
            r10 = _nt_ws
            s1 << r10
          end
        end
      end
    end
    if s1.last
      r1 = instantiate_node(SyntaxNode,input, i1...index, s1)
      r1.extend(Comment1)
    else
      @index = i1
      r1 = nil
    end
    if r1
      r0 = r1
    else
      i11, s11 = index, []
      r12 = _nt_ws
      s11 << r12
      if r12
        if has_terminal?('//', false, index)
          r13 = instantiate_node(SyntaxNode,input, index...(index + 2))
          @index += 2
        else
          terminal_parse_failure('//')
          r13 = nil
        end
        s11 << r13
        if r13
          s14, i14 = [], index
          loop do
            i15, s15 = index, []
            i16 = index
            if has_terminal?("\n", false, index)
              r17 = instantiate_node(SyntaxNode,input, index...(index + 1))
              @index += 1
            else
              terminal_parse_failure("\n")
              r17 = nil
            end
            if r17
              r16 = nil
            else
              @index = i16
              r16 = instantiate_node(SyntaxNode,input, index...index)
            end
            s15 << r16
            if r16
              if index < input_length
                r18 = instantiate_node(SyntaxNode,input, index...(index + 1))
                @index += 1
              else
                terminal_parse_failure("any character")
                r18 = nil
              end
              s15 << r18
            end
            if s15.last
              r15 = instantiate_node(SyntaxNode,input, i15...index, s15)
              r15.extend(Comment2)
            else
              @index = i15
              r15 = nil
            end
            if r15
              s14 << r15
            else
              break
            end
          end
          r14 = instantiate_node(SyntaxNode,input, i14...index, s14)
          s11 << r14
          if r14
            if has_terminal?("\n", false, index)
              r19 = instantiate_node(SyntaxNode,input, index...(index + 1))
              @index += 1
            else
              terminal_parse_failure("\n")
              r19 = nil
            end
            s11 << r19
            if r19
              r20 = _nt_ws
              s11 << r20
            end
          end
        end
      end
      if s11.last
        r11 = instantiate_node(SyntaxNode,input, i11...index, s11)
        r11.extend(Comment3)
      else
        @index = i11
        r11 = nil
      end
      if r11
        r0 = r11
      else
        @index = i0
        r0 = nil
      end
    end

    node_cache[:comment][start_index] = r0

    r0
  end

  module Ruleset0
    def selectors
      elements[0]
    end

    def ws
      elements[2]
    end

    def primary
      elements[3]
    end

    def ws
      elements[4]
    end

    def ws
      elements[6]
    end
  end

  module Ruleset1
    def build env
      # Build the ruleset for each selector
      selectors.build(env, :tree).each do |sel|
        primary.build sel
      end
    end
  end

  module Ruleset2
    def ws
      elements[0]
    end

    def selectors
      elements[1]
    end

    def ws
      elements[3]
    end
  end

  module Ruleset3
    def build env        
      selectors.build(env, :path).each do |path|
        rules = path.inject(env.root) do |current, node|
          current.descend(node.selector, node) or raise MixinNameError, path.join
        end.rules
        env.rules += rules
      end
    end
  end

  def _nt_ruleset
    start_index = index
    if node_cache[:ruleset].has_key?(index)
      cached = node_cache[:ruleset][index]
      @index = cached.interval.end if cached
      return cached
    end

    i0 = index
    i1, s1 = index, []
    r2 = _nt_selectors
    s1 << r2
    if r2
      if has_terminal?("{", false, index)
        r3 = instantiate_node(SyntaxNode,input, index...(index + 1))
        @index += 1
      else
        terminal_parse_failure("{")
        r3 = nil
      end
      s1 << r3
      if r3
        r4 = _nt_ws
        s1 << r4
        if r4
          r5 = _nt_primary
          s1 << r5
          if r5
            r6 = _nt_ws
            s1 << r6
            if r6
              if has_terminal?("}", false, index)
                r7 = instantiate_node(SyntaxNode,input, index...(index + 1))
                @index += 1
              else
                terminal_parse_failure("}")
                r7 = nil
              end
              s1 << r7
              if r7
                r8 = _nt_ws
                s1 << r8
              end
            end
          end
        end
      end
    end
    if s1.last
      r1 = instantiate_node(SyntaxNode,input, i1...index, s1)
      r1.extend(Ruleset0)
      r1.extend(Ruleset1)
    else
      @index = i1
      r1 = nil
    end
    if r1
      r0 = r1
    else
      i9, s9 = index, []
      r10 = _nt_ws
      s9 << r10
      if r10
        r11 = _nt_selectors
        s9 << r11
        if r11
          if has_terminal?(';', false, index)
            r12 = instantiate_node(SyntaxNode,input, index...(index + 1))
            @index += 1
          else
            terminal_parse_failure(';')
            r12 = nil
          end
          s9 << r12
          if r12
            r13 = _nt_ws
            s9 << r13
          end
        end
      end
      if s9.last
        r9 = instantiate_node(SyntaxNode,input, i9...index, s9)
        r9.extend(Ruleset2)
        r9.extend(Ruleset3)
      else
        @index = i9
        r9 = nil
      end
      if r9
        r0 = r9
      else
        @index = i0
        r0 = nil
      end
    end

    node_cache[:ruleset][start_index] = r0

    r0
  end

  module Import0
    def S
      elements[1]
    end

    def url
      elements[2]
    end

    def s
      elements[4]
    end

    def ws
      elements[6]
    end
  end

  module Import1
    def build env
      path = File.join(env.root.file, url.value)
      path += '.less' unless path =~ /\.less$/
      if File.exist? path
        imported = Less::Engine.new(File.new path).to_tree
        env.rules += imported.rules
      else
        raise ImportError, path
      end
    end
  end

  def _nt_import
    start_index = index
    if node_cache[:import].has_key?(index)
      cached = node_cache[:import][index]
      @index = cached.interval.end if cached
      return cached
    end

    i0, s0 = index, []
    if has_terminal?("@import", false, index)
      r1 = instantiate_node(SyntaxNode,input, index...(index + 7))
      @index += 7
    else
      terminal_parse_failure("@import")
      r1 = nil
    end
    s0 << r1
    if r1
      r2 = _nt_S
      s0 << r2
      if r2
        i3 = index
        r4 = _nt_string
        if r4
          r3 = r4
        else
          r5 = _nt_url
          if r5
            r3 = r5
          else
            @index = i3
            r3 = nil
          end
        end
        s0 << r3
        if r3
          r7 = _nt_medias
          if r7
            r6 = r7
          else
            r6 = instantiate_node(SyntaxNode,input, index...index)
          end
          s0 << r6
          if r6
            r8 = _nt_s
            s0 << r8
            if r8
              if has_terminal?(';', false, index)
                r9 = instantiate_node(SyntaxNode,input, index...(index + 1))
                @index += 1
              else
                terminal_parse_failure(';')
                r9 = nil
              end
              s0 << r9
              if r9
                r10 = _nt_ws
                s0 << r10
              end
            end
          end
        end
      end
    end
    if s0.last
      r0 = instantiate_node(SyntaxNode,input, i0...index, s0)
      r0.extend(Import0)
      r0.extend(Import1)
    else
      @index = i0
      r0 = nil
    end

    node_cache[:import][start_index] = r0

    r0
  end

  module Url0
    def path
      elements[1]
    end

  end

  module Url1
    def build env = nil
      Node::String.new(CGI.unescape path.text_value)
    end
    
    def value
      build
    end
  end

  def _nt_url
    start_index = index
    if node_cache[:url].has_key?(index)
      cached = node_cache[:url][index]
      @index = cached.interval.end if cached
      return cached
    end

    i0, s0 = index, []
    if has_terminal?('url(', false, index)
      r1 = instantiate_node(SyntaxNode,input, index...(index + 4))
      @index += 4
    else
      terminal_parse_failure('url(')
      r1 = nil
    end
    s0 << r1
    if r1
      i2 = index
      r3 = _nt_string
      if r3
        r2 = r3
      else
        s4, i4 = [], index
        loop do
          if has_terminal?('[-a-zA-Z0-9_%$/.&=:;#+?]', true, index)
            r5 = true
            @index += 1
          else
            r5 = nil
          end
          if r5
            s4 << r5
          else
            break
          end
        end
        if s4.empty?
          @index = i4
          r4 = nil
        else
          r4 = instantiate_node(SyntaxNode,input, i4...index, s4)
        end
        if r4
          r2 = r4
        else
          @index = i2
          r2 = nil
        end
      end
      s0 << r2
      if r2
        if has_terminal?(')', false, index)
          r6 = instantiate_node(SyntaxNode,input, index...(index + 1))
          @index += 1
        else
          terminal_parse_failure(')')
          r6 = nil
        end
        s0 << r6
      end
    end
    if s0.last
      r0 = instantiate_node(SyntaxNode,input, i0...index, s0)
      r0.extend(Url0)
      r0.extend(Url1)
    else
      @index = i0
      r0 = nil
    end

    node_cache[:url][start_index] = r0

    r0
  end

  module Medias0
    def s
      elements[0]
    end

    def s
      elements[2]
    end

  end

  module Medias1
  end

  def _nt_medias
    start_index = index
    if node_cache[:medias].has_key?(index)
      cached = node_cache[:medias][index]
      @index = cached.interval.end if cached
      return cached
    end

    i0, s0 = index, []
    s1, i1 = [], index
    loop do
      if has_terminal?('[-a-z]', true, index)
        r2 = true
        @index += 1
      else
        r2 = nil
      end
      if r2
        s1 << r2
      else
        break
      end
    end
    if s1.empty?
      @index = i1
      r1 = nil
    else
      r1 = instantiate_node(SyntaxNode,input, i1...index, s1)
    end
    s0 << r1
    if r1
      s3, i3 = [], index
      loop do
        i4, s4 = index, []
        r5 = _nt_s
        s4 << r5
        if r5
          if has_terminal?(',', false, index)
            r6 = instantiate_node(SyntaxNode,input, index...(index + 1))
            @index += 1
          else
            terminal_parse_failure(',')
            r6 = nil
          end
          s4 << r6
          if r6
            r7 = _nt_s
            s4 << r7
            if r7
              s8, i8 = [], index
              loop do
                if has_terminal?('[a-z]', true, index)
                  r9 = true
                  @index += 1
                else
                  r9 = nil
                end
                if r9
                  s8 << r9
                else
                  break
                end
              end
              if s8.empty?
                @index = i8
                r8 = nil
              else
                r8 = instantiate_node(SyntaxNode,input, i8...index, s8)
              end
              s4 << r8
            end
          end
        end
        if s4.last
          r4 = instantiate_node(SyntaxNode,input, i4...index, s4)
          r4.extend(Medias0)
        else
          @index = i4
          r4 = nil
        end
        if r4
          s3 << r4
        else
          break
        end
      end
      r3 = instantiate_node(SyntaxNode,input, i3...index, s3)
      s0 << r3
    end
    if s0.last
      r0 = instantiate_node(SyntaxNode,input, i0...index, s0)
      r0.extend(Medias1)
    else
      @index = i0
      r0 = nil
    end

    node_cache[:medias][start_index] = r0

    r0
  end

  module Selectors0
    def s
      elements[0]
    end

    def ws
      elements[2]
    end

    def selector
      elements[3]
    end
  end

  module Selectors1
    def ws
      elements[0]
    end

    def selector
      elements[1]
    end

    def tail
      elements[2]
    end

    def ws
      elements[3]
    end
  end

  module Selectors2
    def build env, method 
      all.map do |e|
        e.send(method, env) if e.respond_to? method
      end.compact
    end
    
    def all
      [selector] + tail.elements.map {|e| e.selector }
    end
  end

  def _nt_selectors
    start_index = index
    if node_cache[:selectors].has_key?(index)
      cached = node_cache[:selectors][index]
      @index = cached.interval.end if cached
      return cached
    end

    i0, s0 = index, []
    r1 = _nt_ws
    s0 << r1
    if r1
      r2 = _nt_selector
      s0 << r2
      if r2
        s3, i3 = [], index
        loop do
          i4, s4 = index, []
          r5 = _nt_s
          s4 << r5
          if r5
            if has_terminal?(',', false, index)
              r6 = instantiate_node(SyntaxNode,input, index...(index + 1))
              @index += 1
            else
              terminal_parse_failure(',')
              r6 = nil
            end
            s4 << r6
            if r6
              r7 = _nt_ws
              s4 << r7
              if r7
                r8 = _nt_selector
                s4 << r8
              end
            end
          end
          if s4.last
            r4 = instantiate_node(SyntaxNode,input, i4...index, s4)
            r4.extend(Selectors0)
          else
            @index = i4
            r4 = nil
          end
          if r4
            s3 << r4
          else
            break
          end
        end
        r3 = instantiate_node(SyntaxNode,input, i3...index, s3)
        s0 << r3
        if r3
          r9 = _nt_ws
          s0 << r9
        end
      end
    end
    if s0.last
      r0 = instantiate_node(SyntaxNode,input, i0...index, s0)
      r0.extend(Selectors1)
      r0.extend(Selectors2)
    else
      @index = i0
      r0 = nil
    end

    node_cache[:selectors][start_index] = r0

    r0
  end

  module Selector0
    def s
      elements[0]
    end

    def select
      elements[1]
    end

    def element
      elements[2]
    end

    def s
      elements[3]
    end
  end

  module Selector1
    def tree env
      elements.inject(env) do |node, e|
        node << Node::Element.new(e.element.text_value, e.select.text_value)
        node.last
      end
    end
    
    def path env
      elements.map do |e|
        Node::Element.new(e.element.text_value, e.select.text_value)
      end
    end
  end

  def _nt_selector
    start_index = index
    if node_cache[:selector].has_key?(index)
      cached = node_cache[:selector][index]
      @index = cached.interval.end if cached
      return cached
    end

    s0, i0 = [], index
    loop do
      i1, s1 = index, []
      r2 = _nt_s
      s1 << r2
      if r2
        r3 = _nt_select
        s1 << r3
        if r3
          r4 = _nt_element
          s1 << r4
          if r4
            r5 = _nt_s
            s1 << r5
          end
        end
      end
      if s1.last
        r1 = instantiate_node(SyntaxNode,input, i1...index, s1)
        r1.extend(Selector0)
      else
        @index = i1
        r1 = nil
      end
      if r1
        s0 << r1
      else
        break
      end
    end
    if s0.empty?
      @index = i0
      r0 = nil
    else
      r0 = instantiate_node(SyntaxNode,input, i0...index, s0)
      r0.extend(Selector1)
    end

    node_cache[:selector][start_index] = r0

    r0
  end

  module Declaration0
    def ws
      elements[0]
    end

  end

  module Declaration1
    def ws
      elements[0]
    end

    def name
      elements[1]
    end

    def s
      elements[2]
    end

    def s
      elements[4]
    end

    def expression
      elements[5]
    end

    def s
      elements[6]
    end

    def ws
      elements[8]
    end
  end

  module Declaration2
    def build env
      env << (name.text_value =~ /^@/ ? Node::Variable : Node::Property).new(name.text_value, [])
      expression.build env
    end
  # Empty rule
  end

  module Declaration3
    def ws
      elements[0]
    end

    def ident
      elements[1]
    end

    def s
      elements[2]
    end

    def s
      elements[4]
    end

    def ws
      elements[6]
    end
  end

  def _nt_declaration
    start_index = index
    if node_cache[:declaration].has_key?(index)
      cached = node_cache[:declaration][index]
      @index = cached.interval.end if cached
      return cached
    end

    i0 = index
    i1, s1 = index, []
    r2 = _nt_ws
    s1 << r2
    if r2
      i3 = index
      r4 = _nt_ident
      if r4
        r3 = r4
      else
        r5 = _nt_variable
        if r5
          r3 = r5
        else
          @index = i3
          r3 = nil
        end
      end
      s1 << r3
      if r3
        r6 = _nt_s
        s1 << r6
        if r6
          if has_terminal?(':', false, index)
            r7 = instantiate_node(SyntaxNode,input, index...(index + 1))
            @index += 1
          else
            terminal_parse_failure(':')
            r7 = nil
          end
          s1 << r7
          if r7
            r8 = _nt_s
            s1 << r8
            if r8
              r9 = _nt_expression
              s1 << r9
              if r9
                r10 = _nt_s
                s1 << r10
                if r10
                  i11 = index
                  if has_terminal?(';', false, index)
                    r12 = instantiate_node(SyntaxNode,input, index...(index + 1))
                    @index += 1
                  else
                    terminal_parse_failure(';')
                    r12 = nil
                  end
                  if r12
                    r11 = r12
                  else
                    i13, s13 = index, []
                    r14 = _nt_ws
                    s13 << r14
                    if r14
                      i15 = index
                      if has_terminal?('}', false, index)
                        r16 = instantiate_node(SyntaxNode,input, index...(index + 1))
                        @index += 1
                      else
                        terminal_parse_failure('}')
                        r16 = nil
                      end
                      if r16
                        @index = i15
                        r15 = instantiate_node(SyntaxNode,input, index...index)
                      else
                        r15 = nil
                      end
                      s13 << r15
                    end
                    if s13.last
                      r13 = instantiate_node(SyntaxNode,input, i13...index, s13)
                      r13.extend(Declaration0)
                    else
                      @index = i13
                      r13 = nil
                    end
                    if r13
                      r11 = r13
                    else
                      @index = i11
                      r11 = nil
                    end
                  end
                  s1 << r11
                  if r11
                    r17 = _nt_ws
                    s1 << r17
                  end
                end
              end
            end
          end
        end
      end
    end
    if s1.last
      r1 = instantiate_node(SyntaxNode,input, i1...index, s1)
      r1.extend(Declaration1)
      r1.extend(Declaration2)
    else
      @index = i1
      r1 = nil
    end
    if r1
      r0 = r1
    else
      i18, s18 = index, []
      r19 = _nt_ws
      s18 << r19
      if r19
        r20 = _nt_ident
        s18 << r20
        if r20
          r21 = _nt_s
          s18 << r21
          if r21
            if has_terminal?(':', false, index)
              r22 = instantiate_node(SyntaxNode,input, index...(index + 1))
              @index += 1
            else
              terminal_parse_failure(':')
              r22 = nil
            end
            s18 << r22
            if r22
              r23 = _nt_s
              s18 << r23
              if r23
                if has_terminal?(';', false, index)
                  r24 = instantiate_node(SyntaxNode,input, index...(index + 1))
                  @index += 1
                else
                  terminal_parse_failure(';')
                  r24 = nil
                end
                s18 << r24
                if r24
                  r25 = _nt_ws
                  s18 << r25
                end
              end
            end
          end
        end
      end
      if s18.last
        r18 = instantiate_node(SyntaxNode,input, i18...index, s18)
        r18.extend(Declaration3)
      else
        @index = i18
        r18 = nil
      end
      if r18
        r0 = r18
      else
        @index = i0
        r0 = nil
      end
    end

    node_cache[:declaration][start_index] = r0

    r0
  end

  module Expression0
    def entity
      elements[0]
    end

    def expression
      elements[2]
    end
  end

  def _nt_expression
    start_index = index
    if node_cache[:expression].has_key?(index)
      cached = node_cache[:expression][index]
      @index = cached.interval.end if cached
      return cached
    end

    i0 = index
    i1, s1 = index, []
    r2 = _nt_entity
    s1 << r2
    if r2
      i3 = index
      r4 = _nt_operator
      if r4
        r3 = r4
      else
        r5 = _nt_S
        if r5
          r3 = r5
        else
          r6 = _nt_WS
          if r6
            r3 = r6
          else
            @index = i3
            r3 = nil
          end
        end
      end
      s1 << r3
      if r3
        r7 = _nt_expression
        s1 << r7
      end
    end
    if s1.last
      r1 = instantiate_node(Builder,input, i1...index, s1)
      r1.extend(Expression0)
    else
      @index = i1
      r1 = nil
    end
    if r1
      r0 = r1
    else
      r8 = _nt_entity
      if r8
        r0 = r8
      else
        @index = i0
        r0 = nil
      end
    end

    node_cache[:expression][start_index] = r0

    r0
  end

  def _nt_entity
    start_index = index
    if node_cache[:entity].has_key?(index)
      cached = node_cache[:entity][index]
      @index = cached.interval.end if cached
      return cached
    end

    i0 = index
    r1 = _nt_function
    if r1
      r0 = r1
    else
      r2 = _nt_fonts
      if r2
        r0 = r2
      else
        r3 = _nt_keyword
        if r3
          r0 = r3
        else
          r4 = _nt_accessor
          if r4
            r0 = r4
          else
            r5 = _nt_variable
            if r5
              r0 = r5
            else
              r6 = _nt_literal
              if r6
                r0 = r6
              else
                r7 = _nt_important
                if r7
                  r0 = r7
                else
                  @index = i0
                  r0 = nil
                end
              end
            end
          end
        end
      end
    end

    node_cache[:entity][start_index] = r0

    r0
  end

  module Fonts0
    def s
      elements[0]
    end

    def s
      elements[2]
    end

    def font
      elements[3]
    end
  end

  module Fonts1
    def font
      elements[0]
    end

    def family
      elements[1]
    end
  end

  module Fonts2
    def build env
      fonts = ([font] + family.elements.map {|f| f.font }).map do |font|
        font.build env
      end
      env.identifiers.last << Node::FontFamily.new(fonts)
    end
  end

  def _nt_fonts
    start_index = index
    if node_cache[:fonts].has_key?(index)
      cached = node_cache[:fonts][index]
      @index = cached.interval.end if cached
      return cached
    end

    i0, s0 = index, []
    r1 = _nt_font
    s0 << r1
    if r1
      s2, i2 = [], index
      loop do
        i3, s3 = index, []
        r4 = _nt_s
        s3 << r4
        if r4
          if has_terminal?(',', false, index)
            r5 = instantiate_node(SyntaxNode,input, index...(index + 1))
            @index += 1
          else
            terminal_parse_failure(',')
            r5 = nil
          end
          s3 << r5
          if r5
            r6 = _nt_s
            s3 << r6
            if r6
              r7 = _nt_font
              s3 << r7
            end
          end
        end
        if s3.last
          r3 = instantiate_node(SyntaxNode,input, i3...index, s3)
          r3.extend(Fonts0)
        else
          @index = i3
          r3 = nil
        end
        if r3
          s2 << r3
        else
          break
        end
      end
      if s2.empty?
        @index = i2
        r2 = nil
      else
        r2 = instantiate_node(SyntaxNode,input, i2...index, s2)
      end
      s0 << r2
    end
    if s0.last
      r0 = instantiate_node(SyntaxNode,input, i0...index, s0)
      r0.extend(Fonts1)
      r0.extend(Fonts2)
    else
      @index = i0
      r0 = nil
    end

    node_cache[:fonts][start_index] = r0

    r0
  end

  module Font0
  end

  module Font1
    def build env
      Node::Keyword.new(text_value)
    end
  end

  module Font2
    def build env
      Node::String.new(text_value)
    end
  end

  def _nt_font
    start_index = index
    if node_cache[:font].has_key?(index)
      cached = node_cache[:font][index]
      @index = cached.interval.end if cached
      return cached
    end

    i0 = index
    i1, s1 = index, []
    if has_terminal?('[a-zA-Z]', true, index)
      r2 = true
      @index += 1
    else
      r2 = nil
    end
    s1 << r2
    if r2
      s3, i3 = [], index
      loop do
        if has_terminal?('[-a-zA-Z0-9]', true, index)
          r4 = true
          @index += 1
        else
          r4 = nil
        end
        if r4
          s3 << r4
        else
          break
        end
      end
      r3 = instantiate_node(SyntaxNode,input, i3...index, s3)
      s1 << r3
    end
    if s1.last
      r1 = instantiate_node(SyntaxNode,input, i1...index, s1)
      r1.extend(Font0)
      r1.extend(Font1)
    else
      @index = i1
      r1 = nil
    end
    if r1
      r0 = r1
    else
      r5 = _nt_string
      r5.extend(Font2)
      if r5
        r0 = r5
      else
        @index = i0
        r0 = nil
      end
    end

    node_cache[:font][start_index] = r0

    r0
  end

  module Ident0
  end

  def _nt_ident
    start_index = index
    if node_cache[:ident].has_key?(index)
      cached = node_cache[:ident][index]
      @index = cached.interval.end if cached
      return cached
    end

    i0, s0 = index, []
    if has_terminal?('-', false, index)
      r2 = instantiate_node(SyntaxNode,input, index...(index + 1))
      @index += 1
    else
      terminal_parse_failure('-')
      r2 = nil
    end
    if r2
      r1 = r2
    else
      r1 = instantiate_node(SyntaxNode,input, index...index)
    end
    s0 << r1
    if r1
      s3, i3 = [], index
      loop do
        if has_terminal?('[-a-z0-9_]', true, index)
          r4 = true
          @index += 1
        else
          r4 = nil
        end
        if r4
          s3 << r4
        else
          break
        end
      end
      if s3.empty?
        @index = i3
        r3 = nil
      else
        r3 = instantiate_node(SyntaxNode,input, i3...index, s3)
      end
      s0 << r3
    end
    if s0.last
      r0 = instantiate_node(SyntaxNode,input, i0...index, s0)
      r0.extend(Ident0)
    else
      @index = i0
      r0 = nil
    end

    node_cache[:ident][start_index] = r0

    r0
  end

  module Variable0
  end

  module Variable1
    def build env
      #env.identifiers.last << env.nearest(text_value)
      env.identifiers.last << Node::Variable.new(text_value)
    end
  end

  def _nt_variable
    start_index = index
    if node_cache[:variable].has_key?(index)
      cached = node_cache[:variable][index]
      @index = cached.interval.end if cached
      return cached
    end

    i0, s0 = index, []
    if has_terminal?('@', false, index)
      r1 = instantiate_node(SyntaxNode,input, index...(index + 1))
      @index += 1
    else
      terminal_parse_failure('@')
      r1 = nil
    end
    s0 << r1
    if r1
      s2, i2 = [], index
      loop do
        if has_terminal?('[-a-zA-Z0-9_]', true, index)
          r3 = true
          @index += 1
        else
          r3 = nil
        end
        if r3
          s2 << r3
        else
          break
        end
      end
      if s2.empty?
        @index = i2
        r2 = nil
      else
        r2 = instantiate_node(SyntaxNode,input, i2...index, s2)
      end
      s0 << r2
    end
    if s0.last
      r0 = instantiate_node(SyntaxNode,input, i0...index, s0)
      r0.extend(Variable0)
      r0.extend(Variable1)
    else
      @index = i0
      r0 = nil
    end

    node_cache[:variable][start_index] = r0

    r0
  end

  module Element0
  end

  module Element1
  end

  def _nt_element
    start_index = index
    if node_cache[:element].has_key?(index)
      cached = node_cache[:element][index]
      @index = cached.interval.end if cached
      return cached
    end

    i0 = index
    i1, s1 = index, []
    i2 = index
    r3 = _nt_class_id
    if r3
      r2 = r3
    else
      r4 = _nt_tag
      if r4
        r2 = r4
      else
        r5 = _nt_ident
        if r5
          r2 = r5
        else
          @index = i2
          r2 = nil
        end
      end
    end
    s1 << r2
    if r2
      s6, i6 = [], index
      loop do
        r7 = _nt_attribute
        if r7
          s6 << r7
        else
          break
        end
      end
      r6 = instantiate_node(SyntaxNode,input, i6...index, s6)
      s1 << r6
      if r6
        i9, s9 = index, []
        if has_terminal?('(', false, index)
          r10 = instantiate_node(SyntaxNode,input, index...(index + 1))
          @index += 1
        else
          terminal_parse_failure('(')
          r10 = nil
        end
        s9 << r10
        if r10
          r12 = _nt_ident
          if r12
            r11 = r12
          else
            r11 = instantiate_node(SyntaxNode,input, index...index)
          end
          s9 << r11
          if r11
            s13, i13 = [], index
            loop do
              r14 = _nt_attribute
              if r14
                s13 << r14
              else
                break
              end
            end
            r13 = instantiate_node(SyntaxNode,input, i13...index, s13)
            s9 << r13
            if r13
              if has_terminal?(')', false, index)
                r15 = instantiate_node(SyntaxNode,input, index...(index + 1))
                @index += 1
              else
                terminal_parse_failure(')')
                r15 = nil
              end
              s9 << r15
            end
          end
        end
        if s9.last
          r9 = instantiate_node(SyntaxNode,input, i9...index, s9)
          r9.extend(Element0)
        else
          @index = i9
          r9 = nil
        end
        if r9
          r8 = r9
        else
          r8 = instantiate_node(SyntaxNode,input, index...index)
        end
        s1 << r8
      end
    end
    if s1.last
      r1 = instantiate_node(SyntaxNode,input, i1...index, s1)
      r1.extend(Element1)
    else
      @index = i1
      r1 = nil
    end
    if r1
      r0 = r1
    else
      s16, i16 = [], index
      loop do
        r17 = _nt_attribute
        if r17
          s16 << r17
        else
          break
        end
      end
      if s16.empty?
        @index = i16
        r16 = nil
      else
        r16 = instantiate_node(SyntaxNode,input, i16...index, s16)
      end
      if r16
        r0 = r16
      else
        if has_terminal?('@media', false, index)
          r18 = instantiate_node(SyntaxNode,input, index...(index + 6))
          @index += 6
        else
          terminal_parse_failure('@media')
          r18 = nil
        end
        if r18
          r0 = r18
        else
          if has_terminal?('@font-face', false, index)
            r19 = instantiate_node(SyntaxNode,input, index...(index + 10))
            @index += 10
          else
            terminal_parse_failure('@font-face')
            r19 = nil
          end
          if r19
            r0 = r19
          else
            @index = i0
            r0 = nil
          end
        end
      end
    end

    node_cache[:element][start_index] = r0

    r0
  end

  module ClassId0
  end

  def _nt_class_id
    start_index = index
    if node_cache[:class_id].has_key?(index)
      cached = node_cache[:class_id][index]
      @index = cached.interval.end if cached
      return cached
    end

    i0, s0 = index, []
    r2 = _nt_tag
    if r2
      r1 = r2
    else
      r1 = instantiate_node(SyntaxNode,input, index...index)
    end
    s0 << r1
    if r1
      s3, i3 = [], index
      loop do
        i4 = index
        r5 = _nt_class
        if r5
          r4 = r5
        else
          r6 = _nt_id
          if r6
            r4 = r6
          else
            @index = i4
            r4 = nil
          end
        end
        if r4
          s3 << r4
        else
          break
        end
      end
      if s3.empty?
        @index = i3
        r3 = nil
      else
        r3 = instantiate_node(SyntaxNode,input, i3...index, s3)
      end
      s0 << r3
    end
    if s0.last
      r0 = instantiate_node(SyntaxNode,input, i0...index, s0)
      r0.extend(ClassId0)
    else
      @index = i0
      r0 = nil
    end

    node_cache[:class_id][start_index] = r0

    r0
  end

  module Attribute0
  end

  module Attribute1
    def tag
      elements[1]
    end

  end

  module Attribute2
  end

  def _nt_attribute
    start_index = index
    if node_cache[:attribute].has_key?(index)
      cached = node_cache[:attribute][index]
      @index = cached.interval.end if cached
      return cached
    end

    i0 = index
    i1, s1 = index, []
    if has_terminal?('[', false, index)
      r2 = instantiate_node(SyntaxNode,input, index...(index + 1))
      @index += 1
    else
      terminal_parse_failure('[')
      r2 = nil
    end
    s1 << r2
    if r2
      r3 = _nt_tag
      s1 << r3
      if r3
        i4, s4 = index, []
        if has_terminal?('[|~*$^]', true, index)
          r6 = true
          @index += 1
        else
          r6 = nil
        end
        if r6
          r5 = r6
        else
          r5 = instantiate_node(SyntaxNode,input, index...index)
        end
        s4 << r5
        if r5
          if has_terminal?('=', false, index)
            r7 = instantiate_node(SyntaxNode,input, index...(index + 1))
            @index += 1
          else
            terminal_parse_failure('=')
            r7 = nil
          end
          s4 << r7
        end
        if s4.last
          r4 = instantiate_node(SyntaxNode,input, i4...index, s4)
          r4.extend(Attribute0)
        else
          @index = i4
          r4 = nil
        end
        s1 << r4
        if r4
          i8 = index
          r9 = _nt_tag
          if r9
            r8 = r9
          else
            r10 = _nt_string
            if r10
              r8 = r10
            else
              @index = i8
              r8 = nil
            end
          end
          s1 << r8
          if r8
            if has_terminal?(']', false, index)
              r11 = instantiate_node(SyntaxNode,input, index...(index + 1))
              @index += 1
            else
              terminal_parse_failure(']')
              r11 = nil
            end
            s1 << r11
          end
        end
      end
    end
    if s1.last
      r1 = instantiate_node(SyntaxNode,input, i1...index, s1)
      r1.extend(Attribute1)
    else
      @index = i1
      r1 = nil
    end
    if r1
      r0 = r1
    else
      i12, s12 = index, []
      if has_terminal?('[', false, index)
        r13 = instantiate_node(SyntaxNode,input, index...(index + 1))
        @index += 1
      else
        terminal_parse_failure('[')
        r13 = nil
      end
      s12 << r13
      if r13
        i14 = index
        r15 = _nt_tag
        if r15
          r14 = r15
        else
          r16 = _nt_string
          if r16
            r14 = r16
          else
            @index = i14
            r14 = nil
          end
        end
        s12 << r14
        if r14
          if has_terminal?(']', false, index)
            r17 = instantiate_node(SyntaxNode,input, index...(index + 1))
            @index += 1
          else
            terminal_parse_failure(']')
            r17 = nil
          end
          s12 << r17
        end
      end
      if s12.last
        r12 = instantiate_node(SyntaxNode,input, i12...index, s12)
        r12.extend(Attribute2)
      else
        @index = i12
        r12 = nil
      end
      if r12
        r0 = r12
      else
        @index = i0
        r0 = nil
      end
    end

    node_cache[:attribute][start_index] = r0

    r0
  end

  module Class0
  end

  def _nt_class
    start_index = index
    if node_cache[:class].has_key?(index)
      cached = node_cache[:class][index]
      @index = cached.interval.end if cached
      return cached
    end

    i0, s0 = index, []
    if has_terminal?('.', false, index)
      r1 = instantiate_node(SyntaxNode,input, index...(index + 1))
      @index += 1
    else
      terminal_parse_failure('.')
      r1 = nil
    end
    s0 << r1
    if r1
      if has_terminal?('[_a-z]', true, index)
        r2 = true
        @index += 1
      else
        r2 = nil
      end
      s0 << r2
      if r2
        s3, i3 = [], index
        loop do
          if has_terminal?('[-a-zA-Z0-9_]', true, index)
            r4 = true
            @index += 1
          else
            r4 = nil
          end
          if r4
            s3 << r4
          else
            break
          end
        end
        r3 = instantiate_node(SyntaxNode,input, i3...index, s3)
        s0 << r3
      end
    end
    if s0.last
      r0 = instantiate_node(SyntaxNode,input, i0...index, s0)
      r0.extend(Class0)
    else
      @index = i0
      r0 = nil
    end

    node_cache[:class][start_index] = r0

    r0
  end

  module Id0
  end

  def _nt_id
    start_index = index
    if node_cache[:id].has_key?(index)
      cached = node_cache[:id][index]
      @index = cached.interval.end if cached
      return cached
    end

    i0, s0 = index, []
    if has_terminal?('#', false, index)
      r1 = instantiate_node(SyntaxNode,input, index...(index + 1))
      @index += 1
    else
      terminal_parse_failure('#')
      r1 = nil
    end
    s0 << r1
    if r1
      if has_terminal?('[_a-z]', true, index)
        r2 = true
        @index += 1
      else
        r2 = nil
      end
      s0 << r2
      if r2
        s3, i3 = [], index
        loop do
          if has_terminal?('[-a-zA-Z0-9_]', true, index)
            r4 = true
            @index += 1
          else
            r4 = nil
          end
          if r4
            s3 << r4
          else
            break
          end
        end
        r3 = instantiate_node(SyntaxNode,input, i3...index, s3)
        s0 << r3
      end
    end
    if s0.last
      r0 = instantiate_node(SyntaxNode,input, i0...index, s0)
      r0.extend(Id0)
    else
      @index = i0
      r0 = nil
    end

    node_cache[:id][start_index] = r0

    r0
  end

  module Tag0
  end

  def _nt_tag
    start_index = index
    if node_cache[:tag].has_key?(index)
      cached = node_cache[:tag][index]
      @index = cached.interval.end if cached
      return cached
    end

    i0 = index
    i1, s1 = index, []
    if has_terminal?('[a-zA-Z]', true, index)
      r2 = true
      @index += 1
    else
      r2 = nil
    end
    s1 << r2
    if r2
      s3, i3 = [], index
      loop do
        if has_terminal?('[-a-zA-Z]', true, index)
          r4 = true
          @index += 1
        else
          r4 = nil
        end
        if r4
          s3 << r4
        else
          break
        end
      end
      r3 = instantiate_node(SyntaxNode,input, i3...index, s3)
      s1 << r3
      if r3
        if has_terminal?('[0-9]', true, index)
          r6 = true
          @index += 1
        else
          r6 = nil
        end
        if r6
          r5 = r6
        else
          r5 = instantiate_node(SyntaxNode,input, index...index)
        end
        s1 << r5
      end
    end
    if s1.last
      r1 = instantiate_node(SyntaxNode,input, i1...index, s1)
      r1.extend(Tag0)
    else
      @index = i1
      r1 = nil
    end
    if r1
      r0 = r1
    else
      if has_terminal?('*', false, index)
        r7 = instantiate_node(SyntaxNode,input, index...(index + 1))
        @index += 1
      else
        terminal_parse_failure('*')
        r7 = nil
      end
      if r7
        r0 = r7
      else
        @index = i0
        r0 = nil
      end
    end

    node_cache[:tag][start_index] = r0

    r0
  end

  module Select0
    def s
      elements[0]
    end

    def s
      elements[2]
    end
  end

  module Select1
    def s
      elements[0]
    end

  end

  def _nt_select
    start_index = index
    if node_cache[:select].has_key?(index)
      cached = node_cache[:select][index]
      @index = cached.interval.end if cached
      return cached
    end

    i1 = index
    i2, s2 = index, []
    r3 = _nt_s
    s2 << r3
    if r3
      if has_terminal?('[+>~]', true, index)
        r4 = true
        @index += 1
      else
        r4 = nil
      end
      s2 << r4
      if r4
        r5 = _nt_s
        s2 << r5
      end
    end
    if s2.last
      r2 = instantiate_node(SyntaxNode,input, i2...index, s2)
      r2.extend(Select0)
    else
      @index = i2
      r2 = nil
    end
    if r2
      r1 = r2
    else
      i6, s6 = index, []
      r7 = _nt_s
      s6 << r7
      if r7
        if has_terminal?(':', false, index)
          r8 = instantiate_node(SyntaxNode,input, index...(index + 1))
          @index += 1
        else
          terminal_parse_failure(':')
          r8 = nil
        end
        s6 << r8
      end
      if s6.last
        r6 = instantiate_node(SyntaxNode,input, i6...index, s6)
        r6.extend(Select1)
      else
        @index = i6
        r6 = nil
      end
      if r6
        r1 = r6
      else
        r9 = _nt_S
        if r9
          r1 = r9
        else
          @index = i1
          r1 = nil
        end
      end
    end
    if r1
      r0 = r1
    else
      r0 = instantiate_node(SyntaxNode,input, index...index)
    end

    node_cache[:select][start_index] = r0

    r0
  end

  module Accessor0
    def ident
      elements[0]
    end

    def attr
      elements[2]
    end

  end

  module Accessor1
    def build env
      env.identifiers.last << env.nearest(ident.text_value)[attr.text_value.delete(%q["'])].evaluate
    end
  end

  def _nt_accessor
    start_index = index
    if node_cache[:accessor].has_key?(index)
      cached = node_cache[:accessor][index]
      @index = cached.interval.end if cached
      return cached
    end

    i0, s0 = index, []
    i1 = index
    r2 = _nt_class_id
    if r2
      r1 = r2
    else
      r3 = _nt_tag
      if r3
        r1 = r3
      else
        @index = i1
        r1 = nil
      end
    end
    s0 << r1
    if r1
      if has_terminal?('[', false, index)
        r4 = instantiate_node(SyntaxNode,input, index...(index + 1))
        @index += 1
      else
        terminal_parse_failure('[')
        r4 = nil
      end
      s0 << r4
      if r4
        i5 = index
        r6 = _nt_string
        if r6
          r5 = r6
        else
          r7 = _nt_variable
          if r7
            r5 = r7
          else
            @index = i5
            r5 = nil
          end
        end
        s0 << r5
        if r5
          if has_terminal?(']', false, index)
            r8 = instantiate_node(SyntaxNode,input, index...(index + 1))
            @index += 1
          else
            terminal_parse_failure(']')
            r8 = nil
          end
          s0 << r8
        end
      end
    end
    if s0.last
      r0 = instantiate_node(SyntaxNode,input, i0...index, s0)
      r0.extend(Accessor0)
      r0.extend(Accessor1)
    else
      @index = i0
      r0 = nil
    end

    node_cache[:accessor][start_index] = r0

    r0
  end

  module Operator0
    def S
      elements[0]
    end

    def S
      elements[2]
    end
  end

  module Operator1
    def build env
      env.identifiers.last << Node::Operator.new(text_value.strip)
    end
  end

  module Operator2
    def build env
      env.identifiers.last << Node::Operator.new(text_value)
    end
  end

  def _nt_operator
    start_index = index
    if node_cache[:operator].has_key?(index)
      cached = node_cache[:operator][index]
      @index = cached.interval.end if cached
      return cached
    end

    i0 = index
    i1, s1 = index, []
    r2 = _nt_S
    s1 << r2
    if r2
      if has_terminal?('[-+*/]', true, index)
        r3 = true
        @index += 1
      else
        r3 = nil
      end
      s1 << r3
      if r3
        r4 = _nt_S
        s1 << r4
      end
    end
    if s1.last
      r1 = instantiate_node(SyntaxNode,input, i1...index, s1)
      r1.extend(Operator0)
      r1.extend(Operator1)
    else
      @index = i1
      r1 = nil
    end
    if r1
      r0 = r1
    else
      if has_terminal?('[-+*/]', true, index)
        r5 = instantiate_node(SyntaxNode,input, index...(index + 1))
        r5.extend(Operator2)
        @index += 1
      else
        r5 = nil
      end
      if r5
        r0 = r5
      else
        @index = i0
        r0 = nil
      end
    end

    node_cache[:operator][start_index] = r0

    r0
  end

  module Literal0
    def dimension
      elements[2]
    end
  end

  module Literal1
    def build env
      env.identifiers.last << Node::Anonymous.new(text_value)
    end
  end

  module Literal2
    def number
      elements[0]
    end

    def unit
      elements[1]
    end
  end

  module Literal3
    def build env
      env.identifiers.last << Node::Number.new(number.text_value, unit.text_value)
    end
  end

  module Literal4
    def build env
      env.identifiers.last << Node::String.new(text_value)
    end
  end

  def _nt_literal
    start_index = index
    if node_cache[:literal].has_key?(index)
      cached = node_cache[:literal][index]
      @index = cached.interval.end if cached
      return cached
    end

    i0 = index
    r1 = _nt_color
    if r1
      r0 = r1
    else
      i2, s2 = index, []
      i3 = index
      r4 = _nt_dimension
      if r4
        r3 = r4
      else
        s5, i5 = [], index
        loop do
          if has_terminal?('[-a-z]', true, index)
            r6 = true
            @index += 1
          else
            r6 = nil
          end
          if r6
            s5 << r6
          else
            break
          end
        end
        if s5.empty?
          @index = i5
          r5 = nil
        else
          r5 = instantiate_node(SyntaxNode,input, i5...index, s5)
        end
        if r5
          r3 = r5
        else
          @index = i3
          r3 = nil
        end
      end
      s2 << r3
      if r3
        if has_terminal?('/', false, index)
          r7 = instantiate_node(SyntaxNode,input, index...(index + 1))
          @index += 1
        else
          terminal_parse_failure('/')
          r7 = nil
        end
        s2 << r7
        if r7
          r8 = _nt_dimension
          s2 << r8
        end
      end
      if s2.last
        r2 = instantiate_node(SyntaxNode,input, i2...index, s2)
        r2.extend(Literal0)
        r2.extend(Literal1)
      else
        @index = i2
        r2 = nil
      end
      if r2
        r0 = r2
      else
        i9, s9 = index, []
        r10 = _nt_number
        s9 << r10
        if r10
          r11 = _nt_unit
          s9 << r11
        end
        if s9.last
          r9 = instantiate_node(SyntaxNode,input, i9...index, s9)
          r9.extend(Literal2)
          r9.extend(Literal3)
        else
          @index = i9
          r9 = nil
        end
        if r9
          r0 = r9
        else
          r12 = _nt_string
          r12.extend(Literal4)
          if r12
            r0 = r12
          else
            @index = i0
            r0 = nil
          end
        end
      end
    end

    node_cache[:literal][start_index] = r0

    r0
  end

  module Important0
    def build env
      env.identifiers.last << Node::Keyword.new(text_value)
    end
  end

  def _nt_important
    start_index = index
    if node_cache[:important].has_key?(index)
      cached = node_cache[:important][index]
      @index = cached.interval.end if cached
      return cached
    end

    if has_terminal?('!important', false, index)
      r0 = instantiate_node(SyntaxNode,input, index...(index + 10))
      r0.extend(Important0)
      @index += 10
    else
      terminal_parse_failure('!important')
      r0 = nil
    end

    node_cache[:important][start_index] = r0

    r0
  end

  module Keyword0
  end

  module Keyword1
    def build env
      env.identifiers.last << Node::Keyword.new(text_value)
    end
  end

  def _nt_keyword
    start_index = index
    if node_cache[:keyword].has_key?(index)
      cached = node_cache[:keyword][index]
      @index = cached.interval.end if cached
      return cached
    end

    i0, s0 = index, []
    s1, i1 = [], index
    loop do
      if has_terminal?('[-a-zA-Z]', true, index)
        r2 = true
        @index += 1
      else
        r2 = nil
      end
      if r2
        s1 << r2
      else
        break
      end
    end
    if s1.empty?
      @index = i1
      r1 = nil
    else
      r1 = instantiate_node(SyntaxNode,input, i1...index, s1)
    end
    s0 << r1
    if r1
      i3 = index
      r4 = _nt_ns
      if r4
        r3 = nil
      else
        @index = i3
        r3 = instantiate_node(SyntaxNode,input, index...index)
      end
      s0 << r3
    end
    if s0.last
      r0 = instantiate_node(SyntaxNode,input, i0...index, s0)
      r0.extend(Keyword0)
      r0.extend(Keyword1)
    else
      @index = i0
      r0 = nil
    end

    node_cache[:keyword][start_index] = r0

    r0
  end

  module String0
  end

  module String1
    def content
      elements[1]
    end

  end

  module String2
    def value
      text_value[1...-1]
    end
  end

  module String3
  end

  module String4
    def content
      elements[1]
    end

  end

  module String5
    def value
      text_value[1...-1]
    end
  end

  def _nt_string
    start_index = index
    if node_cache[:string].has_key?(index)
      cached = node_cache[:string][index]
      @index = cached.interval.end if cached
      return cached
    end

    i0 = index
    i1, s1 = index, []
    if has_terminal?("'", false, index)
      r2 = instantiate_node(SyntaxNode,input, index...(index + 1))
      @index += 1
    else
      terminal_parse_failure("'")
      r2 = nil
    end
    s1 << r2
    if r2
      s3, i3 = [], index
      loop do
        i4, s4 = index, []
        i5 = index
        if has_terminal?("'", false, index)
          r6 = instantiate_node(SyntaxNode,input, index...(index + 1))
          @index += 1
        else
          terminal_parse_failure("'")
          r6 = nil
        end
        if r6
          r5 = nil
        else
          @index = i5
          r5 = instantiate_node(SyntaxNode,input, index...index)
        end
        s4 << r5
        if r5
          if index < input_length
            r7 = instantiate_node(SyntaxNode,input, index...(index + 1))
            @index += 1
          else
            terminal_parse_failure("any character")
            r7 = nil
          end
          s4 << r7
        end
        if s4.last
          r4 = instantiate_node(SyntaxNode,input, i4...index, s4)
          r4.extend(String0)
        else
          @index = i4
          r4 = nil
        end
        if r4
          s3 << r4
        else
          break
        end
      end
      r3 = instantiate_node(SyntaxNode,input, i3...index, s3)
      s1 << r3
      if r3
        if has_terminal?("'", false, index)
          r8 = instantiate_node(SyntaxNode,input, index...(index + 1))
          @index += 1
        else
          terminal_parse_failure("'")
          r8 = nil
        end
        s1 << r8
      end
    end
    if s1.last
      r1 = instantiate_node(SyntaxNode,input, i1...index, s1)
      r1.extend(String1)
      r1.extend(String2)
    else
      @index = i1
      r1 = nil
    end
    if r1
      r0 = r1
    else
      i9, s9 = index, []
      if has_terminal?('["]', true, index)
        r10 = true
        @index += 1
      else
        r10 = nil
      end
      s9 << r10
      if r10
        s11, i11 = [], index
        loop do
          i12, s12 = index, []
          i13 = index
          if has_terminal?('["]', true, index)
            r14 = true
            @index += 1
          else
            r14 = nil
          end
          if r14
            r13 = nil
          else
            @index = i13
            r13 = instantiate_node(SyntaxNode,input, index...index)
          end
          s12 << r13
          if r13
            if index < input_length
              r15 = instantiate_node(SyntaxNode,input, index...(index + 1))
              @index += 1
            else
              terminal_parse_failure("any character")
              r15 = nil
            end
            s12 << r15
          end
          if s12.last
            r12 = instantiate_node(SyntaxNode,input, i12...index, s12)
            r12.extend(String3)
          else
            @index = i12
            r12 = nil
          end
          if r12
            s11 << r12
          else
            break
          end
        end
        r11 = instantiate_node(SyntaxNode,input, i11...index, s11)
        s9 << r11
        if r11
          if has_terminal?('["]', true, index)
            r16 = true
            @index += 1
          else
            r16 = nil
          end
          s9 << r16
        end
      end
      if s9.last
        r9 = instantiate_node(SyntaxNode,input, i9...index, s9)
        r9.extend(String4)
        r9.extend(String5)
      else
        @index = i9
        r9 = nil
      end
      if r9
        r0 = r9
      else
        @index = i0
        r0 = nil
      end
    end

    node_cache[:string][start_index] = r0

    r0
  end

  module Dimension0
    def number
      elements[0]
    end

    def unit
      elements[1]
    end
  end

  def _nt_dimension
    start_index = index
    if node_cache[:dimension].has_key?(index)
      cached = node_cache[:dimension][index]
      @index = cached.interval.end if cached
      return cached
    end

    i0, s0 = index, []
    r1 = _nt_number
    s0 << r1
    if r1
      r2 = _nt_unit
      s0 << r2
    end
    if s0.last
      r0 = instantiate_node(SyntaxNode,input, i0...index, s0)
      r0.extend(Dimension0)
    else
      @index = i0
      r0 = nil
    end

    node_cache[:dimension][start_index] = r0

    r0
  end

  module Number0
  end

  module Number1
  end

  def _nt_number
    start_index = index
    if node_cache[:number].has_key?(index)
      cached = node_cache[:number][index]
      @index = cached.interval.end if cached
      return cached
    end

    i0 = index
    i1, s1 = index, []
    if has_terminal?('-', false, index)
      r3 = instantiate_node(SyntaxNode,input, index...(index + 1))
      @index += 1
    else
      terminal_parse_failure('-')
      r3 = nil
    end
    if r3
      r2 = r3
    else
      r2 = instantiate_node(SyntaxNode,input, index...index)
    end
    s1 << r2
    if r2
      s4, i4 = [], index
      loop do
        if has_terminal?('[0-9]', true, index)
          r5 = true
          @index += 1
        else
          r5 = nil
        end
        if r5
          s4 << r5
        else
          break
        end
      end
      r4 = instantiate_node(SyntaxNode,input, i4...index, s4)
      s1 << r4
      if r4
        if has_terminal?('.', false, index)
          r6 = instantiate_node(SyntaxNode,input, index...(index + 1))
          @index += 1
        else
          terminal_parse_failure('.')
          r6 = nil
        end
        s1 << r6
        if r6
          s7, i7 = [], index
          loop do
            if has_terminal?('[0-9]', true, index)
              r8 = true
              @index += 1
            else
              r8 = nil
            end
            if r8
              s7 << r8
            else
              break
            end
          end
          if s7.empty?
            @index = i7
            r7 = nil
          else
            r7 = instantiate_node(SyntaxNode,input, i7...index, s7)
          end
          s1 << r7
        end
      end
    end
    if s1.last
      r1 = instantiate_node(SyntaxNode,input, i1...index, s1)
      r1.extend(Number0)
    else
      @index = i1
      r1 = nil
    end
    if r1
      r0 = r1
    else
      i9, s9 = index, []
      if has_terminal?('-', false, index)
        r11 = instantiate_node(SyntaxNode,input, index...(index + 1))
        @index += 1
      else
        terminal_parse_failure('-')
        r11 = nil
      end
      if r11
        r10 = r11
      else
        r10 = instantiate_node(SyntaxNode,input, index...index)
      end
      s9 << r10
      if r10
        s12, i12 = [], index
        loop do
          if has_terminal?('[0-9]', true, index)
            r13 = true
            @index += 1
          else
            r13 = nil
          end
          if r13
            s12 << r13
          else
            break
          end
        end
        if s12.empty?
          @index = i12
          r12 = nil
        else
          r12 = instantiate_node(SyntaxNode,input, i12...index, s12)
        end
        s9 << r12
      end
      if s9.last
        r9 = instantiate_node(SyntaxNode,input, i9...index, s9)
        r9.extend(Number1)
      else
        @index = i9
        r9 = nil
      end
      if r9
        r0 = r9
      else
        @index = i0
        r0 = nil
      end
    end

    node_cache[:number][start_index] = r0

    r0
  end

  def _nt_unit
    start_index = index
    if node_cache[:unit].has_key?(index)
      cached = node_cache[:unit][index]
      @index = cached.interval.end if cached
      return cached
    end

    i1 = index
    if has_terminal?('px', false, index)
      r2 = instantiate_node(SyntaxNode,input, index...(index + 2))
      @index += 2
    else
      terminal_parse_failure('px')
      r2 = nil
    end
    if r2
      r1 = r2
    else
      if has_terminal?('em', false, index)
        r3 = instantiate_node(SyntaxNode,input, index...(index + 2))
        @index += 2
      else
        terminal_parse_failure('em')
        r3 = nil
      end
      if r3
        r1 = r3
      else
        if has_terminal?('pc', false, index)
          r4 = instantiate_node(SyntaxNode,input, index...(index + 2))
          @index += 2
        else
          terminal_parse_failure('pc')
          r4 = nil
        end
        if r4
          r1 = r4
        else
          if has_terminal?('%', false, index)
            r5 = instantiate_node(SyntaxNode,input, index...(index + 1))
            @index += 1
          else
            terminal_parse_failure('%')
            r5 = nil
          end
          if r5
            r1 = r5
          else
            if has_terminal?('pt', false, index)
              r6 = instantiate_node(SyntaxNode,input, index...(index + 2))
              @index += 2
            else
              terminal_parse_failure('pt')
              r6 = nil
            end
            if r6
              r1 = r6
            else
              if has_terminal?('cm', false, index)
                r7 = instantiate_node(SyntaxNode,input, index...(index + 2))
                @index += 2
              else
                terminal_parse_failure('cm')
                r7 = nil
              end
              if r7
                r1 = r7
              else
                if has_terminal?('mm', false, index)
                  r8 = instantiate_node(SyntaxNode,input, index...(index + 2))
                  @index += 2
                else
                  terminal_parse_failure('mm')
                  r8 = nil
                end
                if r8
                  r1 = r8
                else
                  @index = i1
                  r1 = nil
                end
              end
            end
          end
        end
      end
    end
    if r1
      r0 = r1
    else
      r0 = instantiate_node(SyntaxNode,input, index...index)
    end

    node_cache[:unit][start_index] = r0

    r0
  end

  module Color0
    def rgb
      elements[1]
    end
  end

  module Color1
    def build env
      env.identifiers.last << Node::Color.new(*rgb.build)
    end
  end

  module Color2
  end

  module Color3
    def fn
      elements[0]
    end

    def arguments
      elements[2]
    end

  end

  module Color4
    def build env
      args = arguments.build env
      env.identifiers.last << Node::Function.new(fn.text_value, args.flatten)
    end
  end

  def _nt_color
    start_index = index
    if node_cache[:color].has_key?(index)
      cached = node_cache[:color][index]
      @index = cached.interval.end if cached
      return cached
    end

    i0 = index
    i1, s1 = index, []
    if has_terminal?('#', false, index)
      r2 = instantiate_node(SyntaxNode,input, index...(index + 1))
      @index += 1
    else
      terminal_parse_failure('#')
      r2 = nil
    end
    s1 << r2
    if r2
      r3 = _nt_rgb
      s1 << r3
    end
    if s1.last
      r1 = instantiate_node(SyntaxNode,input, i1...index, s1)
      r1.extend(Color0)
      r1.extend(Color1)
    else
      @index = i1
      r1 = nil
    end
    if r1
      r0 = r1
    else
      i4, s4 = index, []
      i5, s5 = index, []
      i6 = index
      if has_terminal?('hsl', false, index)
        r7 = instantiate_node(SyntaxNode,input, index...(index + 3))
        @index += 3
      else
        terminal_parse_failure('hsl')
        r7 = nil
      end
      if r7
        r6 = r7
      else
        if has_terminal?('rgb', false, index)
          r8 = instantiate_node(SyntaxNode,input, index...(index + 3))
          @index += 3
        else
          terminal_parse_failure('rgb')
          r8 = nil
        end
        if r8
          r6 = r8
        else
          @index = i6
          r6 = nil
        end
      end
      s5 << r6
      if r6
        if has_terminal?('a', false, index)
          r10 = instantiate_node(SyntaxNode,input, index...(index + 1))
          @index += 1
        else
          terminal_parse_failure('a')
          r10 = nil
        end
        if r10
          r9 = r10
        else
          r9 = instantiate_node(SyntaxNode,input, index...index)
        end
        s5 << r9
      end
      if s5.last
        r5 = instantiate_node(SyntaxNode,input, i5...index, s5)
        r5.extend(Color2)
      else
        @index = i5
        r5 = nil
      end
      s4 << r5
      if r5
        if has_terminal?('(', false, index)
          r11 = instantiate_node(SyntaxNode,input, index...(index + 1))
          @index += 1
        else
          terminal_parse_failure('(')
          r11 = nil
        end
        s4 << r11
        if r11
          r12 = _nt_arguments
          s4 << r12
          if r12
            if has_terminal?(')', false, index)
              r13 = instantiate_node(SyntaxNode,input, index...(index + 1))
              @index += 1
            else
              terminal_parse_failure(')')
              r13 = nil
            end
            s4 << r13
          end
        end
      end
      if s4.last
        r4 = instantiate_node(SyntaxNode,input, i4...index, s4)
        r4.extend(Color3)
        r4.extend(Color4)
      else
        @index = i4
        r4 = nil
      end
      if r4
        r0 = r4
      else
        @index = i0
        r0 = nil
      end
    end

    node_cache[:color][start_index] = r0

    r0
  end

  module Rgb0
    def hex
      elements[0]
    end

    def hex
      elements[1]
    end
  end

  module Rgb1
    def hex
      elements[0]
    end

    def hex
      elements[1]
    end
  end

  module Rgb2
    def hex
      elements[0]
    end

    def hex
      elements[1]
    end
  end

  module Rgb3
    def r
      elements[0]
    end

    def g
      elements[1]
    end

    def b
      elements[2]
    end
  end

  module Rgb4
    def build
      [r.text_value, g.text_value, b.text_value]
    end
  end

  module Rgb5
    def r
      elements[0]
    end

    def g
      elements[1]
    end

    def b
      elements[2]
    end
  end

  module Rgb6
    def build
      [r.text_value, g.text_value, b.text_value].map {|c| c * 2 }
    end
  end

  def _nt_rgb
    start_index = index
    if node_cache[:rgb].has_key?(index)
      cached = node_cache[:rgb][index]
      @index = cached.interval.end if cached
      return cached
    end

    i0 = index
    i1, s1 = index, []
    i2, s2 = index, []
    r3 = _nt_hex
    s2 << r3
    if r3
      r4 = _nt_hex
      s2 << r4
    end
    if s2.last
      r2 = instantiate_node(SyntaxNode,input, i2...index, s2)
      r2.extend(Rgb0)
    else
      @index = i2
      r2 = nil
    end
    s1 << r2
    if r2
      i5, s5 = index, []
      r6 = _nt_hex
      s5 << r6
      if r6
        r7 = _nt_hex
        s5 << r7
      end
      if s5.last
        r5 = instantiate_node(SyntaxNode,input, i5...index, s5)
        r5.extend(Rgb1)
      else
        @index = i5
        r5 = nil
      end
      s1 << r5
      if r5
        i8, s8 = index, []
        r9 = _nt_hex
        s8 << r9
        if r9
          r10 = _nt_hex
          s8 << r10
        end
        if s8.last
          r8 = instantiate_node(SyntaxNode,input, i8...index, s8)
          r8.extend(Rgb2)
        else
          @index = i8
          r8 = nil
        end
        s1 << r8
      end
    end
    if s1.last
      r1 = instantiate_node(SyntaxNode,input, i1...index, s1)
      r1.extend(Rgb3)
      r1.extend(Rgb4)
    else
      @index = i1
      r1 = nil
    end
    if r1
      r0 = r1
    else
      i11, s11 = index, []
      r12 = _nt_hex
      s11 << r12
      if r12
        r13 = _nt_hex
        s11 << r13
        if r13
          r14 = _nt_hex
          s11 << r14
        end
      end
      if s11.last
        r11 = instantiate_node(SyntaxNode,input, i11...index, s11)
        r11.extend(Rgb5)
        r11.extend(Rgb6)
      else
        @index = i11
        r11 = nil
      end
      if r11
        r0 = r11
      else
        @index = i0
        r0 = nil
      end
    end

    node_cache[:rgb][start_index] = r0

    r0
  end

  def _nt_hex
    start_index = index
    if node_cache[:hex].has_key?(index)
      cached = node_cache[:hex][index]
      @index = cached.interval.end if cached
      return cached
    end

    if has_terminal?('[a-fA-F0-9]', true, index)
      r0 = instantiate_node(SyntaxNode,input, index...(index + 1))
      @index += 1
    else
      r0 = nil
    end

    node_cache[:hex][start_index] = r0

    r0
  end

  module Function0
    def name
      elements[0]
    end

    def arguments
      elements[2]
    end

  end

  module Function1
    def build env
      args = arguments.build env
      env.identifiers.last << Node::Function.new(name.text_value, [args].flatten)
    end
  end

  def _nt_function
    start_index = index
    if node_cache[:function].has_key?(index)
      cached = node_cache[:function][index]
      @index = cached.interval.end if cached
      return cached
    end

    i0, s0 = index, []
    s1, i1 = [], index
    loop do
      if has_terminal?('[-a-zA-Z_]', true, index)
        r2 = true
        @index += 1
      else
        r2 = nil
      end
      if r2
        s1 << r2
      else
        break
      end
    end
    if s1.empty?
      @index = i1
      r1 = nil
    else
      r1 = instantiate_node(SyntaxNode,input, i1...index, s1)
    end
    s0 << r1
    if r1
      if has_terminal?('(', false, index)
        r3 = instantiate_node(SyntaxNode,input, index...(index + 1))
        @index += 1
      else
        terminal_parse_failure('(')
        r3 = nil
      end
      s0 << r3
      if r3
        r4 = _nt_arguments
        s0 << r4
        if r4
          if has_terminal?(')', false, index)
            r5 = instantiate_node(SyntaxNode,input, index...(index + 1))
            @index += 1
          else
            terminal_parse_failure(')')
            r5 = nil
          end
          s0 << r5
        end
      end
    end
    if s0.last
      r0 = instantiate_node(SyntaxNode,input, i0...index, s0)
      r0.extend(Function0)
      r0.extend(Function1)
    else
      @index = i0
      r0 = nil
    end

    node_cache[:function][start_index] = r0

    r0
  end

  module Arguments0
    def argument
      elements[0]
    end

    def s
      elements[1]
    end

    def s
      elements[3]
    end

    def arguments
      elements[4]
    end
  end

  module Arguments1
    def build env
      elements.map do |e|
        e.build env if e.respond_to? :build
      end.compact
    end
  end

  def _nt_arguments
    start_index = index
    if node_cache[:arguments].has_key?(index)
      cached = node_cache[:arguments][index]
      @index = cached.interval.end if cached
      return cached
    end

    i0 = index
    i1, s1 = index, []
    r2 = _nt_argument
    s1 << r2
    if r2
      r3 = _nt_s
      s1 << r3
      if r3
        if has_terminal?(',', false, index)
          r4 = instantiate_node(SyntaxNode,input, index...(index + 1))
          @index += 1
        else
          terminal_parse_failure(',')
          r4 = nil
        end
        s1 << r4
        if r4
          r5 = _nt_s
          s1 << r5
          if r5
            r6 = _nt_arguments
            s1 << r6
          end
        end
      end
    end
    if s1.last
      r1 = instantiate_node(SyntaxNode,input, i1...index, s1)
      r1.extend(Arguments0)
      r1.extend(Arguments1)
    else
      @index = i1
      r1 = nil
    end
    if r1
      r0 = r1
    else
      r7 = _nt_argument
      if r7
        r0 = r7
      else
        @index = i0
        r0 = nil
      end
    end

    node_cache[:arguments][start_index] = r0

    r0
  end

  module Argument0
    def build env
      Node::Color.new text_value
    end
  end

  module Argument1
    def number
      elements[0]
    end

    def unit
      elements[1]
    end
  end

  module Argument2
    def build env
      Node::Number.new number.text_value, unit.text_value
    end
  end

  module Argument3
    def build env
      Node::String.new text_value
    end
  end

  module Argument4
    def dimension
      elements[2]
    end
  end

  module Argument5
    def build env
      Node::Anonymous.new text_value
    end
  end

  module Argument6
    def build env
      Node::String.new text_value
    end
  end

  def _nt_argument
    start_index = index
    if node_cache[:argument].has_key?(index)
      cached = node_cache[:argument][index]
      @index = cached.interval.end if cached
      return cached
    end

    i0 = index
    r1 = _nt_color
    r1.extend(Argument0)
    if r1
      r0 = r1
    else
      i2, s2 = index, []
      r3 = _nt_number
      s2 << r3
      if r3
        r4 = _nt_unit
        s2 << r4
      end
      if s2.last
        r2 = instantiate_node(SyntaxNode,input, i2...index, s2)
        r2.extend(Argument1)
        r2.extend(Argument2)
      else
        @index = i2
        r2 = nil
      end
      if r2
        r0 = r2
      else
        r5 = _nt_string
        r5.extend(Argument3)
        if r5
          r0 = r5
        else
          i6, s6 = index, []
          s7, i7 = [], index
          loop do
            if has_terminal?('[a-zA-Z]', true, index)
              r8 = true
              @index += 1
            else
              r8 = nil
            end
            if r8
              s7 << r8
            else
              break
            end
          end
          if s7.empty?
            @index = i7
            r7 = nil
          else
            r7 = instantiate_node(SyntaxNode,input, i7...index, s7)
          end
          s6 << r7
          if r7
            if has_terminal?('=', false, index)
              r9 = instantiate_node(SyntaxNode,input, index...(index + 1))
              @index += 1
            else
              terminal_parse_failure('=')
              r9 = nil
            end
            s6 << r9
            if r9
              r10 = _nt_dimension
              s6 << r10
            end
          end
          if s6.last
            r6 = instantiate_node(SyntaxNode,input, i6...index, s6)
            r6.extend(Argument4)
            r6.extend(Argument5)
          else
            @index = i6
            r6 = nil
          end
          if r6
            r0 = r6
          else
            s11, i11 = [], index
            loop do
              if has_terminal?('[-a-zA-Z0-9_%$/.&=:;#+?]', true, index)
                r12 = true
                @index += 1
              else
                r12 = nil
              end
              if r12
                s11 << r12
              else
                break
              end
            end
            if s11.empty?
              @index = i11
              r11 = nil
            else
              r11 = instantiate_node(SyntaxNode,input, i11...index, s11)
              r11.extend(Argument6)
            end
            if r11
              r0 = r11
            else
              @index = i0
              r0 = nil
            end
          end
        end
      end
    end

    node_cache[:argument][start_index] = r0

    r0
  end

  def _nt_s
    start_index = index
    if node_cache[:s].has_key?(index)
      cached = node_cache[:s][index]
      @index = cached.interval.end if cached
      return cached
    end

    s0, i0 = [], index
    loop do
      if has_terminal?('[ ]', true, index)
        r1 = true
        @index += 1
      else
        r1 = nil
      end
      if r1
        s0 << r1
      else
        break
      end
    end
    r0 = instantiate_node(SyntaxNode,input, i0...index, s0)

    node_cache[:s][start_index] = r0

    r0
  end

  def _nt_S
    start_index = index
    if node_cache[:S].has_key?(index)
      cached = node_cache[:S][index]
      @index = cached.interval.end if cached
      return cached
    end

    s0, i0 = [], index
    loop do
      if has_terminal?('[ ]', true, index)
        r1 = true
        @index += 1
      else
        r1 = nil
      end
      if r1
        s0 << r1
      else
        break
      end
    end
    if s0.empty?
      @index = i0
      r0 = nil
    else
      r0 = instantiate_node(SyntaxNode,input, i0...index, s0)
    end

    node_cache[:S][start_index] = r0

    r0
  end

  def _nt_ws
    start_index = index
    if node_cache[:ws].has_key?(index)
      cached = node_cache[:ws][index]
      @index = cached.interval.end if cached
      return cached
    end

    s0, i0 = [], index
    loop do
      if has_terminal?('[\\n ]', true, index)
        r1 = true
        @index += 1
      else
        r1 = nil
      end
      if r1
        s0 << r1
      else
        break
      end
    end
    r0 = instantiate_node(SyntaxNode,input, i0...index, s0)

    node_cache[:ws][start_index] = r0

    r0
  end

  def _nt_WS
    start_index = index
    if node_cache[:WS].has_key?(index)
      cached = node_cache[:WS][index]
      @index = cached.interval.end if cached
      return cached
    end

    s0, i0 = [], index
    loop do
      if has_terminal?('[\\n ]', true, index)
        r1 = true
        @index += 1
      else
        r1 = nil
      end
      if r1
        s0 << r1
      else
        break
      end
    end
    if s0.empty?
      @index = i0
      r0 = nil
    else
      r0 = instantiate_node(SyntaxNode,input, i0...index, s0)
    end

    node_cache[:WS][start_index] = r0

    r0
  end

  module Ns0
  end

  def _nt_ns
    start_index = index
    if node_cache[:ns].has_key?(index)
      cached = node_cache[:ns][index]
      @index = cached.interval.end if cached
      return cached
    end

    i0, s0 = index, []
    i1 = index
    if has_terminal?('[ ;\\n]', true, index)
      r2 = true
      @index += 1
    else
      r2 = nil
    end
    if r2
      r1 = nil
    else
      @index = i1
      r1 = instantiate_node(SyntaxNode,input, index...index)
    end
    s0 << r1
    if r1
      if index < input_length
        r3 = instantiate_node(SyntaxNode,input, index...(index + 1))
        @index += 1
      else
        terminal_parse_failure("any character")
        r3 = nil
      end
      s0 << r3
    end
    if s0.last
      r0 = instantiate_node(SyntaxNode,input, i0...index, s0)
      r0.extend(Ns0)
    else
      @index = i0
      r0 = nil
    end

    node_cache[:ns][start_index] = r0

    r0
  end

end

class LessParser < Treetop::Runtime::CompiledParser
  include Less
end

