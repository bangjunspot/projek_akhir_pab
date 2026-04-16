class TransactionItem {
  final String id;
  final String transactionId;
  final String productId;
  final int qty;
  final double price;

  TransactionItem({
    required this.id,
    required this.transactionId,
    required this.productId,
    required this.qty,
    required this.price,
  });
}
