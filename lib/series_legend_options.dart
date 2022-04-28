import 'dart:math';

import 'package:charts_common/common.dart' as common;
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

const Color blueColor = Color(0xff1565C0);
const Color orangeColor = Color(0xffFFA000);

class LegendOptions extends StatelessWidget {
  final List<charts.Series> seriesList;
  static const secondaryMeasureAxisId = 'secondaryMeasureAxisId';
  final bool animate;

  LegendOptions(this.seriesList, {this.animate});

  factory LegendOptions.withSampleData() {
    return LegendOptions(
      _createSampleData(),
      // Disable animations for image tests.
      animate: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return charts.BarChart(
      seriesList,
      animate: animate,
      barGroupingType: charts.BarGroupingType.grouped,
      defaultRenderer: charts.BarRendererConfig(
          cornerStrategy: const charts.ConstCornerStrategy(50)),
      primaryMeasureAxis: charts.NumericAxisSpec(
        tickProviderSpec: charts.BasicNumericTickProviderSpec(
          desiredMinTickCount: 6,
          desiredMaxTickCount: 10,
        ),
      ),
      secondaryMeasureAxis: charts.NumericAxisSpec(
          tickProviderSpec: charts.BasicNumericTickProviderSpec(
              desiredTickCount: 6, desiredMaxTickCount: 10)),
      selectionModels: [
        charts.SelectionModelConfig(
            changedListener: (charts.SelectionModel model) {
          if (model.hasDatumSelection)
            print(model.selectedSeries[0]
                .measureFn(model.selectedDatum[0].index));
        })
      ],
      behaviors: [
        charts.SeriesLegend.customLayout(
          CustomLegendBuilder(),
          position: charts.BehaviorPosition.top,
          outsideJustification: charts.OutsideJustification.start,
        ),
      ],
    );
  }

  static List<charts.Series<OrdinalSales, String>> _createSampleData() {
    final desktopSalesData = [
      OrdinalSales('2/14', 29),
      OrdinalSales('2/15', 25),
      OrdinalSales('2/16', 100),
      OrdinalSales('2/17', 75),
      OrdinalSales('2/18', 70),
      OrdinalSales('2/19', 70),
    ];

    final tabletSalesData = [
      OrdinalSales('2/14', 10),
      OrdinalSales('2/15', 25),
      OrdinalSales('2/16', 8),
      OrdinalSales('2/17', 20),
      OrdinalSales('2/18', 38),
      OrdinalSales('2/19', 70),
    ];

    return [
      charts.Series<OrdinalSales, String>(
          id: 'expense',
          domainFn: (OrdinalSales sales, _) => sales.year,
          measureFn: (OrdinalSales sales, _) => sales.sales,
          data: desktopSalesData,
          colorFn: (_, __) => charts.ColorUtil.fromDartColor(orangeColor),
          labelAccessorFn: (OrdinalSales sales, _) =>
              'expense: ${sales.sales.toString()}',
          displayName: "Expense"),
      charts.Series<OrdinalSales, String>(
        id: 'income',
        domainFn: (OrdinalSales sales, _) => sales.year,
        measureFn: (OrdinalSales sales, _) => sales.sales,
        data: tabletSalesData,
        colorFn: (_, __) => charts.ColorUtil.fromDartColor(blueColor),
        displayName: "Income",
      )..setAttribute(charts.measureAxisIdKey, secondaryMeasureAxisId),
    ];
  }
}

//Here is my CustomLegendBuilder

/// Custom legend builder
class CustomLegendBuilder extends charts.LegendContentBuilder {
  /// Convert the charts common TextStlyeSpec into a standard TextStyle.
  TextStyle _convertTextStyle(
      bool isHidden, BuildContext context, common.TextStyleSpec textStyle) {
    return TextStyle(
        inherit: true,
        fontFamily: textStyle?.fontFamily,
        fontSize:
            textStyle?.fontSize != null ? textStyle.fontSize.toDouble() : null,
        color: Colors.white);
  }

  Widget createLabel(BuildContext context, common.LegendEntry legendEntry,
      common.SeriesLegend legend, bool isHidden) {
    TextStyle style =
        _convertTextStyle(isHidden, context, legendEntry.textStyle);
    Color color =
        charts.ColorUtil.toDartColor(legendEntry.color) ?? Colors.blue;

    return GestureDetector(
        child: Container(
            height: 30,
            width: 90,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: isHidden ? (color).withOpacity(0.26) : color,
            ),
            child: Center(child: Text(legendEntry.label, style: style))),
        onTapUp: makeTapUpCallback(context, legendEntry, legend));
  }

  GestureTapUpCallback makeTapUpCallback(BuildContext context,
      common.LegendEntry legendEntry, common.SeriesLegend legend) {
    return (TapUpDetails d) {
      switch (legend.legendTapHandling) {
        case common.LegendTapHandling.hide:
          final seriesId = legendEntry.series.id;
          if (legend.isSeriesHidden(seriesId)) {
            // This will not be recomended since it suposed to be accessible only from inside the legend class, but it worked fine on my code.
            legend.showSeries(seriesId);
          } else {
            legend.hideSeries(seriesId);
          }
          legend.chart.redraw(skipLayout: true, skipAnimation: false);
          break;
        case common.LegendTapHandling.none:
        default:
          break;
      }
    };
  }

  @override
  Widget build(BuildContext context, common.LegendState legendState,
      common.Legend legend,
      {bool showMeasures}) {
    final entryWidgets = legendState.legendEntries.map((legendEntry) {
      var isHidden = false;
      if (legend is common.SeriesLegend) {
        isHidden = legend.isSeriesHidden(legendEntry.series.id);
      }
      return createLabel(
          context, legendEntry, legend as common.SeriesLegend, isHidden);
    }).toList();

    return Padding(
      padding: const EdgeInsets.only(right: 40.0, top: 10),
      child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: entryWidgets),
    );
  }
}

////////////////////////////////

class OrdinalSales {
  final String year;
  final int sales;

  OrdinalSales(this.year, this.sales);
}
