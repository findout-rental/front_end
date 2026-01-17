import 'package:get/get.dart';

class HomeController extends GetxController {
  final selectedIndex = 0.obs;

  void onTabTapped(int index) {
    selectedIndex.value = index;
  }
}
