import 'dart:async';

import 'package:expenditure/google_sheets.dart';
import 'package:expenditure/homepage.dart';
import 'package:flutter/material.dart';

class MyTransaction extends StatelessWidget {
  final String transactionName;
  final String money;
  final String expenseOrIncome;

  final String day;
  var gg = GoogleSheetsApi();
  final String date;
  final String month;
  final String year;
  final String sheetname;

  final String note;
  final String id;
  final String username;

  MyTransaction({
    required this.id,
    required this.transactionName,
    required this.money,
    required this.expenseOrIncome,
    required this.day,
    required this.date,
    required this.month,
    required this.year,
    required this.note,
    required this.gg,
    required this.sheetname,
    required this.username,
  });
  final _textcontrollerAMOUNT = TextEditingController();
  final _textcontrollerITEM = TextEditingController();
  final _textcontrollerNOTE = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isIncome = false;

  @override
  void _newTransaction(BuildContext context) {
    _textcontrollerAMOUNT.text = money;
    _textcontrollerITEM.text = transactionName;
    print(note);
    _textcontrollerNOTE.text = note;

    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (BuildContext context, setState) {
              return AlertDialog(
                scrollable: true,
                backgroundColor: Colors.blue[800],
                title: Text(
                  '$transactionName',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
                content: SingleChildScrollView(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            '${expenseOrIncome.toUpperCase()}',
                            style: TextStyle(
                                fontSize: 20,
                                color: expenseOrIncome == 'expense'
                                    ? Colors.red
                                    : Colors.greenAccent,
                                fontWeight: FontWeight.bold),
                          ),
                          /*  Switch(
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
                                  fontWeight: FontWeight.bold)), */
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
                                readOnly: true,
                                cursorColor: Colors.white,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.all(20),
                                  fillColor: Colors.blue[800],
                                  filled: true,
                                  border: OutlineInputBorder(),
                                  labelText: 'Ammount',
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
                              readOnly: true,
                              cursorColor: Colors.white,
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.all(20),
                                fillColor: Colors.blue[800],
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
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              readOnly: true,
                              maxLines: 2,
                              cursorColor: Colors.white,
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.all(20),
                                fillColor: Colors.blue[800],
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
                      child:
                          Text('Delete', style: TextStyle(color: Colors.black)),
                      onPressed: () {
                        gg.deleterow(id);
                        /*   gg.loading = true;
                        gg.init(sheetname, sheetid); */
                        /* Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => HomePage(
                              sheetname: sheetname,
                              username: username,
                            ),
                          ),
                        ); */
                      },
                    ),
                  ),
                ],
              );
            },
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: GestureDetector(
          onTap: () {
            _newTransaction(context);
            /* Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => Addsheet(
                      sheetid: sheetid,
                    )),
          ); */
          },
          child: Container(
            height: 70,
            padding: EdgeInsets.all(5),
            color: Colors.grey[100],
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(2),
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: expenseOrIncome == 'income'
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
                    Text(transactionName.toUpperCase(),
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        )),
                  ],
                ),
                Column(
                  children: [
                    SizedBox(
                      height: 2,
                    ),
                    Text(
                      (expenseOrIncome == 'expense' ? '-' : '+') + '\₹' + money,
                      style: TextStyle(
                        //fontWeight: FontWeight.bold,
                        fontSize: 17,
                        color: expenseOrIncome == 'expense'
                            ? Colors.red
                            : Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Text('$day,$date $month, $year',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[700],
                        )),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
