# Firestore Data Structure

This document describes the Firestore database structure for the Smart Farming App.

## Collections

### 1. users

Stores user profile information.

**Document Structure:**
```json
{
  "userId": "string (document ID)",
  "email": "string",
  "name": "string (optional)",
  "phoneNumber": "string (optional)",
  "location": {
    "latitude": "number",
    "longitude": "number",
    "address": "string (optional)"
  },
  "soilType": "string (optional)",
  "createdAt": "timestamp",
  "updatedAt": "timestamp"
}
```

**Example:**
```json
{
  "email": "farmer@example.com",
  "name": "John Doe",
  "location": {
    "latitude": 31.5204,
    "longitude": 74.3587,
    "address": "Lahore, Pakistan"
  },
  "soilType": "Loamy",
  "createdAt": "2024-01-15T10:30:00Z",
  "updatedAt": "2024-01-15T10:30:00Z"
}
```

---

### 2. crop_recommendations

Stores crop recommendation data based on soil type and season.

**Document Structure:**
```json
{
  "cropId": "string (document ID)",
  "cropName": "string",
  "soilType": ["string"], // Array of compatible soil types
  "season": ["string"], // Array of suitable seasons
  "expectedYield": "string",
  "fertilizer": ["string"], // Array of recommended fertilizers
  "waterRequirement": "string",
  "growthPeriod": "number", // in days
  "description": "string (optional)",
  "imageUrl": "string (optional)"
}
```

**Example:**
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

---

### 3. market_prices

Stores current market prices for different crops.

**Document Structure:**
```json
{
  "priceId": "string (document ID)",
  "cropName": "string",
  "price": "number",
  "unit": "string", // e.g., "per kg", "per quintal", "per maund"
  "location": "string",
  "date": "timestamp",
  "cropType": "string (optional)"
}
```

**Example:**
```json
{
  "cropName": "Wheat",
  "price": 3500,
  "unit": "per quintal",
  "location": "Lahore",
  "date": "2024-01-15T10:30:00Z",
  "cropType": "Cereal"
}
```

---

### 4. expenses

Stores farming expense records.

**Document Structure:**
```json
{
  "expenseId": "string (document ID)",
  "userId": "string",
  "type": "string", // "seeds", "fertilizer", "labor", "other"
  "amount": "number",
  "description": "string",
  "date": "timestamp"
}
```

**Example:**
```json
{
  "userId": "user123",
  "type": "seeds",
  "amount": 5000,
  "description": "Wheat seeds for 1 acre",
  "date": "2024-01-15T10:30:00Z"
}
```

---

### 5. calendar_events

Stores farming calendar events and reminders.

**Document Structure:**
```json
{
  "eventId": "string (document ID)",
  "userId": "string",
  "title": "string",
  "type": "string", // "sowing", "fertilizing", "irrigation", "harvesting"
  "date": "timestamp",
  "cropName": "string (optional)",
  "reminderEnabled": "boolean",
  "description": "string (optional)",
  "reminderId": "number (optional)" // For notification management
}
```

**Example:**
```json
{
  "userId": "user123",
  "title": "Sow Wheat Seeds",
  "type": "sowing",
  "date": "2024-02-01T08:00:00Z",
  "cropName": "Wheat",
  "reminderEnabled": true,
  "description": "Sow wheat seeds in field A",
  "reminderId": 1706784000000
}
```

---

### 6. disease_detections

Stores crop disease detection results.

**Document Structure:**
```json
{
  "detectionId": "string (document ID)",
  "userId": "string",
  "diseaseName": "string",
  "severity": "string", // "Low", "Medium", "High"
  "imageUrl": "string",
  "confidence": "number", // 0.0 to 1.0
  "detectedAt": "timestamp"
}
```

**Example:**
```json
{
  "userId": "user123",
  "diseaseName": "Leaf Rust",
  "severity": "Medium",
  "imageUrl": "https://firebasestorage.../disease_image.jpg",
  "confidence": 0.75,
  "detectedAt": "2024-01-15T10:30:00Z"
}
```

---

## Storage Structure

### disease_images/

Stores uploaded disease detection images.

**Path Format:**
```
disease_images/disease_{userId}_{timestamp}.jpg
```

**Example:**
```
disease_images/disease_user123_1706784000000.jpg
```

---

## Security Rules (Recommended)

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Users collection
    match /users/{userId} {
      allow read: if request.auth != null;
      allow write: if request.auth != null && request.auth.uid == userId;
    }
    
    // Crop recommendations (read-only for authenticated users)
    match /crop_recommendations/{docId} {
      allow read: if request.auth != null;
      allow write: if false; // Only admins can write
    }
    
    // Market prices (read-only for authenticated users)
    match /market_prices/{docId} {
      allow read: if request.auth != null;
      allow write: if false; // Only admins can write
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

---

## Sample Data Setup

### 1. Add Crop Recommendations

You can add sample crop recommendations through Firebase Console or using a script:

```javascript
// Example: Add Wheat recommendation
db.collection('crop_recommendations').add({
  cropName: 'Wheat',
  soilType: ['Loamy', 'Clay'],
  season: ['Winter', 'Spring'],
  expectedYield: '40-50 quintals/hectare',
  fertilizer: ['Urea', 'DAP', 'Potash'],
  waterRequirement: 'Moderate',
  growthPeriod: 120,
  description: 'Wheat is a staple crop suitable for winter season.'
});
```

### 2. Add Market Prices

```javascript
// Example: Add Wheat price
db.collection('market_prices').add({
  cropName: 'Wheat',
  price: 3500,
  unit: 'per quintal',
  location: 'Lahore',
  date: firebase.firestore.Timestamp.now(),
  cropType: 'Cereal'
});
```

---

## Indexes Required

For efficient queries, create the following composite indexes:

1. **calendar_events**
   - Fields: `userId` (Ascending), `date` (Ascending)

2. **expenses**
   - Fields: `userId` (Ascending), `date` (Descending)

3. **market_prices**
   - Fields: `location` (Ascending), `date` (Descending)

---

## Notes

- All timestamps should use Firestore Timestamp type
- User IDs should match Firebase Auth UIDs
- Image URLs should be Firebase Storage download URLs
- Prices should be stored as numbers (not strings)
- Arrays should be used for multiple values (e.g., soil types, seasons)
