module Less
  class Engine
    # Each css rule (selector { ... }) creates a Rule instance.
    class Rule
      attr_reader :selector
      def initialize(selector)
        @selector = selector
        @selector.strip!
      end

      def to_css
        "#{selector} { }"
      end
    end
  end
end