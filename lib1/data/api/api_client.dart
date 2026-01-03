import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../models/api_models.dart';


part 'api_client.g.dart';

@RestApi()
abstract class ApiClient {
  factory ApiClient(Dio dio, {String baseUrl}) = _ApiClient;

  // Auth Endpoints
  @POST('/api/accounts/register/')
  Future<User> register(@Body() RegisterRequest request);

  @POST('/api/accounts/patient/login/')
  Future<LoginResponse> patientLogin(@Body() LoginRequest request);

  @POST('/api/accounts/caretaker/login/')
  Future<LoginResponse> caretakerLogin(@Body() LoginRequest request);

  // Pharmacy Endpoints
  @GET('/api/pharmacy/medicines/')
  Future<List<Medicine>> getMedicines();

  // Reminder Endpoints
  @GET('/api/reminders/')
  Future<List<Reminder>> getReminders();

  @POST('/api/reminders/')
  Future<Reminder> createReminder(@Body() CreateReminderRequest request);

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
  @POST('/api/reminders/save-fcm-token/')
  Future<void> saveFcmToken(@Body() Map<String, dynamic> token);

  @GET('/api/reminders/test-fcm/')
  Future<void> testFcm();
}