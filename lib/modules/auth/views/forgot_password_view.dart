import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/utils/validators.dart';
import '../controllers/auth_controller.dart';

/// Forgot Password View
/// Allows users to reset their password via email
class ForgotPasswordView extends StatelessWidget {
  const ForgotPasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthController controller = Get.find<AuthController>();
    final formKey = GlobalKey<FormState>();
    final emailSent = false.obs;

    return Scaffold(
      appBar: AppBar(title: Text('forgot_password'.tr)),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 40),

                // Icon
                Icon(
                  Icons.lock_reset,
                  size: 80,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(height: 24),

                // Title
                Text(
                  'Reset Password',
                  style: Theme.of(context).textTheme.displayMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'Enter your email address and we will send you a link to reset your password.',
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),

                // Email Field
                Obx(
                  () => TextFormField(
                    decoration: InputDecoration(
                      labelText: 'email'.tr,
                      prefixIcon: const Icon(Icons.email_outlined),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: Validators.email,
                    enabled: !emailSent.value,
                    onChanged: (value) =>
                        controller.emailController.value = value,
                  ),
                ),
                const SizedBox(height: 24),

                // Error Message
                Obx(
                  () => controller.errorMessage.value.isNotEmpty
                      ? Container(
                          padding: const EdgeInsets.all(12),
                          margin: const EdgeInsets.only(bottom: 16),
                          decoration: BoxDecoration(
                            color: Colors.red.shade50,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.red.shade200),
                          ),
                          child: Text(
                            controller.errorMessage.value,
                            style: TextStyle(color: Colors.red.shade700),
                          ),
                        )
                      : const SizedBox.shrink(),
                ),

                // Success Message
                Obx(
                  () => emailSent.value
                      ? Container(
                          padding: const EdgeInsets.all(12),
                          margin: const EdgeInsets.only(bottom: 16),
                          decoration: BoxDecoration(
                            color: Colors.green.shade50,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.green.shade200),
                          ),
                          child: Text(
                            'Password reset email sent! Please check your inbox.',
                            style: TextStyle(color: Colors.green.shade700),
                          ),
                        )
                      : const SizedBox.shrink(),
                ),

                // Submit Button
                Obx(
                  () => ElevatedButton(
                    onPressed: controller.isLoading.value || emailSent.value
                        ? null
                        : () async {
                            if (formKey.currentState!.validate()) {
                              final success = await controller
                                  .sendPasswordResetEmail();
                              if (success) {
                                emailSent.value = true;
                              }
                            }
                          },
                    child: controller.isLoading.value
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : Text(
                            emailSent.value ? 'Email Sent' : 'Send Reset Link',
                          ),
                  ),
                ),
                const SizedBox(height: 16),

                // Back to Login
                TextButton(
                  onPressed: () => Get.back(),
                  child: const Text('Back to Login'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
