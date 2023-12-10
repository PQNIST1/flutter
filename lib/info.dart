import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'bag.dart';


class InfoWidget extends StatefulWidget {
  final String id;
  final String userid;
  InfoWidget({required this.id,required this.userid});
  @override
  _InfoWidget createState() => _InfoWidget();
}
class _InfoWidget extends State<InfoWidget> {
  late String name = '';
  late String title = '';
  late String detail = '';
  late int price = 0;
  late String image = 'images/fl.png';
  late String thc = '';
  late String cbd = '';
  @override
  void initState() {
    super.initState();
    fetchProductData(widget.id);
    checkProductInBag(widget.userid, widget.id);
    _calculateTotal();
  }
  List<Map<String, dynamic>> productsInBag = [];

  Future<void> checkProductInBag(String userId, String productId) async {
    final String apiUrl = 'http://localhost:3000/user/bag/$userId';

    try {
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> bagInfo = jsonDecode(response.body);

        // Kiểm tra xem có thông tin giỏ hàng không
        if (bagInfo.containsKey('bag')) {
          final List<dynamic> productsInBagInfo = bagInfo['bag'];

          // Tìm sản phẩm trong giỏ hàng dựa trên ID sản phẩm
          var bagProduct = productsInBagInfo.firstWhere(
                (bagItem) => bagItem['product']['_id'] == productId,
            orElse: () => null,
          );

          // Đặt giá trị _counter bằng số lượng nếu tìm thấy sản phẩm, ngược lại đặt _counter = 0
          setState(() {
            productsInBag = List<Map<String, dynamic>>.from(productsInBagInfo);
            _counter = bagProduct != null ? bagProduct['quantity'] : 0;
          });
        } else {
          print('Bag info does not contain "bag" key.');
        }
      } else {
        print('Failed to get bag info. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } catch (error) {
      print('Error getting bag info: $error');
    }
  }
  Future<void> fetchProductData(String productId) async {
    final response = await http.get(Uri.parse('http://localhost:3000/products/$productId'));

    if (response.statusCode == 200) {
      // If the server returns an OK response, parse the JSON
      final productData = json.decode(response.body);

      // Check if the required fields are not null before updating the state
      if (productData['name'] != null &&
          productData['title'] != null &&
          productData['detail'] != null &&
          productData['price'] != null &&
          productData['Image'] != null &&
          productData['thc'] != null &&
          productData['cbd'] != null) {
        setState(() {
          name = productData['name'];
          title = productData['title'];
          detail = productData['detail'];
          price = productData['price'];
          image = productData['Image'];
          thc = productData['thc'];
          cbd = productData['cbd'];
        });
      }
    } else {
      // If the server did not return a 200 OK response,
      // throw an exception.
      throw Exception('Failed to load product data');
    }
  }
  Future<void> addToBag(String userId, String productId, int quantity) async {
    final String apiUrl = 'http://localhost:3000/user/$userId/bag';

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'productId': productId,
          'quantity': quantity,
        }),
      );

      if (response.statusCode == 200) {
        print('Product added to bag successfully');
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => BagWidget(id: widget.userid,))
        );
      } else {
        print('Failed to add product to bag. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } catch (error) {
      print('Error adding product to bag: $error');
    }
  }

  int _counter = 0;
  @ override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        color: Colors.white,
        child: ListView(
          padding: const EdgeInsets.only(top: 0),
          scrollDirection: Axis.vertical,
          children: [
            Container(
              margin: const EdgeInsets.only(top: 80,left: 30),
              child: Row (
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.pop(context); // Quay trở lại màn hình trước đó
                    },
                    child:  Image.asset('images/back.png'),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => BagWidget(id: widget.userid,)),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(left:260,right: 28),
                      child: Image.asset('images/heart.png'),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 28),
                    child: Image.asset('images/share.png'),
                  ),
                ],
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              height: 325,
              child: SingleChildScrollView(
                physics: PageScrollPhysics(),
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width,
                      child: Image.asset(
                        image
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      child: Image.asset(
                        image,
                      ),
                    ), Container(
                      width: MediaQuery.of(context).size.width,
                      child: Image.asset(
                        image,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              color:  Color(0xFFF9F9F9),
              height: 450,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 30,left: 30),
                    child: Text(name,style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w400
                    ),),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 10,left: 30),
                    child: Text(title,style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF759D1E)
                    ),),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 10,left: 30),
                    child: Row(
                      children: [
                        Row(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(right: 8),
                              child: Text('THC',style: TextStyle(fontSize: 14,fontWeight: FontWeight.w700),),
                            ),
                            Text(thc,style: TextStyle(fontSize: 14,fontWeight: FontWeight.w400),)
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 25),
                          child: Row(
                            children: [
                              Padding(
                                padding: EdgeInsets.only(right: 8),
                                child: Text('CBD',style: TextStyle(fontSize: 14,fontWeight: FontWeight.w700),),
                              ),
                              Text(cbd,style: TextStyle(fontSize: 14,fontWeight: FontWeight.w400),)
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 10,left: 30,right:30),
                    child: Text(detail,style: TextStyle(fontWeight: FontWeight.w400,fontSize: 16,color: Colors.grey,height: 1.5),),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 30,top: 20),
                    child: Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(right: 22),
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                _incrementCounter();
                                _calculateTotal();
                              });
                            },
                            child: Icon(
                              Icons.add_box,
                              color: Colors.grey,
                              size: 24,
                            ),
                          ),
                        ),
                        Text(
                          '$_counter',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 22),
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                _minusCounter();
                                _calculateTotal();
                              });
                            },
                            child: Icon(
                              Icons.indeterminate_check_box,
                              color: Colors.grey,
                              size: 24,
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 160),
                          child: Row(
                            children: [
                              Text('\$$price',style: TextStyle(fontSize: 26,fontWeight: FontWeight.w700,color: Color(0xFF759D1E) ),),
                              Padding(
                                padding: EdgeInsets.only(top: 10,left: 5),
                                child: Text('/GRAM',style: TextStyle(fontSize: 12,fontWeight: FontWeight.w400),),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 30,top:80),
                    child: Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: 10,right: 5),
                          child: Text('TOTAL:',style: TextStyle(fontSize: 12,fontWeight: FontWeight.w400),),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 50),
                          child: Text('\$${_calculateTotal()}',style: TextStyle(fontSize: 26,fontWeight: FontWeight.w700,color: Color(0xFF759D1E) ),),
                        ),
                        SizedBox(
                          height: 50,
                          width: 200,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              child: Center(
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      primary: const Color(0xFF81AA66),
                                    minimumSize: Size(200, 50),),
                                  onPressed: () {
                                    addToBag(widget.userid, widget.id, _counter);
                                  },
                                  child: const Text(
                                    'Add to bag ',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 18,
                                        color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),


                ],
              ),
            )
          ],
        ),
      ),
    );
  }
  int _calculateTotal() {
    int total = 0;
    setState(() {
      total = _counter * price;
    });
    return total;
  }
  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }
  void _minusCounter() {
    setState(() {
      if (_counter > 0) {
        _counter--;
      }
    });
  }

}