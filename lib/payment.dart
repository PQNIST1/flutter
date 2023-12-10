import 'package:fianl_project/store.dart';
import 'package:flutter/material.dart';

class PaymentWidget extends StatefulWidget {
  final String id;
  PaymentWidget({required this.id});
  @override
  _PaymentWidgetState createState() => _PaymentWidgetState();
}

class _PaymentWidgetState extends State<PaymentWidget> {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        alignment: Alignment.center,
        color: Color(0xFF81AA66),
        child:ListView(
          children: [
            Container(
              margin: const EdgeInsets.only(left: 155,right: 155,top: 180),
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: Color(0xFFFFFFFF).withOpacity(0.30),
                borderRadius: BorderRadius.circular(50)
              ),
              child: Image.asset('images/check 2.png'),
            ),
            Container(
              alignment: Alignment.center,
              margin: const EdgeInsets.only(top: 40),
              child: Text('Payment sucessful',style: TextStyle(fontSize: 28,fontWeight: FontWeight.w700,color: Colors.white),),
            ),
            Container(
              margin: const EdgeInsets.only(left: 10,right: 10,top: 70),
              child: Text('It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout. The point of using Lorem Ipsum is that it has a more-or-less normal distribution of letters',
                style: TextStyle(fontWeight: FontWeight.w400,fontSize: 18,color: Colors.white,height: 1.5),textAlign: TextAlign.center,
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                  MaterialPageRoute(builder: (context) => StoreWidget(id: widget.id))
                );
              },
               child: Container(
                  margin: const EdgeInsets.only(left: 30,right: 30,top: 70),
                  alignment: Alignment.center,
                  width: 315,
                  height: 50,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(5)
                  ),
                  child: Text('Continue shopping',style: TextStyle(fontSize: 20,fontWeight: FontWeight.w700,color: Color(0xFF81AA66) ),),
                ),

            ),
          ],
        )
        ),
    );
  }
}