local s = minetest.settings

node_entity_queue.settings = {
	us_per_step = tonumber(s:get("node_entity_queue.us_per_step"))
		or math.round((1e6 * (tonumber(s:get("dedicated_server_step")) or 0.09) / 2)),
	every_n_steps = tonumber(s:get("node_entity_queue.every_n_steps")),
	every_n_seconds = tonumber(s:get("node_entity_queue.every_n_seconds")),
	num_per_step = tonumber(s:get("node_entity_queue.num_per_step")),
}
