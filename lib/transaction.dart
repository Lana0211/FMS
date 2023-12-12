import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TransactionScreen extends StatefulWidget {
  @override
  _TransactionScreenState createState() => _TransactionScreenState();
}

class _TransactionScreenState extends State<TransactionScreen>
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

  List<String> incomeTypes = [
    '薪水',
    '投資',
    '禮金',
    '租金',
    '兼職',
    '獎金',
    '轉賣',
    '利息',
    '退款',
    '其他',
  ];

  List<IconData> incomeIcons = [
    Icons.attach_money,
    Icons.trending_up,
    Icons.card_giftcard,
    Icons.home,
    Icons.work,
    Icons.local_grocery_store,
    Icons.show_chart,
    Icons.payment,
    Icons.refresh,
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
      height: MediaQuery.of(context).size.height * 0.4,
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
              // Dollar
              const SizedBox(height: 8),
              Container(
                height: MediaQuery.of(context).size.height / 12,
                child: TextField(
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
              ),

              const SizedBox(height: 8),
              // Remark
              Container(
                height: MediaQuery.of(context).size.height / 9,
                child: TextField(
                  controller: remarkController,
                  maxLength: 30, //字數限制
                  decoration: const InputDecoration(
                    labelText: 'Remark',
                    border: OutlineInputBorder(),
                  ),
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
    var typeName = selectedType;
    var apiUrl = 'http://db-accounting.azurewebsites.net/api/types'; // Replace with actual API URL
    var typeCategory = _tabController?.index == 0 ? 'expenditure' : 'income'; // based on the selected tab

    try {
      var typeResponse = await http.get(
        Uri.parse('$apiUrl?type_name=$typeName&type=$typeCategory'),
      );

      if (typeResponse.statusCode == 200) {
        var typeData = json.decode(typeResponse.body);
        typeId = typeData['type_id'];
      } else {
        throw Exception('Failed to load type ID');
      }

      // Construct the data payload
      var data = _tabController?.index == 0 ? {
        'user_id': userId,
        'amount': double.parse(dollarController.text),
        'expenditure_type': typeId,
        'expenditure_date': dateController.text, // Adjust the key according to your API's expected parameters
      }: {
        'user_id': userId,
        'amount': double.parse(dollarController.text),
        'income_type': typeId,
        'income_date': dateController.text,
        // Adjust the key according to your API's expected parameters
      };

      print('Data to be sent: $data');

      var saveUrl = _tabController?.index == 0
          ? 'https://db-accounting.azurewebsites.net/api/expenditures' // Replace with actual Expenditure API URL
          : 'https://db-accounting.azurewebsites.net/api/incomes'; // Replace with actual Income API URL

      // Make the POST request to save the data
      var saveResponse = await http.post(
        Uri.parse(saveUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(data),
      );

      if (saveResponse.statusCode == 201) {
        // Successfully saved data
        Navigator.of(context).pop(); // Go back to the home page
      } else {
        throw Exception('Failed to save data');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }

  @override
  void dispose() {
    _tabController?.dispose();
    remarkController.dispose();
    dollarController.dispose();
    typeController.dispose();
    dateController.dispose();
    super.dispose();
  }


// Future<void> _saveDataAndReturnToHomePage() async {
  //   // Simulate a delay (replace with your actual saving logic)
  //   await Future.delayed(const Duration(seconds: 2));
  //
  //   // Navigate back to the home page
  //   Navigator.of(context).pop();
  // }
  //
  // @override
  // void dispose() {
  //   _tabController?.dispose();
  //   super.dispose();
  // }
}
