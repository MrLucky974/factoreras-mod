fn define(mod_info) {
    import "factoreras/scripts/utils" as utils;

    utils::define_icon(mod_info, utils::icon_id("RubberLog"), "factoreras/assets/items/RubberLog.png");

    utils::define_item_only(mod_info, "Rubber Log", 
        utils::icon_id("RubberLog"), 
        "A log from an rubber tree. Useful for building, collecting rubber or burning.",
        |builder| {
            builder
            .with_burn(4 * game::TICK_RATE)
		    .pipette(utils::id("RubberLog"))
        }
    );

	mod_info.add(
		VoxelBuilder(
			utils::id("RubberLog"),
			"Rubber Log",
			"factoreras/scripts/misc/wild/rubber_log.rhai"
		).model(SolidVoxelModel(
			"factoreras/assets/textures/RubberWood.png",
			"factoreras/assets/textures/RubberWoodTop.png",
			"factoreras/assets/textures/RubberWood.png",
			"factoreras/assets/textures/RubberWood.png",
			"factoreras/assets/textures/RubberWoodTop.png",
			"factoreras/assets/textures/RubberWood.png",
		))
        .pipette(utils::id("RubberLog"))
		.break_rate(voxel::BREAK_RATE_HARD)
		.tag("Solid:VoxelEras")
		.tag("Log:VoxelEras")
        .tag(utils::id("RubberFilled"))
		.does_break()
		.does_message()
		.does_scheduled_tick()
	);

	mod_info.add(
		ConstructBuilder(
			utils::id("RubberLog"),
            "Rubber Log",
            "Sturdy piece of wood.",
            "Building",
            utils::icon_id("RubberLog"),
			construct::ROT_CARDINAL
		)
        .cost(WeakItemStack(utils::id("RubberLog"), 1))
		.variant(ConstructVariantBuilder(voxel::ROT_UP)
			.place(
				0, 0, 0,
				WeakVoxelVariant(utils::id("RubberLog"), voxel::ROT_UP)
			)
		).variant(ConstructVariantBuilder(voxel::ROT_DOWN)
			.place(
				0, 0, 0,
				WeakVoxelVariant(utils::id("RubberLog"), voxel::ROT_DOWN)
			)
		).variant(ConstructVariantBuilder(voxel::ROT_NORTH)
			.place(
				0, 0, 0,
				WeakVoxelVariant(utils::id("RubberLog"), voxel::ROT_NORTH)
			)
		).variant(ConstructVariantBuilder(voxel::ROT_SOUTH)
			.place(
				0, 0, 0,
				WeakVoxelVariant(utils::id("RubberLog"), voxel::ROT_SOUTH)
			)
		).variant(ConstructVariantBuilder(voxel::ROT_EAST)
			.place(
				0, 0, 0,
				WeakVoxelVariant(utils::id("RubberLog"), voxel::ROT_EAST)
			)
		).variant(ConstructVariantBuilder(voxel::ROT_WEST)
			.place(
				0, 0, 0,
				WeakVoxelVariant(utils::id("RubberLog"), voxel::ROT_WEST)
			)
		)
		.priority(6)
	);
}

fn on_message(voxel, location, type, message, game_state) {
	if type != "CHOP" { return event::CANCEL; }

	if !voxel.metadata.has_tag("Tree:VoxelEras") {
		return event::CANCEL;
	}
	
	game_state.schedule_tick(
		location,
		game::TICK_RATE / 10
	);

	event::ACCEPT
}

fn on_break(voxel, location, target, entity, game_state) {
    import "factoreras/scripts/utils" as utils;

	if location == target {
		game_state.drop(WeakItemStack(utils::id("RubberLog"), 1), location);
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

fn on_scheduled_tick(voxel, location, game_state) {
	game_state.break_voxel(location, ());

	for x in 0..3 {
		let x = x - 1;
		for y in 0..3 {
			let y = y - 1;
			for z in 0..3 {
				let z = z - 1;
				if x == 0 && y == 0 && z == 0 {
					continue;
				}

				game_state.send_message(
					location + VoxelLocation(x, y, z),
					"CHOP",
					()
				);
			}
		}
	}

	event::ACCEPT
}