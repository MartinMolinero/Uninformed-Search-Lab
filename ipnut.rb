
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

# Returns the cost of applying the action (which has the movement)
# Picking up the container takes 0.5 minutes
# Moving the container one stack to the left or right takes 1 minute.
# Putting the container down takes 0.5 minutes
def cost_function(action)
	(action[0] - action[1]).abs + 1
end

print cost_function([2,4])