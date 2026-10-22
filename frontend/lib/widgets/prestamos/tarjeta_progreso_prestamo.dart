import 'package:flutter/material.dart';

class TarjetaProgresoPrestamo extends StatelessWidget {
  const TarjetaProgresoPrestamo({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE1E8F3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '2 de 12 cuotas',
                style: TextStyle(fontSize: 14, color: Color(0xFF17243C)),
              ),
              Text(
                '16%',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF285FE8),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(3),
            child: const LinearProgressIndicator(
              value: 2 / 12,
              minHeight: 6,
              backgroundColor: Color(0xFFE3E9F2),
              valueColor: AlwaysStoppedAnimation(Color(0xFF285FE8)),
            ),
          ),
        ],
      ),
    );
  }
}
