import 'package:fire_monitor_alex/main.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:fire_monitor_alex/view/components/item_chart_text.dart';
import '../../model/chart_point.dart';

class LineChartW extends StatefulWidget {
  const LineChartW({Key? key, required this.pointsT, required this.pointsH})
      : super(key: key);

  final List<ChartPoint> pointsT;
  final List<ChartPoint> pointsH;

  @override
  State<LineChartW> createState() => _LineChartState();
}

class _LineChartState extends State<LineChartW> {
  List<Color> gradientColors = [
    const Color(0xff23b6e6),
    const Color(0xff02d39a),
  ];

  bool showT = true;
  bool showH = true;

  @override
  Widget build(BuildContext context) {
    //First, the input points must be converted into input points to be,
    //displayed in the chart.
    final List<FlSpot> temperaturePoints = List<FlSpot>.from(
        widget.pointsT.map((e) => FlSpot(e.coordinate, e.value)));
    final List<FlSpot> humidityPoints = List<FlSpot>.from(
        widget.pointsH.map((e) => FlSpot(e.coordinate, e.value)));
    return Stack(
      children: <Widget>[
        AspectRatio(
          aspectRatio: 1.40,
          child: Container(
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(13),
                ),
                color: Color(0xff232d37)),
            //color: Colors.white),
            child: Padding(
              padding: const EdgeInsets.only(
                  right: 18.0, left: 12.0, top: 50, bottom: 12),
              child: LineChart(
                data(humidityPoints, temperaturePoints),
              ),
            ),
          ),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'T(ºC)',
                  style: TextStyle(color: Color(0xff67727d)),
                ),
                const SizedBox(
                  width: 30,
                ),
                ItemChartText(
                    enabled: showH,
                    text: 'Humidity',
                    pressedCallback: () => {
                          setState(() {
                            showH = !showH;
                          }),
                        }),
                const SizedBox(
                  width: 10,
                ),
                ItemChartText(
                    enabled: showT,
                    text: 'Temperature',
                    pressedCallback: () => {
                          setState(() {
                            showT = !showT;
                          }),
                        }),
                const SizedBox(
                  width: 30,
                ),
                const Text(
                  'H(%)',
                  style: TextStyle(color: Color(0xff67727d)),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Color(0xff68737d),
      fontWeight: FontWeight.bold,
      fontSize: 16,
    );
    Widget text;
    switch (value.toInt()) {
      case 0:
        text = const Text('00:00', style: style);
        break;
      case 1:
        text = const Text('6am', style: style);
        break;
      case 6:
        text = const Text('12:00', style: style);
        break;
      case 3:
        text = const Text('6pm', style: style);
        break;
      case 12:
        text = const Text('24:00', style: style);
        break;
      default:
        text = const Text('12pm', style: style);
        break;
    }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 8.0,
      child: text,
    );
  }

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Color(0xff67727d),
      fontWeight: FontWeight.bold,
      fontSize: 15,
    );
    String text;
    switch (value.toInt()) {
      case 0:
        text = '  0';
        break;
      case 50:
        text = ' 50';
        break;
      case 100:
        text = '100';
        break;
      case 150:
        text = '150';
        break;
      default:
        return Container();
    }

    return Text(text, style: style, textAlign: TextAlign.left);
  }

  Widget rightTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Color(0xff67727d),
      fontWeight: FontWeight.bold,
      fontSize: 15,
    );
    String text;
    switch (value.toInt()) {
      case 0:
        text = '   0';
        break;
      case 75:
        text = '  50';
        break;
      case 150:
        text = ' 100';
        break;
      default:
        return Container();
    }

    return Text(text, style: style, textAlign: TextAlign.left);
  }

  LineChartData data(
      List<FlSpot> temperaturePoints, List<FlSpot> humidityPoints) {
    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: false,
        horizontalInterval: 50,
        verticalInterval: 5,
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: const Color(0xff37434d),
            strokeWidth: 1,
          );
        },
        getDrawingVerticalLine: (value) {
          return FlLine(
            color: const Color(0xff37434d),
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 42,
            interval: 25,
            getTitlesWidget: rightTitleWidgets,
          ),
        ),
        topTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            interval: 6,
            getTitlesWidget: bottomTitleWidgets,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval:
                50, //This is used when iterating over the indexes to get the vertical lables
            getTitlesWidget: leftTitleWidgets,
            reservedSize: 42,
          ),
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: Border.all(color: const Color(0xff37434d), width: 1),
      ),
      minX: 0, //Limits of the chart
      maxX: 12,
      minY: 0,
      maxY: 150,
      lineBarsData: [
        LineChartBarData(
          spots: showT
              ? temperaturePoints
              : [], //The list created from the T input points
          isCurved: true,
          gradient: LinearGradient(
            colors: gradientColors,
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          barWidth: 2,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: true,
          ),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors: gradientColors
                  .map((color) => color.withOpacity(0.3))
                  .toList(),
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
          ),
        ),
        LineChartBarData(
          spots: showH
              ? humidityPoints
              : [], //The list created from the input H points
          isCurved: true,
          gradient: LinearGradient(
            colors: gradientColors,
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          barWidth: 2,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: true,
          ),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors: gradientColors
                  .map((color) => color.withOpacity(0.3))
                  .toList(),
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
          ),
        ),
      ],
    );
  }
}
