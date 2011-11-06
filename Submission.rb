class Submission
	attr_reader :id, :result, :time
	def initialize(id, result, time)
		@id = id
		@result = result
		@time = time
	end
	
	def to_s
		"#@id at #@time got #@result"
	end
	
	def <=> (submission)
		@time <=> submission.time
	end
end