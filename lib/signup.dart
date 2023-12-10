import 'package:fianl_project/signin.dart';
import 'package:fianl_project/store.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


class SignWidget extends StatefulWidget {
  @override
  _SignWidget createState() => _SignWidget();
}

class _SignWidget extends State<SignWidget> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  Future<void> registerUser(String email, String password) async {
    final response = await http.post(
      Uri.parse("http://localhost:3000/register"),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'email':email,
        'password': password,
      }),
    );
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');
    if (response.statusCode == 201) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Login Successful'),
            content: const Text('You have successfully logged in.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
      await Future.delayed(Duration(seconds: 1));
      final Map<String, dynamic> userData = jsonDecode(response.body);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => StoreWidget(id:userData['_id'])
        ),
      );
    } else {
      // Xử lý khi đăng nhập thất bại, ví dụ: hiển thị thông báo lỗi
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Login Failed'),
            content: const Text('Invalid username or password.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    return Material(
      child:
        ListView(
          padding: const EdgeInsets.only(top: 0),
          scrollDirection: Axis.vertical,
          children: [
            Stack(
              children: [
                Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 100),
                      alignment: Alignment.topCenter,
                      child: Image.asset(
                        'images/logo1.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 18),
                      child: const Text(
                        'Create your',
                        style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 10, bottom: 30),
                      child: const Text(
                        'account',
                        style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(left: 30, right: 30),
                      child: TextField(
                        controller: emailController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(left: 30, right: 30, top: 35),
                      child: TextField(
                        controller: passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    Container(
                      width: 500,
                      padding: const EdgeInsets.only(left: 30, top: 10, bottom: 35),
                      child: Row(
                        children: [
                          Container(
                            width: 20,
                            height: 20,
                            child: Checkbox(
                              value: isChecked,
                              onChanged: (value) {
                                setState(() {
                                  isChecked = value!;
                                });
                              },
                            ),
                          ),
                          const Expanded(
                            child: Column(
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(top: 15,right: 35),
                                  child: Text('By creating an account you agree with our terms',
                                    style: TextStyle(
                                      color:  Color(0xFF81AA66),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: 5,right: 245),
                                  child: Text('and conditions',
                                    style: TextStyle(
                                      color:  Color(0xFF81AA66),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(
                      height: 50,
                      width: 350,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: const Color(0xFF81AA66),
                        ),
                        onPressed: () {
                          registerUser(emailController.text, passwordController.text);

                        },
                        child: const Text(
                          'Create an account',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 120, top: 45),
                      child: Row(
                        children: <Widget>[
                          const Text(
                            'Already a member?',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Expanded(
                            child: TextButton(
                              child: const Padding(
                                padding: EdgeInsets.only(top: 0,right: 95),
                                child: Text(
                                  'Login',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xFF81AA66),
                                  ),
                                ),
                              ),
                              onPressed: () {
                                // Màn hình đăng nhập
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => SigninWidget()),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    )

                  ],
                ),
                Positioned(
                  top: 305,
                  left: 40,
                  child: _buildCustomLabel('EMAIL ADDRESS'),
                ),
                Positioned(
                  top: 390,
                  left: 40,
                  child: _buildCustomLabel('PASSWORD'),
                ),
                Positioned(
                  top: 415,
                  right: 40,
                  child: Container(
                    padding: const EdgeInsets.only(top: 2, bottom: 2, left: 9, right: 9),
                    child: Image.asset('images/eye.png'),
                  ),
                ),
              ],
            ),
          ],
        ),
    );

  }

  Widget _buildCustomLabel(String label) {
    return Container(
      padding: const EdgeInsets.only(top: 2, bottom: 2, left: 9, right: 9),
      decoration: BoxDecoration(
        color: const Color(0xFF81AA66),
        borderRadius: BorderRadius.circular(25),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
      ),
    );
  }
}
