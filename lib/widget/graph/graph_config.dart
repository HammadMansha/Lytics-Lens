import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class CustomColumnSeriesRenderer extends ColumnSeriesRenderer {
  CustomColumnSeriesRenderer();

  @override
  ChartSegment createSegment() {
    return _ColumnCustomPainter();
  }
}

class _ColumnCustomPainter extends ColumnSegment {
  List<Color> colorList = <Color>[
    const Color.fromRGBO(53, 92, 125, 1),
    const Color.fromRGBO(192, 108, 132, 1),
    const Color.fromRGBO(246, 114, 128, 1),
    const Color.fromRGBO(248, 177, 149, 1),
    const Color.fromRGBO(116, 180, 155, 1),
    const Color.fromRGBO(116, 180, 155, 1),
    const Color.fromRGBO(116, 180, 155, 1),
    const Color.fromRGBO(116, 180, 155, 1),
    const Color.fromRGBO(116, 180, 155, 1),
    const Color.fromRGBO(116, 180, 155, 1),
    const Color.fromRGBO(116, 180, 155, 1),
    const Color.fromRGBO(116, 180, 155, 1),
    const Color.fromRGBO(116, 180, 155, 1),
  ];

  @override
  int get currentSegmentIndex => super.currentSegmentIndex!;

  @override
  Paint getFillPaint() {
    final Paint customerFillPaint = Paint();
    customerFillPaint.isAntiAlias = false;
    customerFillPaint.color = colorList[currentSegmentIndex];
    customerFillPaint.style = PaintingStyle.fill;
    return customerFillPaint;
  }

  @override
  Paint getStrokePaint() {
    final Paint customerStrokePaint = Paint();
    customerStrokePaint.isAntiAlias = false;
    customerStrokePaint.color = Colors.transparent;
    customerStrokePaint.style = PaintingStyle.stroke;
    return customerStrokePaint;
  }

  @override
  void onPaint(Canvas canvas) {
    double x, y;
    x = segmentRect.center.dx;
    y = segmentRect.top;
    double width = 0;
    const double height = 20;
    width = segmentRect.width;
    final Paint paint = Paint();
    paint.color = getFillPaint().color;
    paint.style = PaintingStyle.fill;
    final Path path = Path();
    final double factor = segmentRect.height * (1 - animationFactor);
    path.moveTo(x - width / 2, y + factor + height);
    path.lineTo(x, (segmentRect.top + factor + height) - height);
    path.lineTo(x + width / 2, y + factor + height);
    path.lineTo(x + width / 2, segmentRect.bottom + factor);
    path.lineTo(x - width / 2, segmentRect.bottom + factor);
    path.close();
    canvas.drawPath(path, paint);
  }
}
