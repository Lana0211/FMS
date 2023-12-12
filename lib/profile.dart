import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'login_page.dart'; // Import your login screen file

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late String userName = '';
  late String phone = '';
  late String email = '';

  @override
  void initState() {
    super.initState();
    // Call the backend API to get user data
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      // Replace the URL with your backend API endpoint
      var apiUrl = 'https://db-accounting.azurewebsites.net/api/accounts/1';
      var response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode != 404) {
        // Parse the JSON response
        var data = json.decode(response.body);

        // Extract user information from the data
        setState(() {
          userName = data['user_name'];
          phone = data['user_phone'];
          email = data['user_mail'];
        });
      } else {
        // Handle the case of a failed request
        print('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      // Handle exceptions
      print('Error fetching data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              leading: Icon(Icons.person), // Person icon on the left
              title: Text(
                'User Name: $userName',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            ListTile(
              leading: Icon(Icons.phone), // Phone icon on the left
              title: Text(
                'Phone: $phone',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            ListTile(
              leading: Icon(Icons.email), // Email icon on the left
              title: Text(
                'Email: $email',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            const Divider(
              thickness: 2.0, // Set the thickness to make the divider bolder
            ), // Divider below the email ListTile
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      // Navigate to the login screen on logout
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => LoginScreen()),
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0), // Border radius for a square button
                      ),
                      side: BorderSide(
                        color: Color(0xFFEA0000), // Border color
                      ),
                    ),
                    child: Text(
                      'Logout',
                      style: TextStyle(
                        color: Color(0xFFEA0000), // Text color
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}