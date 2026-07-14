import 'package:flutter/material.dart';
import '../mock_data.dart';

class EnCursoPage extends StatefulWidget {
  const EnCursoPage({super.key});

  @override
  State<EnCursoPage> createState() => _EnCursoPageState();
}

class _EnCursoPageState extends State<EnCursoPage> with SingleTickerProviderStateMixin {
  late AnimationController _progressController;

  @override
  void initState() {
    super.initState();
    _progressController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 15),
    )..repeat();
  }

  @override
  void dispose() {
    _progressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final driver = MockData.drivers[MockData.activeDriverIndex];

    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      appBar: AppBar(
        title: const Text(
          'Servicio en curso',
          style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold, fontFamily: 'Inter'),
        ),
        backgroundColor: const Color(0xFF0A0A0A),
        automaticallyImplyLeading: false,
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Estado del Viaje (Banner superior neón)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFA855F7).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFA855F7).withOpacity(0.4), width: 1.5),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.two_wheeler, color: Color(0xFFA855F7), size: 20),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Andrés M. va en camino',
                            style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold, fontFamily: 'Inter'),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Tiempo estimado al destino: 8 minutos',
                            style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 11, fontFamily: 'Inter'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),

              // RUTA TEXTUAL EN DETALLE (Timeline)
              const Text(
                'Detalle del Recorrido',
                style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold, fontFamily: 'Inter'),
              ),
              const SizedBox(height: 16),
              
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFF141414),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFF222222)),
                ),
                child: Column(
                  children: [
                    // Origen
                    _buildRouteNode(
                      icon: Icons.my_location,
                      iconColor: const Color(0xFF8CFF00),
                      title: 'Punto de Recogida (Origen)',
                      address: 'Calle 8 # 12-45, Fusagasugá Centro',
                    ),
                    
                    // Línea conectora
                    Row(
                      children: [
                        const SizedBox(width: 9),
                        Container(
                          width: 2,
                          height: 32,
                          color: const Color(0xFF222222),
                        ),
                      ],
                    ),
                    
                    // Destino
                    _buildRouteNode(
                      icon: Icons.location_on,
                      iconColor: const Color(0xFFA855F7),
                      title: 'Punto de Entrega (Destino)',
                      address: 'Centro Comercial Manila, Fusagasugá',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),

              // Indicador de Progreso del Viaje Animado (Barra de carga)
              const Text(
                'Progreso del Viaje',
                style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold, fontFamily: 'Inter'),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF141414),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFF222222)),
                ),
                child: Column(
                  children: [
                    AnimatedBuilder(
                      animation: _progressController,
                      builder: (context, child) {
                        return ClipRRect(
                          borderRadius: BorderRadius.circular(5),
                          child: LinearProgressIndicator(
                            value: _progressController.value,
                            backgroundColor: const Color(0xFF0A0A0A),
                            valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFFA855F7)),
                            minHeight: 10,
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Origen', style: TextStyle(color: Colors.white54, fontSize: 10)),
                        Text(
                          'En Tránsito...',
                          style: TextStyle(color: const Color(0xFFA855F7).withOpacity(0.8), fontSize: 11, fontWeight: FontWeight.bold),
                        ),
                        const Text('Destino', style: TextStyle(color: Colors.white54, fontSize: 10)),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),

              // Tarjeta Datos del Conductor
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF141414),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFF222222)),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: const Color(0xFF222222),
                        border: Border.all(color: const Color(0xFFA855F7), width: 1.5),
                      ),
                      child: const Center(
                        child: Icon(Icons.person, color: Colors.white),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            driver.name,
                            style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            '${driver.vehicle} · ${driver.licensePlate}',
                            style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 11),
                          ),
                        ],
                      ),
                    ),
                    // SOS rápido
                    IconButton(
                      icon: const Icon(Icons.warning, color: Color(0xFFFF3B30), size: 22),
                      onPressed: () {
                        Navigator.pushNamed(context, '/pasajero/sos');
                      },
                    ),
                  ],
                ),
              ),
              
              const Spacer(),

              // Botón Finalizar Viaje
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, '/pasajero/finalizado');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF3B30).withOpacity(0.1),
                    side: const BorderSide(color: Color(0xFFFF3B30), width: 1.5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: const Text(
                    'Finalizar viaje (Demo)',
                    style: TextStyle(
                      color: Color(0xFFFF3B30),
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Inter',
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRouteNode({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String address,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: iconColor, size: 20),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 11, fontFamily: 'Inter'),
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
