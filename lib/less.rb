require 'less/command'
require 'less/engine'
require 'less/tree'

module Less
  VERSION = '0.1'
end

class Hash
  # Convert a hash into a Tree  
  def to_tree
    Less::Tree.new self
  end
end