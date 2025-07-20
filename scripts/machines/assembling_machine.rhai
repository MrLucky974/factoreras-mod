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
    let metadata = voxel.metadata;
    let recipe = metadata.get_string("State:Recipe");

    if recipe != () {
        ui.vertical_centered_justified(|ui| {
            ui.horizontal_top(|ui| {
                assembling_machine_interactables(ui, location, voxel, entity, client_state);
            });
        });
    } else {
        let recipe_types = ["BasicWorkbench:VoxelEras", "Anvil:VoxelEras", "AssemblingMachine:FactorEras"];
        assembling_machine_recipe_book(ui, location, voxel, entity, recipe_types, client_state);
    }
}

private fn assembling_machine_recipe_book(ui, location, voxel, entity, recipe_types, client_state) {
    let metadata = voxel.metadata;
    let inventory = metadata.get_inventory();

	ui.vertical_scroll(Vec2(0., 300.), |ui| {
		ui.item_spacing = Vec2(0., 0.);

        let recipes = [];
        for recipe in recipe_types {
            let crafter_recipes = client_state.game_state.get_crafter_recipes(recipe);
            if crafter_recipes == () {
                continue;
            }
            recipes += crafter_recipes;
        }
		loop {
			let recipes = recipes.drain(0..10);
			ui.horizontal_top(|ui| {
				ui.item_spacing = Vec2(0., 0.);
				for recipe in recipes {
					recipe_entry(location, ui, entity, recipe, inventory, client_state)
				}
			});

			if recipes.len() < 10 {
				break;
			}
		}
	});
}

private fn recipe_entry(location, ui, entity, recipe, inventory, client_state) {
	ui.add_enabled(true, |ui| {
		let response = client_state.selection_slot(
			ui,
			recipe.icon,
			"",
			"",
			false,
		);

		if response.clicked() {
			let message = MetaData();
			message.set_string("Recipe", recipe.identifier);
			client_state.action(location, "Craft", message);
		}

		if !response.contains_pointer() {
			return;
		}

		response.show_tooltip_ui(|ui| {
            recipe_tooltip(ui, recipe, inventory, client_state);

			client_state.tip(
				ui,
				"Left click to select this recipe."
			);
		});
	});
}

private fn recipe_tooltip(ui, recipe, inventory, client_state) {
	client_state.heading(
		ui,
		recipe.icon,
		recipe.name,
		""
	);

	ui.allocate_space(Vec2(0., 5.));

	ui.horizontal_top(|ui| {
		client_state.draw_icon(
			ui,
			"CraftAddIcon:VoxelEras",
			Vec2(24., 24.),
		);
		ui.label("Craft Output");
	});

	if recipe.outputs.len() == 0 {
		ui.label("Nothing!");
	} else {
		for product in recipe.outputs {
			client_state.product_tooltip(
				ui,
				product.quantity,
				inventory.item_count(product.item),
				product.item.icon,
				product.item.name
			);
		}
	}

	ui.allocate_space(Vec2(0., 5.));

	ui.horizontal_top(|ui| {
		client_state.draw_icon(
			ui,
			"CraftSubtractIcon:VoxelEras",
			Vec2(24., 24.)
		);
		ui.label("Craft Cost");
	});

	if recipe.inputs.len() == 0 {
		ui.label("Free!");
	} else {
		for cost in recipe.inputs {
            // TODO : Replace by something else?
			client_state.cost_tooltip(
				ui,
				inventory.item_count(cost.item),
				cost.quantity,
				cost.item.icon,
				cost.item.name
			);
		}
	}

	ui.allocate_space(Vec2(0., 5.));
}

