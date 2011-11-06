require 'net\http'
require 'uri'
require 'set'
require_relative 'Problem'
require_relative 'Submission'


def convertTime(time)
	parts = time.split(" ")
	if parts.length < 2
		return nil
	end
	ymd = parts[0].split("-")
	hms = parts[1].split(":")
	return Time.new(ymd[0].to_i,ymd[1].to_i,ymd[2].to_i,hms[0].to_i,hms[1].to_i,hms[2].to_i,"+00:00").to_i
end

def getACs(text)
	list = []
	lines = text.split("\n")
	lines.delete_if{|s| s.chr != '|'}
	lines = lines.reverse
	for line in lines
		parts = line.split("|")
		time = convertTime(parts[2])
		id = parts[3].delete(" ")
		result = parts[4].delete(" ")
		if result.eql?("AC")
			flag = 0
			for item in list
				if (item.id <=> id) == 0
					flag = 1
				end
			end
			if flag == 0
				list.push(Submission.new(id,result,time))
			end
		end
	end
	return list.sort!
end

def getProblemsWithScores(users)
	problems = Set.new()

	for value in users
		url = URI.parse("http://www.spoj.pl/status/" + value + "/signedlist/")
		subs = Net::HTTP.get(url)
		subs = getACs(subs)
		counter = 0;
		for sub in subs
			counter = counter+1
			prob = Problem.new(sub.id)
			prob.score = counter
			prob.users = 1
			flag = 0
			for problem in problems
				if (problem.id <=> prob.id) == 0
					problem.score = problem.score + counter
					problem.users = problem.users + 1
					flag = 1
					break
				end
			end
			if flag == 0
				problems.add(prob)
			end
		end
	end

	problems = problems.to_a;
	problems.sort!
end

def makeMasterList(users)
	problems = getProblemsWithScores(users)
	masterList = []
	for thing in problems
		masterList.push(thing.id)
	end
	return masterList
end

def makeMasterListFile(users)
	problems = getProblemsWithScores(users)
	masterList = File.new("masterList.txt", 'w')
	for thing in problems
		masterList.puts thing.id
	end
end

def readMasterList(path)
	problems = []
	file = File.new(path, "r")
	while (line = file.gets)
		problems.push(line.chomp!)
	end
	return problems
end

#makeMasterListFile(%w[mlpalii hua naonao1234 theraven cricycle random_guy mauriciofmar3 tboyd jason_fisher narendran draperp rsalazar jiacona njames spastic])
