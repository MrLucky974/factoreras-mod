fn id(name, mod_id) {
    name + ":" + mod_id
}

fn id(name) {
    const MOD_ID = "FactorEras";
    id(name, MOD_ID)
}

fn icon_id(name) {
    id(name + "Icon")
}

fn icon_id(name, mod_id) {
    id(name + "Icon", mod_id)
}

fn define_item_only(mod_info, item_id, item_name, icon_id, description) {
    mod_info.add(ItemBuilder(
        id(item_id),
        item_name,
        description,
        icon_id,
    ));
}

fn define_item_only(mod_info, item_name, icon_id, description) {
    let item_id = item_name;
    item_id.replace(" ", "");

    define_item_only(mod_info, item_id, item_name, icon_id, description);
}

fn define_item_only(mod_info, item_name, icon_id) {
    let item_id = item_name;
    item_id.replace(" ", "");

    define_item_only(mod_info, item_name, icon_id, "");
}

fn define_icon(mod_info, icon_id, icon_path) {
    mod_info.add(TextureBuilder(
		icon_id,
		icon_path,
	));
}

fn define_icon(mod_info, icon_id) {
    define_icon(mod_info, icon_id, "factoreras/assets/items/"+ icon_id +".png");
}

fn define_item(mod_info, item_id, item_name, icon_path, description) {
    let icon_id = icon_id(item_id);

    define_icon(mod_info, icon_id, icon_path);
    define_item_only(mod_info, item_id, item_name, icon_id, description);
}

fn define_item(mod_info, item_name, icon_path, description) {
    let item_id = item_name;
    item_id.replace(" ", "");
    
    define_item(mod_info, item_id, item_name, icon_path, description);
}

fn define_item(mod_info, item_name, description) {
    let item_id = item_name;
    item_id.replace(" ", "");
    define_item(mod_info, item_name, "factoreras/assets/items/"+ item_id +".png", description);
}

fn define_item(mod_info, item_name) {
    let item_id = item_name;
    item_id.replace(" ", "");
    define_item(mod_info, item_name, "");
}