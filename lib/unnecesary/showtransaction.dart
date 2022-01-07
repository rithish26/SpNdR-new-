import 'package:flutter/material.dart';

class Transactioninfo extends StatefulWidget {
  String title = "";
  String amount = "";
  String eori = "";
  String day = "";
  String date = "";
  String month = "";
  String year = "";
  String time = "";
  String note = "";
  Transactioninfo({
    required this.title,
    required this.amount,
    required this.eori,
    required this.day,
    required this.date,
    required this.month,
    required this.year,
    required this.time,
    required this.note,
  });
  @override
  _TransactioninfoState createState() => _TransactioninfoState();
}

class _TransactioninfoState extends State<Transactioninfo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(''),
      ),
    );
  }
}
