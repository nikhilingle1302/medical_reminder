import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:medical_reminder/core/network/dio_config.dart';
import 'package:medical_reminder/data/repositories/auth_repository.dart';
import 'package:medical_reminder/data/repositories/medicine_repository.dart';
import 'package:medical_reminder/data/repositories/pharmacy_repository.dart';
import 'package:medical_reminder/data/repositories/reminder_repository.dart';
import 'package:medical_reminder/data/services/api_service.dart';
import 'package:medical_reminder/data/services/notification_service.dart';
import 'package:medical_reminder/presentation/controllers/auth_controller.dart';
import 'package:medical_reminder/presentation/controllers/medicine_controller.dart';
import 'package:medical_reminder/presentation/controllers/pharmacy_controller.dart';
import 'package:medical_reminder/presentation/controllers/reminder_controller.dart';
class AppBindings extends Bindings {
  @override
  void dependencies() {
    // Dio instance
    final dio = DioClient.dio;
    Get.lazyPut(() => dio, fenix: true);
    
    // Services
    Get.lazyPut(() => ApiService(Get.find<Dio>()), fenix: true);
    
    // Repositories
    Get.lazyPut(() => AuthRepository(Get.find<ApiService>()), fenix: true);
    Get.lazyPut(() => ReminderRepository(Get.find<ApiService>()), fenix: true);
    Get.lazyPut(() => MedicineRepository(Get.find<ApiService>()), fenix: true);
    Get.lazyPut(() => PharmacyRepository(Get.find<ApiService>()), fenix: true);
    
    // Controllers
    Get.lazyPut(() => AuthController(Get.find<AuthRepository>()), fenix: true);
    Get.lazyPut(() => ReminderController(Get.find<ReminderRepository>()), fenix: true);
    Get.lazyPut(() => MedicineController(Get.find<MedicineRepository>()), fenix: true);
    Get.lazyPut(() => PharmacyController(Get.find<PharmacyRepository>()), fenix: true);
  }
}
// class AppBindings extends Bindings {
//   @override
//   void dependencies() {
//     // Dio instance
//     final dio = DioConfig.createDio();
//     Get.lazyPut(() => dio, fenix: true);
    
//     // Services
//     Get.lazyPut(() => ApiService(Get.find<Dio>()), fenix: true);
    
//     // Repositories
//     Get.lazyPut(() => AuthRepository(Get.find<ApiService>()), fenix: true);
//     Get.lazyPut(() => ReminderRepository(Get.find<ApiService>()), fenix: true);
//     Get.lazyPut(() => MedicineRepository(Get.find<ApiService>()), fenix: true);
    
//     // Controllers
//     Get.lazyPut(() => AuthController(Get.find<AuthRepository>()), fenix: true);
//     Get.lazyPut(() => ReminderController(Get.find<ReminderRepository>()), fenix: true);
//     Get.lazyPut(() => MedicineController(Get.find<MedicineRepository>()), fenix: true);
//   }
// }
// class AppBindings extends Bindings {
//   @override
//   void dependencies() {
//     // Dio instance
//     final dio = DioConfig.createDio();
//     Get.lazyPut(() => dio, fenix: true);
    
//     // Services
//     Get.lazyPut(() => ApiService(Get.find<Dio>()), fenix: true);
    
//     // Repositories
//     Get.lazyPut(() => AuthRepository(Get.find<ApiService>()), fenix: true);
//     Get.lazyPut(() => ReminderRepository(Get.find<ApiService>()), fenix: true);
    
//     // Controllers
//     Get.lazyPut(() => AuthController(Get.find<AuthRepository>()), fenix: true);
//     Get.lazyPut(() => ReminderController(Get.find<ReminderRepository>()), fenix: true);
//   }
// }