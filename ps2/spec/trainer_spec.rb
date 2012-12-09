require "trainer"

describe Trainer do
    before :each do
	trainer_file = "files/official-training.txt"
	@t = Trainer.new(trainer_file) 
    end

    it "should process a file" do
	@t.corpus.should_not == nil	
    end

    it "should process a seperate file" do
	t = Trainer.new("files/test-training.txt");
	t.corpus.should_not == nil
    end

    #each sentence in the corpus should be an entry in the array, with those
    #arrays being of the unigrams of the sentence
    it "should process a seperate file correctly" do
	t = Trainer.new("files/test-training.txt");
	t.corpus[0].should be_kind_of(Array) 
	t.corpus[0][0].should == "The"
	t.corpus[0][1].should == "cat"
	t.corpus[0][2].should == "ran"
	t.corpus[0][3].should == "."
    end

    it "should divide each sentence into unigrams based soley on white space" do
	@t.corpus[0].should be_kind_of(Array)
	@t.corpus[0][0].should == "In"
	@t.corpus[0][1].should == "college"
	@t.corpus[0][2].should == "football"
	@t.corpus[0][3].should == "action"
    end

    it "should produce isolated punctuation marks" do
	@t.corpus[0][4].should == ","
    end

    it "should return the array of words and punctuation" do
	@t.corpus[0].should be_kind_of(Array)
	@t.freq.include?("college").should == true
	@t.freq.include?(",").should == true
	@t.freq.include?(".").should == true
    end

    it "should provide total word count for the training file" do
	@t.word_count.should == 11302
    end

    it "should provide total word count for the simplistic training file" do
	t = Trainer.new("files/test-training.txt");
	t.word_count.should == 15
    end
    
    it "should provide total line count for the training file" do
	@t.corpus.count.should == 529 
    end

    it "should provide specific word count for the training file" do
	@t.freq['cats'].should == 1
	@t.freq['dwarf'].should == 0 
    end
end
