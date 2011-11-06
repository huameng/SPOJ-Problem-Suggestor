require 'net\http'
require 'uri'
require 'set'
require_relative 'Problem'
require_relative 'PersonalList'

#http://vnoi.info/index.php?option=com_voj&task=classify&site=spoj&sort=1&limit=1000&limitstart=0

def getProblemsWithClassifications()
	uri = URI.parse("http://vnoi.info/index.php?option=com_voj&task=classify&site=spoj&sort=1&limit=1000&limitstart=0")
	subs = Net::HTTP.get(uri)
	problemList = []
	problemName = /<tr class='sectiontableentry[12]'>[ \t\n\r]*<td>[ \t\n\r]*.*[ \t\n\r]*<\/td>/
	problemClassification = /<td>[ \t\n\r]*.*[ \t\n\r]*\(\d+\)[ \t\n\r]*<a href='#'/
	eitherOr = /<tr class='sectiontableentry[12]'>[ \t\n\r]*<td>[ \t\n\r]*.*[ \t\n\r]*<\/td>|<td>[ \t\n\r]*.*[ \t\n\r]*\(\d+\)[ \t\n\r]*<a href='#'/
	stuff = subs.scan(eitherOr)
	flag = 0 #1 means we just found a problem. 2 means we just gave that problem a classification
	#puts stuff
	p
	counter = 0
	for str in stuff
		stuff2 = str.scan(/[A-Z][A-Za-z0-9 -]*/)
		if stuff2[0] =~ /[A-Z0-9]{2,}[ \t\n\r]*/
			stuff2[0].strip!
			problemList.insert(0, Problem.new(stuff2[0]))
			flag = 1
		elsif flag == 1
			stuff2[0].strip!
			problemList[0].classification = stuff2[0]
			flag = 2
		end
	end
	return problemList
end

def classifyYourProblems()
	problemList = getProblemsWithClassifications()
	yourACs = getYourACs(gets.chomp)
	for problem in yourACs
		for otherProblem in problemList
			if problem.id == otherProblem.id
				puts "You solved " + problem.id + ", which is a " + otherProblem.classification + " type of problem"
				break
			end
		end
	end
end

def howManyOfEachClass()
	map = Hash.new()
	problemList = getProblemsWithClassifications()
	yourACs = getYourACs(gets.chomp)
	for problem in yourACs
		flag = 0
		for otherProblem in problemList
			if problem.id == otherProblem.id
				flag = 1
				if map.member?(otherProblem.classification)
					map[otherProblem.classification] += 1
				else
					map[otherProblem.classification] = 1
				end
				break
			end
		end
		if flag == 0
			if map.member?("unclassified")
				map["unclassified"] += 1
			else
				map["unclassified"] = 1
			end
		end
	end
	keys = map.keys;
	keys.sort!
	for key in keys
		puts "You have solved #{map[key]} #{key} problems"
	end
end

def classifyYourUnsolvedProblem()
	yourACs = getYourACs(gets.chomp)
	problemList = getProblemsWithClassifications()
	file = File.new("masterList.txt")
	allACs = []
	while line = file.gets
		allACs.push(line.chomp)
	end
	for thing in allACs
		flag = 0
		for item in yourACs
			if (thing <=> item.id) == 0
				flag = 1
			end
		end
		if flag == 0
			for problem in problemList
				if problem.id == thing
					puts problem
					flag = 1
				end
			end
			if flag == 0
				puts thing + " is an unclassified problem"
			end
		end
	end
end

def sortUnsolvedProblemsByClassification(unsolvedProblemList, problemsWithClassifications)
	map = Hash.new()
	for problem in unsolvedProblemList #these are just strings of the ID
		flag = 0
		for problemWithClass in problemsWithClassifications #these are problems
			if problem == problemWithClass.id
				flag = 1
				classification = problemWithClass.classification
				if map.member?(classification)
					map[classification].push(problem)
				else
					map[classification] = Array[problem]
				end	
			end
		end
		if flag == 0
			classification = "unclassified"
			if map.member?(classification)
				map[classification].push(problem)
			else
				map[classification] = Array[problem]
			end	
		end
	end
	return map
	
end

=begin
	
	for problem in problemsWithClassifications
		index = unsolvedProblemList.index(problem.id)
		if index != nil
			classification = problemsWithClassifications[index].classification
			if map.member?(classification)
				map[classification].push(problem.id)
			else
				map[classification] = Array[problem.id]
			end
		else
			if map.member?("unclassified")
				map["unclassified"].push(problem.id)
			else
				map["unclassified"] = Array[problem.id]
			end
		end
	end
	puts map
	
=end