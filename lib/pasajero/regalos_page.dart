import 'package:flutter/material.dart';
import '../mock_data.dart';

class RegalosPage extends StatelessWidget {
  const RegalosPage({super.key});

  @override
  Widget build(BuildContext context) {
    final profile = MockData.passengerProfile;
    final completed = profile['completedRides'] as int;
    final target = profile['targetRides'] as int;
    final remaining = target - completed;
    final progress = completed / target;

    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      appBar: AppBar(
        title: const Text(
          'CITY Regalos y Promos',
          style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold, fontFamily: 'Inter'),
        ),
        backgroundColor: const Color(0xFF0A0A0A),
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Tarjeta Progreso Recompensas
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFF141414),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFF222222), width: 1.5),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Club de Beneficios',
                          style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold, fontFamily: 'Inter'),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFF8CFF00).withOpacity(0.15),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            '$completed de $target viajes',
                            style: const TextStyle(color: Color(0xFF8CFF00), fontSize: 11, fontWeight: FontWeight.bold, fontFamily: 'Inter'),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    
                    // Barra de progreso con Glow
                    Stack(
                      children: [
                        Container(
                          height: 10,
                          decoration: BoxDecoration(
                            color: const Color(0xFF222222),
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        FractionallySizedBox(
                          widthFactor: progress,
                          child: Container(
                            height: 10,
                            decoration: BoxDecoration(
                              color: const Color(0xFF8CFF00),
                              borderRadius: BorderRadius.circular(5),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFF8CFF00).withOpacity(0.5),
                                  blurRadius: 8,
                                  spreadRadius: 1,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    
                    Text(
                      '¡Estás a solo $remaining servicios de tu próximo viaje gratis!',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.7),
                        fontSize: 13,
                        fontFamily: 'Inter',
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),
              
              // Saldo de Recompensas
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [const Color(0xFF141414), const Color(0xFF1D2612)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFF8CFF00).withOpacity(0.2), width: 1.5),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Saldo Acumulado',
                          style: TextStyle(color: Colors.white60, fontSize: 12, fontFamily: 'Inter'),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          profile['balance'] as String,
                          style: const TextStyle(
                            color: Color(0xFF8CFF00),
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Inter',
                            shadows: [
                              Shadow(color: Color(0xFF8CFF00), blurRadius: 10),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: const Color(0xFF8CFF00).withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.account_balance_wallet, color: Color(0xFF8CFF00), size: 24),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),
              
              // Promociones vigentes
              const Text(
                'Promociones Vigentes',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Inter',
                ),
              ),
              const SizedBox(height: 16),
              
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: MockData.promotions.length,
                itemBuilder: (context, index) {
                  final promo = MockData.promotions[index];
                  
                  // Analizar meta de viajes dinámicamente de la condición
                  int targetPromoRides = 3;
                  if (promo.condition.contains('3')) {
                    targetPromoRides = 3;
                  } else if (promo.condition.contains('5')) {
                    targetPromoRides = 5;
                  } else if (promo.condition.contains('8')) {
                    targetPromoRides = 8;
                  } else if (promo.condition.toLowerCase().contains('primer') || promo.condition.toLowerCase().contains('invita')) {
                    targetPromoRides = 1;
                  }

                  int currentPromoRides = completed;
                  if (currentPromoRides > targetPromoRides) {
                    currentPromoRides = targetPromoRides;
                  }

                  final double promoProgress = currentPromoRides / targetPromoRides;
                  final bool isCompleted = currentPromoRides >= targetPromoRides;

                  return Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF141414),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isCompleted ? const Color(0xFF8CFF00).withOpacity(0.3) : const Color(0xFF222222),
                        width: isCompleted ? 1.5 : 1.0,
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: isCompleted ? const Color(0xFF8CFF00).withOpacity(0.1) : Colors.white.withOpacity(0.05),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(
                            promo.icon,
                            color: isCompleted ? const Color(0xFF8CFF00) : Colors.cyanAccent,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                promo.title,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Inter',
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                promo.condition,
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.5),
                                  fontSize: 11,
                                  fontFamily: 'Inter',
                                ),
                              ),
                              const SizedBox(height: 12),
                              
                              // Indicador de Progreso
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    isCompleted ? '¡Completada!' : 'Progreso: $currentPromoRides de $targetPromoRides viajes',
                                    style: TextStyle(
                                      color: isCompleted ? const Color(0xFF8CFF00) : Colors.white70,
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Inter',
                                    ),
                                  ),
                                  Text(
                                    isCompleted ? 'Listo para reclamar' : '${(promoProgress * 100).toInt()}%',
                                    style: TextStyle(
                                      color: isCompleted ? const Color(0xFF8CFF00) : Colors.white54,
                                      fontSize: 10,
                                      fontFamily: 'Inter',
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 6),
                              
                              // Barra de Progreso Local
                              Stack(
                                children: [
                                  Container(
                                    height: 6,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF222222),
                                      borderRadius: BorderRadius.circular(3),
                                    ),
                                  ),
                                  FractionallySizedBox(
                                    widthFactor: promoProgress,
                                    child: Container(
                                      height: 6,
                                      decoration: BoxDecoration(
                                        color: isCompleted ? const Color(0xFF8CFF00) : Colors.cyanAccent,
                                        borderRadius: BorderRadius.circular(3),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              
                              const SizedBox(height: 12),
                              Text(
                                promo.benefit,
                                style: TextStyle(
                                  color: isCompleted ? const Color(0xFF8CFF00) : Colors.cyanAccent,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Inter',
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
