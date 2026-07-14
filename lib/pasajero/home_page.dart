import 'package:flutter/material.dart';
import '../widgets/bottom_nav.dart';
import 'perfil_page.dart';

class PasajeroContainer extends StatefulWidget {
  const PasajeroContainer({super.key});

  @override
  State<PasajeroContainer> createState() => _PasajeroContainerState();
}

class _PasajeroContainerState extends State<PasajeroContainer> {
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
                const PasajeroHomePage(),
                const PasajeroHistorialPage(),
                const PasajeroPerfilPage(),
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

class PasajeroHomePage extends StatefulWidget {
  const PasajeroHomePage({super.key});

  @override
  State<PasajeroHomePage> createState() => _PasajeroHomePageState();
}

class _PasajeroHomePageState extends State<PasajeroHomePage> {
  final TextEditingController _origenController = TextEditingController(text: 'Calle 8 # 12-45, Fusagasugá Centro');
  final TextEditingController _destinoController = TextEditingController(text: 'CC Manila, Fusa');
  bool _isForMe = true;
  bool _isOutsideFusa = false;

  @override
  void dispose() {
    _origenController.dispose();
    _destinoController.dispose();
    super.dispose();
  }

  void _buildGpsTrackingAndNavigate() {
    // Simula la calibración de GPS exacta
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return _GpsLockingDialog(
          onFinished: () {
            Navigator.pop(context);
            Navigator.pushNamed(context, '/pasajero/tipo');
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Barra superior con Logo
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.asset(
                      'assets/logos/logo3.jpeg',
                      height: 38,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) => RichText(
                        text: const TextSpan(
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Inter',
                          ),
                          children: [
                            TextSpan(text: 'City', style: TextStyle(color: Colors.white)),
                            TextSpan(text: 'MOTO', style: TextStyle(color: Color(0xFF8CFF00))),
                          ],
                        ),
                      ),
                    ),
                  ),
                  
