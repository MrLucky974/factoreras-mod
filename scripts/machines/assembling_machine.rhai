import "voxel_eras/scripts/player" as player;

const MAX_ENERGY = game::TICK_RATE * 48;
const REQUIRED_PROGRESS = game::TICK_RATE * 4;

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
                "factoreras/assets/textures/AssemblingMachineBack.png", // BACK
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
        .does_interacting()
        .does_message()
        .does_tick()
        .does_action()
        .does_insert()
		.does_extract()
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
                "factoreras/assets/textures/AssemblingMachineBackOn.png", // BACK
                "factoreras/assets/textures/AssemblingMachineSide.png",
                "factoreras/assets/textures/AssemblingMachineBottom.png", // BOTTOM
                "factoreras/assets/textures/AssemblingMachineFrontOn.png" // FRONT
            )
        )
        .pipette("AssemblingMachine:FactorEras")
        .tag("Solid:VoxelEras")
        .break_rate(voxel::BREAK_RATE_MACHINE)
		.does_break()
        .does_interact()
        .does_interacting()
        .does_message()
        .does_tick()
        .does_action()
        .does_insert()
		.does_extract()
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

    // Basic Workbench recipes
    mod_info.add(
        RecipeBuilder(
            "OakPlankAssemblingMachine:FactorEras",
            "Cut Oak Log into Oak Plank",
            0,
            "OakPlankIcon:VoxelEras"
        ).crafted_in("AssemblingMachine:FactorEras")
        .with_input(WeakItemStack("OakLog:VoxelEras", 1))
        .with_output(WeakItemStack("OakPlank:VoxelEras", 4))
    );

    mod_info.add(
        RecipeBuilder(
            "StickAssemblingMachine:FactorEras",
            "Cut Oak Plank into Sticks",
            1,
            "StickIcon:VoxelEras"
        ).crafted_in("AssemblingMachine:FactorEras")
        .with_input(WeakItemStack("OakPlank:VoxelEras", 2))
        .with_output(WeakItemStack("Stick:VoxelEras", 4))
    );

    mod_info.add(
        RecipeBuilder(
            "WoodenGearAssemblingMachine:FactorEras",
            "Craft Wooden Gear",
            2,
            "WoodenGearIcon:VoxelEras"
        ).crafted_in("AssemblingMachine:FactorEras")
        .with_input(WeakItemStack("OakPlank:VoxelEras", 4))
        .with_input(WeakItemStack("Stick:VoxelEras", 4))
        .with_output(WeakItemStack("WoodenGear:VoxelEras", 2))
    );

    mod_info.add(
        RecipeBuilder(
            "PlantFiberAssemblingMachine:FactorEras",
            "Weave Trimmings into Fiber",
            4,
            "PlantFiberIcon:VoxelEras"
        ).crafted_in("AssemblingMachine:FactorEras")
        .with_input(WeakItemStack("GrassTrimmings:VoxelEras", 4))
        .with_output(WeakItemStack("PlantFiber:VoxelEras", 2))
    );

    mod_info.add(
        RecipeBuilder(
            "PlantFiberLeavesAssemblingMachine:FactorEras",
            "Weave Oak Leaves into Fiber",
            4,
            "PlantFiberIcon:VoxelEras"
        ).crafted_in("AssemblingMachine:FactorEras")
        .with_input(WeakItemStack("OakLeaves:VoxelEras", 4))
        .with_output(WeakItemStack("PlantFiber:VoxelEras", 2))
    );

    // Anvil recipes
    mod_info.add(
        RecipeBuilder(
            "WroughtIronPlateAssemblingMachine:FactorEras",
            "Forge Wrought Iron into Plate",
            5,
            "WroughtIronPlateIcon:VoxelEras"
        ).crafted_in("AssemblingMachine:FactorEras")
        .with_input(WeakItemStack("WroughtIronIngot:VoxelEras", 2))
        .with_output(WeakItemStack("WroughtIronPlate:VoxelEras", 1))
    );

    mod_info.add(
        RecipeBuilder(
            "CarbonSteelPlateAssemblingMachine:FactorEras",
            "Forge Carbon Steel into Plate",
            6,
            "CarbonSteelPlateIcon:VoxelEras"
        ).crafted_in("AssemblingMachine:FactorEras")
        .with_input(WeakItemStack("CarbonSteelIngot:VoxelEras", 2))
        .with_output(WeakItemStack("CarbonSteelPlate:VoxelEras", 1))
    );

    mod_info.add(
        RecipeBuilder(
            "CarbonSteelGearAssemblingMachine:FactorEras",
            "File Carbon Steel into Gear",
            7,
            "CarbonSteelGearIcon:VoxelEras"
        ).crafted_in("AssemblingMachine:FactorEras")
        .with_input(WeakItemStack("CarbonSteelPlate:VoxelEras", 2))
        .with_output(WeakItemStack("CarbonSteelGear:VoxelEras", 1))
    );

    mod_info.add(
        RecipeBuilder(
            "CarbonSteelTubeAssemblingMachine:FactorEras",
            "Bend Carbon Steel into Tube",
            8,
            "CarbonSteelTubeIcon:VoxelEras"
        ).crafted_in("AssemblingMachine:FactorEras")
        .with_input(WeakItemStack("CarbonSteelPlate:VoxelEras", 1))
        .with_output(WeakItemStack("CarbonSteelTube:VoxelEras", 1))
    );

    mod_info.add(
        RecipeBuilder(
            "BronzePlateAssemblingMachine:FactorEras",
            "Forge Bronze into Plate",
            9,
            "BronzePlateIcon:VoxelEras"
        ).crafted_in("AssemblingMachine:FactorEras")
        .with_input(WeakItemStack("BronzeIngot:VoxelEras", 2))
        .with_output(WeakItemStack("BronzePlate:VoxelEras", 1))
    );

    mod_info.add(
        RecipeBuilder(
            "SmallBronzeGearAssemblingMachine:FactorEras",
            "Fashion Bronze Ingot into Bronze Gear",
            10,
            "SmallBronzeGearIcon:VoxelEras"
        ).crafted_in("AssemblingMachine:FactorEras")
        .with_input(WeakItemStack("BronzePlate:VoxelEras", 2))
        .with_output(WeakItemStack("SmallBronzeGear:VoxelEras", 3))
    );

    mod_info.add(
        RecipeBuilder(
            "ClockworkCoreAssemblingMachine:FactorEras",
            "Form Clockwork Core",
            11,
            "ClockworkCoreIcon:VoxelEras"
        ).crafted_in("AssemblingMachine:FactorEras")
        .with_input(WeakItemStack("SmallBronzeGear:VoxelEras", 3))
        .with_input(WeakItemStack("WroughtIronPlate:VoxelEras", 1))
        .with_output(WeakItemStack("ClockworkCore:VoxelEras", 1))
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
    entity.start_interacting(location);
    
    event::ACCEPT
}

