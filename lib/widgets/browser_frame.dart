import 'package:flutter/material.dart';

class BrowserFrame extends StatelessWidget {
  final Widget child;
  final String path;

  const BrowserFrame({
    super.key,
    required this.child,
    required this.path,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F0F),
      body: Container(
        margin: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFF0A0A0A),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFF222222), width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.4),
              blurRadius: 20,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Column(
          children: [
            // Barra superior del navegador
            Container(
              height: 48,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: const BoxDecoration(
                color: Color(0xFF141414),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15),
                  topRight: Radius.circular(15),
                ),
                border: Border(
                  bottom: BorderSide(color: Color(0xFF222222), width: 1),
                ),
              ),
              child: Row(
                children: [
                  // Botones macOS
                  Row(
                    children: [
                      Container(
                        width: 12,
                        height: 12,
                        decoration: const BoxDecoration(
                          color: Color(0xFFFF5F56),
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        width: 12,
                        height: 12,
                        decoration: const BoxDecoration(
                          color: Color(0xFFFFBD2E),
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        width: 12,
                        height: 12,
                        decoration: const BoxDecoration(
                          color: Color(0xFF27C93F),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 24),
                  
                  // Controles de navegación básicos (atrás/adelante)
                  Icon(Icons.arrow_back_ios_new, color: Colors.white.withOpacity(0.3), size: 14),
                  const SizedBox(width: 16),
                  Icon(Icons.arrow_forward_ios, color: Colors.white.withOpacity(0.3), size: 14),
                  const SizedBox(width: 16),
                  Icon(Icons.refresh, color: Colors.white.withOpacity(0.5), size: 16),
                  
                  const SizedBox(width: 24),
                  
                  // Barra de URL
                  Expanded(
                    child: Container(
                      height: 28,
                      decoration: BoxDecoration(
                        color: const Color(0xFF0A0A0A),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: const Color(0xFF282828), width: 1),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      alignment: Alignment.centerLeft,
                      child: Row(
                        children: [
                          const Icon(Icons.lock, color: Color(0xFF8CFF00), size: 12),
                          const SizedBox(width: 6),
                          Text(
                            'citymotovip.com$path',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.6),
                              fontSize: 12,
                              fontFamily: 'Inter',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 48),
                ],
              ),
            ),
            
            // Contenido de la página
            Expanded(
              child: child,
            ),
          ],
        ),
      ),
    );
  }
}
