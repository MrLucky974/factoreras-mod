fn define(mod_info) {
    import "factoreras/scripts/utils" as utils;

    utils::define_item(mod_info, "Copper Wire", "Copper but very thin. Electrically conductive.");
    utils::define_item(mod_info, "Copper Coil", "A bunch of very thin copper made into big copper.\nDoes it feel like a step back?");

    mod_info.add(
		RecipeBuilder(
			utils::id("CopperWireWorkbench"),
			"Cut Copper into Wires",
			5,
			utils::icon_id("CopperWire")
		).crafted_in(utils::id("BasicWorkbench", "VoxelEras"))
		.with_input(WeakItemStack(utils::id("CopperIngot", "VoxelEras"), 1))
        .with_input(WeakItemStack(utils::id("WireCutter"), 1))
		.with_output(WeakItemStack(utils::id("CopperWire"), 3))
        .with_output(WeakItemStack(utils::id("WireCutter"), 1))
	);

	mod_info.add(
		RecipeBuilder(
			utils::id("CopperCoilWorkbench"),
			"Wrap Copper into Coil",
			5,
			utils::icon_id("CopperCoil")
		).crafted_in(utils::id("BasicWorkbench", "VoxelEras"))
		.with_input(WeakItemStack(utils::id("CopperWire"), 6))
		.with_output(WeakItemStack(utils::id("CopperCoil"), 1))
	);
}