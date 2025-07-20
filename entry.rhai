fn setup(mod_info) {
    import "factoreras/scripts/icons" as icons;
    import "factoreras/scripts/machines/machines" as machines;
    import "factoreras/scripts/decoration/decoration" as decoration;
    
    icons::define(mod_info);

    machines::define(mod_info);
    decoration::define(mod_info);
}