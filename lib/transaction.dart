import 'package:flutter/material.dart';

class TransactionScreen extends StatefulWidget {
  @override
  _TransactionScreenState createState() => _TransactionScreenState();
}

class _TransactionScreenState extends State<TransactionScreen>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;
  String selectedType = '';
  List<String> expenditureTypes = [
    'Food',
    'Transport',
    'Shopping',
    'Entertain',
    'Healthcare',
    'Rent',
    'Education',
    'Travel',
    'Gifts',
    'Insurance',
    'Technology',
    'Clothing',
    'Hobbies',
    'Others',
  ];

  List<IconData> expenditureIcons = [
    Icons.fastfood,        // Food
    Icons.directions_car,  // Transportation
    Icons.shopping_cart,   // Shopping
    Icons.movie,           // Entertainment
    Icons.local_hospital,  // Healthcare
    Icons.home,            // Rent
    Icons.school,          // Education
    Icons.airplanemode_active, // Travel
    Icons.card_giftcard,   // Gifts
    Icons.local_hospital,  // Insurance
    Icons.devices,         // Technology
    Icons.shopping_bag,    // Clothing
    Icons.brush,           // Hobbies
    Icons.category,        // Others
  ];

  List<String> incomeTypes = [
    'Salary',
    'Freelance',
    'Investments',
    'Gift',
    'Rent',
    'Bonus',
    'Selling',
    'Interest',
    'Refund',
    'Others',
  ];

  List<IconData> incomeIcons = [
    Icons.attach_money,
    Icons.work,
    Icons.trending_up,
    Icons.card_giftcard,
    Icons.home,
    Icons.card_giftcard,
    Icons.local_grocery_store,
    Icons.show_chart,
    Icons.payment,
    Icons.category,
  ];

  TextEditingController remarkController = TextEditingController();
  TextEditingController dollarController = TextEditingController();
  TextEditingController typeController = TextEditingController();
  TextEditingController dateController = TextEditingController();

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
                  // TODO: Add logic to save data and return to homepage
                  _saveDataAndReturnToHomePage();
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
              _buildTypeSelection(expenditureTypes, expenditureIcons),
              // Income Tab
              _buildTypeSelection(incomeTypes, incomeIcons),
            ],
          ),
          bottomNavigationBar: _buildBottomNavigationBar(),
        ),
      ),
    );
  }

  Future<bool> _onWillPop() async {
    // Handle the case when the user presses the back button
    // You can add additional logic here if needed
    return true; // Return true to allow pop
  }

  Widget _buildTypeSelection(List<String> types, List<IconData> icons) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Generate type buttons
          Wrap(
            spacing: 8.0,
            runSpacing: 8.0,
            children: List.generate(types.length, (index) {
              String type = types[index];
              IconData icon = icons[index];

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
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        icon,
                        size: 40,
                      ),
                      const SizedBox(height: 8),
                      Text(type),
                    ],
                  ),
                ),
              );
            }),
          ),
          // Add input fields and buttons
          TextField(
            controller: remarkController,
            decoration: InputDecoration(
              labelText: 'Remark',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: dollarController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Dollar',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  controller: typeController,
                  decoration: InputDecoration(
                    labelText: 'Type',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          TextField(
            controller: dateController,
            decoration: InputDecoration(
              labelText: 'Date',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: () {
              // TODO: Handle save logic
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.check),
                const SizedBox(width: 8),
                Text('Save'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return Container(
      height: MediaQuery.of(context).size.height / 3,
      width: MediaQuery.of(context).size.width,
      color: Colors.white,
      child: Center(
        // Display selected type at the bottom
        child: Text(
          'Selected Type: $selectedType',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
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
