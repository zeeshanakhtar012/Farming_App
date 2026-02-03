import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../core/services/firebase_service.dart';
import '../models/user_model.dart';

/// Authentication Controller
/// Manages authentication state and operations
class AuthController extends GetxController {
  final FirebaseService _firebaseService = Get.find<FirebaseService>();

  // Observable state
  final RxBool isLoading = false.obs;
  final RxBool isLoggedIn = false.obs;
  final Rx<UserModel?> currentUser = Rx<UserModel?>(null);
  final RxString errorMessage = ''.obs;

  // Form controllers
  final emailController = ''.obs;
  final passwordController = ''.obs;
  final confirmPasswordController = ''.obs;
  final nameController = ''.obs;

  @override
  void onInit() {
    super.onInit();
    print('🎯 [AUTH_CONTROLLER] onInit called');
    _checkAuthState();
  }

  @override
  void onReady() {
    super.onReady();
    print('✅ [AUTH_CONTROLLER] onReady called');
  }

  @override
  void onClose() {
    print('🔴 [AUTH_CONTROLLER] onClose called');
    super.onClose();
  }

  /// Check current authentication state
  void _checkAuthState() {
    print('👀 [AUTH_CONTROLLER] Checking auth state...');
    _firebaseService.authStateChanges.listen((User? user) {
      print('🔔 [AUTH_CONTROLLER] Auth state changed: ${user?.uid ?? "null"}');
      isLoggedIn.value = user != null;
      if (user != null) {
        print('👤 [AUTH_CONTROLLER] User logged in: ${user.email}');
        _loadUserData(user.uid);
      } else {
        print('👋 [AUTH_CONTROLLER] User logged out');
        currentUser.value = null;
      }
    });
  }

  /// Load user data from Firestore
  Future<void> _loadUserData(String userId) async {
    try {
      print('📥 [AUTH_CONTROLLER] Loading user data for: $userId');
      final doc = await _firebaseService.getDocument('users', userId);
      if (doc.exists) {
        print('✅ [AUTH_CONTROLLER] User document found');
        currentUser.value = UserModel.fromFirestore(
          doc.data() as Map<String, dynamic>,
          userId,
        );
        print('👤 [AUTH_CONTROLLER] User loaded: ${currentUser.value?.name}');
      } else {
        print('⚠️ [AUTH_CONTROLLER] User document does not exist');
      }
    } catch (e) {
      print('❌ [AUTH_CONTROLLER] Error loading user data: $e');
    }
  }

  /// Sign in with email and password
  Future<bool> signIn() async {
    try {
      print('═══════════════════════════════════════');
      print('🔐 [SIGN_IN] Process started');
      print('═══════════════════════════════════════');

      isLoading.value = true;
      errorMessage.value = '';

      print('📧 [SIGN_IN] Email: "${emailController.value}"');
      print('🔑 [SIGN_IN] Password length: ${passwordController.value.length}');

      // Validation
      if (emailController.value.isEmpty || passwordController.value.isEmpty) {
        print('❌ [SIGN_IN] Validation failed: Empty fields');
        errorMessage.value = 'Please fill in all fields';
        isLoading.value = false;
        return false;
      }

      print('🔄 [SIGN_IN] Calling Firebase signInWithEmail...');
      final userCredential = await _firebaseService.signInWithEmail(
        email: emailController.value,
        password: passwordController.value,
      );

      print('✅ [SIGN_IN] Firebase returned credential');
      print('👤 [SIGN_IN] User ID: ${userCredential?.user?.uid}');
      print('📧 [SIGN_IN] User Email: ${userCredential?.user?.email}');

      if (userCredential?.user != null) {
        print('📥 [SIGN_IN] Loading user data from Firestore...');
        await _loadUserData(userCredential!.user!.uid);
        print('✅ [SIGN_IN] Sign in successful!');
        print('═══════════════════════════════════════');
        isLoading.value = false;
        return true;
      }

      print('⚠️ [SIGN_IN] No user credential returned');
      print('═══════════════════════════════════════');
      isLoading.value = false;
      return false;
    } catch (e) {
      print('❌ [SIGN_IN] Exception occurred: $e');
      print('❌ [SIGN_IN] Exception type: ${e.runtimeType}');
      print('═══════════════════════════════════════');
      errorMessage.value = e.toString();
      isLoading.value = false;
      return false;
    }
  }

