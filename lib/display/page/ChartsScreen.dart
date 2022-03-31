import 'package:flutter/material.dart';
import 'package:pretty_gauge/pretty_gauge.dart';
import 'package:charts_flutter/flutter.dart' as charts;

import '../widget/DashPatternLineChart.dart';

class ChartsScreen extends StatefulWidget {
  const ChartsScreen({Key? key}) : super(key: key);

  @override
  State<ChartsScreen> createState() => _ChartsScreenState();
}

class _ChartsScreenState extends State<ChartsScreen> {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: SizedBox(
        height: 500,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ///BMI gauge Chart
            PrettyGauge(
              gaugeSize: 400,
              minValue: 10,
              maxValue: 45,
              segments: [
                GaugeSegment('UnderWeight', 8.5, Colors.blue),
                GaugeSegment('Normal', 6.5, Colors.green),
                GaugeSegment('Overweight', 5, Colors.yellow),
                GaugeSegment('Obese', 5, Colors.orange),
                GaugeSegment('Extermely Obese', 10, Colors.red),
              ],
              currentValue: 24,
              displayWidget: const Text(
                'Normal',
                style: TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                    decoration: TextDecoration.none),
              ),
            ),
            // const SizedBox(
            //   width: 150,
            // ),
            Expanded(
                child: SimpleTimeSeriesChart(_createSampleData(), 'BMI Chart')),
          ],
        ),
      ),
    );
  }
}

List<charts.Series<LinearSales, DateTime>> _createSampleData() {
  final myFakeDesktopData = [
    LinearSales(DateTime(2018), 33),
    LinearSales(DateTime(2019), 30),
    LinearSales(DateTime(2020), 31),
    LinearSales(DateTime(2021), 27),
    LinearSales(DateTime(2022), 26),
  ];

  final myFakeTargetData = [
    LinearSales(DateTime(2018), 25),
    LinearSales(DateTime(2019), 25),
    LinearSales(DateTime(2020), 25),
    LinearSales(DateTime(2021), 25),
    LinearSales(DateTime(2022), 25),
  ];

  // var myFakeMobileData = [
  //   new LinearSales(0, 15),
  //   new LinearSales(1, 75),
  //   new LinearSales(2, 300),
  //   new LinearSales(3, 225),
  // ];

  return [
    charts.Series<LinearSales, DateTime>(
      id: 'Real BMI',
      colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
      domainFn: (LinearSales sales, _) => sales.year,
      measureFn: (LinearSales sales, _) => sales.sales,
      data: myFakeDesktopData,
    ),
    charts.Series<LinearSales, DateTime>(
      id: 'Target BMI',
      colorFn: (_, __) => charts.MaterialPalette.red.shadeDefault,
      domainFn: (LinearSales sales, _) => sales.year,
      measureFn: (LinearSales sales, _) => sales.sales,
      data: myFakeTargetData,
    ),
    // new charts.Series<LinearSales, int>(
    //   id: 'Mobile',
    //   colorFn: (_, __) => charts.MaterialPalette.green.shadeDefault,
    //   domainFn: (LinearSales sales, _) => sales.year,
    //   measureFn: (LinearSales sales, _) => sales.sales,
    //   data: myFakeMobileData,
    // )
  ];
}

/// Sample linear data type.
class LinearSales {
  final DateTime year;
  final int sales;

  LinearSales(this.year, this.sales);
}
