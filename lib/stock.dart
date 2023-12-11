import 'package:flutter/material.dart';
import 'stock_add.dart';

class StockScreen extends StatefulWidget {
  @override
  _StockScreenState createState() => _StockScreenState();
}

class _StockScreenState extends State<StockScreen> {
  List<Stock> stocks = [
    Stock('AAPL', 'Apple Inc.', 10, 150.0, 160.0),
    Stock('GOOGL', 'Alphabet Inc.', 5, 2000.0, 2050.0),
    // Add more stocks as needed
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Stocks'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            iconSize: 30.0,
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => StockAddScreen(),
                ),
              );
            },
          ),
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(80.0),
          child: Column(
            children: [
              Center(
                child: Text(
                  'Shareholding',
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: stocks.length,
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.all(8.0),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 第一排
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Stock'),
                      Text('Shares'),
                      Text('Current Price'),
                      Text('Bought Price'),
                      Text('Profit/Loss'),
                    ],
                  ),
                  SizedBox(height: 8),  // 增加間距
                  // 第二排
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: 180, // 調整寬度
                        child: Text('${stocks[index].name} (${stocks[index].symbol}) ${stocks[index].symbol}'),
                      ),
                      Text('${stocks[index].shares}'),
                      Text('\$${stocks[index].currentPrice}'),
                      Text('\$${stocks[index].boughtPrice}'),
                      Text('\$${stocks[index].calculateProfitLoss()}'),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class Stock {
  final String symbol;
  final String name;
  final int shares;
  final double boughtPrice;
  final double currentPrice;

  Stock(this.symbol, this.name, this.shares, this.boughtPrice, this.currentPrice);

  double calculateProfitLoss() {
    return (currentPrice - boughtPrice) * shares;
  }
}
