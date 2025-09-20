extends JsonSerializable
class_name ModerationState

## The date and time this moderation state was last updated.
var LastModifiedDate: String

## The current stated reason for the associated item being moderated.
var Reason: String

## The current moderation status for the associated item.
var Status: ModerationStatus


func _get_type_for_property(property_name: String) -> String:
	match property_name:
#		"<PROPERTY NAME>":
#			return "<PROPERTY TYPE>"
		_:
			pass

	push_error("Could not find mapping for property: " + property_name)
	return super._get_type_for_property(property_name)

enum ModerationStatus {
	Unknown,
	Moderation,
	Approved,
	Rejected
}
