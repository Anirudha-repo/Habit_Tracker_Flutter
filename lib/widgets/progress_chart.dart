import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../models/habit.dart';

class ProgressChart extends StatelessWidget {
  final List<Habit> habits;
  const ProgressChart({Key? key, required this.habits}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final int habitCount = habits.length;
    List<int> dayCounts = List<int>.filled(7, 0);

    for (var h in habits) {
      for (int i = 0; i < 7; i++) {
        if (h.completed.length > i && h.completed[i]) dayCounts[i]++;
      }
    }

    return Card(
      margin: const EdgeInsets.all(12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text('Weekly Progress', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            SizedBox(
              height: 180,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: habitCount.toDouble() < 1 ? 1 : habitCount.toDouble(),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: true, interval: 1),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, _) {
                          const days = ['M','T','W','T','F','S','S'];
                          return Text(days[value.toInt()]);
                        },
                      ),
                    ),
                  ),
                  barGroups: List.generate(7, (i) {
                    return BarChartGroupData(
                      x: i,
                      barRods: [
                        BarChartRodData(
                          toY: dayCounts[i].toDouble(),
                          width: 20,
                          color: Colors.indigo,
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ],
                    );
                  }),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
