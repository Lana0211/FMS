import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class StockAddScreen extends StatefulWidget {
  @override
  _StockAddScreenState createState() => _StockAddScreenState();
}

class _StockAddScreenState extends State<StockAddScreen> {
  TextEditingController idController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController sharesController = TextEditingController();
  TextEditingController priceController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            // 不儲存，返回到 StockScreen
            Navigator.of(context).pop();
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: () {
              // 儲存資料，返回到 StockScreen，並顯示新增的 stock
              _saveDataAndReturnToStockScreen();
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: idController,
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly,
              ],
              decoration: const InputDecoration(
                labelText: 'Stock ID',
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: nameController,
              maxLength: 30,
              decoration: const InputDecoration(
                labelText: 'Stock Name',
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: sharesController,
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly,
              ],
              decoration: const InputDecoration(
                labelText: 'Shares',
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: priceController,
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.allow(
                  RegExp(r'^\d+\.?\d{0,2}$'),
                ),
              ],
              decoration: const InputDecoration(
                labelText: 'Current Price',
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _saveDataAndReturnToStockScreen() {
    // TODO: Add logic to save data to the database

    // Simulate a delay (replace with your actual saving logic)
    Future.delayed(const Duration(seconds: 2), () {
      // 儲存完成，返回到 StockScreen
      Navigator.of(context).pop();
    });
  }
}