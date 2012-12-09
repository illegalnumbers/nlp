#this will be the output class
require 'bootstrap'

class Output 
    attr_accessor :output
  
    def initialize(_bootstrap) 
	bootstrap = _bootstrap
	@output = []
    end

end
