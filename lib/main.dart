// main.dart
import 'package:flutter/material.dart';
import 'src/theme.dart';
import 'home.dart';
import 'total.dart';
// import 'budget.dart';
// import 'stock.dart';
// import 'user.dart';
import 'transaction.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: AppTheme.lightTheme, // Use the light theme
      home: MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  final List<Widget> _pages = [
    TotalScreen(),
    TotalScreen(),
    HomeScreen(),
    TotalScreen(),
    // The TransactionScreen is not part of the bottom navigation pages
  ];

  // Placeholder to match the FAB width.
  final BottomNavigationBarItem fabPlaceholder = const BottomNavigationBarItem(
    icon: Icon(null), // Empty icon
    label: 'Placeholder', // Placeholder text, can be left empty or null for no text
  );

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => TransactionScreen()),
          );
        },
        shape: const CircleBorder(),
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      bottomNavigationBar: BottomAppBar(
        color: AppTheme.floatingActionButtonColor,
        shape: CircularNotchedRectangle(),
        notchMargin: 8.0,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            _buildTabItem(
              index: 0,
              iconData: Icons.account_balance_wallet,
              label: 'Total',
            ),
            _buildTabItem(
              index: 1,
              iconData: Icons.edit_document,
              label: 'Budget',
            ),
            SizedBox(width: 40), // The width of the FAB button
            _buildTabItem(
              index: 2,
              iconData: Icons.settings,
              label: 'Stock',
            ),
            _buildTabItem(
              index: 3,
              iconData: Icons.update,
              label: 'User',
            ),
          ],
        ),
      ),
    );
  }
  Widget _buildTabItem({
    required int index,
    required IconData iconData,
    required String label,
  }) {
    final bool isSelected = _currentIndex == index;

    return Expanded(
      child: SizedBox(
        height: kBottomNavigationBarHeight,
        child: Material(
          type: MaterialType.transparency,
          child: InkWell(
            onTap: () => _onItemTapped(index),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(
                  iconData,
                  color: isSelected ? Colors.blue : Colors.grey,
                ),
                Text(
                  label,
                  style: TextStyle(
                    color: isSelected ? Colors.blue : Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
