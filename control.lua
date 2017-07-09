start_entity = {}
start_position = {x=0, y=0}
end_position = {x=0, y=0}
placing = false
border = 15

script.on_event(defines.events.on_built_entity, function(event)

	if event.created_entity.name == "autobelt-ghost" then
		if placing == false then
			placing = true
			start_position = event.created_entity.position
			start_entity = event.created_entity
		else 
			placing = false
			end_position = event.created_entity.position
			start_entity.destroy()
			event.created_entity.destroy()
			build_belt(start_position, end_position)
		end
	end

end)

function build_belt(startpos, endpos)

	local valid_node_func = function ( node, neighbor ) 
		if game.surfaces[1].can_place_entity{name="transport-belt", position=neighbor} then
			return true
		end
		return false
	end

	local ignore = false -- ignore cached paths

	local all_nodes = {}

	local tl = {x=math.min(startpos.x, endpos.x), y=math.min(startpos.y, endpos.y)}
	local br = {x=math.max(startpos.x, endpos.x), y=math.max(startpos.y, endpos.y)}

	local bounds = { x1 = tl.x - border, x2 = br.x + border, y1 = tl.y - border, y2 = br.y + border }

	local path = path ( startpos, endpos, bounds, ignore, valid_node_func)
	if path then
		-- do something with path (a lua table of ordered nodes from start to end)
		local last = endpos
		for _,n in ipairs(path) do
			game.surfaces[1].create_entity{name="transport-belt", position=n, force="player", direction=get_dir(n, last)}
			last = n
		end
	end
end

function reverse(tbl)
	for i=1, math.floor(#tbl / 2) do
		local tmp = tbl[i]
		tbl[i] = tbl[#tbl - i + 1]
		tbl[#tbl - i + 1] = tmp
	end
end


function neighbors( node, is_valid, bounds )
	local output = {}
	if is_valid(node, {x = node.x + 0, y = node.y + 1}) and node.y <= bounds.y2 then table.insert(output, {x = node.x + 0, y = node.y + 1}) end
	if is_valid(node, {x = node.x + 0, y = node.y - 1}) and node.y >= bounds.y1 then table.insert(output, {x = node.x + 0, y = node.y - 1}) end
	if is_valid(node, {x = node.x + 1, y = node.y + 0}) and node.x < bounds.x2 then table.insert(output, {x = node.x + 1, y = node.y + 0}) end
	if is_valid(node, {x = node.x - 1, y = node.y + 0}) and node.x > bounds.x1 then table.insert(output, {x = node.x - 1, y = node.y + 0}) end
	return output
end

function remove_node ( set, theNode )

	for i, node in ipairs ( set ) do
		if node == theNode then 
			set [ i ] = set [ #set ]
			set [ #set ] = nil
			break
		end
	end	
end

function not_in ( set, theNode )

	for _, node in ipairs ( set ) do
		if is_same(node, theNode) then return false end
	end
	return true
end

function is_same( node1, node2 )

	if node1.x == node2.x and node1.y == node2.y then 
		return true
	end
	return false
end

function heuristic(a, b)
   -- Manhattan distance on a square grid
   return math.abs(a.x - b.x) + math.abs(a.y - b.y)
end

function path ( start, goal, bounds, ignore, valid_node_func )
	-- initialise stuff

	local frontier = {}
	local visited = {}
	start.cost = 0

	-- begin the frontier at the start!

	table.insert(frontier, start)
	table.insert(visited, start)
	start.from = "none"

	while (#frontier > 0) do
		local current = table.remove(frontier, #frontier)

		if is_same(current, goal) then
			return return_path( current, visited )
		end

		for _,node in ipairs(neighbors(current, valid_node_func, bounds)) do

			if not_in(visited, node) then

				node.cost = current.cost + 1

				node.priority = heuristic(node, goal) + node.cost

				table.insert(frontier, node)
				table.sort(frontier, function(a,b) return a.priority > b.priority end)
				table.insert(visited, node)
				node.from = current
			end
		end
	end

	return nil
end

function get_dir (node1, node2)
	if node1.x < node2.x then return defines.direction.east end
	if node1.x > node2.x then return defines.direction.west end 
	if node1.y < node2.y then return defines.direction.south end
	if node1.y > node2.y then return defines.direction.north end
end

function return_path( goal, visited )
	local output = {}

	while goal.from ~= "none" do
		table.insert(output, goal.from)
		goal = goal.from
	end

	return output
end