fn define(mod_info) {
    import "factoreras/scripts/utils" as utils;

    utils::define_item(mod_info, "Gold Chunk", "Very small chunk of gold.\nCan be crushed into dust.");
	utils::define_item(mod_info, "Gold Dust", "Fine particles of gold. Electrically conductive.");
    utils::define_item(mod_info, "Gold Ingot", "Melted down gold dust in ingot form. Shiny!");

    mod_info.add(
		RecipeBuilder(
			"GoldDustMortar:VoxelEras",
			"Grind Gold Chunk into Gold Dust",
			2,
			utils::icon_id("GoldDust")
		).crafted_in(utils::id("Mortar", "VoxelEras"))
		.with_input(WeakItemStack(utils::id("GoldChunk"), 1))
		.with_output(WeakItemStack(utils::id("GoldDust"), 2))
	);

    mod_info.add(
		RecipeBuilder(
			"GoldDustGrinder:VoxelEras",
			"Grind Gold Chunk into Gold Dust",
			2,
			utils::icon_id("GoldDust")
		).crafted_in(utils::id("Grinder", "VoxelEras"))
		.with_input(WeakItemStack(utils::id("GoldChunk"), 1))
		.with_output(WeakItemStack(utils::id("GoldDust"), 2))
	);

    mod_info.add(
		RecipeBuilder(
			"GoldDustCrudeFurnace:VoxelEras",
			"Smelt Gold Dust into Gold Ingot",
			0,
			utils::icon_id("GoldDust")
		)
        .crafted_in(utils::id("CrudeFurnace", "VoxelEras"))
		.with_input(WeakItemStack(utils::id("GoldDust"), 4))
		.with_output(WeakItemStack(utils::id("GoldIngot"), 1))
	);
}