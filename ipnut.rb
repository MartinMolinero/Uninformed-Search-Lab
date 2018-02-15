
def parse
	max = $stdin.readline
	start = $stdin.readline.chomp()
	goal = $stdin.readline.chomp()

	stacks = start.split(";")
	goal = goal.split(";")

	stacks.each_with_index do |s, i|
		s.gsub!('(', '')
		s.gsub!(')', '')
		s.gsub!(' ', '')
		goal[i].gsub!('(', '')
		goal[i].gsub!(')', '')
		goal[i].gsub!(' ', '')

		stacks[i] = s.split(",")
		goal[i] = goal[i].split(",")
	end

	# puts max
	print stacks
	puts "\n"
	print goal
end

parse