import 'package:flutter/material.dart';
import '../mock_data.dart';
import '../widgets/bottom_nav.dart';

class ConductorContainer extends StatefulWidget {
  const ConductorContainer({super.key});

  @override
  State<ConductorContainer> createState() => _ConductorContainerState();
}

class _ConductorContainerState extends State<ConductorContainer> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      body: Stack(
        children: [
          Positioned.fill(
            child: IndexedStack(
              index: _currentIndex,
              children: [
                const ConductorHomePage(),
                const ConductorHistorialPage(),
                const ConductorPerfilPage(),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNav(
        selectedIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}

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
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Fila superior: Info rápida y botón SOS
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: const Color(0xFF222222),
                          border: Border.all(color: const Color(0xFFA855F7), width: 1.5),
                        ),
                        child: const Center(
                          child: Icon(Icons.person, color: Colors.white, size: 18),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            driver.name,
                            style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'Conductor Activo',
                            style: TextStyle(color: const Color(0xFF8CFF00).withOpacity(0.8), fontSize: 10, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ],
                  ),
                  
                  // Botón SOS de Pánico
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
              const SizedBox(height: 32),
              
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
              const SizedBox(height: 32),
              
              // Estadísticas Rápidas
              const Text(
                'Resumen Operativo hoy',
                style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold, fontFamily: 'Inter'),
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

// PESTAÑA 1: HISTORIAL DE VIAJES DEL CONDUCTOR
class ConductorHistorialPage extends StatelessWidget {
  const ConductorHistorialPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      appBar: AppBar(
        title: const Text('Historial de Servicios', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF141414),
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView.builder(
          itemCount: MockData.viajesConductor.length,
          itemBuilder: (context, index) {
            final v = MockData.viajesConductor[index];
            return Container(
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF141414),
                borderRadius: BorderRadius.circular(16),
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
                        style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 11),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFF8CFF00).withOpacity(0.15),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Text(
                          'Completado',
                          style: TextStyle(color: Color(0xFF8CFF00), fontSize: 10, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(
                          color: Color(0xFF222222),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.person, color: Color(0xFFA855F7), size: 16),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              v.passengerName,
                              style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              v.route,
                              style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 11),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        v.fare,
                        style: const TextStyle(color: Color(0xFF8CFF00), fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

// PESTAÑA 2: PERFIL DEL CONDUCTOR (Andrés M.)
class ConductorPerfilPage extends StatelessWidget {
  const ConductorPerfilPage({super.key});

  @override
  Widget build(BuildContext context) {
    final driver = MockData.drivers[MockData.activeDriverIndex];

    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              const Text(
                'Mi Perfil de Chofer',
                style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold, fontFamily: 'Inter'),
              ),
              const SizedBox(height: 24),
              
              // Tarjeta Perfil Conductor
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFF141414),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFF222222), width: 1.5),
                ),
                child: Row(
                  children: [
                    // Avatar con glow púrpura
                    Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: const Color(0xFF222222),
                        border: Border.all(color: const Color(0xFFA855F7), width: 2.5),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFFA855F7).withOpacity(0.3),
                            blurRadius: 10,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                      child: const Center(
                        child: Icon(Icons.person, color: Colors.white, size: 36),
                      ),
                    ),
                    const SizedBox(width: 16),
                    
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            driver.name,
                            style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold, fontFamily: 'Inter'),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Chofer VIP · 128 viajes completados',
                            style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 12, fontFamily: 'Inter'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              
              // Opciones del Perfil
              _buildOptionTile(
                icon: Icons.motorcycle,
                title: 'Información del Vehículo',
                subtitle: '${driver.vehicle} · Placa ${driver.licensePlate}',
                onTap: () {},
              ),
              _buildOptionTile(
                icon: Icons.assignment_outlined,
                title: 'Documentos de Conductor',
                subtitle: 'SOAT y Licencia vigentes',
                onTap: () {},
              ),
              _buildOptionTile(
                icon: Icons.security,
                title: 'Seguridad en Ruta (SOS)',
                subtitle: 'Configurar botón de pánico de soporte',
                onTap: () {},
              ),
              _buildOptionTile(
                icon: Icons.help_outline,
                title: 'Centro de Soporte y Ayuda',
                subtitle: 'Contacto directo con la central',
                onTap: () {},
              ),
              
              const SizedBox(height: 40),
              
              // Botón de Desconexión (Cerrar sesión)
              SizedBox(
                width: double.infinity,
                height: 52,
                child: OutlinedButton.icon(
                  onPressed: () {
                    Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
                  },
                  icon: const Icon(Icons.power_settings_new, color: Color(0xFFFF3B30), size: 18),
                  label: const Text(
                    'Desconectarse / Salir',
                    style: TextStyle(
                      color: Color(0xFFFF3B30),
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Inter',
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0xFFFF3B30), width: 1.5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOptionTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF141414),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFF222222), width: 1),
      ),
      child: ListTile(
        onTap: onTap,
        leading: Icon(icon, color: Colors.white70, size: 22),
        title: Text(
          title,
          style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold, fontFamily: 'Inter'),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(color: Colors.white.withOpacity(0.4), fontSize: 11, fontFamily: 'Inter'),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, color: Colors.white24, size: 14),
      ),
    );
  }
}
