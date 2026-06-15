# ``NetworkService``

A lightweight and modern networking service for consuming the Disney API.

## Overview

`NetworkService` provides an abstraction layer over `URLSession` to perform HTTP requests in a simple and safe way. The module uses `async/await` to handle asynchronous operations and is specifically designed to consume the Disney API.

### Key Features

- **Modern async/await API**: Leverages Swift's concurrency capabilities for cleaner and more readable code.
- **Typed endpoints**: The `Endpoint` enum encapsulates all the configuration needed for each request.
- **Automatic decoding**: The service automatically decodes JSON responses to the specified type.
- **Error handling**: `NetworkError` provides specific errors for each type of network failure.

### Available Endpoints

| Endpoint | Description |
|----------|-------------|
| `fetchList(page:)` | Fetches a paginated list of Disney characters |
| `fetchDetail(id:)` | Fetches the detail of a specific character |

### Basic Usage

```swift
import NetworkService

// Create a service instance
let networkService = NetworkServiceFactory.makeNetworkService()

// Fetch character list
let charactersList: CharactersList = try await networkService.execute(.fetchList(page: 1))

// Fetch character detail
let character: CharacterDetail = try await networkService.execute(.fetchDetail(id: "123"))
```

### Endpoint Configuration

Each endpoint defines:
- **URL**: Built from the Disney API base URL
- **HTTP Method**: GET, POST, PUT, or DELETE
- **Headers**: Includes `Content-Type: application/json` by default
- **Cache Policy**: URLSession cache policy

## Topics

### Service Creation

- ``NetworkServiceFactory``

### Main Protocol

- ``NetworkServiceInterface``

### Request Configuration

- ``Endpoint``
- ``HTTPMethod``

### Errors

- ``NetworkError``
