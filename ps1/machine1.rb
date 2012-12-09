class Machine
    def initialize(dictionary_name, specification)
	@dictionary = Dictionary.new(dictionary_name).items 
	@motors = MotorCollection.new(specification)
	@parse_count = 0
	@parts_of_speech = Dictionary.new(dictionary_name).parts_of_speech
	@ret_points = []
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
#	tmp = process(sentence, @motors.motors["S"], @motors.motors["S"].init_state, [])
	output = output + tmp unless tmp.nil?

       if @parse_count > 0 
	    output.insert(2,"SUCCESSFUL PARSE\n")
	end

	output << "Done! Found #{@parse_count} parse(s).\n"
	return output
    end
   
   def process(work_str, motor, cur_state, ret_points)
	ar_work_str = work_str.split(" ")
	curr_word = ar_work_str[0] 
	if(!(@parts_of_speech[cur_state].nil?) && 
	@dictionary[curr_word] == @parts_of_speech[cur_state])
	    new_str = "" 
	    (1..ar_work_str.length-1).each |w| do
		new_str << w+" " 
	    end	
	    process(new_str, 
	end
   end 
end
