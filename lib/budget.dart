import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:math' as math;
import 'budget_add.dart';
import 'src/theme.dart';

class BudgetScreen extends StatefulWidget {
  @override
  _BudgetScreenState createState() => _BudgetScreenState();
}

class _BudgetScreenState extends State<BudgetScreen> {
  DateTime selectedDate = DateTime.now();
  String yearMonth = DateFormat('yyyy-MM').format(DateTime.now());
  List<String> expenditureTypes = [];
  List<double> expenditures = [];
  List<double> budgets = [];

  @override
  void initState() {
    super.initState();
    fetchTypesAndBudgets();
  }

  Future<void> fetchTypesAndBudgets() async {
    expenditureTypes = [];
    expenditures = [];
    budgets = [];

    final String year = selectedDate.year.toString();
    final String month = selectedDate.month.toString().padLeft(2, '0');
    const String typesUrl = 'https://db-accounting.azurewebsites.net/api/types?type=expenditure';
    final String budgetsUrl = 'https://db-accounting.azurewebsites.net/api/budgets?year=$year&month=$month';

    try {
      // Fetching budgets
      final responseBudgets = await http.get(Uri.parse(budgetsUrl));
      if (responseBudgets.statusCode == 200) {
        final List<dynamic> budgetsData = json.decode(responseBudgets.body);
        List<int> typeIds = budgetsData.map((budget) => budget['expenditure_type'] as int).toSet().toList();

        for (int typeId in typeIds) {
          final responseTypes = await http.get(Uri.parse('$typesUrl&type_id=$typeId'));
          if (responseTypes.statusCode == 200) {
            final dynamic typeData = json.decode(responseTypes.body);
            expenditureTypes.add(typeData['name']);
          } else {
            throw Exception('Failed to load type for id $typeId');
          }
        }

        setState(() {
          expenditures = budgetsData.map((budget) => double.parse(budget['remaining_budget'].toString())).toList();
          budgets = budgetsData.map((budget) => double.parse(budget['amount'].toString())).toList();
        });


      } else {
        throw Exception('Failed to load budgets');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error fetching budget data: $e'),
          duration: const Duration(seconds: 2),
        ),
      );
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
          fetchTypesAndBudgets(); // 獲得新數據
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    String formattedDate = DateFormat('yyyy-MM').format(selectedDate);

    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text('Budget'),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              _navigateToBudgetAdd(context);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Center(
              child: InkWell( // 日曆彈窗
                child: Padding(
                  padding: const EdgeInsets.all(5),
                  child: Row(
                    mainAxisSize: MainAxisSize.min, // 限制 Row 的大小僅包裹其內容
                    mainAxisAlignment: MainAxisAlignment.center, // 水平居中
                    children: <Widget>[
                      const Icon(Icons.calendar_today, size: 15.0), // 日曆圖標
                      const SizedBox(width: 8.0), // 圖標和文本之間的間隙
                      Text(formattedDate), // 顯示格式化的日期
                    ],
                  ),
                ),
                onTap: () => _selectMonthYear(context), // 綁定 _selectDate
              ),
            ),
            // Add some padding to move the BarChart down
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: Container(
                height: MediaQuery.of(context).size.height / 4,
                child: Stack(
                  children: [
                    // BarChart
                    budgets.isNotEmpty ? BarChartWidget(
                      barData: BarData(
                        expenditureTypes: expenditureTypes,
                        expenditures: expenditures,
                        budgets: budgets,
                      ),
                    ) : Container(),
                    // Horizontal Line
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        height: 1,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            // Display Expenditure Type, Expenditure, Budget
            Container(
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
              child: Row(
                children: [
                  // Expenditure Type
                  Expanded(
                    child: Column(
                      children: [
                        for (int i = 0; i < expenditureTypes.length; i++)
                          Column(
                            children: [
                              Text(
                                expenditureTypes[i],
                                style: TextStyle(fontSize: 18),
                              ),
                              SizedBox(height: 10), // 在每行文本之間添加10點的間隔
                            ],
                          ),
                      ],
                    ),
                  ),
                  SizedBox(width: 24),
                  // Expenditure
                  Expanded(
                    child: Column(
                      children: [
                        for (int i = 0; i < expenditures.length; i++)
                          Column(
                            children: [
                              Text(
                                '\$${expenditures[i]}',
                                style: TextStyle(fontSize: 18, color: Colors.red),
                              ),
                              SizedBox(height: 10), // 在每行文本之間添加10點的間隔
                            ],
                          ),
                      ],
                    ),
                  ),
                  SizedBox(width: 24),
                  // Budget
                  Expanded(
                    child: Column(
                      children: [
                        for (int i = 0; i < budgets.length; i++)
                          Column(
                            children: [
                              Text(
                                '\$${budgets[i]}',
                                style: TextStyle(fontSize: 18, color: Colors.blue),
                              ),
                              SizedBox(height: 10), // 在每行文本之間添加10點的間隔
                            ],
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BarChartWidget extends StatelessWidget {
  final BarData barData;

  BarChartWidget({required this.barData});

  @override
  Widget build(BuildContext context) {
    // 找出最大的數字
    final maxAmount = (barData.expenditures + barData.budgets).reduce(math.max);
    final double chartHeight = 200.0;

    return Container(
        height: chartHeight,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: List.generate(barData.expenditures.length, (index) {
          // 計算每個的百分比
          final expenditureHeight = (math.max(0, barData.expenditures[index]) / maxAmount) * chartHeight;
          final budgetHeight = (math.max(0, barData.budgets[index]) / maxAmount) * chartHeight;

          return Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              barData.expenditures[index] > 0 ? Container(
                height: expenditureHeight,
                // height: barData.expenditures[index],
                width: 20,
                color: Colors.red,
              ) : Container(),
              SizedBox(width: 8),
              Container(
                height: budgetHeight,
                // height: barData.budgets[index],
                width: 20,
                color: Colors.blue,
              ),
            ],
          );
        }),
      ),
    );
  }
}

class BarData {
  final List<String> expenditureTypes;
  final List<double> expenditures;
  final List<double> budgets;

  BarData({required this.expenditureTypes, required this.expenditures, required this.budgets});
}

void _navigateToBudgetAdd(BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => BudgetAddScreen()),
  ).then((value) {
    // Handle the result when the BudgetAddScreen page is popped.
    if (value != null) {
      // Assuming value is the newly added budget data.
      // You can handle the data as needed.
      // For example, update the UI with the new data.
      // Update the budgets list and any other necessary data.
    }
  });
}