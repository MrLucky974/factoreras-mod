fn setup(mod_info) {
    import "factoreras/scripts/icons" as icons;
    import "factoreras/scripts/machines/machines" as machines;
    import "factoreras/scripts/bomb" as bomb;
    import "factoreras/scripts/decoration/decoration" as decoration;
    import "factoreras/scripts/items/items" as items;
    
    icons::define(mod_info);

    items::define(mod_info);
    machines::define(mod_info);
    bomb::define(mod_info);
    decoration::define(mod_info);
}