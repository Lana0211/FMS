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
    // 初始化
    selectedType = widget.type;
    dateController.text = widget.date;
    dollarController.text = widget.dollar;
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
                      // TODO: Add logic to delete data
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
              IconButton(
                icon: Icon(
                  Icons.delete,
                  color: Colors.red, // 更改為紅色
                ),
                onPressed: () {
                  // TODO: Add logic to delete data
                  _deleteDataAndReturnToHomePage();
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _deleteDataAndReturnToHomePage() async {
    // TODO: 在這裡實現刪除數據的邏輯，這可能涉及發送 HTTP 刪除請求或調用某個服務。
    // 你需要根據你的實際需求來實現這部分的邏輯。

    // 延遲一些時間，模擬刪除的過程
    await Future.delayed(const Duration(seconds: 2));

    // TODO: 刪除數據的邏輯完成後，你可能還需要通知用戶或執行其他操作。

    // 返回上一個頁面，並將一個標記指示刪除操作的結果返回
    Navigator.of(context).pop(true);
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
    // 獲取新的數據
    String updatedType = selectedType;
    String updatedDate = dateController.text;
    String updatedDollar = dollarController.text;

    // TODO: 在這裡實現將新的數據保存到數據庫的邏輯，這可能涉及發送 HTTP 請求或調用某個服務。
    // 你需要根據你的實際需求來實現這部分的邏輯。

    // 延遲一些時間，模擬保存的過程
    await Future.delayed(const Duration(seconds: 2));

    // 創建一個包含新數據的 Map
    Map<String, dynamic> updatedData = {
      'type': updatedType,
      'date': updatedDate,
      'dollar': updatedDollar,
    };

    // 通過 Navigator 返回上一個頁面，並將更新的數據作為結果返回
    Navigator.of(context).pop(updatedData);
  }
}


