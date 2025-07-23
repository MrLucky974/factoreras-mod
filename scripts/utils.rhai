fn id(name) {
    name + ":FactorEras"
}

fn define_item(mod_info, item_name, icon_path, description) {
    let item_id = item_name;
    item_id.replace(" ", "");
    let icon_id = id(item_id + "Icon");

    mod_info.add(TextureBuilder(
		icon_id,
		icon_path,
	));

    mod_info.add(ItemBuilder(
        id(item_id),
        item_name,
        description,
        icon_id,
    ));
}