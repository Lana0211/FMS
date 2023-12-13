import 'dart:convert';
import 'dart:ffi';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ExpenditureDeleteScreen extends StatefulWidget {
  final String type;
  final String date;
  final String dollar;
  final int expenditure_id;

  ExpenditureDeleteScreen({required this.type, required this.date, required this.dollar, required this.expenditure_id});
  @override
  _ExpenditureDeleteScreenState createState() => _ExpenditureDeleteScreenState();
}

class _ExpenditureDeleteScreenState extends State<ExpenditureDeleteScreen>
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
    _tabController = TabController(length: 1, vsync: this); // Updated to only one tab
    // 初始化
    selectedType = widget.type;
    dateController.text = widget.date;
    dollarController.text = (double.parse(widget.dollar) * -1).toString();
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
                  _saveDataAndReturnToHomePage();
                },
              ),
            ],
            bottom: TabBar(
              controller: _tabController,
              tabs: const [
                Tab(text: 'Expenditure'),
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Selected Type: $selectedType',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.delete,
                      color: Colors.red, // 更改為紅色
                    ),
                    onPressed: () {
                      _deleteDataAndReturnToHomePage();
                    },
                  ),
                ],
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

  Future<int?> getTypeID(String typeName) async {
    try {
      final response = await http.get(
        Uri.parse('https://db-accounting.azurewebsites.net/api/types?type=expenditure&type_name=$typeName'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data.isNotEmpty) {
          return data['type_id'];
        }
      }
    } catch (e) {
      print('Error: $e');
    }

    return null;
  }



  Future<void> _saveDataAndReturnToHomePage() async {
    // 獲取新的數據
    final int update_id = widget.expenditure_id;
    String updatedType = selectedType;
    String updatedDate = dateController.text;
    String updatedDollar = dollarController.text;

    int? typeId = await getTypeID(updatedType);

    Map<String, dynamic> requestData = {
      'amount': updatedDollar,
      'expenditure_type': typeId,
      'expenditure_date': updatedDate,
    };

    String requestBody = jsonEncode(requestData);

    try {
      // 发送HTTP PUT请求
      final response = await http.put(
        Uri.parse('https://db-accounting.azurewebsites.net/api/expenditures/$update_id'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: requestBody,
      );

        Navigator.of(context).pop();
        print(response.body);
    } catch (e) {
      // 捕获异常，处理网络请求出错的情况
      print('Error: $e');
    }
  }

  Future<void> _deleteDataAndReturnToHomePage() async {
    final int delet_id = widget.expenditure_id;

    try {
      // 发送HTTP DELETE请求
      final response = await http.delete(
        Uri.parse('https://db-accounting.azurewebsites.net/api/expenditures/$delet_id'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      Navigator.of(context).pop(true);
      print(response.body);
    } catch (e) {
      print('Error: $e');
    }
  }


}
