#trainer will be tested here
require 'trainer'
require 'bigdecimal'
require 'pry'

describe Trainer do
    before :each do
	#setup
	seed_file = "files/official-seedrules.txt"
	trainer_file = "files/official-train-data.txt"
	@trainer = Trainer.new(seed_file, trainer_file)
	@trainer.build
    end

    describe "new" do
	it "should require parameters seed-file,trainer-file" do
	    @trainer.should_not == nil
	end
    end

    describe "official trainer" do
	it "should have the right data for the seed [type,prob, freq]" do
	    @trainer.seed['Ltd'].should == ['ORGANIZATION',BigDecimal.new('-1.000'),-1] 
	    @trainer.seed['Corp'].should == ['ORGANIZATION',BigDecimal.new('-1.000'),-1] 
	    @trainer.seed['John'].should == ['PERSON',BigDecimal.new('-1.000'),-1] 
	    @trainer.seed['David'].should == ['PERSON',BigDecimal.new('-1.000'),-1] 
	    @trainer.seed['Japan'].should == ['LOCATION',BigDecimal.new('-1.000'),-1] 
	    @trainer.seed['City'].should == ['LOCATION',BigDecimal.new('-1.000'),-1] 
	end

	context "should build the right data from the official trainer" do
	    it "should generate the iterations after build" do
		@trainer.context[0].should_not == nil
		@trainer.context[1].should_not == nil
		@trainer.context[2].should_not == nil
		@trainer.spelling[0].should_not == nil
		@trainer.spelling[1].should_not == nil
		@trainer.spelling[2].should_not == nil
	    end

	    it "should have the right info for the first context iteration" do
		binding.pry	
		@trainer.context[0][0].should == ['LOCATION',BigDecimal.new('1.000'), 11]
	#	@trainer.context[0]['capital'].should == ['LOCATION',BigDecimal.new('1.000'), 11]
	#	@trainer.context[0]['merger'].should == ['ORGANIZATION',BigDecimal.new('1.000'), 10]
	#	@trainer.context[0]['acquisition'].should == ['ORGANIZATION',BigDecimal.new('1.000'), 7]
	#	@trainer.context[0]['chairman'].should == ['PERSON',BigDecimal.new('1.000'), 7]
	#	@trainer.context[0]['president'].should == ['PERSON',BigDecimal.new('.833'), 12]
	    end

	    it "should have the right info for the first spelling iteration" do
		@trainer.spelling[0]['Yuri'].should == ['PERSON', BigDecimal.new('1.000'), 12]
		@trainer.spelling[0]['Alexander'].should == ['PERSON', BigDecimal.new('1.000'), 8]
		@trainer.spelling[0]['Tokyo'].should == ['LOCATION', BigDecimal.new('1.000'), 8]
		@trainer.spelling[0]['Inc'].should == ['ORGANIZATION', BigDecimal.new('1.000'), 7]
		@trainer.spelling[0]['Chechnya'].should == ['LOCATION',BigDecimal.new('1.000'), 6]
		@trainer.spelling[0]['Morgan'].should == ['ORGANIZATION', 1.000, 5]
	    end

	    it "should have the right info for the second context iteration" do
		@trainer.context[1]['force'].should == ['LOCATION',BigDecimal.new('1.000'), 15]
		@trainer.context[1]['company'].should == ['ORGANIZATION',BigDecimal.new('1.000'), 14]
		@trainer.context[1]['subsidiary'].should == ['ORGANIZATION',BigDecimal.new('1.000'), 9]
		@trainer.context[1]['troops'].should == ['LOCATION',BigDecimal.new('1.000'), 8]
		@trainer.context[1]['head'].should == ['PERSON',BigDecimal.new('.800'),5]
	    end

	    it "should have the right info for the second spelling iteration" do
		@trainer.spelling[1]['Vishnevsky'].should == ['PERSON',BigDecimal.new('1.000'), 8]
		@trainer.spelling[1]['Rutskoi'].should == ['PERSON',BigDecimal.new('1.000'), 7]
		@trainer.spelling[1]['Grozny'].should == ['LOCATION',BigDecimal.new('1.000'), 6]
		@trainer.spelling[1]['Stanley'].should == ['ORGANIZATION',BigDecimal.new('1.000'), 6]
		@trainer.spelling[1]['Group'].should == ['ORGANIZATION',BigDecimal.new('1.000'), 5]
		@trainer.spelling[1]['Palestinian'].should == ['LOCATION',BigDecimal.new('1.000'), 5]
	    end 

	    it "should have the right info for the third context iteration" do
		@trainer.context[2]['bombing'].should == ['LOCATION',BigDecimal.new('1.000'), 20]
		@trainer.context[2]['northwest'].should == ['LOCATION',BigDecimal.new('1.000'), 16]
		@trainer.context[2]['stake'].should == ['ORGANIZATION',BigDecimal.new('1.000'), 16]
		@trainer.context[2]['aerospace'].should == ['ORGANIZATION',BigDecimal.new('1.000'), 5]
	    end

	    it "should have the right info for the third spelling iteration" do
		@trainer.spelling[1]['Yeltsin'].should == ['PERSON', BigDecimal.new('1.000'), 7]
		@trainer.spelling[1]['William'].should == ['PERSON', BigDecimal.new('1.000'), 6]
		@trainer.spelling[1]['Attwoods'].should == ['ORGANIZATION',BigDecimal.new('1.000'), 5]
		@trainer.spelling[1]['Lockheed'].should == ['ORGANIZATION',BigDecimal.new('.889'), 9]
		@trainer.spelling[1]['Kansas'].should == ['LOCATION',BigDeciaml.new('.824'), 17]
	    end

	end

    end

    describe "test trainer" do
	it "should build the right data from a test trainer" do
	
	end

    end

end
