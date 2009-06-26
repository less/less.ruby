module Descend
  def build env = {}, depth = 0
    env[:depth] += depth
    #log text_value, env[:depth] if terminal?
    elements.each do |e|
      e.build env if e.respond_to? :build
    end
  end
end

class Node < Treetop::Runtime::SyntaxNode
  include Descend
  
  def initialize
    super
  end
end

def log msg, env
  puts ". " * env[:depth] + msg
end