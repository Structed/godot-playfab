extends Reference
class_name EntityTokenResponse

## The entity id and type.
var Entity#: EntityKey

## The token used to set X-EntityToken for all entity based API calls.
var EntityToken: String

## The time the token will expire, if it is an expiring token, in UTC.
var TokenExpiration: String
