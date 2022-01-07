import 'dart:async';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expenditure/Addtransaction.dart';
import 'package:expenditure/dash.dart';
import 'package:expenditure/gs.dart';
import 'package:expenditure/loadingcircle.dart';
import 'package:expenditure/unnecesary/plus_button.dart';
import 'package:expenditure/searchservice.dart';
import 'package:expenditure/top_card.dart';
import 'package:expenditure/transaction.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import 'chart.dart';
import 'google_sheets.dart';

class HomePage extends StatefulWidget {
  String sheetname = "";
  String refid = "";
  String username = "";
  HomePage(
      {required this.sheetname, required this.username, required this.refid});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _textcontrollerAMOUNT = TextEditingController();
  final _textcontrollerITEM = TextEditingController();
  final _textcontrollerNOTE = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isIncome = false;
  int income = 0;
  int expense = 0;
  int total = 0;
  var queryResultSet = [];
  var tempsearchstore = [];
  final FirebaseAuth auth = FirebaseAuth.instance;

  initiateSearch() {
    queryResultSet = [];
    tempsearchstore = [];

    SearchService().searchByt(widget.refid).then((QuerySnapshot docse) {
      for (int i = 0; i < docse.docs.length; ++i) {
        queryResultSet.add(docse.docs[i].data());
        setState(() {
          print(queryResultSet[i]);
          tempsearchstore.add(queryResultSet[i]);
        });
      }
    });
  }

