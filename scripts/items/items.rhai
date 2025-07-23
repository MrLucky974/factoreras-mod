fn define(mod_info) {
    mod_info.add(TextureBuilder(
		"CopperWireIcon:FactorEras",
		"factoreras/assets/items/CopperWire.png"
	));

    mod_info.add(TextureBuilder(
		"CopperCoilIcon:FactorEras",
		"factoreras/assets/items/CopperCoil.png"
	));

    mod_info.add(TextureBuilder(
		"SulfurChunkIcon:FactorEras",
		"factoreras/assets/items/SulfurChunk.png"
	));

    mod_info.add(TextureBuilder(
		"SulfurDustIcon:FactorEras",
		"factoreras/assets/items/SulfurDust.png"
	));

    mod_info.add(ItemBuilder(
        "CopperWire:FactorEras",
        "Copper Wire",
        "Copper but very thin. Could be useful to conduct electricity or something idk...",
        "CopperWireIcon:FactorEras",
    ));

    mod_info.add(ItemBuilder(
        "CopperCoil:FactorEras",
        "Copper Magnetic Coil",
        "A bunch of very thin copper made into big copper. Does it feel like a step back?",
        "CopperCoilIcon:FactorEras",
    ));

    mod_info.add(ItemBuilder(
        "SulfurChunk:FactorEras",
        "Sulfur Chunk",
        "",
        "SulfurChunkIcon:FactorEras",
    ));

    mod_info.add(ItemBuilder(
        "SulfurDust:FactorEras",
        "Sulfur Dust",
        "",
        "SulfurDustIcon:FactorEras",
    ));
}