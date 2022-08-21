local neq = node_entity_queue
local api = neq.api

local table_insert = table.insert
local v_add = vector.add
local v_sub = vector.subtract
local get_objects_in_area = minetest.get_objects_in_area

local deserialize = minetest.deserialize
local serialize = minetest.serialize


function neq.register_node_entity(name, def)
	if not def.attached_node then
		error("must specify attached node or group")
	end

	local attached_node = def.attached_node
	def.attached_node = nil
	local group = attached_node:match("^group:(.*)$")

	local function is_attached(pos)
		local node_name = minetest.get_node(pos).name
		if group then
			return minetest.get_item_group(node_name, group) > 0

		else
			return node_name == attached_node
		end
	end

	if def.physical == nil then
		def.physical = false
	end
	def.collisionbox = def.collisionbox or {0, 0, 0, 0, 0, 0}

	local get_staticdata = def.get_staticdata
	local on_activate = def.on_activate
	local get_entities = def.get_entities or function(pos)
		local entities = {}

		for _, obj in ipairs(get_objects_in_area(v_sub(pos, 0.5), v_add(pos, 0.5))) do
			local ent = obj:get_luaentity()
			if ent and ent.name == name then
				local ent_pos = ent.pos
				if not ent_pos then
					obj:remove()

				elseif vector.equals(ent_pos, pos) then
					table_insert(entities, obj)
				end
			end
		end

		return entities
	end
	def.get_entities = nil

	local already_exists = def.already_exists or function(self, pos)
		local entities = get_entities(pos)
		local obj = self.object
		for _, other_obj in ipairs(entities) do
			if other_obj ~= obj then
				return true
			end
		end
		return false
	end
	def.already_exists = nil

	function def.get_staticdata(self)
		if get_staticdata then
			return serialize({self.pos, get_staticdata(self)})

		else
			return serialize({self.pos})
		end
	end

	function def.on_activate(self, staticdata, dtime_s)
		local fields = deserialize(staticdata)
		local pos = fields[1]
		local obj = self.object

		if not (pos and is_attached(pos)) then
			obj:remove()
			return
		end

		if on_activate then
			on_activate(self, unpack(fields, 2), dtime_s)
		end

		if already_exists(self, pos) then
			obj:remove()
		end
	end

	minetest.register_entity(name, def)

	minetest.register_lbm({
		name = ("%s_restoration"):format(name),
		nodenames = {attached_node},
		run_at_every_load = true,
		action = function(pos, node, active_object_count, active_object_count_wider)
			api.add_entity(name, pos)
		end
	})
end

neq.register_node_entity("cottages:anvil_item", {
	visual = "wielditem",
	visual_size = {x = .33, y = .33},

	get_staticdata = function(self)
		return self.item
	end,

	on_activate = function(self, item, dtime_s)
		self.item = item
		self.object:set_properties({wield_item = item})
	end,
})
