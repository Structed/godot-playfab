extends Control
class_name ItemCard


func reset(catalog_item: CatalogItem) -> void:
	%Title.text = catalog_item.Title[PlayFab.LANG_NEUTRAL]
	%Description.text = catalog_item.Description[PlayFab.LANG_NEUTRAL]
	%Type.text = catalog_item.Type

	for price in catalog_item.PriceOptions.Prices:
		var unit_amount: float = price.UnitAmount
		var text: String = "%s pieces: " % [unit_amount]

		for currency_amount in price.Amounts:
			var currency := PlayFabManager.catalog.resolve_item(currency_amount.ItemId)
			text += "| %s (%s)" % [currency_amount.Amount, currency.Title.get(PlayFab.LANG_NEUTRAL)]

		var buy_button = Button.new()
		buy_button.text = text
		buy_button.pressed.connect(_on_purchase_button_pressed.bindv([unit_amount, catalog_item]))
		%VirtualPrices.add_child(buy_button)


func reset_inventory(catalog_item: CatalogItem, inventory_item: InventoryItem) -> void:
	%Title.text = catalog_item.Title[PlayFab.LANG_NEUTRAL]
	%Description.text = catalog_item.Description[PlayFab.LANG_NEUTRAL]
	%Type.text = catalog_item.Type
	%Amount.text = "%dx" % inventory_item.Amount


func _on_purchase_button_pressed(amount: int, catalog_item: CatalogItem) -> void:
	var request_data := PurchaseInventoryItemsRequest.from_catalog_item(amount, catalog_item)

	PlayFabManager.inventory.purchase_inventory_items(request_data, func(_response: PurchaseInventoryItemsResponse):
		PlayFabManager.inventory.turboload_inventory(func():
			ToastParty.show({
				"text": "🪙 Purchased %sx %s." % [amount, catalog_item.Title.get(PlayFab.LANG_NEUTRAL)],           # Text (emojis can be used)
				"bgcolor": Color(0, 0, 0, 0.7),     # Background Color
				"color": Color(1, 1, 1, 1),         # Text Color
				"gravity": "top",                   # top or bottom
				"direction": "right",               # left or center or right
				"text_size": 18,                    # [optional] Text (font) size // experimental (warning!)
				"use_font": false                   # [optional] Use custom ToastParty font // experimental (warning!)
			})
		)
	)
