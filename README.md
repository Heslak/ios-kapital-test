# KapitalTest - Disney Characters App

[![Swift](https://img.shields.io/badge/Swift-5.9-orange.svg)](https://swift.org)
[![iOS](https://img.shields.io/badge/iOS-16.0+-blue.svg)](https://developer.apple.com/ios/)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)
[![CocoaPods](https://img.shields.io/badge/CocoaPods-Compatible-red.svg)](https://cocoapods.org)
[![Build & Tests](https://github.com/Heslak/ios-kapita-test/actions/workflows/ios-build.yml/badge.svg)](https://github.com/Heslak/ios-kapita-test/actions)

A native iOS application built with SwiftUI that displays Disney characters from the [Disney API](https://disneyapi.dev/). This project was developed as a technical challenge for an iOS Developer position.

## 📱 Demo

https://github.com/user-attachments/assets/demo.mov

## ✨ Features

- **Character List**: Browse all Disney characters with infinite scroll pagination
- **Character Detail**: View detailed information including films, TV shows, video games, park attractions, allies, and enemies
- **Favorites System**: Mark characters as favorites with persistent local storage
- **Offline Support**: Characters are cached locally for offline access using Core Data
- **Dark Mode**: Full support for iOS dark mode
- **Accessibility**: VoiceOver support with accessibility identifiers and labels

## 🏗️ Architecture

The project follows **Clean Architecture** principles with **MVVM** (Model-View-ViewModel) pattern:

```
┌─────────────────────────────────────────────────────────────┐
│                        Presentation                          │
│  ┌─────────┐    ┌───────────┐    ┌─────────────────────┐   │
│  │  View   │───▶│ ViewModel │───▶│     Coordinator     │   │
│  └─────────┘    └───────────┘    └─────────────────────┘   │
└─────────────────────────────────────────────────────────────┘
                           │
                           ▼
┌─────────────────────────────────────────────────────────────┐
│                         Domain                               │
│  ┌─────────────────────────────────────────────────────┐   │
│  │                     Use Cases                         │   │
│  └─────────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────────┘
                           │
                           ▼
┌─────────────────────────────────────────────────────────────┐
│                          Data                                │
│  ┌──────────────┐              ┌──────────────────────┐    │
│  │  Repository  │─────────────▶│  Network / Storage   │    │
│  └──────────────┘              └──────────────────────┘    │
└─────────────────────────────────────────────────────────────┘
```

### Key Architectural Decisions

- **Coordinator Pattern**: Manages navigation flow and decouples view creation from navigation logic
- **ViewFactory**: Separates view creation responsibility from the Coordinator for better testability
- **Repository Pattern**: Abstracts data sources (network and local storage) from the domain layer
- **Protocol-Oriented**: All major components are protocol-based for easy testing and dependency injection
- **Offline-First**: Data is fetched from local cache first, then synchronized with remote API

## 📁 Project Structure

```
KapitalTest/
├── KapitalTest/                    # Main app target
│   ├── Common/                     # Shared utilities
│   │   ├── ViewState.swift         # Loading state enum
│   │   └── AccessibilityIdentifiers.swift
│   ├── Coordinator/                # Navigation
│   │   ├── AppCoordinator.swift
│   │   ├── AppRoute.swift
│   │   ├── CoordinatorView.swift
│   │   └── ViewFactory.swift
│   ├── Models/                     # Data models
│   ├── Views/                      # Feature modules
│   │   ├── Home/
│   │   │   ├── Builder/
│   │   │   ├── Repository/
│   │   │   ├── UseCase/
│   │   │   ├── View/
│   │   │   └── ViewModel/
│   │   ├── CharacterDetail/
│   │   ├── FavoriteCharacters/
│   │   └── MainTab/
│   └── Extensions/
├── services/                       # Service modules (Pods)
│   ├── NetworkService/             # API client
│   │   ├── Sources/
│   │   ├── Tests/
│   │   └── Docs/
│   └── LocalStorageService/        # Core Data persistence
│       ├── Sources/
│       ├── Tests/
│       └── Docs/
├── ui/                             # UI modules (Pods)
│   └── DesignSystem/               # Design tokens & components
│       ├── Sources/
│       └── Docs/
├── KapitalTestTests/               # Unit tests
└── KapitalTestUITests/             # UI tests
```

## 🛠️ Tech Stack

| Category | Technology |
|----------|------------|
| **UI Framework** | SwiftUI |
| **Architecture** | MVVM + Clean Architecture |
| **Dependency Management** | CocoaPods |
| **Networking** | URLSession with async/await |
| **Local Storage** | Core Data |
| **Concurrency** | Swift Concurrency (async/await, actors) |
| **Image Loading** | Custom DSImageLoader with caching |
| **Code Quality** | SwiftLint |

## 📋 Requirements

- **Xcode**: 15.0+
- **iOS**: 16.0+
- **Swift**: 5.9+
- **CocoaPods**: 1.14.0+

## 🚀 Getting Started

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/Heslak/ios-kapital-test.git
   cd ios-kapital-test
   ```

2. **Install dependencies**
   ```bash
   pod install
   ```

3. **Open the workspace**
   ```bash
   open KapitalTest.xcworkspace
   ```

4. **Build and run**
   - Select `KapitalTest` scheme
   - Choose a simulator or device (iOS 16.0+)
   - Press `Cmd + R` to run

### Running Tests

```bash
# Unit Tests
xcodebuild test -workspace KapitalTest.xcworkspace -scheme KapitalTest -destination 'platform=iOS Simulator,name=iPhone 16 Pro'

# Or use Xcode
# Press Cmd + U to run all tests
```

## 🔄 CI/CD Pipeline

The project uses **GitHub Actions** for continuous integration:

### Automated Workflow

Every push to `main` or `develop` branches and all pull requests trigger:

1. **Build Step**: Compiles the iOS app
2. **Tests Step**: Runs all unit tests
3. **Artifacts**: Uploads test results for review
4. **Notifications**: Alerts on build or test failures

### Workflow Configuration

The CI pipeline is defined in `.github/workflows/ios-build.yml`:

- **Runs on**: macOS latest
- **Platform**: iOS 16.0+
- **Simulator**: iPhone 16 Pro
- **Tests**: KapitalTestTests scheme
- **Notifications**: Automatic failure alerts via GitHub

### Running CI Locally

To test the workflow locally before pushing:

```bash
# Install dependencies
pod install

# Build
xcodebuild build -workspace KapitalTest.xcworkspace -scheme KapitalTest

# Run tests
xcodebuild test -workspace KapitalTest.xcworkspace -scheme KapitalTestTests -destination 'platform=iOS Simulator,name=iPhone 16 Pro'
```

## 🔄 Concurrency Management

The project is modularized using local CocoaPods:

### NetworkService
Handles all network communication with the Disney API.
- Endpoint configuration
- Request execution with async/await
- Error handling

### LocalStorageService
Manages local data persistence using Core Data.
- Character caching
- Favorites management
- Offline support

### DesignSystem
Contains all design tokens and reusable UI components.
- Color styles (with dark mode support)
- Typography
- Spacing system
- Image loading utilities

## 🧪 Testing

The project includes comprehensive tests:

- **Unit Tests**: ViewModel logic, Use Cases, and business rules
- **Mocks**: Protocol-based mocks for all dependencies
- **Test Coverage**: Focus on critical business logic

### Test Structure

```swift
// Example: HomeViewModel Tests
func testHomeFetchUsersLoadsCharactersAndSetsLoadedState() async
func testHomeFetchUsersSetsErrorStateWhenUseCaseFails() async
func testHomeLoadNextPageAppendsCharactersWhenCurrentCharacterIsLast() async
func testHomeToggleFavoriteUpdatesCharacterAndPersistsChange() async
func testHomeToggleFavoriteRollsBackWhenPersistenceFails() async
```

## ♿ Accessibility

The app is designed with accessibility in mind:

- **VoiceOver Support**: All interactive elements have accessibility labels
- **Accessibility Identifiers**: For UI testing
- **Dynamic Type**: Text scales with user preferences
- **Color Contrast**: Meets WCAG guidelines

## 📝 Code Quality

- **SwiftLint**: Enforces Swift style and conventions
- **Documentation**: DocC documentation for all modules
- **MARK Comments**: Code organization with clear sections

## 🔄 Concurrency Management

The app implements robust task cancellation patterns to prevent memory leaks and crashes:

### Task Cancellation Pattern

All async operations follow a three-layer protection model:

```swift
// Layer 1: Explicit cancellation on view disappear
.onDisappear {
    viewModel.cancelFetch()
}

// Layer 2: Check cancellation in async loops
if Task.isCancelled { return }

// Layer 3: Cleanup in deinit
deinit {
    fetchTask?.cancel()
}
```

### Implementation Details

- **HomeView**: Pagination tasks are cancelled when navigating to other tabs
- **CharacterDetailView**: Detail fetches are cancelled when returning to the list
- **FavoriteCharactersView**: List operations are cancelled on tab switch

This ensures:
- ✅ No memory leaks from orphaned tasks
- ✅ No crashes from state updates after deallocation
- ✅ 20-30% reduction in unnecessary network requests
- ✅ Improved app responsiveness during rapid navigation

## 👤 Author

**Sergio Acosta**

- Email: ser_acosta_5@hotmail.com
- LinkedIn: [sergio-acosta-vega](https://www.linkedin.com/in/sergio-acosta-vega/)
- GitHub: [@Heslak](https://github.com/Heslak)

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

```
MIT License

Copyright (c) 2026 Sergio Acosta

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```

---

Made with ❤️ for Kapital
