import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'src/theme.dart';
import 'dart:convert';
import 'package:month_picker_dialog/month_picker_dialog.dart';

class AccountingScreen extends StatefulWidget {
  @override
  _AccountingScreenState createState() => _AccountingScreenState();
}

class _AccountingScreenState extends State<AccountingScreen> {
  DateTime selectedDate = DateTime.now();
  List<Map<String, dynamic>> records = [];

  @override
  void initState() {
    super.initState();
    fetchRecords();
  }

  Future<void> fetchRecords() async {
    records = [];
    var year = selectedDate.year.toString();
    var month = selectedDate.month.toString().padLeft(2, '0');

    var expenditureEndpoint = 'http://10.0.2.2:5000/api/expenditures?year=$year&month=$month';
    var incomeEndpoint = 'http://10.0.2.2:5000/api/incomes?year=$year&month=$month';

    try {
      var expenditureResponse = await http.get(Uri.parse(expenditureEndpoint));
      var incomeResponse = await http.get(Uri.parse(incomeEndpoint));

      if (expenditureResponse.statusCode == 200 && incomeResponse.statusCode == 200) {
        var expenditureData = json.decode(expenditureResponse.body);
        var incomeData = json.decode(incomeResponse.body);

        List<Map<String, dynamic>> expenditures = (expenditureData['expenditures'] as List)
            .map((item) => Map<String, dynamic>.from(item))
            .toList();
        List<Map<String, dynamic>> incomes = (incomeData['incomes'] as List)
            .map((item) => Map<String, dynamic>.from(item))
            .toList();

        for (var expenditure in expenditures) {
          String amountString = expenditure['amount'];
          expenditure['amount'] = '-${amountString}';
        }

        setState(() {
          records = expenditures + incomes;
          // Sort records if not empty
          if (records.isNotEmpty) {
            records.sort((a, b) => DateTime.parse(a['date']).compareTo(DateTime.parse(b['date'])));
          }
        });
      } else {
        print('Failed to fetch data');
      }
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  Future<void> _selectMonthYear(BuildContext context) async {
    showMonthPicker(
      context: context,
      initialDate: DateTime.now(),
    ).then((date) {
      if (date != null && date != selectedDate) {
        setState(() {
          selectedDate = DateTime(date.year, date.month);
          records = [];
        });
        fetchRecords(); // 獲得新數據
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var formattedDate = DateFormat('yyyy-MM').format(selectedDate);

    return Scaffold(
      appBar: AppBar(
        title: Text('Accounting'),
        actions: <Widget>[
          InkWell( // 日曆彈窗
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisSize: MainAxisSize.min, // 限制 Row 的大小僅包裹其內容
                mainAxisAlignment: MainAxisAlignment.center, // 水平居中
                children: <Widget>[
                  const Icon(Icons.calendar_today, size: 24.0), // 日曆圖標
                  const SizedBox(width: 8.0), // 圖標和文本之間的間隙
                  Text(formattedDate), // 顯示格式化的日期
                ],
              ),
            ),
            onTap: () => _selectMonthYear(context), // 綁定 _selectDate
          ),
        ],
      ),
      body: records.isEmpty
        ? const Center(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'No records found for the selected month.',
              style: TextStyle(fontSize: 18.0),
            ),
          ),
        )
        : ListView.builder(
          itemCount: records.length,
          itemBuilder: (context, index) {
            var record = records[index];
            return Container(
              margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0), // Add some spacing around each item
              decoration: BoxDecoration(
                color: AppTheme.listBackgroundColor, // Set the background color
                borderRadius: BorderRadius.circular(10.0), // Rounded corners
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2), // Shadow color with some transparency
                    spreadRadius: 2,
                    blurRadius: 4,
                    offset: Offset(0, 3), // Changes position of shadow
                  ),
                ],
              ),
              child: ListTile(
                title: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('${record['type']}'),
                          Text('${record['date']}'),
                        ],
                      ),
                    ),
                    Text(
                      '${record['amount']}',
                      style: TextStyle(
                        color: record['amount'].startsWith('-') ? Colors.red : Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        )
    );
  }
}