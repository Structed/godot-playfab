# Steam Inventory Scene

## Overview
A new scene that displays all items from the Steam inventory of the logged-in Steam user. Items are shown as cards with their name, image, and quantity.

## Files Created

### 1. SteamInventory.gd & SteamInventory.tscn
**Path:** `Scenes/Economy/SteamInventory.gd` and `Scenes/Economy/SteamInventory.tscn`

The main scene that:
- Checks if Steam is available and running
- Loads Steam inventory items and definitions
- Displays items in a grid layout using cards
- Handles refresh functionality
- Shows appropriate messages when Steam is unavailable or inventory is empty

### 2. SteamItemCard.gd & SteamItemCard.tscn
**Path:** `Scenes/Widgets/SteamItemCard.gd` and `Scenes/Widgets/SteamItemCard.tscn`

A card widget that displays:
- Item icon (loaded from URL if available)
- Item name
- Item description
- Quantity in stack (e.g., "5x")

### 3. Updated Economy.gd & Economy.tscn
**Path:** `Scenes/Economy.gd` and `Scenes/Economy.tscn`

Added a "Steam Inventory" button that navigates to the new Steam Inventory scene.

## Features

### Steam Integration
- Uses GodotSteam API to fetch inventory data
- Calls `Steam.loadItemDefinitions()` to get item metadata
- Calls `Steam.getAllItems()` to retrieve user's inventory
- Properly handles Steam result codes

### Signal Handling
- Connects to `Steam.inventory_definition_update` signal for definitions
- Connects to `Steam.inventory_result_ready` signal for inventory items
- Uses CONNECT_ONE_SHOT to avoid duplicate connections
- Subscribes to `PlayFabSteam.inventory_updated` for automatic updates

### Error Handling
- Gracefully handles missing Steam client
- Shows user-friendly messages when Steam is unavailable
- Displays message when inventory is empty
- Validates result codes from Steam API

### UI Components
- Loading indicator during data fetch
- Grid layout with 4 columns for item cards
- Scroll container for large inventories
- Refresh button to reload inventory
- Back button to return to Economy menu

## Usage

1. Navigate to Economy menu from the main game
2. Click "Steam Inventory" button
3. The scene will automatically load your Steam inventory items
4. Click "Refresh Steam Inventory" to reload items
5. Click "Back to Economy" to return

## Requirements

- GodotSteam plugin must be installed
- Steam client must be running
- User must be logged into Steam
- Game must have Steam inventory items configured in Steamworks

## Technical Details

### Steam API Calls
```gdscript
Steam.loadItemDefinitions()  // Loads item metadata
Steam.getAllItems()           // Gets user inventory
Steam.getResultItems(handle)  // Retrieves items from result handle
```

### Item Data Structure
**Item Data:**
- `item_id`: Steam item instance ID
- `definition`: Item definition ID
- `quantity`: Stack quantity

**Item Definition:**
- `itemdefid`: Definition ID
- `name`: Item name
- `description`: Item description
- `icon_url`: URL to item icon image

### Signal Flow
1. Scene loads → Check Steam availability
2. Call `loadItemDefinitions()` → `inventory_definition_update` signal
3. Call `getAllItems()` → `inventory_result_ready` signal
4. Display items in grid using SteamItemCard widgets

## Compatibility
- **Godot Version:** 4.5+
- **GodotSteam:** Compatible with current GodotSteam API
- **Project:** Integrates seamlessly with existing godot-playfab project structure

## Notes
- Image loading is asynchronous using HTTPRequest
- Supports both PNG and JPG formats for item icons
- Gracefully hides icon if URL is missing or fails to load
- No compilation errors in Godot 4.5

