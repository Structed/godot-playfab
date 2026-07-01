extends JsonSerializable
class_name StoreReference

## An alternate ID of the store.
var AlternateId: CatalogAlternateId

## The unique ID of the store.
var Id: String


func _get_type_for_property(property_name: String) -> String:
	match property_name:
#		"<PROPERTY NAME>":
#			return "<PROPERTY TYPE>"
		"AlternateId":
			return "CatalogAlternateId"
		_:
			pass

	push_error("Could not find mapping for property: " + property_name)
	return super._get_type_for_property(property_name)

