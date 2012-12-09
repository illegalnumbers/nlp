require "machine"
require "dictionary"
require "motorcollection"
require "pry"

describe "NLP Project" do
  context Machine do
    context "simplest machine" do
      before :each do
        dictionary_name = "files/dictionary.txt"
        spec_name = "files/rtn_spec.txt"
        @my_machine = Machine.new(dictionary_name, spec_name)
      end

      it "should reject invalid sentences" do
        sentence = "john ."
	sentence.upcase!
        output = @my_machine.parse sentence.clone
        output[0].should == "PROCESSING SENTENCE : #{sentence}\n"
	binding.pry
        output[1].should == "\n"
        output[2].should == "Done! Found 0 parse(s).\n"
      end

      it "should not accept invalid tokens" do
        sentence = "garbage ."
	sentence.upcase!
        output = @my_machine.parse sentence.clone
        output[0].should == "PROCESSING SENTENCE : #{sentence}\n"
        output[1].should == "\n"
        output[2].should == "Done! Found 0 parse(s).\n"
      end
    end

    context "parse a test file" do
	before :each do
	   dictionary_name = "files/dictionary.txt"
	   spec_name = "files/rtn_spec_1.txt"
	   @my_machine = Machine.new(dictionary_name, spec_name)
	   @output = []
	 end

	it "should process a file" do
	   test_file = "files/test_1.txt"
	   output = @my_machine.parse('john .') 	
	   output[0].should == "PROCESSING SENTENCE : john .\n"
	   output[1].should == "\n"
	   output[2].should == "SUCCESSFUL PARSE\n"
	   output[3].should == "S0 - NOUN(JOHN) -> S1"
	   output[4].should == "S1 (ACCEPT)"
	   output[5].should == "\n"
	   output[6].should == "Done! Found 1 parse(s).\n"
	end

	it "should process a complex file" do
	    @my_machine = Machine.new("files/dictionary.txt","files/rtn_spec.txt") 
	    output = @my_machine.parse('john walks .') 	
		binding.pry  
	   
	   output[0].should == "PROCESSING SENTENCE : john walks .\n"
	   output[1].should == "\n"
	   output[2].should == "SUCCESSFUL PARSE\n"
	   output[3].should == "S0 - NP -> S1"
	   output[4].should == "NP0 - NOUN(JOHN) -> NP2"
	   output[5].should == "S1 - VP -> S2"
	   output[6].should == "VP0 - VERB(WALKS) -> VP1"
	   output[7].should == "S2 (ACCEPT)"
	   output[8].should == "\n"
	   output[9].should == "Done! Found 1 parse(s).\n"
	end
	
	it "should process an embedded clause" do
	    @my_machine = Machine.new("files/dictionary.txt","files/rtn_spec.txt") 
	    output = @my_machine.parse('the trees walks .') 	
		binding.pry  
	   output[0].should == "PROCESSING SENTENCE : the trees walks .\n"
	   output[1].should == "\n"
	   output[2].should == "SUCCESSFUL PARSE\n"
	   output[3].should == "S0 - NP -> S1"
	   output[4].should == "NP0 - ART(THE) -> NP1"
	   output[5].should == "NP1 - NOUN(TREES) -> NP2"
	   output[6].should == "S1 - VP -> S2"
	   output[7].should == "VP0 - VERB(WALKS) -> VP1"
	   output[8].should == "S2 (ACCEPT)"
	   output[9].should == "\n"
	   output[10].should == "Done! Found 1 parse(s).\n"
	end
	
	it "should process an ambiguous embedded clause" do
	    @my_machine = Machine.new("files/dictionary.txt","files/rtn_spec.txt") 
	    output = @my_machine.parse('john like pears .') 	
		#binding.pry  
	   output[0].should == "PROCESSING SENTENCE : john like pears .\n"
	   output[1].should == "\n"
		binding.pry
	   output[2].should == "SUCCESSFUL PARSE\n"
	  # output[3].should == "S0 - NOUN(JOHN) -> S1"
	  # output[4].should == "S1 (ACCEPT)"
	  # output[5].should == "Done! Found 1 parse(s).\n"
	end
	
	it "should process another rtn specification" do
	   test_file = "files/test_1.txt"
	   @my_machine = Machine.new("files/dictionary.txt","files/rtn_spec_3.txt")
	   output = @my_machine.parse('john .') 	
	   output[0].should == "PROCESSING SENTENCE : john .\n"
	   output[1].should == "\n"
	   output[2].should == "SUCCESSFUL PARSE\n"
	   output[3].should == "S0 - NP -> S1"
	   output[4].should == "NP0 - NOUN(JOHN) -> NP1"
	   output[5].should == "S1 (ACCEPT)"
	   output[6].should == "\n"
	   output[7].should == "Done! Found 1 parse(s).\n"
	end

	it "should produce correct output for invalid parse" do
        sentence = "garbage ."
	sentence.upcase!
        @output = @my_machine.parse sentence.clone
        @output[0].should == "PROCESSING SENTENCE : #{sentence}\n"
        @output[1].should == "\n"
        @output[2].should == "Done! Found 0 parse(s).\n"
	end
    end 
  end

  context Dictionary do
    context "simplest dictionary" do
      before :each do
        filename = "files/dictionary.txt"
        @dictionary = Dictionary.new(filename)
      end

      it "should load all tokens from dictionary file" do
        @dictionary.items.length.should == 12
      end

      it "should get the pos tag for a token with 1 pos" do
        @dictionary.items['JOHN'].length.should == 1
      end

      it "should get all token pos tags for ambiguous words" do
        @dictionary.items['FLIES'].length.should == 2
        @dictionary.items['LIKE'].length.should == 2
        @dictionary.items['WALKS'].length.should == 2
        @dictionary.items['DOG'].length.should == 2
      end

      describe "pos tagging" do
        it "should recognize the correct pos tags for the dictionary" 
      end
    end
 
    context MotorCollection do
	before :each do
	    filename = "files/rtn_spec.txt"
	    @m_collection = MotorCollection.new(filename)	
	end
	it "should read in a collection of motors" do
	    @m_collection.length.should == 4
	end
    
	it "should have an 'S' motor" do
	    @m_collection.motors['S'].should_not == nil	
	end

	it "should have the correct initial state for 'S' " do
	    @m_collection.motors['S'].init_state.should == 'S0'
	end
	it "should have the correct final state for 'S' " do
	    @m_collection.motors['S'].fin_states.should == ['S2']
	end
	it "should have the correct arcs for 'S' " do
	    arcs = ["S0 NP S1", "S1 VP S2"] 
	    @m_collection.motors['S'].arcs.should == arcs 
	end
	
	it "should have the 'NP' motor " do
	    @m_collection.motors['NP'].should_not == nil	
	end
	it "should have the correct initial states for 'NP' " do
	    @m_collection.motors['NP'].init_state.should == 'NP0'
	end
	it "should have the correct final states for 'NP' " do
	    @m_collection.motors['NP'].fin_states.should == ['NP2','NP3']
	end
	it "should have the correct arcs for 'NP' " do
	    arcs = ["NP0 ART NP1", "NP0 ADJ NP1", "NP1 NOUN NP2",
		    "NP2 NOUN NP2", "NP0 NOUN NP2", "NP2 PP NP3"] 
	    @m_collection.motors['NP'].arcs.should == arcs 
	end
	
	it "should have the 'VP' motor" do
	    @m_collection.motors['VP'].should_not == nil	
	end
	it "should have the correct initial state for 'VP'" do
	    @m_collection.motors['VP'].init_state.should == 'VP0'
	end
	it "should have the correct final state for 'VP'" do
	    @m_collection.motors['VP'].fin_states.should == ['VP1','VP2','VP3','VP4']
	end
	it "should have the correct arcs for 'VP'" do
	    arcs = ['VP0 VERB VP1', 'VP1 PP VP2',
		    'VP1 NP VP3', 'VP3 PP VP4'] 
	    @m_collection.motors['VP'].arcs.should == arcs 
	end

	it "should have the 'PP' motor" do
	    @m_collection.motors['PP'].should_not == nil	
	end
	it "should have the correct initial state for 'PP'" do
	    @m_collection.motors['PP'].init_state.should == 'PP0'
	end
	it "should have the correct final state for 'PP'" do
	    @m_collection.motors['PP'].fin_states.should == ['PP2']
	end
	it "should have the correct arcs for 'PP'" do
	    arcs = ['PP0 PREP PP1', 'PP1 NP PP2'] 
	    @m_collection.motors['PP'].arcs.should == arcs 
	end
    end
    it "should catch whitespace that isn't spaces" 
    it "should do CaSe testing"
  end
end
