import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../core/services/product_service.dart';
import '../../core/utils/emoji_filter.dart';
import '../../core/utils/input_validators.dart';
import '../../core/utils/currency_formatter.dart';
import '../../core/utils/rupiah_input_formatter.dart';
import '../../models/product.dart';
import '../../providers/product_provider.dart';
import '../../providers/stock_provider.dart';
import '../../theme/clay_colors.dart';
import '../../widgets/clay_button.dart';
import '../../widgets/clay_card.dart';
import '../../widgets/clay_input.dart';
import '../../widgets/clay_fade_slide.dart';
import '../../widgets/clay_fab.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({super.key});
  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  static const List<String> _categoryOptions = [
    'Aneka Ayam', 'Aneka Nasi Goreng', 'Aneka Indomie', 'Minuman', 'Lainnya',
  ];
  final ProductService _productService = ProductService();
  final _picker = ImagePicker();

  List<String> _orderedCategories(Iterable<String> keys) {
    final ordered = <String>[];
    for (final key in _categoryOptions) {
      if (keys.contains(key)) ordered.add(key);
    }
    final extras = keys.where((k) => !_categoryOptions.contains(k)).toList()..sort();
    ordered.addAll(extras);
    return ordered;
  }

  Map<String, List<Product>> _groupProducts(List<Product> items) {
    final map = <String, List<Product>>{};
    for (final product in items) {
      final raw = product.category?.trim();
      final key = (raw == null || raw.isEmpty) ? 'Lainnya' : raw;
      map.putIfAbsent(key, () => []).add(product);
    }
    for (final entry in map.entries) {
      entry.value.sort((a, b) => a.name.compareTo(b.name));
    }
    return map;
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProductProvider>().loadProducts(onlyActive: false);
      context.read<StockProvider>().loadMovements();
    });
  }

  void _showSnackBar(String message, {bool success = true}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(children: [
          Icon(
            success ? Icons.check_circle_rounded : Icons.error_rounded,
            color: Colors.white, size: 18,
          ),
          const SizedBox(width: 8),
          Expanded(child: Text(message)),
        ]),
        backgroundColor: success ? ClayColors.success : Colors.red.shade600,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  Future<void> _openProductForm({Product? product}) async {
    final nameController = TextEditingController(text: product?.name ?? '');
    final priceController = TextEditingController(
      text: product != null && product.price > 0
          ? RupiahInputFormatter.formatNumber(product.price.toInt())
          : '',
    );

    String selectedCategory = product?.category?.trim().isNotEmpty == true
        ? product!.category!.trim()
        : _categoryOptions.first;
    if (!_categoryOptions.contains(selectedCategory)) selectedCategory = 'Lainnya';

    bool isActive = product?.isActive ?? true;
    String? currentImageUrl = product?.imageUrl;

    // Image state — dikelola DALAM dialog via setStateDialog
    Uint8List? pickedBytes;
    String? pickedName;
    bool isUploading = false;

    final formKey = GlobalKey<FormState>();

    final result = await showDialog<bool>(
      context: context,
      builder: (dialogCtx) {
        return StatefulBuilder(builder: (dialogCtx, setStateDialog) {

          // ── Fungsi pick gambar di dalam StatefulBuilder ──────────────
          Future<void> pickImage() async {
            try {
              final picked = await _picker.pickImage(
                source: ImageSource.gallery,
                imageQuality: 75,
              );
              if (picked == null) return;
              final bytes = await picked.readAsBytes();
              final name =
                  '${DateTime.now().millisecondsSinceEpoch}_${picked.name}';
              setStateDialog(() {
                pickedBytes = bytes;
                pickedName = name;
              });
            } catch (e) {
              if (dialogCtx.mounted) {
                ScaffoldMessenger.of(dialogCtx).showSnackBar(SnackBar(
                  content: Text('Gagal memilih gambar: $e'),
                  backgroundColor: Colors.red,
                ));
              }
            }
          }

          // ── Preview gambar ──────────────────────────────────────────
          Widget imagePreview() {
            if (pickedBytes != null) {
              // Gambar baru yang baru dipilih
              return Stack(children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.memory(
                    pickedBytes!,
                    height: 120,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  top: 6, right: 6,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: ClayColors.success,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.check_circle_rounded,
                            color: Colors.white, size: 12),
                        SizedBox(width: 4),
                        Text('Terpilih',
                            style: TextStyle(
                                color: Colors.white, fontSize: 10)),
                      ],
                    ),
                  ),
                ),
              ]);
            }
            if (currentImageUrl != null && currentImageUrl!.isNotEmpty) {
              return Stack(children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    currentImageUrl!,
                    height: 120,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (c, e, s) => _emptyImagePlaceholder(),
                  ),
                ),
                Positioned(
                  bottom: 6, right: 6,
                  child: Container(
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: ClayColors.primary,
                      borderRadius: BorderRadius.circular(7),
                    ),
                    child: const Icon(Icons.edit_rounded,
                        color: Colors.white, size: 14),
                  ),
                ),
              ]);
            }
            return _emptyImagePlaceholder();
          }

          return AlertDialog(
            title: Text(product == null ? 'Tambah Produk' : 'Edit Produk'),
            // ── SizedBox(width: double.maxFinite) agar tidak melebar ──
            content: SizedBox(
              width: double.maxFinite,
              child: Form(
                key: formKey,
                child: SingleChildScrollView(
                  child: Column(mainAxisSize: MainAxisSize.min, children: [
                    // ── Gambar: klik area ATAU tombol upload ───────────
                    GestureDetector(
                      onTap: pickImage,
                      child: imagePreview(),
                    ),
                    const SizedBox(height: 6),
                    // Tombol upload eksplisit
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: isUploading ? null : pickImage,
                        icon: isUploading
                            ? const SizedBox(
                                width: 14, height: 14,
                                child: CircularProgressIndicator(
                                    strokeWidth: 2))
                            : const Icon(Icons.upload_rounded, size: 16),
                        label: Text(pickedBytes != null
                            ? 'Ganti Gambar'
                            : 'Upload Gambar'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: ClayColors.primary,
                          side: BorderSide(color: ClayColors.primary),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 8),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    ClayInput(
                      controller: nameController,
                      label: 'Nama Produk',
                      inputFormatters: [EmojiFilter.denyEmoji],
                      validator: (v) =>
                          InputValidators.requiredField(v, 'Nama produk'),
                    ),
                    const SizedBox(height: 10),
                    DropdownButtonFormField<String>(
                      value: selectedCategory,
                      decoration:
                          const InputDecoration(labelText: 'Kategori'),
                      items: _categoryOptions
                          .map((c) => DropdownMenuItem<String>(
                              value: c, child: Text(c)))
                          .toList(),
                      onChanged: (val) {
                        if (val != null) {
                          setStateDialog(() => selectedCategory = val);
                        }
                      },
                      validator: (v) =>
                          InputValidators.requiredField(v, 'Kategori'),
                    ),
                    const SizedBox(height: 10),
                    ClayInput(
                      controller: priceController,
                      label: 'Harga (Rp)',
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        EmojiFilter.denyEmoji,
                        RupiahInputFormatter(),
                      ],
                      validator: (v) {
                        final raw =
                            v?.replaceAll(RegExp(r'[^\d]'), '') ?? '';
                        if (raw.isEmpty) return 'Harga wajib diisi';
                        final val = double.tryParse(raw);
                        if (val == null || val <= 0) {
                          return 'Harga harus lebih dari 0';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 8),
                    Row(children: [
                      const Text('Aktif'),
                      Switch(
                        value: isActive,
                        activeColor: ClayColors.success,
                        onChanged: (val) =>
                            setStateDialog(() => isActive = val),
                      ),
                    ]),
                  ]),
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogCtx, false),
                child: const Text('Batal'),
              ),
              ClayButton(
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    Navigator.pop(dialogCtx, true);
                  }
                },
                label: 'Simpan',
              ),
            ],
          );
        });
      },
    );

    if (result != true) return;
    if (!mounted) return;

    // Capture provider sebelum async gap
    final provider = context.read<ProductProvider>();

    final rawPrice = priceController.text.replaceAll(RegExp(r'[^\d]'), '');
    final price = double.tryParse(rawPrice) ?? 0;

    // Upload gambar ke Supabase jika ada gambar baru
    String? finalImageUrl = currentImageUrl;
    if (pickedBytes != null && pickedName != null) {
      final uploaded =
          await _productService.uploadProductImage(pickedBytes!, pickedName!);
      if (uploaded != null) {
        finalImageUrl = uploaded;
      } else {
        if (mounted) {
          _showSnackBar(
              'Gambar gagal diupload ke server, produk disimpan tanpa gambar.',
              success: false);
        }
      }
    }

    if (!mounted) return;

    final newProduct = Product(
      id: product?.id ?? '',
      name: nameController.text.trim(),
      category: selectedCategory.trim().isEmpty
          ? 'Lainnya'
          : selectedCategory.trim(),
      price: price,
      imageUrl: finalImageUrl,
      isActive: isActive,
      createdAt: product?.createdAt,
    );

    try {
      if (product == null) {
        await provider.addProduct(newProduct);
        _showSnackBar('Menu berhasil ditambahkan');
      } else {
        await provider.updateProduct(newProduct);
        _showSnackBar('Menu berhasil diperbarui');
      }
    } catch (e) {
      if (!mounted) return;
      _showSnackBar(
        product == null
            ? 'Gagal menambahkan menu: $e'
            : 'Gagal memperbarui menu: $e',
        success: false,
      );
    }
  }

  /// Toggle aktif/nonaktif — hanya bisa aktif jika ada stok
  Future<void> _toggleActive(
      Product product, bool newValue, Map<String, int> stockMap) async {
    final stock = stockMap[product.id] ?? 0;

    if (newValue && stock <= 0) {
      _showSnackBar(
        'Tidak bisa diaktifkan — stok "${product.name}" masih habis. '
        'Tambah stok di halaman Stok terlebih dahulu.',
        success: false,
      );
      return;
    }

    final updated = Product(
      id: product.id, name: product.name, category: product.category,
      price: product.price, imageUrl: product.imageUrl,
      isActive: newValue, createdAt: product.createdAt,
    );
    try {
      await context.read<ProductProvider>().updateProduct(updated);
      if (!mounted) return;
      _showSnackBar(newValue
          ? '"${product.name}" diaktifkan'
          : '"${product.name}" dinonaktifkan');
    } catch (e) {
      if (!mounted) return;
      _showSnackBar('Gagal mengubah status: $e', success: false);
    }
  }

  Future<void> _deleteProduct(Product product) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
                color: Colors.red.withAlpha(25),
                borderRadius: BorderRadius.circular(10)),
            child: Icon(Icons.delete_rounded,
                color: Colors.red.shade400, size: 18),
          ),
          const SizedBox(width: 10),
          const Text('Hapus Menu'),
        ]),
        content: RichText(
          text: TextSpan(
            style: DefaultTextStyle.of(ctx).style,
            children: [
              const TextSpan(text: 'Hapus menu '),
              TextSpan(text: product.name,
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              const TextSpan(text: '?\n\nAksi ini tidak bisa dibatalkan.'),
            ],
          ),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Batal')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade400,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;
    try {
      await context.read<ProductProvider>().deleteProduct(product.id);
      _showSnackBar('Menu "${product.name}" berhasil dihapus');
    } catch (e) {
      if (!mounted) return;
      _showSnackBar('Gagal hapus menu: $e', success: false);
    }
  }

  Widget _emptyImagePlaceholder() {
    return Container(
      height: 120,
      width: double.infinity,
      decoration: BoxDecoration(
        color: ClayColors.surfaceAlt,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: ClayColors.textMuted.withAlpha(50),
          style: BorderStyle.solid,
        ),
      ),
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Icon(Icons.add_photo_alternate_rounded,
            size: 32, color: ClayColors.textMuted),
        const SizedBox(height: 6),
        Text('Ketuk atau klik tombol di bawah',
            style: TextStyle(fontSize: 11, color: ClayColors.textMuted)),
        Text('untuk upload gambar menu',
            style: TextStyle(fontSize: 11, color: ClayColors.textMuted)),
      ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ProductProvider>();
    final stockProvider = context.watch<StockProvider>();
    final stockMap = stockProvider.stockMap;

    if (provider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (provider.error != null) {
      return Center(child: Text('Gagal memuat produk: ${provider.error}'));
    }

    final products = provider.products;
    final grouped = _groupProducts(products);
    final categories = _orderedCategories(grouped.keys);

    return Scaffold(
      floatingActionButton: ClayFab(
          icon: Icons.add, onPressed: () => _openProductForm()),
      body: products.isEmpty
          ? const Center(child: Text('Belum ada produk.'))
          : ListView(
              padding: const EdgeInsets.only(bottom: 20),
              children: () {
                final widgets = <Widget>[];
                var itemIndex = 0;
                for (final category in categories) {
                  final items = grouped[category] ?? [];
                  if (items.isEmpty) continue;
                  widgets.add(Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                    child: Text(category,
                        style: Theme.of(context).textTheme.titleLarge),
                  ));
                  widgets.addAll(items.map((product) {
                    final idx = itemIndex++;
                    final stock = stockMap[product.id] ?? 0;
                    final stockEmpty = stock <= 0;
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 6),
                      child: ClayFadeSlide(
                        index: idx,
                        child: ClayCard(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 10),
                          child: Row(children: [
                            // Thumbnail dihilangkan agar tampilan lebih ringkas
                            Expanded(
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(product.name,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w600),
                                        overflow: TextOverflow.ellipsis),
                                    const SizedBox(height: 2),
                                    Text(formatRupiah(product.price),
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: ClayColors.primary)),
                                    const SizedBox(height: 4),
                                    Wrap(spacing: 4, runSpacing: 4, children: [
                                      _StatusBadge(
                                        label: stockEmpty
                                            ? 'Stok Habis'
                                            : 'Stok: $stock',
                                        color: stockEmpty
                                            ? Colors.red
                                            : ClayColors.success,
                                      ),
                                      if (!product.isActive)
                                        const _StatusBadge(
                                            label: 'Nonaktif',
                                            color: Colors.grey),
                                    ]),
                                  ]),
                            ),
                            // Toggle: disabled jika stok habis (auto-manage)
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Tooltip(
                                  message: stockEmpty && !product.isActive
                                      ? 'Tambah stok dulu untuk mengaktifkan'
                                      : product.isActive
                                          ? 'Klik untuk nonaktifkan'
                                          : 'Klik untuk aktifkan',
                                  child: Transform.scale(
                                    scale: 0.8,
                                    child: Switch(
                                      value: product.isActive,
                                      // Jika stok habis dan sedang nonaktif, toggle dikunci
                                      onChanged: (stockEmpty && !product.isActive)
                                          ? null
                                          : (val) => _toggleActive(
                                              product, val, stockMap),
                                      activeColor: ClayColors.success,
                                      materialTapTargetSize:
                                          MaterialTapTargetSize.shrinkWrap,
                                    ),
                                  ),
                                ),
                                Text(
                                  product.isActive ? 'Aktif' : 'Nonaktif',
                                  style: TextStyle(
                                    fontSize: 9,
                                    color: product.isActive
                                        ? ClayColors.success
                                        : Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                            IconButton(
                              icon: const Icon(Icons.edit, size: 20),
                              onPressed: () => _openProductForm(product: product),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, size: 20),
                              color: Colors.red.shade300,
                              onPressed: () => _deleteProduct(product),
                            ),
                          ]),
                        ),
                      ),
                    );
                  }));
                }
                return widgets;
              }(),
            ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final String label;
  final Color color;
  const _StatusBadge({required this.label, required this.color});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
          color: color.withAlpha(28), borderRadius: BorderRadius.circular(6)),
      child: Text(label,
          style: TextStyle(
              fontSize: 10, color: color, fontWeight: FontWeight.w600)),
    );
  }
}
