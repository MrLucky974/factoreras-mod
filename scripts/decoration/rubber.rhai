fn define(mod_info) {
	import "factoreras/scripts/utils" as utils;

	utils::define_item(mod_info, "Sap", "Collected from trees by using a Tree Tap.");
	utils::define_item(mod_info, "Rubber Bar", "Bouncy and resistant.");

    mod_info.add(
		RecipeBuilder(
			utils::id("RubberBarFurnace"),
			"Convert Sap into Rubber",
			0,
			utils::icon_id("RubberBar")
		)
        .crafted_in(utils::id("CrudeFurnace"))
		.with_input(WeakItemStack(utils::id("Sap"), 1))
		.with_output(WeakItemStack(utils::id("RubberBar"), 1))
	);

	mod_info.add(TextureBuilder(
		"RubberIcon:FactorEras",
		"factoreras/assets/textures/Rubber.png"
	));

    mod_info.add(
		VoxelBuilder(
			"Rubber:FactorEras",
			"Rubber",
			"factoreras/scripts/decoration/rubber.rhai"
		).model(SolidVoxelModel("factoreras/assets/textures/Rubber.png"))
		.pipette("Rubber:FactorEras")
		.break_rate(voxel::BREAK_RATE_HARD)
		.tag("Solid:VoxelEras")
		.does_break()
	);

    mod_info.add(
		ConstructBuilder(
			"Rubber:FactorEras",
			"Rubber",
			"Crazy? I was crazy once.",
			"Building",
			"RubberIcon:FactorEras",
			construct::ROT_NONE
		).variant(
			ConstructVariantBuilder(voxel::ROT_UP)
				.place(
					0, 0, 0,
					WeakVoxelVariant("Rubber:FactorEras", voxel::ROT_UP)
				)
		)
		.cost(WeakItemStack("RubberBar:FactorEras", 4))
		.priority(4)
	);

	mod_info.add(TextureBuilder(
		"WhiteRubberIcon:FactorEras",
		"factoreras/assets/textures/WhiteRubber.png"
	));

	mod_info.add(
		VoxelBuilder(
			"WhiteRubber:FactorEras",
			"White Rubber",
			"factoreras/scripts/decoration/rubber.rhai"
		).model(SolidVoxelModel("factoreras/assets/textures/WhiteRubber.png"))
		.pipette("WhiteRubber:FactorEras")
		.break_rate(voxel::BREAK_RATE_HARD)
		.tag("Solid:VoxelEras")
		.does_break()
	);

	mod_info.add(
		ConstructBuilder(
			"WhiteRubber:FactorEras",
			"White Rubber",
			"Crazy? I was crazy once.",
			"Building",
			"WhiteRubberIcon:FactorEras",
			construct::ROT_NONE
		).variant(
			ConstructVariantBuilder(voxel::ROT_UP)
				.place(
					0, 0, 0,
					WeakVoxelVariant("WhiteRubber:FactorEras", voxel::ROT_UP)
				)
		)
		.cost(WeakItemStack("RubberBar:FactorEras", 4))
		.priority(4)
	);
}

fn on_break(voxel, location, target, entity, game_state) {
	if location == target {
		game_state.drop(WeakItemStack("RubberBar:FactorEras", 4), location);
	}

	event::ACCEPT
}