import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'), // Replace with your app's title
      ),
      body: Center(
        child: Text(
          'Welcome to the Home Page!', // Replace with your actual content
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add your onPressed code here!
        },
        tooltip: 'Increment',
        shape: const CircleBorder(),
        child: const Icon(Icons.add), // Make the FAB circular
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 6.0,
        clipBehavior: Clip.antiAlias,
        child: SizedBox(
          height: kBottomNavigationBarHeight, // Adjust the height as needed
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround, // Align items evenly
            children: <Widget>[
              IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: () {
                  // Handle refresh action
                },
              ),
              IconButton(
                icon: const Icon(Icons.book),
                onPressed: () {
                  // Handle book action
                },
              ),
              const SizedBox(), // Add an empty SizedBox in the middle for the FAB
              IconButton(
                icon: const Icon(Icons.settings),
                onPressed: () {
                  // Handle settings action
                },
              ),
              IconButton(
                icon: const Icon(Icons.update),
                onPressed: () {
                  // Handle update action
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
