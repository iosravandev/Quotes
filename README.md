# Quotes iOS App

A modern iOS application for managing and displaying quotes, built with SwiftUI and following Clean Architecture principles.

## Features

- View quotes from local or remote sources
- Save favorite quotes
- Edit/redact saved quotes
- Add quotes to lockscreen via iOS Widgets
- Multi-language support
- Theme customization (light/dark/custom)
- In-app purchase for premium features

## Architecture

The app follows Clean Architecture principles with three main layers:

### Domain Layer
- Contains business logic and entities
- Defines use cases and interfaces
- Independent of any framework

### Data Layer
- Implements repositories
- Handles data sources (local/remote)
- Contains data models and persistence logic

### Presentation Layer
- SwiftUI views and view models
- Handles UI state and user interactions
- Implements navigation and routing

## Technical Stack

- SwiftUI for UI
- Combine/async-await for data flow
- Core Data for persistence
- WidgetKit for lockscreen widgets
- StoreKit for in-app purchases
- Swift Package Manager for dependencies

## Project Structure

```
Quotes/
├── Domain/
│   ├── Entities/
│   ├── UseCases/
│   └── Interfaces/
├── Data/
│   ├── Repositories/
│   ├── DataSources/
│   └── Models/
├── Presentation/
│   ├── Views/
│   ├── ViewModels/
│   └── Components/
├── Resources/
│   ├── Localization/
│   └── Assets/
└── App/
    ├── AppDelegate/
    └── SceneDelegate/
```

## Getting Started

1. Clone the repository
2. Open `Quotes.xcodeproj`
3. Build and run the project

## Requirements

- iOS 15.0+
- Xcode 13.0+
- Swift 5.5+

## License

This project is licensed under the MIT License - see the LICENSE file for details. 