import 'package:cloud_firestore/cloud_firestore.dart';

/// Market Price Model
/// Represents crop market price data
class MarketPriceModel {
  final String priceId;
  final String cropName;
  final double price;
  final String unit; // per kg, per quintal, etc.
  final String location;
  final DateTime date;
  final String? cropType;

  MarketPriceModel({
    required this.priceId,
    required this.cropName,
    required this.price,
    required this.unit,
    required this.location,
    required this.date,
    this.cropType,
  });

  /// Create MarketPriceModel from Firestore
  factory MarketPriceModel.fromFirestore(
    Map<String, dynamic> data,
    String priceId,
  ) {
    return MarketPriceModel(
      priceId: priceId,
      cropName: data['cropName'] ?? '',
      price: (data['price'] as num).toDouble(),
      unit: data['unit'] ?? 'per kg',
      location: data['location'] ?? '',
      date: (data['date'] as Timestamp).toDate(),
      cropType: data['cropType'],
    );
  }

  /// Convert MarketPriceModel to Map
  Map<String, dynamic> toMap() {
    return {
      'cropName': cropName,
      'price': price,
      'unit': unit,
      'location': location,
      'date': date,
      if (cropType != null) 'cropType': cropType,
    };
  }
}
