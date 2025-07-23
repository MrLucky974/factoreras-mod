fn define(mod_info) {
    for i in 0..8 {
        mod_info.add(TextureBuilder(
            "EnergyIcon" + i + "Icon:FactorEras",
            "factoreras/assets/icons/EnergyIcon" + i + ".png"
        ));
    }

    mod_info.add(TextureBuilder(
        "CancelIcon:FactorEras",
        "factoreras/assets/icons/Cancel.png"
    ));
}