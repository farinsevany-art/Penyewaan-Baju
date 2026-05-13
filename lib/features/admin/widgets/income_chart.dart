import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';

class IncomeChart extends StatelessWidget {
  final List<dynamic> chartData;
  const IncomeChart({super.key, required this.chartData});

  @override
  Widget build(BuildContext context) {
    double totalWeek = 0;
    for (var item in chartData) {
      totalWeek += item['total'];
    }

    return Container(
      height: 280,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFF3E9D2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.primaryGold.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Total Penyewaan 7 Hari Terakhir",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
          const SizedBox(height: 10),
          Text(
            "Rp ${totalWeek.toInt()}",
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          Expanded(child: _LineChart(data: chartData)),
        ],
      ),
    );
  }
}

class _LineChart extends StatelessWidget {
  final List<dynamic> data;
  const _LineChart({required this.data});

  @override
  Widget build(BuildContext context) {
    return LineChart(
      LineChartData(
        gridData: const FlGridData(show: false),
        // ... kode sebelumnya ...
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: 1, // 🔻 TAMBAHKAN BARIS INI AGAR HARI TIDAK DOUBLE 🔻
              getTitlesWidget: (value, meta) {
                int index = value.toInt();
                // ... kode setelahnya ...
                if (index >= 0 && index < data.length) {
                  return Text(
                    data[index]['day'],
                    style: const TextStyle(fontSize: 10, color: Colors.grey),
                  );
                }
                return const Text('');
              },
            ),
          ),
          leftTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
        ),
        borderData: FlBorderData(show: false),
        lineBarsData: [
          LineChartBarData(
            spots: data.asMap().entries.map((e) {
              // Dibagi 10.000 agar skala grafik tetap proporsional (Y-axis)
              return FlSpot(
                e.key.toDouble(),
                (e.value['total'] as num).toDouble() / 10000,
              );
            }).toList(),
            isCurved: true,
            color: AppColors.primaryGold,
            barWidth: 4,
            dotData: const FlDotData(show: true),
            belowBarData: BarAreaData(
              show: true,
              color: AppColors.primaryGold.withOpacity(0.1),
            ),
          ),
        ],
      ),
    );
  }
}
