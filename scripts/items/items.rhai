fn define(mod_info) {
    import "factoreras/scripts/items/wire_cutter" as wire_cutter;
    import "factoreras/scripts/items/copper" as copper;
    import "factoreras/scripts/items/sulfur" as sulfur;
    import "factoreras/scripts/items/gunpowder" as gunpowder;

    wire_cutter::define(mod_info);
    copper::define(mod_info);
    sulfur::define(mod_info);
    gunpowder::define(mod_info);
}