import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../app/routes/app_routes.dart';
import '../controllers/home_controller.dart';

/// Home View
/// Main dashboard screen with feature cards
class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final HomeController controller = Get.find<HomeController>();

    // Feature cards data
    final features = [
      {
        'title': 'crop_recommendation'.tr,
        'icon': Icons.eco,
        'color': Colors.green,
        'route': AppRoutes.CROP_RECOMMENDATION,
      },
      {
        'title': 'weather_forecast'.tr,
        'icon': Icons.wb_sunny,
        'color': Colors.orange,
        'route': AppRoutes.WEATHER,
      },
      {
        'title': 'disease_detection'.tr,
        'icon': Icons.bug_report,
        'color': Colors.red,
        'route': AppRoutes.DISEASE_DETECTION,
      },
      {
        'title': 'market_prices'.tr,
        'icon': Icons.attach_money,
        'color': Colors.blue,
        'route': AppRoutes.MARKET_PRICES,
      },
      {
        'title': 'farming_calendar'.tr,
        'icon': Icons.calendar_today,
        'color': Colors.purple,
        'route': AppRoutes.CALENDAR,
      },
      {
        'title': 'expense_tracker'.tr,
        'icon': Icons.account_balance_wallet,
        'color': Colors.teal,
        'route': AppRoutes.EXPENSE_TRACKER,
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text('app_name'.tr),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await controller.logout();
            },
            tooltip: 'logout'.tr,
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Welcome Section
              Obx(
                () => Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${'welcome'.tr}, ${controller.currentUser?.name ?? 'User'}!',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Make smart farming decisions',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white.withOpacity(0.9),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Features Grid
              Text(
                'Features',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 16),

              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 1.1,
                ),
                itemCount: features.length,
                itemBuilder: (context, index) {
                  final feature = features[index];
                  return _FeatureCard(
                    title: feature['title'] as String,
                    icon: feature['icon'] as IconData,
                    color: feature['color'] as Color,
                    onTap: () => Get.toNamed(feature['route'] as String),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Feature Card Widget
class _FeatureCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _FeatureCard({
    required this.title,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 48, color: color),
              const SizedBox(height: 12),
              Text(
                title,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleMedium,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
