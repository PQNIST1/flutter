import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/foundation.dart';

class BagManager with ChangeNotifier {
  List<Map<String, dynamic>> productsInBag = [];
  int total = 0;

  Future<void> fetchProductsInBag(String userId) async {
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

        // Kiểm tra xem có thông tin giỏ hàng khôngs
        if (bagInfo.containsKey('bag')) {
          final List<dynamic> productsInBagInfo = bagInfo['bag'];
          // Chuyển đổi danh sách thông tin sản phẩm từ giỏ hàng sang List<Map<String, dynamic>>
          productsInBag = List<Map<String, dynamic>>.from(productsInBagInfo);
          total = 0;
          for (final bag in productsInBag) {
            total += (bag['product']['price'] as int) * (bag['quantity'] as int);
          }
          // Thông báo về sự thay đổi cho người nghe (listener)
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
}
