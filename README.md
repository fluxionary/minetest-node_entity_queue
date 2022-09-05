# node_entity_queue

minetest mod which creates a common queue for updating "node entities", a term i use for non-physical
entities which are semantically bound to a specific node.

## api

* `function api.register_node_entity_loader(node_name, action)`
  `action = function(pos, node, params, dtime, n)`
  the initializer action will be queued for calling whenever it is "loaded" (mapblock becomes active).
