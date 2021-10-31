import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:genetic_sudoku/algorithm/generation.dart';
import 'package:genetic_sudoku/theme/schema_colors.dart';

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
        minX: 0,
        maxX: 1000,
        maxY: 250,
        minY: 0,
        titlesData: titlesData,
        lineBarsData: [fittest, unfittest],
        gridData: FlGridData(show: false),
        borderData: FlBorderData(
          border: Border(
            bottom: BorderSide(
              color: borderChartColor,
              width: 4,
            ),
          ),
        ),
        lineTouchData: LineTouchData(
          touchTooltipData: LineTouchTooltipData(
            tooltipBgColor: Colors.blueGrey.withOpacity(0.8),
          ),
        ),
      );

  FlTitlesData get titlesData => FlTitlesData(
        rightTitles: SideTitles(showTitles: false),
        topTitles: SideTitles(showTitles: false),
        bottomTitles: bottomTitles,
        leftTitles: leftTitles,
      );

  SideTitles get bottomTitles => SideTitles(
        showTitles: true,
        margin: 10,
        interval: 100,
        getTextStyles: (context, value) => TextStyle(
          color: numberChartColor,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
        getTitles: (value) => value.toStringAsFixed(0),
      );

  SideTitles get leftTitles => SideTitles(
        showTitles: true,
        margin: 8,
        interval: 20,
        reservedSize: 40,
        getTextStyles: (context, value) => TextStyle(
          color: numberChartColor,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
        getTitles: (value) => value.toStringAsFixed(0),
      );

  LineChartBarData get fittest => LineChartBarData(
        isCurved: true,
        colors: [fittestColor],
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
        colors: [unfittestColor],
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
