#output will be tested here
require 'trainer'
require 'bootstrap'
require 'output'

describe Output do
    before :each do
	#setup
	@output = []
	@test_output = []
	official_train_file = "files/official-train-data.txt"
	test_train_file = "files/test-train-data.txt"
	official_seed_file = "files/official-seedrules.txt"
	test_seed_file = "files/test-seedrules.txt"

	off_t = Trainer.new(official_seed_file,official_train_file)
	test_t = Trainer.new(test_seed_file,test_train_file)

	official_test_file = "files/official-test-data.txt" 
	test_test_file = "files/test-test-data.txt" 
	off_b = Bootstrap.new(official_test_file,off_t)
	test_b = Bootstrap.new(test_test_file,test_t)
	
	@off_o = Output.new(off_b)
	@test_o = Output.new(test_b) 

	official_trace_match = "files/official-trace.txt"
	#setup the output trace array to match the output to
	File.open(official_trace_match, "r") do |file|
	    file.each_line { |line|
		@output << line
	    }
	end
	
	test_trace_match = "files/test-trace.txt"
	#setup the output trace array to match the output to
	File.open(test_trace_match, "r") do |file|
	    file.each_line { |line|
		@test_output << line
	    }
	end
    end

    describe "new" do
	it "takes in parameters and can be constructed" do
	    @off_o.is_a?(Output).should == true	    
	    @off_o.is_a?(Output).should == true	    
	end
    end

    describe "official trace" do
	it "should match the official trace output" do
	    @off_o.output.should_not == nil 
	    @off_o.output[0].should_not == nil 
	    @off_o.output[0].should == "SEED DECISION LIST"
 
	    @off_o.output.each_index{ |i|
		@off_o.output[i].should == @output[i]
	    }
	end
    end

    describe "test trace" do
	it "should match trace as expected from the test trace" do
	    @test_o.output.should_not == nil 
	    @test_o.output[0].should_not == nil 
	    @test_o.output[0].should == "SEED DECISION LIST"
 
	    @test_o.output.each_index{ |i|
		@test_o.output[i].should == @output[i]
	    }

	end
    end
end
