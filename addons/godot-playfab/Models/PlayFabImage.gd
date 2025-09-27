extends JsonSerializable
class_name PlayFabImage

## The image unique ID.
var Id: String

## The client-defined tag associated with this image. Tags must be defined in the Catalog Config before being used in images
var Tag: String

## Images can be defined as either a "thumbnail" or "screenshot". There can only be one "thumbnail" image per item.
var Type: String

## The URL for retrieval of the image.
var Url: String


func _get_type_for_property(property_name: String) -> String:
	match property_name:
#		"<PROPERTY NAME>":
#			return "<PROPERTY TYPE>"
		_:
			pass

	push_error("Could not find mapping for property: " + property_name)
	return super._get_type_for_property(property_name)
