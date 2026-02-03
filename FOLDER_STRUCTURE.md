# Project Folder Structure

This document explains the folder structure of the Smart Farming App Flutter project.

## Root Directory

```
FYP/
├── android/                 # Android platform-specific files
├── ios/                     # iOS platform-specific files (not implemented)
├── lib/                     # Main application source code
├── assets/                  # Images, icons, locales
├── docs/                    # Documentation files
├── pubspec.yaml            # Flutter dependencies and configuration
├── README.md               # Project README
├── .gitignore             # Git ignore rules
└── analysis_options.yaml   # Dart analyzer configuration
```

## lib/ Directory Structure

```
lib/
├── main.dart                          # Application entry point
│
├── app/                               # App-level configuration
│   ├── routes/
│   │   ├── app_routes.dart           # Route name constants
│   │   └── app_pages.dart            # Route definitions with bindings
│   ├── theme/
│   │   └── app_theme.dart            # Light and dark theme configuration
│   └── bindings/                     # Global bindings (if any)
│
├── core/                              # Core functionality and utilities
│   ├── constants/                    # App-wide constants
│   ├── services/                     # Core services
│   │   ├── firebase_service.dart     # Firebase operations (Auth, Firestore, Storage)
│   │   ├── weather_service.dart      # Weather API integration
│   │   └── notification_service.dart # Local notifications
│   └── utils/                         # Utility functions
│       ├── validators.dart           # Form validation functions
│       └── app_translations.dart     # Multi-language translations
│
├── data/                              # Data layer (if using repository pattern)
│   ├── models/                       # Data models
│   ├── repositories/                 # Data repositories
│   └── providers/                    # Data providers
│
├── modules/                           # Feature modules (MVC pattern)
│   ├── splash/
│   │   └── views/
│   │       └── splash_view.dart      # Splash screen
│   │
│   ├── auth/                         # Authentication module
│   │   ├── controllers/
│   │   │   └── auth_controller.dart  # Auth state management
│   │   ├── views/
│   │   │   ├── login_view.dart       # Login screen
│   │   │   ├── register_view.dart   # Registration screen
│   │   │   └── forgot_password_view.dart
│   │   ├── models/
│   │   │   └── user_model.dart      # User data model
│   │   └── bindings/
│   │       └── auth_binding.dart     # Dependency injection
│   │
│   ├── home/                         # Home/Dashboard module
│   │   ├── controllers/
│   │   │   └── home_controller.dart
│   │   ├── views/
│   │   │   └── home_view.dart       # Main dashboard
│   │   └── bindings/
│   │       └── home_binding.dart
│   │
│   ├── crop_recommendation/          # Crop Recommendation feature
│   │   ├── controllers/
│   │   │   └── crop_recommendation_controller.dart
│   │   ├── views/
│   │   │   └── crop_recommendation_view.dart
│   │   ├── models/
│   │   │   └── crop_model.dart
│   │   └── bindings/
│   │       └── crop_recommendation_binding.dart
│   │
│   ├── weather/                      # Weather Forecast feature
│   │   ├── controllers/
│   │   │   └── weather_controller.dart
│   │   ├── views/
│   │   │   └── weather_view.dart
│   │   ├── models/
│   │   │   └── weather_model.dart
│   │   └── bindings/
│   │       └── weather_binding.dart
│   │
│   ├── disease_detection/            # Disease Detection feature
│   │   ├── controllers/
│   │   │   └── disease_detection_controller.dart
│   │   ├── views/
│   │   │   └── disease_detection_view.dart
│   │   ├── models/
│   │   │   └── disease_model.dart
│   │   └── bindings/
│   │       └── disease_detection_binding.dart
│   │
│   ├── market_prices/                # Market Prices feature
│   │   ├── controllers/
│   │   │   └── market_prices_controller.dart
│   │   ├── views/
│   │   │   └── market_prices_view.dart
│   │   ├── models/
│   │   │   └── market_price_model.dart
│   │   └── bindings/
│   │       └── market_prices_binding.dart
│   │
│   ├── calendar/                     # Farming Calendar feature
│   │   ├── controllers/
│   │   │   └── calendar_controller.dart
│   │   ├── views/
│   │   │   └── calendar_view.dart
│   │   ├── models/
│   │   │   └── calendar_event_model.dart
│   │   └── bindings/
│   │       └── calendar_binding.dart
│   │
│   └── expense_tracker/              # Expense Tracker feature
│       ├── controllers/
│       │   └── expense_tracker_controller.dart
│       ├── views/
│       │   └── expense_tracker_view.dart
│       ├── models/
│       │   └── expense_model.dart
│       └── bindings/
│           └── expense_tracker_binding.dart
│
└── widgets/                          # Reusable widgets
    └── common/                       # Common widgets (if any)
```

## assets/ Directory Structure

```
assets/
├── images/              # App images and icons
├── icons/               # Custom icons
└── locales/            # Translation files (if using JSON)
    ├── en.json
    └── ur.json
```

## docs/ Directory Structure

```
docs/
├── firebase_setup.md           # Firebase setup instructions
└── firestore_structure.md      # Firestore database schema
```

## Architecture Pattern

The app follows **MVC (Model-View-Controller)** architecture with **GetX** for state management:

- **Models**: Data structures and business logic
- **Views**: UI components (Widgets)
- **Controllers**: State management and business logic coordination
- **Bindings**: Dependency injection for controllers
- **Services**: External service integrations (Firebase, APIs)

## Key Files Explained

### main.dart
- Application entry point
- Initializes Firebase, GetStorage, and services
- Sets up routing, theming, and localization

### app/routes/app_routes.dart
- Contains all route names as constants
- Type-safe navigation

### app/routes/app_pages.dart
- Defines all routes with their views and bindings
- GetX routing configuration

### app/theme/app_theme.dart
- Light and dark theme definitions
- Color schemes, typography, component themes

### core/services/firebase_service.dart
- Centralized Firebase operations
- Authentication, Firestore, Storage methods

### core/utils/app_translations.dart
- Multi-language support (English, Urdu)
- GetX translation system

## Module Structure

Each feature module follows this structure:

```
module_name/
├── controllers/        # Business logic and state
├── views/             # UI screens
├── models/            # Data models
└── bindings/          # Dependency injection
```

This structure ensures:
- **Separation of concerns**
- **Reusability**
- **Maintainability**
- **Testability**

## Naming Conventions

- **Files**: snake_case (e.g., `auth_controller.dart`)
- **Classes**: PascalCase (e.g., `AuthController`)
- **Variables**: camelCase (e.g., `isLoading`)
- **Constants**: lowerCamelCase or UPPER_SNAKE_CASE

## Dependencies Management

All dependencies are managed in `pubspec.yaml`:
- State Management: GetX
- Firebase: firebase_core, firebase_auth, cloud_firestore, firebase_storage
- HTTP: http, dio
- Image: image_picker, camera
- Notifications: flutter_local_notifications
- Location: geolocator, geocoding

---

**Note**: This structure is designed for scalability and maintainability. As the app grows, you can add more modules following the same pattern.
