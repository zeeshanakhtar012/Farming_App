# Smart Farming App - Final Year Project

## 📱 Project Overview

A comprehensive Flutter mobile application designed to help farmers make smart, data-driven agricultural decisions using real-time data and AI-assisted logic. The app provides crop recommendations, weather forecasts, disease detection, market price tracking, farming calendar, and expense/profit tracking.

## 🧱 Tech Stack

- **Frontend**: Flutter (Latest Stable)
- **State Management**: GetX
- **Backend**: Firebase
  - Firebase Authentication (Email/Password)
  - Cloud Firestore
  - Firebase Storage
- **APIs**: OpenWeather API (or similar)
- **AI**: Rule-based crop disease detection

## ✨ Features

### 1. Authentication Module
- User Registration
- User Login
- Forgot Password
- Persistent Login State

### 2. Crop Recommendation System
- Location-based recommendations
- Soil type analysis
- Seasonal crop suggestions
- Expected yield estimates
- Fertilizer recommendations

### 3. Weather Forecast & Alerts
- Real-time weather data
- Temperature, humidity, rain probability
- Weather warnings and alerts

### 4. Crop Disease Detection
- Image upload/capture
- Disease identification (rule-based)
- Severity assessment
- Treatment recommendations

### 5. Market Price Tracking
- Crop price display
- Filter by crop type
- Location-based price comparison

### 6. Smart Farming Calendar
- Sowing reminders
- Fertilizing schedules
- Irrigation alerts
- Harvesting notifications
- Local notifications support

### 7. Expense & Profit Tracker
- Seed cost tracking
- Fertilizer cost tracking
- Labor cost tracking
- Total cost calculation
- Estimated profit calculation

### 8. Multi-language Support
- English
- Urdu

## 📁 Project Structure

```
lib/
├── main.dart
├── app/
│   ├── bindings/
│   ├── routes/
│   └── theme/
├── core/
│   ├── constants/
│   ├── utils/
│   └── services/
├── data/
│   ├── models/
│   ├── repositories/
│   └── providers/
├── modules/
│   ├── auth/
│   │   ├── controllers/
│   │   ├── views/
│   │   └── models/
│   ├── crop_recommendation/
│   ├── weather/
│   ├── disease_detection/
│   ├── market_prices/
│   ├── calendar/
│   └── expense_tracker/
└── widgets/
    └── common/
```

## 🚀 Setup Instructions

### Prerequisites
- Flutter SDK (latest stable version)
- Android Studio / VS Code
- Firebase account
- OpenWeather API key (optional)

### Firebase Setup

1. **Create Firebase Project**
   - Go to [Firebase Console](https://console.firebase.google.com/)
   - Create a new project
   - Enable Authentication (Email/Password)
   - Create Firestore database
   - Enable Storage

2. **Add Android Configuration**
   - Download `google-services.json`
   - Place it in `android/app/` directory

3. **Firestore Data Structure**
   See `docs/firestore_structure.md` for detailed schema

### Installation Steps

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd FYP
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Configure Firebase**
   - Add `google-services.json` to `android/app/`
   - Update Firebase configuration in `lib/core/services/firebase_service.dart`

4. **Configure API Keys**
   - Create `.env` file in root directory
   - Add your OpenWeather API key:
     ```
     WEATHER_API_KEY=your_api_key_here
     ```

5. **Run the app**
   ```bash
   flutter run
   ```

## 📊 Firestore Data Structure

### Collections

#### users
```json
{
  "userId": "string",
  "email": "string",
  "name": "string",
  "location": {
    "latitude": "number",
    "longitude": "number",
    "address": "string"
  },
  "soilType": "string",
  "createdAt": "timestamp"
}
```

#### crop_recommendations
```json
{
  "cropId": "string",
  "cropName": "string",
  "soilType": ["string"],
  "season": ["string"],
  "expectedYield": "string",
  "fertilizer": ["string"],
  "waterRequirement": "string",
  "growthPeriod": "number"
}
```

#### market_prices
```json
{
  "cropId": "string",
  "cropName": "string",
  "price": "number",
  "unit": "string",
  "location": "string",
  "date": "timestamp"
}
```

#### expenses
```json
{
  "expenseId": "string",
  "userId": "string",
  "type": "string", // seeds, fertilizer, labor, other
  "amount": "number",
  "description": "string",
  "date": "timestamp"
}
```

#### calendar_events
```json
{
  "eventId": "string",
  "userId": "string",
  "title": "string",
  "type": "string", // sowing, fertilizing, irrigation, harvesting
  "date": "timestamp",
  "cropName": "string",
  "reminderEnabled": "boolean"
}
```

## 🧪 Testing

Run tests using:
```bash
flutter test
```

## 📝 Code Quality

- Clean Architecture principles
- MVC pattern implementation
- Well-commented code
- Error handling throughout
- Loading states management

## 🌍 Localization

The app supports multiple languages:
- English (en)
- Urdu (ur)

Translation files are located in `assets/locales/`

## 📱 Screenshots

(Add screenshots of your app here)

## 👨‍💻 Development

### Adding New Features
1. Create model in `lib/data/models/`
2. Create controller in `lib/modules/[feature]/controllers/`
3. Create view in `lib/modules/[feature]/views/`
4. Add route in `lib/app/routes/app_routes.dart`
5. Update bindings if needed

### State Management
- All state management is handled using GetX
- Controllers extend `GetxController`
- Use `Get.find()` to access controllers

## 🐛 Known Issues

(List any known issues here)

## 🔮 Future Enhancements

- Machine Learning integration for disease detection
- Real-time market price API integration
- Advanced analytics dashboard
- Community features
- Offline mode support

## 📄 License

This project is developed as a Final Year Project.

## 👥 Authors

Zeeshan Akhtar

## 🙏 Acknowledgments

- Flutter Team
- Firebase Team
- GetX Community
- OpenWeather API

---

**Note**: This is an academic project developed for Final Year Project submission.
