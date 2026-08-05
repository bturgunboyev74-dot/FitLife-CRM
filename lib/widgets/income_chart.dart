import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../services/payment_service.dart';

class IncomeChart extends StatelessWidget {
  const IncomeChart({super.key});

  List<FlSpot> _spots() {
    final now = DateTime.now();

    List<FlSpot> spots = [];

    for (int i = 6; i >= 0; i--) {
      final day = DateTime(
        now.year,
        now.month,
        now.day,
      ).subtract(Duration(days: i));

      double total = 0;

      for (final payment in PaymentService.payments) {
        if (payment.date.year == day.year &&
            payment.date.month == day.month &&
            payment.date.day == day.day) {
          total += payment.amount;
        }
      }

      // Grafik juda baland chiqmasligi uchun
      spots.add(
        FlSpot(
          (6 - i).toDouble(),
          total / 100000,
        ),
      );
    }

    return spots;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 230,
      child: LineChart(
        LineChartData(
          borderData: FlBorderData(show: false),

          gridData: FlGridData(show: true),

          lineBarsData: [
            LineChartBarData(
              spots: _spots(),
              isCurved: true,
              barWidth: 5,
              dotData: FlDotData(show: true),
              belowBarData: BarAreaData(show: true),
            ),
          ],
        ),
      ),
    );
  }
}