private fn assembling_machine_interactables(ui, location, voxel, entity, client_state) {
    const COOK_FRAMES = 15;
    const ENERGY_FRAMES = 8;

    let metadata = voxel.metadata;
	let inventory = metadata.get_inventory();
    let progress = metadata.get_u64("State:Progress");
    let energy = metadata.get_u64("State:ClockworkEnergy");
    let selected_slot = entity.metadata.get_slot_ref("State:SelectedSlot");

    let cook_anim = ((progress * COOK_FRAMES) / global::REQUIRED_PROGRESS).min(COOK_FRAMES - 1);
    let energy_anim = ((energy * ENERGY_FRAMES) / global::MAX_ENERGY).min(ENERGY_FRAMES - 1);

    ui.vertical(|ui| {
        if client_state.selection_slot(
            ui,
            "CancelIcon:FactorEras",
            "",
            "Clear the selected recipe.",
            false
        ).clicked() {
            let metadata = MetaData();
            client_state.action(location, "Clear", metadata);
        }
    });

    let recipe_id = metadata.get_string("State:Recipe");
    let recipe = client_state.game_state.get_recipe(recipe_id);
    if recipe == () {
        ui.label("Unknown recipe with id: " + recipe_id);
        return;
    }

    ui.horizontal_top(|ui| {
        ui.item_spacing = Vec2(0., 0.);
        for slot_index in 0..recipe.inputs.len() {
            let input = recipe.inputs[slot_index].item;

            let slot_interact = client_state.inventory_slot(
                ui,
                inventory[slot_index],
                if selected_slot != () {
                    selected_slot.inventory_index == 1 && selected_slot.slot_index == slot_index
                } else {
                    false
                },
                input.icon, // Icon identifier goes here
                "Insert an ingredient into this slot.\nCan be input into from all sides."
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

    let output = recipe.outputs[0].item;
    ui.vertical(|ui| {
        let slot_interact = client_state.inventory_slot(
            ui,
            inventory[4],
            if selected_slot != () {
                selected_slot.inventory_index == 1 && selected_slot.slot_index == 4
            } else {
                false
            },
            output.icon, // Icon identifier goes here
            "The output of the assembling machine.\nCan be taken from on all sides."
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

    ui.vertical(|ui| {
        client_state.draw_icon(
            ui,
            "EnergyIcon" + energy_anim + "Icon:FactorEras",
            Vec2(12.5, 50.)
        );
    });
}

fn on_message(voxel, location, type, message, game_state) {
    // This code is used to receive energy from clockwork winders 
    // (or any other source that sends CLOCKWORK messages)

	if type != "CLOCKWORK" { return event::CANCEL; }
	let energy = message;

	let stored_energy = voxel.metadata.get_u64("State:ClockworkEnergy");
	if stored_energy + energy > (global::MAX_ENERGY - game::TICK_RATE * 8) {
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
        let recipe_id = metadata.get_string("State:Recipe");
        let recipe = game_state.get_recipe(recipe_id);

        let craftable_count = inventory.consumable_count(recipe.inputs); // Check if there is enough items to craft at least one output
        let can_insert_output = inventory[4] == () || inventory[4].item == recipe.outputs[0].item; // Check if the output slot is empty or if the stack inside is the recipe output item (prevent overriding)

        if recipe != () && craftable_count > 0 && can_insert_output {
            progress += 1;
            energy -= 1;
            metadata.set_u64("State:ClockworkEnergy", energy);
            
            if progress >= global::REQUIRED_PROGRESS {
                // If the progress reaches the required amount, consume the inputs and produce the output
                inventory = inventory.consume(recipe.inputs);

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
	if type == "Transfer" {
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
	} else if type == "Craft" {
        let metadata = voxel.metadata;
        let recipe = message.get_string("Recipe");
        metadata.set_string("State:Recipe", recipe);
        game_state.set_voxel(
            location,
            game_state
                .get_voxel_prefab(voxel.prefab.identifier)
                .get_variant(voxel.rotation, metadata)
	    );
    } else if type == "Clear" {
        let metadata = voxel.metadata;
        let recipe = metadata.get_string("State:Recipe");
        if recipe != () {
            metadata.remove("State:Recipe");
            game_state.set_voxel(
                location,
                game_state
                    .get_voxel_prefab(voxel.prefab.identifier)
                    .get_variant(voxel.rotation, metadata)
	        );
        }
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