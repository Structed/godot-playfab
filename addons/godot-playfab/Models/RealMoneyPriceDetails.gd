extends JsonSerializable
class_name RealMoneyPriceDetails

## The 'AppleAppStore' price amount per CurrencyCode. 'USD' supported only.
var AppleAppStorePrices: Dictionary[String, String]


## The 'GooglePlay' price amount per CurrencyCode. 'USD' supported only.
var GooglePlayPrices: Dictionary[String, String]


## The 'MicrosoftStore' price amount per CurrencyCode. 'USD' supported only.
var MicrosoftStorePrices: Dictionary[String, String]


## The 'NintendoEShop' price amount per CurrencyCode. 'USD' supported only.
var NintendoEShopPrices: Dictionary[String, String]


## The 'PlayStationStore' price amount per CurrencyCode. 'USD' supported only.
var PlayStationStorePrices: Dictionary[String, String]


## The 'Steam' price amount per CurrencyCode. 'USD' supported only.
var SteamPrices: Dictionary[String, String]



func _get_type_for_property(property_name: String) -> String:
	match property_name:
#		"<PROPERTY NAME>":
#			return "<PROPERTY TYPE>"
		_:
			pass

	push_error("Could not find mapping for property: " + property_name)
	return super._get_type_for_property(property_name)
