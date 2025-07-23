fn define(mod_info) {
    import "factoreras/scripts/decoration/bricks" as bricks;
    import "factoreras/scripts/decoration/rubber" as rubber;
    
    bricks::define(mod_info);
    rubber::define(mod_info);
}