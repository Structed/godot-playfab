extends JsonSerializable
class_name PurchaseInventoryItemsRequest

## The amount to purchase.
var Amount: int


## The id of the entity's collection to perform this action on. (Default="default"). The number of inventory collections is unlimited.
var CollectionId: String


## The optional custom tags associated with the request (e.g. build number, external trace identifiers, etc.).
var CustomTags: Dictionary[String, Variant]


## Indicates whether stacks reduced to an amount of 0 during the request should be deleted from the inventory. (Default=false)
var DeleteEmptyStacks: bool


## The duration to purchase.
var DurationInSeconds: float


## ETags are used for concurrency checking when updating resources. More information about using ETags can be found here: https://learn.microsoft.com/en-us/gaming/playfab/features/economy-v2/catalog/etags
var ETag: String


## The entity to perform this action on.
var Entity: EntityKey


## The Idempotency ID for this request. Idempotency IDs can be used to prevent operation replay in the medium term but will be garbage collected eventually.
var IdempotencyId: String


## The inventory item the request applies to.
var Item: InventoryItemReference


## The values to apply to a stack newly created by this request.
var NewStackValues: InitialValues


## The per-item price the item is expected to be purchased at. This must match a value configured in the Catalog or specified Store.
var PriceAmounts: Array[PurchasePriceAmount]


## The id of the Store to purchase the item from.
var StoreId: String



func _get_type_for_property(property_name: String) -> String:
	match property_name:
#		"<PROPERTY NAME>":
#			return "<PROPERTY TYPE>"
		_:
			pass

	push_error("Could not find mapping for property: " + property_name)
	return super._get_type_for_property(property_name)

static func from_catalog_item(purchase_amount: float, catalog_item: CatalogItem) -> PurchaseInventoryItemsRequest:

	var request_data := PurchaseInventoryItemsRequest.new()
	request_data.Amount = purchase_amount

	var item_reference = InventoryItemReference.new()
	item_reference.Id = catalog_item.Id
#	item_reference.AlternateId = catalog_item.AlternateIds[0]
#	item_reference.StackId = catalog_item.DefaultStackId
	request_data.Item = item_reference

	var price_amounts : Array[PurchasePriceAmount]

	# Find the price option that matches the purchase amount
	var catalog_item_price_key = catalog_item.PriceOptions.Prices.find_custom(func(item: CatalogPrice) -> bool:
		if item.UnitAmount == purchase_amount:
			return true

		return false
	)

	if catalog_item_price_key == -1:
		push_error("Could not find price option for item: " + catalog_item.Id + " with amount: " + str(purchase_amount))
		return request_data


	for catalog_price_amount in catalog_item.PriceOptions.Prices[catalog_item_price_key].Amounts:
		var price_amount = PurchasePriceAmount.new()
		price_amount.ItemId = catalog_price_amount.ItemId
		price_amount.Amount = catalog_price_amount.Amount
		price_amounts.append(price_amount)

	request_data.PriceAmounts = price_amounts

	return request_data
