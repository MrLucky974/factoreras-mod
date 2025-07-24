import "voxel_eras/scripts/player" as player;

const MAX_ENERGY = game::TICK_RATE * 48;
const ENERGY_PER_INTERACT = game::TICK_RATE * 12;
const INTERACT_DELAY = game::TICK_RATE / 4;
const PROGRESS_TO_MINE = game::TICK_RATE * 3;

fn define(mod_info) {
	import "factoreras/scripts/utils" as utils;

    mod_info.add(TextureBuilder(
        "SieveIcon:FactorEras",
        "factoreras/assets/textures/SieveSide.png"
    ));
    
    mod_info.add(
        VoxelBuilder(
            "SieveOff:FactorEras",
            "Sieve (Off)",
            "factoreras/scripts/machines/sieve.rhai"
        )
        .model(
            SolidVoxelModel(
                "factoreras/assets/textures/SieveTop.png",
                "factoreras/assets/textures/SieveSide.png",
                "voxel_eras/assets/textures/AlloyFurnaceBottom.png",
            )
        )
        .pipette("Sieve:FactorEras")
        .tag("Solid:VoxelEras")
        .break_rate(voxel::BREAK_RATE_MACHINE)
		.does_break()
        .does_interact()
        .does_interacting()
        .does_message()
        .does_tick()
        .does_action()
        .does_insert()
    );

	mod_info.add(
        VoxelBuilder(
            "SieveOn:FactorEras",
            "Sieve (On)",
            "factoreras/scripts/machines/sieve.rhai"
        )
        .model(
            SolidVoxelModel(
                "factoreras/assets/textures/SieveTop.png",
                "factoreras/assets/textures/SieveSideOnAnim.png",
                "voxel_eras/assets/textures/AlloyFurnaceBottom.png",
            )
        )
        .pipette("Sieve:FactorEras")
        .tag("Solid:VoxelEras")
        .break_rate(voxel::BREAK_RATE_MACHINE)
		.does_break()
        .does_interact()
        .does_interacting()
        .does_message()
        .does_tick()
        .does_action()
        .does_insert()
    );

	mod_info.add(
        VoxelBuilder(
            "SieveStuck:FactorEras",
            "Sieve (Stalled)",
            "factoreras/scripts/machines/sieve.rhai"
        )
        .model(
            SolidVoxelModel(
                "factoreras/assets/textures/SieveTop.png",
                "factoreras/assets/textures/SieveSideStuckAnim.png",
                "voxel_eras/assets/textures/AlloyFurnaceBottom.png",
            )
        )
        .pipette("Sieve:FactorEras")
        .tag("Solid:VoxelEras")
        .break_rate(voxel::BREAK_RATE_MACHINE)
		.does_break()
        .does_interact()
        .does_interacting()
        .does_message()
        .does_tick()
        .does_action()
        .does_insert()
    );

    mod_info.add(
		ConstructBuilder(
			"Sieve:FactorEras",
			"Sieve",
			"Find new materials from sieving gravel or sand with the power of clockwork!",
			"Machines",
			"SieveIcon:FactorEras",
			construct::ROT_COMPASS
		)
        .cost(WeakItemStack("WroughtIronIngot:VoxelEras", 8))
        .cost(WeakItemStack("OakPlank:VoxelEras", 8))
        .cost(WeakItemStack("ClockworkCore:VoxelEras", 1))
		.cost(WeakItemStack("SmallBronzeGear:VoxelEras", 2))
		.variant(
			ConstructVariantBuilder(voxel::ROT_UP)
				.place(
					0, 0, 0,
					WeakVoxelVariant("SieveOff:FactorEras", voxel::ROT_UP)
					    .add_state("State:Inventory", metadata::Inventory(1))
                        .add_state("State:ClockworkEnergy", metadata::U64(0))
                        .add_state("State:Progress", metadata::U64(0))
						.add_state("State:LastInteracted", metadata::U64(0))
				)
		)
        .variant(
			ConstructVariantBuilder(voxel::ROT_UP1)
				.place(
					0, 0, 0,
					WeakVoxelVariant("SieveOff:FactorEras", voxel::ROT_UP1)
					    .add_state("State:Inventory", metadata::Inventory(1))
                        .add_state("State:ClockworkEnergy", metadata::U64(0))
                        .add_state("State:Progress", metadata::U64(0))
						.add_state("State:LastInteracted", metadata::U64(0))
				)
		)
        .variant(
			ConstructVariantBuilder(voxel::ROT_UP2)
				.place(
					0, 0, 0,
					WeakVoxelVariant("SieveOff:FactorEras", voxel::ROT_UP2)
					    .add_state("State:Inventory", metadata::Inventory(1))
                        .add_state("State:ClockworkEnergy", metadata::U64(0))
                        .add_state("State:Progress", metadata::U64(0))
						.add_state("State:LastInteracted", metadata::U64(0))
				)
		)
        .variant(
			ConstructVariantBuilder(voxel::ROT_UP3)
				.place(
					0, 0, 0,
					WeakVoxelVariant("SieveOff:FactorEras", voxel::ROT_UP3)
					    .add_state("State:Inventory", metadata::Inventory(1))
                        .add_state("State:ClockworkEnergy", metadata::U64(0))
                        .add_state("State:Progress", metadata::U64(0))
						.add_state("State:LastInteracted", metadata::U64(0))
				)
		)
        .priority(20)
	);

	mod_info.add(
		RecipeBuilder(
			utils::id("GravelSieve"),
			"Sieve Gravel",
			0,
			utils::icon_id("Gravel", "VoxelEras")
		)
		.crafted_in(utils::id("Sieve"))
		.with_input(WeakItemStack(utils::id("Gravel", "VoxelEras"), 1))
		.with_output(WeakItemStack(utils::id("SulfurChunk"), 1))
		.with_output(WeakItemStack(utils::id("Sand", "VoxelEras"), 1))
	);

	mod_info.add(
		RecipeBuilder(
			utils::id("SandSieve"),
			"Sieve Sand",
			0,
			utils::icon_id("Sand", "VoxelEras")
		)
		.crafted_in(utils::id("Sieve"))
		.with_input(WeakItemStack(utils::id("Sand", "VoxelEras"), 1))
		.with_output(WeakItemStack(utils::id("GoldChunk"), 1))
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

        game_state.drop(WeakItemStack("WroughtIronIngot:VoxelEras", 8), location);
        game_state.drop(WeakItemStack("OakPlank:VoxelEras", 8), location);
        game_state.drop(WeakItemStack("ClockworkCore:VoxelEras", 1), location);
		game_state.drop(WeakItemStack("SmallBronzeGear:VoxelEras", 2), location);
	}

	event::ACCEPT
}

