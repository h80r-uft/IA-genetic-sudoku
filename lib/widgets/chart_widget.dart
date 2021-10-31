import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:genetic_sudoku/algorithm/generation.dart';

class ChartWidget extends StatelessWidget {
  const ChartWidget({Key? key, required this.generationsLog}) : super(key: key);

  final List<GenerationLog> generationsLog;

  @override
  Widget build(BuildContext context) {
    return LineChart(
      sampleData,
      swapAnimationDuration: const Duration(milliseconds: 250),
    );
  }

  LineChartData get sampleData => LineChartData(
        lineTouchData: lineTouchData,
        gridData: FlGridData(show: false),
        titlesData: titlesData,
        borderData: borderData,
        lineBarsData: lineBarsData,
        minX: 0,
        maxX: 1000,
        maxY: 250,
        minY: 0,
      );

  LineTouchData get lineTouchData => LineTouchData(
        handleBuiltInTouches: true,
        touchTooltipData: LineTouchTooltipData(
          tooltipBgColor: Colors.blueGrey.withOpacity(0.8),
        ),
      );

  FlTitlesData get titlesData => FlTitlesData(
        rightTitles: SideTitles(showTitles: false),
        topTitles: SideTitles(showTitles: false),
        bottomTitles: bottomTitles,
        leftTitles: leftTitles,
      );

  List<LineChartBarData> get lineBarsData => [
        fittest,
        unfittest,
      ];

  SideTitles get leftTitles => SideTitles(
        showTitles: true,
        margin: 8,
        interval: 20,
        reservedSize: 40,
        getTextStyles: (context, value) => const TextStyle(
          color: Color(0xff75729e),
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
        getTitles: (value) => value.toStringAsFixed(0),
      );

  SideTitles get bottomTitles => SideTitles(
        showTitles: true,
        reservedSize: 22,
        margin: 10,
        interval: 100,
        getTextStyles: (context, value) => const TextStyle(
          color: Color(0xff72719b),
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
        getTitles: (value) => value.toStringAsFixed(0),
      );

  FlBorderData get borderData => FlBorderData(
        show: true,
        border: const Border(
          bottom: BorderSide(color: Color(0xff4e4965), width: 4),
          left: BorderSide(color: Colors.transparent),
          right: BorderSide(color: Colors.transparent),
          top: BorderSide(color: Colors.transparent),
        ),
      );

  LineChartBarData get fittest => LineChartBarData(
        isCurved: true,
        colors: [const Color(0xff4af699)],
        barWidth: 2,
        isStrokeCapRound: true,
        dotData: FlDotData(show: false),
        belowBarData: BarAreaData(show: false),
        spots: generationsLog
            .map<FlSpot>((e) => FlSpot(
                  e.generationNumber.toDouble(),
                  e.fitness.toDouble(),
                ))
            .toList(),
      );

  LineChartBarData get unfittest => LineChartBarData(
        isCurved: true,
        colors: [const Color(0xffaa4cfc)],
        barWidth: 2,
        isStrokeCapRound: true,
        dotData: FlDotData(show: false),
        belowBarData: BarAreaData(show: false, colors: [
          const Color(0x00aa4cfc),
        ]),
        spots: generationsLog
            .map<FlSpot>((e) => FlSpot(
                  e.generationNumber.toDouble(),
                  e.unfittest.toDouble(),
                ))
            .toList(),
      );
}
