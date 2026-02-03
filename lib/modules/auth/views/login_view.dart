import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../app/routes/app_routes.dart';
import '../../../core/utils/validators.dart';
import '../controllers/auth_controller.dart';

/// Login View
/// Allows users to sign in to the application
class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthController controller = Get.find<AuthController>();
    final formKey = GlobalKey<FormState>();

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 40),

                // App Logo
                Icon(
                  Icons.agriculture,
                  size: 80,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(height: 24),

                // Title
                Text(
                  'login'.tr,
                  style: Theme.of(context).textTheme.displayMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'Welcome back!'.tr,
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),

                // Email Field
                // Obx(
                //   () => TextFormField(
                //     decoration: InputDecoration(
                //       labelText: 'email'.tr,
                //       prefixIcon: const Icon(Icons.email_outlined),
                //     ),
                //     keyboardType: TextInputType.emailAddress,
                //     validator: Validators.email,
                //     onChanged: (value) =>
                //         controller.emailController.value = value,
                //   ),
                // ),
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
                // Obx(
                //   () => TextFormField(
                //     decoration: InputDecoration(
                //       labelText: 'password'.tr,
                //       prefixIcon: const Icon(Icons.lock_outlined),
                //     ),
                //     obscureText: true,
                //     validator: Validators.password,
                //     onChanged: (value) =>
                //         controller.passwordController.value = value,
                //   ),
                // ),
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
                const SizedBox(height: 8),

                // Forgot Password
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () => Get.toNamed(AppRoutes.FORGOT_PASSWORD),
                    child: Text('forgot_password'.tr),
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

                // Login Button
                Obx(
                  () => ElevatedButton(
                    onPressed: controller.isLoading.value
                        ? null
                        : () async {
                            if (formKey.currentState!.validate()) {
                              final success = await controller.signIn();
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
                        : Text('sign_in'.tr),
                  ),
                ),
                const SizedBox(height: 24),

                // Register Link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('dont_have_account'.tr),
                    TextButton(
                      onPressed: () => Get.toNamed(AppRoutes.REGISTER),
                      child: Text('sign_up'.tr),
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
