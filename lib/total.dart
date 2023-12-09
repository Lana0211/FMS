import 'package:flutter/material.dart';

class TotalScreen extends StatelessWidget {
  // 創建一個 List 來存儲類型和金額的數據
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
          _buildTypeAndAmountList(),
        ],
      ),
    );
  }

  Widget _buildExpenditureHeader() {
    // 實現你的 Expenditure and Date Selector UI
    return Container(
      // Your implementation here
    );
  }

  Widget _buildPieChart() {
    // 實現你的 Pie Chart UI
    return Container(
      // Your implementation here
    );
  }

  Widget _buildTotalExpenditure() {
    // 實現你的 Total Expenditure UI
    return Container(
      // Your implementation here
    );
  }

  Widget _buildTypeAndAmountList() {
    // 使用 ListView.builder 來顯示列表
    return Expanded(
      child: ListView.builder(
        itemCount: typeAndAmountList.length,
        itemBuilder: (BuildContext context, int index) {
          // 獲取當前項目的數據
          final Map<String, dynamic> item = typeAndAmountList[index];

          return ListTile(
            title: Text(item['type']), // 顯示類型
            subtitle: Text('Amount: \$${item['amount']}'), // 顯示金額
          );
        },
      ),
    );
  }
}
