import 'package:gsheets/gsheets.dart';
import 'package:intl/intl.dart';
import 'dart:math';

class GoogleSheetsApi {
  static const _credentials = r'''
{
  "type": "service_account",
  "project_id": "flutter-gsheets-329714",
  "private_key_id": "45f4303cecd00e6d0d3e0a6fd34bde3d01f1eb5c",
  "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQDhcmK9OdEEm/NK\nh1INSqOpI+UQPwZHdj2Jrb5VBita6t75x+Yqki8Z7lYL7mr0jeVj87Eg6wO1wi0i\nGGpCaFTwBSMPArkKl3z9LjYqc0vPH24XV+PApwbOqnUrCjdUN702ufkxkXgPW1Kc\nArisA4OVO1LYWL13xNkb60kZvGOtjElK4VcNCiyps5oGJsEUXIs37Pynx9LtirQG\n01/SyYLtxBZmE46/l44epr59UQcxdij4n9YdW14CYwSc/0Y/C2AP5IjuEArmTWo5\nE8qcdwa/JGstntGRhGKWlY//DOqOymN4wR2Y0OZUSMvr/zvuPyzOmpDtLXMBvXom\nKuTg45d9AgMBAAECggEAAh55Hx40AL8WglTTSJyy/RwBQy3UeUd7PJgNee8c6TXb\n8q0WVMAbATtkQ6hyCOpshYv81jpfRo4UroVcOlOQuNDTi4iTBK531klg6PU8eS3q\ncv24fk8TmU2w3D60Vm5PsPv+g6DCaCKLnDvKUJOX4Qc1uCLdZQrMn56OiVdj+HWc\nlTYNPqIlCMXvCRFkoGju9NHfWUHI4rUXi4NHA5NHgqdDhZE0XTUPMPDZ70D4gL8g\nrMP2LY6zJtkxOmUVIoLFlk3Qwee3jP1eKtfXQ4tOcLqa4OopzOO+xeWuLwEou6TX\nfxKAVAXY5somAJThGtKwzWmNQKYgbCs3ZcyQ/xnyYQKBgQD8UMFA6WHI8aVfICSm\ny7cM4DqC5WNtFa6XErXeoB52C362AA+2AfifwrUl9RSXxuApPGy+G1fMk5Hnzq3u\nDtyBB2hFRvSTrW7wVr2vfrCrGbeWS3B9Dly9fCSngCKWPCnoWDscAzXM0OJQMQzC\nNhIqtBGwx139R+GYtzZgq2aMowKBgQDkvS+wc7Qp/KPrhWogLxAlgpLSOZwG4qyh\nsHLlajwNvjWC9lYpMWSVbIypHKOZ7Gbc3tgas4Tviu8At79BFZ/elghKaxDi+vsW\nDmKHbH+3D2Fbu4Oksrhok5pu3EeHhYFA+x8wvkKcksGVMXAcwJKRBZu3Vkaz8N25\nHYP6X3xtXwKBgCRUDD8oWyfvgvv7SMurMSPtdP87v+EI6iZeT0lKjJg6d3gE8j4m\ncoGuKx7X9qsTu1q0lIOatD2EUdGqdGh+Q0lgo6a13KkWo45/LriB6TX5cfF10zBu\nTPQLV8u2K0SuTOpjKb+SxsBCoxMgvNGJr3vuiU2GpwW8v8KZPn8UrqM5AoGBAKb4\n8zb7PyjnI0Fpwm577G11Q3fyVdMw5JOjGjwdsHjXwHg5Gew4AhSRiJxqK4LQ7sWM\nZnQXV5ME+DKt7w6zmmABZUvtnAYU7/TJy2LP8OrQb2FnIFG5pKOyG6mRYyWqbw/g\nQIR0XmutNWKTFCPo7xSt412RvUrdKP1Ybl72FP5BAoGBAJ96RTZqjgCzmUj8G/jz\nDFbrcr+laFRxIywMUodNxQEn58Aby8n5tIsbOVGZTHPef9yBGOvMM7mVoGcfw2qO\ndr0V98UW/xYZHK6uq2tsTBbyBVPla3d8DHp8fK4UTRXMIVzzoKwgySZSlP9NL5MN\nx1Q4tOLOWQtnpL5JIABtj7VO\n-----END PRIVATE KEY-----\n",
  "client_email": "flutter-gsheets@flutter-gsheets-329714.iam.gserviceaccount.com",
  "client_id": "115320672213866075705",
  "auth_uri": "https://accounts.google.com/o/oauth2/auth",
  "token_uri": "https://oauth2.googleapis.com/token",
  "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
  "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/flutter-gsheets%40flutter-gsheets-329714.iam.gserviceaccount.com"
}


''';

