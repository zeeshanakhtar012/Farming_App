import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/market_prices_controller.dart';

/// Market Prices View
/// Displays crop market prices with filtering options
class MarketPricesView extends StatelessWidget {
  const MarketPricesView({super.key});

  @override
  Widget build(BuildContext context) {
    final MarketPricesController controller =
        Get.find<MarketPricesController>();

    return Scaffold(
      appBar: AppBar(
        title: Text('market_prices'.tr),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => controller.fetchPrices(),
          ),
        ],
      ),
      body: Column(
        children: [
          // Filters Section
          Card(
            margin: const EdgeInsets.all(16),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Search Bar
                  TextField(
                    decoration: InputDecoration(
                      labelText: 'search'.tr,
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onChanged: (value) => controller.setSearchQuery(value),
                  ),
                  const SizedBox(height: 16),

                  // Crop Filter
                  Obx(
                    () => DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        labelText: 'Filter by Crop',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      value: controller.selectedCropFilter.value,
                      items: controller.cropTypes.map((crop) {
                        return DropdownMenuItem(value: crop, child: Text(crop));
                      }).toList(),
                      onChanged: (value) =>
                          controller.setCropFilter(value ?? 'All'),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Location Filter
                  Obx(
                    () => DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        labelText: 'Filter by Location',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      value: controller.selectedLocationFilter.value,
                      items: controller.locations.map((location) {
                        return DropdownMenuItem(
                          value: location,
                          child: Text(location),
                        );
                      }).toList(),
                      onChanged: (value) =>
                          controller.setLocationFilter(value ?? 'All'),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Prices List
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              if (controller.filteredPrices.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.inbox, size: 64, color: Colors.grey.shade400),
                      const SizedBox(height: 16),
                      Text(
                        'No prices found',
                        style: TextStyle(color: Colors.grey.shade600),
                      ),
                    ],
                  ),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: controller.filteredPrices.length,
                itemBuilder: (context, index) {
                  final price = controller.filteredPrices[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        child: Text(
                          price.cropName[0],
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                      title: Text(
                        price.cropName,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        '${price.location} • ${_formatDate(price.date)}',
                      ),
                      trailing: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            'Rs. ${price.price.toStringAsFixed(0)}',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                          Text(
                            price.unit,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
