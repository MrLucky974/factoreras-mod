fn define(mod_info) {
    import "factoreras/scripts/utils" as utils;

    utils::define_item(mod_info, "Gold Chunk", "");
	utils::define_item(mod_info, "Gold Dust", "");
    utils::define_item(mod_info, "Gold Ingot", "");

    mod_info.add(
		RecipeBuilder(
			"GoldDustMortar:VoxelEras",
			"Grind Gold Chunk into Gold Dust",
			2,
			utils::icon_id("GoldDust")
		).crafted_in(utils::id("Mortar", "VoxelEras"))
		.with_input(WeakItemStack(utils::id("GoldChunk"), 1))
		.with_output(WeakItemStack(utils::id("GoldDust"), 1))
	);

    mod_info.add(
		RecipeBuilder(
			"GoldDustGrinder:VoxelEras",
			"Grind Gold Chunk into Gold Dust",
			2,
			utils::icon_id("GoldDust")
		).crafted_in(utils::id("Grinder", "VoxelEras"))
		.with_input(WeakItemStack(utils::id("GoldChunk"), 1))
		.with_output(WeakItemStack(utils::id("GoldDust"), 1))
	);

    mod_info.add(
		RecipeBuilder(
			"GoldDustFurnace:VoxelEras",
			"Smelt Gold Dust into Gold Ingot",
			0,
			utils::icon_id("GoldDust")
		).crafted_in(utils::id("Furnace", "VoxelEras"))
		.with_input(WeakItemStack(utils::id("GoldDust"), 1))
		.with_output(WeakItemStack(utils::id("GoldIngot"), 1))
	);
}