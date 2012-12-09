require 'dictionary'
require 'motorcollection'

class Machine
    def initialize(dictionary_name, specification)
	@dictionary = Dictionary.new(dictionary_name).items 
	@motors = MotorCollection.new(specification)
	@parse_count = 0
	@parts_of_speech = Dictionary.new(dictionary_name).parts_of_speech
    end
    
    def parse(sentence)
	output = []
	og_sentence = sentence.clone
	sentence.gsub!(/\s/, " ")
	sentence.upcase!

	token_array = sentence.split(" ")
	num_period = sentence.count "."
	output << "PROCESSING SENTENCE : #{og_sentence}\n"
	output << "\n"

    	unless(num_period.eql? 1)
	   output << "Done! Found 0 parse(s).\n"
	end
	sentence.gsub!(" .", "")

	token_array.each do |token|
	    if token.empty?
		next
	    end

	    if token.eql? "."
		break
	    end


	    if @dictionary[token].nil?
		output << "Done! Found 0 parse(s).\n"
	     end
	end 
	tmp = process(sentence, @motors.motors["S"], @motors.motors["S"].init_state, [])
	output = output + tmp unless tmp.nil?

       if @parse_count > 0 
	    output.insert(2,"SUCCESSFUL PARSE\n")
       end

	    binding.pry 
	output << "Done! Found #{@parse_count} parse(s).\n"
	return output
    end
   
   def process(work_str, motor, init_state, work_array,ret_points=[],backup_states=[])
	    #binding.pry 
	if((work_str == "") && (motor.fin_states.include?(init_state) == true) && ret_points.length == 0 && motor.name == "S") 
	    #binding.pry 
	    @parse_count = @parse_count + 1
	    work_array << "#{init_state} (ACCEPT)"
	    work_array << "\n"
	    return work_array
	elsif(motor.fin_states.include?(init_state) == true && ret_points.length != 0)
	    next_group = ret_points.pop
	    #binding.pry 
	    return process(work_str, next_group[0], next_group[1], work_array, ret_points, backup_states)	
	elsif((work_str == ""))
	  #need to check backupstates, if backupstate are empty then return nil else pick one and process(it) 
	    #binding.pry
	    unless backup_states.length == 0
	     state = backup_states.pop 
	   #  binding.pry 
	     return process(state[0],state[1],state[2],state[3],state[4],backup_states)
	    end
	    return nil
	end

	output = []	
	#current part of the sentence
	token_array = work_str.split(" ")
	#sentence minus current word
	next_token_array = token_array.clone
	next_token_array.shift
	next_work_str = next_token_array.join(" ")
	
	#get parts of speech {can be MULTIPLE}
	curr_word_pos = @dictionary[token_array[0]]
	#state_list = motor.states_with_init(init_state)
	state_list = motor.arcs
	   # binding.pry  #describes all states with the current state as a starting node

	if state_list.length == 0
	    return nil
	end
	
	#if the word doesn't have a type it's not valid for the dict
	#and the parse should fail
	unless curr_word_pos.nil?
	    #for every possible arc, check the status of it
	    state_list.each do |state|
		ret = work_array.clone
		arr = state.split(" ")

	    curr_word_pos.each do |t|
	#	binding.pry
	       if t.eql? arr[1] and init_state == arr[0]
		#binding.pry
		  backup_states << [next_work_str,motor,init_state,ret,ret_points] unless backup_states.include? [next_work_str,motor,init_state,ret,ret_points] 
	       #binding.pry  
	       end
	    end
      
		#binding.pry 
	       if curr_word_pos.include? arr[1] and init_state == arr[0]
		#binding.pry 
		ret << "#{arr[0]} - #{arr[1]}(#{token_array[0]}) -> #{arr[2]}"
		return process(next_work_str, motor, arr[2], ret, ret_points,backup_states)
	       end
		
		#assuming if it's not a pos it's a machine	    
		if(!(@parts_of_speech.include? arr[1]) and arr[0] == init_state)
		    ret << "#{arr[0]} - #{arr[1]} -> #{arr[2]}"
		    next_motor = @motors.motors[arr[1]]
		    #binding.pry 
		    unless ret_points.nil?
			ret_points << [motor,arr[2]]
		    end
		    ret_points = [[motor,arr[2]]]
		    backup_states << [work_str,motor,arr[2],ret,ret_points] unless backup_states.include? [work_str,motor,arr[2],ret,ret_points]
		    #binding.pry
		    return process(work_str, next_motor,next_motor.init_state, ret, ret_points, backup_states) 
		end
	    end 
	else
	    unless backup_states.length == 0
	     state = backup_states.pop 
	     return process(state[0],state[1],state[2],state[3],state[4],backup_states)
	    end
	    return nil
	end
	
    
	    #binding.pry
    if((work_str != "") && (backup_states.length != 0))
	 state = backup_states.pop 
         #  binding.pry 
	 return process(state[0],state[1],state[2],state[3],state[4],backup_states)
    else 
    return output
    end

   end
end
