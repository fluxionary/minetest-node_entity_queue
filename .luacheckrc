std = "lua51+luajit+minetest+node_entity_queue"
unused_args = false
max_line_length = 120

stds.minetest = {
	read_globals = {
		"DIR_DELIM",
		"minetest",
		"core",
		"dump",
		"vector",
		"nodeupdate",
		"VoxelManip",
		"VoxelArea",
		"PseudoRandom",
		"ItemStack",
		"default",
		"table",
		"math",
		"string",
	}
}

stds.node_entity_queue = {
	globals = {
		"node_entity_queue",
	},
	read_globals = {
		"action_queues",
		"futil",
		"minetest",
	},
}
