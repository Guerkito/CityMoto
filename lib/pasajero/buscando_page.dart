import 'package:flutter/material.dart';

class BuscandoPage extends StatefulWidget {
  const BuscandoPage({super.key});

  @override
  State<BuscandoPage> createState() => _BuscandoPageState();
}

class _BuscandoPageState extends State<BuscandoPage> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();

    _simulateDriverAssignment();
  }

  void _simulateDriverAssignment() async {
    await Future.delayed(const Duration(seconds: 3));
    if (mounted) {
      Navigator.pushReplacementNamed(context, '/pasajero/asignado');
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      body: SafeArea(
        child: Column(
          children: [
            const Spacer(),
            
            // Radar Animado
            Center(
              child: AnimatedBuilder(
                animation: _animationController,
                builder: (context, child) {
                  return CustomPaint(
                    painter: RadarPainter(progress: _animationController.value),
                    size: const Size(260, 260),
                  );
                },
              ),
            ),
            
            const Spacer(),
            
            // Textos
            const Text(
              'Buscando Conductor',
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
                fontFamily: 'Inter',
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Conectando con el conductor más cercano...',
              style: TextStyle(
                color: Colors.white.withOpacity(0.5),
                fontSize: 14,
                fontFamily: 'Inter',
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 48),
            
            // Indicador de Progreso lineal sutil
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 48.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: const LinearProgressIndicator(
                  backgroundColor: Color(0xFF1E1E1E),
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF8CFF00)),
                  minHeight: 4,
                ),
              ),
            ),
            const SizedBox(height: 48),
          ],
        ),
      ),
    );
  }
}

class RadarPainter extends CustomPainter {
  final double progress;

  RadarPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final maxRadius = size.width / 2;

    // Pintar círculos concéntricos con opacidad decreciente
    final paint = Paint()
      ..color = const Color(0xFF8CFF00)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    // Círculo Central Fijo
    canvas.drawCircle(center, 12, Paint()..color = const Color(0xFF8CFF00));
    canvas.drawCircle(center, 12, Paint()..color = Colors.white..style = PaintingStyle.stroke..strokeWidth = 2);

    // Ondas expansivas
    for (int i = 0; i < 3; i++) {
      final currentProgress = (progress + i / 3.0) % 1.0;
      final radius = maxRadius * currentProgress;
      final opacity = 1.0 - currentProgress;
      
      paint.color = const Color(0xFF8CFF00).withOpacity(opacity * 0.4);
      paint.strokeWidth = 1.5 + (1.5 * opacity);
      
      // Dibujar círculo
      canvas.drawCircle(center, radius, paint);
      
      // Dibujar sutil glow alrededor
      final glowPaint = Paint()
        ..color = const Color(0xFF8CFF00).withOpacity(opacity * 0.1)
        ..style = PaintingStyle.fill;
      canvas.drawCircle(center, radius, glowPaint);
    }
  }

  @override
  bool shouldRepaint(covariant RadarPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
