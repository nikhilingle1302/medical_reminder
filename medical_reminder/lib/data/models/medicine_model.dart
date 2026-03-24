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
  @JsonKey(name: 'description')
  final String? description;
  @JsonKey(name: '"requires_prescription"')
  final bool? requiresPrescription;

  Medicine({
    required this.id,
    required this.name,
    this.company,
    this.stock,
    this.expiry,
    this.category,
    this.requiresPrescription,
    this.description,
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

  @JsonKey(name: 'category')
  final String category;

  @JsonKey(name: 'quantity')
  final int quantity;

  @JsonKey(name: 'expiry_date')
  final String expiryDate;

  @JsonKey(name: 'price')
  final int price;

  CreateMedicineRequest({
    required this.name,
    required this.company,
    required this.category,
    required this.quantity,
    required this.expiryDate,
    required this.price,
  });

  factory CreateMedicineRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateMedicineRequestFromJson(json);

  Map<String, dynamic> toJson() =>
      _$CreateMedicineRequestToJson(this);
}
