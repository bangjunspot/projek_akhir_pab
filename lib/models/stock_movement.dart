class StockMovement {
  final String id;
  final String productId;
  final int qty;
  final String type; // 'in' or 'out'
  final String? note;
  final DateTime? createdAt;

  StockMovement({
    required this.id,
    required this.productId,
    required this.qty,
    required this.type,
    required this.note,
    required this.createdAt,
  });

  factory StockMovement.fromMap(Map<String, dynamic> map) {
    return StockMovement(
      id: map['id'].toString(),
      productId: map['product_id'].toString(),
      qty: (map['qty'] as num?)?.toInt() ?? 0,
      type: (map['type'] ?? 'in').toString(),
      note: map['note']?.toString(),
      createdAt: map['created_at'] != null
          ? DateTime.tryParse(map['created_at'].toString())
          : null,
    );
  }
}
