extends JsonSerializable
class_name JsonSerializableImpl

var foo: String = "foo_value"
var bar: String = "bar_value"


class WithNotSetObjectProperty:
	extends JsonSerializable

	var sub_prop: SubProp


class WithSetObjectProperty:
	extends JsonSerializable

	var sub_prop: SubProp = SubProp.new()


class WithBuiltinObject:
	extends JsonSerializable

	var node: Node = Node.new()
