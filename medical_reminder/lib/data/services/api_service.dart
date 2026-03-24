import 'package:dio/dio.dart';
import 'package:medical_reminder/data/models/order_model.dart';
import 'package:medical_reminder/data/models/search_medicien.dart';
import 'package:retrofit/retrofit.dart';
import 'package:medical_reminder/data/models/auth_model.dart';
import 'package:medical_reminder/data/models/reminder_model.dart';
import 'package:medical_reminder/data/models/medicine_model.dart';

part 'api_service.g.dart';
  
@RestApi()
abstract class ApiService {
  factory ApiService(Dio dio, {String baseUrl}) = _ApiService;

  // Auth Endpoints
@POST('/api/register/')
Future<RegisterResponse> register(@Body() RegisterRequest request);

  @POST('/api/login/')
Future<LoginResponse> login(@Body() LoginRequest request);
  

  @POST('/api/accounts/patient/login/')
  Future<LoginResponse> patientLogin(@Body() LoginRequest request);

  @POST('/api/accounts/caretaker/login/')
  Future<LoginResponse> caretakerLogin(@Body() LoginRequest request);

  @POST('/api/accounts/seller/login/')
Future<LoginResponse> sellerLogin(@Body() LoginRequest request);

@POST('/api/pharmacy/sales/')
Future<dynamic> sellMedicine(@Body() Map<String, dynamic> request);


  // Pharmacy Endpoints
  @GET('/api/medicines/')
  Future<List<Medicine>> getMedicines();

  // Reminder Endpoints
@GET('/api/reminders/my/')
Future<List<Reminder>> getReminders();


@POST('/api/reminders/')
Future<dynamic> createReminder(@Body() Map<String, dynamic> request);

@GET('/api/search/')
Future<List<SearchResultItem>> searchMedicine(
  @Query('q') String name,
);

@POST('/api/orders/')
Future<dynamic> createOrder(@Body() Map<String, dynamic> request);

@POST('/api/orders/{id}/confirm/')
Future<dynamic> confirmOrder(@Path('id') int orderId);

  @PUT('/api/reminders/{id}/')
  Future<Reminder> updateReminder(
    @Path('id') int id,
    @Body() CreateReminderRequest request,
  );

  @DELETE('/api/reminders/{id}/')
  Future<void> deleteReminder(@Path('id') int id);

  @POST('/api/reminders/{id}/taken/')
  Future<Reminder> markReminderTaken(@Path('id') int id);

  // FCM Endpoints
@POST('/api/save-fcm-token/')
Future<void> saveFcmToken(@Body() Map<String, String> body);

  @GET('/api/reminders/test-fcm/')
  Future<void> testFcm();

  // @POST('/api/pharmacy/medicines/save/')
  // Future<dynamic> createMedicine(@Body() dynamic request);
    @POST('/api/medicines/')
  Future<dynamic> createMedicine(@Body() dynamic request);

 @POST('/api/stores/') 
Future<dynamic> createStore(@Body() dynamic body);

 @POST('/api/inventory/') 
Future<dynamic> addInventory(@Body() dynamic body);

@GET('/api/orders/')
Future<List<OrderModel>> getOrders();

@GET('/api/stores/all/')
Future<List<StoreModel>> getAllStores();

@GET('/api/stores/all/')
Future<List<SellerStoreModel>> getSellerAllStores();

    @POST('/api/pharmacy/medicines/')
  Future<dynamic> createSellerMedicine(@Body() dynamic request);

  @GET('/api/reminders/due/')
  Future<dynamic> getDueReminders();
}
// @RestApi(baseUrl: AppConstants.baseUrl)
// abstract class ApiService {
//   factory ApiService(Dio dio, {String baseUrl}) = _ApiService;

//   // Auth Endpoints - NO Authorization header needed
//   @POST('/api/accounts/register/')
//   Future<User> register(@Body() RegisterRequest request);

//   @POST('/api/accounts/patient/login/')
//   Future<LoginResponse> patientLogin(@Body() LoginRequest request);

//   @POST('/api/accounts/caretaker/login/')
//   Future<LoginResponse> caretakerLogin(@Body() LoginRequest request);

//   // Pharmacy Endpoints - Authorization handled by Dio interceptor
//   @GET('/api/pharmacy/medicines/')
//   Future<List<Medicine>> getMedicines();

