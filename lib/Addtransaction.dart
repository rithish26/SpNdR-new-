import 'dart:async';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expenditure/dash.dart';
import 'package:expenditure/google_sheets.dart';
import 'package:expenditure/homepage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class Addtransaction extends StatefulWidget {
  late String refid;
  String sheetname;
  String username;
  int expense;
  int income;
  int total;
  Addtransaction(
      {required this.refid,
      required this.sheetname,
      required this.username,
      required this.expense,
      required this.income,
      required this.total});
  @override
  _AddtransactionState createState() => _AddtransactionState();
}

class _AddtransactionState extends State<Addtransaction>
    with TickerProviderStateMixin {
  final _textcontrollerAMOUNT = TextEditingController();
  final _textcontrollerITEM = TextEditingController();
  final _textcontrollerNOTE = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isIncome = false;
  late AnimationController controller1;
  late AnimationController controller2;
  late Animation<double> animation1;
  late Animation<double> animation2;
  late Animation<double> animation3;
  late Animation<double> animation4;
  func1() {
    setState(() {
      _isIncome = false;
    });
  }

  func2() {
    setState(() {
      _isIncome = true;
    });
  }

  void _enterTransaction() {
    /*  widget.gg.insert(
      _textcontrollerITEM.text,
      _textcontrollerAMOUNT.text,
      _isIncome,
      _textcontrollerNOTE.text,
    ); */
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller1 = AnimationController(
      vsync: this,
      duration: Duration(
        seconds: 5,
      ),
    );
    animation1 = Tween<double>(begin: .1, end: .15).animate(
      CurvedAnimation(
        parent: controller1,
        curve: Curves.easeInOut,
      ),
    )
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          controller1.reverse();
        } else if (status == AnimationStatus.dismissed) {
          controller1.forward();
        }
      });
    animation2 = Tween<double>(begin: .02, end: .04).animate(
      CurvedAnimation(
        parent: controller1,
        curve: Curves.easeInOut,
      ),
    )..addListener(() {
        setState(() {});
      });

    controller2 = AnimationController(
      vsync: this,
      duration: Duration(
        seconds: 5,
      ),
    );
    animation3 = Tween<double>(begin: .41, end: .38).animate(CurvedAnimation(
      parent: controller2,
      curve: Curves.easeInOut,
    ))
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          controller2.reverse();
        } else if (status == AnimationStatus.dismissed) {
          controller2.forward();
        }
      });
    animation4 = Tween<double>(begin: 170, end: 190).animate(
      CurvedAnimation(
        parent: controller2,
        curve: Curves.easeInOut,
      ),
    )..addListener(() {
        setState(() {});
      });

    Timer(Duration(milliseconds: 2500), () {
      controller1.forward();
    });

    controller2.forward();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    controller1.dispose();
    controller2.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Color(0xff192028),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(
          'N E W  T R A N S A C T I O N',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: SizedBox(
          height: size.height,
          child: Stack(
            children: [
              Positioned(
                top: size.height * (animation2.value + .58),
                left: size.width * .21,
                child: CustomPaint(
                  painter: MyPainter(50),
                ),
              ),
              Positioned(
                top: size.height * .98,
                left: size.width * .1,
                child: CustomPaint(
                  painter: MyPainter(animation4.value - 30),
                ),
              ),
              Positioned(
                top: size.height * .5,
                left: size.width * (animation2.value + .8),
                child: CustomPaint(
                  painter: MyPainter(30),
                ),
              ),
              Positioned(
                top: size.height * animation3.value,
                left: size.width * (animation1.value + .1),
                child: CustomPaint(
                  painter: MyPainter(60),
                ),
              ),
              Positioned(
                top: size.height * .1,
                left: size.width * .8,
                child: CustomPaint(
                  painter: MyPainter(animation4.value),
                ),
              ),
              SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10.0),
                              child: BackdropFilter(
                                filter: ImageFilter.blur(
                                  sigmaY: 50,
                                  sigmaX: 50,
                                ),
                                child: GestureDetector(
                                  onTap: func1,
                                  child: Container(
                                    height: 240,
                                    child: Center(
                                      child: Column(
                                        children: [
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Text(
                                            'Expense',
                                            style: TextStyle(
                                                color: _isIncome
                                                    ? Colors.white
                                                    : Colors.black,
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Container(
                                            child: Center(
                                              child: Image.asset(
                                                  'assets/expenses.png'),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    margin: EdgeInsets.all(5.0),
                                    decoration: BoxDecoration(
                                      color: _isIncome
                                          ? Colors.transparent
                                          : Colors.white,
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10.0),
                              child: BackdropFilter(
                                filter: ImageFilter.blur(
                                  sigmaY: 50,
                                  sigmaX: 50,
                                ),
                                child: GestureDetector(
                                  onTap: func2,
                                  child: Container(
                                    height: 240,
                                    child: Center(
                                      child: Column(
                                        children: [
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Text(
                                            'Income',
                                            style: TextStyle(
                                                color: _isIncome
                                                    ? Colors.black
                                                    : Colors.white,
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Container(
                                            child: Center(
                                              child: Image.asset(
                                                  'assets/income.png'),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    margin: EdgeInsets.all(5.0),
                                    decoration: BoxDecoration(
                                      color: _isIncome
                                          ? Colors.white
                                          : Colors.transparent,
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Form(
                      key: _formKey,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(
                            sigmaY: 10,
                            sigmaX: 10,
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(10),
                            child: TextFormField(
                              cursorColor: Colors.white,
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.all(20),
                                fillColor: Colors.transparent,
                                filled: true,
                                border: OutlineInputBorder(),
                                labelText: 'Amount',
                                labelStyle: TextStyle(color: Colors.white),
                                hintText: '₹',
                                hintStyle: TextStyle(
                                    fontSize: 20.0, color: Colors.white),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.white,
                                    width: 1,
                                  ),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.white,
                                    width: 1,
                                  ),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.allow(
                                    RegExp(r'[0-9]')),
                              ],
                              keyboardType: TextInputType.number,
                              validator: (text) {
                                if (text == null || text.isEmpty) {
                                  return 'Enter an amount';
                                }

                                return null;
                              },
                              controller: _textcontrollerAMOUNT,
                            ),
                          ),
                        ),
                      ),
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(
                          sigmaY: 10,
                          sigmaX: 10,
                        ),
                        child: Padding(
                          padding:
                              EdgeInsets.only(left: 10, right: 10, bottom: 10),
                          child: TextField(
                            cursorColor: Colors.white,
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.all(20),
                              fillColor: Colors.transparent,
                              filled: true,
                              border: OutlineInputBorder(),
                              labelText: 'For?',
                              labelStyle: TextStyle(color: Colors.white),
                              hintText: '',
                              hintStyle: TextStyle(
                                  fontSize: 20.0, color: Colors.white),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.white,
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.white,
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            controller: _textcontrollerITEM,
                          ),
                        ),
                      ),
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(
                          sigmaY: 10,
                          sigmaX: 10,
                        ),
                        child: Padding(
                          padding:
                              EdgeInsets.only(left: 10, right: 10, bottom: 10),
                          child: TextField(
                            maxLines: 2,
                            cursorColor: Colors.white,
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.all(20),
                              fillColor: Colors.transparent,
                              filled: true,
                              border: OutlineInputBorder(),
                              labelText: 'Note',
                              labelStyle: TextStyle(color: Colors.white),
                              hintText: '',
                              hintStyle: TextStyle(
                                  fontSize: 20.0, color: Colors.white),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.white,
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.white,
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            controller: _textcontrollerNOTE,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: 10),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: BackdropFilter(
                              filter: ImageFilter.blur(
                                sigmaY: 50,
                                sigmaX: 50,
                              ),
                              child: Container(
                                height: 50,
                                width: 100,
                                decoration: BoxDecoration(
                                    border: Border.all(color: Colors.white),
                                    borderRadius: BorderRadius.circular(20)),
                                child: TextButton(
                                  style: ButtonStyle(
                                    overlayColor:
                                        MaterialStateProperty.resolveWith(
                                      (states) => Colors.black12,
                                    ),
                                  ),
                                  onPressed: () async {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text(
                                    'Cancel',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 25,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 10),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: BackdropFilter(
                              filter: ImageFilter.blur(
                                sigmaY: 50,
                                sigmaX: 50,
                              ),
                              child: Container(
                                height: 50,
                                width: 200,
                                decoration: BoxDecoration(
                                    border: Border.all(color: Colors.white),
                                    borderRadius: BorderRadius.circular(20)),
                                child: TextButton(
                                  style: ButtonStyle(
                                    overlayColor:
                                        MaterialStateProperty.resolveWith(
                                      (states) => Colors.black12,
                                    ),
                                  ),
                                  onPressed: () {
                                    Future.delayed(Duration(milliseconds: 10),
                                        () {
                                      if (_formKey.currentState!.validate()) {
                                        DateTime now = new DateTime.now();
                                        String day =
                                            new DateFormat('EEEEE').format(now);
                                        String date =
                                            new DateFormat('d').format(now);
                                        String month =
                                            new DateFormat('MMM').format(now);
                                        String year =
                                            new DateFormat('yyyy').format(now);
                                        String time =
                                            new DateFormat('hh:mm').format(now);
                                        if (_textcontrollerAMOUNT.text == "" ||
                                            _textcontrollerITEM.text == "") {
                                          Alert(
                                                  type: AlertType.error,
                                                  style: AlertStyle(
                                                    backgroundColor:
                                                        Color(0xff192028),
                                                    overlayColor:
                                                        Colors.transparent,
                                                    animationType:
                                                        AnimationType.fromTop,
                                                    descStyle: TextStyle(
                                                      color: Colors.white,
                                                    ),
                                                    animationDuration: Duration(
                                                        milliseconds: 400),
                                                    alertBorder:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              30.0),
                                                      side: BorderSide(
                                                          color: Colors.white),
                                                    ),
                                                    titleStyle: TextStyle(
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                  context: context,
                                                  title: "Error",
                                                  desc:
                                                      "Amount or Title missing")
                                              .show();
                                          /*  showDialog(
                                      context: context,
                                      builder: (BuildContext context) =>
                                          _buildPopupDialog(context, "Sheetname empty"),
                                    ); */
                                        } else {
                                          final ref = FirebaseFirestore.instance
                                              .collection('userdata')
                                              .doc(FirebaseAuth
                                                  .instance.currentUser.uid)
                                              .collection('Sheets')
                                              .doc(widget.refid)
                                              .collection('Transactions')
                                              .doc();
                                          ref.set({
                                            "name": _textcontrollerITEM.text,
                                            "amount":
                                                _textcontrollerAMOUNT.text,
                                            "isincome": _isIncome,
                                            "day": day,
                                            "month": month,
                                            "year": year,
                                            "time": new DateTime.now(),
                                            "stringtime": time,
                                            "note": _textcontrollerNOTE.text,
                                            "refid": ref.id,
                                            "date": date,
                                          });
                                          final refe = FirebaseFirestore
                                              .instance
                                              .collection('userdata')
                                              .doc(FirebaseAuth
                                                  .instance.currentUser.uid)
                                              .collection('Sheets')
                                              .doc(widget.refid);

                                          refe.update({
                                            "expense": !_isIncome
                                                ? int.parse(
                                                        _textcontrollerAMOUNT
                                                            .text) +
                                                    widget.expense
                                                : widget.expense,
                                            "income": _isIncome
                                                ? int.parse(
                                                        _textcontrollerAMOUNT
                                                            .text) +
                                                    widget.income
                                                : widget.income,
                                            "total": _isIncome
                                                ? int.parse(
                                                        _textcontrollerAMOUNT
                                                            .text) +
                                                    widget.total
                                                : widget.total -
                                                    int.parse(
                                                        _textcontrollerAMOUNT
                                                            .text),
                                          });
                                          /* final refe = FirebaseFirestore.instance
                                      .collection('USERS')
                                      .doc(FirebaseAuth.instance.currentUser.uid)
                                      .collection("sheetids")
                                      .doc(ref.id)
                                      .collection('Sheets')
                                      .doc();
                                  refe.set(
                                      {"Sheetname": _sheetname.text, "Refid": refe.id}); */
                                          Navigator.pushAndRemoveUntil(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => HomePage(
                                                    sheetname: widget.sheetname,
                                                    username: widget.username,
                                                    refid: widget.refid)),
                                            (Route<dynamic> route) => false,
                                          );
                                        }
                                      }
                                    });
                                  },
                                  child: Text(
                                    'Enter',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 25,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        /*  Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20)),
                          child: TextButton(
                            style: ButtonStyle(
                              overlayColor: MaterialStateProperty.resolveWith(
                                (states) => Colors.black12,
                              ),
                            ),
                            child: Text('Cancel',
                                style: TextStyle(color: Colors.black)),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20)),
                          child: TextButton(
                            style: ButtonStyle(
                              overlayColor: MaterialStateProperty.resolveWith(
                                (states) => Colors.black12,
                              ),
                            ),
                            child: Text('Enter',
                                style: TextStyle(color: Colors.black)),
                            onPressed: () {
                              Future.delayed(Duration(milliseconds: 10), () {
                                if (_formKey.currentState!.validate()) {
                                  DateTime now = new DateTime.now();
                                  String day =
                                      new DateFormat('EEEEE').format(now);
                                  String date = new DateFormat('d').format(now);
                                  String month =
                                      new DateFormat('MMM').format(now);
                                  String year =
                                      new DateFormat('yyyy').format(now);
                                  String time =
                                      new DateFormat('hh:mm').format(now);
                                  if (_textcontrollerNOTE.text == "" ||
                                      _textcontrollerAMOUNT.text == "" ||
                                      _textcontrollerITEM.text == "") {
                                    Alert(
                                            context: context,
                                            title: "Error",
                                            desc: "Sheetname empty")
                                        .show();
                                    /*  showDialog(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      _buildPopupDialog(context, "Sheetname empty"),
                                ); */
                                  } else {
                                    final ref = FirebaseFirestore.instance
                                        .collection('userdata')
                                        .doc(
                                            FirebaseAuth.instance.currentUser.uid)
                                        .collection('Sheets')
                                        .doc(widget.refid)
                                        .collection('Transactions')
                                        .doc();
                                    ref.set({
                                      "name": _textcontrollerITEM.text,
                                      "amount": _textcontrollerAMOUNT.text,
                                      "isincome": _isIncome,
                                      "day": day,
                                      "month": month,
                                      "year": year,
                                      "time": new DateTime.now(),
                                      "stringtime": time,
                                      "note": _textcontrollerNOTE.text,
                                      "refid": ref.id,
                                      "date": date,
                                    });
                                    final refe = FirebaseFirestore.instance
                                        .collection('userdata')
                                        .doc(
                                            FirebaseAuth.instance.currentUser.uid)
                                        .collection('Sheets')
                                        .doc(widget.refid);
              
                                    refe.update({
                                      "expense": !_isIncome
                                          ? int.parse(
                                                  _textcontrollerAMOUNT.text) +
                                              widget.expense
                                          : widget.expense,
                                      "income": _isIncome
                                          ? int.parse(
                                                  _textcontrollerAMOUNT.text) +
                                              widget.income
                                          : widget.income,
                                      "total": _isIncome
                                          ? int.parse(
                                                  _textcontrollerAMOUNT.text) +
                                              widget.total
                                          : widget.total -
                                              int.parse(
                                                  _textcontrollerAMOUNT.text),
                                    });
                                    /* final refe = FirebaseFirestore.instance
                                  .collection('USERS')
                                  .doc(FirebaseAuth.instance.currentUser.uid)
                                  .collection("sheetids")
                                  .doc(ref.id)
                                  .collection('Sheets')
                                  .doc();
                              refe.set(
                                  {"Sheetname": _sheetname.text, "Refid": refe.id}); */
                                    Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => HomePage(
                                              sheetname: widget.sheetname,
                                              username: widget.username,
                                              refid: widget.refid)),
                                      (Route<dynamic> route) => false,
                                    );
                                  }
                                }
                              });
                            },
                          ),
                        ) */
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
