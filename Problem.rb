class Problem
	attr_reader :id
	attr_accessor :score, :users, :classification
	def initialize(id)
		@id = id
		@score = 0
		@users = 0
		@classification = "unclassified"
	end
	
	def to_s
		"#@id is a #@classification problem."
	end
	
	def <=> (problem)
		maybe = problem.users <=> @users
		if maybe == 0
			maybe = @score/@users <=> problem.score/problem.users
		end
		return maybe
	end
end