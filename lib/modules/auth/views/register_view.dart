import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../app/routes/app_routes.dart';
import '../../../core/utils/validators.dart';
import '../controllers/auth_controller.dart';

/// Register View
/// Allows new users to create an account
class RegisterView extends StatelessWidget {
  const RegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthController controller = Get.find<AuthController>();
    final formKey = GlobalKey<FormState>();

    return Scaffold(
      appBar: AppBar(title: Text('register'.tr)),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 20),

                // Name Field
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Name',
                    prefixIcon: const Icon(Icons.person_outlined),
                  ),
                  validator: (value) =>
                      Validators.required(value, fieldName: 'Name'),
                  onChanged: (value) =>
                  controller.nameController.value = value,
                ),
                const SizedBox(height: 16),

                // Email Field
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'email'.tr,
                    prefixIcon: const Icon(Icons.email_outlined),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: Validators.email,
                  onChanged: (value) =>
                  controller.emailController.value = value,
                ),
                const SizedBox(height: 16),

                // Password Field
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'password'.tr,
                    prefixIcon: const Icon(Icons.lock_outlined),
                  ),
                  obscureText: true,
                  validator: Validators.password,
                  onChanged: (value) =>
                  controller.passwordController.value = value,
                ),
                const SizedBox(height: 16),

                // Confirm Password Field
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'confirm_password'.tr,
                    prefixIcon: const Icon(Icons.lock_outlined),
                  ),
                  obscureText: true,
                  validator: (value) => Validators.confirmPassword(
                    value,
                    controller.passwordController.value,
                  ),
                  onChanged: (value) =>
                  controller.confirmPasswordController.value = value,
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

                // Register Button
                Obx(
                  () => ElevatedButton(
                    onPressed: controller.isLoading.value
                        ? null
                        : () async {
                            if (formKey.currentState!.validate()) {
                              final success = await controller.register();
                              if (success) {
                                Get.offAllNamed(AppRoutes.HOME);
                              }
                            }
                          },
                    child: controller.isLoading.value
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : Text('sign_up'.tr),
                  ),
                ),
                const SizedBox(height: 24),

                // Login Link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('already_have_account'.tr),
                    TextButton(
                      onPressed: () => Get.back(),
                      child: Text('sign_in'.tr),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
