import 'package:json_annotation/json_annotation.dart';

part 'reminder_model.g.dart';

@JsonSerializable()
class Reminder {
  @JsonKey(name: 'id')
  final int id;
  
  @JsonKey(name: 'firebase_patient_id')
  final String firebasePatientId;
  
  @JsonKey(name: 'medicine_name')  // Changed to match API
  final String medicineName;        // Changed field name
  
  @JsonKey(name: 'medicine_id')
  final int medicineId;
  
  @JsonKey(name: 'dosage')
  final String dosage;
  
  @JsonKey(name: 'reminder_time')
  final String reminderTime;
  
  @JsonKey(name: 'is_taken')
  final bool isTaken;
  
  @JsonKey(name: 'is_sent')  // Add this if you need it
  final bool? isSent;

  Reminder({
    required this.id,
    required this.firebasePatientId,
    required this.medicineName,
    required this.medicineId,
    required this.dosage,
    required this.reminderTime,
    required this.isTaken,
     this.isSent,
  });

  factory Reminder.fromJson(Map<String, dynamic> json) =>
      _$ReminderFromJson(json);
  Map<String, dynamic> toJson() => _$ReminderToJson(this);
}


class ReminderResponse {
  final List<Reminder> reminders;
  
  ReminderResponse({required this.reminders});
  
  factory ReminderResponse.fromJson(Map<String, dynamic> json) {
    return ReminderResponse(
      reminders: (json['reminders'] as List)
          .map((item) => Reminder.fromJson(item))
          .toList(),
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