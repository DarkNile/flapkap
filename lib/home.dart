import 'dart:convert';
import 'package:flapkap/chart.dart';
import 'package:flapkap/order.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<dynamic> data = [];
  List<dynamic> orders = [];
  List<double> prices = [];
  List<Order> ordersData = [];
  int totalCount = 0;
  double totalPrice = 0;
  double averagePrice = 0;
  int numberOfReturns = 0;

  Future<List<dynamic>> getOrders() async {
    final String response = await rootBundle.loadString('assets/orders.json');
    data = await json.decode(response);
    return data;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('FlapKap'),
          backgroundColor: Colors.indigo[900],
          leading: IconButton(
              onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => Chart(
                        data: ordersData,
                      ))),
              icon: const Icon(Icons.bar_chart)),
        ),
        body: FutureBuilder<List<dynamic>>(
            future: getOrders(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                orders = snapshot.data!;
                totalCount = orders.length;
                prices = [];
                data = [];
                for (int i = 0; i < orders.length; i++) {
                  prices.add(double.parse(orders[i]['price']
                      .toString()
                      .substring(1)
                      .replaceAll(',', '')));
                  ordersData.add(Order(
                      orderNumber: i + 1,
                      registeredAt: DateTime.parse(orders[i]['registered'])
                          .toString()
                          .substring(10, 19),
                      barColor: charts.ColorUtil.fromDartColor(Colors.blue)));
                }
                totalPrice = prices.reduce((a, b) => a + b);
                averagePrice = totalPrice / totalCount;
                numberOfReturns = orders
                    .where((order) => order['status'] == 'RETURNED')
                    .length;
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SizedBox(
                        width: 200,
                        height: 100,
                        child: Card(
                            elevation: 10,
                            color: Colors.purple[900],
                            child: Center(
                              child: Text(
                                'Total Count: $totalCount',
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            )),
                      ),
                      SizedBox(
                          width: 200,
                          height: 100,
                          child: Card(
                              elevation: 10,
                              color: Colors.green[900],
                              child: Center(
                                  child: Text(
                                'Average Price: ${averagePrice.toStringAsFixed(2)}',
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                ),
                              )))),
                      SizedBox(
                          width: 200,
                          height: 100,
                          child: Card(
                              color: Colors.red[900],
                              elevation: 10,
                              child: Center(
                                  child: Text(
                                'Number of Returns: $numberOfReturns',
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                ),
                              )))),
                    ],
                  ),
                );
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            }));
  }
}
