const INTERACT_EXPLOSION_DELAY = game::TICK_RATE * 1;
const CHAIN_EXPLOSION_DELAY = game::TICK_RATE / 2;

fn define(mod_info) {
    mod_info.add(TextureBuilder(
		"BombBlockIcon:Explosives",
		"factoreras/assets/items/Bomb.png"
	));

    mod_info.add(
		VoxelBuilder(
			"Bomb:Explosives",
			"Bomb",
			"factoreras/scripts/misc/bomb.rhai"
		).model(SolidVoxelModel(
            "factoreras/assets/textures/BombTop.png",
            "factoreras/assets/textures/BombSide.png",
            "factoreras/assets/textures/BombBottom.png"
        ))
		.pipette("Bomb:Explosives")
		.tag("Solid:VoxelEras")
		.does_break()
		.break_rate(voxel::BREAK_RATE_COMPONENT)
        .does_interact()
        .does_message()
	);

    mod_info.add(
		VoxelBuilder(
			"BombIgnited:Explosives",
			"Bomb (Ignited)",
			"factoreras/scripts/misc/bomb.rhai"
		).model(SolidVoxelModel(
            "factoreras/assets/textures/BombTopIgnite.png",
            "factoreras/assets/textures/BombSideIgnite.png",
            "factoreras/assets/textures/BombBottomIgnite.png"
        ))
		.pipette("Bomb:Explosives")
		.tag("Solid:VoxelEras")
        .does_message()
        .does_scheduled_tick()
        .lighting(voxel::opaque_light(255, 255, 255))
	);

    mod_info.add(
		ConstructBuilder(
			"Bomb:Explosives",
			"Bomb",
			"Make things go BOOM!",
			"Explosives",
			"BombBlockIcon:Explosives",
			construct::ROT_NONE
		).variant(
			ConstructVariantBuilder(voxel::ROT_UP)
				.place(
					0, 0, 0,
					WeakVoxelVariant("Bomb:Explosives", voxel::ROT_UP)
				)
		)
		.cost(WeakItemStack("Gunpowder:FactorEras", 8))
		.priority(0)
	);
}

fn on_break(voxel, location, target, entity, game_state) {
	if location == target {
		game_state.drop(WeakItemStack("Gunpowder:FactorEras", 8), location);
	}

	event::ACCEPT
}

fn on_interact(voxel, location, entity, game_state) {
    game_state.set_voxel(
        location,
        game_state
            .get_voxel_prefab("BombIgnited:Explosives")
            .get_variant(voxel.rotation, voxel.metadata)
    );

    schedule_explosion(INTERACT_EXPLOSION_DELAY, location, game_state);
    
    event::ACCEPT
}

fn on_scheduled_tick(voxel, location, game_state) {
	explode(voxel, location, game_state);

	event::ACCEPT
}

fn on_message(voxel, location, type, message, game_state) {
    if type != "EXPLOSION" { return event::CANCEL; }
    
    if voxel.prefab.identifier != "Bomb:Explosives" { return event::CANCEL; }

    game_state.set_voxel(
        location,
        game_state
            .get_voxel_prefab("BombIgnited:Explosives")
            .get_variant(voxel.rotation, voxel.metadata)
    );

    schedule_explosion(CHAIN_EXPLOSION_DELAY, location, game_state);

    event::ACCEPT
}

private fn schedule_explosion(delay, location, game_state) {
    game_state.schedule_tick(
		location,
		delay
	);
}

private fn explode(voxel, location, game_state) {
    const BASE_EXPLOSION_RADIUS = 3;

    let radius = BASE_EXPLOSION_RADIUS + game_state.random_float(0., 1.);

    replace_by_air(location, game_state);

    let locations = get_explosion_radius(location, radius)
        .filter(|v| game_state.get_voxel(v).prefab != game_state.get_voxel_prefab("Air:VoxelEras"));

    for location in locations {
        let voxel = game_state.get_voxel(location);

        if voxel.prefab == game_state.get_voxel_prefab("Bomb:Explosives") {
            game_state.send_message(location, "EXPLOSION", ());
            continue;
        }

        // TODO : Prevent certain blocks from being broken
        game_state.break_voxel(location, ());
    }
}

private fn get_explosion_radius(origin, radius) {
    let array = [];
    let radius_squared = radius * radius;
    
    // Calculate integer bounds for iteration
    let min_x = (origin.x - radius).to_int();
    let max_x = (origin.x + radius).to_int();
    let min_y = (origin.y - radius).to_int();
    let max_y = (origin.y + radius).to_int();
    let min_z = (origin.z - radius).to_int();
    let max_z = (origin.z + radius).to_int();
    
    // Iterate through all possible positions in the expanded cubic area
    for x in min_x..=max_x {
        for y in min_y..=max_y {
            for z in min_z..=max_z {
                // Calculate relative position as floats
                let dx = x - origin.x.to_float();
                let dy = y - origin.y.to_float();
                let dz = z - origin.z.to_float();
                
                // Calculate squared distance from origin
                let distance_squared = dx*dx + dy*dy + dz*dz;
                
                // Check if within spherical radius
                if distance_squared <= radius_squared {
                    // Create new position and add to array
                    array.push(VoxelLocation(x, y, z));
                }
            }
        }
    }
    
    array
}