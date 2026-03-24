// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reminder_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

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
