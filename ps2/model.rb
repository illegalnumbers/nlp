#this is the language model generator
require "trainer"
require "bigdecimal"

class Model
    attr_accessor :frequency_tables
 
    def initialize(trainer, test_file)
	@trainer = trainer
	@frequency_tables = []
	@frequency_tables[0] = trainer.corpus
	@frequency_tables[1] = trainer.freq
	@frequency_tables[2] = trainer.bifreq
	@frequency_tables[3] = trainer.trifreq
	@frequency_tables[4] = trainer.word_count()
	@frequency_tables[5] = trainer.vocab_count()
    end

    def unigram_count(string)
	string.upcase!
	return @frequency_tables[1][string]
    end
    def bigram_count(string)
	string.upcase!
	return @frequency_tables[2][string]
    end
    def trigram_count(string)
	string.upcase!
	return @frequency_tables[3][string]
    end
    
    def round(float)
	return ((float * 10000).round.to_f) / 10000	
    end

    def process_unigram(sentence)
	probability = BigDecimal.new("1") 
	sen_arr = sentence.split(" ")
	sen_arr.each { |word|
	#  binding.pry
	  probability *= (BigDecimal.new(unigram_count(word).to_s()) / BigDecimal.new(@frequency_tables[4].to_s())) 
	}
	unless probability.eql? 0
	    val= ((Math.log(probability)/Math.log(2))) 
	    return retval = round(val)	
	end
	return "undefined" 
    end

    def process_bigram(sentence)
	probability = BigDecimal.new("1")
	sen_arr = sentence.split(" ")
	for i in (0..(sen_arr.length-1))
	  unless i == 0
	  denom = BigDecimal.new(unigram_count(sen_arr[i-1]).to_s())/BigDecimal.new(@frequency_tables[4].to_s())
	    unless denom.eql? 0
	      probability *= (BigDecimal.new(bigram_count(sen_arr[i-1]+" "+sen_arr[i]).to_s()) / BigDecimal.new(@frequency_tables[4].to_s()))/denom  
	     else
	      probability = 0
	     end
	  else
	  probability *= (BigDecimal.new(bigram_count("PHI "+sen_arr[i]).to_s()) / BigDecimal.new(@frequency_tables[4].to_s())) / (BigDecimal.new(unigram_count("PHI").to_s())/BigDecimal.new(@frequency_tables[4].to_s()))   
	  end
	end
	unless probability.eql? 0
	    val= ((Math.log(probability)/Math.log(2))) 
	    retval = round(val)	
	    return retval
	end
	return "undefined"
    end

    def process_trigram(sentence)
	probability = BigDecimal.new("1")
	sen_arr = sentence.split(" ")
	for i in (0..(sen_arr.length-1))
	  if i >= 2
	  denom = (BigDecimal.new(bigram_count(sen_arr[i-2]+" "+sen_arr[i-1]).to_s()))
	      unless denom.eql? 0
		  probability *= (BigDecimal.new(trigram_count(sen_arr[i-2]+" "+sen_arr[i-1]+" "+sen_arr[i]).to_s()))/denom   
	      else
		probability *= 0
	      end
	  elsif i == 1
	  denom = (BigDecimal.new(bigram_count("PHI "+sen_arr[i-1]).to_s()))
	      unless denom.eql? 0
	      probability *= (BigDecimal.new(trigram_count("PHI "+sen_arr[i-1]+" "+sen_arr[i]).to_s()))/denom  
	      else
	      probability = 0
	      end
	  else
	  probability *= (BigDecimal.new(trigram_count("PHI PHI "+sen_arr[i]).to_s())) / (BigDecimal.new(unigram_count("PHI").to_s()))   
	  end
	end
	unless probability.eql? 0 
	    val= ((Math.log(probability)/Math.log(2))) 
	    retval = round(val)	
	    return retval
	end
	return "undefined"
    end
    
    def process_smooth_bigram(sentence)
	probability = BigDecimal.new("1")
	sen_arr = sentence.split(" ")
	for i in (0..(sen_arr.length-1))
	  unless i == 0
	  bigram_c = bigram_count(sen_arr[i-1]+" "+sen_arr[i])+1
	  ugram_c = unigram_count(sen_arr[i-1])+@frequency_tables[5]
	  probability *= (BigDecimal.new(bigram_c.to_s()))/(BigDecimal.new(ugram_c.to_s()))   
	  else
	  probability *= (BigDecimal.new((bigram_count("PHI "+sen_arr[i])+1).to_s())) / (BigDecimal.new((unigram_count("PHI")+@frequency_tables[5]).to_s()))   
	  end
	end
	unless probability.eql? 0
	    val= ((Math.log(probability)/Math.log(2))) 
	    retval = round(val)	
	    return retval
	end
	return "undefined"
    end

    def process_smooth_trigram(sentence)
	probability = BigDecimal.new("1")
	sen_arr = sentence.split(" ")
	for i in (0..(sen_arr.length-1))
	  if i >= 2
	  denom = (BigDecimal.new((bigram_count(sen_arr[i-2]+" "+sen_arr[i-1])+@frequency_tables[5]).to_s()))
	  probability *= (BigDecimal.new((trigram_count(sen_arr[i-2]+" "+sen_arr[i-1]+" "+sen_arr[i])+1).to_s()))/denom   
	  elsif i == 1
	  denom = (BigDecimal.new((bigram_count("PHI "+sen_arr[i-1])+@frequency_tables[5]).to_s()))
	  probability *= (BigDecimal.new((trigram_count("PHI "+sen_arr[i-1]+" "+sen_arr[i])+1).to_s()))/denom  
	  else
	  probability *= (BigDecimal.new((trigram_count("PHI PHI "+sen_arr[i])+1).to_s())) / (BigDecimal.new((unigram_count("PHI")+@frequency_tables[5]).to_s()))   
	  end
	end
	unless probability.eql? 0 
	    val= ((Math.log(probability)/Math.log(2))) 
	    retval = round(val)	
	    return retval
	end
	return "undefined"
    end
end
