#this will be the bootstrap class
require 'trainer'
class Bootstrap
    attr_accessor :trainer_arr, :t, :final_list_sp, :final_list_c
  
    def initialize(test_file,trainer)
	@t = trainer
        @trainer_arr = []
	@final_list_sp = []
	@final_list_c = []
        context = ""
        np = ""
        #get the trainer file
        File.open(test_file,'r') do |file|
            file.each_line do |line|
                if(line =~ /CONTEXT:/)
                    arr = line.split(/CONTEXT:/)
                    context = arr[1].strip
                end

                if(line =~ /NP:/)
                    arr = line.split(/NP:/)
                    np = arr[1].strip
                    @trainer_arr << Instance.new(np, context, "NONE")
                end
            end
        end
	@t.build
	temp = []
	@t.seed.each{ |key, value|
	    temp << [key, value[0], value[1], value[2]]
	}
	temp.each { |arr|
	@final_list_sp << arr
	}
	@t.spelling[0].each { |value|
	    @final_list_sp << value
	}
	@t.spelling[1].each { |value|
	    @final_list_sp << value
	}
	@t.spelling[2].each { |value|
	    @final_list_sp << value
	}
	@t.context[0].each { |value|
	    @final_list_c << value
	}
	@t.context[1].each { |value|
	    @final_list_c << value
	}
	@t.context[2].each { |value|
	    @final_list_c << value
	}

    end

    def apply_to_test
	@trainer_arr.each { |instance|
	    @final_list_sp.each { |rule|
		if(instance.np.include?(rule[0].to_s) && instance.label == "NONE")
		    instance.label = rule[1]
		end
	    }
	    @final_list_c.each { |rule|
		if(instance.context.include?(rule[0].to_s) && instance.label == "NONE")
		    instance.label = rule[1]
		end
	    }
	}
    end
end
