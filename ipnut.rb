class Stack
	def initialize
		@local = Array.new()
	end

	def from_array a
		@local = a
	end

	def pop
		@local.pop()
	end

	def push e
		@local.push(e)
		self
	end

	def length
		@local.length
	end

	def local
		@local
	end

	def clone
		@local.clone
	end

	def to_s
		local.to_s
	end
end

class Node

	def initialize(stack_arr, parent, action, path_cost, max)
		@state = stack_arr.clone
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
			@possible_actions.push(a.to_s + ", " + b.to_s)
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

	def generate_child(action)
		new_state = Array.new
		@state.each do |s|
			new_stack = Stack.new
			new_stack.from_array s.clone
			new_state.push new_stack
		end
		a = action.split(",")[0].to_i
		b = action.split(",")[1].to_i
		e = new_state[a].pop()
		if !e.nil? then
			new_state[b].push(e)
		end
		new_node = Node.new(new_state, self, action, @path_cost + cost_function(a,b), @max)
		new_node
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

	def to_s
		str = "";
		@state.each do |s|
			str.concat(s.to_s)
		end
		str
	end

	def equals? n
		@state.each_with_index do |s, i|
			if s.local != n.state[i].local \
				&& s.to_s != "[\"X\"]" && n.state[i].to_s != "[\"X\"]" then
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
	@V_str = Array.new
	@Q.push start
	found = false
	actions = Array.new
	res = ""
	while !@Q.empty? && !found
		n = @Q.shift
		if !@V_str.include? n.to_s then
			if n.equals? goal then
				found = true
				m = n
				while !m.equals? start
					actions.push m.action
					m = m.parent
				end
			else
				@V.push n
				@V_str.push n.to_s
				n.children.each do |c|
					@Q.push n.generate_child(c)
				end
				@Q.sort_by! do |node|
					node.path_cost
				end
			end
		end
	end
	if @Q.empty? && !found then
		print "No solution found"
	else
		actions.reverse.each do |s|
			res += "(" + s + "); "
		end
		puts n.path_cost
		print res[0, res.length() -2 ]
	end



end

# Returns the cost of applying the action (which has the movement)
# Picking up the container takes 0.5 minutes
# Moving the container one stack to the left or right takes 1 minute.
# Putting the container down takes 0.5 minutes
def cost_function(a, b)
	(a - b).abs + 1
end

parse
