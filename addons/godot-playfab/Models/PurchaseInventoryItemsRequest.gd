extends JsonSerializable
class_name PurchaseInventoryItemsRequest

## The amount to purchase. 
var Amount: float 


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
