require 'machine'

dictionary = ARGV[0]
rtn_spec = ARGV[1]
test_file = ARGV[2]

machine = Machine.new(dictionary,rtn_spec)
output = []
File.open(test_file, mode="r").each_line {|sentence|
    output << machine.parse(sentence) 
}

tracefile = File.new("rtn.trace", mode="w")
output.each do |o|
    tracefile.puts o
end
