extends JsonSerializable
class_name CatalogPrice

## The amounts of the catalog item price. Each price can have up to 15 item amounts.
var Amounts: Array[CatalogPriceAmount]

## The per-unit amount this price can be used to purchase.
var UnitAmount: float

## The per-unit duration this price can be used to purchase. The maximum duration is 100 years.
var UnitDurationInSeconds: float


func _get_type_for_property(property_name: String) -> String:
	match property_name:
#		"<PROPERTY NAME>":
#			return "<PROPERTY TYPE>"
		_:
			pass

	push_error("Could not find mapping for property: " + property_name)
	return super._get_type_for_property(property_name)
