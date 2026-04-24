import 'package:flutter/material.dart';
import 'package:marketplace/core/constants/app_colors.dart';
import 'package:marketplace/core/routes/app_router.dart';
import 'package:marketplace/features/auth/presentation/providers/auth_provider.dart';
import 'package:marketplace/features/cart/domain/entities/cart_item.dart';
import 'package:marketplace/features/cart/presentation/providers/cart_provider.dart';
import 'package:marketplace/features/dashboard/data/models/product_model.dart';
import 'package:marketplace/features/dashboard/presentation/providers/product_provider.dart';
import 'package:marketplace/features/dashboard/presentation/pages/product_detail_page.dart';
import 'package:provider/provider.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProductProvider>().fetchProducts();
    });
  }

  String _formatPrice(double price) {
    return price
        .toStringAsFixed(0)
        .replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (m) => '${m[1]}.',
        );
  }

  void _addToCart(BuildContext context, ProductModel p) {
    final cart = context.read<CartProvider>();
    cart.addItem(CartItem(
      id: p.id,
      name: p.name,
      price: p.price,
      quantity: 1,
    ));

    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${p.name} ditambahkan ke keranjang'),
        backgroundColor: AppColors.primary,
        duration: const Duration(milliseconds: 1000), // Hilang lebih cepat
        action: SnackBarAction(
          label: 'Lihat Cart',
          textColor: Colors.white,
          onPressed: () =>
              Navigator.pushNamed(context, AppRouter.cart),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final product = context.watch<ProductProvider>();
    final cartCount = context.watch<CartProvider>().itemCount;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Nike Store',
                style:
                    TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text(
              'Halo, ${auth.firebaseUser?.displayName ?? 'User'}! 👋',
              style: const TextStyle(
                  fontSize: 13, fontWeight: FontWeight.normal),
            ),
          ],
        ),
        actions: [
          // ── Cart Icon dengan Badge ──────────────────────
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart_outlined),
                tooltip: 'Keranjang',
                onPressed: () =>
                    Navigator.pushNamed(context, AppRouter.cart),
              ),
              if (cartCount > 0)
                Positioned(
                  right: 6,
                  top: 6,
                  child: Container(
                    width: 18,
                    height: 18,
                    decoration: const BoxDecoration(
                      color: AppColors.error, // Merah untuk alert/badge
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      cartCount > 99 ? '99+' : '$cartCount',
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
            ],
          ),

          // ── Logout ─────────────────────────────────────
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Keluar',
            onPressed: () async {
              final navigator = Navigator.of(context);
              await auth.logout();
              navigator.pushReplacementNamed(AppRouter.login);
            },
          ),
        ],
      ),

      body: switch (product.status) {
        // ── Loading ───────────────────────────────────────
        ProductStatus.loading || ProductStatus.initial => const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(color: AppColors.primary),
                SizedBox(height: 16),
                Text('Memuat produk...',
                    style: TextStyle(color: AppColors.textSecondary)),
              ],
            ),
          ),

        // ── Error ─────────────────────────────────────────
        ProductStatus.error => Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: Colors.red.shade50,
                      shape: BoxShape.circle,
                    ),
                    child:
                        const Icon(Icons.wifi_off, size: 40, color: Colors.red),
                  ),
                  const SizedBox(height: 16),
                  const Text('Gagal Memuat Produk',
                      style: TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text(product.error ?? 'Terjadi kesalahan',
                      textAlign: TextAlign.center,
                      style:
                          const TextStyle(color: AppColors.textSecondary)),
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.refresh),
                    label: const Text('Coba Lagi'),
                    onPressed: () => product.fetchProducts(),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white),
                  ),
                ],
              ),
            ),
          ),

        // ── Loaded ───────────────────────────────────────
        ProductStatus.loaded => RefreshIndicator(
            onRefresh: () => product.fetchProducts(),
            color: AppColors.primary,
            child: CustomScrollView(
              // Fix scroll: ClampingScrollPhysics mencegah overscroll/bouncing
              physics: const ClampingScrollPhysics(),
              slivers: [
                // ── Search Bar & Category Header ──────────
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Search bar (dekoratif)
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 8,
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.search,
                                  color: AppColors.textHint),
                              const SizedBox(width: 8),
                              Text('Cari produk...',
                                  style: TextStyle(
                                      color: Colors.grey.shade400,
                                      fontSize: 14)),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Semua Produk (${product.products.length})',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // ── Product Grid ──────────────────────────
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                  sliver: SliverGrid(
                    delegate: SliverChildBuilderDelegate(
                      (context, i) {
                        final p = product.products[i];
                        return _ProductCard(
                          product: p,
                          formatPrice: _formatPrice,
                          onAddToCart: () => _addToCart(context, p),
                        );
                      },
                      childCount: product.products.length,
                    ),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.6, // Diubah dari 0.72 ke 0.6 agar tidak overflow (card lebih tinggi)
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),
      },
    );
  }
}

// ─── Product Card ────────────────────────────────────────────────────────────

class _ProductCard extends StatelessWidget {
  final ProductModel product;
  final String Function(double) formatPrice;
  final VoidCallback onAddToCart;

  const _ProductCard({
    required this.product,
    required this.formatPrice,
    required this.onAddToCart,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ProductDetailPage(product: product),
          ),
        );
      },
      borderRadius: BorderRadius.circular(14),
      child: Card(
        elevation: 2,
        shadowColor: Colors.black12,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          // ── Gambar produk ─────────────────────────────
          ClipRRect(
            borderRadius:
                const BorderRadius.vertical(top: Radius.circular(14)),
            child: Hero(
              tag: 'product_image_${product.id}',
              child: product.imageUrl.isNotEmpty
                  ? Image.network(
                      product.imageUrl,
                      height: 140, // Height sedikit dibesarkan
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (_, e, s) => _placeholderImage(),
                    )
                  : _placeholderImage(),
            ),
          ),

          // ── Info & Tombol ─────────────────────────────
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 3),
                      Text(
                        'Rp ${formatPrice(product.price)}',
                        style: const TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w700,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          product.category,
                          style: const TextStyle(
                            fontSize: 10,
                            color: AppColors.primary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),

                  // ── Add to Cart Button ──────────────────
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: onAddToCart,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        padding:
                            const EdgeInsets.symmetric(vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: 0,
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.add_shopping_cart, size: 14),
                          SizedBox(width: 4),
                          Text('Tambah',
                              style: TextStyle(fontSize: 12)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      ),
    );
  }

  Widget _placeholderImage() => Container(
        height: 140,
        width: double.infinity,
        color: AppColors.primary.withOpacity(0.08),
        child:
            const Icon(Icons.image_not_supported, size: 36, color: AppColors.primary),
      );
}