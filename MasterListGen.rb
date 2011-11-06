require 'net\http'
require 'uri'
require 'set'
require_relative 'Problem'
require_relative 'PersonalList'
require_relative 'ProblemClassifications'
require_relative 'MasterList'

def getUsers(pageCount)
	users = []
	for x in (0...pageCount)
		i = 100*x
		puts i
		url = URI.parse("http://www.spoj.pl/ranks/users/start=" + i.to_s)
		topx = Net::HTTP.get(url)
		name = /\/users\/([A-Za-z0-9_]*)"/
		temp = topx.scan(name)
		for str in temp
			users.push(str[0])
		end
	end
	return users
end

users = getUsers(100)
makeMasterListFile(users)