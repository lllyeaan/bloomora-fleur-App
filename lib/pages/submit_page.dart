import 'package:flutter/material.dart';
import '../services/product_service.dart';

class SubmitPage extends StatefulWidget {
  const SubmitPage({super.key});

  @override
  State<SubmitPage> createState() => _SubmitPageState();
}

class _SubmitPageState extends State<SubmitPage> {
  final ProductService productService = ProductService();

  final nameController = TextEditingController(text: 'Rose Romance Bouquet');
  final priceController = TextEditingController(text: '150000');
  final descriptionController = TextEditingController(
    text:
        'Buket mawar merah elegan dengan wrapping premium untuk hadiah romantis.',
  );
  final githubController = TextEditingController(
    text: 'https://github.com/username-kamu/tugas-pbm-florist',
  );

  bool isLoading = false;

  static const Color accentPink = Color(0xFFD94F8C);
  static const Color accentPinkSoft = Color(0xFFF7CFE1);
  static const Color accentPinkLight = Color(0xFFFFF1F6);
  static const Color darkText = Color(0xFF2B2B2B);
  static const Color softText = Color(0xFF7A6F76);
  static const Color background = Color(0xFFFFF8FB);
  static const Color inputFill = Color(0xFFFFFCFD);

  Future<void> submitTask() async {
    final name = nameController.text.trim();
    final priceText = priceController.text.trim();
    final description = descriptionController.text.trim();
    final githubUrl = githubController.text.trim();

    if (name.isEmpty ||
        priceText.isEmpty ||
        description.isEmpty ||
        githubUrl.isEmpty) {
      showMessage('Semua data submit wajib diisi.');
      return;
    }

    final price = int.tryParse(priceText);

    if (price == null) {
      showMessage('Harga produk harus berupa angka.');
      return;
    }

    if (!githubUrl.startsWith('https://github.com/')) {
      showMessage('Link repository harus diawali https://github.com/');
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final success = await productService.submitProduct(
        name: name,
        price: price,
        description: description,
        githubUrl: githubUrl,
      );

      if (!mounted) return;

      setState(() {
        isLoading = false;
      });

      if (success) {
        showMessage('Tugas berhasil disubmit.');
      } else {
        showMessage('Gagal submit tugas. Periksa token atau data request.');
      }
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isLoading = false;
      });

      showMessage('Terjadi kesalahan: $e');
    }
  }

  void showMessage(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        backgroundColor: darkText,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
      ),
    );
  }

  InputDecoration inputDecoration({
    required String label,
    required String hint,
    required IconData icon,
  }) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      filled: true,
      fillColor: inputFill,
      prefixIcon: Icon(
        icon,
        color: accentPink,
      ),
      labelStyle: const TextStyle(
        color: softText,
        fontWeight: FontWeight.w500,
      ),
      hintStyle: TextStyle(
        color: Colors.grey.shade400,
        fontSize: 14,
      ),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 18,
        vertical: 16,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: BorderSide(
          color: Colors.grey.shade200,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: const BorderSide(
          color: accentPinkSoft,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: const BorderSide(
          color: accentPink,
          width: 1.5,
        ),
      ),
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    priceController.dispose();
    descriptionController.dispose();
    githubController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(22, 18, 22, 28),
          children: [
            Row(
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: accentPinkSoft,
                    ),
                  ),
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    icon: const Icon(
                      Icons.arrow_back_ios_new_rounded,
                      size: 18,
                      color: darkText,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),

                const Expanded(
                  child: Center(
                    child: Column(
                      children: [
                        Text(
                          'Submit Tugas',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w900,
                            color: darkText,
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'Bloomora Fleur',
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
                    border: Border.all(
                      color: accentPinkSoft,
                    ),
                  ),
                  child: const Icon(
                    Icons.local_florist_outlined,
                    color: accentPink,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 28),

            Container(
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFFFFF4F8),
                    Color(0xFFFCE7F1),
                    Color(0xFFFFF8EE),
                  ],
                ),
                borderRadius: BorderRadius.circular(28),
                border: Border.all(
                  color: accentPinkSoft,
                ),
                boxShadow: [
                  BoxShadow(
                    color: accentPink.withOpacity(0.10),
                    blurRadius: 22,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    width: 58,
                    height: 58,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: accentPinkSoft,
                      ),
                    ),
                    child: const Icon(
                      Icons.card_giftcard_outlined,
                      color: accentPink,
                      size: 28,
                    ),
                  ),

                  const SizedBox(width: 16),

                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Final Submission',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w900,
                            color: darkText,
                            letterSpacing: -0.3,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(28),
                border: Border.all(
                  color: accentPinkSoft,
                ),
                boxShadow: [
                  BoxShadow(
                    color: accentPink.withOpacity(0.06),
                    blurRadius: 18,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Data Pengumpulan',
                    style: TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.w900,
                      color: darkText,
                    ),
                  ),

                  const SizedBox(height: 20),

                  TextField(
                    controller: nameController,
                    decoration: inputDecoration(
                      label: 'Nama Buket',
                      hint: 'Contoh: Rose Romance Bouquet',
                      icon: Icons.local_florist_outlined,
                    ),
                  ),

                  const SizedBox(height: 14),

                  TextField(
                    controller: priceController,
                    keyboardType: TextInputType.number,
                    decoration: inputDecoration(
                      label: 'Harga Buket',
                      hint: 'Contoh: 150000',
                      icon: Icons.payments_outlined,
                    ),
                  ),

                  const SizedBox(height: 14),

                  TextField(
                    controller: descriptionController,
                    maxLines: 3,
                    decoration: inputDecoration(
                      label: 'Deskripsi Buket',
                      hint: 'Tulis deskripsi singkat buket',
                      icon: Icons.notes_rounded,
                    ),
                  ),

                  const SizedBox(height: 14),

                  TextField(
                    controller: githubController,
                    decoration: inputDecoration(
                      label: 'Link Repository GitHub',
                      hint: 'https://github.com/username/repository',
                      icon: Icons.link_rounded,
                    ),
                  ),

                  const SizedBox(height: 24),

                  SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: ElevatedButton(
                      onPressed: isLoading ? null : submitTask,
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        backgroundColor: accentPink,
                        disabledBackgroundColor: accentPink.withOpacity(0.45),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                      ),
                      child: isLoading
                          ? const SizedBox(
                              width: 22,
                              height: 22,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.4,
                                color: Colors.white,
                              ),
                            )
                          : const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.cloud_upload_outlined),
                                SizedBox(width: 10),
                                Text(
                                  'Submit Tugas',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ],
                            ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 18),

          ],
        ),
      ),
    );
  }
}