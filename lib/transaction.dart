import 'package:flutter/material.dart';

class transactionScreen extends StatefulWidget {
  final String recordType;

  transactionScreen({required this.recordType});

  @override
  _transactionScreenState createState() => _transactionScreenState();
}

class _transactionScreenState extends State<transactionScreen> {
  final List<String> typeOptions = ['Type 1', 'Type 2', 'Type 3', 'Type 4'];
  String selectedType = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.recordType),
        leading: IconButton(
          icon: Icon(Icons.close),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.check),
            onPressed: () {
              print('Selected Type: $selectedType');
              // TODO: Add your logic to save the data to the database
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Select Type:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Center(
              child: Wrap(
                spacing: 8.0,
                runSpacing: 8.0,
                children: typeOptions.map((type) {
                  return ElevatedButton(
                    onPressed: () {
                      setState(() {
                        selectedType = type;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      primary: type == selectedType ? Colors.blue : null,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    child: Text(type),
                  );
                }).toList(),
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Selected Type: $selectedType',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
