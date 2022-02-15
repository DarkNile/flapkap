import 'package:flapkap/order.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class Chart extends StatefulWidget {
  final List<Order>? data;
  const Chart({Key? key, @required this.data}) : super(key: key);

  @override
  _ChartState createState() => _ChartState();
}

class _ChartState extends State<Chart> {
  List<charts.Series<Order, String>>? series;

  @override
  void initState() {
    super.initState();
    series = [
      charts.Series(
          id: "orders",
          data: widget.data!,
          domainFn: (Order series, _) => series.registeredAt!,
          measureFn: (Order series, _) => series.orderNumber!,
          colorFn: (Order series, _) => series.barColor!)
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Chart'),
        backgroundColor: Colors.indigo[900],
      ),
      body: SizedBox(
        height: 300,
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text(
                  "Orders",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                Expanded(
                  child: charts.BarChart(
                    series!,
                    animate: true,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
