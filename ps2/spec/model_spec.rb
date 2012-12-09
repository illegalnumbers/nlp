require "../model"
require "pry"

describe Model do
    before :each do
	trainer_file = "../files/official-training.txt"
	test_file = "../files/official-test.txt"
	t = Trainer.new(trainer_file)
	@m = Model.new(t, test_file)
    end

    it "should generate tables of frequency counts from the trainer" do
	@m.frequency_tables.should_not == nil	
    end

    it "should generate unigram counts" do
	@m.frequency_tables[1].should_not == nil
    end

    it "should generate bigram counts" do
	@m.frequency_tables[2].should_not == nil
    end
    it "should generate trigram counts" do
	@m.frequency_tables[3].should_not == nil
    end

    it "should not cross sentence boundaries" 

    it "should be case-insensitive for unigram counts" do
    	@m.unigram_count('wolf').should ==
	@m.unigram_count('WOLF')
    end
    it "should be case-insensitive for bigram counts" do
	@m.bigram_count('spread wolf').should ==
	@m.bigram_count('SPREAD WOLF')
    end
    it "should be case-insensitive for trigram counts" do
	@m.trigram_count('Norwegians spread wolf').should ==
	@m.trigram_count('NORWEGIANS SPREAD WOLF')
    end
    it "should create a bigram model with add-one smoothing" do
	@m.frequency_tables[4].should_not == nil
    end
    it "should create a trigram model with add-one smoothing" do
	@m.frequency_tables[5].should_not == nil
    end
    it "should handle test sentences that countain bigrams and trigrams not present in the trainer" do
	@m.process_unigram("adjfk fdja k").should == "undefined"
	@m.process_bigram("adjfk fdja k").should == "undefined"	
	@m.process_trigram("adjfk fdja k").should == "undefined"
    end
    it "should produce the correct unigram results" do
	#@m.process_unigram("Wolf").should == -10.6569
	@m.process_unigram("Widespread panic").should == -26.9286
	@m.process_unigram("I don't trust horses .").should == -42.7229
	@m.process_unigram("I swear I am not making this up .").should == -74.1429
	@m.process_unigram("Never forget your froggy .").should == -51.1322
	@m.process_unigram("Little did I know that a treacherous lizard addressed 300,000 scientists .").should == -119.3167 
    end
    it "should produce the correct bigram results" do
	@m.process_bigram("Wolf").should == "undefined" 
	@m.process_bigram("Widespread panic").should == "undefined" 
	@m.process_bigram("I don't trust horses .").should == -15.1491
	@m.process_bigram("I swear I am not making this up .").should == -28.6793
	@m.process_bigram("Never forget your froggy .").should == "undefined" 
	@m.process_bigram("Little did I know that a treacherous lizard addressed 300,000 scientists .").should == "undefined"
    
    end
    it "should produce the correct trigram results" do
	@m.process_trigram("Wolf").should == "undefined" 
	@m.process_trigram("Widespread panic").should == "undefined" 
	@m.process_trigram("I don't trust horses .").should == -9.4097
	@m.process_trigram("I swear I am not making this up .").should == -13.2170
	@m.process_trigram("Never forget your froggy .").should == "undefined" 
	@m.process_trigram("Little did I know that a treacherous lizard addressed 300,000 scientists .").should == "undefined"
    end
    it "should produce the correct addone bigram results" do
	@m.process_smooth_bigram("Wolf").should == -11.6799 
	@m.process_smooth_bigram("Widespread panic").should == -22.1067 
	@m.process_smooth_bigram("I don't trust horses .").should == -45.0726
	@m.process_smooth_bigram("I swear I am not making this up .").should == -80.6216
	@m.process_smooth_bigram("Never forget your froggy .").should == -56.3991 
	@m.process_smooth_bigram("Little did I know that a treacherous lizard addressed 300,000 scientists .").should == -133.7532
    end
    it "should produce the correct addone trigram results" do
	@m.process_smooth_trigram("Wolf").should == -11.6799 
	@m.process_smooth_trigram("Widespread panic").should == -23.1062 
	@m.process_smooth_trigram("I don't trust horses .").should == -45.9218
	@m.process_smooth_trigram("I swear I am not making this up .").should == -83.6032
	@m.process_smooth_trigram("Never forget your froggy .").should == -56.3855
	@m.process_smooth_trigram("Little did I know that a treacherous lizard addressed 300,000 scientists .").should == -137.3720
    end

end
