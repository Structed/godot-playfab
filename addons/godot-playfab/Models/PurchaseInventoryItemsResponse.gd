extends JsonSerializable
class_name PurchaseInventoryItemsResponse

## ETags are used for concurrency checking when updating resources. More information about using ETags can be found here: https://learn.microsoft.com/en-us/gaming/playfab/features/economy-v2/catalog/etags 
var ETag: String 


## The idempotency id used in the request. 
var IdempotencyId: String 


## The ids of transactions that occurred as a result of the request. 
var TransactionIds: Array[String] 



func _get_type_for_property(property_name: String) -> String:
	match property_name:
#		"<PROPERTY NAME>":
#			return "<PROPERTY TYPE>"
		_:
			pass

	push_error("Could not find mapping for property: " + property_name)
	return super._get_type_for_property(property_name)
