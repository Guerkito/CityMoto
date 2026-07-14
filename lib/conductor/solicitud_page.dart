import 'package:flutter/material.dart';

class SolicitudPage extends StatefulWidget {
  const SolicitudPage({super.key});

  @override
  State<SolicitudPage> createState() => _SolicitudPageState();
}

class _SolicitudPageState extends State<SolicitudPage> with SingleTickerProviderStateMixin {
  late AnimationController _timerController;

  @override
  void initState() {
    super.initState();
    _timerController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 15),
    );

    _timerController.reverse(from: 1.0);

    // Si el tiempo expira, rechaza automáticamente
    _timerController.addStatusListener((status) {
      if (status == AnimationStatus.dismissed) {
        if (mounted) {
          _rechazarSolicitud();
        }
      }
    });
  }

  @override
  void dispose() {
    _timerController.dispose();
    super.dispose();
  }

  void _rechazarSolicitud() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Solicitud rechazada/expirada.'),
        backgroundColor: Colors.redAccent,
      ),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 32),
              
              // Título y animación
              const Text(
                'NUEVA SOLICITUD',
                style: TextStyle(
                  color: Color(0xFF8CFF00),
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2.0,
                  fontFamily: 'Inter',
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Moto VIP',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Inter',
                ),
              ),
              const SizedBox(height: 40),
              
              // Temporizador circular
              Center(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Círculo de fondo
                    Container(
                      width: 140,
                      height: 140,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: const Color(0xFF141414),
                        border: Border.all(color: const Color(0xFF222222), width: 4),
                      ),
                    ),
                    
                    // Arco de progreso regresivo
                    SizedBox(
                      width: 140,
                      height: 140,
                      child: AnimatedBuilder(
                        animation: _timerController,
                        builder: (context, child) {
                          return CircularProgressIndicator(
                            value: _timerController.value,
                            strokeWidth: 6,
                            backgroundColor: Colors.transparent,
                            valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF8CFF00)),
                          );
                        },
                      ),
                    ),
                    
                    // Texto contador
                    AnimatedBuilder(
                      animation: _timerController,
                      builder: (context, child) {
                        final seconds = (_timerController.value * 15).ceil();
                        return Text(
                          '$seconds',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Inter',
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 48),
              
              // Datos del Viaje
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFF141414),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFF222222), width: 1.5),
                ),
                child: Column(
                  children: [
                    _buildRouteDetail(
                      icon: Icons.my_location,
                      color: const Color(0xFF8CFF00),
                      title: 'Origen (Recogida)',
                      address: 'Calle 85 # 11-32, Bogotá',
                    ),
                    const Divider(color: Color(0xFF222222), height: 32),
                    _buildRouteDetail(
                      icon: Icons.location_on,
                      color: const Color(0xFFA855F7),
                      title: 'Destino',
                      address: 'Centro Comercial Andino',
                    ),
                    const Divider(color: Color(0xFF222222), height: 32),
                    
                    // Precio y Distancia
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Tarifa Estimada', style: TextStyle(color: Colors.white54, fontSize: 11, fontFamily: 'Inter')),
                            const SizedBox(height: 4),
                            const Text('\$8.500 COP', style: TextStyle(color: Color(0xFF8CFF00), fontSize: 16, fontWeight: FontWeight.bold, fontFamily: 'Inter')),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            const Text('Distancia', style: TextStyle(color: Colors.white54, fontSize: 11, fontFamily: 'Inter')),
                            const SizedBox(height: 4),
                            const Text('1.2 km (5 min)', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold, fontFamily: 'Inter')),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              
              const Spacer(),
              
              // Botones Aceptar / Rechazar
              Row(
                children: [
                  // Rechazar
                  Expanded(
                    child: SizedBox(
                      height: 52,
                      child: OutlinedButton(
                        onPressed: _rechazarSolicitud,
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Color(0xFFFF3B30), width: 1.5),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        ),
                        child: const Text(
                          'Rechazar',
                          style: TextStyle(color: Color(0xFFFF3B30), fontSize: 14, fontWeight: FontWeight.bold, fontFamily: 'Inter'),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  
                  // Aceptar
                  Expanded(
                    child: SizedBox(
                      height: 52,
                      child: ElevatedButton(
                        onPressed: () {
                          // Navega a en curso
                          Navigator.pushReplacementNamed(context, '/conductor/en-curso');
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF8CFF00),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        ),
                        child: const Text(
                          'Aceptar',
                          style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.bold, fontFamily: 'Inter'),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRouteDetail({
    required IconData icon,
    required Color color,
    required String title,
    required String address,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: color, size: 18),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(color: Colors.white54, fontSize: 11, fontFamily: 'Inter'),
              ),
              const SizedBox(height: 2),
              Text(
                address,
                style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold, fontFamily: 'Inter'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
