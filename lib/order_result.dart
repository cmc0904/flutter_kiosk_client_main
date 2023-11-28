import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

var db = FirebaseFirestore.instance;

String orderCollectionName = "cafe-order";

class OrderResult extends StatefulWidget {
  Map<dynamic, dynamic> orderResult;

  OrderResult({super.key, required this.orderResult});

  @override
  State<OrderResult> createState() => _OrderResultState();
}

class _OrderResultState extends State<OrderResult> {
  late Map<dynamic, dynamic> orderResult;

  Future<int> getOrderNumber() async {
    int number = 1;

    var s = DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
    );

    var today = Timestamp.fromDate(s);

    try {
      await db
          .collection(orderCollectionName)
          .where('orderTime', isGreaterThan: today)
          .orderBy('orderTime', descending: true)
          .limit(1)
          .get()
          .then(
        (value) {
          var data = value.docs[0];
          number = data['orderNumber'] + 1;
        },
      );
    } catch (e) {
      number = 1;
    }

    return number;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    orderResult = widget.orderResult;
    getOrderNumber();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Text(orderResult.toString()),
    );
  }
}
