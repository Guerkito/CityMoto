import 'package:flutter/material.dart';

class CustomMap extends StatefulWidget {
  final bool showRoute;
  final Color routeColor;
  final bool animateRadar;
  final List<MapMarker>? staticMarkers;
  final Function(MapMarker)? onMarkerTap;

  const CustomMap({
    super.key,
    this.showRoute = false,
    this.routeColor = const Color(0xFFA855F7), // Púrpura neón por defecto
    this.animateRadar = false,
    this.staticMarkers,
    this.onMarkerTap,
  });

  @override
  State<CustomMap> createState() => _CustomMapState();
}

class _CustomMapState extends State<CustomMap> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );
    if (widget.animateRadar || widget.showRoute) {
      _animationController.repeat();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      child: Stack(
        children: [
          // Fondo del mapa
          Positioned.fill(
            child: AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                return CustomPaint(
                  painter: MapPainter(
                    showRoute: widget.showRoute,
                    routeColor: widget.routeColor,
                    animationValue: _animationController.value,
                    staticMarkers: widget.staticMarkers,
                  ),
                );
              },
            ),
          ),
          
          // Render de botones o interactividad sobre los marcadores si los hay
          if (widget.staticMarkers != null)
            ...widget.staticMarkers!.map((marker) {
              return Positioned(
                left: marker.position.dx - 20,
                top: marker.position.dy - 20,
                child: GestureDetector(
                  onTap: () {
                    if (widget.onMarkerTap != null) {
                      widget.onMarkerTap!(marker);
                    }
                  },
                  child: Container(
                    width: 40,
                    height: 40,
                    color: Colors.transparent, // Área para hacer tap
                  ),
                ),
              );
            }),
        ],
      ),
    );
  }
}

class MapMarker {
  final String id;
  final String label;
  final Offset position;
  final IconData icon;
  final Color color;

  MapMarker({
    required this.id,
    required this.label,
    required this.position,
    required this.icon,
    required this.color,
  });
}

class MapPainter extends CustomPainter {
  final bool showRoute;
  final Color routeColor;
  final double animationValue;
  final List<MapMarker>? staticMarkers;

  MapPainter({
    required this.showRoute,
    required this.routeColor,
    required this.animationValue,
    this.staticMarkers,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF0F0F0F)
      ..style = PaintingStyle.fill;
    
    // Rellenar fondo oscuro del mapa
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint);

    // Dibujar rejilla de calles estilo Tron/Cyberpunk sutil
    final streetPaint = Paint()
      ..color = const Color(0xFF1E1E1E)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    final double gridSpacing = 60.0;
    
    // Calles horizontales y diagonales
    for (double y = 0; y < size.height; y += gridSpacing) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), streetPaint);
    }
    for (double x = 0; x < size.width; x += gridSpacing) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), streetPaint);
    }

    // Dibujar algunas avenidas principales más gruesas y en diagonal
    final avenuePaint = Paint()
      ..color = const Color(0xFF282828)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0;

    canvas.drawLine(Offset(0, size.height * 0.3), Offset(size.width, size.height * 0.5), avenuePaint);
    canvas.drawLine(Offset(size.width * 0.2, 0), Offset(size.width * 0.8, size.height), avenuePaint);
    
    // Si se muestra ruta activa
    if (showRoute) {
      final start = Offset(size.width * 0.3, size.height * 0.65);
      final end = Offset(size.width * 0.7, size.height * 0.35);

      // Dibujar línea de ruta con glow
      final glowPaint = Paint()
        ..color = routeColor.withOpacity(0.3)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 8.0
        ..strokeCap = StrokeCap.round;
      
      final activeRoutePaint = Paint()
        ..color = routeColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = 4.0
        ..strokeCap = StrokeCap.round;

      // Dibujar ruta curva (Bezieres)
      final path = Path();
      path.moveTo(start.dx, start.dy);
      // Punto de control para curva
      final controlPoint = Offset(size.width * 0.4, size.height * 0.4);
      path.quadraticBezierTo(controlPoint.dx, controlPoint.dy, end.dx, end.dy);

      canvas.drawPath(path, glowPaint);
      canvas.drawPath(path, activeRoutePaint);

      // Simular un punto moviéndose a lo largo de la ruta (animación de viaje)
      final pathMetrics = path.computeMetrics().first;
      final progress = animationValue;
      final tangent = pathMetrics.getTangentForOffset(pathMetrics.length * progress);
      
      if (tangent != null) {
        final dotPaint = Paint()
          ..color = Colors.white
          ..style = PaintingStyle.fill;
        final dotGlow = Paint()
          ..color = routeColor.withOpacity(0.8)
          ..style = PaintingStyle.fill;

        canvas.drawCircle(tangent.position, 8, dotGlow);
        canvas.drawCircle(tangent.position, 4, dotPaint);
      }

      // Pines de Origen y Destino
      _drawNeonPin(canvas, start, const Color(0xFF8CFF00)); // Pasajero
      _drawNeonPin(canvas, end, const Color(0xFFA855F7));   // Destino / Conductor
    } 
    // Dibujar marcadores estáticos (por ejemplo, conductores activos en el panel de admin)
    else if (staticMarkers != null) {
      for (var marker in staticMarkers!) {
        _drawInteractiveMarker(canvas, marker);
      }
    } 
    // Si no hay ruta ni marcadores estáticos, dibujar pin central verde por defecto (Home Pasajero)
    else {
      final center = Offset(size.width / 2, size.height / 2);
      _drawNeonPin(canvas, center, const Color(0xFF8CFF00));
    }
  }

  void _drawNeonPin(Canvas canvas, Offset position, Color color) {
    final glowPaint = Paint()
      ..color = color.withOpacity(0.4)
      ..style = PaintingStyle.fill;

    final pinPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final centerPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    // Círculo de glow
    canvas.drawCircle(position, 16, glowPaint);
    // Pin exterior
    canvas.drawCircle(position, 8, pinPaint);
    // Centro del pin
    canvas.drawCircle(position, 3, centerPaint);
  }

  void _drawInteractiveMarker(Canvas canvas, MapMarker marker) {
    final glowPaint = Paint()
      ..color = marker.color.withOpacity(0.4)
      ..style = PaintingStyle.fill;

    final pinPaint = Paint()
      ..color = marker.color
      ..style = PaintingStyle.fill;

    // Círculo exterior glow
    canvas.drawCircle(marker.position, 14, glowPaint);
    canvas.drawCircle(marker.position, 8, pinPaint);
    
    // Dibujar un pequeño triángulo debajo para simular un pin clásico
    final path = Path()
      ..moveTo(marker.position.dx - 6, marker.position.dy + 4)
      ..lineTo(marker.position.dx, marker.position.dy + 14)
      ..lineTo(marker.position.dx + 6, marker.position.dy + 4)
      ..close();
    canvas.drawPath(path, pinPaint);
    
    // Punto blanco en el centro
    final whitePaint = Paint()..color = Colors.black;
    canvas.drawCircle(marker.position, 3, whitePaint);
  }

  @override
  bool shouldRepaint(covariant MapPainter oldDelegate) {
    return oldDelegate.animationValue != animationValue ||
           oldDelegate.showRoute != showRoute ||
           oldDelegate.staticMarkers != staticMarkers;
  }
}
