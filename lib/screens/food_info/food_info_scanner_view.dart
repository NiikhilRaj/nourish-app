import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:toastification/toastification.dart';
import '../../widgets/utils/toast_service.dart';

class FoodInfoScannerView extends StatefulWidget {
  const FoodInfoScannerView({super.key});

  @override
  State<FoodInfoScannerView> createState() => _FoodInfoScannerViewState();
}

class _BarcodeScannerViewPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF6F60EF)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0;

    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final rrect = RRect.fromRectAndRadius(rect, const Radius.circular(12));
    canvas.drawRRect(rrect, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _FoodInfoScannerViewState extends State<FoodInfoScannerView> with SingleTickerProviderStateMixin {
  final MobileScannerController controller = MobileScannerController();
  late AnimationController animationController;
  bool isScanning = true;

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
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Scan any barcode',
          style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w500),
        ),
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          MobileScanner(
            controller: controller,
            onDetect: (capture) {
              if (!isScanning) return;
              final List<Barcode> barcodes = capture.barcodes;
              if (barcodes.isNotEmpty && barcodes.first.rawValue != null) {
                isScanning = false;
                final barcode = barcodes.first.rawValue!;
                Navigator.pop(context, barcode);
              }
            },
          ),
          Container(
            color: Colors.black.withValues(alpha: 0.5),
          ),
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: 260,
                      height: 160,
                      decoration: const BoxDecoration(
                        color: Colors.transparent,
                      ),
                      child: CustomPaint(
                        painter: _BarcodeScannerViewPainter(),
                      ),
                    ),
                    AnimatedBuilder(
                      animation: animationController,
                      builder: (context, child) {
                        return Positioned(
                          top: 10 + (animationController.value * 140),
                          child: Container(
                            width: 240,
                            height: 2.5,
                            decoration: BoxDecoration(
                              color: const Color(0xFF6F60EF),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFF6F60EF).withValues(alpha: 0.8),
                                  blurRadius: 4,
                                  offset: const Offset(0, 0),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 48,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.flash_on, color: Colors.white),
                      onPressed: () => controller.toggleTorch(),
                    ),
                    const SizedBox(width: 24),
                    IconButton(
                      icon: const Icon(Icons.image_outlined, color: Colors.white),
                      onPressed: () {
                        ToastService().showToast(
                          context,
                          'Gallery support',
                          type: ToastificationType.info,
                          description: 'Point your camera at a barcode to scan it.',
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
