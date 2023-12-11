import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
import 'package:fl_chart/fl_chart.dart';
import 'budget_add.dart';

class BudgetScreen extends StatefulWidget {
  @override
  _BudgetScreenState createState() => _BudgetScreenState();
}

class _BudgetScreenState extends State<BudgetScreen> {
  bool isExpenditure = true;
  DateTime selectedDate = DateTime.now();
  String yearMonth = DateFormat('yyyy-MM').format(DateTime.now());
  List<String> expenditureTypes = ['Food', 'Transportation', 'Entertainment', 'Utilities', 'Others'];
  List<double> expenditures = [500, 200, 100, 150, 300];
  List<double> budgets = [600, 250, 180, 200, 350];

  @override
  void initState() {
    super.initState();
  }

  Future<void> _selectMonthYear(BuildContext context) async {
    showMonthPicker(
      context: context,
      initialDate: DateTime.now(),
    ).then((date) {
      if (date != null && date != selectedDate) {
        setState(() {
          selectedDate = DateTime(date.year, date.month);
          yearMonth = DateFormat('yyyy-MM').format(selectedDate);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    String formattedDate = DateFormat('yyyy-MM').format(selectedDate);

    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: const Text('Budget'),
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
              child: InkWell(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      const Icon(Icons.calendar_today, size: 24.0),
                      const SizedBox(width: 8.0),
                      Text(yearMonth),
                    ],
                  ),
                ),
                onTap: () => _selectMonthYear(context),
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
                    BarChartWidget(
                      barData: BarData(
                        expenditureTypes: expenditureTypes,
                        expenditures: expenditures,
                        budgets: budgets,
                      ),
                    ),
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
            // White Separator Line
            Container(
              height: 1,
              color: Colors.white,
              margin: const EdgeInsets.symmetric(vertical: 8),
            ),
            // Display Expenditure Type, Expenditure, Budget
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  // Expenditure Type
                  Expanded(
                    child: Column(
                      children: [
                        for (int i = 0; i < expenditureTypes.length; i++)
                          Text(
                            expenditureTypes[i],
                            style: TextStyle(fontSize: 18),
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
                          Text(
                            '\$${expenditures[i]}',
                            style: TextStyle(fontSize: 18),
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
                          Text(
                            '\$${budgets[i]}',
                            style: TextStyle(fontSize: 18),
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
}

class BarChartWidget extends StatelessWidget {
  final BarData barData;

  BarChartWidget({required this.barData});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(barData.expenditures.length, (index) {
        return Stack(
          alignment: Alignment.topRight,
          children: [
            // Bar
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  height: barData.expenditures[index],
                  width: 20,
                  color: Colors.red,
                ),
                SizedBox(width: 8),
                Container(
                  height: barData.budgets[index],
                  width: 20,
                  color: Colors.blue,
                ),
              ],
            ),
          ],
        );
      }),
    );
  }
}

class BarData {
  final List<String> expenditureTypes;
  final List<double> expenditures;
  final List<double> budgets;

  BarData({required this.expenditureTypes, required this.expenditures, required this.budgets});
}
