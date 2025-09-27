extends JsonSerializable
class_name CatalogItem

## The alternate IDs associated with this item. An alternate ID can be set to 'FriendlyId' or any of the supported marketplace names.
var AlternateIds: Array[CatalogAlternateId]

## The client-defined type of the item.
var ContentType: String

## The set of content/files associated with this item. Up to 100 files can be added to an item.
var Contents: Array[Content]

## The date and time when this item was created.
var CreationDate: String

## The ID of the creator of this catalog item.
var CreatorEntity: EntityKey

## The set of platform specific deep links for this item.
var DeepLinks: Array[DeepLink]

## The Stack Id that will be used as default for this item in Inventory when an explicit one is not provided. This DefaultStackId can be a static stack id or '{guid}', which will generate a unique stack id for the item. If null, Inventory's default stack id will be used.
var DefaultStackId: String

## A dictionary of localized descriptions. Key is language code and localized string is the value. The NEUTRAL locale is required. Descriptions have a 10000 character limit per country code.
var Description: Dictionary[String, String]

## Game specific properties for display purposes. This is an arbitrary JSON blob. The Display Properties field has a 10000 byte limit per item.
var DisplayProperties: Dictionary

## The user provided version of the item for display purposes. Maximum character length of 50.
var DisplayVersion: String

## The current ETag value that can be used for optimistic concurrency in the If-None-Match header.
var ETag: String

## The date of when the item will cease to be available. If not provided then the product will be available indefinitely.
var EndDate: String

## The unique ID of the item.
var Id: String

## The images associated with this item. Images can be thumbnails or screenshots. Up to 100 images can be added to an item. Only .png, .jpg, .gif, and .bmp file types can be uploaded
var Images: Array[PlayFabImage]

## Indicates if the item is hidden.
var IsHidden: bool

## The item references associated with this item. For example, the items in a Bundle/Store/Subscription. Every item can have up to 50 item references.
var ItemReferences: Array[CatalogItemReference]

## A dictionary of localized keywords. Key is language code and localized list of keywords is the value. Keywords have a 50 character limit per keyword and up to 32 keywords can be added per country code.
var Keywords: Dictionary[String, String]

## The date and time this item was last updated.
var LastModifiedDate: String

## The moderation state for this item.
var Moderation: ModerationState

## The platforms supported by this item.
var Platforms: Array[String]

## The prices the item can be purchased for.
var PriceOptions: CatalogPriceOptions

## Rating summary for this item.
var Rating: Rating

## The real price the item was purchased for per marketplace.
var RealMoneyPriceDetails: RealMoneyPriceDetails

## The date of when the item will be available. If not provided then the product will appear immediately.
var StartDate: String

## Optional details for stores items.
var StoreDetails: StoreDetails

## The list of tags that are associated with this item. Up to 32 tags can be added to an item.
var Tags: Array[String]

## A dictionary of localized titles. Key is language code and localized string is the value. The NEUTRAL locale is required. Titles have a 512 character limit per country code.
var Title: Dictionary[String, String]

## The high-level type of the item. The following item types are supported: bundle, catalogItem, currency, store, ugc, subscription.
var Type: String


func _get_type_for_property(property_name: String) -> String:
	match property_name:
		"CreatorEntity":
			return "EntityKey"
		"Moderation":
			return "ModerationState"
		"PriceOptions":
			return "CatalogPriceOptions"
		"Rating":
			return "Rating"
		"RealMoneyPriceDetails":
			return "RealMoneyPriceDetails"
		"StoreDetails":
			return "StoreDetails"
		_:
			pass

	push_error("Could not find mapping for property: " + property_name)
	return super._get_type_for_property(property_name)

const ITEM_TYPE_BUNDLE: String = "bundle"
const ITEM_TYPE_CATALOG_ITEM: String = "catalogItem"
const ITEM_TYPE_CURRENCY: String = "currency"
const ITEM_TYPE_STORE: String = "store"
const ITEM_TYPE_UGC: String = "ugc"
const ITEM_TYPE_SUBSCRIPTION: String = "subscription"
