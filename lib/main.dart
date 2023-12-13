// main.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'src/theme.dart';
import 'total.dart';
import 'budget.dart';
import 'stock.dart';
import 'accounting.dart';
import 'transaction.dart';
import 'login_page.dart';
import 'profile.dart';


void main() {
  runApp(MyApp());
}

Future<bool> initApp() async {
  WidgetsFlutterBinding.ensureInitialized();
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  if(prefs.getBool('is_logged_in') == null){
    await prefs.setBool('is_logged_in', false);
  }
  final bool isLoggedIn = prefs.getBool('is_logged_in') ?? false;

  return isLoggedIn;
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Future<bool> _isLoggedIn;

  @override
  void initState() {
    super.initState();
    _isLoggedIn = initApp();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _isLoggedIn,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const MaterialApp(
            home: Scaffold(
              body: Center(child: CircularProgressIndicator()),
            ),
          );
        } else if (snapshot.hasError) {
          return MaterialApp(
            home: Scaffold(
              body: Center(child: Text("Error: ${snapshot.error}")),
            ),
          );
        }

        final isLoggedIn = snapshot.data ?? false;

        return MaterialApp(
          title: 'Flutter Demo',
          theme: AppTheme.lightTheme,
          home: isLoggedIn ? MainScreen() : LoginScreen(),
        );
      },
    );
  }
}

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 2;
  final List<Widget> _pages = [
    TotalScreen(),
    BudgetScreen(),
    AccountingScreen(),
    ProfileScreen(),
  ];

  // Placeholder to match the FAB width.
  final BottomNavigationBarItem fabPlaceholder = const BottomNavigationBarItem(
    icon: Icon(null), // Empty icon
    label: 'Placeholder', // Placeholder text
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
          ).then((_) {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => MainScreen()),
                  (Route<dynamic> route) => false,
            );
          });
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
              label: '報表',
            ),
            _buildTabItem(
              index: 1,
              iconData: Icons.edit_document,
              label: '預算',
            ),
            SizedBox(width: 40), // The width of the FAB button
            _buildTabItem(
              index: 2,
              iconData: Icons.update,
              label: '賬簿',
            ),
            _buildTabItem(
              index: 3,
              iconData: Icons.settings,
              label: '用戶',
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
