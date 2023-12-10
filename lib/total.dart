import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class TotalScreen extends StatelessWidget {
  final List<Map<String, dynamic>> typeAndAmountList = List.generate(
    10,
        (index) => {'type': 'Type', 'amount': 0},
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Total'),
      ),
      body: Column(
        children: [
          // Expenditure and Date Selector
          _buildExpenditureHeader(),
          // Pie Chart
          _buildPieChart(),
          // Total Expenditure
          _buildTotalExpenditure(),
          // White Line
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

  Widget _buildExpenditureHeader() {
    return Container(
      // Your implementation here
    );
  }

  Widget _buildPieChart() {
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
      padding: const EdgeInsets.all(16.0),
      width: 300.0,
      height: 300.0,
      child: PieChart(
        PieChartData(
          sections: sections,
          centerSpaceRadius: 40.0,
          borderData: FlBorderData(show: false),
          sectionsSpace: 0,
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