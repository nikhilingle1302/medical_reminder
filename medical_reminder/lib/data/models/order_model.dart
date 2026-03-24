class OrderModel {
  final int id;
  final int patient;
  final String patientName;
  final int store;
  final String storeName;
  final int medicine;
  final String medicineName;
  final int quantity;
  final String? prescription;
  final String status;
  final String createdAt;

  OrderModel({
    required this.id,
    required this.patient,
    required this.patientName,
    required this.store,
    required this.storeName,
    required this.medicine,
    required this.medicineName,
    required this.quantity,
    this.prescription,
    required this.status,
    required this.createdAt,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'],
      patient: json['patient'],
      patientName: json['patient_name'],
      store: json['store'],
      storeName: json['store_name'],
      medicine: json['medicine'],
      medicineName: json['medicine_name'],
      quantity: json['quantity'],
      prescription: json['prescription'],
      status: json['status'],
      createdAt: json['created_at'],
    );
  }
}