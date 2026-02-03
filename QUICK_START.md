# Quick Start Guide

Follow these steps to get the Smart Farming App up and running.

## Prerequisites

- Flutter SDK (latest stable version)
- Android Studio or VS Code
- Firebase account
- Android device or emulator

## Step 1: Clone/Download Project

```bash
cd FYP
```

## Step 2: Install Dependencies

```bash
flutter pub get
```

## Step 3: Firebase Setup

1. **Create Firebase Project**
   - Go to [Firebase Console](https://console.firebase.google.com/)
   - Create a new project

2. **Enable Services**
   - Enable **Authentication** (Email/Password)
   - Create **Firestore Database** (test mode)
   - Enable **Storage** (test mode)

3. **Add Android App**
   - Click "Add app" → Android
   - Package name: `com.example.smart_farming_app`
   - Download `google-services.json`
   - Place it in `android/app/` directory

4. **Configure Security Rules**
   - See `docs/firebase_setup.md` for detailed rules

## Step 4: Run the App

```bash
flutter run
```

## Step 5: Test Features

1. **Register a new account**
2. **Explore features:**
   - Crop Recommendation
   - Weather Forecast
   - Disease Detection
   - Market Prices
   - Farming Calendar
   - Expense Tracker

## Troubleshooting

### Firebase Not Initialized
- Make sure `google-services.json` is in `android/app/`
- Check Firebase setup in `docs/firebase_setup.md`

### Dependencies Error
```bash
flutter clean
flutter pub get
```

### Build Errors
```bash
cd android
./gradlew clean
cd ..
flutter run
```

## Next Steps

1. Add sample data to Firestore (see `docs/firestore_structure.md`)
2. Configure Weather API key (optional)
3. Customize app theme and colors
4. Add more crop recommendations
5. Test all features thoroughly

## Important Notes

- The app uses mock data when Firebase is not configured
- Weather API requires an API key (see `lib/core/services/weather_service.dart`)
- Disease detection uses rule-based logic (mock)
- All features work offline with cached/mock data

## Support

For detailed documentation:
- `README.md` - Project overview
- `docs/firebase_setup.md` - Firebase configuration
- `docs/firestore_structure.md` - Database schema
- `FOLDER_STRUCTURE.md` - Code organization

---

**Happy Coding! 🌱**