fn on_tick(voxel, location, game_state) {
	let metadata = voxel.metadata;
	let energy = metadata.get_u64("State:ClockworkEnergy");
	let progress = metadata.get_u64("State:Progress");
	let inventory = metadata.get_inventory();

	if energy == 0 && progress == 0 && voxel.prefab.identifier != "SieveOn:FactorEras" {
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

	let stalled = false;
	if progress >= global::PROGRESS_TO_MINE {
		let recipe = game_state.find_possible_recipe("Sieve:FactorEras", [inventory[0]], [(), (), (), ()]);
		if recipe != () {
			for output in recipe.outputs {
				if game_state.random_bool(0.5) {
					if game_state.try_insert(location.up(), voxel::SIDE_BOTTOM, output) {

					} else {
						let above = game_state.get_voxel(location.up());
						if above.prefab.identifier == "Air:VoxelEras" {
							game_state.drop(output, location.up());
						} else {
							stalled = true;
							break;
						}
					}
				}
			}
		} else {
			stalled = true;
		}

		if !stalled {
			inventory[0].quantity -= 1;
			progress -= global::PROGRESS_TO_MINE;
		}
	}

	let new_state = voxel.metadata;
	new_state.set_u64("State:Progress", progress);
	new_state.set_u64("State:ClockworkEnergy", energy);
	new_state.set_inventory(inventory);

	game_state.set_voxel(
		location,
		game_state.get_voxel_prefab(
			if stalled {
				"SieveStuck:FactorEras"
			} else if was_running {
				"SieveOn:FactorEras"
			} else {
				"SieveOff:FactorEras"
			}
		).get_variant(voxel.rotation, new_state)
	);
	
	event::ACCEPT
}

fn on_interact(voxel, location, entity, game_state) {
    entity.start_interacting(location);
    
    event::ACCEPT
}

fn on_interacting(voxel, location, entity, egui, client_state) {
	let game_state = client_state.game_state;
	egui.window(
		"SieveInteracting",
		|ui| {
			client_state.heading(
				ui,
				"SieveIcon:FactorEras",
				"Sieve",
				"Find new materials from sieving gravel or sand with the power of clockwork!"
			);

            // Render the Assembling Machine UI
			sieve_ui(ui, location, voxel, entity, client_state);

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

private fn sieve_ui(ui, location, voxel, entity, client_state) {
	ui.vertical_centered_justified(|ui| {
		ui.set_width(160.);

		ui.columns(1, |ui| {
			sieve_interactables(ui, location, voxel, entity, client_state);
		});
	});
}

private fn sieve_interactables(ui, location, voxel, entity, client_state) {
	let metadata = voxel.metadata;
	let inventory = metadata.get_inventory();
	let selected_slot = entity.metadata.get_slot_ref("State:SelectedSlot");

	ui[0].vertical(|ui| {
		ui.horizontal_top(|ui| {
			let slot_interact = client_state.inventory_slot(
				ui,
				inventory[0],
				if selected_slot != () {
					selected_slot.inventory_index == 1 && selected_slot.slot_index == 0
				} else {
					false
				},
				"",
				"Insert dust (gravel or sand) into this slot.\nCan be input into from the bottom or sides."
			);

			if slot_interact.clicked_down() || slot_interact.secondary_clicked() {
				let metadata = MetaData();
				metadata.set_slot_ref("State:ClickedSlot", metadata::SlotRef(
					1,
					0,
					slot_interact.clicked_down(),
					slot_interact.shifting(),
				));
				client_state.action(location, "Transfer", metadata);
			}
		});
	});
}

fn on_insert(voxel, location, slot, items, direction, game_state) {
	if direction == voxel::SIDE_TOP { return event::CANCEL; }

	let metadata = voxel.metadata;

	let found_recipe = game_state.find_possible_recipe("Sieve:FactorEras", [items], [(), (), (), ()]);
	if found_recipe == () {
		return event::CANCEL; 
	}

	event::ACCEPT
}

fn on_message(voxel, location, type, message, game_state) {
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
		voxel.get_variant(new_state)
	);

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