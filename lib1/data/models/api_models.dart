import 'package:json_annotation/json_annotation.dart';

part 'api_models.g.dart';

// User Model
@JsonSerializable()
class User {
  final int? id;
  final String username;
  final String? password;
  final String? role;

  User({
    this.id,
    required this.username,
    this.password,
    this.role,
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);
}

// Login Request Model
@JsonSerializable()
class LoginRequest {
  final String username;
  final String password;

  LoginRequest({
    required this.username,
    required this.password,
  });

  factory LoginRequest.fromJson(Map<String, dynamic> json) =>
      _$LoginRequestFromJson(json);
  Map<String, dynamic> toJson() => _$LoginRequestToJson(this);
}

// Register Request Model
@JsonSerializable()
class RegisterRequest {
  final String username;
  final String password;
  final String role;

  RegisterRequest({
    required this.username,
    required this.password,
    required this.role,
  });

  factory RegisterRequest.fromJson(Map<String, dynamic> json) =>
      _$RegisterRequestFromJson(json);
  Map<String, dynamic> toJson() => _$RegisterRequestToJson(this);
}

// Login Response Model - FIXED to handle your API response
@JsonSerializable()
class LoginResponse {
  final String token;
  final String message;
  @JsonKey(name: 'user_id')
  final int userId;
  final String username;
  final String role;

  LoginResponse({
    required this.token,
    required this.message,
    required this.userId,
    required this.username,
    required this.role,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) =>
      _$LoginResponseFromJson(json);
  Map<String, dynamic> toJson() => _$LoginResponseToJson(this);
}

// Medicine Model
@JsonSerializable()
class Medicine {
  final int id;
  final String name;
  final String? company;
  final int? stock;
  final String? expiry;

  Medicine({
    required this.id,
    required this.name,
    this.company,
    this.stock,
    this.expiry,
  });

  factory Medicine.fromJson(Map<String, dynamic> json) =>
      _$MedicineFromJson(json);
  Map<String, dynamic> toJson() => _$MedicineToJson(this);
}

// Reminder Model
@JsonSerializable()
class Reminder {
  final int? id;
  @JsonKey(name: 'firebase_patient_id')
  final String? firebasePatientId;
  @JsonKey(name: 'firebase_caretaker_id')
  final String? firebaseCaretakerId;
  @JsonKey(name: 'medicine_id')
  final int? medicineId;
  final String? medicine;
  final String dosage;
  @JsonKey(name: 'reminder_time')
  final String reminderTime;
  @JsonKey(name: 'is_taken')
  final bool? isTaken;

  Reminder({
    this.id,
    this.firebasePatientId,
    this.firebaseCaretakerId,
    this.medicineId,
    this.medicine,
    required this.dosage,
    required this.reminderTime,
    this.isTaken,
  });

  factory Reminder.fromJson(Map<String, dynamic> json) =>
      _$ReminderFromJson(json);
  Map<String, dynamic> toJson() => _$ReminderToJson(this);
}

// Create Reminder Request
@JsonSerializable()
class CreateReminderRequest {
  @JsonKey(name: 'firebase_patient_id')
  final String firebasePatientId;
  @JsonKey(name: 'firebase_caretaker_id')
  final String? firebaseCaretakerId;
  @JsonKey(name: 'medicine_id')
  final int medicineId;
  final String dosage;
  @JsonKey(name: 'reminder_time')
  final String reminderTime;

  CreateReminderRequest({
    required this.firebasePatientId,
    this.firebaseCaretakerId,
    required this.medicineId,
    required this.dosage,
    required this.reminderTime,
  });

  factory CreateReminderRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateReminderRequestFromJson(json);
  Map<String, dynamic> toJson() => _$CreateReminderRequestToJson(this);
}