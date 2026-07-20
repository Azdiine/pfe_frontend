import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'dart:ui';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:async';
import '../../../../core/theme/app_colors.dart';
import '../../../fridge/data/services/recommendation_service.dart';

class BarcodeScannerPage extends StatefulWidget {
  const BarcodeScannerPage({super.key});

  @override
  State<BarcodeScannerPage> createState() => _BarcodeScannerPageState();
}

class _BarcodeScannerPageState extends State<BarcodeScannerPage>
    with SingleTickerProviderStateMixin {
  MobileScannerController cameraController = MobileScannerController(
    detectionSpeed: DetectionSpeed.normal,
    facing: CameraFacing.back,
    detectionTimeoutMs: 1000,
  );

  final ImagePicker _imagePicker = ImagePicker();
  final RecommendationService _recommendationService = RecommendationService();

  bool _isProcessing = false;
  bool _isAnalyzing = false;
  late AnimationController _animationController;
  late Animation<double> _scanAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _scanAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    cameraController.dispose();
    super.dispose();
  }

  void _onDetect(BarcodeCapture capture) async {
    if (_isProcessing) return;

    final List<Barcode> barcodes = capture.barcodes;
    if (barcodes.isEmpty) return;

    final barcode = barcodes.first;
    if (barcode.rawValue == null) return;

    setState(() {
      _isProcessing = true;
    });

    // Simulate API call to analyze product
    await _analyzeProduct(barcode.rawValue!);
  }

  Future<void> _analyzeProduct(String barcode) async {
    HapticFeedback.mediumImpact();

    setState(() {
      _isAnalyzing = true;
    });

    try {
      // Appel à l'API backend pour obtenir les recommandations
      final result = await _recommendationService.getRecommendationsByBarcode(barcode);

      if (!mounted) return;

      final scannedProduct = result['scannedProduct'] as Map<String, dynamic>?;
      if (scannedProduct == null) {
        _showError('Produit non trouvé. Essayez un autre code-barres.');
        return;
      }

      // Retourner le produit scanné à l'écran précédent
      Navigator.pop(context, {
        'barcode': barcode,
        'productName': scannedProduct['name'] ?? 'Produit scanné',
        'emoji': '🥫',
        'scannedProduct': scannedProduct,
      });
    } catch (e) {
      if (!mounted) return;
      _showError('Erreur: ${e.toString()}');
    } finally {
      if (mounted) {
        setState(() {
          _isAnalyzing = false;
          _isProcessing = false;
        });
      }
    }
  }

  // 📷 Scanner depuis la galerie
  Future<void> _pickImageAndScan() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1920,
        maxHeight: 1920,
      );

      if (image == null) return;

      setState(() {
        _isAnalyzing = true;
      });

      // Analyser l'image avec mobile_scanner
      final BarcodeCapture? capture = await cameraController.analyzeImage(image.path);

      if (capture != null && capture.barcodes.isNotEmpty) {
        final barcode = capture.barcodes.first;
        if (barcode.rawValue != null) {
          await _analyzeProduct(barcode.rawValue!);
          return;
        }
      }

      // Aucun code trouvé
      setState(() {
        _isAnalyzing = false;
      });

      if (mounted) {
        _showError('Aucun code-barres trouvé dans l\'image');
      }
    } catch (e) {
      setState(() {
        _isAnalyzing = false;
      });
      if (mounted) {
        _showError('Erreur lors de l\'analyse de l\'image');
      }
    }
  }

  // 🚨 Afficher une erreur
  void _showError(String message) {
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text('Erreur'),
        content: Text(message),
        actions: [
          CupertinoDialogAction(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tealColor = AppColors.primary(context);
    
    // 🛑 WRAPPER COMPLET qui masque tout
    return PopScope(
      child: Material(
        type: MaterialType.canvas,
        color: Colors.black,
        child: AnnotatedRegion<SystemUiOverlayStyle>(
          value: const SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            systemNavigationBarColor: Colors.black,
            systemNavigationBarIconBrightness: Brightness.light,
            statusBarIconBrightness: Brightness.light,
          ),
          child: Scaffold(
            backgroundColor: Colors.black,
            extendBody: true,
            extendBodyBehindAppBar: true,
            body: Stack(
        children: [
          // Camera View
          MobileScanner(controller: cameraController, onDetect: _onDetect),

          // Overlay with scan area
          CustomPaint(
            painter: ScannerOverlayPainter(
              scanAnimation: _scanAnimation,
              tealColor: tealColor,
            ),
            child: Container(),
          ),

          // 🎨 Gradient Top pour depth
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 200,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.7),
                    Colors.black.withValues(alpha: 0.4),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          // Top Bar - iOS 2026 Style Premium
          SafeArea(
            child: Column(
              children: [
                // 🍎 Header Premium
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          // Close Button
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                              child: Container(
                                width: 36,
                                height: 36,
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: Colors.white.withValues(alpha: 0.1),
                                    width: 0.5,
                                  ),
                                ),
                                child: CupertinoButton(
                                  padding: EdgeInsets.zero,
                                  onPressed: () => Navigator.pop(context),
                                  child: const Icon(
                                    CupertinoIcons.xmark,
                                    color: Colors.white,
                                    size: 18,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const Spacer(),
                          // Titre Meatay
                          const Text(
                            'Meatay',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                              letterSpacing: -0.5,
                            ),
                          ),
                          const Spacer(),
                          // Flashlight
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                              child: Container(
                                width: 36,
                                height: 36,
                                decoration: BoxDecoration(
                                  color: cameraController.torchEnabled
                                      ? Colors.white.withValues(alpha: 0.25)
                                      : Colors.white.withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: Colors.white.withValues(alpha: 0.1),
                                    width: 0.5,
                                  ),
                                ),
                                child: CupertinoButton(
                                  padding: EdgeInsets.zero,
                                  onPressed: () => cameraController.toggleTorch(),
                                  child: Icon(
                                    cameraController.torchEnabled
                                        ? CupertinoIcons.bolt_fill
                                        : CupertinoIcons.bolt,
                                    color: Colors.white,
                                    size: 18,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const Spacer(),

                // 🍎 Instructions minimalistes - À l'intérieur du cadre
                if (!_isAnalyzing)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 100),
                    child: Column(
                      children: [
                        const Text(
                          'Placez le code dans le cadre',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                            letterSpacing: -0.3,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Détection automatique',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w400,
                            color: Colors.white.withValues(alpha: 0.6),
                            letterSpacing: -0.1,
                          ),
                        ),
                      ],
                    ),
                  ),

                // 📷 Bouton galerie compact
                if (!_isAnalyzing)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 30),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                        child: Container(
                          height: 44,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.white.withValues(alpha: 0.2),
                                Colors.white.withValues(alpha: 0.15),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.2),
                              width: 1,
                            ),
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () {
                                HapticFeedback.lightImpact();
                                _pickImageAndScan();
                              },
                              borderRadius: BorderRadius.circular(12),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(
                                    CupertinoIcons.photo,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 10),
                                  const Text(
                                    'Importer depuis la galerie',
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                      letterSpacing: -0.3,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                const SizedBox(height: 8),
              ],
            ),
          ),

          // � Analyzing Overlay - iOS 2026 Pure
          if (_isAnalyzing)
            Container(
              color: Colors.black.withValues(alpha: 0.95),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Progress indicator iOS natif
                    const SizedBox(
                      width: 44,
                      height: 44,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Colors.white,
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 32),
                    
                    // Text simple
                    const Text(
                      'Analyse en cours',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        letterSpacing: -0.3,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
          ),
        ),
      ),
    );
  }
}

// Custom painter for scanner overlay
class ScannerOverlayPainter extends CustomPainter {
  final Animation<double> scanAnimation;
  final Color tealColor;

  ScannerOverlayPainter({
    required this.scanAnimation,
    required this.tealColor,
  }) : super(repaint: scanAnimation);

  @override
  void paint(Canvas canvas, Size size) {
    final double width = size.width;
    final double height = size.height;
    
    // 🍎 Ajustement intelligent - texte à l'intérieur du cadre
    final double horizontalPadding = 20.0;
    final double topPadding = 110.0; // Espace pour le header
    final double bottomPadding = 110.0; // Réduit pour englober le texte dans le cadre
    
    final double scanAreaWidth = width - (horizontalPadding * 2);
    final double scanAreaHeight = height - topPadding - bottomPadding;
    final double left = horizontalPadding;
    final double top = topPadding;
    final double radius = 24; // iOS 2026: Modern radius

    // 🍎 Dark overlay - Simple
    final backgroundPaint = Paint()
      ..color = Colors.black.withValues(alpha: 0.65)
      ..style = PaintingStyle.fill;

    final scanAreaPath = Path()
      ..addRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(left, top, scanAreaWidth, scanAreaHeight),
          Radius.circular(radius),
        ),
      );

    canvas.drawPath(
      Path.combine(
        PathOperation.difference,
        Path()..addRect(Rect.fromLTWH(0, 0, width, height)),
        scanAreaPath,
      ),
      backgroundPaint,
    );

    // 🍎 Border élégante avec subtle glow
    final borderGlowPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(left, top, scanAreaWidth, scanAreaHeight),
        Radius.circular(radius),
      ),
      borderGlowPaint,
    );

    final borderPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.6)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(left, top, scanAreaWidth, scanAreaHeight),
        Radius.circular(radius),
      ),
      borderPaint,
    );

    // 🍎 Corner indicators premium - Style iOS avec glow
    final cornerGlowPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.4)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5
      ..strokeCap = StrokeCap.round
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);

    final cornerPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.5
      ..strokeCap = StrokeCap.round;

    final cornerLength = 40.0;
    final cornerInset = 16.0;

    // Helper function to draw corners with glow
    void drawCorner(Offset corner, bool isLeft, bool isTop) {
      final x = corner.dx;
      final y = corner.dy;
      
      // Glow effect
      canvas.drawLine(
        Offset(x, isTop ? y + cornerLength : y - cornerLength),
        Offset(x, y),
        cornerGlowPaint,
      );
      canvas.drawLine(
        Offset(x, y),
        Offset(isLeft ? x + cornerLength : x - cornerLength, y),
        cornerGlowPaint,
      );
      
      // Solid lines
      canvas.drawLine(
        Offset(x, isTop ? y + cornerLength : y - cornerLength),
        Offset(x, y),
        cornerPaint,
      );
      canvas.drawLine(
        Offset(x, y),
        Offset(isLeft ? x + cornerLength : x - cornerLength, y),
        cornerPaint,
      );
    }

    // Draw all corners
    drawCorner(Offset(left + cornerInset, top + cornerInset), true, true);
    drawCorner(Offset(left + scanAreaWidth - cornerInset, top + cornerInset), false, true);
    drawCorner(Offset(left + cornerInset, top + scanAreaHeight - cornerInset), true, false);
    drawCorner(Offset(left + scanAreaWidth - cornerInset, top + scanAreaHeight - cornerInset), false, false);

    // 🍎 Scan line premium avec glow
    final scanLineY = top + (scanAreaHeight * scanAnimation.value);
    
    // Glow effect pour la scan line
    final scanLineGlowPaint = Paint()
      ..shader = LinearGradient(
        colors: [
          Colors.transparent,
          Colors.white.withValues(alpha: 0.3),
          Colors.white.withValues(alpha: 0.5),
          Colors.white.withValues(alpha: 0.3),
          Colors.transparent,
        ],
        stops: const [0.0, 0.35, 0.5, 0.65, 1.0],
      ).createShader(Rect.fromLTWH(left + 30, scanLineY - 8, scanAreaWidth - 60, 16))
      ..style = PaintingStyle.fill
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(left + 30, scanLineY - 8, scanAreaWidth - 60, 16),
        const Radius.circular(8),
      ),
      scanLineGlowPaint,
    );

    // Solid scan line
    final scanLinePaint = Paint()
      ..shader = LinearGradient(
        colors: [
          Colors.transparent,
          Colors.white.withValues(alpha: 0.9),
          Colors.white,
          Colors.white.withValues(alpha: 0.9),
          Colors.transparent,
        ],
        stops: const [0.0, 0.4, 0.5, 0.6, 1.0],
      ).createShader(Rect.fromLTWH(left + 30, scanLineY - 1.5, scanAreaWidth - 60, 3))
      ..style = PaintingStyle.fill;

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(left + 30, scanLineY - 1.5, scanAreaWidth - 60, 3),
        const Radius.circular(1.5),
      ),
      scanLinePaint,
    );
  }

  @override
  bool shouldRepaint(ScannerOverlayPainter oldDelegate) => true;
}
