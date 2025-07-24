fn define(mod_info) {
    import "factoreras/scripts/utils" as utils;

    mod_info.add(ModelBuilder(
		utils::id("TreeTap"),
		"factoreras/assets/models/TreeTap.glb"
	));

	mod_info.add(ModelBuilder(
		utils::id("TreeTapClosed"),
		"factoreras/assets/models/TreeTapClosed.glb"
	));

	utils::define_item(mod_info, "Tree Tap", "Place on trees to collect sap.");

	mod_info.add(
		RecipeBuilder(
			utils::id("TreeTapWorkbench"),
			"Manufacture Tree Tap",
			2,
			utils::icon_id("TreeTap")
		)
        .crafted_in(utils::id("BasicWorkbench", "VoxelEras"))
		.with_input(WeakItemStack(utils::id("BronzeIngot", "VoxelEras"), 2))
		.with_output(WeakItemStack(utils::id("TreeTap"), 1))
	);

    mod_info.add(
		VoxelBuilder(
			utils::id("TreeTap"),
			"Tree Tap (Opened)",
			"factoreras/scripts/misc/tree_tap.rhai"
		)
        .pipette(utils::id("TreeTap"))
		.lighting(voxel::LIGHT_TRANSLUCENT)
        .does_break()
        .break_rate(voxel::BREAK_RATE_HARD)
		.does_render()
		.does_tick()
		.does_interact()
		.clear_colliders()
		.add_collider(AABB(
			Vec3(0.5, 0.5, 0.875),
			Vec3(0.2, 0.2, 0.25)
		))
	);

	mod_info.add(
		VoxelBuilder(
			utils::id("TreeTapClosed"),
			"Tree Tap (Closed)",
			"factoreras/scripts/misc/tree_tap.rhai"
		)
        .pipette(utils::id("TreeTap"))
		.lighting(voxel::LIGHT_TRANSLUCENT)
        .does_break()
        .break_rate(voxel::BREAK_RATE_HARD)
		.does_render()
		.does_tick()
		.does_interact()
		.clear_colliders()
		.add_collider(AABB(
			Vec3(0.5, 0.5, 0.875),
			Vec3(0.2, 0.2, 0.25)
		))
	);

    mod_info.add(
		ConstructBuilder(
			utils::id("TreeTap"),
			"Tree Tap",
			"MANKIND IS DEAD, SAP IS FUEL, HELL IS FULL",
			"Misc",
			utils::icon_id("TreeTap"),
			construct::ROT_COMPASS
		).cost(WeakItemStack(utils::id("TreeTap"), 1))
		.variant(
			ConstructVariantBuilder(voxel::ROT_UP)
				.place(
					0, 0, 0,
					WeakVoxelVariant(utils::id("TreeTapClosed"), voxel::ROT_UP)
						.add_state("State:Progress", metadata::U64(0))
				)
                .require(
                    0, 0, 1,
                    WeakConstructRequirement(["Solid:VoxelEras", "Log:VoxelEras", utils::id("RubberFilled")])
                )
		).variant(
			ConstructVariantBuilder(voxel::ROT_UP1)
				.place(
					0, 0, 0,
					WeakVoxelVariant(utils::id("TreeTapClosed"), voxel::ROT_UP1)
						.add_state("State:Progress", metadata::U64(0))
				)
                .require(
                    1, 0, 0,
                    WeakConstructRequirement(["Solid:VoxelEras", "Log:VoxelEras", utils::id("RubberFilled")])
                )
		).variant(
			ConstructVariantBuilder(voxel::ROT_UP2)
				.place(
					0, 0, 0,
					WeakVoxelVariant(utils::id("TreeTapClosed"), voxel::ROT_UP2)
						.add_state("State:Progress", metadata::U64(0))
				)
                .require(
                    0, 0, -1,
                    WeakConstructRequirement(["Solid:VoxelEras", "Log:VoxelEras", utils::id("RubberFilled")])
                )
		).variant(
			ConstructVariantBuilder(voxel::ROT_UP3)
				.place(
					0, 0, 0,
					WeakVoxelVariant(utils::id("TreeTapClosed"), voxel::ROT_UP3)
						.add_state("State:Progress", metadata::U64(0))
				)
                .require(
                    -1, 0, 0,
                    WeakConstructRequirement(["Solid:VoxelEras", "Log:VoxelEras", utils::id("RubberFilled")])
                )
		)
		.priority(5)
	);
}

fn on_render(voxel, location, fake_render, client_state) {
    import "factoreras/scripts/utils" as utils;

	let tint;
	let rotation;
	if fake_render == () {
		tint = tint(1., 1., 1., 1.);
		rotation = voxel.rotation;
	} else {
		tint = fake_render.tint;
		rotation = fake_render.rotation;
	}

	client_state.draw(
		voxel.prefab.identifier,
		voxel_matrix(location, rotation, 1.),
		tint
	);

	event::ACCEPT
}

fn on_interact(voxel, location, entity, game_state) {
	import "factoreras/scripts/utils" as utils;

	let metadata = voxel.metadata;

    if voxel.prefab.identifier == utils::id("TreeTap") {
		game_state.set_voxel(
			location,
			game_state
				.get_voxel_prefab(utils::id("TreeTapClosed"))
				.get_variant(voxel.rotation, metadata)
		);
	} else {
		game_state.set_voxel(
			location,
			game_state
				.get_voxel_prefab(utils::id("TreeTap"))
				.get_variant(voxel.rotation, metadata)
		);
	}
    
    event::ACCEPT
}

fn on_break(voxel, location, target, entity, game_state) {
	import "factoreras/scripts/utils" as utils;

	if location == target {
		game_state.drop(WeakItemStack(utils::id("TreeTap"), 1), location);
	}

	event::ACCEPT
}

fn on_tick(voxel, location, game_state) {
	import "factoreras/scripts/utils" as utils;

	const GENERATION_RATE = game::TICK_RATE * 2;

	// Break the tree tap if it was placed in front of a user-placed block or air
	{
		let offset = voxel::SIDE_FRONT.rotate(voxel.rotation).offset;
		let voxel = game_state.get_voxel(location + offset);
		if voxel == () || (!voxel.metadata.has_tag("Tree:VoxelEras") && !voxel.metadata.has_tag("RubberFilled:FactorEras")) {
			game_state.break_voxel(location, ());
			return;
		}
	}

	if voxel.prefab.identifier != utils::id("TreeTap") { return; }

	let metadata = voxel.metadata;
	let progress = metadata.get_u64("State:Progress");
	
	progress += 1;

	if progress >= GENERATION_RATE {
		game_state.drop(WeakItemStack(utils::id("Sap"), 1), location);

		progress = 0;
	}

	metadata.set_u64("State:Progress", progress);

	game_state.set_voxel(
		location,
		game_state
			.get_voxel_prefab(utils::id("TreeTap"))
			.get_variant(voxel.rotation, metadata)
	);
}