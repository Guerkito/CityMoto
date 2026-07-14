import 'package:flutter/material.dart';
import '../mock_data.dart';

class ConductorHomePage extends StatefulWidget {
  const ConductorHomePage({super.key});

  @override
  State<ConductorHomePage> createState() => _ConductorHomePageState();
}

class _ConductorHomePageState extends State<ConductorHomePage> {
  bool _isActive = false;
  bool _sosEnviado = false;

  void _toggleActive(bool value) async {
    setState(() {
      _isActive = value;
    });

    if (_isActive) {
      // Simula que llega una solicitud después de 3 segundos
      await Future.delayed(const Duration(seconds: 3));
      if (mounted && _isActive) {
        Navigator.pushNamed(context, '/conductor/solicitud').then((value) {
          if (mounted) {
            setState(() {
              _isActive = false;
            });
          }
        });
      }
    }
  }

  void _enviarAlertaConductor() {
    MockData.addSosAlert(
      'Andrés M. (Conductor)',
      'Conductor',
      'Fusa Balmoral (Ubicación GPS Conductor)',
    );

    setState(() {
      _sosEnviado = true;
    });

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1C0A0A),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: const BorderSide(color: Color(0xFFFF3B30), width: 1.5),
          ),
          title: const Row(
            children: [
              Icon(Icons.shield_outlined, color: Color(0xFFFF3B30)),
              SizedBox(width: 8),
              Text('Alerta SOS de Conductor', style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold)),
            ],
          ),
          content: const Text(
            'Tu alerta de seguridad ha sido enviada al centro de control. El monitoreo por audio y GPS en tiempo real ha sido activado.',
            style: TextStyle(color: Colors.white70, fontSize: 13),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Entendido', style: TextStyle(color: Color(0xFFFF3B30), fontWeight: FontWeight.bold)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final driver = MockData.drivers[MockData.activeDriverIndex];

    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      appBar: AppBar(
        title: const Text(
          'Panel de Conductor',
          style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold, fontFamily: 'Inter'),
        ),
        backgroundColor: const Color(0xFF0A0A0A),
        automaticallyImplyLeading: false,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Fila superior: Perfil rápido y botón SOS Conductor
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
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
                          child: Icon(Icons.person, color: Colors.white, size: 20),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            driver.name,
                            style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            driver.vehicle,
                            style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 11),
                          ),
                        ],
                      ),
                    ],
                  ),
                  
                  // Botón SOS de pánico rápido para el conductor
                  GestureDetector(
                    onTap: _enviarAlertaConductor,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFF3B30).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: _sosEnviado ? const Color(0xFFFF3B30) : const Color(0xFFFF3B30).withOpacity(0.5),
                          width: 1.5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFFFF3B30).withOpacity(0.2),
                            blurRadius: 8,
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.warning, color: Color(0xFFFF3B30), size: 14),
                          const SizedBox(width: 6),
                          Text(
                            _sosEnviado ? 'SOS ENVIADO' : 'SOS PÁNICO',
                            style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              
              // Estado Switch Card
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFF141414),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: _isActive ? const Color(0xFF8CFF00).withOpacity(0.5) : const Color(0xFF222222),
                    width: 1.5,
                  ),
                  boxShadow: [
                    if (_isActive)
                      BoxShadow(
                        color: const Color(0xFF8CFF00).withOpacity(0.15),
                        blurRadius: 20,
                        spreadRadius: 2,
                      ),
                  ],
                ),
                child: Column(
                  children: [
                    Text(
                      _isActive ? 'ESTADO: ACTIVO' : 'ESTADO: INACTIVO',
                      style: TextStyle(
                        color: _isActive ? const Color(0xFF8CFF00) : Colors.white60,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Inter',
                        letterSpacing: 1.0,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      _isActive 
                          ? 'Esperando solicitudes de viajes cercanos...'
                          : 'Activa el interruptor para empezar a recibir viajes.',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.4),
                        fontSize: 12,
                        fontFamily: 'Inter',
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    
                    // Switch
                    Transform.scale(
                      scale: 1.3,
                      child: Switch(
                        value: _isActive,
                        onChanged: _toggleActive,
                        activeColor: const Color(0xFF8CFF00),
                        activeTrackColor: const Color(0xFF8CFF00).withOpacity(0.3),
                        inactiveThumbColor: Colors.white60,
                        inactiveTrackColor: const Color(0xFF222222),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              
              // Estadísticas de Hoy
              const Text(
                'Estadísticas de Hoy',
                style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold, fontFamily: 'Inter'),
              ),
              const SizedBox(height: 12),
              
              Row(
                children: [
                  _buildStatItem('Servicios', '4 viajes', Icons.directions_bike, const Color(0xFF8CFF00)),
                  const SizedBox(width: 12),
                  _buildStatItem('Calificación', '4.8', Icons.star, Colors.amber),
                ],
              ),
              const SizedBox(height: 12),
              _buildLargeStatItem('Ganancias Estimadas', '\$33.000 COP', Icons.monetization_on, const Color(0xFFA855F7)),
              const SizedBox(height: 24),

              // HISTORIAL DE VIAJES DEL CONDUCTOR
              const Text(
                'Historial de Viajes Recientes',
                style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold, fontFamily: 'Inter'),
              ),
              const SizedBox(height: 12),

              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: MockData.viajesConductor.length,
                itemBuilder: (context, index) {
                  final v = MockData.viajesConductor[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF141414),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: const Color(0xFF222222)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              v.date,
                              style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 10),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: const Color(0xFF8CFF00).withOpacity(0.15),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: const Text(
                                'Completado',
                                style: TextStyle(color: Color(0xFF8CFF00), fontSize: 9, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Cliente: ${v.passengerName}',
                          style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          v.route,
                          style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 11),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Tarifa:', style: TextStyle(color: Colors.white60, fontSize: 11)),
                            Text(
                              v.fare,
                              style: const TextStyle(color: Color(0xFF8CFF00), fontSize: 13, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
              
              const SizedBox(height: 24),
              
              // Volver
              Center(
                child: TextButton(
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, '/');
                  },
                  child: Text(
                    'Cambiar de Rol / Salir',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.4),
                      fontSize: 12,
                      fontFamily: 'Inter',
                      decoration: TextDecoration.underline,
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

  Widget _buildStatItem(String label, String value, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF141414),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFF222222), width: 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 18),
            const SizedBox(height: 10),
            Text(
              value,
              style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold, fontFamily: 'Inter'),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(color: Colors.white.withOpacity(0.4), fontSize: 10, fontFamily: 'Inter'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLargeStatItem(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF141414),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFF222222), width: 1),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold, fontFamily: 'Inter'),
              ),
              const SizedBox(height: 2),
              Text(
                label,
                style: TextStyle(color: Colors.white.withOpacity(0.4), fontSize: 10, fontFamily: 'Inter'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
