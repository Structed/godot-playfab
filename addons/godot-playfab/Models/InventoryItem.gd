extends JsonSerializable
class_name InventoryItem

## The amount of the item. 
var Amount: float 


## Game specific properties for display purposes. This is an arbitrary JSON blob. The Display Properties field has a 1000 byte limit. 
var DisplayProperties: Dictionary[String, Variant] 


## Only used for subscriptions. The date of when the item will expire in UTC. 
var ExpirationDate: String 


## The id of the item. This should correspond to the item id in the catalog. 
var Id: String 


## The stack id of the item. 
var StackId: String 


## The type of the item. This should correspond to the item type in the catalog. 
var Type: String 



func _get_type_for_property(property_name: String) -> String:
	match property_name:
#		"<PROPERTY NAME>":
#			return "<PROPERTY TYPE>"
		_:
			pass

	push_error("Could not find mapping for property: " + property_name)
	return super._get_type_for_property(property_name)

