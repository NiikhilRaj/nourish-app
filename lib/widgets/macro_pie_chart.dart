import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:percent_indicator/percent_indicator.dart';

class MacroPercentIndicator extends StatelessWidget {
  const MacroPercentIndicator({
    super.key,
    required this.completed,
    required this.total,
    required this.macros,
  });

  final double completed;
  final double total;
  final List<MacroData> macros;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _ProgressRing(percent: completed / total, label: 'Completed'),
            _ProgressRing(percent: 0.23, label: 'Remaining'),
          ],
        ),
        const SizedBox(height: 32),
        MacroPieChart(data: macros),
      ],
    );
  }
}

//this is the smaller progress ring
//takes two input- percent and label
class _ProgressRing extends StatelessWidget {
  const _ProgressRing({required this.percent, required this.label});

  final double percent;
  final String label;

  @override
  Widget build(BuildContext context) {
    return CircularPercentIndicator(
      radius: 60.0,
      lineWidth: 5.0,
      percent: percent,
      progressColor: Theme.of(context).colorScheme.primary,
      backgroundColor: Theme.of(context).colorScheme.primary.withAlpha(200),
      center: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '${(percent * 100).toInt()}%',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          Text(label, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }
}

class MacroData {
  const MacroData({
    required this.name,
    required this.percent,
    required this.color,
  });

  final String name;
  final double percent;
  final Color color;
}

class MacroPieChart extends StatelessWidget {
  const MacroPieChart({super.key, required this.data});

  final List<MacroData> data;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 200,
          child: PieChart(
            PieChartData(
              startDegreeOffset: 270,
              sectionsSpace: 2,
              centerSpaceRadius: 45,
              sections:
                  data
                      .map(
                        (m) => PieChartSectionData(
                          value: m.percent,
                          color: m.color,
                          title: '${m.percent.toInt()}%',
                          radius: 50,
                          titleStyle: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      )
                      .toList(),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 12,
          children:
              data
                  .map(
                    (m) => Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                            color: m.color,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text('${m.name} ${m.percent.toInt()}%'),
                      ],
                    ),
                  )
                  .toList(),
        ),
      ],
    );
  }
}