  /// Register new user
  Future<bool> register() async {
    try {
      print('═══════════════════════════════════════');
      print('📝 [REGISTER] Process started');
      print('═══════════════════════════════════════');

      isLoading.value = true;
      errorMessage.value = '';

      print('📧 [REGISTER] Email: "${emailController.value}"');
      print('👤 [REGISTER] Name: "${nameController.value}"');
      print('🔑 [REGISTER] Password length: ${passwordController.value.length}');
      print('🔑 [REGISTER] Confirm password length: ${confirmPasswordController.value.length}');

      // Validate inputs
      if (emailController.value.isEmpty ||
          passwordController.value.isEmpty ||
          nameController.value.isEmpty) {
        print('❌ [REGISTER] Validation failed: Empty fields');
        errorMessage.value = 'Please fill in all fields';
        isLoading.value = false;
        return false;
      }

      if (passwordController.value != confirmPasswordController.value) {
        print('❌ [REGISTER] Validation failed: Passwords do not match');
        errorMessage.value = 'Passwords do not match';
        isLoading.value = false;
        return false;
      }

      if (passwordController.value.length < 6) {
        print('❌ [REGISTER] Validation failed: Password too short');
        errorMessage.value = 'Password must be at least 6 characters';
        isLoading.value = false;
        return false;
      }

      print('✅ [REGISTER] Validation passed');
      print('🔄 [REGISTER] Calling Firebase registerWithEmail...');

      // Register user
      final userCredential = await _firebaseService.registerWithEmail(
        email: emailController.value,
        password: passwordController.value,
      );

      print('✅ [REGISTER] Firebase returned credential');
      print('👤 [REGISTER] User ID: ${userCredential?.user?.uid}');
      print('📧 [REGISTER] User Email: ${userCredential?.user?.email}');

      if (userCredential?.user != null) {
        print('💾 [REGISTER] Creating user document in Firestore...');

        // Create user document in Firestore
        final userModel = UserModel(
          userId: userCredential!.user!.uid,
          email: emailController.value,
          name: nameController.value,
          createdAt: DateTime.now(),
        );

        print('📝 [REGISTER] User model created: ${userModel.toFirestore()}');

        await _firebaseService.setDocument(
          'users',
          userCredential.user!.uid,
          userModel.toFirestore(),
        );

        print('✅ [REGISTER] User document created in Firestore');
        print('📥 [REGISTER] Loading user data...');

        await _loadUserData(userCredential.user!.uid);

        print('✅ [REGISTER] Registration successful!');
        print('═══════════════════════════════════════');
        isLoading.value = false;
        return true;
      }

      print('⚠️ [REGISTER] No user credential returned');
      print('═══════════════════════════════════════');
      isLoading.value = false;
      return false;
    } catch (e) {
      print('❌ [REGISTER] Exception occurred: $e');
      print('❌ [REGISTER] Exception type: ${e.runtimeType}');
      print('═══════════════════════════════════════');
      errorMessage.value = e.toString();
      isLoading.value = false;
      return false;
    }
  }

  /// Send password reset email
  Future<bool> sendPasswordResetEmail() async {
    try {
      print('═══════════════════════════════════════');
      print('🔑 [PASSWORD_RESET] Process started');
      print('═══════════════════════════════════════');

      isLoading.value = true;
      errorMessage.value = '';

      print('📧 [PASSWORD_RESET] Email: "${emailController.value}"');

      if (emailController.value.isEmpty) {
        print('❌ [PASSWORD_RESET] Validation failed: Empty email');
        errorMessage.value = 'Please enter your email';
        isLoading.value = false;
        return false;
      }

      print('🔄 [PASSWORD_RESET] Sending password reset email...');
      await _firebaseService.sendPasswordResetEmail(emailController.value);

      print('✅ [PASSWORD_RESET] Password reset email sent successfully');
      print('═══════════════════════════════════════');
      isLoading.value = false;
      return true;
    } catch (e) {
      print('❌ [PASSWORD_RESET] Exception occurred: $e');
      print('❌ [PASSWORD_RESET] Exception type: ${e.runtimeType}');
      print('═══════════════════════════════════════');
      errorMessage.value = e.toString();
      isLoading.value = false;
      return false;
    }
  }

  /// Sign out
  Future<void> signOut() async {
    try {
      print('═══════════════════════════════════════');
      print('👋 [SIGN_OUT] Process started');
      print('═══════════════════════════════════════');

      isLoading.value = true;

      print('🔄 [SIGN_OUT] Calling Firebase signOut...');
      await _firebaseService.signOut();

      currentUser.value = null;

      print('✅ [SIGN_OUT] Sign out successful');
      print('═══════════════════════════════════════');
      isLoading.value = false;
    } catch (e) {
      print('❌ [SIGN_OUT] Exception occurred: $e');
      print('❌ [SIGN_OUT] Exception type: ${e.runtimeType}');
      print('═══════════════════════════════════════');
      errorMessage.value = e.toString();
      isLoading.value = false;
    }
  }

  /// Clear form fields
  void clearFields() {
    print('🧹 [AUTH_CONTROLLER] Clearing form fields');
    emailController.value = '';
    passwordController.value = '';
    confirmPasswordController.value = '';
    nameController.value = '';
    errorMessage.value = '';
  }
}