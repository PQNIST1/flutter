import 'package:fianl_project/payment.dart';
import 'package:flutter/material.dart';
import 'package:fianl_project/custom1.dart';
import 'package:provider/provider.dart';

import 'fetch.dart';



class BagWidget extends StatefulWidget {
  final String id;
  BagWidget({required this.id});
  @override
  _BagWidgetState createState() => _BagWidgetState();
}

class _BagWidgetState extends State<BagWidget> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => BagManager(),
      child: _BuildBagWidget(id: widget.id),
    );
  }
}
class _BuildBagWidget extends StatelessWidget {
  final String id;
git
  _BuildBagWidget({required this.id});

  @override
  Widget build(BuildContext context) {
    BagManager bagManager = Provider.of<BagManager>(context);
    bagManager.fetchProductsInBag(id);
    return Material(
      child: Container(
        color:  Color(0xFFF9F9F9),
        child: ListView(
          padding: const EdgeInsets.only(top: 0),
          scrollDirection: Axis.vertical,
          children: [
            Container(
              margin: const EdgeInsets.only(top: 80,left: 30,bottom: 50),
              child: Row (
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.pop(context); // Quay trở lại màn hình trước đó
                    },
                    child:  Image.asset('images/back.png'),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left:30),
                    child: Text('Your bag',style: TextStyle(fontSize: 24,fontWeight: FontWeight.w700),),
                  ),
                ],
              ),
            ),
            Column(
              children: [
                for (final bag in bagManager.productsInBag)
                  Custom1ProductWidget(
                    t_1: bag['product']['name'],
                    t_2: bag['product']['name'],
                    t_3: '\$${bag['product']['price']}',
                    img: bag['product']['Image'],
                    id: bag['product']['_id'],
                    userid: id,
                    quantity: bag['quantity'],
                  ),
              ],
            ),

            Padding(
              padding: const EdgeInsets.only(left: 30,bottom: 20),
              child: Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 10,right: 5),
                    child: Text('TOTAL:',style: TextStyle(fontSize: 12,fontWeight: FontWeight.w400),),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 50),
                    child: Text('\$${bagManager.total}',style: TextStyle(fontSize: 26,fontWeight: FontWeight.w700,color: Color(0xFF759D1E) ),),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 15),
              child: SizedBox(
                height: 60,
                width: 315,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    child: Center(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: const Color(0xFF81AA66),
                          minimumSize: Size(315, 60),),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PaymentWidget(id: id),
                            ),
                          );
                        },
                        child: const Text(
                          'Create an payment ',
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
            ),
          ],
        ),
      ),
    );
  }
}

