import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:permission_handler/permission_handler.dart';

class BarcodeScannerView extends StatefulWidget {
  const BarcodeScannerView({super.key});

  @override
  State<BarcodeScannerView> createState() => _BarcodeScannerViewState();
}

class _BarcodeScannerViewState extends State<BarcodeScannerView> with WidgetsBindingObserver {
  late MobileScannerController controller;
  bool _scanned = false;
  PermissionStatus _permissionStatus = PermissionStatus.denied;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    controller = MobileScannerController(
      detectionSpeed: DetectionSpeed.normal,
      facing: CameraFacing.back,
      autoStart: false,
    );
    _checkPermission();
  }

  Future<void> _checkPermission() async {
    final status = await Permission.camera.status;
    setState(() {
      _permissionStatus = status;
    });

    if (status.isGranted) {
      _startCamera();
    } else {
      final result = await Permission.camera.request();
      setState(() {
        _permissionStatus = result;
      });
      if (result.isGranted) {
        _startCamera();
      } else {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _startCamera() async {
    setState(() {
      _isLoading = false;
    });
    try {
      await controller.start();
    } catch (e) {
      debugPrint('Error starting camera: $e');
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (_permissionStatus.isGranted) {
      if (state == AppLifecycleState.resumed) {
        controller.start();
      } else if (state == AppLifecycleState.paused) {
        controller.stop();
      }
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Scan Product Barcode', style: TextStyle(color: Colors.white, fontSize: 18)),
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Color(0xFF8B80F9)))
          : !_permissionStatus.isGranted
              ? Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.camera_alt_outlined, color: Colors.grey, size: 64),
                      const SizedBox(height: 16),
                      const Text(
                        'Camera permission is required to scan barcodes.',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: () async {
                          if (_permissionStatus.isPermanentlyDenied) {
                            await openAppSettings();
                          } else {
                            _checkPermission();
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF8B80F9),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        child: Text(_permissionStatus.isPermanentlyDenied 
                            ? 'Open App Settings' 
                            : 'Grant Camera Permission'),
                      ),
                    ],
                  ),
                )
              : Stack(
                  alignment: Alignment.center,
                  children: [
                    MobileScanner(
                      controller: controller,
                      onDetect: (capture) {
                        if (_scanned) return;
                        final List<Barcode> barcodes = capture.barcodes;
                        if (barcodes.isNotEmpty) {
                          final String? code = barcodes.first.rawValue;
                          if (code != null && code.trim().isNotEmpty) {
                            _scanned = true;
                            Navigator.pop(context, code);
                          }
                        }
                      },
                    ),
                    
                    // Viewfinder box overlay
                    Container(
                      width: 250,
                      height: 250,
                      decoration: BoxDecoration(
                        border: Border.all(color: const Color(0xFF8B80F9), width: 3),
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    
                    Positioned(
                      bottom: 80,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: const BoxDecoration(
                          color: Colors.black54,
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                        ),
                        child: const Text(
                          'Align barcode inside the frame to scan',
                          style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                  ],
                ),
    );
  }
}
