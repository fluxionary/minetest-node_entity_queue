local modname = minetest.get_current_modname()
local modpath = minetest.get_modpath(modname)
local S = minetest.get_translator(modname)

node_entity_queue = {
	version = os.time({year = 2022, month = 8, day = 9}),

	modname = modname,
	modpath = modpath,
	S = S,

	has = {
	},

	log = function(level, messagefmt, ...)
		return minetest.log(level, ("[%s] %s"):format(modname, messagefmt:format(...)))
	end,

	dofile = function(...)
		return dofile(table.concat({modpath, ...}, DIR_DELIM) .. ".lua")
	end,
}

node_entity_queue.dofile("settings")

node_entity_queue.queue = action_queues.api.create_serverstep_queue(node_entity_queue.settings)
