extends JsonSerializable
class_name JsonSerializableImpl

var foo: String = "foo_value"
var bar: String = "bar_value"


class WithBuiltinObject:
    extends JsonSerializable

    var node: Node = Node.new()