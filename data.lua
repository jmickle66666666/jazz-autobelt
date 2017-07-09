data:extend({
	{
		type="item",
		name="autobelt-item",
		icon="__base__/graphics/icons/transport-belt.png",
		flags={"goes-to-quickbar"},
		place_result="autobelt-ghost",
		stack_size=2
	},
	{
		type="recipe",
		name="autobelt-recipe",
		enabled="true",
		ingredients={},
		result="autobelt-item",
		result_count=2,
		group="logistics",
		icon="__base__/graphics/icons/transport-belt.png"
	},
	{
		type="simple-entity",
		name="autobelt-ghost",
		flags = {"placeable-neutral", "player-creation"},
		minable = {mining_time = 0.05},
		icon="__base__/graphics/icons/transport-belt.png",
   		collision_box = {{-0.4, -0.2}, {0.4, 0.2}},
    	selection_box = {{-0.5, -0.5}, {0.5, 0.5}},
    	collision_mask = {"ghost-layer"},
    	picture = 
    	{
    		filename="__jazz-autobelt__/graphics/autobelt.png",
    		width=32,
    		height=32
    	},
    	render_layer = "object"


	}
})