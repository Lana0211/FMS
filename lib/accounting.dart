import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:month_picker_dialog/month_picker_dialog.dart';

class TotalScreen extends StatefulWidget {
  @override
  _TotalScreenState createState() => _TotalScreenState();
}


class _TotalScreenState extends State<TotalScreen> {
  bool isExpenditure = true; //切換支出還是收入
  DateTime selectedDate = DateTime.now();
  List<Map<String, dynamic>> typeAndAmountList = [];
  double totalAmount = 0;

  @override
  void initState() {
    super.initState();
    fetchData(); // 初始化數據
  }

  Future<void> fetchData() async {
    final String year = selectedDate.year.toString();
    final String month = selectedDate.month.toString().padLeft(2, '0'); // 確保月份是兩位數
    final String endpoint = isExpenditure
        ? 'http://10.0.2.2:5000/api/expenditures?year=$year&month=$month'
        : 'http://10.0.2.2:5000/api/incomes?year=$year&month=$month';

    try {
      final response = await http.get(Uri.parse(endpoint));
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        if (isExpenditure) {
          // 处理支出数据
          if (data['expenditures'] != null) {
            setState(() {
              typeAndAmountList = List<Map<String, dynamic>>.from(data['expenditures']);
              totalAmount = double.parse(data['total_amount']);
            });
          } else {
            setState(() {
              typeAndAmountList = [];
              totalAmount = 0.0;
            });
          }
        } else {
          // 处理收入数据
          if (data['incomes'] != null) {
            setState(() {
              typeAndAmountList = List<Map<String, dynamic>>.from(data['incomes']);
              totalAmount = double.parse(data['total_amount']);
            });
          } else {
            setState(() {
              typeAndAmountList = [];
              totalAmount = 0.0;
            });
          }
        }
      } else {
        print('Failed to load data');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  // Future<void> _selectDate(BuildContext context) async {
  //   final initialDate = DateTime(selectedDate.year, selectedDate.month, 1);
  //
  //   final DateTime? picked = await showDatePicker(
  //     context: context,
  //     initialDate: selectedDate.isAfter(DateTime.now()) ? DateTime.now() : initialDate,
  //     firstDate: DateTime(2000),
  //     lastDate: DateTime(2025),
  //     initialEntryMode: DatePickerEntryMode.calendarOnly,
  //     // selectableDayPredicate: (DateTime day) => day.day == 1,
  //   );
  //   if (picked != null && picked != selectedDate) {
  //     setState(() {
  //       selectedDate = DateTime(picked.year, picked.month);
  //       typeAndAmountList = []; // 清空列表
  //       totalAmount = 0.0; // 重置總價
  //     });
  //     fetchData(); // 獲得新數據
  //   }
  // }

  Future<void> _selectMonthYear(BuildContext context) async {
    showMonthPicker(
      context: context,
      initialDate: DateTime.now(),
    ).then((date) {
      if (date != null && date != selectedDate) {
        setState(() {
          selectedDate = DateTime(date.year, date.month);
          typeAndAmountList = []; // 清空列表
          totalAmount = 0.0; // 重置總價
        });
        fetchData(); // 獲得新數據
      }
    });

  }

  @override
  Widget build(BuildContext context) {
    String formattedDate = DateFormat('yyyy-MM').format(selectedDate); // 格式化

    return Scaffold(
      appBar: AppBar(
        title: const Text('Total'),
      ),
      body: Column(
        children: [
          ToggleButtons(
            constraints: const BoxConstraints(
              minHeight: 30.0, // 最小高度
              maxHeight: 40.0, // 最大高度
            ),

            isSelected: [isExpenditure, !isExpenditure],
            onPressed: (int index) {
              setState(() {
                isExpenditure = index == 0;
                fetchData(); // 切换后重新获取数据
              });
            },
            children: const <Widget>[
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text('Expenditure'),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text('Income'),
              ),
            ],
          ),
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

          if (typeAndAmountList.isNotEmpty) ...[
            _buildPieChart(),
            _buildTotalAmount(),
            const Divider(color: Colors.white, thickness: 1.0),
            _buildTypeAndAmountList(context),
          ] else ...[
            _buildEmptyPieChart(),
            _buildTotalAmount(),
            const Divider(color: Colors.white, thickness: 1.0),
          ],
        ],
      ),
    );
  }

  Widget _buildEmptyPieChart() {
    return Container(
      padding: const EdgeInsets.all(5.0),
      width: 100.0,
      height: 150.0,
      child: PieChart(
        PieChartData(
          sections: [
            PieChartSectionData(
              color: Colors.grey,
              value: 100, // 一个满圆
              title: '', // 没有标题
            ),
          ],
          centerSpaceRadius: 30.0,
          borderData: FlBorderData(show: false),
          sectionsSpace: 0,
        ),
      ),
    );
  }

  Widget _buildPieChart() {
    List<PieChartSectionData> sections = typeAndAmountList.map((dataItem) {
      int index = typeAndAmountList.indexOf(dataItem);
      int roundedAmount = double.parse(dataItem['amount'].toString()).round();
      return PieChartSectionData(
        color: Colors.primaries[index % Colors.primaries.length],
        value: roundedAmount.toDouble(), // 必須為double
        title: '$roundedAmount',
      );
    }).toList();

    return Container(
      padding: const EdgeInsets.all(5.0),
      width: 100.0,
      height: 150.0,
      child: PieChart(
        PieChartData(
          sections: sections,
          centerSpaceRadius: 30.0,
          borderData: FlBorderData(show: false),
          sectionsSpace: 0,
        ),
      ),
    );
  }


  Widget _buildTotalAmount() {
    final String typeLabel = isExpenditure ? 'Expenditure' : 'Income';
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Text(
        'Total $typeLabel: \$${totalAmount.toStringAsFixed(2)}',
        style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildTypeAndAmountList(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        itemCount: typeAndAmountList.length,
        itemBuilder: (BuildContext context, int index) {
          final Map<String, dynamic> item = typeAndAmountList[index];
          return ListTile(
            title: Text('${item['date']}'),
            subtitle: Text('${item['type']} - \$${item['amount']}'),
            onTap: () {
              // 获取被点击项的年月字符串
              String yearMonth = DateFormat('yyyy-MM').format(DateTime.parse(item['date']));
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TypeTotalPage(
                    type: item['type'],
                    yearMonth: yearMonth,
                    allData: typeAndAmountList,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}


class TypeTotalPage extends StatelessWidget {
  final String type;
  final String yearMonth;
  final List<Map<String, dynamic>> allData;

  TypeTotalPage({required this.type, required this.yearMonth, required this.allData});

  @override
  Widget build(BuildContext context) {
    // 找出相同類型和年月的資料
    List<Map<String, dynamic>> filteredData = allData.where((item) {
      DateTime date = DateTime.parse(item['date']);
      // 格式化日期
      String itemYearMonth = DateFormat('yyyy-MM').format(date);
      return item['type'] == type && itemYearMonth == yearMonth;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('$type - $yearMonth'),
      ),
      body: ListView.builder(
        itemCount: filteredData.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text('${filteredData[index]['date']}'),
            subtitle: Text('${filteredData[index]['type']} - \$${filteredData[index]['amount']}'),
          );
        },
      ),
    );
  }
}
