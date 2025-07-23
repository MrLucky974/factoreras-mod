fn define(mod_info) {
    import "factoreras/scripts/utils" as utils;
    
    utils::define_item(mod_info, "Sulfur Chunk", "factoreras/assets/items/SulfurChunk.png", "");
	utils::define_item(mod_info, "Sulfur Dust", "factoreras/assets/items/SulfurDust.png", "");

    mod_info.add(
		RecipeBuilder(
			"SulfurDustMortar:VoxelEras",
			"Grind Sulfur Chunk into Sulfur Dust",
			0,
			"SulfurDustIcon:FactorEras"
		).crafted_in("Mortar:VoxelEras")
		.with_input(WeakItemStack("SulfurChunk:FactorEras", 1))
		.with_output(WeakItemStack("SulfurDust:FactorEras", 3))
	);

    mod_info.add(
		RecipeBuilder(
			"SulfurDustGrinder:VoxelEras",
			"Grind Sulfur Chunk into Sulfur Dust",
			0,
			"SulfurDustIcon:FactorEras"
		).crafted_in("Grinder:VoxelEras")
		.with_input(WeakItemStack("SulfurChunk:FactorEras", 1))
		.with_output(WeakItemStack("SulfurDust:FactorEras", 3))
	);
}