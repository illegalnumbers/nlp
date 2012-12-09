require "model"
require "trainer"

describe "The model should produce correct output" do
    before :each do
	trainer-file = "../files/official-training.txt"
	t = Trainer.new(trainer-file)
	m = Model.new(t) 
	m.process_trainer   
    end

    it "should print the correct info for each test sentence" do
	m.process_sentence "The dog walks ."
	m.output.should == "S = The dog walks .\nUnigrams: logprob(S) = \nBigrams: logprob(S) =  \nTrigrams: logprob(S) = \nSmoothed Bigrams: logprob(S)= \nSmoothed Trigrams: logprob(S) =  "			
    end
    
    it "should produce the correct info for sentences without unigrams" do
	m.process_sentence "The dwarf walks ."
	m.output.should == "S = The dwarf walks .\nUnigrams: logprob(S) = \nBigrams:logprob(S) = \nTrigrams: logprob(S) = \nSmoothed Bigrams: logprob(S)= \nSmoothed Trigrams: logprob(S) = "
    end
    
    it "should produce the correct info for sentences without bigrams" do
	m.process_sentence "Smur dwarf walks ."
	m.output.should == "S = Smur dwarf walks .\nUnigrams: logprob(S) = \nBigrams:logprob(S) = \nTrigrams: logprob(S) = \nSmoothed Bigrams: logprob(S)= \nSmoothed Trigrams: logprob(S) = "
    end

    it "should produce the correct info for sentences without trigrams" do
	m.process_sentence "Smur dwarf ks around ."
	m.output.should == "S = Smur dwarf ks around .\nUnigrams: logprob(S) = \nBigrams:logprob(S) = \nTrigrams: logprob(S) = \nSmoothed Bigrams: logprob(S)= \nSmoothed Trigrams: logprob(S) = "
    end

    it "should produce the correct info for sentences without any available corpus data" do
	m.process_sentence "Smur dwarf ks ."
	m.output.should == "S = Smur dwarf ks .\nUnigrams: logprob(S) = \nBigrams:logprob(S) = \nTrigrams: logprob(S) = \nSmoothed Bigrams: logprob(S)= \nSmoothed Trigrams: logprob(S) = "
    end

end
