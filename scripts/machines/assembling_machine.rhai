import "voxel_eras/scripts/player" as player;

const MAX_ENERGY = game::TICK_RATE / 2;

fn define(mod_info) {

    // Register the icon texture for the Assembling Machine
    mod_info.add(TextureBuilder(
        "AssemblingMachineIcon:FactorEras",
        "factoreras/assets/items/AssemblingMachineIcon.png"
    ));

    // Register the Assembling Machine (Off) block model
    mod_info.add(
        VoxelBuilder(
            "AssemblingMachineOff:FactorEras",
            "Assembling Machine (Off)",
            "factoreras/scripts/machines/assembling_machine.rhai"
        )
        .model(
            SolidVoxelModel(
                "factoreras/assets/textures/AssemblingMachineSide.png",
                "factoreras/assets/textures/AssemblingMachineTop.png", // TOP
                "factoreras/assets/textures/AssemblingMachineBack.png",
                "factoreras/assets/textures/AssemblingMachineSide.png",
                "factoreras/assets/textures/AssemblingMachineBottom.png", // BOTTOM
                "factoreras/assets/textures/AssemblingMachineFront.png" // FRONT
            )
        )
        .pipette("AssemblingMachine:FactorEras")
        .tag("Solid:VoxelEras")
        .break_rate(voxel::BREAK_RATE_MACHINE)
		.does_break()
        .does_interact()
        .does_message()
    );

    // Register the Assembling Machine (On) block model
    mod_info.add(
        VoxelBuilder(
            "AssemblingMachineOn:FactorEras",
            "Assembling Machine (On)",
            "factoreras/scripts/machines/assembling_machine.rhai"
        )
        .model(
            SolidVoxelModel(
                "factoreras/assets/textures/AssemblingMachineSide.png",
                "factoreras/assets/textures/AssemblingMachineTop.png", // TOP
                "factoreras/assets/textures/AssemblingMachineBackOn.png",
                "factoreras/assets/textures/AssemblingMachineSide.png",
                "factoreras/assets/textures/AssemblingMachineBottom.png", // BOTTOM
                "factoreras/assets/textures/AssemblingMachineFront.png" // FRONT
            )
        )
        .pipette("AssemblingMachine:FactorEras")
        .tag("Solid:VoxelEras")
        .break_rate(voxel::BREAK_RATE_MACHINE)
		.does_break()
        .does_interact()
        .does_message()
    );

    // Register the Assembling Machine block
    mod_info.add(
		ConstructBuilder(
			"AssemblingMachine:FactorEras",
			"Assembling Machine",
			"Assemble items automatically with the power of clockwork!",
			"Machines",
			"AssemblingMachineIcon:FactorEras",
			construct::ROT_COMPASS
		)
        .cost(WeakItemStack("Stone:VoxelEras", 1))
		.variant(
			ConstructVariantBuilder(voxel::ROT_UP)
				.place(
					0, 0, 0,
					WeakVoxelVariant("AssemblingMachineOff:FactorEras", voxel::ROT_UP)
					.add_state("State:Inventory", metadata::Inventory(5))
                    .add_state("State:ClockworkEnergy", metadata::U64(0))
                    .add_state("State:Progress", metadata::U64(0))
				)
		)
        .variant(
			ConstructVariantBuilder(voxel::ROT_UP1)
				.place(
					0, 0, 0,
					WeakVoxelVariant("AssemblingMachineOff:FactorEras", voxel::ROT_UP1)
					.add_state("State:Inventory", metadata::Inventory(5))
                    .add_state("State:ClockworkEnergy", metadata::U64(0))
                    .add_state("State:Progress", metadata::U64(0))
				)
		)
        .variant(
			ConstructVariantBuilder(voxel::ROT_UP2)
				.place(
					0, 0, 0,
					WeakVoxelVariant("AssemblingMachineOff:FactorEras", voxel::ROT_UP2)
					.add_state("State:Inventory", metadata::Inventory(5))
                    .add_state("State:ClockworkEnergy", metadata::U64(0))
                    .add_state("State:Progress", metadata::U64(0))
				)
		)
        .variant(
			ConstructVariantBuilder(voxel::ROT_UP3)
				.place(
					0, 0, 0,
					WeakVoxelVariant("AssemblingMachineOff:FactorEras", voxel::ROT_UP3)
					.add_state("State:Inventory", metadata::Inventory(5))
                    .add_state("State:ClockworkEnergy", metadata::U64(0))
                    .add_state("State:Progress", metadata::U64(0))
				)
		)
        .priority(20)
	);


}

fn on_break(voxel, location, target, entity, game_state) {
	if location == target {
        let inventory = voxel.metadata.get_inventory();
		for slot in inventory {
			if slot == () {
				continue;
			}

			game_state.drop(slot, location);
		}

        game_state.drop(WeakItemStack("Stone:VoxelEras", 1), location);
	}

	event::ACCEPT
}

fn on_interact(voxel, location, entity, game_state) {
    let stored_energy = voxel.metadata.get_u64("State:ClockworkEnergy");
	if stored_energy + global::ENERGY_PER_INTERACT > global::MAX_ENERGY {
		return event::CANCEL;
	}

    let new_state = voxel.metadata;
	new_state.set_u64("State:ClockworkEnergy", stored_energy + global::ENERGY_PER_INTERACT);

	game_state.set_voxel(
		location,
		voxel.get_variant(new_state)
	);
    
    event::ACCEPT
}

fn on_message(voxel, location, type, message, game_state) {
    // This code is used to receive energy from clockwork winders 
    // (or any other source that sends CLOCKWORK messages)

	if type != "CLOCKWORK" { return event::CANCEL; }
	let energy = message;

	let stored_energy = voxel.metadata.get_u64("State:ClockworkEnergy");
	if stored_energy + energy > global::MAX_ENERGY {
		return event::CANCEL;
	}

	let new_state = voxel.metadata;
	new_state.set_u64("State:ClockworkEnergy", stored_energy + energy);

	game_state.set_voxel(
		location,
		voxel.get_variant(new_state)
	);

	event::ACCEPT
}

fn on_tick(voxel, location, game_state) {
	let energy = voxel.metadata.get_u64("State:ClockworkEnergy");
	let progress = voxel.metadata.get_u64("State:Progress");

	if energy == 0 && progress == 0 && voxel.prefab.identifier != "AssemblingMachineOn:FactorEras" {
		return event::ACCEPT;
	}

    let was_running = false;
	if progress < global::PROGRESS_TO_MINE {
		if energy > 0 {
			energy -= 1;
			progress += 1;
			was_running = true;
		}
	}

    let new_state = voxel.metadata;
	new_state.set_u64("State:Progress", progress);
	new_state.set_u64("State:ClockworkEnergy", energy);

	game_state.set_voxel(
		location,
		game_state.get_voxel_prefab(
			if was_running {
				"AssemblyMachineOn:FactorEras"
			} else {
				"AssemblyMachineOff:VoxelEras"
			}
		).get_variant(voxel.rotation, new_state)
	);

    event::ACCEPT
}