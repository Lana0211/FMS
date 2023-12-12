import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class BudgetAddScreen extends StatefulWidget {
  @override
  _BudgetAddScreenState createState() => _BudgetAddScreenState();
}

class _BudgetAddScreenState extends State<BudgetAddScreen>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;
  String selectedType = '';
  List<String> expenditureTypes = [
    '餐飲',
    '交通',
    '娛樂',
    '購物',
    '醫療',
    '住房',
    '學習',
    '旅行',
    '禮品',
    '水電',
    '通訊',
    '美容',
    '日用',
    '其他',
  ];

  List<IconData> expenditureIcons = [
    Icons.fastfood,
    Icons.directions_car,
    Icons.movie,
    Icons.shopping_cart,
    Icons.local_hospital,
    Icons.home,
    Icons.school,
    Icons.airplanemode_active,
    Icons.card_giftcard,
    Icons.opacity,
    Icons.phone,
    Icons.face,
    Icons.shopping_basket,
    Icons.category,
  ];

  TextEditingController remarkController = TextEditingController();
  TextEditingController dollarController = TextEditingController();
  TextEditingController typeController = TextEditingController();
  TextEditingController dateController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 1, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 1,
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
                Tab(text: 'Budget'),
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
    double iconWidth = MediaQuery.of(context).size.width / 6; // 將圖標的寬度設置為屏幕寬度的三分之一
    double iconFontSize = iconWidth * 0.3;
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
                  width: iconWidth, // 使用計算的圖標寬度
                  height: iconWidth, // 使用計算的圖標寬度
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        icon,
                        size: iconFontSize,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        type,
                        style: TextStyle(fontSize: iconFontSize), // 使用計算的字體大小
                      ),
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
      height: MediaQuery.of(context).size.height * 0.3,
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
    // Validate inputs
    if (selectedType.isEmpty || dollarController.text.isEmpty || dateController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields')),
      );
      return;
    }

    // Assuming the user ID is available in the session or from user input
    int userId = 1; // Replace with actual user ID

    // Get the type ID from the API
    var typeId;
    var apiUrl = 'https://db-accounting.azurewebsites.net/api/types'; // Replace with actual API URL

    try {
      var typeResponse = await http.get(
        Uri.parse('$apiUrl?type_name=$selectedType&type=expenditure'),
      );

      if (typeResponse.statusCode == 200) {
        var typeData = json.decode(typeResponse.body);
        typeId = typeData['type_id'];
      } else {
        throw Exception('Failed to load type ID');
      }

      // Construct the budget data payload
      var budgetData = {
        'user_id': userId,
        'amount': double.parse(dollarController.text),
        'expenditure_type': typeId,
        'budget_date': dateController.text,
      };

      // Print the data to console for debugging
      print('Budget Data to be sent: $budgetData');

      // API URL for creating a budget
      var budgetApiUrl = 'https://db-accounting.azurewebsites.net/api/budgets'; // Replace with actual Budget API URL

      // Make the POST request to save the budget data
      var budgetResponse = await http.post(
        Uri.parse(budgetApiUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(budgetData),
      );


      if (budgetResponse.statusCode == 201) {
        // Successfully saved budget data
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Budget created successfully.')),
        );
        Navigator.of(context).pop(); // Go back to the home page
      } else {
        throw Exception('Failed to save budget data');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }

}