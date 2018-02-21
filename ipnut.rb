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

	def local
		@local
	end
end


def generate_child(node, action)
	state = node.state
	a = action.split(",")[0].to_i
	b = action.split(",")[1].to_i
	state[b].push(state[a].pop())
	Node.new(state, node, action, node.path_cost + cost_function(a,b), node.max)
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

	def equals? n
		@state.each_with_index do |s, i|
			if s.local != n.state[i].local then
				return false
			end
		end
		true
	end
end

def parse
	max = $stdin.readline
	start = $stdin.readline.chomp()
	goal_str = $stdin.readline.chomp()
	stacks_str = start.split(";")
	goal_str = goal_str.split(";")
	stacks = Array.new
	goal_stacks = Array.new
	goal = Array.new

	stacks_str.each_with_index do |s, i|
		s.gsub!('(', '')
		s.gsub!(')', '')
		s.gsub!(' ', '')
		goal_str[i].gsub!('(', '')
		goal_str[i].gsub!(')', '')
		goal_str[i].gsub!(' ', '')

		stacks[i] = Stack.new
		s.split(",").each do |c|
			stacks[i].push c
		end

		goal_stacks[i] = Stack.new
		goal_str[i].split(",").each do |c|
			goal_stacks[i].push c
		end

		start = Node.new(stacks, nil, "0,0", 0, max)
		goal = Node.new(goal_stacks, nil, nil, 0, max)
	end

	# puts max
	# print goal.inspect
	# print goal.state[0].local
	# print start.equals? goal

	@Q = Array.new
	@V = Array.new
	@Q.push start
	found = false
	while !@Q.empty? && !found
		n = @Q.pop
		if !@V.include? n then
			if n.equals? goal then
				found = true
			else
				@V.push n
				n.children.each do |c|
					@Q.push generate_child(n,c)
				end
				print n.inspect
				@Q.sort_by! do |node|
					node.path_cost
				end
			end
		end
		# print @Q
		# puts "\n V \n"
		# print @V
		enter = $stdin.readline
	end

	print @V

end

# Returns the cost of applying the action (which has the movement)
# Picking up the container takes 0.5 minutes
# Moving the container one stack to the left or right takes 1 minute.
# Putting the container down takes 0.5 minutes
def cost_function(a, b)
	(a - b).abs + 1
end

parse