  final _gsheets = GSheets(_credentials);
  Worksheet? _worksheet;
  int numberOfTransactions = 0;
  List<List<dynamic>> currentTransactions = [];
  bool loading = true;
  String sheetname = "";
  static int id = 0;

  Future init(String a, String b) async {
    final ss = await _gsheets.spreadsheet(b);
    _worksheet = ss.worksheetByTitle(a);

    print('class');
  }

  Future countRows() async {
    while ((await _worksheet!.values
            .value(column: 1, row: numberOfTransactions + 1)) !=
        '') {
      numberOfTransactions++;
    }

    // now we know how many notes to load, now let's load them!
  }

  Future loadTransactions() async {
    if (_worksheet == null) {
      print('failed load');
      return;
    }
    id = numberOfTransactions - 1;
    for (int i = 1; i < numberOfTransactions; i++) {
      final String index =
          await _worksheet!.values.value(column: 1, row: i + 1);
      final String transactionName =
          await _worksheet!.values.value(column: 2, row: i + 1);
      final String transactionAmount =
          await _worksheet!.values.value(column: 3, row: i + 1);
      final String transactionType =
          await _worksheet!.values.value(column: 4, row: i + 1);

      final String day = await _worksheet!.values.value(column: 5, row: i + 1);
      final String date = await _worksheet!.values.value(column: 6, row: i + 1);
      final String month =
          await _worksheet!.values.value(column: 7, row: i + 1);
      final String year = await _worksheet!.values.value(column: 8, row: i + 1);
      final String time = await _worksheet!.values.value(column: 9, row: i + 1);
      final String note =
          await _worksheet!.values.value(column: 10, row: i + 1);

      if (index == 'Id') {
        continue;
      }
      if (currentTransactions.length < numberOfTransactions) {
        currentTransactions.add([
          index,
          transactionName,
          transactionAmount,
          transactionType,
          day,
          date,
          month,
          year,
          time,
          note,
        ]);
      }
    }
    print(currentTransactions);
    // this will stop the circular loading indicator
    loading = false;
  }

  Future start(String id, String sheetname) async {
    try {
      final sse = await _gsheets.spreadsheet(id);

      print('hello1');
      Worksheet? _work;
      print('hello2');
      _work = sse.worksheetByTitle(sheetname);
      await _work.values.appendRow([
        'Title',
        'Amount',
        'Expense/Income',
        'Day',
        'Date',
        'Month',
        'Year',
        'Time',
        'Note',
      ]);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future insert(String name, String amount, bool _isIncome, String note,
      String day, String date, String month, String year, String time) async {
    if (_worksheet == null) return;
    print('hello');
    await _worksheet!.values.appendRow([
      name,
      amount,
      _isIncome == true ? 'income' : 'expense',
      day,
      date,
      month,
      year,
      time,
      note,
    ]);
  }

  Future<bool> deleterow(String indexe) async {
    print('hello');
    if (_worksheet == null) return false;
    final index = await _worksheet!.values.rowIndexOf(indexe);
    print(index);
    print('hellow again');
    if (index == -1) return false;
    return _worksheet!.deleteRow(index);
  }

  double calculateIncome() {
    double totalIncome = 0;
    for (int i = 0; i < currentTransactions.length; i++) {
      if (currentTransactions[i][3] == 'income') {
        totalIncome += double.parse(currentTransactions[i][2]);
      }
    }
    return totalIncome;
  }

  double calculateExpense() {
    double totalExpense = 0;
    for (int i = 0; i < currentTransactions.length; i++) {
      if (currentTransactions[i][3] == 'expense') {
        totalExpense += double.parse(currentTransactions[i][2]);
      }
    }
    return totalExpense;
  }
}
