import 'package:flutter/material.dart';
import '../widgets/custom_map.dart';
import '../mock_data.dart';

class EnCursoPage extends StatelessWidget {
  const EnCursoPage({super.key});

  @override
  Widget build(BuildContext context) {
    final driver = MockData.drivers[MockData.activeDriverIndex];

    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      body: Stack(
        children: [
          // Mapa con ruta activa en púrpura neón
          const Positioned.fill(
            child: CustomMap(
              showRoute: true,
              routeColor: Color(0xFFA855F7), // Púrpura neón para ruta
            ),
          ),
          
          // Barra de estado del servicio superior
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
                  Icon(Icons.directions_run, color: Color(0xFFA855F7), size: 18),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Servicio en curso · Destino a 8 min',
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
                  // Info rápida del conductor
                  Row(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: const Color(0xFF222222),
                          border: Border.all(color: const Color(0xFFA855F7), width: 1.5),
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
                              driver.name,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Inter',
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '${driver.vehicle} · ${driver.licensePlate}',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.5),
                                fontSize: 11,
                                fontFamily: 'Inter',
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Botón SOS rápido flotante
                      IconButton(
                        icon: const Icon(Icons.warning, color: Color(0xFFFF3B30), size: 22),
                        onPressed: () {
                          Navigator.pushNamed(context, '/pasajero/sos');
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  
                  // Botón Finalizar Viaje
                  SizedBox(
                    width: double.infinity,
                    height: 52,
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
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
