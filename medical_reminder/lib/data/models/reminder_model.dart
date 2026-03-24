import 'package:json_annotation/json_annotation.dart';

part 'reminder_model.g.dart';

// @JsonSerializable()
// class Reminder {
//   @JsonKey(name: 'id')
//   final int id;
  
//   @JsonKey(name: 'firebase_patient_id')
//   final String firebasePatientId;
  
//   @JsonKey(name: 'medicine_name')  // Changed to match API
//   final String medicineName;        // Changed field name
  
//   @JsonKey(name: 'medicine_id')
//   final int medicineId;
  
//   @JsonKey(name: 'dosage')
//   final String dosage;
  
//   @JsonKey(name: 'reminder_time')
//   final String reminderTime;
  
//   @JsonKey(name: 'is_taken')
//   final bool isTaken;
  
//   @JsonKey(name: 'is_sent')  // Add this if you need it
//   final bool? isSent;

//   Reminder({
//     required this.id,
//     required this.firebasePatientId,
//     required this.medicineName,
//     required this.medicineId,
//     required this.dosage,
//     required this.reminderTime,
//     required this.isTaken,
//      this.isSent,
//   });

//   factory Reminder.fromJson(Map<String, dynamic> json) =>
//       _$ReminderFromJson(json);
//   Map<String, dynamic> toJson() => _$ReminderToJson(this);
// }
class Reminder {
  final int id;
  final int user;
  final String userName;
  final int medicine;
  final String medicineName;
  final String reminderTime;   // "08:00" format
  final int frequencyPerDay;
  final String startDate;
  final String? endDate;
  final String createdAt;

  Reminder({
    required this.id,
    required this.user,
    required this.userName,
    required this.medicine,
    required this.medicineName,
    required this.reminderTime,
    required this.frequencyPerDay,
    required this.startDate,
    this.endDate,
    required this.createdAt,
  });

  factory Reminder.fromJson(Map<String, dynamic> json) {
    return Reminder(
      id: json['id'],
      user: json['user'],
      userName: json['user_name'],
      medicine: json['medicine'],
      medicineName: json['medicine_name'],
      reminderTime: json['reminder_time'],   // "08:00"
      frequencyPerDay: json['frequency_per_day'],
      startDate: json['start_date'],
      endDate: json['end_date'],
      createdAt: json['created_at'],
    );
  }
}


class ReminderResponse {
  final List<Reminder> reminders;
  ReminderResponse({required this.reminders});

  factory ReminderResponse.fromJson(List<dynamic> json) {
    return ReminderResponse(
      reminders: json.map((e) => Reminder.fromJson(e)).toList(),
    );
  }
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