extends RefCounted
class_name ApiErrorWrapper

# Numerical HTTP code
var code: int

# Playfab error code
var error: String

# Numerical PlayFab error code
var errorCode: int

# Detailed description of individual issues with the request object
var errorDetails

# Description for the PlayFab errorCode
var errorMessage: String

# String HTTP code
var status: String
