import 'package:flutter/material.dart';

import 'login.dart';
class MenuDialog extends StatefulWidget {
  final String email;

  MenuDialog({required this.email});

  @override
  _MenuDialogState createState() => _MenuDialogState();
}

class _MenuDialogState extends State<MenuDialog> {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Stack(
        children: [
          Positioned(
            left: 0,
            top: 0,
            child: Container(
              color: Colors.white,
              width: 310,
              height: 1000,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 72, bottom: 22),
                    child: Image.asset('images/logo2.png'),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 18),
                    child: Image.asset(
                      'images/avatar1.png',
                      width: 85,
                      height: 85,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Text(
                    widget.email,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 12,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 25, right: 165),
                    child: Column(
                      children: [
                        _buildCustomText('Explore        ', const Color(0xFF759D1E)),
                        _buildCustomText('Vapes           ', const Color(0xFF999999)),
                        _buildCustomText('Extracts       ', const Color(0xFF999999)),
                        _buildCustomText('Edibles        ', const Color(0xFF999999)),
                        _buildCustomText('Flowers        ', const Color(0xFF999999)),
                        _buildCustomText('Accessories', const Color(0xFF999999)),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      // Màn hình đăng nhập
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => LoginWidget()),
                      );
                    },
                    child: Container(
                      margin: const EdgeInsets.only(top: 45, right: 200),
                      child: _buildCustomText('Log Out', const Color(0xFFE56C44)),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            left: 310,
            child: Column(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop(); // Close the dialog
                  },
                  child: Container(
                    width: 100,
                    height: 1000,
                    color: Colors.transparent,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCustomText(String text, Color color) {
    return Container(
      padding: const EdgeInsets.only(left: 30, bottom: 45),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: color,
        ),
      ),
    );
  }
}
