import 'package:flutter/material.dart';
import '../mock_data.dart';

class SosPage extends StatefulWidget {
  const SosPage({super.key});

  @override
  State<SosPage> createState() => _SosPageState();
}

class _SosPageState extends State<SosPage> with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  bool _alertaEnviada = false;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  void _enviarAlerta() {
    // Registra la alerta en memoria dinámicamente para que la vea la sección de Admin
    MockData.addSosAlert(
      MockData.passengerProfile['name'] as String,
      'Pasajero',
      'Calle 85 # 11-32 (Ubicación en Tiempo Real)',
    );

    setState(() {
      _alertaEnviada = true;
    });

    // Pequeño retardo y muestra diálogo de confirmación
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
              Text('Alerta SOS Enviada', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
            ],
          ),
          content: const Text(
            'Tu alerta ha sido enviada al centro de control. Tu ubicación GPS en tiempo real está siendo monitoreada por nuestro equipo de seguridad.',
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
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF2A0808), // Rojo oscuro superior
              Color(0xFF0A0A0A), // Negro inferior
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Fila superior de navegación
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const Text(
                      'CENTRO DE EMERGENCIA',
                      style: TextStyle(
                        color: Colors.white60,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.5,
                        fontFamily: 'Inter',
                      ),
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: Image.asset(
                        'assets/logos/logo3.jpeg',
                        height: 24,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) => const SizedBox(width: 24),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                
                // Explicación
                const Text(
                  '¿Tienes una Emergencia?',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Inter',
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Mantén presionado el botón o toca para alertar a la central y a tus contactos de seguridad.',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.6),
                    fontSize: 13,
                    fontFamily: 'Inter',
                  ),
                  textAlign: TextAlign.center,
                ),
                
                const Spacer(),
                
                // Botón SOS con Animación de Pulso
                Center(
                  child: GestureDetector(
                    onTap: _enviarAlerta,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Círculos de pulso
                        ...List.generate(2, (index) {
                          return AnimatedBuilder(
                            animation: _pulseController,
                            builder: (context, child) {
                              final progress = (_pulseController.value + index * 0.5) % 1.0;
                              final radius = 100.0 + (progress * 80.0);
                              final opacity = (1.0 - progress) * 0.4;
                              return Container(
                                width: radius * 2,
                                height: radius * 2,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: const Color(0xFFFF3B30).withOpacity(opacity),
                                ),
                              );
                            },
                          );
                        }),
                        
                        // Botón físico central
                        Container(
                          width: 160,
                          height: 160,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: const Color(0xFF141414),
                            border: Border.all(
                              color: _alertaEnviada ? const Color(0xFFFF3B30) : const Color(0xFFFF3B30).withOpacity(0.8),
                              width: 6,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFFFF3B30).withOpacity(0.5),
                                blurRadius: 30,
                                spreadRadius: 3,
                              ),
                            ],
                          ),
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  _alertaEnviada ? Icons.shield : Icons.warning_amber_rounded,
                                  color: const Color(0xFFFF3B30),
                                  size: 48,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  _alertaEnviada ? 'ENVIADA' : 'SOS',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Inter',
                                    letterSpacing: 1.0,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                
                const Spacer(),
                
                // Estado del envío en tiempo real
                if (_alertaEnviada)
                  Container(
                    margin: const EdgeInsets.only(bottom: 24),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFF3B30).withOpacity(0.15),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFFF3B30).withOpacity(0.3)),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.location_on, color: Color(0xFFFF3B30), size: 16),
                        SizedBox(width: 8),
                        Text(
                          'Tu ubicación GPS está siendo compartida',
                          style: TextStyle(color: Color(0xFFFF3B30), fontSize: 11, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                
                // Números rápidos
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Líneas de Emergencia Directas',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Inter',
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                
                Row(
                  children: [
                    _buildEmergencyCallButton(context, 'Policía 123', '123'),
                    const SizedBox(width: 12),
                    _buildEmergencyCallButton(context, 'Ambulancia 125', '125'),
                    const SizedBox(width: 12),
                    _buildEmergencyCallButton(context, 'Bomberos 119', '119'),
                  ],
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmergencyCallButton(BuildContext context, String label, String number) {
    return Expanded(
      child: InkWell(
        onTap: () {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                backgroundColor: const Color(0xFF141414),
                title: Text('Simular llamada a $label', style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold)),
                content: Text('Marcando al número de emergencia $number de forma simulada en tu dispositivo...', style: const TextStyle(color: Colors.white70, fontSize: 13)),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cerrar', style: TextStyle(color: Color(0xFFFF3B30))),
                  ),
                ],
              );
            },
          );
        },
        child: Container(
          height: 48,
          decoration: BoxDecoration(
            color: const Color(0xFF141414),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFF222222), width: 1),
          ),
          child: Center(
            child: Text(
              label,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 11,
                fontWeight: FontWeight.w600,
                fontFamily: 'Inter',
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}
