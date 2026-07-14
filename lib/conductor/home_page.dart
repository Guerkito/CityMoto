import 'package:flutter/material.dart';
import '../mock_data.dart';

class ConductorHomePage extends StatefulWidget {
  const ConductorHomePage({super.key});

  @override
  State<ConductorHomePage> createState() => _ConductorHomePageState();
}

class _ConductorHomePageState extends State<ConductorHomePage> {
  bool _isActive = false;

  void _toggleActive(bool value) async {
    setState(() {
      _isActive = value;
    });

    if (_isActive) {
      // Simula que llega una solicitud después de 3 segundos
      await Future.delayed(const Duration(seconds: 3));
      if (mounted && _isActive) {
        Navigator.pushNamed(context, '/conductor/solicitud').then((value) {
          // Si regresa, desactiva por seguridad
          if (mounted) {
            setState(() {
              _isActive = false;
            });
          }
        });
      }
    }
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
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Perfil Conductor Rápido
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
                      child: Icon(Icons.person, color: Colors.white),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        driver.name,
                        style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        driver.vehicle,
                        style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 11),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 32),
              
              // Estado Switch Card
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: const Color(0xFF141414),
                  borderRadius: BorderRadius.circular(24),
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
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Inter',
                        letterSpacing: 1.0,
                      ),
                    ),
                    const SizedBox(height: 8),
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
                    const SizedBox(height: 24),
                    
                    // Switch premium circular
                    Transform.scale(
                      scale: 1.5,
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
              const SizedBox(height: 32),
              
              // Estadísticas
              const Text(
                'Estadísticas de Hoy',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Inter',
                ),
              ),
              const SizedBox(height: 16),
              
              Row(
                children: [
                  _buildStatItem('Viajes', '128', Icons.directions_bike, const Color(0xFF8CFF00)),
                  const SizedBox(width: 16),
                  _buildStatItem('Calificación', '4.8', Icons.star, Colors.amber),
                ],
              ),
              const SizedBox(height: 16),
              _buildLargeStatItem('Ganancias Estimadas', '\$145.000 COP', Icons.monetization_on, const Color(0xFFA855F7)),
              
              const Spacer(),
              
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
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color(0xFF141414),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFF222222), width: 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(height: 12),
            Text(
              value,
              style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold, fontFamily: 'Inter'),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(color: Colors.white.withOpacity(0.4), fontSize: 11, fontFamily: 'Inter'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLargeStatItem(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF141414),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF222222), width: 1),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold, fontFamily: 'Inter'),
              ),
              const SizedBox(height: 2),
              Text(
                label,
                style: TextStyle(color: Colors.white.withOpacity(0.4), fontSize: 11, fontFamily: 'Inter'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
