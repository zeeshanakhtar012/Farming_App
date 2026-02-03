/// User Model
/// Represents user data structure
class UserModel {
  final String userId;
  final String email;
  final String? name;
  final String? phoneNumber;
  final LocationModel? location;
  final String? soilType;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  UserModel({
    required this.userId,
    required this.email,
    this.name,
    this.phoneNumber,
    this.location,
    this.soilType,
    this.createdAt,
    this.updatedAt,
  });

  /// Create UserModel from Firestore document
  factory UserModel.fromFirestore(Map<String, dynamic> data, String userId) {
    return UserModel(
      userId: userId,
      email: data['email'] ?? '',
      name: data['name'],
      phoneNumber: data['phoneNumber'],
      location: data['location'] != null
          ? LocationModel.fromMap(data['location'])
          : null,
      soilType: data['soilType'],
      createdAt: data['createdAt']?.toDate(),
      updatedAt: data['updatedAt']?.toDate(),
    );
  }

  /// Convert UserModel to Map for Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'email': email,
      if (name != null) 'name': name,
      if (phoneNumber != null) 'phoneNumber': phoneNumber,
      if (location != null) 'location': location!.toMap(),
      if (soilType != null) 'soilType': soilType,
      if (createdAt != null) 'createdAt': createdAt,
      'updatedAt': DateTime.now(),
    };
  }

  /// Create a copy with updated fields
  UserModel copyWith({
    String? userId,
    String? email,
    String? name,
    String? phoneNumber,
    LocationModel? location,
    String? soilType,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserModel(
      userId: userId ?? this.userId,
      email: email ?? this.email,
      name: name ?? this.name,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      location: location ?? this.location,
      soilType: soilType ?? this.soilType,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

/// Location Model
/// Represents user's location data
class LocationModel {
  final double latitude;
  final double longitude;
  final String? address;

  LocationModel({
    required this.latitude,
    required this.longitude,
    this.address,
  });

  /// Create LocationModel from Map
  factory LocationModel.fromMap(Map<String, dynamic> map) {
    return LocationModel(
      latitude: (map['latitude'] as num).toDouble(),
      longitude: (map['longitude'] as num).toDouble(),
      address: map['address'],
    );
  }

  /// Convert LocationModel to Map
  Map<String, dynamic> toMap() {
    return {
      'latitude': latitude,
      'longitude': longitude,
      if (address != null) 'address': address,
    };
  }
}
