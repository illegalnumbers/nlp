#this will be the trainer class
require 'bigdecimal'

class Instance
    attr_accessor :np, :context, :label, :prob
    def initialize(_np, _context, _label)
	@np = _np
	@context = _context
	@label = _label
    end
end

class Handler
    def initialize(_seeds)
	@total_count = 1
	@class_counts = {}
	@seeds = _seeds
    end

    def inc_class(_class)
	if(!@seeds.keys.include?(_class))
	    unless(@class_counts[_class] == nil)
		 @class_counts[_class] += 1
	    else
		 @class_counts[_class] = 1
	    end
	end
    end

    def increment
	@total_count += 1
    end
    #prob is with these ret functions giving oddly dif return
    #values i believe 
    def ret_max
	max = ["init", 0]
	@class_counts.each { |key,value|
	    if(max[1] < value)
		max = [key, value]
#	    elsif((max[1] == value) && (max[0] != "init" && max[0] < key[0]))
		max = [key, value] 
	    end
	}	
	return max
    end

    def ret_max_prob
	max = BigDecimal.new(ret_max()[1].to_s)
	count = BigDecimal.new(@total_count.to_s)
	prob = max / count 
	return prob
    end
end

class Trainer 
    attr_accessor :spelling, :context, :seed
  
    def initialize(seed_file,trainer_file)
	@seed = Hash.new
	@spelling = Array.new(4, Array.new)
	@context = Array.new(3, Array.new)
	#get the seed file
	File.open(seed_file,'r') do |file|
	    file.each_line do |line|
		split_str = line.split(/[()]/)
		word = split_str[1]
		type = split_str[2].split('>')[1].strip
		#initialize the seed
		seed[word] = [type, BigDecimal.new('-1.000'), -1]
	    end
	end

	@trainer_arr = [] 
	context = ""
	np = ""
	#get the trainer file
	File.open(trainer_file,'r') do |file|
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
    end
    
    def build
	#label for seed
	@trainer_arr.each { |instance|
	    @seed.each { |key,value|
	        if(instance.np.include?(key))
		    instance.label = value[0]	 
		end
	    }	
	 }
        
	 #induce decision should return the next set of rules
	(0..2).each { |i| 
	 temp_co_dlist = induce_decision("CONTEXT")
	 @context[i] = get_best_rules(temp_co_dlist)
	 
	 @trainer_arr.each { |instance|
	    @context.each { |arr|
		arr.each { |sub_arr|
		if(instance.context.include?(sub_arr[0]) && instance.label=="NONE")
		    instance.label = arr[0]
		end
	      }
	    }
	 }	
    
	temp_sp_dlist = induce_decision("SPELLING")
	@spelling[i] = get_best_rules(temp_sp_dlist)

	 @trainer_arr.each { |instance|
	    @spelling.each { |arr|
		arr.each { |sub_arr|
		if(instance.np.include?(sub_arr[0]) && instance.label=="NONE")
		    instance.label = arr[0]
		end
	      }
	    }
	 }	
       } 
	#label the seed instances
    end

    def get_best_rules(dlist)
	#dlist.each { |possible_d|
	#key, type, prob, freq
	#}
	org = []
	per = []
	loc = []
	dlist.each { |arr|
	   if(arr[1] == "ORGANIZATION")
	     if(org.length > 1)	
		org.each{ |past|
		   if(arr[2] > past[2])
		    past = arr
		   end
		   if((arr[2] == past[2]))
		     if(arr[3] > past[3])
			past = arr
		     elsif(arr[3] == past[3] && arr[0] > past [0])
			past = arr	
		     end 
		   end
		}
	      else
	        org << arr	
	      end
	   elsif(arr[1] == "PERSON")
	     if(per.length > 1)	
		per.each{ |past|
		   if(arr[2] > past[2])
		    past = arr
		   end
		   if((arr[2] == past[2]))
		     if(arr[3] > past[3])
			past = arr
		     elsif(arr[3] == past[3] && arr[0] > past [0])
			past = arr	
		     end 
		   end
		}
	      else
	        per << arr	
	      end
	   elsif(arr[1] == "LOCATION")
	     if(loc.length > 1)	
		loc.each{ |past|
		  if(arr[2] > past[2])
		    past = arr
		   end
		   if((arr[2] == past[2]))
		     if(arr[3] > past[3])
			past = arr
		     elsif(arr[3] == past[3] && arr[0] > past [0])
			past = arr	
		     end 
		   end
		}
	      else
	        loc << arr	
	      end
	
	   end 
	}
	return_arr = org + loc + per

	return return_arr.sort!
    end

    def induce_decision(type)
	#min prob .80
	#min freq 5
	#sort by frequency

	handlers = {}
	return_array = []
	if(type == "CONTEXT")
	#context rule learning
	  @trainer_arr.each { |instance|
	    instance.context.split(" ").each{ |context|
		 if(instance.label != "NONE")
		    if(handlers[context] != nil)
			handlers[context].increment
			handlers[context].inc_class(instance.label)
		    else
			handlers[context] = Handler.new(@seed)
			handlers[context].inc_class(instance.label) 
		    end 
		 end
	    } 
	   }
	   handlers.each { |key,value|
		max_ret = value.ret_max 
		prob = value.ret_max_prob
		unless(max_ret[1] < 5 || prob < BigDecimal.new('.80'))
		    return_array << [key,max_ret[0], prob, max_ret[1]]
		end
	   }
	else
	#NP rule learning	
	  @trainer_arr.each { |instance|
	    instance.np.split(" ").each{ |np|
		 if(instance.label != "NONE")
		    if(handlers[np] != nil)
			handlers[np].increment
			handlers[np].inc_class(instance.label)
		    else
			handlers[np] = Handler.new(@seed)
			handlers[np].inc_class(instance.label) 
		    end 
		 end
	    } 
	   }
	   handlers.each { |key,value|
		max_ret = value.ret_max 
		prob = value.ret_max_prob
		unless(max_ret[1] < 5 || prob < BigDecimal.new('.80'))
		    return_array << [key,max_ret[0], prob, max_ret[1]]
		end
	   }
	end
	return return_array
    end
end
