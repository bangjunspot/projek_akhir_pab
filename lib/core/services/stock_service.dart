import '../services/supabase_service.dart';
import '../../models/stock_movement.dart';

class StockService {
  final _supabase = SupabaseService();

  Future<List<StockMovement>> fetchMovements() async {
    final data = await _supabase.client
        .from('stock_movements')
        .select()
        .order('created_at', ascending: false);
    return (data as List)
        .map((item) => StockMovement.fromMap(item as Map<String, dynamic>))
        .toList();
  }

  Future<void> createMovement({
    required String productId,
    required int qty,
    required String type,
    String? note,
  }) async {
    await _supabase.client.from('stock_movements').insert({
      'product_id': productId,
      'qty': qty,
      'type': type,
      'note': note,
    });
  }
}
