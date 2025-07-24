import "voxel_eras/scripts/utils" as utils;

fn define(mod_info) {
    import "factoreras/scripts/utils" as fe_utils;

    fe_utils::define_icon(mod_info, fe_utils::icon_id("RubberSapling"), "factoreras/assets/textures/RubberSapling.png");

    fe_utils::define_item_only(mod_info, "Rubber Sapling", 
        fe_utils::icon_id("RubberSapling"), 
        "A sapling from a rubber tree.",
        |builder| {
            builder
            .with_burn(game::TICK_RATE)
		    .pipette(fe_utils::id("RubberSapling"))
        }
    );

    // TODO : Remove later
    mod_info.add(
		RecipeBuilder(
			fe_utils::id("RubberSaplingWorkbench"),
			"Convert Oak to Rubber Sapling",
			5,
			fe_utils::icon_id("RubberSapling")
		)
        .crafted_in(fe_utils::id("BasicWorkbench", "VoxelEras"))
		.with_input(WeakItemStack(fe_utils::id("OakSapling", "VoxelEras"), 1))
		.with_output(WeakItemStack(fe_utils::id("RubberSapling"), 1))
	);

	mod_info.add(
		VoxelBuilder(
			fe_utils::id("RubberSapling"),
            "Rubber Sapling",
			"factoreras/scripts/misc/wild/rubber_sapling.rhai"
		)
		.no_clip()
		.lighting(voxel::LIGHT_TRANSLUCENT)
		.model(CrossVoxelModel("factoreras/assets/textures/RubberSapling.png"))
		.pipette(fe_utils::id("RubberSapling"))
		.break_rate(voxel::BREAK_RATE_PLANT)
		.clear_colliders()
		.add_collider(AABB(
			Vec3(0.5, 0.46875, 0.5),
			Vec3(0.3125, 0.46875, 0.3125)
		))
		.tag("Plant:VoxelEras")
		.does_break()
		.does_random()
	);

	mod_info.add(
		ConstructBuilder(
			fe_utils::id("RubberSapling"),
            "Rubber Sapling",
            "A sapling from an rubber tree. Can be grown.",
            "Organics",
            fe_utils::icon_id("RubberSapling"),
			construct::ROT_NONE
		).variant(
			utils::add_plant_requirements(
				ConstructVariantBuilder(voxel::ROT_UP)
				.place(
					0, 0, 0,
					WeakVoxelVariant(fe_utils::id("RubberSapling"), voxel::ROT_UP)
				)
			)
		)
		.cost(WeakItemStack(fe_utils::id("RubberSapling"), 1))
		.tag("Plant:VoxelEras")
	);
}

fn on_break(voxel, location, target, entity, game_state) {
    import "factoreras/scripts/utils" as fe_utils;

	if location == target {
		game_state.drop(WeakItemStack(fe_utils::id("RubberSapling"), 1), location);
	} else if location.down() == target {
		game_state.break_voxel(location, entity);
	}

	event::ACCEPT
}

fn on_random(voxel, location, game_state) {
    import "factoreras/scripts/utils" as fe_utils;

	if game_state.random_bool(0.875) {
		return event::ACCEPT;
	}

	let tree_spawned_metadata = MetaData();
	tree_spawned_metadata.set_tag("Tree:VoxelEras");
    tree_spawned_metadata.set_tag("RubberFilled:FactorEras");

	utils::attempt_tree_spawn(
		location, 
		[
			game_state.get_voxel_prefab(fe_utils::id("RubberLog")).get_variant(voxel::ROT_UP, tree_spawned_metadata),
			game_state.get_voxel_prefab(fe_utils::id("RubberLog")).get_variant(voxel::ROT_NORTH, tree_spawned_metadata),
			game_state.get_voxel_prefab(fe_utils::id("RubberLog")).get_variant(voxel::ROT_SOUTH, tree_spawned_metadata),
			game_state.get_voxel_prefab(fe_utils::id("RubberLog")).get_variant(voxel::ROT_EAST, tree_spawned_metadata),
			game_state.get_voxel_prefab(fe_utils::id("RubberLog")).get_variant(voxel::ROT_WEST, tree_spawned_metadata)
		],
		game_state.get_voxel_prefab(fe_utils::id("RubberLeaves")).get_variant(tree_spawned_metadata),
		game_state
	);

	event::ACCEPT
}