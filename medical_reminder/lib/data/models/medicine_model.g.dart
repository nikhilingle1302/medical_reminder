// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'medicine_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Medicine _$MedicineFromJson(Map<String, dynamic> json) => Medicine(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      company: json['company'] as String?,
      stock: (json['quantity'] as num?)?.toInt(),
      expiry: json['expiry_date'] as String?,
      category: json['category'] as String?,
    );

Map<String, dynamic> _$MedicineToJson(Medicine instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'company': instance.company,
      'quantity': instance.stock,
      'expiry_date': instance.expiry,
      'category': instance.category,
    };

CreateMedicineRequest _$CreateMedicineRequestFromJson(
        Map<String, dynamic> json) =>
    CreateMedicineRequest(
      name: json['name'] as String,
      company: json['company'] as String,
      stock: (json['stock'] as num).toInt(),
      expiry: json['expiry'] as String,
    );

Map<String, dynamic> _$CreateMedicineRequestToJson(
        CreateMedicineRequest instance) =>
    <String, dynamic>{
      'name': instance.name,
      'company': instance.company,
      'stock': instance.stock,
      'expiry': instance.expiry,
    };
