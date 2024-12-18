# GdUnit generated TestSuite
class_name UuidTest
extends GdUnitTestSuite
@warning_ignore('unused_parameter')
@warning_ignore('return_value_discarded')

# TestSuite generated from
const __source = 'res://addons/godot-playfab/lib/binogure-studio/godot-uuid/uuid.gd'


func test_uuidbin() -> void:
	var test_array: Array = UUID.uuidbin()
	assert_array(test_array).is_not_empty()
	assert_int(test_array.size()).is_equal(16)
	for i in test_array:
		assert_int(i).is_greater_equal(0)
		assert_int(i).is_less_equal(255)



func test_uuidbinrng() -> void:
	var test_array: Array = UUID.uuidbinrng(RandomNumberGenerator.new())
	assert_array(test_array).is_not_empty()
	assert_int(test_array.size()).is_equal(16)
	for i in test_array:
		assert_int(i).is_greater_equal(0)
		assert_int(i).is_less_equal(255)



func test_v4() -> void:
	var test_string: String = UUID.v4()
	assert_str(test_string).has_length(36)
	var regex: RegEx = RegEx.new()
	regex.compile("^[0-9a-fA-F]{8}\\b-[0-9a-fA-F]{4}\\b-[0-9a-fA-F]{4}\\b-[0-9a-fA-F]{4}\\b-[0-9a-fA-F]{12}$")
	assert_str(regex.search(test_string).to_string()).is_not_empty()
	


func test_v4_rng() -> void:
	var test_string: String = UUID.v4_rng(RandomNumberGenerator.new())
	assert_str(test_string).has_length(36)
	var regex: RegEx = RegEx.new()
	regex.compile("^[0-9a-fA-F]{8}\\b-[0-9a-fA-F]{4}\\b-[0-9a-fA-F]{4}\\b-[0-9a-fA-F]{4}\\b-[0-9a-fA-F]{12}$")
	assert_str(regex.search(test_string).to_string()).is_not_empty()


func test_as_array() -> void:
	var test_uuid: UUID = auto_free(UUID.new())
	var test_array: Array = test_uuid.as_array()
	assert_array(test_array).is_not_empty()
	assert_int(test_array.size()).is_equal(16)
	for i in test_array:
		assert_int(i).is_greater_equal(0)
		assert_int(i).is_less_equal(255)
	
	


func test_as_dict() -> void:
	var test_uuid: UUID = auto_free(UUID.new())
	var test_array: Array = []
	var test_low_endian_dict: Dictionary = test_uuid.as_dict(false)
	test_array.append(test_low_endian_dict)
	var test_high_endian_dict:Dictionary = test_uuid.as_dict()
	test_array.append(test_high_endian_dict)
	for i in test_array:
		assert_dict(i).is_not_empty()
		assert_dict(i).contains_keys(["low", "mid", "hi", "clock", "node"])
		assert_dict(i).has_size(5)
		assert_int(i["low"]).is_greater_equal(0)
		assert_int(i["mid"]).is_greater_equal(0)
		assert_int(i["hi"]).is_greater_equal(0)
		assert_int(i["clock"]).is_greater_equal(0)
		assert_int(i["node"]).is_greater_equal(0)
		assert_int(i["low"]).is_less_equal((2**(4*8))-1)
		assert_int(i["mid"]).is_less_equal((2**(2*8))-1)
		assert_int(i["hi"]).is_less_equal((2**(2*8))-1)
		assert_int(i["clock"]).is_less_equal((2**(2*8))-1)
		assert_int(i["node"]).is_less_equal((2**(6*8))-1)
		

func test_as_string() -> void:
	var test_uuid: UUID = auto_free(UUID.new())
	var test_string: String = test_uuid.as_string()
	assert_str(test_string).has_length(36)
	var regex: RegEx = RegEx.new()
	regex.compile("^[0-9a-fA-F]{8}\\b-[0-9a-fA-F]{4}\\b-[0-9a-fA-F]{4}\\b-[0-9a-fA-F]{4}\\b-[0-9a-fA-F]{12}$")
	assert_str(regex.search(test_string).to_string()).is_not_empty()


func test_is_equal() -> void:
	var test_uuid: UUID = auto_free(UUID.new())
	var same_uuid: UUID = test_uuid
	var other_uuid: UUID = auto_free(UUID.new())
	assert_bool(test_uuid.is_equal(same_uuid)).is_true()
	assert_bool(test_uuid.is_equal(other_uuid)).is_false()