  getdata() {
    FirebaseFirestore.instance
        .collection('userdata')
        .doc(FirebaseAuth.instance.currentUser.uid)
        .collection('Sheets')
        .doc(widget.refid)
        .get()
        .then((value) {
      setState(() {
        income = value['income'];
        expense = value['expense'];
        total = value['total'];
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initiateSearch();
    getdata();
    print(widget.sheetname);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
  // enter the new transaction into the spreadsheet
  /*  void _enterTransaction() {
    gg.insert(
      _textcontrollerITEM.text,
      _textcontrollerAMOUNT.text,
      _isIncome,
      _textcontrollerNOTE.text,
    );
    setState(() {});
  } */

  void _newTransaction() {}

  /*  bool timerHasStarted = false;
  void startLoading() {
    timerHasStarted = true;
    Timer.periodic(Duration(seconds: 1), (timer) {
      if (gg.loading == false) {
        setState(() {});
        timer.cancel();
      }
    });
  }
 */

  @override
  Widget build(BuildContext context) {
    /*    if (gg.loading == true && timerHasStarted == false) {
      startLoading();
    } */
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => Addtransaction(
                income: income,
                expense: expense,
                total: total,
                sheetname: widget.sheetname,
                username: widget.username,
                refid: widget.refid,
              ),
            ),
          );
          /*  _textcontrollerITEM.clear();
          _textcontrollerAMOUNT.clear();
          _isIncome = false;
          _textcontrollerNOTE.clear();
          _newTransaction();
          /* Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => Addtransaction(
                gg: gg,
              ),
            ), 
          );*/ */
        },
        child: Icon(
          Icons.add,
          color: Colors.orange,
          size: 30.0,
        ),
        backgroundColor: Colors.black,
      ),
      backgroundColor: Color(0xff192028),
      appBar: AppBar(
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Color(0xff192028),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_outlined),
          onPressed: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => Dash()),
              (Route<dynamic> route) => false,
            );
          },
        ),
        title: Column(children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
                child: Text('Welcome',
                    style: TextStyle(color: Colors.white, fontSize: 15))),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
                child: Text('$username!!',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 25,
                        fontWeight: FontWeight.bold))),
          ),
        ]),
        actions: [],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TopNeuCard(
                balance: '$total',
                //(gg.calculateIncome() - gg.calculateExpense()).toString(),
                income: '$income', //gg.calculateIncome().toString(),
                expense: '$expense' //gg.calculateExpense().toString(),
                ),
            SizedBox(
              height: 20,
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                  child: Text('Transactions..',
                      style: TextStyle(color: Colors.white, fontSize: 25))),
            ),
            Expanded(
              child: ListView(
                  padding: EdgeInsets.only(top: 20),
                  primary: true,
                  shrinkWrap: true,
                  children: tempsearchstore.map((element) {
                    return buildResultCard(
                        context,
                        element,
                        widget.refid,
                        expense,
                        income,
                        total,
                        widget.sheetname,
                        widget.username);
                  }).toList()),
            ),
          ],
        ),
      ),
      bottomNavigationBar: ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaY: 100,
            sigmaX: 100,
          ),
          child: BottomAppBar(
            shape: CircularNotchedRectangle(),
            color: Colors.black,
            child: IconTheme(
              data:
                  IconThemeData(color: Theme.of(context).colorScheme.onPrimary),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  IconButton(
                    tooltip: 'Log out',
                    icon: const Icon(
                      Icons.analytics,
                      color: Colors.blue,
                      size: 30,
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => Chart(widget.refid)),
                      );
                    },
                  ),
                  /* IconButton(
                      tooltip: 'Add',
                      icon: const Icon(
                        Icons.add,
                        color: Colors.orange,
                        size: 30,
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Addsheet(
                                    sheetid: sheetid,
                                  )),
                        );
                      },
                    ), */

                  IconButton(
                    tooltip: 'Edit Profile',
                    icon: const Icon(
                      Icons.archive_rounded,
                      color: Colors.green,
                      size: 30,
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => Gs(refid: widget.refid)),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

Widget buildResultCard(BuildContext context, data, String refid, int expense,
    int income, int total, String sheetname, String username) {
  final _textcontrollerAMOUNT = TextEditingController();
  final _textcontrollerITEM = TextEditingController();
  final _textcontrollerNOTE = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isIncome = data['isincome'];
  bool nonchangeable = data['isincome'];
  _textcontrollerAMOUNT.text = data['amount'];
  _textcontrollerITEM.text = data['name'];
  _textcontrollerNOTE.text = data['note'];
  func1() {
    _isIncome = false;
  }

  func2() {
    _isIncome = true;
  }

  return Padding(
    padding: const EdgeInsets.only(bottom: 12.0),
    child: ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GestureDetector(
        onLongPress: () {
          showDialog(
              barrierDismissible: true,
              context: context,
              builder: (BuildContext context) {
                return StatefulBuilder(
                  builder: (BuildContext context, setState) {
                    return AlertDialog(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(32.0)),
                          side: BorderSide(color: Colors.white)),
                      backgroundColor: Color(0xff192028),
                      title: Text(
                        'T R A N S A C T I O N',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      content: SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(
                                  'Expense',
                                  style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                                Switch(
                                  activeTrackColor: Colors.white,
                                  hoverColor: Colors.white,
                                  focusColor: Colors.white,
                                  inactiveThumbColor: Colors.white,
                                  value: _isIncome,
                                  onChanged: (newValue) {
                                    setState(() {
                                      _isIncome = newValue;
                                    });
                                  },
                                ),
                                Text('Income',
                                    style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold)),
                              ],
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Row(
                              children: [
                                SizedBox(
                                  width: 2,
                                ),
                                Expanded(
                                  child: TextField(
                                    cursorColor: Colors.white,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                    ),
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.all(20),
                                      fillColor: Color(0xff192028),
                                      filled: true,
                                      border: OutlineInputBorder(),
                                      labelText: 'For?',
                                      labelStyle:
                                          TextStyle(color: Colors.white),
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
                              ],
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: Form(
                                    key: _formKey,
                                    child: TextFormField(
                                      cursorColor: Colors.white,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                      ),
                                      decoration: InputDecoration(
                                        contentPadding: EdgeInsets.all(20),
                                        fillColor: Color(0xff192028),
                                        filled: true,
                                        border: OutlineInputBorder(),
                                        labelText: 'Ammount',
                                        labelStyle:
                                            TextStyle(color: Colors.white),
                                        hintText: '₹',
                                        hintStyle: TextStyle(
                                            fontSize: 20.0,
                                            color: Colors.white),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Colors.white,
                                            width: 1,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Colors.white,
                                            width: 1,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                      ),
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
                              ],
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: TextField(
                                    maxLines: 3,
                                    cursorColor: Colors.white,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                    ),
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.all(20),
                                      fillColor: Color(0xff192028),
                                      filled: true,
                                      border: OutlineInputBorder(),
                                      labelText: 'Note',
                                      labelStyle:
                                          TextStyle(color: Colors.white),
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
                              ],
                            ),
                          ],
                        ),
                      ),
                      actions: <Widget>[
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
                            child: Text('Update',
                                style: TextStyle(color: Colors.black)),
                            onPressed: () {
                              if (_textcontrollerITEM.text == "" ||
                                  _textcontrollerAMOUNT.text == "") {
                                Alert(
                                        type: AlertType.error,
                                        style: AlertStyle(
                                          backgroundColor: Color(0xff192028),
                                          overlayColor: Colors.transparent,
                                          animationType: AnimationType.fromTop,
                                          descStyle: TextStyle(
                                            color: Colors.white,
                                          ),
                                          animationDuration:
                                              Duration(milliseconds: 400),
                                          alertBorder: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(30.0),
                                            side:
                                                BorderSide(color: Colors.white),
                                          ),
                                          titleStyle: TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                        context: context,
                                        title: "Error",
                                        desc: "Feilds empty")
                                    .show();
                              } else {
                                print('yo');
                                final refe = FirebaseFirestore.instance
                                    .collection('userdata')
                                    .doc(FirebaseAuth.instance.currentUser.uid)
                                    .collection('Sheets')
                                    .doc(refid);

                                print(income);
                                final ref = FirebaseFirestore.instance
                                    .collection('userdata')
                                    .doc(FirebaseAuth.instance.currentUser.uid)
                                    .collection('Sheets')
                                    .doc(refid)
                                    .collection('Transactions')
                                    .doc(data['refid']);
                                ref.update(
                                  {
                                    "name": _textcontrollerITEM.text,
                                    "amount": _textcontrollerAMOUNT.text,
                                    "isincome": _isIncome,
                                    "note": _textcontrollerNOTE.text,
                                    "refid": ref.id,
                                  },
                                );
                                if (!_isIncome && !nonchangeable) {
                                  expense =
                                      int.parse(_textcontrollerAMOUNT.text) +
                                          expense -
                                          int.parse(data['amount']);
                                  total = total -
                                      int.parse(_textcontrollerAMOUNT.text) +
                                      int.parse(data['amount']);
                                } else if (_isIncome && nonchangeable) {
                                  income =
                                      int.parse(_textcontrollerAMOUNT.text) +
                                          income -
                                          int.parse(data['amount']);
                                  total =
                                      int.parse(_textcontrollerAMOUNT.text) +
                                          total -
                                          int.parse(data['amount']);
                                } else if (!_isIncome && nonchangeable) {
                                  expense = expense +
                                      int.parse(_textcontrollerAMOUNT.text);
                                  income = income - int.parse(data['amount']);
                                  total = income - expense;
                                } else if (_isIncome && !nonchangeable) {
                                  expense = expense - int.parse(data['amount']);
                                  income = income +
                                      int.parse(_textcontrollerAMOUNT.text);
                                  total = income - expense;
                                }
                                print('yo again');
                                refe.update({
                                  "expense": expense,
                                  "income": income,
                                  "total": total,
                                });
                                print(income);
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
                                          sheetname: sheetname,
                                          username: username,
                                          refid: refid)),
                                  (Route<dynamic> route) => false,
                                );
                              }
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
                            child: Text('Delete',
                                style: TextStyle(color: Colors.black)),
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                final refe = FirebaseFirestore.instance
                                    .collection('userdata')
                                    .doc(FirebaseAuth.instance.currentUser.uid)
                                    .collection('Sheets')
                                    .doc(refid);

                                refe.update({
                                  "expense": !nonchangeable
                                      ? expense - int.parse(data['amount'])
                                      : expense,
                                  "income": nonchangeable
                                      ? income - int.parse(data['amount'])
                                      : income,
                                  "total": nonchangeable
                                      ? total - int.parse(data['amount'])
                                      : total + int.parse(data['amount']),
                                });
                                final ref = FirebaseFirestore.instance
                                    .collection('userdata')
                                    .doc(FirebaseAuth.instance.currentUser.uid)
                                    .collection('Sheets')
                                    .doc(refid)
                                    .collection('Transactions')
                                    .doc(data['refid']);
                                ref.delete();

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
                                          sheetname: sheetname,
                                          username: username,
                                          refid: refid)),
                                  (Route<dynamic> route) => false,
                                );
                              }
                            },
                          ),
                        )
                      ],
                    );
                  },
                );
              });
          /*  Alert(
              style: AlertStyle(
                backgroundColor: Color(0xff192028),
                overlayColor: Colors.transparent,
                animationType: AnimationType.fromTop,
                descStyle: TextStyle(fontWeight: FontWeight.bold),
                animationDuration: Duration(milliseconds: 400),
                alertBorder: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  side: BorderSide(
                    color: Colors.white,
                  ),
                ),
                titleStyle: TextStyle(
                  color: Colors.white,
                ),
              ),
              context: context,
              title: "T R A N S A C T I O N",
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                       Switch(
                            activeTrackColor: Colors.white,
                            hoverColor: Colors.white,
                            focusColor: Colors.white,
                            inactiveThumbColor: Colors.white,
                            value: _isIncome,
                            onChanged: (newValue) {
                              setState(() {
                                _isIncome = newValue;
                              });
                            },
                          ),
                      Expanded(
                          child: GestureDetector(
                        onTap: func1,
                        child: Container(
                          height: 200,
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
                                    child: Image.asset('assets/expenses.png'),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          margin: EdgeInsets.all(5.0),
                          decoration: BoxDecoration(
                            color: _isIncome
                                ? Color(0xff192028)
                                : Color(0xffFDFFFF),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                      )),
                      Expanded(
                          child: GestureDetector(
                        onTap: func2,
                        child: Container(
                          height: 200,
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
                                    child: Image.asset('assets/income.png'),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          margin: EdgeInsets.all(5.0),
                          decoration: BoxDecoration(
                            color: _isIncome
                                ? Color(0xffFDFFFF)
                                : Color(0xff192028),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                      )),
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Form(
                    key: _formKey,
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
                          fillColor: Color(0xff192028),
                          filled: true,
                          border: OutlineInputBorder(),
                          labelText: 'Ammount',
                          labelStyle: TextStyle(color: Colors.white),
                          hintText: '₹',
                          hintStyle:
                              TextStyle(fontSize: 20.0, color: Colors.white),
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
                          FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
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
                  Padding(
                    padding: EdgeInsets.only(left: 10, right: 10, bottom: 10),
                    child: TextField(
                      cursorColor: Colors.white,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(20),
                        fillColor: Color(0xff192028),
                        filled: true,
                        border: OutlineInputBorder(),
                        labelText: 'For?',
                        labelStyle: TextStyle(color: Colors.white),
                        hintText: '',
                        hintStyle:
                            TextStyle(fontSize: 20.0, color: Colors.white),
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
                  Padding(
                    padding: EdgeInsets.only(left: 10, right: 10, bottom: 10),
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
                        fillColor: Color(0xff192028),
                        filled: true,
                        border: OutlineInputBorder(),
                        labelText: 'Note',
                        labelStyle: TextStyle(color: Colors.white),
                        hintText: '',
                        hintStyle:
                            TextStyle(fontSize: 20.0, color: Colors.white),
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
                  /* Row(
              children: [
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
                    child:
                        Text('Cancel', style: TextStyle(color: Colors.black)),
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
                    child: Text('Enter', style: TextStyle(color: Colors.black)),
                    onPressed: () {
                      Future.delayed(Duration(milliseconds: 10), () {
                        if (_formKey.currentState!.validate()) {
                          DateTime now = new DateTime.now();
                          String day = new DateFormat('EEEEE').format(now);
                          String date = new DateFormat('d').format(now);
                          String month = new DateFormat('MMM').format(now);
                          String year = new DateFormat('yyyy').format(now);
                          String time = new DateFormat('hh:mm').format(now);
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
                                .doc(FirebaseAuth.instance.currentUser.uid)
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
                                .doc(FirebaseAuth.instance.currentUser.uid)
                                .collection('Sheets')
                                .doc(widget.refid);

                            refe.update({
                              "expense": !_isIncome
                                  ? int.parse(_textcontrollerAMOUNT.text) +
                                      widget.expense
                                  : widget.expense,
                              "income": _isIncome
                                  ? int.parse(_textcontrollerAMOUNT.text) +
                                      widget.income
                                  : widget.income,
                              "total": _isIncome
                                  ? int.parse(_textcontrollerAMOUNT.text) +
                                      widget.total
                                  : widget.total -
                                      int.parse(_textcontrollerAMOUNT.text),
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
                )
              ],
            ), */
                ],
              ),
