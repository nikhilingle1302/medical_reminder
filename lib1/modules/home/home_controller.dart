import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class HomeController extends GetxController {
  final storage = GetStorage();
  final selectedIndex = 0.obs;
  final username = ''.obs;

  @override
  void onInit() {
    super.onInit();
    username.value = storage.read('username') ?? 'User';
  }

  void changeTab(int index) {
    selectedIndex.value = index;
  }

  String getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning';
    if (hour < 17) return 'Good Afternoon';
    return 'Good Evening';
  }
}