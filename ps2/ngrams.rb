#this is the output handler
require 'model'
require 'trainer'
training_file = ARGV[0]
test_file = ARGV[1]
trainer = Trainer.new(training_file)
model = Model.new(trainer, "legacy")
output = []
File.open(test_file, mode="r").each_line { |sentence|
    output << "S = #{sentence}"
    output << "\n"
    output << "Unigrams: logprob(S) = "+model.process_unigram(sentence).to_s()
    output << "Bigrams: logprob(S) = "+model.process_bigram(sentence).to_s()
    output << "Trigrams: logprob(S) = "+model.process_trigram(sentence).to_s()
    output << "Smoothed Bigrams: logprob(S) = "+model.process_smooth_bigram(sentence).to_s()
    output << "Smoothed Trigrams: logprob(S) = "+model.process_smooth_trigram(sentence).to_s()
    output << "\n"
}

tracefile = File.new("ngrams.trace", mode="w")
output.each do |o|
    tracefile.puts o
end
