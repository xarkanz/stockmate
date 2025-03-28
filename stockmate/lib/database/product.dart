class Product {
  int? id;
  String name;
  String barcode;
  String? description;
  String? category;
  String? imagePath;
  String dateAdded;
  int quantity; // Tambahkan quantity

  Product({
    this.id,
    required this.name,
    required this.barcode,
    this.description,
    this.category,
    this.imagePath,
    required this.dateAdded,
    this.quantity = 0, // Default ke 0
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'barcode': barcode,
      'description': description,
      'category': category,
      'imagePath': imagePath,
      'dateAdded': dateAdded,
      'quantity': quantity,
    };
  }

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'],
      name: map['name'],
      barcode: map['barcode'],
      description: map['description'],
      category: map['category'],
      imagePath: map['imagePath'],
      dateAdded: map['dateAdded'],
      quantity: map['quantity'] ?? 0, // Pastikan quantity tidak null
    );
  }
}
