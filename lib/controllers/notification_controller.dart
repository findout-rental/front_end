import 'package:get/get.dart';
import 'package:project/data/models/notification_model.dart';
import 'package:project/services/notification_service.dart';

class NotificationController extends GetxController {
  final NotificationService _service = Get.find<NotificationService>();

  final isLoading = false.obs;
  final notifications = <NotificationModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchNotifications();
  }

  Future<void> fetchNotifications() async {
    try {
      isLoading.value = true;
      final response = await _service.getNotifications();
      final List<dynamic> data = response.data['data'] ?? [];
      notifications.assignAll(
        data.map((json) => NotificationModel.fromJson(json)).toList(),
      );
    } catch (e) {
      print("Fetch Notifications Error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> markAllAsRead() async {
    try {
      await _service.markAllAsRead();
      for (var notification in notifications) {}
      notifications.refresh();
    } catch (e) {
      print("Mark as read error: $e");
    }
  }
}
