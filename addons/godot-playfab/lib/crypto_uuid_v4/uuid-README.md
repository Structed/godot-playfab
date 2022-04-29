# Crypto UUID v4

This addon provides cryptographically secure UUID v4 objects (as references) and String representations in line with [official guidelines](https://www.itu.int/rec/T-REC-X.667-200409-S/en)

Web builds will attempt to use the web browser-provided crypto object if available, and only fall back to weak pseudorandom numbers as a last resort.

## Usage

### Generating UUIDs:
1. `UUID.new() -> UUID` generates a new randomized UUIDv4 object. (See following sections for usage.)

**OR**

2. `UUID.v4() -> String` generates a plain UUIDv4 string. (This is a `static` function, you do not need to call `new()` first.)

### Comparing UUIDs:
1. `uuid_a.is_equal(uuid_b) -> bool` can compare UUID objects, a UUID object against a UUID string, or a UUID object against a PoolByteArray containing 16 bytes.
2. `str(uuid_a) == str(uuid_b)` can compare any two UUID string representations or objects

### Other functionality:
- `str(uuid)` returns the formatted `String` representation of a UUID object, in the same standard format as `UUID.v4()` would generate.
- `UUID.new(from: String) -> UUID` returns a UUID object from a valid UUID String representation (eg. if serialized)
- `UUID.new(from: PoolByteArray) -> UUID` returns a UUID object from a PoolByteArray containing 16 bytes
- `UUID.v4bin() -> PoolByteArray` generates an array containing 16 bytes
- `UUID.format(data: PoolByteArray) -> String` generates a UUID string from a `PoolByteArray` containing 16 bytes (no validation checks)
