#!/usr/bin/ruby

require 'tree'

t = Tree.new
t.add_path("show user", "ncs show user")
t.add_path("show users", "ncs show users")
t.add_path("show sites", "ncs sites")
t.add_path("show tunnels", "ncs show tunnels")
t.add_path("debug user", "ncs debug user")
t.add_path("debug flow", "ncs debug flow")
t.add_path("show tuners", "ncs show tuners")

system("stty raw -echo") #=> Raw mode, no echo
buffer = []
begin
  while (c = STDIN.getc) do
    if (c > 31 && c < 127)
      buffer.push c.chr
      print "#{c.chr}"
    elsif (c == 3) # ctrl-c
      break
    elsif (c == 9) # tab
      #puts "\r\nFinding #{buffer.join}\r\n"
      commands = t.find(buffer.join)
      if (commands.length == 0)
        print "\r\nUnrecognized command!\r\n#{buffer.join}"
      elsif (commands.length == 1)
        c = commands[0].node_name
        c.sub!(/^#{buffer.join.split(/\s+/).last}/, '')
        buffer.push *c.split(//)
        buffer.push ' '
      else
        print "\r\n% Ambiguous Command!\r\n"
        print "#{commands.join("\r\n")}\r\n"
        print buffer.join;
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
rescue => e
  STDERR.print "\r\nCaught error: #{e}\r\n}"
  STDERR.print "\r\n\t#{e.backtrace.join("\r\n\t")}\r\n}"
ensure
  system("stty -raw echo") #=> Reset terminal mode
end

