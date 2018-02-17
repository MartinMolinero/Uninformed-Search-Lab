class Stack
	def initialize
		@local = Array.new()
	end

	def pop
		@local.pop()
	end

	def push e
		@local.push(e)
	end
end


class Node

	def initialize(stack_arr, parent, action, path_cost)
		@stacks = stack_arr
	end

	def calculate_actions

		@stacks.each_with_index do |s|

		end
	end

	def children
		#compute the possible children from the action set
	end

	def parent
		return @parent
	end

	def state

	end

end
def parse
	max = $stdin.readline
	start = $stdin.readline.chomp()
	goal = $stdin.readline.chomp()
	stacks = Array.new
	stacks_str = start.split(";")
	goal = goal.split(";")

	stacks_str.each_with_index do |s, i|
		s.gsub!('(', '')
		s.gsub!(')', '')
		s.gsub!(' ', '')
		goal[i].gsub!('(', '')
		goal[i].gsub!(')', '')
		goal[i].gsub!(' ', '')

		stacks[i] = Stack.new
		s.split(",").each do |c|
			stacks[i].push c 
		end

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
parse