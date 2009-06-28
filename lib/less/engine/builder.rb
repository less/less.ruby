module Builder
  def build env = Less::Element.new
    elements.map do |e|
      e.build env if e.respond_to? :build
    end
    env
  end
end