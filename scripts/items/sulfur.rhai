fn define(mod_info) {
    import "factoreras/scripts/utils" as utils;

    utils::define_item(mod_info, "Sulfur Chunk", "");
	utils::define_item(mod_info, "Sulfur Dust", "");

    mod_info.add(
		RecipeBuilder(
			"SulfurDustMortar:VoxelEras",
			"Grind Sulfur Chunk into Sulfur Dust",
			2,
			utils::icon_id("SulfurDust")
		).crafted_in(utils::id("Mortar", "VoxelEras"))
		.with_input(WeakItemStack(utils::id("SulfurChunk"), 1))
		.with_output(WeakItemStack(utils::id("SulfurDust"), 3))
	);

    mod_info.add(
		RecipeBuilder(
			"SulfurDustGrinder:VoxelEras",
			"Grind Sulfur Chunk into Sulfur Dust",
			2,
			utils::icon_id("SulfurDust")
		).crafted_in(utils::id("Grinder", "VoxelEras"))
		.with_input(WeakItemStack(utils::id("SulfurChunk"), 1))
		.with_output(WeakItemStack(utils::id("SulfurDust"), 3))
	);
}