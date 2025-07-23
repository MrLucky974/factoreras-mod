fn define(mod_info) {
    import "factoreras/scripts/utils" as utils;

    utils::define_item(mod_info, "Gunpowder", "Used to make explosives.");

    mod_info.add(
		RecipeBuilder(
			utils::id("GunpowderMortar"),
			"Mix Gunpowder from Sulfur and Coal Dust",
			0,
			utils::icon_id("Gunpowder")
		)
        .crafted_in(utils::id("Mortar", "VoxelEras"))
        .with_input(WeakItemStack(utils::id("SulfurDust"), 3))
		.with_input(WeakItemStack(utils::id("CoalDust", "VoxelEras"), 2))
		.with_output(WeakItemStack(utils::id("Gunpowder"), 6))
	);
}