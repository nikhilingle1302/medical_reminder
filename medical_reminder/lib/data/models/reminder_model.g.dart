// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reminder_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Reminder _$ReminderFromJson(Map<String, dynamic> json) => Reminder(
      id: (json['id'] as num).toInt(),
      firebasePatientId: json['firebase_patient_id'] as String,
      medicineName: json['medicine_name'] as String,
      medicineId: (json['medicine_id'] as num).toInt(),
      dosage: json['dosage'] as String,
      reminderTime: json['reminder_time'] as String,
      isTaken: json['is_taken'] as bool,
      isSent: json['is_sent'] as bool?,
    );

Map<String, dynamic> _$ReminderToJson(Reminder instance) => <String, dynamic>{
      'id': instance.id,
      'firebase_patient_id': instance.firebasePatientId,
      'medicine_name': instance.medicineName,
      'medicine_id': instance.medicineId,
      'dosage': instance.dosage,
      'reminder_time': instance.reminderTime,
      'is_taken': instance.isTaken,
      'is_sent': instance.isSent,
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
