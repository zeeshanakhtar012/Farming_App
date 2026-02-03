# Firebase Setup Instructions

This guide will help you set up Firebase for the Smart Farming App.

## Prerequisites

- A Firebase account (create one at [firebase.google.com](https://firebase.google.com))
- Flutter SDK installed
- Android Studio or VS Code with Flutter extensions

## Step 1: Create Firebase Project

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Click "Add project" or "Create a project"
3. Enter project name: `Smart Farming App` (or your preferred name)
4. Disable Google Analytics (optional, for simplicity)
5. Click "Create project"
6. Wait for project creation to complete

## Step 2: Enable Authentication

1. In Firebase Console, go to **Authentication**
2. Click "Get started"
3. Go to **Sign-in method** tab
4. Enable **Email/Password** provider:
   - Click on "Email/Password"
   - Toggle "Enable" to ON
   - Click "Save"

## Step 3: Create Firestore Database

1. In Firebase Console, go to **Firestore Database**
2. Click "Create database"
3. Choose **Start in test mode** (for development)
   - Note: You'll need to set up security rules later for production
4. Select a location (choose closest to your users)
5. Click "Enable"

## Step 4: Set Up Firestore Security Rules

1. In Firestore Database, go to **Rules** tab
2. Replace the default rules with:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Users collection
    match /users/{userId} {
      allow read: if request.auth != null;
      allow write: if request.auth != null && request.auth.uid == userId;
    }
    
    // Crop recommendations (read-only)
    match /crop_recommendations/{docId} {
      allow read: if request.auth != null;
      allow write: if false;
    }
    
    // Market prices (read-only)
    match /market_prices/{docId} {
      allow read: if request.auth != null;
      allow write: if false;
    }
    
    // Expenses (user-specific)
    match /expenses/{expenseId} {
      allow read, write: if request.auth != null && 
        resource.data.userId == request.auth.uid;
    }
    
    // Calendar events (user-specific)
    match /calendar_events/{eventId} {
      allow read, write: if request.auth != null && 
        resource.data.userId == request.auth.uid;
    }
    
    // Disease detections (user-specific)
    match /disease_detections/{detectionId} {
      allow read, write: if request.auth != null && 
        resource.data.userId == request.auth.uid;
    }
  }
}
```

3. Click "Publish"

## Step 5: Enable Firebase Storage

1. In Firebase Console, go to **Storage**
2. Click "Get started"
3. Choose **Start in test mode** (for development)
4. Select a location (same as Firestore)
5. Click "Done"

## Step 6: Set Up Storage Security Rules

1. In Storage, go to **Rules** tab
2. Replace the default rules with:

```javascript
rules_version = '2';
service firebase.storage {
  match /b/{bucket}/o {
    match /disease_images/{imageId} {
      allow read: if request.auth != null;
      allow write: if request.auth != null && request.auth.size < 5 * 1024 * 1024; // 5MB limit
    }
  }
}
```

3. Click "Publish"

## Step 7: Add Android App to Firebase

1. In Firebase Console, click the Android icon (or "Add app")
2. Enter Android package name: `com.SoftMat.smart_farming_app` (must match `applicationId` in `android/app/build.gradle`)
3. Enter app nickname (optional): `Smart Farming Android`
4. Click "Register app"
5. Download `google-services.json`
6. Place the file in `android/app/` directory of your Flutter project
7. **Add SHA-1 (required for sign-up/sign-in on Android):**
   - In Firebase Console go to **Project settings** (gear icon) → **Your apps**
   - Select your Android app → click **Add fingerprint**
   - Get your debug SHA-1: run in project root:  
     `cd android && ./gradlew signingReport`  
     (or on Windows: `gradlew.bat signingReport`)  
     Copy the SHA-1 from the **Variant: debug** section
   - Paste it in Firebase and click **Save**
   - For release builds, add your release keystore’s SHA-1 the same way

## Step 8: Configure Android Project

1. Open `android/build.gradle` (project level)
2. Add to `dependencies`:
```gradle
dependencies {
    classpath 'com.google.gms:google-services:4.4.0'
}
```

3. Open `android/app/build.gradle`
4. Add at the top:
```gradle
apply plugin: 'com.google.gms.google-services'
```

5. Ensure `minSdkVersion` is at least 21:
```gradle
android {
    defaultConfig {
        minSdkVersion 21
    }
}
```

## Step 9: Install Flutter Dependencies

Run in your project root:
```bash
flutter pub get
```

## Step 10: Initialize Firebase in Flutter

The app already has Firebase initialization code in `lib/main.dart`. Make sure you have:

1. `firebase_core` package installed (already in `pubspec.yaml`)
2. Firebase initialized before running the app

## Step 11: Add Sample Data (Optional)

You can add sample data to Firestore for testing:

### Crop Recommendations

Go to Firestore Console → `crop_recommendations` → Add document:

```json
{
  "cropName": "Wheat",
  "soilType": ["Loamy", "Clay"],
  "season": ["Winter", "Spring"],
  "expectedYield": "40-50 quintals/hectare",
  "fertilizer": ["Urea", "DAP", "Potash"],
  "waterRequirement": "Moderate",
  "growthPeriod": 120,
  "description": "Wheat is a staple crop suitable for winter season."
}
```

### Market Prices

Go to Firestore Console → `market_prices` → Add document:

```json
{
  "cropName": "Wheat",
  "price": 3500,
  "unit": "per quintal",
  "location": "Lahore",
  "date": [Current Timestamp],
  "cropType": "Cereal"
}
```

## Step 12: Create Firestore Indexes

For better query performance, create these indexes:

1. Go to Firestore → Indexes
2. Click "Create Index"
3. Create indexes for:
   - Collection: `calendar_events`
     - Fields: `userId` (Ascending), `date` (Ascending)
   - Collection: `expenses`
     - Fields: `userId` (Ascending), `date` (Descending)
   - Collection: `market_prices`
     - Fields: `location` (Ascending), `date` (Descending)

## Step 13: Test Firebase Connection

1. Run the app: `flutter run`
2. Try to register a new user
3. Check Firebase Console → Authentication to see if user was created
4. Check Firestore → `users` collection to see if user document was created

## Troubleshooting

### Issue: reCAPTCHA / "A network error (such as timeout, interrupted connection or unreachable host)" on sign-up or sign-in (Android)
This usually means Firebase cannot complete verification. Fix in this order:

1. **Add your app’s SHA-1 in Firebase (most common fix)**  
   - Firebase Console → **Project settings** → **Your apps** → your Android app → **Add fingerprint**  
   - Get SHA-1: in terminal run `cd android && ./gradlew signingReport`, copy SHA-1 from the **debug** variant  
   - Paste in Firebase and save. Wait a few minutes, then try again.

2. **Use a device or emulator with Google Play**  
   - Use a physical device with internet, or an Android emulator image that includes **Google Play** (not “Google APIs” only).  
   - ReCAPTCHA/Play Integrity often fail on emulators without Play Services.

3. **Check network**  
   - Ensure the device/emulator has internet and can reach Google (no firewall blocking).

4. **“No AppCheckProvider installed”**  
   - This is a warning. For development you can ignore it. For production, configure [App Check](https://firebase.google.com/docs/app-check) in Firebase Console.

### Issue: "MissingPluginException"
- Solution: Run `flutter clean` and `flutter pub get`, then rebuild

### Issue: "google-services.json not found"
- Solution: Make sure `google-services.json` is in `android/app/` directory

### Issue: "FirebaseApp not initialized"
- Solution: Check that Firebase.initializeApp() is called in `main.dart` before runApp()

### Issue: Permission denied errors
- Solution: Check Firestore and Storage security rules

## Production Considerations

Before deploying to production:

1. **Update Security Rules**: Replace test mode rules with proper authentication-based rules
2. **Enable App Check**: Add App Check for additional security
3. **Set up Cloud Functions**: For admin operations (adding crop recommendations, prices)
4. **Monitor Usage**: Set up Firebase monitoring and alerts
5. **Backup Strategy**: Set up regular Firestore backups

## Additional Resources

- [Firebase Flutter Documentation](https://firebase.flutter.dev/)
- [Firestore Documentation](https://firebase.google.com/docs/firestore)
- [Firebase Storage Documentation](https://firebase.google.com/docs/storage)
- [Firebase Authentication Documentation](https://firebase.google.com/docs/auth)

---

**Note**: Keep your `google-services.json` file secure and never commit it to public repositories. It's already included in `.gitignore`.
