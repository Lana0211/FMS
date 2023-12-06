import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _accountController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  TextEditingController _loginAccountController = TextEditingController();
  TextEditingController _loginPasswordController = TextEditingController();
  TextEditingController _signupAccountController = TextEditingController();
  TextEditingController _signupPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Welcome'),
          centerTitle: true,
          backgroundColor: Color(0xFFC4E1FF),
          bottom: TabBar(
            tabs: [
              Tab(text: 'LogIn'),
              Tab(text: 'SignUp'),
            ],
            labelColor: Colors.blue,
            unselectedLabelColor: Colors.grey,
            indicatorColor: Colors.blue,
          ),
        ),
        body: Container(
          color: Color(0xFFC4E1FF),
          padding: EdgeInsets.all(16.0),
          child: TabBarView(
            children: [
              // LogIn Tab
              Column(
                children: [
                  SizedBox(height: 16.0),
                  Container(
                    padding: EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    child: Column(
                      children: [
                        TextField(
                          controller: _loginAccountController,
                          decoration: InputDecoration(
                            labelText: 'Account',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        SizedBox(height: 16.0),
                        TextField(
                          controller: _loginPasswordController,
                          decoration: InputDecoration(
                            labelText: 'Password',
                            border: OutlineInputBorder(),
                          ),
                          obscureText: true,
                        ),
                        SizedBox(height: 24.0),
                        ElevatedButton(
                          onPressed: _login,
                          child: Text('LogIn'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              // SignUp Tab
              Column(
                children: [
                  SizedBox(height: 16.0),
                  Container(
                    padding: EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    child: Column(
                      children: [
                        // Add SignUp UI components here
                        TextField(
                          controller: _signupAccountController,
                          decoration: InputDecoration(
                            labelText: 'Account',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        SizedBox(height: 16.0),
                        TextField(
                          controller: _signupPasswordController,
                          decoration: InputDecoration(
                            labelText: 'Password',
                            border: OutlineInputBorder(),
                          ),
                          obscureText: true,
                        ),
                        SizedBox(height: 24.0),
                        ElevatedButton(
                          onPressed: _signup,
                          child: Text('SignUp'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _login() async {
    final String account = _loginAccountController.text;
    final String password = _loginPasswordController.text;

    final response = await http.post(
      Uri.parse('YOUR_FLASK_BACKEND_API_ENDPOINT/login'),
      body: {
        'account': account,
        'password': password,
      },
    );
    print('LogIn');
  }

  Future<void> _signup() async {
    final String account = _signupAccountController.text;
    final String password = _signupPasswordController.text;

    final response = await http.post(
      Uri.parse('YOUR_FLASK_BACKEND_API_ENDPOINT/login'),
      body: {
        'account': account,
        'password': password,
      },
    );
    print('SignUp');
  }
}

void main() {
  runApp(MaterialApp(
    home: LoginPage(),
  ));
}
