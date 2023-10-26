import 'package:flutter/material.dart';
import 'package:lytics_lens/Models/simplechartmodel.dart';
import 'package:lytics_lens/widget/graph/graph_config.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class TopicGraph extends StatelessWidget {
  const TopicGraph({Key? key, required this.dataSource}) : super(key: key);

  final List<ChartSampleData> dataSource;

  @override
  Widget build(BuildContext context) {
    return SfCartesianChart(
      title: ChartTitle(text: ''),
      primaryXAxis: CategoryAxis(
        labelStyle: const TextStyle(fontSize: 8),
        majorGridLines: const MajorGridLines(width: 0),
      ),
      primaryYAxis: NumericAxis(
          labelFormat: '{value}',
          title: AxisTitle(text: ''),
          majorGridLines: const MajorGridLines(width: 0),
          majorTickLines: const MajorTickLines(size: 0)),
      series: <ChartSeries<ChartSampleData, String>>[
        ColumnSeries<ChartSampleData, String>(
          onCreateRenderer: (ChartSeries<ChartSampleData, String> series) {
            return CustomColumnSeriesRenderer();
          },
          dataLabelSettings: const DataLabelSettings(
              isVisible: false, labelAlignment: ChartDataLabelAlignment.middle),
          dataSource: dataSource,
          // <ChartSampleData>[
          //   ChartSampleData(
          //       x: 'HP Inc',
          //       y: 12.54,
          //       pointColor: const Color.fromARGB(53, 92, 125, 1)),
          //   ChartSampleData(
          //       x: 'Lenovo',
          //       y: 13.46,
          //       pointColor: const Color.fromARGB(192, 108, 132, 1)),
          //   ChartSampleData(
          //       x: 'Dell',
          //       y: 9.18,
          //       pointColor: const Color.fromARGB(246, 114, 128, 1)),
          //   ChartSampleData(
          //       x: 'Apple',
          //       y: 4.56,
          //       pointColor: const Color.fromARGB(248, 177, 149, 1)),
          //   ChartSampleData(
          //       x: 'Asus',
          //       y: 5.29,
          //       pointColor: const Color.fromARGB(116, 180, 155, 1)),
          // ],
          width: 0.8,
          xValueMapper: (ChartSampleData sales, _) => sales.x as String,
          yValueMapper: (ChartSampleData sales, _) => sales.y,
          pointColorMapper: (ChartSampleData sales, _) => sales.pointColor,
        )
      ],
      tooltipBehavior:
          TooltipBehavior(enable: true, canShowMarker: false, header: ''),
    );
  }
}
