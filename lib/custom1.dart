import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'fetch.dart';
import 'info.dart';

class Custom1ProductWidget extends StatefulWidget {
  final String t_1;
  final String t_2;
  final String t_3;
  final String img;
  final String id;
  final String userid;
  final int quantity;

  Custom1ProductWidget({
    Key? key,
    required this.t_1,
    required this.t_2,
    required this.t_3,
    required this.img,
    required this.id,
    required this.userid,
    required this.quantity
  }) : super(key: key);

  @override
  _Custom1ProductWidgetState createState() => _Custom1ProductWidgetState();
}

class _Custom1ProductWidgetState extends State<Custom1ProductWidget> {
  @override
  void initState() {
    super.initState();
    _counter = widget.quantity;
  }
  Future<void> removeProductFromBag() async {
    final url = Uri.parse('http://localhost:3000/removeProduct');

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          // Include any additional headers you may need for authentication or other purposes
        },
        body: jsonEncode({
          'userId': widget.userid,
          'productId': widget.id,
        }),
      );

      if (response.statusCode == 200) {
        print('Product removed successfully');
      } else if (response.statusCode == 404) {
        print('Product or user not found');
      } else {
        print('Failed to remove product. Status code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error removing product: $error');
    }
  }
  Future<void> _updateDatabaseQuantity(int newQuantity) async {
    final String apiUrl = 'http://localhost:3000/updateQuantity';

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'userId': widget.userid,
          'productId': widget.id,
          'quantity': newQuantity,
        }),
      );

      if (response.statusCode == 200) {
        print('Quantity updated successfully');
      } else {
        print('Failed to update quantity. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } catch (error) {
      print('Error updating quantity: $error');
    }
  }
  int _counter = 0;
  void _incrementCounter() {
    setState(() {
      _counter++;
      _updateDatabaseQuantity(_counter);
    });
  }

  void _minusCounter() {
    setState(() {
      if (_counter > 0) {
        _counter--;
        _updateDatabaseQuantity(_counter);
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => InfoWidget(id: widget.id,userid: widget.userid,)),
            );
          },
          child: Container(
            height: 120,
            width: 350,
            margin: const EdgeInsets.only(bottom: 25),
            decoration: BoxDecoration(color: Colors.white),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.only(right: 35, left: 10),
                  child: Image.asset(widget.img),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 20),
                      child: Text(
                        widget.t_1,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    Text(
                      widget.t_2,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 85),
                      child: Text(
                        widget.t_3,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: Color(0xFF759D1E),
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(top: 20),
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 20),
                        child: GestureDetector(
                          onTap: () {
                            _incrementCounter();
                          },
                          child: Icon(
                            Icons.add_box,
                            color: Colors.grey,
                            size: 24,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: Text(
                          '$_counter',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 22),
                        child: GestureDetector(
                          onTap: () {
                            _minusCounter();
                          },
                          child: Icon(
                            Icons.indeterminate_check_box,
                            color: Colors.grey,
                            size: 24,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        Positioned(
          top: 45,
          right: 5,
          child: GestureDetector(
            onTap: () {
              removeProductFromBag();
            },
            child: Padding(
              padding: const EdgeInsets.only(left: 5),
              child: Icon(Icons.delete_forever,size: 30,),
            ),
          ),
        )
      ],
    );
  }
}

