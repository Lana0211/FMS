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
    String apiUrl;
    String ExpenditureOrIncome = _tabController?.index == 0 ? 'expenditure' : 'income';
    // Map<String, dynamic> postData = {
    //   'user_id': 1, // 這裡應該是用戶ID，請替換為實際的用戶ID
    //   'amount': double.parse(dollarController.text), // 從UI獲取金額
    //   '{$ExpenditureOrIncome}_type': selectedType,
    //   '{$ExpenditureOrIncome}_date': dateController.text,
    // };

    if (_tabController?.index == 0) {
      // 如果是支出（Expenditure）
      // apiUrl = 'https://db-accounting.azurewebsites.net/api/expenditures';
      apiUrl = 'https://10.0.2.2:5000/api/expenditures';
    } else {
      // 如果是收入（Income）
      // apiUrl = 'https://db-accounting.azurewebsites.net/api/incomes';
      apiUrl = 'https://10.0.2.2:5000/api/incomes';
    }

    // 调用API获取type_name对应的type_id
    String typeCategory = _tabController?.index == 0 ? 'expenditure' : 'income';
    // String getTypeUrl = 'https://db-accounting.azurewebsites.net/api/types?type_name={$selectedType}s&type=$typeCategory';
    String getTypeUrl = 'https://10.0.2.2:5000/api/types?type_name={$selectedType}s&type=$typeCategory';

    try {
      final response = await http.get(
        Uri.parse(getTypeUrl),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        if (responseData.isNotEmpty) {

          final int typeId = responseData['type_id'];

          // 调用API保存数据
          final saveResponse = await http.post(
            Uri.parse(apiUrl),
            headers: {
              'Content-Type': 'application/json',
            },
            body: jsonEncode({
              // 'user_id': 1, // This should be the actual user ID
              // 'amount': double.parse(dollarController.text).toStringAsFixed(2), // Format to 2 decimal places
              // '${ExpenditureOrIncome}_type': typeId,
              // '${ExpenditureOrIncome}_date': dateController.text,
              {
                "user_id": 1,
                "amount": 100.00,
                "expenditure_type": 1,
                "expenditure_date": "2023-12-12"
              }
            }),
          );

          final responsetest = jsonDecode(response.body);
          print('API Response Data: $responsetest');


          if (saveResponse.statusCode == 201) {
            // 如果成功保存数据，返回到主页
            Navigator.of(context).pop();
          } else {
            // 失败处理，你可以根据实际需要处理错误
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text('Error'),
                  content: const Text('Failed to save data. Please try again later.'),
                  actions: <Widget>[
                    TextButton(
                      child: Text('OK'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                );
              },
            );
          }
        } else {
          // 失败处理，type_name不存在
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text('Error'),
                content: Text('Selected type does not exist.'),
                actions: <Widget>[
                  TextButton(
                    child: Text('OK'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
        }
      } else {
        // 失败处理，你可以根据实际需要处理错误
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Error'),
              content: Text('Failed to fetch type data. Please try again later.'),
              actions: <Widget>[
                TextButton(
                  child: Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      }
    } catch (error) {
      // 异常处理，你可以根据实际需要处理异常
      print('Error: $error');
      }
    }





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
