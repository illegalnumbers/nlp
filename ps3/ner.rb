#this will be the program driver
require 'bootstrap'

seed_rules = ARGV[0]
training_data = ARGV[1]
test_data = ARGV[2]

trainer = Trainer.new(seed_rules, training_data)
boot = Bootstrap.new(test_data, trainer)

boot.apply_to_test
output = []
output << "SEED DECISION LIST\n"
trainer.seed.each { |seed,value|
    output << "SPELLING Contains("+seed+") -> "+value[0]+" (prob="+value[1].to_s+" ; freq="+value[2].to_s+")\n"
}

output << "\nITERATION #1: NEW CONTEXT RULES\n"
trainer.context[0].each { |arr|
    output << "CONTEXT Contains("+arr[0].to_s+") -> "+arr[1].to_s+"(prob="+arr[2].to_s+" ; freq="+arr[3].to_s+")\n"    
}
output << "ITERATION #1: NEW SPELLING RULES\n"
trainer.spelling[0].each { |arr|
    output << "SPELLING Contains("+arr[0].to_s+") -> "+arr[1].to_s+"(prob="+arr[2].to_s+" ; freq="+arr[3].to_s+")\n"    
}
output << "ITERATION #2: NEW CONTEXT RULES\n"
trainer.context[1].each { |arr|
    output << "CONTEXT Contains("+arr[0].to_s+") -> "+arr[1].to_s+"(prob="+arr[2].to_s+" ; freq="+arr[3].to_s+")\n"    
}
output << "ITERATION #2: NEW SPELLING RULES\n"
trainer.spelling[1].each { |arr|
    output << "SPELLING Contains("+arr[0].to_s+") -> "+arr[1].to_s+"(prob="+arr[2].to_s+" ; freq="+arr[3].to_s+")\n"    
}
output << "ITERATION #3: NEW CONTEXT RULES\n"
trainer.context[2].each { |arr|
    output << "CONTEXT Contains("+arr[0].to_s+") -> "+arr[1].to_s+"(prob="+arr[2].to_s+" ; freq="+arr[3].to_s+")\n"    
}
output << "ITERATION #3: NEW SPELLING RULES\n"
trainer.spelling[2].each { |arr|
    output << "SPELLING Contains("+arr[0].to_s+") -> "+arr[1].to_s+"(prob="+arr[2].to_s+" ; freq="+arr[3].to_s+")\n"    
}
output << "FINAL DECISION LIST\n"
boot.final_list_sp.each { |arr|
    output << "SPELLING Contains("+arr[0].to_s+") -> "+arr[1].to_s+"(prob="+arr[2].to_s+" ; freq="+arr[3].to_s+")\n"    
}
boot.final_list_c.each { |arr|
    output << "CONTEXT Contains("+arr[0].to_s+") -> "+arr[1].to_s+"(prob="+arr[2].to_s+" ; freq="+arr[3].to_s+")\n"    
}

output << "APPLYING FINAL DECISION LIST TO TEST INSTANCES\n"
boot.trainer_arr.each { |instance|
    output << "\nCONTEXT: "+instance.context
    output << "\nNP: "+instance.np
    output << "\nCLASS: "+instance.label
    output << "\n"
}

File.open('ner.trace', 'w') do |f2|
output.each{ |x|
    f2.puts x
} 
end
