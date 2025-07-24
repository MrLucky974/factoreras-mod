fn define(mod_info) {
    import "factoreras/scripts/machines/assembling_machine" as assembling_machine;
    import "factoreras/scripts/machines/sieve" as sieve;
    
    assembling_machine::define(mod_info);
    sieve::define(mod_info);
}