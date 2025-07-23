fn setup(mod_info) {
    import "factoreras/scripts/icons" as icons;
    import "factoreras/scripts/items/items" as items;
    import "factoreras/scripts/machines/machines" as machines;
    import "factoreras/scripts/misc/misc" as misc;
    import "factoreras/scripts/decoration/decoration" as decoration;
    
    icons::define(mod_info);

    items::define(mod_info);
    machines::define(mod_info);
    misc::define(mod_info);
    decoration::define(mod_info);
}