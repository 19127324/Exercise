import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:exercise_1/component/barChart.dart';
import 'package:exercise_1/component/linearChart.dart';

class Analysis extends StatefulWidget {
  const Analysis({super.key});

  @override
  State<Analysis> createState() => _AnalysisState();
}

class _AnalysisState extends State<Analysis> {
  late List<charts.Series<ChartData, String>> _seriesList;
  late List<charts.Series<PieData, String>> _seriesListLinear;
  @override
  void initState() {
    super.initState();
    _seriesList = _createSampleData();
    _seriesListLinear = createSampleDataLinear();
  }

  List<charts.Series<ChartData, String>> _createSampleData() {
    final data1 = [
      ChartData('Thu nhập', 5, Colors.blue),
      ChartData('Chi tiêu', 25, Colors.orange),
    ];
    final data2 = [];
    return [
      charts.Series<ChartData, String>(
        id: 'Thu nhập',
        domainFn: (ChartData sales, _) => sales.category,
        measureFn: (ChartData sales, _) => sales.amount,
        data: data1,
        colorFn: (ChartData sales, _) => sales.color,
        labelAccessorFn: (ChartData row, _) => '${row.amount}',
      ),
    ];
  }

  static List<charts.Series<PieData, String>> createSampleDataLinear() {
    final data = [
      PieData('Thu nhập', 500, Colors.blue),
      PieData('Chi tiêu', 300, Colors.orange),
    ];

    return [
      charts.Series<PieData, String>(
        id: 'Linear',
        domainFn: (PieData data, _) => data.label,
        measureFn: (PieData data, _) => data.value,
        colorFn: (PieData data, _) => data.color,
        data: data,
        labelAccessorFn: (PieData row, _) => '${row.label}: ${row.value}',
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: DefaultTabController(
          length: 2,
          child: Column(
            children: <Widget>[
              TabBar(
                labelColor: Color(0xFF00aaf7),
                tabs: <Widget>[
                  Tab(text: "Theo tháng"),
                  Tab(text: "Theo năm"),
                ],
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    Center(
                      child: Container(
                          margin: const EdgeInsets.only(
                              top: 40, bottom: 40, right: 5, left: 5),
                          child: BarChart(_seriesList, true, 'Tháng 9')),
                    ),
                    Center(
                      child: Container(
                          margin: const EdgeInsets.only(
                              top: 40, bottom: 40, right: 5, left: 5),
                          child: BarChart(_seriesList, true, 'Năm 2021')),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
