extends AbstractJsonSerializableCollection
class_name PlayerStatisticVersionCollection

func _init():
	_item_type = PlayerStatisticVersion

# Determine the latest Statistic version
# @returns: int - The latest Statistic version number
func get_latest_version() -> int:
	var version: int = 0
	for element in _Items:
		if element.Version > version:
			version = element.Version

	return version