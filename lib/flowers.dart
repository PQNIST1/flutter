import 'package:fianl_project/bag.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'custom.dart';
import 'menuDialog.dart';

class FlowersWidget extends StatefulWidget {
  final String id;
  FlowersWidget({required this.id});
  @override
  _FlowersWidgetState createState() => _FlowersWidgetState();
}

class _FlowersWidgetState extends State<FlowersWidget>{
  late String email = '';
  @override
  void initState() {
    super.initState();
    fetchUserData(widget.id);
    fetchProducts();
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

  List<Map<String, dynamic>> products = [];
  Future<void> fetchProducts() async {
    final response = await http.get(Uri.parse('http://localhost:3000/products'));

    if (response.statusCode == 200) {
      // If the server returns an OK response, parse the JSON
      final List<dynamic> productList = json.decode(response.body);
      // Update the state with the fetched data
      setState(() {
        products = List<Map<String, dynamic>>.from(productList);
      });
    } else {
      // If the server did not return a 200 OK response,
      // throw an exception.
      throw Exception('Failed to load products');
    }
  }
  String? selectedCategory;
  @override
  Widget build(BuildContext context) {
    return Material(
      child: ListView(
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
                  padding: const EdgeInsets.only(left: 22,right: 140),
                  child: Image.asset('images/logo2.png'),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => BagWidget(id:widget.id)),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(right: 28),
                    child: Image.asset('images/heart.png'),
                  ),
                ),
                Image.asset('images/avatar.png'),
              ],
            ),
          ),
          Stack(
            children:[
              Padding(
                padding: EdgeInsets.only(left: 30,right: 30),
                child: TextField(
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Search here'
                    )
                ),
              ),
              Positioned(
                top: 20,
                right: 55,
                  child: Image.asset('images/search.png'),
              ),
          ]
          ),
          SingleChildScrollView(
            padding: const EdgeInsets.only(top: 24,right: 10),
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                // Các widget con của Row sẽ được sắp xếp theo chiều ngang và có thể cuộn ngang
                _buildCustomBar('Flowers'),
                _buildCustomBar('Vapes'),
                _buildCustomBar('Extracts'),
                _buildCustomBar('Edibles'),
                _buildCustomBar('Accessories'),
                // Thêm các widget con khác nếu cần
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Color(0xFF759D1E).withOpacity(0.03),
            ),
            padding: const EdgeInsets.only(top: 35, left: 30, right: 35),
            child: Column(
              children: [
                for (final product in products)
                  CustomProductWidget(
                    t_1: product['name'] ?? 'Default Name',
                    t_2: product['title'] ?? 'Default Title',
                    t_3: '\$${product['price'] ?? 0}',
                    img: product['Image'] ?? 'images/fl.png',
                    id: product['_id'] ?? '6565e75ae7f7fbdce44d8ec5',
                    userid: widget.id,
                  ),
              ],
            ),
          )


        ],
      ),
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



  Widget _buildCustomBar(String text) {
        return GestureDetector(
          onTap: () {
            setState(() {
              selectedCategory = text;
            });
          },
          child: Container(
            width: 100,
            padding: const EdgeInsets.only(bottom: 5.0),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: selectedCategory == text?  Color(0xFF759D1E) : Colors.transparent,
                  width: 2.0,
                ),
              ),
            ),
            child: Container(
              margin: const EdgeInsets.only(left: 20),
              child: Text(
                text,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color:selectedCategory == text ?  Color(0xFF759D1E) : Colors.grey,
                ),
              ),
            ),
          ),
        );
  }
  }