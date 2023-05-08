import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class PieChart extends StatelessWidget {
  final List<charts.Series<PieData, String>> seriesList;
  final bool animate;

  PieChart(this.seriesList, this.animate);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      width: 300,
      child: charts.PieChart(seriesList,
          animate: animate,
          defaultRenderer: charts.ArcRendererConfig(
            arcWidth: 60,
            arcRendererDecorators: [
              charts.ArcLabelDecorator(
                labelPosition: charts.ArcLabelPosition.outside,
                outsideLabelStyleSpec: charts.TextStyleSpec(
                  fontSize: 16,
                  color: charts.MaterialPalette.gray.shade800,
                ),
              ),
            ],
          )),
    );
  }
}

class PieData {
  final String label;
  final int value;
  final charts.Color color;

  PieData(this.label, this.value, Color color)
      : this.color = charts.Color(
            r: color.red, g: color.green, b: color.blue, a: color.alpha);
}
