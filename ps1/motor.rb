class Motor
    attr_accessor :name, :init_state, :fin_states, :arcs
    
    def initialize(name)
	@name = name
	@init_state = nil
	@fin_states = nil
	@arcs = nil
    end
    
    def states_with_init(init_state)
	ret = []
	@arcs.each do |s|
	    curr = s.split(" ")
	    if curr[0] == init_state
		    ret << s
		end
	    end
    ret	
    end
    
end
