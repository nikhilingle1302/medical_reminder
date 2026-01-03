// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
      id: (json['id'] as num?)?.toInt(),
      username: json['username'] as String,
      password: json['password'] as String?,
      role: json['role'] as String?,
    );

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'id': instance.id,
      'username': instance.username,
      'password': instance.password,
      'role': instance.role,
    };

LoginRequest _$LoginRequestFromJson(Map<String, dynamic> json) => LoginRequest(
      username: json['username'] as String,
      password: json['password'] as String,
    );

Map<String, dynamic> _$LoginRequestToJson(LoginRequest instance) =>
    <String, dynamic>{
      'username': instance.username,
      'password': instance.password,
    };

RegisterRequest _$RegisterRequestFromJson(Map<String, dynamic> json) =>
    RegisterRequest(
      username: json['username'] as String,
      password: json['password'] as String,
      role: json['role'] as String,
    );

Map<String, dynamic> _$RegisterRequestToJson(RegisterRequest instance) =>
    <String, dynamic>{
      'username': instance.username,
      'password': instance.password,
      'role': instance.role,
    };

LoginResponse _$LoginResponseFromJson(Map<String, dynamic> json) =>
    LoginResponse(
      token: json['token'] as String,
      message: json['message'] as String,
      userId: (json['user_id'] as num).toInt(),
      username: json['username'] as String,
      role: json['role'] as String,
    );

Map<String, dynamic> _$LoginResponseToJson(LoginResponse instance) =>
    <String, dynamic>{
      'token': instance.token,
      'message': instance.message,
      'user_id': instance.userId,
      'username': instance.username,
      'role': instance.role,
    };

Medicine _$MedicineFromJson(Map<String, dynamic> json) => Medicine(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      company: json['company'] as String?,
      stock: (json['stock'] as num?)?.toInt(),
      expiry: json['expiry'] as String?,
    );

Map<String, dynamic> _$MedicineToJson(Medicine instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'company': instance.company,
      'stock': instance.stock,
      'expiry': instance.expiry,
    };

Reminder _$ReminderFromJson(Map<String, dynamic> json) => Reminder(
      id: (json['id'] as num?)?.toInt(),
      firebasePatientId: json['firebase_patient_id'] as String?,
      firebaseCaretakerId: json['firebase_caretaker_id'] as String?,
      medicineId: (json['medicine_id'] as num?)?.toInt(),
      medicine: json['medicine'] as String?,
      dosage: json['dosage'] as String,
      reminderTime: json['reminder_time'] as String,
      isTaken: json['is_taken'] as bool?,
    );

Map<String, dynamic> _$ReminderToJson(Reminder instance) => <String, dynamic>{
      'id': instance.id,
      'firebase_patient_id': instance.firebasePatientId,
      'firebase_caretaker_id': instance.firebaseCaretakerId,
      'medicine_id': instance.medicineId,
      'medicine': instance.medicine,
      'dosage': instance.dosage,
      'reminder_time': instance.reminderTime,
      'is_taken': instance.isTaken,
    };

CreateReminderRequest _$CreateReminderRequestFromJson(
        Map<String, dynamic> json) =>
    CreateReminderRequest(
      firebasePatientId: json['firebase_patient_id'] as String,
      firebaseCaretakerId: json['firebase_caretaker_id'] as String?,
      medicineId: (json['medicine_id'] as num).toInt(),
      dosage: json['dosage'] as String,
      reminderTime: json['reminder_time'] as String,
    );

Map<String, dynamic> _$CreateReminderRequestToJson(
        CreateReminderRequest instance) =>
    <String, dynamic>{
      'firebase_patient_id': instance.firebasePatientId,
      'firebase_caretaker_id': instance.firebaseCaretakerId,
      'medicine_id': instance.medicineId,
      'dosage': instance.dosage,
      'reminder_time': instance.reminderTime,
    };
