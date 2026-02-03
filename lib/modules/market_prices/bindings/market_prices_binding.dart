import 'package:get/get.dart';
import '../controllers/market_prices_controller.dart';

/// Market Prices Binding
class MarketPricesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MarketPricesController>(() => MarketPricesController());
  }
}