fn on_interacting(voxel, location, entity, egui, client_state) {
	let game_state = client_state.game_state;
	egui.window(
		"AssemblingMachineInteracting",
		|ui| {
			client_state.heading(
				ui,
				"AssemblingMachineIcon:FactorEras",
				"Assembling Machine",
				"Assemble items automatically with the power of clockwork!"
			);

            // Render the Assembling Machine UI
			assembling_machine_ui(ui, location, voxel, entity, client_state);

            // Render the player's inventory UI
			player::inventory_ui(
				ui,
				location,
				voxel,
				entity,
				client_state
			);
		}
	);

    // Render the selected slot if it exists
	let selected_slot = entity.metadata.get_slot_ref("State:SelectedSlot");
	if selected_slot != () {
		client_state.render_grabbed_slot(
			egui,
			selected_slot.using_primary, 
			(if selected_slot.inventory_index == 0 {
				entity.metadata.get_inventory()
			} else {
				game_state.get_voxel(location).metadata.get_inventory()
			})[selected_slot.slot_index]
		);
	}

	event::ACCEPT
}

private fn assembling_machine_ui(ui, location, voxel, entity, client_state) {
    ui.vertical_centered_justified(|ui| {
        ui.horizontal_top(|ui| {
            assembling_machine_interactables(ui, location, voxel, entity, client_state);
        });
    });
}

private fn assembling_machine_interactables(ui, location, voxel, entity, client_state) {
    const COOK_FRAMES = 15;

    let metadata = voxel.metadata;
	let inventory = metadata.get_inventory();
    let progress = metadata.get_u64("State:Progress");
    let selected_slot = entity.metadata.get_slot_ref("State:SelectedSlot");

    let cook_anim = ((progress * COOK_FRAMES) / global::REQUIRED_PROGRESS).min(COOK_FRAMES - 1);

    ui.horizontal_top(|ui| {
        ui.item_spacing = Vec2(0., 0.);
        for slot_index in 0..4 {
            let slot_interact = client_state.inventory_slot(
                ui,
                inventory[slot_index],
                if selected_slot != () {
                    selected_slot.inventory_index == 1 && selected_slot.slot_index == slot_index
                } else {
                    false
                },
                "",
                "Input Slot " + (slot_index + 1).to_string()
            );

            if slot_interact.clicked_down() || slot_interact.secondary_clicked() {
                let metadata = MetaData();
                metadata.set_slot_ref("State:ClickedSlot", metadata::SlotRef(
                    1,
                    slot_index,
                    slot_interact.clicked_down(),
                ));
                client_state.action(location, "Transfer", metadata);
            }
        }
    });

    ui.vertical(|ui| {
        client_state.draw_icon(
            ui,
            "MergeArrow" + cook_anim + "Icon:VoxelEras",
            Vec2(50., 50.)
        );
    });

    ui.vertical(|ui| {
        let slot_interact = client_state.inventory_slot(
            ui,
            inventory[4],
            if selected_slot != () {
                selected_slot.inventory_index == 1 && selected_slot.slot_index == 4
            } else {
                false
            },
            "",
            "Output Slot"
        );

        if slot_interact.clicked_down() || slot_interact.secondary_clicked() {
            let metadata = MetaData();
            metadata.set_slot_ref("State:ClickedSlot", metadata::SlotRef(
                1,
                4,
                slot_interact.clicked_down(),
            ));
            client_state.action(location, "Transfer", metadata);
        }
    });
}

