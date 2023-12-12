import 'package:flutter/material.dart';
import 'total.dart';
import 'transaction.dart';
import 'budget.dart';
import 'stock.dart';
import 'accounting.dart';
import 'profile.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String displayContent = 'Welcome to the Home Page!';

  void updateContent(String content) {
    setState(() {
      displayContent = content;
    });
  }

  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: Center(
        child: Text(
          displayContent,
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => TransactionScreen()),
          );
        },
        tooltip: 'Increment',
        shape: const CircleBorder(),
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 6.0,
        clipBehavior: Clip.antiAlias,
        child: SizedBox(
          height: kBottomNavigationBarHeight,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              IconButton(
                icon: const Icon(Icons.account_balance_wallet),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => TotalScreen()),
                  ).then((value) {
                    // This code runs when the TotalScreen page is popped.
                    updateContent('Welcome to the Home Page!');
                  });
                },
                color: _currentIndex == 0 ? Colors.blue : Colors.grey,
              ),
              IconButton(
                icon: const Icon(Icons.edit_document),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => BudgetScreen()),
                  ).then((value) {
                    // This code runs when the TotalScreen page is popped.
                    updateContent('Welcome to the Home Page!');
                  });
                  // Handle edit_document action
                },
                color: _currentIndex == 1 ? Colors.blue : Colors.grey,
              ),
              const SizedBox(),
              IconButton(
                icon: const Icon(Icons.settings),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ProfileScreen()),
                  ).then((value) {
                    // This code runs when the TotalScreen page is popped.
                    updateContent('Welcome to the Home Page!');
                  });
                  // Handle settings action
                },
                color: _currentIndex == 2 ? Colors.blue : Colors.grey,
              ),
              IconButton(
                icon: const Icon(Icons.update),
                onPressed: () {Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AccountingScreen()),
                ).then((value) {
                  // This code runs when the TotalScreen page is popped.
                  updateContent('Welcome to the Home Page!');
                });
                  // Handle update action
                },
                color: _currentIndex == 3 ? Colors.blue : Colors.grey,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

