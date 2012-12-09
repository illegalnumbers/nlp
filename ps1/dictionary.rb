class Dictionary
    attr_accessor :items

    def initialize(filename)
	@items = {}
	File.open(filename, mode="r").each_line { |sentence|
	    sentence.upcase! 
	    arr = sentence.split(" ")
	    key = arr[0]
	    val = arr[1]
	    if @items[key].nil?
		@items[key] = [val]
	    else
		@items[key] << val
	    end	
	}
    end

    def parts_of_speech
	ret = []
	@items.each do |k, v|
	    v.each do |i|
	    ret << i unless ret.include? i
	    end 	
	end
	ret.each do |v|
	    v.upcase!	
	end
    end

end
