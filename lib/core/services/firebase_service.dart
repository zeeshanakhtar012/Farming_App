import 'dart:typed_data';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';

/// Firebase Service
/// Handles all Firebase-related operations (Auth, Firestore, Storage)
class FirebaseService extends GetxService {
  // Firebase Instances
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // Getters
  FirebaseAuth get auth => _auth;
  FirebaseFirestore get firestore => _firestore;
  FirebaseStorage get storage => _storage;

  // Current User Stream
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Current User
  User? get currentUser => _auth.currentUser;

  /// Initialize Firebase Service
  Future<FirebaseService> init() async {
    print('🚀 [FIREBASE_SERVICE] Initializing...');

    // Listen to auth state changes. Defer navigation so it runs after
    // GetMaterialApp is built (avoids contextless navigation on startup).
    _auth.authStateChanges().listen((User? user) {
      print('🔔 [FIREBASE_SERVICE] Auth state changed: ${user?.uid ?? "null"}');
      if (user == null) {
        print('🔄 [FIREBASE_SERVICE] No user, navigating to /login');
        SchedulerBinding.instance.addPostFrameCallback((_) {
          Get.offAllNamed('/login');
        });
      } else {
        print('✅ [FIREBASE_SERVICE] User authenticated: ${user.email}');
      }
    });

    print('✅ [FIREBASE_SERVICE] Initialized successfully');
    return this;
  }

  /// Sign in with email and password
  Future<UserCredential?> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      print('═══════════════════════════════════════');
      print('🔐 [FIREBASE_SERVICE] signInWithEmail called');
      print('📧 [FIREBASE_SERVICE] Email: "$email"');
      print('🔑 [FIREBASE_SERVICE] Password length: ${password.length}');
      print('═══════════════════════════════════════');

      final UserCredential userCredential = await _auth
          .signInWithEmailAndPassword(email: email.trim(), password: password);

      print('✅ [FIREBASE_SERVICE] Sign in successful');
      print('👤 [FIREBASE_SERVICE] User ID: ${userCredential.user?.uid}');
      print('📧 [FIREBASE_SERVICE] User Email: ${userCredential.user?.email}');
      print('✓ [FIREBASE_SERVICE] Email verified: ${userCredential.user?.emailVerified}');
      print('═══════════════════════════════════════');

