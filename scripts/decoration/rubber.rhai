fn define(mod_info) {
    mod_info.add(TextureBuilder(
		"SapIcon:FactorEras",
		"factoreras/assets/items/Sap.png"
	));

    mod_info.add(TextureBuilder(
		"RubberBarIcon:FactorEras",
		"factoreras/assets/items/RubberBar.png"
	));

    mod_info.add(ItemBuilder(
        "Sap:FactorEras",
        "Sap",
        "",
        "SapIcon:FactorEras",
    ));

    mod_info.add(ItemBuilder(
        "RubberBar:FactorEras",
        "Rubber Bar",
        "",
        "RubberBarIcon:FactorEras",
    ));

    mod_info.add(
		RecipeBuilder(
			"RubberBarWorkbench:FactorEras",
			"Fire Sap into Rubber",
			0,
			"RubberBarIcon:FactorEras"
		)
        .crafted_in("CrudeFurnace:VoxelEras")
		.with_input(WeakItemStack("Sap:FactorEras", 1))
		.with_output(WeakItemStack("RubberBar:FactorEras", 1))
	);

    // mod_info.add(
	// 	RecipeBuilder(
	// 		"BrickWorkbench:FactorEras",
	// 		"Mold Grout into Bricks",
	// 		5,
	// 		"BrickIcon:FactorEras"
	// 	)
    //     .crafted_in("BasicWorkbench:VoxelEras")
	// 	.with_input(WeakItemStack("Grout:FactorEras", 2))
	// 	.with_output(WeakItemStack("Brick:FactorEras", 1))
	// );

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
			"RubberBarIcon:FactorEras",
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
}

fn on_break(voxel, location, target, entity, game_state) {
	if location == target {
		game_state.drop(WeakItemStack("RubberBar:FactorEras", 4), location);
	}

	event::ACCEPT
}