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

	def length
		@local.length
	end
end


def generate_child( node, action)
	@state = node.state
	a = action.split(",")[0].to_i
	b = action.split(",")[1].to_i
	@state[b].push(@state[a].pop())
	Node.new(@state, node, action, node.path_cost + cost_function(a,b), node.max)
end

class Node

	def initialize(stack_arr, parent, action, path_cost, max)
		@state = stack_arr
		@parent = parent
		@action = action
		@path_cost = path_cost
		@max = max.to_i
	end

	def path_cost
		@path_cost
	end

	def children
		#compute the possible children from the action set
		@actions = []
		@state.each_with_index do |s, i|
			@actions.push(i)
		end
		@possible_actions = []
		@final_actions = []
		@actions.permutation(2).to_a.each do |a,b|
			@possible_actions.push(a.to_s + "," + b.to_s)
		end
		@possible_actions.each_with_index do |p, i|
			a = p.split(",")[0]
			b = p.split(",")[1]
			if (@state[b.to_i].length + 1 <= @max) then
				@final_actions.push(p)
			end
		end
	 	@final_actions
	end

	def state
		@state
	end

	def action
		@action
	end

	def path_cost
		@path_cost
	end

	def parent
		@parent
	end

	def max
		@max
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
	n = Node.new(stacks, nil, nil,0, max)
	puts "node\n"
	print n.children
	puts ""
	print generate_child(n, "0,1").state

end

# Returns the cost of applying the action (which has the movement)
# Picking up the container takes 0.5 minutes
# Moving the container one stack to the left or right takes 1 minute.
# Putting the container down takes 0.5 minutes
def cost_function(a,b)
	(a - b).abs + 1
end
parse
