extends JsonSerializable
class_name EntityKey

## Combined entity type and ID structure which uniquely identifies a single entity.
## See: https://docs.microsoft.com/en-us/gaming/playfab/features/data/entities/available-built-in-entity-types
## Entity keys identify entities in most of the newer API methods.
## You use the value of the EntityKey.Type field to determine the type of value to set in the ID field.
## Note:
## ENTITY KEYS ARE CASE SENSITIVE.

## The namespace entity refers to all global information for all titles within your studio.
## Note:
## Changes to this entity are not reflected in real time.
## Set the ID field to your game's Publisher ID. To retrieve your Publisher ID:
##  * Sign in to Game Manager.
##  * In the upper left-hand corner of Game Manger, select the gear icon.
##  * Select Title Settings.
##  * Select API Features.
## The Publisher ID is displayed in the API ACCESS section.
const ENTITY_TYPE_NAMESPACE = "namespace"

## The title entity refers to all global information for that title.
## Note:
## Changes to this entity are not reflected in real time.
## Set the ID field to your game's Title ID. To retrieve the Title ID:
##  * Sign in to Game Manager.
##  * In the upper left-hand corner of Game Manger, select the gear icon.
##  * Select Title Settings.
##  * Select API Features.
## The Title ID is displayed in the API ACCESS section.
const ENTITY_TYPE_TITLE = "title"

## The master_player_account is a player entity that is shared by all titles within your studio.
## Set the ID field to the LoginResult.PlayFabId from the classic API. To retrieve the LoginResult, call one of the login methods in Client Authentication.
const ENTITY_TYPE_MASTER_PLAYER_ACCOUNT = "master_player_account"

## For most developers, title_player_account represents the player in the most traditional way.
## Set the ID field to LoginResult.EntityToken.Entity.Id in the client API, or GetEntityTokenResponse.Entity.Id in the authentication API.
## To retrieve the LoginResult, call one of the login methods in Client Authentication. To retrieve the GetEntityTokenResponse, call Get Entity Token.
const ENTITY_TYPE_TITLE_PLAYER_ACCOUNT = "title_player_account"

## The character entity is a sub-entity of title_player_account, and is a direct mirror of Characters in the Classic APIs.
## Set the ID field to any characterId from result.Characters[i].CharacterId.
const ENTITY_TYPE_CHARACTER = "character"

## The group entity is a container for other entities. It is currently limited to players and characters.
## Set the ID field to the result.Group.Id if you are creating a group, or the result.Groups[i].Group.Id when listing your memberships.
const ENTITY_TYPE_GROUP = "group"

## The service entity is reserved for internal use.
const ENTITY_TYPE_SERVICE = "service"

# Unique ID of the entity.
var Id: String

# Entity type - one of ENTITY_TYPE_*. See https://docs.microsoft.com/gaming/playfab/features/data/entities/available-built-in-entity-types
var Type: String

