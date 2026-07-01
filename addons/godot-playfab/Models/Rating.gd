extends JsonSerializable
class_name Rating

## The average rating for this item.
var Average: float

## The total count of 1 star ratings for this item.
var Count1Star: int

## The total count of 2 star ratings for this item.
var Count2Star: int

## The total count of 3 star ratings for this item.
var Count3Star: int

## The total count of 4 star ratings for this item.
var Count4Star: int

## The total count of 5 star ratings for this item.
var Count5Star: int

## The total count of ratings for this item.
var TotalCount: int


func _get_type_for_property(property_name: String) -> String:
	match property_name:
#		"<PROPERTY NAME>":
#			return "<PROPERTY TYPE>"
		_:
			pass

	push_error("Could not find mapping for property: " + property_name)
	return super._get_type_for_property(property_name)

