# ``LocalStorageService``

A Core Data-backed local storage service for persisting and retrieving Disney character data.

## Overview

`LocalStorageService` provides an abstraction layer over Core Data to manage persistent storage of character lists and their details. The module is designed with protocols that allow adaptation to different data models without coupling to specific implementations.

### Key Features

- **Paginated list persistence**: Stores character lists with full pagination support.
- **Favorites management**: Allows marking characters as favorites and retrieving them easily.
- **Protocol-based abstraction**: The `LocalStorableCharactersList`, `LocalStorableListInfo`, and `LocalStorableCharacterInfo` protocols allow using any conforming model.
- **Typed error handling**: `LocalStorageError` provides specific errors for each situation.

### Basic Usage

```swift
import LocalStorageService

// Create a service instance
let storageService = LocalStorageServiceFactory.makeLocalStorageService()

// Save a character list
try storageService.saveCharactersList(charactersList, page: 1)

// Retrieve a saved list
let cachedList = try storageService.getCharactersList(MyCharactersList.self, page: 1)

// Mark a character as favorite
try storageService.setCharacterFavorite(id: 123, isFavorite: true)

// Get all favorites
let favorites = try storageService.getFavoriteCharacters(MyCharacter.self)
```

## Topics

### Service Creation

- ``LocalStorageServiceFactory``

### Main Protocol

- ``LocalStorageServiceInterface``

### Data Protocols

- ``LocalStorableCharactersList``
- ``LocalStorableListInfo``
- ``LocalStorableCharacterInfo``

### Errors

- ``LocalStorageError``
