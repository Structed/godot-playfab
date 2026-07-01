extends JsonSerializable
class_name StoreDetails

## The options for the filter in filter-based stores. These options are mutually exclusive with item references.
var FilterOptions: FilterOptions

## The permissions that control which players can purchase from the store.
var Permissions: Permissions

## The global prices utilized in the store. These options are mutually exclusive with price options in item references.
var PriceOptionsOverride: CatalogPriceOptionsOverride


func _get_type_for_property(property_name: String) -> String:
	match property_name:
#		"<PROPERTY NAME>":
#			return "<PROPERTY TYPE>"
		_:
			pass

	push_error("Could not find mapping for property: " + property_name)
	return super._get_type_for_property(property_name)

