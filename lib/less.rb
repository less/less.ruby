require 'less/command'
require 'less/engine'
require 'less/tree'

module Less
  class MixedUnitsError < Exception 
  end
  
  def self.version
    File.read( File.join( File.dirname(__FILE__), '..', 'VERSION') )
  end
end

class Hash
  # Convert a hash into a Tree  
  def to_tree
    Less::Tree.new self
  end
end