//   // Reminder Endpoints - Authorization handled by Dio interceptor
//   @GET('/api/reminders/')
//   Future<List<Reminder>> getReminders();

//   @POST('/api/reminders/')
//   Future<ApiResponse> createReminder(@Body() CreateReminderRequest request);

//   @POST('/api/reminders/{id}/taken/')
//   Future<ApiResponse> markReminderTaken(@Path('id') int id);

//   // Note: These endpoints might not exist in current API, but keeping them
//   @PUT('/api/reminders/{id}/')
//   Future<Reminder> updateReminder(
//     @Path('id') int id,
//     @Body() CreateReminderRequest request,
//   );

//   @DELETE('/api/reminders/{id}/')
//   Future<void> deleteReminder(@Path('id') int id);

//   //   @GET('/api/reminders/due/')
//   // Future<DueRemindersResponse> getDueReminders(
//   //   @Header('Authorization') String token,
//   // );
//     @POST('/api/pharmacy/medicines/save/')
//   Future<ApiResponse> createMedicine(
//     @Header('Authorization') String token,
//     @Body() CreateMedicineRequest request,
//   );
// }

// // Response Models
// @JsonSerializable()
// class ApiResponse {
//   final String? message;
//   final String? status;

//   ApiResponse({this.message, this.status});

//   factory ApiResponse.fromJson(Map<String, dynamic> json) =>
//       _$ApiResponseFromJson(json);
//   Map<String, dynamic> toJson() => _$ApiResponseToJson(this);
// }
// @RestApi(baseUrl: AppConstants.baseUrl)
// abstract class ApiService {
//   factory ApiService(Dio dio, {String baseUrl}) = _ApiService;
//   // Auth Endpoints - NO TOKEN NEEDED
//   // @POST('/api/accounts/register/')
//   // Future<User> register(@Body() RegisterRequest request);

//   // @POST('/api/accounts/patient/login/')
//   // Future<LoginResponse> patientLogin(@Body() LoginRequest request);

//   // @POST('/api/accounts/caretaker/login/')
//   // Future<LoginResponse> caretakerLogin(@Body() LoginRequest request);
//   // Authentication
//   @POST('/api/accounts/register/')
//   Future<LoginResponse> register(@Body() RegisterRequest request);

//   // Separate login endpoints based on the original API documentation
//   @POST('/api/accounts/patient/login/')
//   Future<LoginResponse> patientLogin(@Body() Map<String,String> request);

//   @POST('/api/accounts/caretaker/login/')
//   Future<LoginResponse> caretakerLogin(@Body() Map<String,String> request);

//   // Pharmacy
//   @GET('/api/pharmacy/medicines/')
//   Future<List<Medicine>> getMedicines(@Header('Authorization') String token);


//   @POST('/api/pharmacy/medicines/save/')
//   Future<ApiResponse> createMedicine(
//     @Header('Authorization') String token,
//     @Body() CreateMedicineRequest request,
//   );

//   // Reminders
//   @GET('/api/reminders/')
//   Future<List<Reminder>> getReminders(@Header('Authorization') String token);

//   @POST('/api/reminders/')
//   Future<ApiResponse> createReminder(
//     @Header('Authorization') String token,
//     @Body() CreateReminderRequest request,
//   );

//   @POST('/api/reminders/{id}/taken/')
//   Future<ApiResponse> markReminderTaken(
//     @Header('Authorization') String token,
//     @Path('id') int id,
//   );

//   @GET('/api/reminders/due/')
//   Future<DueRemindersResponse> getDueReminders(
//     @Header('Authorization') String token,
//   );
// }

// // Response wrappers
// @JsonSerializable()
// class ApiResponse {
//   final String? message;
//   final String? status;

//   ApiResponse({this.message, this.status});

//   factory ApiResponse.fromJson(Map<String, dynamic> json) =>
//       _$ApiResponseFromJson(json);
//   Map<String, dynamic> toJson() => _$ApiResponseToJson(this);
// }

// @JsonSerializable()
// class DueRemindersResponse {
//   final String status;
//   @JsonKey(name: 'notifications_sent')
//   final int notificationsSent;

//   DueRemindersResponse({
//     required this.status,
//     required this.notificationsSent,
//   });

//   factory DueRemindersResponse.fromJson(Map<String, dynamic> json) =>
//       _$DueRemindersResponseFromJson(json);
//   Map<String, dynamic> toJson() => _$DueRemindersResponseToJson(this);
// }