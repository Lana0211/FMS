import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
import 'package:fl_chart/fl_chart.dart';

class BudgetScreen extends StatefulWidget {
  @override
  _BudgetScreenState createState() => _BudgetScreenState();
}

class _BudgetScreenState extends State<BudgetScreen> {
  bool isExpenditure = true;
  DateTime selectedDate = DateTime.now();
  String yearMonth = DateFormat('yyyy-MM').format(DateTime.now());
  // Placeholder data for illustration purposes
  List<String> months = ['January', 'February', 'March', 'April', 'May'];
  List<double> expenditures = [1000, 1200, 800, 900, 1100]; // Expenditure for each month
  List<double> budgets = [1200, 1300, 1000, 1100, 1200]; // Budget for each month

  @override
  void initState() {
    super.initState();
    // fetchData();
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
          // typeAndAmountList = [];
          // totalAmount = 0.0;
        });
        // fetchData();
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
      ),
      body: Column(
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
          // Add the following lines to display Expenditure Type, Budget, Expenditure
          Text('Expenditure Type: YourExpenditureType'),
          Text('Budget: \$YourBudgetAmount'),
          Text('Expenditure: \$YourExpenditureAmount'),
          // Bar chart for budget and expenditure comparison
          Container(
            height: MediaQuery.of(context).size.height / 2,
            child: BarChart(
              expenditures: expenditures,
              budgets: budgets,
            ),
          ),
        ],
      ),
    );
  }
}

class BarChart extends StatelessWidget {
  final List<double> expenditures;
  final List<double> budgets;

  BarChart({required this.expenditures, required this.budgets});

  @override
  Widget build(BuildContext context) {
    // Placeholder implementation for the bar chart
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(expenditures.length, (index) {
        return Column(
          children: [
            Container(
              height: expenditures[index], // Expenditure bar height
              width: 20,
              color: Colors.red,
            ),
            Container(
              height: 10, // White line height
              width: 20,
              color: Colors.white,
            ),
            Container(
              height: budgets[index], // Budget bar height
              width: 20,
              color: Colors.blue,
            ),
          ],
        );
      }),
    );
  }
}
