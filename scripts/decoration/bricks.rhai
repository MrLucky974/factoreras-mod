fn define(mod_info) {
    mod_info.add(TextureBuilder(
		"GroutDustIcon:FactorEras",
		"factoreras/assets/items/Grout.png"
	));

    mod_info.add(TextureBuilder(
		"BrickIcon:FactorEras",
		"factoreras/assets/items/Brick.png"
	));

    mod_info.add(TextureBuilder(
		"BrickBlockIcon:FactorEras",
		"factoreras/assets/items/BrickBlock.png"
	));

    mod_info.add(ItemBuilder(
        "Grout:FactorEras",
        "Grout Dust",
        "",
        "GroutDustIcon:FactorEras",
    ));

    mod_info.add(
		RecipeBuilder(
			"GroutDustMortar:FactorEras",
			"Mix Sand and Gravel into Grout Dust",
			2,
			"GroutDustIcon:FactorEras"
		)
        .crafted_in("Mortar:VoxelEras")
		.with_input(WeakItemStack("Gravel:VoxelEras", 1))
        .with_input(WeakItemStack("Sand:VoxelEras", 1))
		.with_output(WeakItemStack("Grout:FactorEras", 2))
	);

    mod_info.add(ItemBuilder(
        "Brick:FactorEras",
        "Brick",
        "Made from sand and gravel. Used to make brick walls.",
        "BrickIcon:FactorEras",
    ));

    mod_info.add(
		RecipeBuilder(
			"BrickWorkbench:FactorEras",
			"Mold Grout into Bricks",
			5,
			"BrickIcon:FactorEras"
		)
        .crafted_in("BasicWorkbench:VoxelEras")
		.with_input(WeakItemStack("Grout:FactorEras", 2))
		.with_output(WeakItemStack("Brick:FactorEras", 1))
	);

    mod_info.add(
		VoxelBuilder(
			"Brick:FactorEras",
			"Bricks",
			"factoreras/scripts/decoration/bricks.rhai"
		).model(SolidVoxelModel("factoreras/assets/textures/Bricks.png"))
		.pipette("Brick:FactorEras")
		.break_rate(voxel::BREAK_RATE_HARD)
		.tag("Solid:VoxelEras")
		.does_break()
	);

    mod_info.add(
		ConstructBuilder(
			"Brick:FactorEras",
			"Bricks",
			"Sturdy building materials to build factories.",
			"Building",
			"BrickBlockIcon:FactorEras",
			construct::ROT_NONE
		).variant(
			ConstructVariantBuilder(voxel::ROT_UP)
				.place(
					0, 0, 0,
					WeakVoxelVariant("Brick:FactorEras", voxel::ROT_UP)
				)
		)
		.cost(WeakItemStack("Brick:FactorEras", 4))
		.priority(4)
	);
}

fn on_break(voxel, location, target, entity, game_state) {
	if location == target {
		game_state.drop(WeakItemStack("Brick:FactorEras", 4), location);
	}

	event::ACCEPT
}