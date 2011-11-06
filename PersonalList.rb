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

def getYourACs(name)
	uri = URI.parse("http://www.spoj.pl/status/" + name + "/signedlist/")
	subs = Net::HTTP.get(uri)
	yourACs = getACs(subs)
end

def getUnsolvedProblems(yourACs, masterList)
	for ac in yourACs
		masterList.delete(ac.id.chomp)
	end
	return masterList
end

def compareList()
	$stderr.puts "What is your SPOJ username?"
	name = gets.chomp
	outFile = File.new(name + "List.txt", 'w')
	yourACs = getYourACs(name)
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
			outFile.puts thing
		end
	end
end