import 'package:flutter/foundation.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class Order {
  final int? orderNumber;
  final String? registeredAt;
  final charts.Color? barColor;
  Order(
      {@required this.orderNumber,
      @required this.registeredAt,
      @required this.barColor});
}