                  // Notificaciones
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF141414),
                      shape: BoxShape.circle,
                      border: Border.all(color: const Color(0xFF222222), width: 1),
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.notifications_none, color: Colors.white, size: 20),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('No tienes notificaciones nuevas.'),
                            backgroundColor: Color(0xFF141414),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Cabecera interactiva
              const Text(
                '¿A dónde vamos hoy?',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Inter',
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Ingresa tu ubicación actual y tu destino para solicitar un conductor cercano.',
                style: TextStyle(
                  color: Colors.white60,
                  fontSize: 13,
                  fontFamily: 'Inter',
                ),
              ),
              const SizedBox(height: 24),

              // Formulario Principal de Solicitud (Ubicaciones)
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFF141414),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: const Color(0xFF222222), width: 1.5),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.4),
                      blurRadius: 15,
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Campo Origen (¿Dónde estás?)
                    const Text(
                      '¿Dónde te recogemos?',
                      style: TextStyle(color: Color(0xFF8CFF00), fontSize: 11, fontWeight: FontWeight.bold, fontFamily: 'Inter'),
                    ),
                    const SizedBox(height: 6),
                    TextField(
                      controller: _origenController,
                      style: const TextStyle(color: Colors.white, fontSize: 13, fontFamily: 'Inter'),
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.my_location, color: Color(0xFF8CFF00), size: 18),
                        hintText: 'Escribe tu ubicación actual...',
                        hintStyle: TextStyle(color: Colors.white.withOpacity(0.3), fontSize: 13),
                        filled: true,
                        fillColor: const Color(0xFF0A0A0A),
                        contentPadding: const EdgeInsets.symmetric(vertical: 12),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Color(0xFF222222)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Color(0xFF222222)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Color(0xFF8CFF00)),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Campo Destino (¿A dónde vas?)
                    const Text(
                      '¿Cuál es tu destino?',
                      style: TextStyle(color: Color(0xFFA855F7), fontSize: 11, fontWeight: FontWeight.bold, fontFamily: 'Inter'),
                    ),
                    const SizedBox(height: 6),
                    TextField(
                      controller: _destinoController,
                      style: const TextStyle(color: Colors.white, fontSize: 13, fontFamily: 'Inter'),
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.location_on, color: Color(0xFFA855F7), size: 18),
                        hintText: 'Escribe tu destino...',
                        hintStyle: TextStyle(color: Colors.white.withOpacity(0.3), fontSize: 13),
                        filled: true,
                        fillColor: const Color(0xFF0A0A0A),
                        contentPadding: const EdgeInsets.symmetric(vertical: 12),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Color(0xFF222222)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Color(0xFF222222)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Color(0xFF8CFF00)),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Direcciones Rápidas Favoritas
                    Row(
                      children: [
                        _buildFavAddressBtn('🏠 Casa (Fusa)', 'Calle 6 # 14-22, Fusa Centro'),
                        const SizedBox(width: 8),
                        _buildFavAddressBtn('💼 Trabajo', 'Avenida Las Palmas # 20-30'),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Tarjeta Opciones Adicionales de Viaje
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFF141414),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFF222222)),
                ),
                child: Column(
                  children: [
                    // Opción: ¿Para quién es?
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          '¿Para quién es el servicio?',
                          style: TextStyle(color: Colors.white70, fontSize: 12, fontFamily: 'Inter'),
                        ),
                        Row(
                          children: [
                            _buildForWhoBtn('Para mí', _isForMe, () => setState(() => _isForMe = true)),
                            const SizedBox(width: 8),
                            _buildForWhoBtn('Para otro', !_isForMe, () => setState(() => _isForMe = false)),
                          ],
                        ),
                      ],
                    ),
                    const Divider(color: Color(0xFF222222), height: 24),

                    // Opción: ¿Fuera de Fusa?
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          '¿Estoy fuera de Fusagasugá?',
                          style: TextStyle(color: Colors.white70, fontSize: 12, fontFamily: 'Inter'),
                        ),
                        Switch(
                          value: _isOutsideFusa,
                          onChanged: (val) {
                            setState(() {
                              _isOutsideFusa = val;
                              if (_isOutsideFusa) {
                                _origenController.text = 'Vía Silvania (Fuera de Fusa)';
                              } else {
                                _origenController.text = 'Calle 8 # 12-45, Fusagasugá Centro';
                              }
                            });
                          },
                          activeColor: const Color(0xFF8CFF00),
                          activeTrackColor: const Color(0xFF8CFF00).withOpacity(0.3),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),

              // Botón Principal Pedir Servicio
              Container(
                height: 56,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: const LinearGradient(
                    colors: [Color(0xFF8CFF00), Color(0xFF76D600)],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF8CFF00).withOpacity(0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ElevatedButton(
                  onPressed: _buildGpsTrackingAndNavigate,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Pedir servicio ahora',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Inter',
                        ),
                      ),
                      SizedBox(width: 8),
                      Icon(Icons.arrow_forward, color: Colors.black, size: 20),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Botones Flotantes de atajo flotando sobre el contenido
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildFloatingActionButton(
                    label: 'CITY Regalos',
                    icon: Icons.card_giftcard,
                    iconColor: const Color(0xFF8CFF00),
                    onTap: () {
                      Navigator.pushNamed(context, '/pasajero/regalos');
                    },
                  ),
                  _buildFloatingActionButton(
                    label: 'SOS Emergencia',
                    icon: Icons.warning_amber_rounded,
                    iconColor: const Color(0xFFFF3B30),
                    isSos: true,
                    onTap: () {
                      Navigator.pushNamed(context, '/pasajero/sos');
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFavAddressBtn(String label, String address) {
    return Expanded(
      child: InkWell(
        onTap: () {
          setState(() {
            _destinoController.text = address;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: const Color(0xFF0A0A0A),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xFF222222)),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: const TextStyle(color: Colors.white70, fontSize: 11, fontFamily: 'Inter'),
          ),
        ),
      ),
    );
  }

  Widget _buildForWhoBtn(String label, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF8CFF00).withOpacity(0.15) : const Color(0xFF0A0A0A),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? const Color(0xFF8CFF00) : const Color(0xFF222222),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? const Color(0xFF8CFF00) : Colors.white60,
            fontSize: 11,
            fontWeight: FontWeight.bold,
            fontFamily: 'Inter',
          ),
        ),
      ),
    );
  }

  Widget _buildFloatingActionButton({
    required String label,
    required IconData icon,
    required Color iconColor,
    bool isSos = false,
    required VoidCallback onTap,
  }) {
    final glowColor = isSos ? iconColor.withOpacity(0.3) : iconColor.withOpacity(0.2);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(30),
      child: Container(
        height: 48,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: const Color(0xFF141414),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isSos ? iconColor.withOpacity(0.5) : const Color(0xFF222222),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: glowColor,
              blurRadius: 10,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: iconColor, size: 18),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.bold,
                fontFamily: 'Inter',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Dialogo de Calibración de GPS
class _GpsLockingDialog extends StatefulWidget {
  final VoidCallback onFinished;

  const _GpsLockingDialog({required this.onFinished});

  @override
  State<_GpsLockingDialog> createState() => _GpsLockingDialogState();
}

class _GpsLockingDialogState extends State<_GpsLockingDialog> {
  String _statusText = 'Optimizando señal satelital GPS...';
  double _precision = 15.0;

  @override
  void initState() {
    super.initState();
    _startCalibration();
  }

  void _startCalibration() async {
    await Future.delayed(const Duration(milliseconds: 600));
    if (mounted) {
      setState(() {
        _statusText = 'Fijando coordenadas en tiempo real...';
        _precision = 3.5;
      });
    }
    await Future.delayed(const Duration(milliseconds: 700));
    if (mounted) {
      setState(() {
        _statusText = 'Ubicación calibrada con precisión del 99%';
        _precision = 0.9;
      });
    }
    await Future.delayed(const Duration(milliseconds: 500));
    widget.onFinished();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: const Color(0xFF141414),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: const BorderSide(color: Color(0xFF222222), width: 1.5),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 28.0, horizontal: 20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                const SizedBox(
                  width: 64,
                  height: 64,
                  child: CircularProgressIndicator(
                    strokeWidth: 4,
                    valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF8CFF00)),
                  ),
                ),
                Container(
                  width: 50,
                  height: 50,
                  decoration: const BoxDecoration(
                    color: Color(0xFF0A0A0A),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.gps_fixed, color: Color(0xFF8CFF00), size: 24),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Text(
              _statusText,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.bold,
                fontFamily: 'Inter',
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Rango de precisión: ${_precision}m',
              style: TextStyle(
                color: const Color(0xFF8CFF00).withOpacity(0.8),
                fontSize: 11,
                fontFamily: 'Inter',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Historial de viajes simple para la pestaña intermedia
class PasajeroHistorialPage extends StatelessWidget {
  const PasajeroHistorialPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      appBar: AppBar(
        title: const Text('Historial de Viajes', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF141414),
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            Expanded(
              child: ListView(
                children: [
                  _buildHistoryItem(
                    date: 'Hoy, 10:24 AM',
                    driverName: 'Andrés M.',
                    vehicle: 'Yamaha FZ 2.0',
                    price: '\$8.500 COP',
                    serviceType: 'Moto VIP',
                    status: 'Completado',
                  ),
                  const SizedBox(height: 16),
                  _buildHistoryItem(
                    date: 'Ayer, 6:15 PM',
                    driverName: 'Carlos R.',
                    vehicle: 'Suzuki Gixxer 150',
                    price: '\$9.200 COP',
                    serviceType: 'Moto VIP',
                    status: 'Completado',
                  ),
                  const SizedBox(height: 16),
                  _buildHistoryItem(
                    date: '10 Jul, 2:40 PM',
                    driverName: 'Servicio Express',
                    vehicle: 'Domicilio Envío',
                    price: '\$12.000 COP',
                    serviceType: 'CITY Domicilio',
                    status: 'Completado',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHistoryItem({
    required String date,
    required String driverName,
    required String vehicle,
    required String price,
    required String serviceType,
    required String status,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF141414),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF222222), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                date,
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
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: const Color(0xFF222222),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.two_wheeler, color: Color(0xFF8CFF00), size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      driverName,
                      style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '$serviceType · $vehicle',
                      style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 11),
                    ),
                  ],
                ),
              ),
              Text(
                price,
                style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
