import 'package:flutter/material.dart';

class TransactionScreen extends StatefulWidget {
  @override
  _TransactionScreenState createState() => _TransactionScreenState();
}

class _TransactionScreenState extends State<TransactionScreen>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;
  String selectedType = '';
  List<String> expenditureTypes = ['Expense 1', 'Expense 2', 'Expense 3', 'Expense 4'];
  List<String> incomeTypes = ['Income 1', 'Income 2', 'Income 3', 'Income 4'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: WillPopScope(
        onWillPop: _onWillPop,
        child: Scaffold(
          appBar: AppBar(
            title: Text('Transaction'),
            leading: IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            actions: [
              IconButton(
                icon: Icon(Icons.check),
                onPressed: () {
                  _showConfirmationDialog();
                },
              ),
            ],
            bottom: TabBar(
              controller: _tabController,
              tabs: [
                Tab(text: 'Expenditure'),
                Tab(text: 'Income'),
              ],
              labelColor: Colors.blue,
              unselectedLabelColor: Colors.grey,
              indicatorColor: Colors.blue,
            ),
          ),
          body: TabBarView(
            controller: _tabController,
            children: [
              // Expenditure Tab
              _buildTypeSelection(expenditureTypes),
              // Income Tab
              _buildTypeSelection(incomeTypes),
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> _onWillPop() async {
    return true;
  }

  Widget _buildTypeSelection(List<String> types) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 8.0,
            runSpacing: 8.0,
            children: types.map((type) {
              return ElevatedButton(
                onPressed: () {
                  setState(() {
                    selectedType = type;
                  });
                },
                style: ElevatedButton.styleFrom(
                  primary: type == selectedType ? Colors.blue : null,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                child: Container(
                  width: 80,
                  height: 80,
                  alignment: Alignment.center,
                  child: Text(type),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 16),
          Text(
            'Selected Type: $selectedType',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Future<void> _showConfirmationDialog() async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Container(
            width: MediaQuery.of(context).size.width / 3,
            padding: EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Confirmation',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 16.0),
                Text('Are you sure you want to save?'),
                SizedBox(height: 16.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text('Cancel'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        // TODO: Add logic to save data and return to homepage
                        _saveDataAndReturnToHomePage();
                      },
                      child: Text('Confirm'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _saveDataAndReturnToHomePage() async {
    // TODO: Add logic to save data to the database
    // Simulate a delay (replace with your actual saving logic)
    await Future.delayed(Duration(seconds: 2));

    // Navigate back to the home page
    Navigator.of(context).pop();
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }
}
