fn define(mod_info) {
    import "factoreras/scripts/misc/bomb" as bomb;
    import "factoreras/scripts/misc/tree_tap" as tree_tap;
    
    bomb::define(mod_info);
    tree_tap::define(mod_info);
}