import '../services/supabase_service.dart';
import '../../models/product.dart';

class ProductService {
  final _supabase = SupabaseService();

  Future<List<Product>> fetchProducts({bool onlyActive = true}) async {
    var query = _supabase.client.from('products').select();
    if (onlyActive) {
      query = query.eq('is_active', true);
    }
    final data = await query.order('name');
    return (data as List)
        .map((item) => Product.fromMap(item as Map<String, dynamic>))
        .toList();
  }

  Future<void> createProduct(Product product) async {
    await _supabase.client.from('products').insert(product.toInsert());
  }

  Future<void> updateProduct(Product product) async {
    await _supabase.client
        .from('products')
        .update(product.toUpdate())
        .eq('id', product.id);
  }

  Future<void> deleteProduct(String id) async {
    await _supabase.client.from('products').delete().eq('id', id);
  }
}
