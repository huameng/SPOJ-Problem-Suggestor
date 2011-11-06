require 'net\http'
require 'uri'
require 'set'
require_relative 'Problem'
require_relative 'PersonalList'
require_relative 'ProblemClassifications'
require_relative 'MasterList'

$stderr.puts "What is your username?"
myACs = getYourACs(gets.chomp)
masterList = readMasterList("\masterList.txt")
map = sortUnsolvedProblemsByClassification(getUnsolvedProblems(myACs, masterList), getProblemsWithClassifications())
for key in map.keys()
	puts "\n\ncategory: " + key + "\n\n"
	for item in map[key]
		puts item
	end
end
