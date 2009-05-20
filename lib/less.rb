require 'less/command'
require 'less/engine'
require 'less/tree'

module Less
  VERSION = '0.5.2'
  class MixedUnitsError < Exception
  end
end

class Hash
  # Convert a hash into a Tree  
  def to_tree
    Less::Tree.new self
  end
end