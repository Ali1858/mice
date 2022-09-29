import 'package:d_chart/d_chart.dart';
import 'package:flutter/material.dart';

import 'home_page_test.dart';

class BarChart extends StatefulWidget {
  final Color color1;
  final Color color2;
  final List<Map<String, dynamic>> gData;
  const BarChart(
      {Key? key,
      required this.color1,
      required this.color2,
      required this.gData})
      : super(key: key);

  @override
  State<BarChart> createState() => _BarChartState();
}

class _BarChartState extends State<BarChart> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: DChartBar(
        data: widget.gData,
        yAxisTitle: 'Percentage',
        xAxisTitle: '',
        measureMin: 0,
        measureMax: 1,
        minimumPaddingBetweenLabel: 1,
        domainLabelPaddingToAxisLine: 16,
        domainLabelColor: containerBackgroundColor,
        barValueColor: containerBackgroundColor,
        measureLabelColor: containerBackgroundColor,
        xAxisTitleColor: containerBackgroundColor,
        borderColor: containerBackgroundColor,
        axisLineTick: 2,
        axisLinePointTick: 2,
        axisLinePointWidth: 10,
        axisLineColor: widget.color1,
        measureLabelPaddingToAxisLine: 16,
        barColor: (barData, index, id) =>
            id == 'Bar 1' ? widget.color1 : widget.color2,
        barValue: (barData, index) => '${barData['measure']}',
        showBarValue: true,
        animate: true,
        yAxisTitleColor: containerBackgroundColor,
        barValuePosition: BarValuePosition.outside,
        showDomainLine: true,
      ),
    );
  }
}
