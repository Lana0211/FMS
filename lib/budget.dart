// TODO: rebase final version on this
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
                    BarChart(
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
            // Display Expenditure Type, Budget, Expenditure
            for (int i = 0; i < expenditureTypes.length; i++)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('${expenditureTypes[i]} - Expenditure: \$${expenditures[i]} | Budget: \$${budgets[i]}'),
              ),
          ],
        ),
      ),
    );
  }
}

class BarChart extends StatelessWidget {
  final BarData barData;

  BarChart({required this.barData});

  @override
  Widget build(BuildContext context) {
    double maxHeight = barData.expenditures.reduce((a, b) => a > b ? a : b);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(barData.expenditures.length, (index) {
        return Row(
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
