

class LeafNode
  attr_reader :node_name
  attr_reader :node_value

  def initialize node_name, node_value
    @node_name = node_name
    @node_value = node_value
    print "\r\nCreated leaf node #{node_name} with value #{node_value}\r\n"
  end

  def to_s
    "#{node_name}: #{node_value}"
  end
end