fn on_message(voxel, location, type, message, game_state) {
    // This code is used to receive energy from clockwork winders 
    // (or any other source that sends CLOCKWORK messages)

	if type != "CLOCKWORK" { return event::CANCEL; }
	let energy = message;

	let stored_energy = voxel.metadata.get_u64("State:ClockworkEnergy");
	if stored_energy + energy > global::MAX_ENERGY / 4 {
		return event::CANCEL;
	}

	let new_state = voxel.metadata;
	new_state.set_u64("State:ClockworkEnergy", stored_energy + energy);

	game_state.set_voxel(
		location,
		voxel.get_variant(voxel.rotation, new_state)
	);

	event::ACCEPT
}

fn on_tick(voxel, location, game_state) {
    // Get the current energy and progress from the voxel metadata
    let metadata = voxel.metadata;
    let inventory = metadata.get_inventory();
	let energy = metadata.get_u64("State:ClockworkEnergy");
	let progress = metadata.get_u64("State:Progress");

    // If there's no energy and no progress, and the voxel is not the "On" variant, return
    // This prevents unnecessary updates when the machine is idle
	if energy == 0 && progress == 0 && voxel.prefab.identifier != "AssemblingMachineOn:FactorEras" {
		return event::ACCEPT;
	}

	if energy > 0 {
        let recipe = game_state.find_possible_recipe("AssemblingMachine:FactorEras", [inventory[0], inventory[1], inventory[2], inventory[3]], [inventory[4]]);

        if recipe != () {
            energy -= 1;
            metadata.set_u64("State:ClockworkEnergy", energy);
            
            progress += 1;
            
            if progress >= global::REQUIRED_PROGRESS {
                // If the progress reaches the required amount, consume the inputs and produce the output
                for i in 0..4 {
                    if inventory[i] != () {
                        inventory[i].quantity -= recipe.inputs[i].quantity;
                    }
                }

                if inventory[4] == () {
					inventory[4] = recipe.outputs[0];
				} else {
					inventory[4].quantity += recipe.outputs[0].quantity;
				}
                
                metadata.set_inventory(inventory);
                progress = 0;
            }
        } else if progress > 0 {
            // If no recipe is found, reset progress
            progress = 0;
        }
        
        metadata.set_u64("State:Progress", progress);

        game_state.set_voxel(
            location,
            game_state
                .get_voxel_prefab("AssemblingMachineOn:FactorEras")
                .get_variant(voxel.rotation, metadata)
	    );
    } else {
        // If there's no energy, reset the progress and set the voxel to the "Off" variant
        if progress > 0 {
            progress = 0;
            metadata.set_u64("State:Progress", progress);
        }

        game_state.set_voxel(
            location,
            game_state
                .get_voxel_prefab("AssemblingMachineOff:FactorEras")
                .get_variant(voxel.rotation, metadata)
	    );
    }

    event::ACCEPT
}

fn on_action(voxel, location, player, type, message, game_state) {
	if type != "Transfer" {
		return event::ACCEPT;
	}

	let player = game_state.validate_player_interact(player, location);
	if player == () { return event::ACCEPT; }

	let clicked_slot = message.get_slot_ref("State:ClickedSlot");
	if clicked_slot != () {
		game_state.voxel_entity_transfer(
			clicked_slot,
			location,
			voxel,
			player
		);
	}

	event::ACCEPT
}

fn on_insert(voxel, location, slot, items, direction, game_state) {
	if slot >= 4 {
        return event::CANCEL;
    }

    event::ACCEPT
}

fn on_extract(voxel, location, slot, items, direction, game_state) {
	if direction != () && slot < 4 {
		return event::CANCEL;
	}

	event::ACCEPT
}