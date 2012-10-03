#!/usr/bin/ruby

class Trie
 def initialize()
   @trie = Hash.new()
 end
 
  def build(str) 
    node = @trie  
    str.each_char { |ch|
      cur = ch 
      prev_node = node
      node = node[cur]
      if node == nil 
        prev_node[cur] = Hash.new()
        node = prev_node[cur]
      end
    }
  end
 
  def find(str) 
    node = @trie
    str.each_char { |ch|
      cur = ch 
      node = node[cur]
      if node == nil 
        return {}
      end
    }
    return node 
  end

  def commands prefix, node=nil
    node = find(prefix) if (node.nil?)
    c = []
    node.each do |k,v|
      p = prefix + k
      if (v.length == 0)
        c.push(p)
      else
        c.push(*commands(p, v))
      end
    end
    c
  end
end



t = Trie.new
t.build("net")
t.build("ncs")
t.build("new")

system("stty raw -echo") #=> Raw mode, no echo
buffer = []
while (c = STDIN.getc) do
  if (c > 31 && c < 127)
    buffer.push c.chr
    print "#{c.chr}"
  elsif (c == 3) # ctrl-c
    break
  elsif (c == 9) # tab
    commands = t.commands(buffer.join)
    if (commands.length == 0)
      print "\r\nUnrecognized command!\r\n#{buffer.join}"
    elsif (commands.length == 1)
      c = commands[0]
      c.sub!(/^#{buffer.join}/, '')
      print c
    else
      print "\r\n#{commands.join("\r\n")}\r\n"
    end
  elsif (c == 13) # carriage return
    buffer.clear
    print "\r\n"
  elsif (c == 127)
    if (buffer.length > 0)
      buffer.pop
      print c.chr
    end
  else
    print "#{c}\r\n"
  end
end
system("stty -raw echo") #=> Reset terminal mode