      return userCredential;
    } on FirebaseAuthException catch (e) {
      print('❌ [FIREBASE_SERVICE] FirebaseAuthException caught');
      print('🔴 [FIREBASE_SERVICE] Error code: ${e.code}');
      print('🔴 [FIREBASE_SERVICE] Error message: ${e.message}');
      print('═══════════════════════════════════════');
      throw _handleAuthException(e);
    } catch (e) {
      print('❌ [FIREBASE_SERVICE] Generic exception caught');
      print('🔴 [FIREBASE_SERVICE] Error type: ${e.runtimeType}');
      print('🔴 [FIREBASE_SERVICE] Error: $e');
      print('═══════════════════════════════════════');
      throw 'An error occurred: ${e.toString()}';
    }
  }

  /// Register with email and password
  Future<UserCredential?> registerWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      print('═══════════════════════════════════════');
      print('📝 [FIREBASE_SERVICE] registerWithEmail called');
      print('📧 [FIREBASE_SERVICE] Email: "$email"');
      print('🔑 [FIREBASE_SERVICE] Password length: ${password.length}');
      print('═══════════════════════════════════════');

      final UserCredential userCredential =
      await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      print('✅ [FIREBASE_SERVICE] Registration successful');
      print('👤 [FIREBASE_SERVICE] User ID: ${userCredential.user?.uid}');
      print('📧 [FIREBASE_SERVICE] User Email: ${userCredential.user?.email}');
      print('✓ [FIREBASE_SERVICE] Email verified: ${userCredential.user?.emailVerified}');
      print('═══════════════════════════════════════');

      return userCredential;
    } on FirebaseAuthException catch (e) {
      print('❌ [FIREBASE_SERVICE] FirebaseAuthException caught');
      print('🔴 [FIREBASE_SERVICE] Error code: ${e.code}');
      print('🔴 [FIREBASE_SERVICE] Error message: ${e.message}');
      print('═══════════════════════════════════════');
      throw _handleAuthException(e);
    } catch (e) {
      print('❌ [FIREBASE_SERVICE] Generic exception caught');
      print('🔴 [FIREBASE_SERVICE] Error type: ${e.runtimeType}');
      print('🔴 [FIREBASE_SERVICE] Error: $e');

      final msg = e.toString().toLowerCase();
      if (msg.contains('network') ||
          msg.contains('recaptcha') ||
          msg.contains('timeout') ||
          msg.contains('unreachable')) {
        print('⚠️ [FIREBASE_SERVICE] Network/reCAPTCHA error detected');
        print('═══════════════════════════════════════');
        throw _networkRecaptchaErrorMessage;
      }
      print('═══════════════════════════════════════');
      throw 'An error occurred: ${e.toString()}';
    }
  }

  /// Send password reset email
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      print('═══════════════════════════════════════');
      print('🔑 [FIREBASE_SERVICE] sendPasswordResetEmail called');
      print('📧 [FIREBASE_SERVICE] Email: "$email"');
      print('═══════════════════════════════════════');

      await _auth.sendPasswordResetEmail(email: email.trim());

      print('✅ [FIREBASE_SERVICE] Password reset email sent');
      print('═══════════════════════════════════════');
    } on FirebaseAuthException catch (e) {
      print('❌ [FIREBASE_SERVICE] FirebaseAuthException caught');
      print('🔴 [FIREBASE_SERVICE] Error code: ${e.code}');
      print('🔴 [FIREBASE_SERVICE] Error message: ${e.message}');
      print('═══════════════════════════════════════');
      throw _handleAuthException(e);
    } catch (e) {
      print('❌ [FIREBASE_SERVICE] Generic exception caught');
      print('🔴 [FIREBASE_SERVICE] Error: $e');
      print('═══════════════════════════════════════');
      throw 'An error occurred: ${e.toString()}';
    }
  }

  /// Sign out
  Future<void> signOut() async {
    try {
      print('═══════════════════════════════════════');
      print('👋 [FIREBASE_SERVICE] signOut called');
      print('═══════════════════════════════════════');

      await _auth.signOut();

      print('✅ [FIREBASE_SERVICE] Sign out successful');
      print('═══════════════════════════════════════');
    } catch (e) {
      print('❌ [FIREBASE_SERVICE] Sign out error: $e');
      print('═══════════════════════════════════════');
      throw 'Error signing out: ${e.toString()}';
    }
  }

  /// Handle Firebase Auth Exceptions
  String _handleAuthException(FirebaseAuthException e) {
    print('🔍 [FIREBASE_SERVICE] Handling auth exception: ${e.code}');

    switch (e.code) {
      case 'weak-password':
        return 'The password provided is too weak.';
      case 'email-already-in-use':
        return 'An account already exists for that email.';
      case 'user-not-found':
        return 'No user found for that email.';
      case 'wrong-password':
        return 'Wrong password provided.';
      case 'invalid-email':
        return 'The email address is invalid.';
      case 'user-disabled':
        return 'This user account has been disabled.';
      case 'too-many-requests':
        return 'Too many requests. Please try again later.';
      case 'operation-not-allowed':
        return 'This operation is not allowed.';
      case 'network-request-failed':
        return _networkRecaptchaErrorMessage;
      default:
      // reCAPTCHA/network errors often come as generic messages
        final msg = (e.message ?? '').toLowerCase();
        if (msg.contains('network') ||
            msg.contains('recaptcha') ||
            msg.contains('timeout') ||
            msg.contains('unreachable')) {
          return _networkRecaptchaErrorMessage;
        }
        return e.message ?? 'An authentication error occurred.';
    }
  }

  static const String _networkRecaptchaErrorMessage =
      'Network or verification error. Check your internet connection, '
      'try again, or use a device/emulator with Google Play. '
      'If this persists, add your app\'s SHA-1 in Firebase Console → Project settings → Your apps.';

  /// Firestore Operations

  /// Get document from Firestore
  Future<DocumentSnapshot> getDocument(String collection, String docId) async {
    try {
      print('📄 [FIREBASE_SERVICE] Getting document: $collection/$docId');
      final doc = await _firestore.collection(collection).doc(docId).get();
      print('✅ [FIREBASE_SERVICE] Document exists: ${doc.exists}');
      return doc;
    } catch (e) {
      print('❌ [FIREBASE_SERVICE] Error getting document: $e');
      throw 'Error getting document: ${e.toString()}';
    }
  }

  /// Get collection from Firestore
  Future<QuerySnapshot> getCollection(String collection) async {
    try {
      print('📁 [FIREBASE_SERVICE] Getting collection: $collection');
      final snapshot = await _firestore.collection(collection).get();
      print('✅ [FIREBASE_SERVICE] Collection size: ${snapshot.docs.length}');
      return snapshot;
    } catch (e) {
      print('❌ [FIREBASE_SERVICE] Error getting collection: $e');
      throw 'Error getting collection: ${e.toString()}';
    }
  }

  /// Add document to Firestore
  Future<void> addDocument(String collection, Map<String, dynamic> data) async {
    try {
      print('➕ [FIREBASE_SERVICE] Adding document to: $collection');
      print('📝 [FIREBASE_SERVICE] Data: $data');
      await _firestore.collection(collection).add(data);
      print('✅ [FIREBASE_SERVICE] Document added successfully');
    } catch (e) {
      print('❌ [FIREBASE_SERVICE] Error adding document: $e');
      throw 'Error adding document: ${e.toString()}';
    }
  }

  /// Set document in Firestore
  Future<void> setDocument(
      String collection,
      String docId,
      Map<String, dynamic> data,
      ) async {
    try {
      print('💾 [FIREBASE_SERVICE] Setting document: $collection/$docId');
      print('📝 [FIREBASE_SERVICE] Data: $data');
      await _firestore.collection(collection).doc(docId).set(data);
      print('✅ [FIREBASE_SERVICE] Document set successfully');
    } catch (e) {
      print('❌ [FIREBASE_SERVICE] Error setting document: $e');
      throw 'Error setting document: ${e.toString()}';
    }
  }

  /// Update document in Firestore
  Future<void> updateDocument(
      String collection,
      String docId,
      Map<String, dynamic> data,
      ) async {
    try {
      print('🔄 [FIREBASE_SERVICE] Updating document: $collection/$docId');
      print('📝 [FIREBASE_SERVICE] Data: $data');
      await _firestore.collection(collection).doc(docId).update(data);
      print('✅ [FIREBASE_SERVICE] Document updated successfully');
    } catch (e) {
      print('❌ [FIREBASE_SERVICE] Error updating document: $e');
      throw 'Error updating document: ${e.toString()}';
    }
  }

  /// Delete document from Firestore
  Future<void> deleteDocument(String collection, String docId) async {
    try {
      print('🗑️ [FIREBASE_SERVICE] Deleting document: $collection/$docId');
      await _firestore.collection(collection).doc(docId).delete();
      print('✅ [FIREBASE_SERVICE] Document deleted successfully');
    } catch (e) {
      print('❌ [FIREBASE_SERVICE] Error deleting document: $e');
      throw 'Error deleting document: ${e.toString()}';
    }
  }

  /// Stream collection from Firestore
  Stream<QuerySnapshot> streamCollection(String collection) {
    print('📡 [FIREBASE_SERVICE] Streaming collection: $collection');
    return _firestore.collection(collection).snapshots();
  }

  /// Stream document from Firestore
  Stream<DocumentSnapshot> streamDocument(String collection, String docId) {
    print('📡 [FIREBASE_SERVICE] Streaming document: $collection/$docId');
    return _firestore.collection(collection).doc(docId).snapshots();
  }

  /// Storage Operations

  /// Upload file to Firebase Storage
  Future<String> uploadFile(
      String path,
      String fileName,
      List<int> fileBytes,
      ) async {
    try {
      print('📤 [FIREBASE_SERVICE] Uploading file: $path/$fileName');
      final Reference ref = _storage.ref().child(path).child(fileName);
      final UploadTask uploadTask = ref.putData(
        Uint8List.fromList(fileBytes),
        SettableMetadata(contentType: 'image/jpeg'),
      );
      final TaskSnapshot snapshot = await uploadTask;
      final String downloadUrl = await snapshot.ref.getDownloadURL();
      print('✅ [FIREBASE_SERVICE] File uploaded: $downloadUrl');
      return downloadUrl;
    } catch (e) {
      print('❌ [FIREBASE_SERVICE] Error uploading file: $e');
      throw 'Error uploading file: ${e.toString()}';
    }
  }

  /// Delete file from Firebase Storage
  Future<void> deleteFile(String path) async {
    try {
      print('🗑️ [FIREBASE_SERVICE] Deleting file: $path');
      await _storage.ref(path).delete();
      print('✅ [FIREBASE_SERVICE] File deleted successfully');
    } catch (e) {
      print('❌ [FIREBASE_SERVICE] Error deleting file: $e');
      throw 'Error deleting file: ${e.toString()}';
    }
  }
}