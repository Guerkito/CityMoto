import 'package:flutter/material.dart';

class PhoneFrame extends StatelessWidget {
  final Widget child;

  const PhoneFrame({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    // Si la pantalla es muy pequeña (móvil real), no renderizamos el marco físico para que ocupe todo el espacio.
    final size = MediaQuery.of(context).size;
    if (size.width < 500) {
      return Scaffold(
        backgroundColor: const Color(0xFF0A0A0A),
        body: child,
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFF0F0F0F),
      body: Center(
        child: Container(
          width: 390,
          height: 844,
          margin: const EdgeInsets.symmetric(vertical: 20),
          decoration: BoxDecoration(
            color: const Color(0xFF0A0A0A),
            borderRadius: BorderRadius.circular(48),
            border: Border.all(color: const Color(0xFF222222), width: 12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.5),
                blurRadius: 40,
                spreadRadius: 5,
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(36),
            child: Stack(
              children: [
                // Contenido de la pantalla
                Positioned.fill(
                  child: child,
                ),
                
                // Barra de Estado simulada (Notch + Hora + Íconos)
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  height: 44,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    color: Colors.transparent,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Hora
                        const Text(
                          '9:41',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Inter',
                          ),
                        ),
                        // Notch
                        Container(
                          width: 110,
                          height: 30,
                          decoration: const BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(20),
                              bottomRight: Radius.circular(20),
                            ),
                          ),
                        ),
                        // Batería y Señal
                        Row(
                          children: [
                            const Icon(Icons.signal_cellular_4_bar, color: Colors.white, size: 14),
                            const SizedBox(width: 4),
                            const Icon(Icons.wifi, color: Colors.white, size: 14),
                            const SizedBox(width: 4),
                            Container(
                              width: 20,
                              height: 10,
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.white, width: 1),
                                borderRadius: BorderRadius.circular(3),
                              ),
                              padding: const EdgeInsets.all(1),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(1.5),
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
          ),
        ),
      ),
    );
  }
}
