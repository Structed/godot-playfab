extends Reference
class_name DateTimeHelper

# Returns a ISO 8601 formatted DateTime string, including second fractions (ms)
# Example: 2022-10-21T12:01:23.6761898Z
#
# @returns: int - A ISO 8601 Date Time String (UTC)
static func get_date_time_string_utc() -> String:
	var unix_time_stamp = OS.get_unix_time()
	var total_milliseconds_since_epoch = OS.get_system_time_msecs()

	var datetime = to_date_time(unix_time_stamp, total_milliseconds_since_epoch)
	
	return datetime


# Returns a ISO 8601 formatted DateTime string, including second fractions (ms)
# Example: 2022-10-21T12:01:23.6761898Z
#
# @param unix_timestamp: int - Typically from `OS.get_unix_time()`
# @param total_milliseconds_since_epoch: int - Typically from `OS.get_system_time_msecs()`
#
# @returns: int - A ISO 8601 Date Time String (UTC)
static func to_date_time(unix_timestamp: int, total_milliseconds_since_epoch: int) -> String:
	var ms_string: String = (total_milliseconds_since_epoch as String)
	var msecs = ms_string.right(ms_string.length() - 3) # Take the last three digits, as that is the ms fraction of the second

	var date_time = OS.get_datetime_from_unix_time(unix_timestamp)
	var datetime_string = "%s-%s-%sT%s:%s:%s.%sZ" % [
		date_time["year"],
		(date_time["month"] as String).pad_zeros(2),
		(date_time["day"] as String).pad_zeros(2),
		(date_time["hour"] as String).pad_zeros(2),
		(date_time["minute"] as String).pad_zeros(2),
		(date_time["second"] as String).pad_zeros(2),
		msecs
	]
	
	return datetime_string