/* Column(
          children: <Widget>[
            TextField(
              decoration: InputDecoration(
                icon: Icon(Icons.account_circle),
                labelText: 'Username',
              ),
            ),
            TextField(
              obscureText: true,
              decoration: InputDecoration(
                icon: Icon(Icons.lock),
                labelText: 'Password',
              ),
            ),
          ],
        ), */
              buttons: [
                DialogButton(
                  child: Text(
                    "UPDATE",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                  onPressed: () async {
                    if (_textcontrollerITEM.text == "" ||
                        _textcontrollerAMOUNT.text == "") {
                      Alert(
                              context: context,
                              title: "Error",
                              desc: "Feilds empty")
                          .show();
                    } else {
                      print('yo');
                      final refe = FirebaseFirestore.instance
                          .collection('userdata')
                          .doc(FirebaseAuth.instance.currentUser.uid)
                          .collection('Sheets')
                          .doc(refid);

                      print(income);
                      final ref = FirebaseFirestore.instance
                          .collection('userdata')
                          .doc(FirebaseAuth.instance.currentUser.uid)
                          .collection('Sheets')
                          .doc(refid)
                          .collection('Transactions')
                          .doc(data['refid']);
                      ref.update(
                        {
                          "name": _textcontrollerITEM.text,
                          "amount": _textcontrollerAMOUNT.text,
                          "isincome": _isIncome,
                          "note": _textcontrollerNOTE.text,
                          "refid": ref.id,
                        },
                      );
                      print('yo again');
                      refe.update({
                        "expense": !_isIncome
                            ? int.parse(_textcontrollerAMOUNT.text) +
                                expense -
                                int.parse(data['amount'])
                            : expense,
                        "income": _isIncome
                            ? int.parse(_textcontrollerAMOUNT.text) +
                                income -
                                int.parse(data['amount'])
                            : income,
                        "total": _isIncome
                            ? int.parse(_textcontrollerAMOUNT.text) +
                                total -
                                int.parse(data['amount'])
                            : total -
                                int.parse(_textcontrollerAMOUNT.text) +
                                int.parse(data['amount']),
                      });
                      print(income);
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
                                sheetname: sheetname,
                                username: username,
                                refid: refid)),
                        (Route<dynamic> route) => false,
                      );
                    }
                  },
                  gradient: LinearGradient(colors: [
                    Colors.blue,
                    Colors.purple,
                    Colors.orange,
                  ]),
                ),
                DialogButton(
                  child: Text(
                    "DELETE",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                  onPressed: () {
                    final refe = FirebaseFirestore.instance
                        .collection('userdata')
                        .doc(FirebaseAuth.instance.currentUser.uid)
                        .collection('Sheets')
                        .doc(refid);

                    refe.update({
                      "expense": !_isIncome
                          ? expense - int.parse(data['amount'])
                          : expense,
                      "income": _isIncome
                          ? income - int.parse(data['amount'])
                          : income,
                      "total": _isIncome
                          ? total - int.parse(data['amount'])
                          : total + int.parse(_textcontrollerAMOUNT.text),
                    });
                    final ref = FirebaseFirestore.instance
                        .collection('userdata')
                        .doc(FirebaseAuth.instance.currentUser.uid)
                        .collection('Sheets')
                        .doc(refid)
                        .collection('Transactions')
                        .doc(data['refid']);
                    ref.delete();

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
                              sheetname: sheetname,
                              username: username,
                              refid: refid)),
                      (Route<dynamic> route) => false,
                    );
                  },
                  gradient: LinearGradient(colors: [
                    Colors.blue,
                    Colors.purple,
                    Colors.orange,
                  ]),
                )
              ]).show(); */
        },
        child: ClipRRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(
              sigmaY: 10,
              sigmaX: 10,
            ),
            child: Container(
              height: 70,
              decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.white)),
              padding: EdgeInsets.all(5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(2),
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: data['isincome']
                                  ? Colors.green[700]
                                  : Colors.red),
                          child: Center(
                            child: Icon(
                              Icons.attach_money_outlined,
                              size: 20.0,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: Text(data['name'].toUpperCase(),
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              )),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    children: [
                      SizedBox(
                        height: 2,
                      ),
                      Text(
                        (!data['isincome'] ? '-' : '+') + '\₹' + data['amount'],
                        style: TextStyle(
                          //fontWeight: FontWeight.bold,
                          fontSize: 17,
                          color: !data['isincome'] ? Colors.red : Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                          '${data['day']},${data['date']}\'${data['month']},${data['year']}',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                          )),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    ),
  );

  /*return SingleChildScrollView(
    child:  Column(
      children: [
        Tooltip(
          message: 'Longpress for more options',
          child: GestureDetector(
              child: Container(
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.blue,
                        Colors.purpleAccent,
                        Colors.orange,
                        /*  Color(0xff405DE6),
                Color(0xff5851DB),
                Color(0xff833AB4),
                Color(0xffC13584),
                Color(0xffE1306C),
                Color(0xffFD1D1D),
                Color(0xffF56040),
                Color(0xffF77737),
                Color(0xffFCAF45),
                Color(0xffFFDC80), */
                      ],
                    ),
                    color: Colors.blue[900],
                    borderRadius: BorderRadius.all(Radius.circular(20))),
                height: 100,
                child: Center(
                    child: Text(data['name'],
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ))),
              ),
              onLongPress: () {
               /*  Alert(
                  style: AlertStyle(
                    backgroundColor: Color(0xff192028),
                    overlayColor: Colors.transparent,
                    animationType: AnimationType.fromTop,
                    descStyle: TextStyle(fontWeight: FontWeight.bold),
                    animationDuration: Duration(milliseconds: 400),
                    alertBorder: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                      side: BorderSide(
                        color: Colors.white,
                      ),
                    ),
                    titleStyle: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  context: context,
                  type: AlertType.warning,
                  title: "Options",
                  desc: "",
                  content: Column(
                    children: <Widget>[
                      ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(
                            sigmaY: 10,
                            sigmaX: 10,
                          ),
                          child: Padding(
                            padding: EdgeInsets.only(left: 10, right: 10),
                            child: TextField(
                              controller: name,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                              cursorColor: Colors.white,
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.all(20),
                                border: OutlineInputBorder(),
                                labelStyle: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                                hintText: 'Enter the Catagory Name',
                                hintStyle: TextStyle(
                                    fontSize: 20.0, color: Colors.white),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.white,
                                    width: 1,
                                  ),
                                  borderRadius: BorderRadius.circular(18),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.white,
                                    width: 1,
                                  ),
                                  borderRadius: BorderRadius.circular(18),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  buttons: [
                    /*  DialogButton(
                      child: Text(
                        "UPDATE",
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                      onPressed: () async {
                        if (name.text == "") {
                          Alert(
                                  context: context,
                                  title: "Error",
                                  desc: "Sheetname empty")
                              .show();
                        } else {
                          final ref = FirebaseFirestore.instance
                              .collection('userdata')
                              .doc(FirebaseAuth.instance.currentUser.uid)
                              .collection('Sheets')
                              .doc(data['refid']);
                          ref.update(
                            {
                              "sheetname": name.text,
                              "refid": ref.id,
                              "searchkey": name.text.toLowerCase(),
                            },
                          );
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
                            MaterialPageRoute(builder: (context) => Dash()),
                            (Route<dynamic> route) => false,
                          );
                        }
                      },
                      gradient: LinearGradient(colors: [
                        Colors.blue,
                        Colors.purple,
                        Colors.orange,
                      ]),
                    ),
                    DialogButton(
                      child: Text(
                        "DELETE",
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                      onPressed: () {
                        if (name.text == "") {
                          Alert(
                                  context: context,
                                  title: "Error",
                                  desc: "Sheetname empty")
                              .show();
                        } else {
                          final ref = FirebaseFirestore.instance
                              .collection('userdata')
                              .doc(FirebaseAuth.instance.currentUser.uid)
                              .collection('Sheets')
                              .doc(data['refid']);
                          ref.delete();
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
                            MaterialPageRoute(builder: (context) => Dash()),
                            (Route<dynamic> route) => false,
                          );
                        }
                      },
                      gradient: LinearGradient(colors: [
                        Colors.blue,
                        Colors.purple,
                        Colors.orange,
                      ]),
                    ) */
                  ],
                ).show(); */
              },
              onTap: () {
                /*  Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => JobApply(
                      jobtitle: data['jobtitle'],
                      jobdisc: data['jobdisc'],
                      qualification: data['qualification'],
                      websitelink: data['websitelink'],
                      isadmin: true,
                      companyname: data['companyname'],
                      refid: data['refid'],
                      email: data['email link'],
                      aboutcompany: data['about company'],
                      isprev: false,
                    ),
                  ),
                ); */
              }),
        ),
        SizedBox(
          height: 10.0,
        ),
      ],
    ),
  ); */
}
