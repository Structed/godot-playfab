extends JsonSerializable
class_name PurchasePriceAmount

## The amount of the inventory item to use in the purchase . 
var Amount: int 


## The inventory item id to use in the purchase . 
var ItemId: String 


## The inventory stack id the to use in the purchase. Set to "default" by default 
var StackId: String 



func _get_type_for_property(property_name: String) -> String:
	match property_name:
#		"<PROPERTY NAME>":
#			return "<PROPERTY TYPE>"
		_:
			pass

	push_error("Could not find mapping for property: " + property_name)
	return super._get_type_for_property(property_name)
