import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TransactionDeleteScreen extends StatefulWidget {
  final String type;
  final String date;
  final String dollar;

  TransactionDeleteScreen({required this.type, required this.date, required this.dollar,});
  @override
  _TransactionDeleteScreenState createState() => _TransactionDeleteScreenState();
}

class _TransactionDeleteScreenState extends State<TransactionDeleteScreen>
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
              icon: const Icon(Icons.close),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.check),
                onPressed: () {
                  // TODO: Add logic to save data and return to homepage
                  _saveDataAndReturnToHomePage();
                },
              ),
            ],
            bottom: TabBar(
              controller: _tabController,
              tabs: const [
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
              SingleChildScrollView(
                child: _buildTypeSelection(expenditureTypes, expenditureIcons),
              ),
              SingleChildScrollView(
                child: _buildTypeSelection(incomeTypes, incomeIcons),
              ),
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
        ],
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return Container(
      height: MediaQuery.of(context).size.height / 2,
      width: MediaQuery.of(context).size.width,
      color: Colors.white,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Selected Type
              Text(
                'Selected Type: $selectedType',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              // Display selected type at the bottom
              const SizedBox(height: 8),
              // Date
              Row(
                children: [
                  ElevatedButton(
                    onPressed: () => _selectDate(context),
                    child: const Text('Select Date'),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '${dateController.text}',
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              // Dollar
              TextField(
                controller: dollarController,
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[ //只能輸入數字
                  FilteringTextInputFormatter.digitsOnly,
                ],
                decoration: const InputDecoration(
                  labelText: 'Dollar',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 8),
              // Remark
              TextField(
                controller: remarkController,
                maxLength: 30, //字數限制
                decoration: const InputDecoration(
                  labelText: 'Remark',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      // 格式化選擇的日期，只保留日期部分
      final formattedDate = "${picked.year}-${picked.month}-${picked.day}";
      setState(() {
        dateController.text = formattedDate;
      });
    }
  }

  Future<void> _saveDataAndReturnToHomePage() async {
    // TODO: Add logic to save data to the database
    // Simulate a delay (replace with your actual saving logic)
    await Future.delayed(const Duration(seconds: 2));

    // Navigate back to the home page
    Navigator.of(context).pop();
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }
}
