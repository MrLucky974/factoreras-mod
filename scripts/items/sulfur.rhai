fn define(mod_info) {
    mod_info.add(TextureBuilder(
		"SulfurChunkIcon:FactorEras",
		"factoreras/assets/items/SulfurChunk.png"
	));

    mod_info.add(TextureBuilder(
		"SulfurDustIcon:FactorEras",
		"factoreras/assets/items/SulfurDust.png"
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