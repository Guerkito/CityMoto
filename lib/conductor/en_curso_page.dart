import 'package:flutter/material.dart';
import '../widgets/custom_map.dart';
import '../mock_data.dart';

class ConductorEnCursoPage extends StatelessWidget {
  const ConductorEnCursoPage({super.key});

  @override
  Widget build(BuildContext context) {
    final profile = MockData.passengerProfile;

    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      body: Stack(
        children: [
          // Mapa con ruta trazada en púrpura neón
          const Positioned.fill(
            child: CustomMap(
              showRoute: true,
              routeColor: Color(0xFFA855F7),
            ),
          ),
          
          // Indicador de estado superior
          Positioned(
            top: 54,
            left: 20,
            right: 20,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: const Color(0xFF141414).withOpacity(0.9),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFF222222), width: 1),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: const Row(
                children: [
                  Icon(Icons.navigation, color: Color(0xFF8CFF00), size: 18),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Navegando al destino del pasajero',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Inter',
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // Tarjeta inferior de Viaje Activo
          Positioned(
            bottom: 24,
            left: 20,
            right: 20,
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF141414),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: const Color(0xFF222222), width: 1.5),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.5),
                    blurRadius: 20,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Datos del Pasajero
                  Row(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: const Color(0xFF222222),
                          border: Border.all(color: const Color(0xFF8CFF00), width: 1.5),
                        ),
                        child: const Center(
                          child: Icon(Icons.person, color: Colors.white, size: 24),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              profile['name'] as String,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Inter',
                              ),
                            ),
                            const SizedBox(height: 2),
                            const Row(
                              children: [
                                Icon(Icons.star, color: Colors.amber, size: 12),
                                SizedBox(width: 4),
                                Text(
                                  '4.9 · Pasajero VIP',
                                  style: TextStyle(
                                    color: Colors.white54,
                                    fontSize: 11,
                                    fontFamily: 'Inter',
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      // Chat de WhatsApp simulado
                      IconButton(
                        icon: const Icon(Icons.message, color: Color(0xFF8CFF00), size: 22),
                        onPressed: () {
                          _simularAccion(context, 'Abrir WhatsApp', 'Abriendo chat de WhatsApp con la pasajera Laura Gómez...');
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  
                  // Fila de botones de control
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
                      
                      // Finalizar Viaje
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
                              // Vuelve al home del conductor
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
                ],
              ),
            ),
          ),
        ],
      ),
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
