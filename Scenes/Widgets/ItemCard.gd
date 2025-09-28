extends Control
class_name ItemCard


func reset(catalog_item: CatalogItem) -> void:
	%Title.text = catalog_item.Title[PlayFab.LANG_NEUTRAL]
	%Description.text = catalog_item.Description[PlayFab.LANG_NEUTRAL]
	%Type.text = catalog_item.Type

	for price in catalog_item.PriceOptions.Prices:
		var unit_amount: float = price.UnitAmount
		var price_amount = price.Amounts[0]["Amount"]
		var text: String = "%s pieces: %sG" % [unit_amount, price_amount]
		var buy_button = Button.new()
		buy_button.text = text
		%VirtualPrices.add_child(buy_button)
