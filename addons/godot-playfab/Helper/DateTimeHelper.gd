extends Reference
class_name DateTimeHelper


func to_date_time(unix_timestamp: int, total_milliseconds_since_epoch: int) -> String:
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
	
	print_debug(datetime_string)	
	
	return datetime_string # 2022-10-21T12:01:23.6761898Z
