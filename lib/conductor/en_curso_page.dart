import 'package:flutter/material.dart';
import '../mock_data.dart';

class ConductorEnCursoPage extends StatelessWidget {
  const ConductorEnCursoPage({super.key});

  @override
  Widget build(BuildContext context) {
    final profile = MockData.passengerProfile;

    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      appBar: AppBar(
        title: const Text(
          'Servicio en curso (Conductor)',
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
              // Banner superior neón
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF8CFF00).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFF8CFF00).withOpacity(0.4), width: 1.5),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.navigation, color: Color(0xFF8CFF00), size: 20),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Navegando al destino del pasajero',
                            style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold, fontFamily: 'Inter'),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Destino a 1.2 km (aprox. 5 min)',
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
                'Hoja de Ruta',
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
                      title: 'Dirección de Recogida (Pasajero)',
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
                      title: 'Dirección de Destino (Pasajero)',
                      address: 'Centro Comercial Manila, Fusagasugá',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),

              // Datos del Pasajero
              const Text(
                'Información del Pasajero',
                style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold, fontFamily: 'Inter'),
              ),
              const SizedBox(height: 12),

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
                        border: Border.all(color: const Color(0xFF8CFF00), width: 1.5),
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
                            profile['name'] as String,
                            style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 2),
                          const Row(
                            children: [
                              Icon(Icons.star, color: Colors.amber, size: 12),
                              SizedBox(width: 4),
                              Text(
                                '4.9 · Pasajero VIP',
                                style: TextStyle(color: Colors.white54, fontSize: 11),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    // Mensaje de WhatsApp
                    IconButton(
                      icon: const Icon(Icons.message, color: Color(0xFF8CFF00), size: 20),
                      onPressed: () {
                        _simularAccion(context, 'Abrir WhatsApp', 'Abriendo chat de WhatsApp con la pasajera Laura Gómez...');
                      },
                    ),
                    const SizedBox(width: 4),
                    // SOS Conductor
                    IconButton(
                      icon: const Icon(Icons.warning, color: Color(0xFFFF3B30), size: 20),
                      onPressed: () {
                        MockData.addSosAlert('Andrés M. (Conductor)', 'Conductor', 'En ruta (Vía Silvania - CC Manila)');
                        _simularAccion(context, 'SOS Activado', 'Tu alerta SOS en ruta ha sido enviada al centro de control. Mantén la calma, la ayuda está en camino.');
                      },
                    ),
                  ],
                ),
              ),
              
              const Spacer(),

              // Botones Cancelar / Finalizar
              Row(
                children: [
                  // Cancelar
                  Expanded(
                    child: SizedBox(
                      height: 52,
                      child: OutlinedButton(
                        onPressed: () {
                          _simularAccion(context, 'Cancelar Servicio', '¿Seguro que deseas cancelar este servicio? El sistema te penalizará temporalmente.');
                        },
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Color(0xFFFF3B30), width: 1.5),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        ),
                        child: const Text(
                          'Cancelar',
                          style: TextStyle(color: Color(0xFFFF3B30), fontSize: 14, fontWeight: FontWeight.bold, fontFamily: 'Inter'),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  
                  // Finalizar
                  Expanded(
                    child: SizedBox(
                      height: 52,
                      child: ElevatedButton(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('¡Servicio finalizado con éxito!', style: TextStyle(color: Colors.black)),
                              backgroundColor: Color(0xFF8CFF00),
                            ),
                          );
                          Navigator.pushReplacementNamed(context, '/conductor');
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF8CFF00),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        ),
                        child: const Text(
                          'Finalizar',
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

  void _simularAccion(BuildContext context, String titulo, String desc) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF141414),
          title: Text(titulo, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
          content: Text(desc, style: const TextStyle(color: Colors.white70, fontSize: 14)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: const BorderSide(color: Color(0xFF222222), width: 1),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Entendido', style: TextStyle(color: Color(0xFF8CFF00))),
            ),
          ],
        );
      },
    );
  }
}
