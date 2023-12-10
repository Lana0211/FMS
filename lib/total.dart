import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

class TotalScreen extends StatefulWidget {
  @override
  _TotalScreenState createState() => _TotalScreenState();
}


class _TotalScreenState extends State<TotalScreen> {
  bool isExpenditure = true; //切換支出還是收入
  DateTime selectedDate = DateTime.now();

  // 定義 typeAndAmountList
  List<Map<String, dynamic>> typeAndAmountList = List.generate(
    10,
        (index) => {'type': 'Type $index', 'amount': (index + 1) * 10},
  );

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

          isExpenditure ? _buildExpenditurePieChart() : _buildIncomePieChart(),
          _buildTotalExpenditure(), // 显示总支出
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


  Widget _buildExpenditurePieChart() {
    // 模拟数据
    List<PieChartSectionData> sections = List.generate(
      typeAndAmountList.length,
          (index) => PieChartSectionData(
        color: Colors.primaries[index % Colors.primaries.length],
        value: typeAndAmountList[index]['amount'].toDouble(),
        title: '${typeAndAmountList[index]['amount']}',
      ),
    );

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

  Widget _buildIncomePieChart() {
    // 模擬數據
    List<Map<String, dynamic>> incomeTypeAndAmountList = List.generate(
      10,
          (index) => {'type': 'Income Type $index', 'amount': (index + 1) * 15},
    );

    List<PieChartSectionData> sections = List.generate(
      incomeTypeAndAmountList.length,
          (index) => PieChartSectionData(
        color: Colors.primaries[index % Colors.primaries.length],
        value: incomeTypeAndAmountList[index]['amount'].toDouble(),
        title: '${incomeTypeAndAmountList[index]['amount']}',
      ),
    );

    return Container(
      padding: const EdgeInsets.all(5.0),
      width: 100.0, // 调整饼图的宽度
      height: 150.0, // 调整饼图的高度
      child: PieChart(
        PieChartData(
          sections: sections,
          centerSpaceRadius: 30.0, // 调整饼图中心空白区域的半径
          borderData: FlBorderData(show: false),
          sectionsSpace: 0, // 调整饼图各部分之间的间隔
        ),
      ),
    );
  }

  Widget _buildTotalExpenditure() {
    int totalExpenditure = typeAndAmountList.fold(
        0, (sum, item) => sum + (item['amount'] as int));

    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Text(
        'Total Expenditure: \$${totalExpenditure.toString()}',
        style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
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
            title: Text(item['type']),
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