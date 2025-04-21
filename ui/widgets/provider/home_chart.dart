import 'package:ajeer/models/provider/home/provider_home_model.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

Widget BuildChart(ProviderHomeChart? chart) {
  if (chart == null || chart.offers == null || chart.services == null) {
    return const Center(child: Text('No data available'));
  }

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      // عنوان المخطط
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Text(
          "الإحصائيات الشهرية",
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),

      // المخطط البياني
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: SizedBox(
          height: 250, // ارتفاع مناسب للمخطط
          child: LineChart(
            LineChartData(
              titlesData: FlTitlesData(
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: false, // إخفاء أسماء الأشهر
                  ),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 32,
                    getTitlesWidget: (value, meta) {
                      return Text(
                        '${value.toInt()}k',
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 10,
                        ),
                      );
                    },
                  ),
                ),
              ),
              gridData: FlGridData(
                show: true,
                horizontalInterval: 1,
                getDrawingHorizontalLine: (value) {
                  return FlLine(
                    color: Colors.grey.withOpacity(0.3),
                    strokeWidth: 1,
                  );
                },
              ),
              lineBarsData: [
                LineChartBarData(
                  spots: List.generate(
                    chart.services!.length,
                    (index) {
                      final y = chart.services![index].toDouble();
                      if (!y.isNaN && y.isFinite) {
                        return FlSpot(index.toDouble(), y);
                      }
                      return const FlSpot(0, 0); // قيمة افتراضية في حالة الخطأ
                    },
                  ),
                  isCurved: true,
                  color: Colors.redAccent,
                  barWidth: 3,
                  belowBarData: BarAreaData(
                    show: true,
                    color: Colors.redAccent.withOpacity(0.3),
                  ),
                ),
                LineChartBarData(
                  spots: List.generate(
                    chart.offers!.length,
                    (index) {
                      final y = chart.offers![index].toDouble();
                      if (!y.isNaN && y.isFinite) {
                        return FlSpot(index.toDouble(), y);
                      }
                      return const FlSpot(0, 0); // قيمة افتراضية في حالة الخطأ
                    },
                  ),
                  isCurved: true,
                  color: Colors.black,
                  barWidth: 3,
                ),
              ],
            ),
          ),
        ),
      ),

      // توضيح المخطط
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            LegendItem(color: Colors.redAccent, label: "الخدمات"),
            LegendItem(color: Colors.black, label: "العروض"),
          ],
        ),
      ),
    ],
  );
}

class LegendItem extends StatelessWidget {
  final Color color;
  final String label;

  const LegendItem({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(6),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: Colors.black),
        ),
      ],
    );
  }
}
