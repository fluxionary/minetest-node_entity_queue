local queue = node_entity_queue.queue

local api = {
	registered_nodes = {},
	action_by_node = {},
	action_by_group = {},
}

function api.register_node_entity_loader(node_name, action)
	local mod, item = node_name:match("^([^:]+):([^:]+)$")
	if mod and mod == "group" then
		api.action_by_group[item] = action

	else
		api.action_by_node[node_name] = action
		futil.add_groups(node_name, {node_entity_queue = 1})
	end
end

minetest.register_lbm({
	label = "load node entities",
	name = "node_entity_queue:loader",
	nodenames = {"group:node_entity_queue"},
	run_at_every_load = true,
	action = function(pos, node)
		local action = api.action_by_node[node.name]

		if action then
			queue:push_back(function(params, dtime, i)
				return action(pos, node, params, dtime, i)
			end)
		end
	end,
})

minetest.register_on_mods_loaded(function()
	for group, action in pairs(api.action_by_group) do
		for _, item in ipairs(futil.get_items_with_group(group)) do
			api.action_by_node[item] = action
			futil.add_groups(item, {node_entity_queue = 1})
		end
	end
end)

-- TODO: need to also catch any calls to override_item

node_entity_queue.api = api
