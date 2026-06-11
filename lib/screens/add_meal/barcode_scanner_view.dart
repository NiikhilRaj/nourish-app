import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:toastification/toastification.dart';
import '../../widgets/utils/toast_service.dart';

class BarcodeScannerView extends StatefulWidget {
  const BarcodeScannerView({super.key});

  @override
  State<BarcodeScannerView> createState() => _BarcodeScannerViewState();
}

class _BarcodeScannerViewState extends State<BarcodeScannerView> with SingleTickerProviderStateMixin {
  final MobileScannerController controller = MobileScannerController();
  final TextEditingController textController = TextEditingController();
  late AnimationController animationController;
  bool isScanning = true;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    controller.dispose();
    textController.dispose();
    animationController.dispose();
    super.dispose();
  }

  double _parseDouble(dynamic value, double defaultValue) {
    if (value == null) return defaultValue;
    if (value is num) return value.toDouble();
    if (value is String) {
      return double.tryParse(value) ?? defaultValue;
    }
    return defaultValue;
  }

  Future<void> _fetchProductDetails(String barcode) async {
    if (isLoading) return;
    setState(() {
      isLoading = true;
      isScanning = false;
    });

    final client = HttpClient();
    try {
      final request = await client.getUrl(Uri.parse('https://world.openfoodfacts.org/api/v2/product/$barcode.json'));
      final response = await request.close();
      if (response.statusCode == 200) {
        final responseBody = await response.transform(utf8.decoder).join();
        final data = json.decode(responseBody);
        if (data['status'] == 1 && data['product'] != null) {
          final product = data['product'];
          final name = product['product_name'] ?? product['product_name_en'] ?? product['generic_name'] ?? 'Scanned Food';
          final nutriments = product['nutriments'] ?? {};

          final calories = _parseDouble(nutriments['energy-kcal_100g'] ?? nutriments['energy-kcal'] ?? nutriments['energy-kcal_serving'], 150.0);
          final protein = _parseDouble(nutriments['proteins_100g'] ?? nutriments['proteins'] ?? nutriments['proteins_serving'], 5.0);
          final carbs = _parseDouble(nutriments['carbohydrates_100g'] ?? nutriments['carbohydrates'] ?? nutriments['carbohydrates_serving'], 20.0);
          final fat = _parseDouble(nutriments['fat_100g'] ?? nutriments['fat'] ?? nutriments['fat_serving'], 5.0);

          if (mounted) {
            ToastService().showToast(
              context,
              'Product Found!',
              type: ToastificationType.success,
              description: '$name has been added.',
            );
            Navigator.pop(context, {
              'name': name,
              'calories': calories,
              'protein': protein,
              'carbs': carbs,
              'fat': fat,
            });
          }
          return;
        }
      }
      if (mounted) {
        ToastService().showToast(
          context,
          'Not Found',
          type: ToastificationType.error,
          description: 'Product details could not be found.',
        );
      }
    } catch (e) {
      if (mounted) {
        ToastService().showToast(
          context,
          'Error',
          type: ToastificationType.error,
          description: 'Unable to connect to product database.',
        );
      }
    } finally {
      client.close();
      if (mounted) {
        setState(() {
          isLoading = false;
          isScanning = true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Scan Barcode',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: Stack(
        children: [
          if (isScanning && !isLoading)
            MobileScanner(
              controller: controller,
              onDetect: (capture) {
                final List<Barcode> barcodes = capture.barcodes;
                if (barcodes.isNotEmpty) {
                  final barcodeVal = barcodes.first.rawValue;
                  if (barcodeVal != null && barcodeVal.isNotEmpty) {
                    _fetchProductDetails(barcodeVal);
                  }
                }
              },
            ),
          if (isScanning && !isLoading)
            AnimatedBuilder(
              animation: animationController,
              builder: (context, child) {
                final size = MediaQuery.sizeOf(context);
                final topOffset = size.height * 0.2 + (animationController.value * size.height * 0.3);
                return Stack(
                  children: [
                    ColorFiltered(
                      colorFilter: ColorFilter.mode(
                        Colors.black.withValues(alpha: 0.65),
                        BlendMode.srcOut,
                      ),
                      child: Stack(
                        children: [
                          Container(
                            color: Colors.transparent,
                          ),
                          Center(
                            child: Container(
                              width: size.width * 0.7,
                              height: size.height * 0.3,
                              decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Center(
                      child: Container(
                        width: size.width * 0.7,
                        height: size.height * 0.3,
                        decoration: BoxDecoration(
                          border: Border.all(color: const Color(0xFF6F60EF), width: 3),
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                    ),
                    Positioned(
                      top: topOffset,
                      left: size.width * 0.15,
                      right: size.width * 0.15,
                      child: Container(
                        height: 3,
                        color: const Color(0xFF6F60EF),
                      ),
                    ),
                  ],
                );
              },
            ),
          if (isLoading)
            Container(
              color: Colors.black.withValues(alpha: 0.7),
              child: const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF6F60EF)),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Fetching product details...',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
          Positioned(
            left: 20,
            right: 20,
            bottom: 24,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.95),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Trouble Scanning? Enter manually:',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black87),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          child: TextField(
                            controller: textController,
                            keyboardType: TextInputType.number,
                            style: const TextStyle(color: Colors.black),
                            decoration: const InputDecoration(
                              hintText: 'Enter barcode...',
                              hintStyle: TextStyle(color: Colors.grey),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: () {
                          if (textController.text.trim().isNotEmpty) {
                            _fetchProductDetails(textController.text.trim());
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF6F60EF),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        ),
                        child: const Text('Fetch', style: TextStyle(color: Colors.white)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Quick Test Presets:',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black54),
                  ),
                  const SizedBox(height: 6),
                  Wrap(
                    spacing: 6,
                    children: [
                      ActionChip(
                        label: const Text('Maggi'),
                        onPressed: () => _fetchProductDetails('8901058002316'),
                        backgroundColor: const Color(0xFFE4DCFC),
                        labelStyle: const TextStyle(color: Color(0xFF6F60EF), fontSize: 12),
                        side: BorderSide.none,
                      ),
                      ActionChip(
                        label: const Text('Oreo'),
                        onPressed: () => _fetchProductDetails('7622201141448'),
                        backgroundColor: const Color(0xFFE4DCFC),
                        labelStyle: const TextStyle(color: Color(0xFF6F60EF), fontSize: 12),
                        side: BorderSide.none,
                      ),
                      ActionChip(
                        label: const Text('Coca-Cola'),
                        onPressed: () => _fetchProductDetails('5449000000996'),
                        backgroundColor: const Color(0xFFE4DCFC),
                        labelStyle: const TextStyle(color: Color(0xFF6F60EF), fontSize: 12),
                        side: BorderSide.none,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
