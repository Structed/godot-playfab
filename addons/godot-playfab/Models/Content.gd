extends JsonSerializable
class_name Content

## The content unique ID.
var Id: String

## The maximum client version that this content is compatible with. Client Versions can be up to 3 segments separated by periods(.) and each segment can have a maximum value of 65535.
var MaxClientVersion: String

## The minimum client version that this content is compatible with. Client Versions can be up to 3 segments separated by periods(.) and each segment can have a maximum value of 65535.
var MinClientVersion: String

## The list of tags that are associated with this content. Tags must be defined in the Catalog Config before being used in content.
var Tags: Array[String]

## The client-defined type of the content. Content Types must be defined in the Catalog Config before being used.
var Type: String

## The Azure CDN URL for retrieval of the catalog item binary content.
var Url: String


func _get_type_for_property(property_name: String) -> String:
	match property_name:
#		"<PROPERTY NAME>":
#			return "<PROPERTY TYPE>"
		_:
			pass

	push_error("Could not find mapping for property: " + property_name)
	return super._get_type_for_property(property_name)

