fn define(mod_info) {
    import "factoreras/scripts/utils" as utils;

    utils::define_item(mod_info, "Wire Cutter", "*snip* *snip*");

    mod_info.add(
		RecipeBuilder(
			utils::id("WireCutterAnvil"),
			"Manufacture Wire Cutter",
			10,
			utils::icon_id("WireCutter")
		).crafted_in(utils::id("Anvil", "VoxelEras"))
		.with_input(WeakItemStack(utils::id("RubberBar"), 2))
        .with_input(WeakItemStack(utils::id("WroughtIronPlate", "VoxelEras"), 1))
		.with_output(WeakItemStack(utils::id("WireCutter"), 1))
	);
}