require "motor"

class MotorCollection
    attr_accessor :length,:motors;
    def initialize(filename)
	@motors = {}
	@length = 0
	name = ""
	arcs = []
	File.open(filename, mode="r").each_line { |sentence|
	    sentence.upcase!
	    sentence.chomp! 
	    arr = sentence.split(" ")
	    declaration_name = arr[0]
	    case declaration_name
		when "MACHINE"
		    name = arr[1]
		    @motors[name] = Motor.new(name)
		    @length += 1
		when "INIT"
		    @motors[name].init_state = arr[1]
		when "FINAL"
		    fin_states = []
		    (1..arr.length-1).each do |m|
			fin_states << arr[m]	
		    end
		    @motors[name].fin_states = fin_states
		when "BEGIN"
		when "END"
		else
		    if(@motors[name].arcs.nil?)
			@motors[name].arcs = [sentence]
		    else
		    @motors[name].arcs << sentence unless(sentence.nil? or sentence.empty?) 
		    end
	    end
	}    
    end
end
