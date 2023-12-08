import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  final TextEditingController _loginAccountController = TextEditingController();
  final TextEditingController _loginPasswordController = TextEditingController();
  final TextEditingController _signupAccountController = TextEditingController();
  final TextEditingController _signupPasswordController = TextEditingController();
  final TextEditingController _checkPasswordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _mailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Welcome'),
          centerTitle: true,
          backgroundColor: const Color(0xFFC4E1FF),
          bottom: const TabBar(
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
          color: const Color(0xFFC4E1FF),
          padding: const EdgeInsets.all(16.0),
          child: TabBarView(
            children: [
              // LogIn Tab
              Column(
                children: [
                  const SizedBox(height: 16.0),
                  Container(
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: Colors.white, // 半透明白色
                      borderRadius: BorderRadius.circular(5.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: const Offset(0, 3), // changes the position of shadow
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        TextField(
                          controller: _loginAccountController,
                          decoration: const InputDecoration(
                            labelText: 'Account',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 16.0),
                        TextField(
                          controller: _loginPasswordController,
                          decoration: const InputDecoration(
                            labelText: 'Password',
                            border: OutlineInputBorder(),
                          ),
                          obscureText: true,
                        ),
                        const SizedBox(height: 24.0),
                        ElevatedButton(
                          onPressed: _login,
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(Color(0xFF66B3FF)),
                          ),
                          child: const Text(
                            'Log In',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              // SignUp Tab
              Column(
                children: [
                  const SizedBox(height: 16.0),
                  Container(
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.7), // 透明度
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    child: Column(
                      children: [
                        TextField(
                          controller: _nameController,
                          decoration: const InputDecoration(
                            labelText: 'Name',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 16.0),
                        TextField(
                          controller: _mailController,
                          decoration: const InputDecoration(
                            labelText: 'Mail',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 16.0),
                        TextField(
                          controller: _phoneController,
                          decoration: const InputDecoration(
                            labelText: 'Phone',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 16.0),
                        TextField(
                          controller: _signupAccountController,
                          decoration: const InputDecoration(
                            labelText: 'Account',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 16.0),
                        TextField(
                          controller: _signupPasswordController,
                          decoration: const InputDecoration(
                            labelText: 'Password',
                            border: OutlineInputBorder(),
                          ),
                          obscureText: true,
                        ),
                        const SizedBox(height: 16.0),
                        TextField(
                          controller: _checkPasswordController,
                          decoration: const InputDecoration(
                            labelText: 'Check Password',
                            border: OutlineInputBorder(),
                          ),
                          obscureText: true,
                        ),
                        const SizedBox(height: 24.0),
                        ElevatedButton(
                          onPressed: _signup,
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(const Color(0xFF66B3FF)), // BTN color
                          ),
                          child: const Text(
                            'Sign Up',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
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
      Uri.parse('http://127.0.0.1:5000/login'),
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
    final String checkPassword = _checkPasswordController.text;
    final String name = _nameController.text;
    final String mail = _mailController.text;
    final String phone = _phoneController.text;

    if (password != checkPassword) {
      print('Password not matched.');
      return;
    }

    final response = await http.post(
      Uri.parse('YOUR_FLASK_BACKEND_API_ENDPOINT/signup'),
      body: {
        'account': account,
        'name': name,
        'mail': mail,
        'phone': phone,
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
