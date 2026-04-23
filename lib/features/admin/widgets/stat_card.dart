import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';

class StatCard extends StatelessWidget {
  final String title;
  final String value;
  final String percentage;
  final bool isIncrease;

  const StatCard({
    super.key,
    required this.title,
    required this.value,
    required this.percentage,
    required this.isIncrease,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: const Color(0xFFF3E9D2), // Warna krem sesuai desain
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: AppColors.primaryGold.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 12, color: Colors.black54),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(
                isIncrease ? Icons.trending_up : Icons.trending_down,
                size: 16,
                color: isIncrease ? Colors.green : Colors.red,
              ),
              const SizedBox(width: 4),
              Text(
                percentage,
                style: TextStyle(
                  fontSize: 12,
                  color: isIncrease ? Colors.green : Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
