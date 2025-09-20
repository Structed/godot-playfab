extends JsonSerializable
class_name RealMoneyPriceDetails

## The 'AppleAppStore' price amount per CurrencyCode. 'USD' supported only.
var AppleAppStorePrices: Object

## The 'GooglePlay' price amount per CurrencyCode. 'USD' supported only.
var GooglePlayPrices: Object

## The 'MicrosoftStore' price amount per CurrencyCode. 'USD' supported only.
var MicrosoftStorePrices: Object

## The 'NintendoEShop' price amount per CurrencyCode. 'USD' supported only.
var NintendoEShopPrices: Object

## The 'PlayStationStore' price amount per CurrencyCode. 'USD' supported only.
var PlayStationStorePrices: Object

## The 'Steam' price amount per CurrencyCode. 'USD' supported only.
var SteamPrices: Object


func _get_type_for_property(property_name: String) -> String:
	match property_name:
#		"<PROPERTY NAME>":
#			return "<PROPERTY TYPE>"
		_:
			pass

	push_error("Could not find mapping for property: " + property_name)
	return super._get_type_for_property(property_name)

