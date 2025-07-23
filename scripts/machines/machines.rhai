fn define(mod_info) {
    import "factoreras/scripts/machines/assembling_machine" as assembling_machine;
    import "factoreras/scripts/machines/clockwork_sieve" as clockwork_sieve;
    
    assembling_machine::define(mod_info);
    clockwork_sieve::define(mod_info);
}