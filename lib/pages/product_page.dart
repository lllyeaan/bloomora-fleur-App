import 'package:flutter/material.dart';
import '../pages/login_page.dart';
import '../models/product_model.dart';
import '../services/product_service.dart';
import 'submit_page.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({super.key});

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  final ProductService productService = ProductService();

  final nameController = TextEditingController();
  final priceController = TextEditingController();
  final descriptionController = TextEditingController();
  final searchController = TextEditingController();

  List<ProductModel> products = [];
  bool isLoading = true;
  String searchQuery = '';

  static const Color accentPink = Color(0xFFD94F8C);
  static const Color accentPinkSoft = Color(0xFFF7CFE1);
  static const Color accentPinkLight = Color(0xFFFFF1F6);
  static const Color darkText = Color(0xFF2B2B2B);
  static const Color softText = Color(0xFF7A6F76);
  static const Color background = Color(0xFFFFF8FB);
  static const Color inputFill = Color(0xFFFFFCFD);

  final List<ProductModel> BouquetSamples = [
    ProductModel(
      name: 'Topper Bouquet',
      price: 45000,
      description:
          'Buket bunga dengan topper custom, cocok untuk hadiah wisuda, ulang tahun, atau ucapan spesial.',
    ),
    ProductModel(
      name: 'Bouquet Bias/Foto',
      price: 75000,
      description:
          'Buket bunga dengan tambahan foto atau bias pilihan, cocok untuk hadiah personal dan unik.',
    ),
    ProductModel(
      name: 'Pipe Flower Bouquet',
      price: 65000,
      description:
          'Buket pipe flower handmade dengan warna ceria dan tampilan lucu untuk hadiah istimewa.',
    ),
    ProductModel(
      name: 'Single Rose',
      price: 25000,
      description:
          'Buket satu tangkai mawar dengan wrapping cantik, simpel, elegan, dan tetap berkesan.',
    ),
    ProductModel(
      name: 'Artificial Bouquet Rose',
      price: 55000,
      description:
          'Buket mawar artificial yang tahan lama dengan kombinasi warna lembut dan wrapping premium.',
    ),
    ProductModel(
      name: 'Money Bouquet',
      price: 125000,
      description:
          'Buket uang custom dengan dekorasi bunga cantik, cocok untuk hadiah ulang tahun atau wisuda.',
    ),
    ProductModel(
      name: 'Blooms Bouquet',
      price: 85000,
      description:
          'Buket bunga pilihan dengan rangkaian manis dan elegan untuk berbagai momen spesial.',
    ),
    ProductModel(
      name: 'Cherry Blossom Bouquet',
      price: 90000,
      description:
          'Buket bernuansa cherry blossom dengan tampilan soft, feminin, dan romantis.',
    ),
    ProductModel(
      name: 'Blooms Box',
      price: 110000,
      description:
          'Rangkaian bunga dalam box eksklusif yang cocok untuk hadiah ulang tahun atau anniversary.',
    ),
    ProductModel(
      name: 'Cherry Blossom Box',
      price: 120000,
      description:
          'Flower box bertema cherry blossom dengan nuansa pink lembut dan tampilan premium.',
    ),
    ProductModel(
      name: 'Custom Bloom',
      price: 150000,
      description:
          'Buket bunga custom sesuai permintaan warna, tema, dan kebutuhan acara pelanggan.',
    ),
    ProductModel(
      name: 'DIY Flower Class',
      price: 75000,
      description:
          'Paket kelas merangkai bunga sederhana untuk pengalaman kreatif bersama Bloomora Fleur.',
    ),
  ];

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  @override
  void dispose() {
    nameController.dispose();
    priceController.dispose();
    descriptionController.dispose();
    searchController.dispose();
    super.dispose();
  }

  List<ProductModel> get filteredProducts {
    if (searchQuery.trim().isEmpty) {
      return products;
    }

    final query = searchQuery.toLowerCase();

    return products.where((product) {
      final name = product.name.toLowerCase();
      final description = product.description.toLowerCase();

      return name.contains(query) || description.contains(query);
    }).toList();
  }

  Future<void> fetchProducts() async {
    setState(() {
      isLoading = true;
    });

    try {
      final result = await productService.getProducts();

      if (!mounted) return;

      setState(() {
        products = result;
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isLoading = false;
      });

      showMessage('Gagal mengambil produk: $e');
    }
  }

  Future<void> addProduct() async {
    final name = nameController.text.trim();
    final priceText = priceController.text.trim();
    final description = descriptionController.text.trim();

    if (name.isEmpty || priceText.isEmpty || description.isEmpty) {
      showMessage('Semua wajib diisi.');
      return;
    }

    final price = int.tryParse(priceText);

    if (price == null) {
      showMessage('Harga harus berupa angka.');
      return;
    }

    final product = ProductModel(
      name: name,
      price: price,
      description: description,
    );

    try {
      final success = await productService.addProduct(product);

      if (!mounted) return;

      if (success) {
        nameController.clear();
        priceController.clear();
        descriptionController.clear();

        await fetchProducts();

        showMessage('Produk berhasil disimpan sebagai draft.');
      } else {
        showMessage('Gagal menyimpan produk.');
      }
    } catch (e) {
      showMessage('Gagal menyimpan produk: $e');
    }
  }

  Future<void> deleteProduct(ProductModel product) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
          ),
          title: const Text(
            'Hapus Produk?',
            style: TextStyle(fontWeight: FontWeight.w800, color: darkText),
          ),
          content: Text(
            'Produk "${product.name}" akan dihapus dari katalog.',
            style: const TextStyle(color: softText, height: 1.4),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: const Text('Batal', style: TextStyle(color: softText)),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              style: ElevatedButton.styleFrom(
                elevation: 0,
                backgroundColor: Colors.redAccent,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: const Text('Hapus'),
            ),
          ],
        );
      },
    );

    if (confirm != true) return;

    try {
      final success = await productService.deleteProduct(product.id);

      if (!mounted) return;

      if (success) {
        await fetchProducts();
        showMessage('Produk berhasil dihapus.');
      } else {
        showMessage('Gagal menghapus produk.');
      }
    } catch (e) {
      showMessage('Terjadi kesalahan: $e');
    }
  }

  void fillSample(ProductModel product) {
    nameController.text = product.name;
    priceController.text = product.price.toStringAsFixed(0);
    descriptionController.text = product.description;
    showAddProductSheet();
  }

  void showMessage(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        backgroundColor: darkText,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
    );
  }

  InputDecoration inputDecoration({
    required String label,
    required String hint,
  }) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      filled: true,
      fillColor: inputFill,
      labelStyle: const TextStyle(color: softText),
      hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
      contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: BorderSide(color: Colors.grey.shade200),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: const BorderSide(color: accentPinkSoft),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: const BorderSide(color: accentPink, width: 1.5),
      ),
    );
  }

  void showAddProductSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (bottomSheetContext) {
        return SafeArea(
          child: Padding(
            padding: EdgeInsets.only(
              left: 16,
              right: 16,
              bottom: MediaQuery.of(bottomSheetContext).viewInsets.bottom + 16,
            ),
            child: Container(
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: accentPink.withOpacity(0.12),
                    blurRadius: 28,
                    offset: const Offset(0, 12),
                  ),
                ],
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: 46,
                        height: 5,
                        decoration: BoxDecoration(
                          color: accentPinkSoft,
                          borderRadius: BorderRadius.circular(99),
                        ),
                      ),
                    ),

                    const SizedBox(height: 22),

                    Row(
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: accentPinkLight,
                            borderRadius: BorderRadius.circular(17),
                            border: Border.all(color: accentPinkSoft),
                          ),
                          child: const Icon(
                            Icons.add_shopping_cart_rounded,
                            color: accentPink,
                            size: 23,
                          ),
                        ),
                        const SizedBox(width: 14),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Tambah Buket Baru',
                                style: TextStyle(
                                  fontSize: 21,
                                  fontWeight: FontWeight.w800,
                                  color: darkText,
                                  letterSpacing: -0.3,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'Isi detail buket bunga',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: softText,
                                  height: 1.4,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    TextField(
                      controller: nameController,
                      style: const TextStyle(fontSize: 15, color: darkText),
                      decoration: inputDecoration(
                        label: 'Nama Produk',
                        hint: 'Contoh: Pipe flower bouquet',
                      ),
                    ),

                    const SizedBox(height: 14),

                    TextField(
                      controller: priceController,
                      keyboardType: TextInputType.number,
                      style: const TextStyle(fontSize: 15, color: darkText),
                      decoration: inputDecoration(
                        label: 'Harga',
                        hint: 'Contoh: 50000',
                      ),
                    ),

                    const SizedBox(height: 14),

                    TextField(
                      controller: descriptionController,
                      maxLines: 3,
                      style: const TextStyle(fontSize: 15, color: darkText),
                      decoration: inputDecoration(
                        label: 'Deskripsi Produk',
                        hint: 'Tulis deskripsi singkat produk',
                      ),
                    ),

                    const SizedBox(height: 22),

                    SizedBox(
                      width: double.infinity,
                      height: 54,
                      child: ElevatedButton(
                        onPressed: () async {
                          final name = nameController.text.trim();
                          final price = priceController.text.trim();
                          final description = descriptionController.text.trim();

                          if (name.isEmpty ||
                              price.isEmpty ||
                              description.isEmpty) {
                            showMessage('Semua data produk wajib diisi.');
                            return;
                          }

                          Navigator.pop(bottomSheetContext);
                          await addProduct();
                        },
                        style: ElevatedButton.styleFrom(
                          elevation: 0,
                          backgroundColor: accentPink,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                        ),
                        child: const Text(
                          'Simpan Buket',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget buildHeader() {
    return Padding(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 14,
        left: 22,
        right: 22,
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: IconButton(
                  padding: EdgeInsets.zero,
                  icon: const Icon(
                    Icons.arrow_back_ios_new_rounded,
                    size: 18,
                    color: darkText,
                  ),
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => const LoginPage()),
                    );
                  },
                ),
              ),

              const Expanded(
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Bloomora Fleur',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w900,
                          color: darkText,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'Fresh & Artificial Flower Bouquet Catalog',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: softText,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: accentPinkLight,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: accentPinkSoft),
                ),
                child: IconButton(
                  padding: EdgeInsets.zero,
                  icon: const Icon(Icons.shopping_bag_outlined, color: accentPink),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const SubmitPage()),
                    );
                  },
                ),
              ),
            ],
          ),

          const SizedBox(height: 22),

          Row(
            children: [
              Expanded(
                child: Container(
                  height: 52,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: TextField(
                    controller: searchController,
                    onChanged: (value) {
                      setState(() {
                        searchQuery = value;
                      });
                    },
                    decoration: const InputDecoration(
                      hintText: 'Search bouquet',
                      hintStyle: TextStyle(fontSize: 14, color: softText),
                      prefixIcon: Icon(Icons.search_rounded, color: softText),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(vertical: 15),
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 12),

              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: IconButton(
                  icon: const Icon(Icons.refresh_rounded, color: darkText),
                  onPressed: fetchProducts,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildSampleProducts() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(22, 24, 0, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(right: 22),
              child: Row(
                children: [
                  Text(
                    'Best Seller Bouquets',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w900,
                      color: darkText,
                    ),
                  ),
                  Spacer(),
                  Text(
                    'Tap to use',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: softText,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 14),

            SizedBox(
              height: 152,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: BouquetSamples.length,
                separatorBuilder: (context, index) {
                  return const SizedBox(width: 12);
                },
                itemBuilder: (context, index) {
                  final product = BouquetSamples[index];

                  return InkWell(
                    borderRadius: BorderRadius.circular(24),
                    onTap: () {
                      fillSample(product);
                    },
                    child: Container(
                      width: 160,
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: accentPink.withOpacity(0.06),
                            blurRadius: 16,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 46,
                            height: 46,
                            decoration: BoxDecoration(
                              color: accentPinkLight,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: accentPinkSoft),
                            ),
                            child: const Icon(
                              Icons.local_florist_outlined,
                              color: accentPink,
                              size: 23,
                            ),
                          ),

                          const Spacer(),

                          Text(
                            product.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w800,
                              color: darkText,
                            ),
                          ),

                          const SizedBox(height: 4),

                          Text(
                            'Rp${product.price.toStringAsFixed(0)}',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w800,
                              color: accentPink,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildProductGrid(List<ProductModel> data) {
    if (isLoading) {
      return const SliverFillRemaining(
        hasScrollBody: false,
        child: Center(child: CircularProgressIndicator(color: accentPink)),
      );
    }

    if (data.isEmpty) {
      return SliverFillRemaining(
        hasScrollBody: false,
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Center(
            child: Container(
              padding: const EdgeInsets.all(26),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(26),
              ),
              child: const Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.shopping_bag_outlined,
                    color: accentPink,
                    size: 42,
                  ),
                  SizedBox(height: 14),
                  Text(
                    'Belum ada buket ',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: darkText,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Tekan + untuk menambahkan buket bunga ke katalog.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: softText,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    return SliverPadding(
      padding: const EdgeInsets.fromLTRB(22, 18, 22, 110),
      sliver: SliverGrid(
        delegate: SliverChildBuilderDelegate((context, index) {
          final product = data[index];

          return ProductGridCard(
            product: product,
            onDelete: () {
              deleteProduct(product);
            },
          );
        }, childCount: data.length),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 18,
          crossAxisSpacing: 16,
          childAspectRatio: 0.64,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final data = filteredProducts;

    return Scaffold(
      backgroundColor: background,
      floatingActionButton: FloatingActionButton(
        heroTag: 'add_product',
        elevation: 7,
        backgroundColor: accentPink,
        foregroundColor: Colors.white,
        onPressed: showAddProductSheet,
        child: const Icon(Icons.add_rounded),
      ),
      body: RefreshIndicator(
        color: accentPink,
        onRefresh: fetchProducts,
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(child: buildHeader()),

            buildSampleProducts(),

            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(22, 28, 22, 0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Found\n${data.length} Results',
                      style: const TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.w900,
                        color: darkText,
                        height: 1.05,
                        letterSpacing: -0.5,
                      ),
                    ),

                    const Spacer(),

                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 7,
                      ),
                      decoration: BoxDecoration(
                        color: accentPinkLight,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: accentPinkSoft),
                      ),
                      child: const Text(
                        'Bouquet',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: accentPink,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            buildProductGrid(data),
          ],
        ),
      ),
    );
  }
}

class ProductGridCard extends StatelessWidget {
  final ProductModel product;
  final VoidCallback onDelete;

  const ProductGridCard({
    super.key,
    required this.product,
    required this.onDelete,
  });

  static const Color accentPink = Color(0xFFD94F8C);
  static const Color accentPinkSoft = Color(0xFFF7CFE1);
  static const Color accentPinkLight = Color(0xFFFFF1F6);
  static const Color darkText = Color(0xFF2B2B2B);
  static const Color softText = Color(0xFF7A6F76);
  static const Color background = Color(0xFFFFF8FB);
  static const Color inputFill = Color(0xFFFFFCFD);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(26),
        boxShadow: [
          BoxShadow(
            color: accentPink.withOpacity(0.07),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 14, 14, 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Center(
                child: Container(
                  width: 76,
                  height: 96,
                  decoration: BoxDecoration(
                    color: accentPinkLight,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: const Icon(
                    Icons.local_florist_outlined,
                    color: accentPink,
                    size: 42,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 10),

            Text(
              product.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w800,
                color: darkText,
              ),
            ),

            const SizedBox(height: 4),

            Text(
              product.description,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 11, color: softText),
            ),

            const SizedBox(height: 8),

            Row(
              children: [
                Expanded(
                  child: Text(
                    'Rp${product.price.toStringAsFixed(0)}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w900,
                      color: darkText,
                    ),
                  ),
                ),

                Container(
                  width: 32,
                  height: 32,
                  decoration: const BoxDecoration(
                    color: accentPink,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    icon: const Icon(
                      Icons.delete_outline_rounded,
                      size: 17,
                      color: Colors.white,
                    ),
                    onPressed: onDelete,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
