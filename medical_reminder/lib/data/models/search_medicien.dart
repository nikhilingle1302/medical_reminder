class SearchMedicineModel {
  final int medicineId;
  final String medicine;
  final String description;
  final bool requiresPrescription;
  final List<StoreModel> availableStores;

  SearchMedicineModel({
    required this.medicineId,
    required this.medicine,
    required this.description,
    required this.requiresPrescription,
    required this.availableStores,
  });

  factory SearchMedicineModel.fromJson(Map<String, dynamic> json) {
    return SearchMedicineModel(
      medicineId: json['medicine_id'],
      medicine: json['medicine'],
      description: json['description'] ?? '',
      requiresPrescription: json['requires_prescription'] ?? false,
      // ✅ API returns 'stores' not 'available_stores'
      availableStores: (json['stores'] as List)
          .map((e) => StoreModel.fromJson(e))
          .toList(),
    );
  }
}

class StoreModel {
  final int id;
  final String storeName;
  final double price;
  final int stock;

  StoreModel({
    required this.id,
    required this.storeName,
    required this.price,
    required this.stock,
  });

  factory StoreModel.fromJson(Map<String, dynamic> json) {
    return StoreModel(
      // ✅ API returns 'store_id' not 'id'
      id: json['store_id'],
      storeName: json['store_name'],
      // ✅ API returns price as double (84.0)
      price: (json['price'] as num).toDouble(),
      stock: json['stock'],
    );
  }
}

class SearchResultItem {
  final int medicineId;      // ✅ back
  final String medicine;
  final int storeId;         // ✅ back
  final String store;
  final double price;
  final int stock;

  SearchResultItem({
    required this.medicineId,
    required this.medicine,
    required this.storeId,
    required this.store,
    required this.price,
    required this.stock,
  });

  factory SearchResultItem.fromJson(Map<String, dynamic> json) {
    return SearchResultItem(
      medicineId: json['medicine_id'],
      medicine: json['medicine'],
      storeId: json['store_id'],
      store: json['store'],
      price: (json['price'] as num).toDouble(),
      stock: json['stock'],
    );
  }
}

class SellerStoreModel {
  final int id;
  final String storeName;
  final String address;
  final String user;

  SellerStoreModel({
    required this.id,
    required this.storeName,
    required this.address,
    required this.user,
  });

  factory SellerStoreModel.fromJson(Map<String, dynamic> json) {
    return SellerStoreModel(
      id: json['id'],                    // ✅ 'id' not 'store_id'
      storeName: json['store_name'],
      address: json['address'] ?? '',
      user: json['user'] ?? '',
    );
  }
}