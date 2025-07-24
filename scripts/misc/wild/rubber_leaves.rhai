fn define(mod_info) {
    import "factoreras/scripts/utils" as utils;

    utils::define_icon(mod_info, utils::icon_id("RubberLeaves"), "factoreras/assets/items/RubberLeaf.png");

    utils::define_item_only(mod_info, "Rubber Leaves", 
        utils::icon_id("RubberLeaves"), 
        "Loosely connected pile of leaves.",
        |builder| {
            builder
            .with_burn(game::TICK_RATE)
		    .pipette(utils::id("RubberLeaves"))
        }
    );

    mod_info.add(
		VoxelBuilder(
			utils::id("RubberLeaves"),
			"Rubber Leaves",
			"factoreras/scripts/misc/wild/rubber_leaves.rhai"
		)
        .model(TransparentVoxelModel("factoreras/assets/textures/RubberLeaf.png"))
		.break_rate(voxel::BREAK_RATE_FRAGILE)
		.pipette(utils::id("RubberLeaves"))
		.lighting(voxel::LIGHT_TRANSLUCENT)
		.replacable_by_growth()
		.tag("Solid:VoxelEras")
		.tag("Plant:VoxelEras")
		.does_break()
		.does_scheduled_tick()
		.does_message()
	);

	mod_info.add(
		ConstructBuilder(
			utils::id("RubberLeaves"),
            "Rubber Leaves",
            "Loosely connected pile of leaves.",
            "Organics",
            utils::icon_id("RubberLeaves"),
			construct::ROT_NONE
		).variant(
			ConstructVariantBuilder(voxel::ROT_UP)
			.place(
				0, 0, 0,
				WeakVoxelVariant(utils::id("RubberLeaves"), voxel::ROT_UP)
					.add_state("DecayKeep:VoxelEras", metadata::Tag())
			)
		)
		.cost(WeakItemStack(utils::id("RubberLeaves"), 1))
	);
}

fn on_break(voxel, location, target, entity, game_state) {
    import "factoreras/scripts/utils" as utils;

	if location == target {
		if game_state.random_bool(0.04) {
			game_state.drop(WeakItemStack(utils::id("RubberSapling"), 1), location);
		} else if game_state.random_bool(0.08) {
			game_state.drop(WeakItemStack(utils::id("RubberLeaves"), 1), location);
		}

		game_state.message_connected(
			location,
			game_state.get_voxel_prefab(utils::id("RubberLeaves")),
			1,
			"DECAY",
			location
		);
	}

	event::ACCEPT
}

fn on_message(voxel, location, type, message, game_state) {
	if type != "DECAY" { return event::CANCEL; }
	// There *is* a location parameter in the message
	// but we don't really need it :shrug:

	if voxel.metadata.has_tag("DecayKeep:VoxelEras") {
		return event::ACCEPT;
	}
	
	game_state.schedule_tick(
		location,
		game_state.random_int(1, game::TICK_RATE * 8)
	);

	event::ACCEPT
}

fn on_scheduled_tick(voxel, location, game_state) {
    import "factoreras/scripts/utils" as utils;

	if game_state.flood_search(
		location,
		voxel.prefab,
		game_state.get_voxel_prefab(utils::id("RubberLog")),
		3
	) == () {
		game_state.break_voxel(location, ());
	}

	event::ACCEPT
}