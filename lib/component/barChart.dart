import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';

class BarChart extends StatelessWidget {
  final List<charts.Series<ChartData, String>> seriesList;
  final bool animate;
  final String title;
  BarChart(this.seriesList, this.animate, this.title);

  @override
  Widget build(BuildContext context) {
    return charts.BarChart(
      seriesList,
      animate: animate,
      // Cột được nhóm lại theo nhóm dữ liệu
      behaviors: [
        charts.ChartTitle(title,
            behaviorPosition: charts.BehaviorPosition.top,
            titleOutsideJustification:
                charts.OutsideJustification.middleDrawArea),
      ],
    );
  }
}

class ChartData {
  final String category;
  final int amount;
  final charts.Color color;

  ChartData(this.category, this.amount, Color color)
      : this.color = charts.Color(
            r: color.red, g: color.green, b: color.blue, a: color.alpha);
}
