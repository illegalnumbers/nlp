class Trainer
    attr_accessor :corpus, :freq, :bifreq, :trifreq

    def initialize(training_file)
	@corpus = []
	@freq = Hash.new(0) 
	@bifreq = Hash.new(0) 
	@trifreq = Hash.new(0) 
	c = 0
	File.open(training_file, mode="r").each_line { |sentence|
	    sentence.upcase! 
	    freq['PHI'] += 1
	    @corpus[c] = sentence.split(" ") 
	    @corpus[c].each { |word| freq[word] += 1}
	    c+=1 
	}
	bigram_count()
	trigram_count()
    end
    
    def word_count()
	count = 0
	@freq.each { |key,value|
    #the start of sentence marker is not being counted as a word
	 if(key != "PHI")
  	   count += value
	 end}
	return count 
    end
    def vocab_count()
    count = 0
    @freq.each { |key, value|
	count += 1 }
    #somethings up with phi, gotta subtract one from the vocab?
    return count-1
    end
   
    #gets c(word_2 | word_1) 
    def bigram_count()
	@corpus.each { |sentence_arr|
	    prev_word = ""
	    sentence_arr.each { |word|
		if(prev_word != "")
		  @bifreq[prev_word + " " + word] += 1
		else
		  @bifreq["PHI "+word] += 1
		end   	    	
		prev_word = word
	    }
	}
    end

    
    #gets c(word_3 | word_1 word_2) 
    def trigram_count()
	@corpus.each { |sentence_arr|
	    prev_word_1 = ""
	    prev_word_2 = ""
	    sentence_arr.each { |word|
		if(prev_word_1 != "" && prev_word_2 != "")
		 @trifreq[prev_word_1 + " " + prev_word_2 + " " + word] += 1
		elsif(prev_word_1 == "" && prev_word_2 != "")
		 @trifreq["PHI "+prev_word_2+" "+word] += 1
		elsif(prev_word_1 == "" && prev_word_2 == "")
		 @trifreq["PHI PHI "+word] += 1	
		end   	    	
		prev_word_1 = prev_word_2 
		prev_word_2 = word
	    }
	}
    end
end
