import 'package:fianl_project/signin.dart';
import 'package:fianl_project/signup.dart';
import 'package:flutter/material.dart';

import 'autoScroll.dart';


class LoginWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return  Material(
      child: Stack(
          children: [
            AutoScrollPageView(),
            Container(
              alignment: Alignment.center,
              child: Image.asset('images/logo.png',
              ),
            ),
            Container(
              alignment: Alignment.center,
              margin: const EdgeInsets.only(top: 150),
              child: const Text('Stay High',
                style: TextStyle(color: Colors.white,
                    fontWeight: FontWeight.w400,
                    fontSize: 40),
              ),
            ),
            Container(
              alignment: Alignment.center,
              margin: const EdgeInsets.only(top: 250),
              child: const Text('Stay Happy',
                style: TextStyle(color: Colors.white,
                    fontWeight: FontWeight.w400,
                    fontSize: 40),
              ),
            ),
            Container(
              alignment: Alignment.center,
              margin: const EdgeInsets.only(top: 350),
              child: const Text('Always',
                style: TextStyle(color: Colors.white,
                    fontWeight: FontWeight.w400,
                    fontSize: 40),
              ),
            ),
            Row(
              children: [
                Container(
                  width: 125,
                  alignment: Alignment.bottomLeft,
                  margin: const EdgeInsets.only(top: 700, left: 50, bottom: 135),
                  padding: const EdgeInsets.only(top: 3, left: 35, bottom: 15),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: InkWell(
                    onTap: () {
                      // Add your login logic here
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SignWidget()),
                      );
                    },
                    child: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 5.0),
                      child: Text(
                        'Join',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xFF81AA66),
                          fontWeight: FontWeight.w500,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  width: 125,
                  alignment: Alignment.bottomLeft,
                  margin: const EdgeInsets.only(top: 700, left: 50, bottom: 135),
                  padding: const EdgeInsets.only(top: 3, left: 35, bottom: 15),
                  decoration: BoxDecoration(
                    color: null,
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(
                      color: Colors.white, // Màu viền trắng
                      width: 2.0, // Độ dày 1px
                    ),
                  ),
                  child: InkWell(
                    onTap: () {
                      // Add your login logic here
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SigninWidget()),
                      );
                    },
                    child: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 2.0),
                      child: Text(
                        'Login',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                ),

              ],
            ),
            Row(
              children: [
                Container(
                    alignment: Alignment.bottomLeft,
                    margin: const EdgeInsets.only(bottom: 90,left: 100),
                    child: Image.asset('images/google logo.png')
                ),
                Container(
                    alignment: Alignment.bottomLeft,
                    margin: const EdgeInsets.only(bottom: 86,left: 10),
                    child: const Text('Continue with google',style: TextStyle(color: Colors.white,fontSize: 20),)
                ),
              ],
            )
          ]
      ),
    );
  }
}
