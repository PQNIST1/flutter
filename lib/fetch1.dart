import 'package:flutter/material.dart'; // Import Material.dart for the Navigator
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/foundation.dart';

import 'bag.dart';

class LoadBag with ChangeNotifier {
  int _counter = 0;

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
          _counter = bagProduct != null ? bagProduct['quantity'] : 0;
          notifyListeners();

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

  Future<void> addToBag(BuildContext context,String userId, String productId, int quantity) async {
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

        // Navigate to BagWidget after adding the product

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BagWidget(id: userId),
          ),
        );
        notifyListeners();
      } else {
        print('Failed to add product to bag. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } catch (error) {
      print('Error adding product to bag: $error');
    }
  }

  int get counter => _counter; // Getter for counter

  void incrementCounter() {
    _counter++;
    notifyListeners();
  }

  void decrementCounter() {
    if (_counter > 0) {
      _counter--;
      notifyListeners();
    }
  }
}
class YourWidget extends StatelessWidget {
  final LoadBag loadBag;
  final String userId;
  final String id;

  YourWidget({
    required this.loadBag,
    required this.userId,
    required this.id,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        showProductDialog(context);
      },
      child: Text('Show Dialog'),
    );
  }

  void showProductDialog(BuildContext context) {
    loadBag.checkProductInBag(userId,id);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Stack(
              children: [
                Positioned(
                  top: 110,
                  left: 120,
                  child: Container(
                    alignment: Alignment.center,
                    color: Colors.white,
                    width: 185,
                    height: 279,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 20, bottom: 25),
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                loadBag.incrementCounter();
                              });
                            },
                            child: Icon(
                              Icons.add_box,
                              color: Colors.grey,
                              size: 40,
                            ),
                          ),
                        ),
                        Text(
                          '${loadBag._counter}',
                          style: TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 25, bottom: 20),
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                loadBag.decrementCounter();
                              });
                            },
                            child: Icon(
                              Icons.indeterminate_check_box,
                              color: Colors.grey,
                              size: 40,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 50,
                          width: 150,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              child: Center(
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      primary: const Color(0xFF81AA66)),
                                  onPressed: () {
                                    loadBag.addToBag(context,userId, id, loadBag._counter);
                                  },
                                  child: const Text(
                                    'Add to bag',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 18,
                                        color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}

