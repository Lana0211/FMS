import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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
    fetchData(); // 初始时获取数据
  }

  Future<void> fetchData() async {
    final String endpoint = isExpenditure
        ? 'http://10.0.2.2:5000/api/expenditures'
        : 'http://10.0.2.2:5000/api/incomes';
    try {
      final response = await http.get(Uri.parse(endpoint));
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        // setState(() {
        //   // 根据返回的 JSON 结构解析数据
        //   typeAndAmountList = List<Map<String, dynamic>>.from(data['expenditure']);
        //   totalAmount = double.parse(data['total_amount']);
        // });
        if (isExpenditure) {
          // 处理支出数据
          if (data['expenditures'] != null) {
            setState(() {
              typeAndAmountList = List<Map<String, dynamic>>.from(data['expenditures']);
              totalAmount = double.parse(data['total_amount']);
            });
          } else {
            // 如果 data['income'] 为 null，则应对 typeAndAmountList 进行适当处理
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
            // 如果 data['income'] 为 null，则应对 typeAndAmountList 进行适当处理
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

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2023),
      initialEntryMode: DatePickerEntryMode.calendarOnly, // 顯示日曆
      // 只允許選擇年/月
      selectableDayPredicate: (DateTime day) => day.day == 1,
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = DateTime(picked.year, picked.month);
      });
    }
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
            onTap: () => _selectDate(context), // 綁定 _selectDate
          ),

          _buildPieChart(),
          _buildTotalAmount(),
          const Divider(
            color: Colors.white,
            thickness: 1.0,
          ),
          // Type and Amount
          _buildTypeAndAmountList(context),
        ],
      ),
    );
  }


  Widget _buildPieChart() {
    List<PieChartSectionData> sections = typeAndAmountList.map((dataItem) {
      int index = typeAndAmountList.indexOf(dataItem);
      return PieChartSectionData(
        color: Colors.primaries[index % Colors.primaries.length],
        value: double.parse(dataItem['amount'].toString()), // 确保转换为 double 类型
        title: '${dataItem['amount']}',
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
    final String typeLabel = isExpenditure ? 'expenditure' : 'income';
    return Expanded(
      child: ListView.builder(
        itemCount: typeAndAmountList.length,
        itemBuilder: (BuildContext context, int index) {
          final Map<String, dynamic> item = typeAndAmountList[index];
          return ListTile(
            title: Text('${item['type']}'),
            subtitle: Text('Amount: \$${item['amount']}'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => YourNewPage(),
                ),
              );
            },
          );
        },
      ),
    );
  }
}


// 添加你的新页面的 Widget
class YourNewPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your New Page'),
      ),
      body: Center(
        child: Text('This is your new page content.'),
      ),
    );
  }
}