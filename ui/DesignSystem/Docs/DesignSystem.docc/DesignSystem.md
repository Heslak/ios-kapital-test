# ``DesignSystem``

A modular design system that provides UI components, color styles, typography, and utilities to maintain visual consistency across the application.

## Overview

`DesignSystem` is a module that centralizes all design tokens and reusable components for the application. It is designed to facilitate maintaining a coherent and scalable user interface.

### Key Features

- **Semantic colors**: Color system with light and dark mode support through `DSColorStyle`.
- **Consistent typography**: Predefined font styles with `DSFontStyle` for all use cases.
- **Spacing system**: Standardized spacing tokens with `DSDimens` based on a 4-point scale.
- **Optimized image loading**: `DSImageLoader` with in-memory cache and automatic downsampling.

## Colors

The color system is organized by semantic categories:

```swift
import DesignSystem

// Ink colors (text)
let primaryText = DSColorStyle.ink(.primary)

// Background colors
let backgroundColor = DSColorStyle.background(.main)

// Placeholder colors
let placeholderColor = DSColorStyle.placeholder(.default)

// Shadows
let shadowColor = DSColorStyle.shadow(.default)
```

## Typography

Font styles follow a clear hierarchy:

```swift
import DesignSystem

// Headings
let heading = DSFontStyle.h1Bold
let subheading = DSFontStyle.h2Regular

// Titles
let title = DSFontStyle.titleMedium

// Body text
let body = DSFontStyle.bodyRegular

// Captions and labels
let caption = DSFontStyle.caption1Regular
let label = DSFontStyle.labelMedium
```

## Spacing

The spacing system uses a consistent scale:

```swift
import DesignSystem

// Available spacings (in points)
DSDimens.spacing_0   // 0
DSDimens.spacing_1   // 2
DSDimens.spacing_2   // 4
DSDimens.spacing_3   // 8
DSDimens.spacing_4   // 12
DSDimens.spacing_5   // 16
// ... up to spacing_19
```

## Image Loading

`DSImageLoader` provides efficient image loading with caching:

```swift
import DesignSystem

let imageLoader = DSImageLoader.shared

let image = try await imageLoader.loadImage(
    from: imageURL,
    targetSize: CGSize(width: 100, height: 100),
    scale: UIScreen.main.scale
)
```

## Topics

### Colors

- ``DSColorStyle``
- ``InkStyle``
- ``BackgroundStyle``
- ``PlaceholderStyle``
- ``ShadowStyle``

### Typography

- ``DSFontStyle``

### Spacing

- ``DSDimens``

### Image Loading

- ``DSImageLoader``
- ``DSImageLoading``
- ``DSImageLoaderError``
