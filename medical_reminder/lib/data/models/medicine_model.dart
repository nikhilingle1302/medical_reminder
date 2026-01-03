import 'package:json_annotation/json_annotation.dart';

part 'medicine_model.g.dart';

// Medicine Model
@JsonSerializable()
class Medicine {
  @JsonKey(name: 'id')
  final int id;
  @JsonKey(name: 'name')
  final String name;
  @JsonKey(name: 'company')
  final String? company;
  @JsonKey(name: 'quantity')
  final int? stock;
  @JsonKey(name: 'expiry_date')
  final String? expiry;
  @JsonKey(name: 'category')
  final String? category;

  Medicine({
    required this.id,
    required this.name,
    this.company,
    this.stock,
    this.expiry,
    this.category,
  });

  factory Medicine.fromJson(Map<String, dynamic> json) =>
      _$MedicineFromJson(json);
  Map<String, dynamic> toJson() => _$MedicineToJson(this);
}

// Create Medicine Request
@JsonSerializable()
class CreateMedicineRequest {
  @JsonKey(name: 'name')
  final String name;
  @JsonKey(name: 'company')
  final String company;
  @JsonKey(name: 'stock')
  final int stock;
  @JsonKey(name: 'expiry')
  final String expiry;

  CreateMedicineRequest({
    required this.name,
    required this.company,
    required this.stock,
    required this.expiry,
  });

  factory CreateMedicineRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateMedicineRequestFromJson(json);
  Map<String, dynamic> toJson() => _$CreateMedicineRequestToJson(this);
}