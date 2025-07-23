fn define(mod_info) {
    import "factoreras/scripts/utils" as utils;

    utils::define_item(mod_info, "Gunpowder", "factoreras/assets/items/SulfurDust.png", "Used to make explosives.");

    mod_info.add(
		RecipeBuilder(
			"GunpowderMortar:FactorEras",
			"Mix Gunpowder from Sulfur and Coal Dust",
			0,
			"GunpowderIcon:FactorEras"
		)
        .crafted_in("Mortar:VoxelEras")
        .with_input(WeakItemStack("SulfurDust:FactorEras", 3))
		.with_input(WeakItemStack("CoalDust:VoxelEras", 2))
		.with_output(WeakItemStack("Gunpowder:FactorEras", 6))
	);
}