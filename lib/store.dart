import 'package:fianl_project/flowers.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'menuDialog.dart';
class StoreWidget extends StatefulWidget {
  final String id;
  StoreWidget({required this.id});
  @override
  _StoreWidget createState() => _StoreWidget();
}
class _StoreWidget extends State<StoreWidget> {
  late String email = '';

  @override
  void initState() {
    super.initState();
    fetchUserData(widget.id);
  }

  Future<void> fetchUserData(String userId) async {
    final response = await http.get(Uri.parse('http://localhost:3000/$userId'));

    if (response.statusCode == 200) {
      // If the server returns an OK response, parse the JSON
      final userData = json.decode(response.body);

      // Check if 'email' is not null before updating the state
      if (userData['email'] != null) {
        setState(() {
          email = userData['email'];
        });
      }
    } else {
      // If the server did not return a 200 OK response,
      // throw an exception.
      throw Exception('Failed to load user data');
    }
  }
  @override
  Widget build(BuildContext context) {
    return Material (
            child: ListView (
              padding: const EdgeInsets.only(top: 0),
              scrollDirection: Axis.vertical,
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 80,left: 30,bottom: 40),
                  child: Row (
                    children: [
                      GestureDetector(
                        onTap: () {
                          // Hiển thị hộp thoại hoặc bottom sheet khi click vào hình ảnh menu
                          _showMenuDialog();
                        },
                        child: Image.asset('images/menu.png'),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 22,right: 80),
                        child: Image.asset('images/logo2.png'),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 27),
                        child: Image.asset('images/search.png'),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 28),
                        child: Image.asset('images/heart.png'),
                      ),
                      Image.asset('images/avatar.png'),
                    ],
                  ),
                ),
                Stack(
                  children: [
                    Container(
                      padding: const EdgeInsets.only(left: 45),
                      child: Image.asset('images/bg-n.jpg'),
                    ),
                    Column(
                      children: [
                          Container(
                            padding: const EdgeInsets.only(top: 75,bottom: 12),
                            alignment: Alignment.center,
                            child: Image.asset('images/maple-leaf.png'),
                            ),
                        Container(
                          alignment: Alignment.bottomCenter,
                          child:const Text('   50% Off\n Everything',
                            style: TextStyle(
                                fontSize: 36,
                                fontWeight: FontWeight.w700,
                                height: 1.3
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.only(top: 12),
                          alignment: Alignment.bottomCenter,
                          child:const Text('with code: sativa 123',
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
                Container(
                  margin: const EdgeInsets.only(top: 35),
                  alignment: Alignment.center,
                  child: const Column(
                    children: [
                      Text('Top Categories',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 8),
                        child: Text('Mark the occassion with these must have\n '
                            '                               products',
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              height: 1.5,
                            color: Colors.grey
                          ),
                        ),
                      ),

                    ],
                  ),
                ),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 46,top: 20,right: 32),
                      child: _buildCustomLabel('Flower pot', 'images/plant-pot.png', const Color(0xFF5489B1)),
                    ),
                    GestureDetector(
                      onTap: () {
                        // Màn hình đăng nhập
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => FlowersWidget(id: widget.id,)),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: _buildCustomLabel('Flowers', 'images/flower.png', const Color(0xFFEAB351)),
                      ),
                    )
                    ,Padding(
                      padding: const EdgeInsets.only(left: 32,top: 20),
                      child: _buildCustomLabel('Fertilizer', 'images/fertilizer.png', const Color(0xFF759D1E)),
                    ),


    ],
                )
              ],
            ),
    );
  }
  Widget _buildCustomLabel(String text, String image, Color color) {
    return Column(
      children: [
       Container(
         margin: const EdgeInsets.only(bottom: 17),
         width: 84,
         height: 85,
         decoration: BoxDecoration(
           color: color.withOpacity(0.1), // Giá trị 0.5 ở đây là độ mờ, có thể điều chỉnh từ 0.0 đến 1.0
         ),
         child: Image.asset(image),
       ),
        Text(text,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500
          ),
        )
      ],
    );
  }
  void _showMenuDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return MenuDialog(email: email);
      },
    );
  }


}