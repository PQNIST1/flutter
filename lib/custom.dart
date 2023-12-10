import 'package:fianl_project/bag.dart';
import 'package:fianl_project/fetch1.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'info.dart';
import 'package:provider/provider.dart';

class CustomProductWidget extends StatefulWidget {
  final String t_1;
  final String t_2;
  final String t_3;
  final String img;
  final String id;
  final String userid;

  CustomProductWidget({
    Key? key,
    required this.t_1,
    required this.t_2,
    required this.t_3,
    required this.img,
    required this.id,
    required this.userid,
  }) : super(key: key);

  @override
  _CustomProductWidgetState createState() => _CustomProductWidgetState();
}

class _CustomProductWidgetState extends State<CustomProductWidget> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => LoadBag(),
      child: _BuildBagWidget(id: widget.id,t_1: widget.t_1,t_2: widget.t_2,t_3: widget.t_3,img: widget.img,userid: widget.userid),
    );
  }
}
class _BuildBagWidget extends StatelessWidget {
  final String id;
  final String t_1;
  final String t_2;
  final String t_3;
  final String img;
  final String userid;
  _BuildBagWidget({
    required this.t_1,
    required this.t_2,
    required this.t_3,
    required this.img,
    required this.id,
    required this.userid,
  });
  @override
  Widget build(BuildContext context) {
    LoadBag loadBag = Provider.of<LoadBag>(context);
    YourWidget yourWidget = YourWidget(id: id,userId: userid,loadBag: loadBag,);
    return  GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => InfoWidget(id: id,userid:userid,)),
        );
      },
      child:Container(
        height: 120,
        width: 350,
        margin: const EdgeInsets.only(bottom: 25),
        decoration: BoxDecoration(
            color:  Colors.white
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.only(right: 35,left: 0),
              child: Image.asset(img),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 20),
                  child: Text(t_1,style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                    color: Colors.black,
                  ),),
                ),
                Text(t_2,style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Colors.black
                ),),
                Padding(
                  padding: const EdgeInsets.only(left: 0),
                  child: Text(t_3,style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color:  Color(0xFF759D1E)
                  ),),
                ),
              ],
            ),
            GestureDetector(
              onTap: () {
                  yourWidget.showProductDialog(context);
              },
              child: Padding(
                padding: const EdgeInsets.only(left: 60),
                child: Icon(
                  Icons.add_box,
                  color: const Color(0xFF759D1E),
                  size: 40,
                ),
              ),
            )
          ],
        ),
      )
    );

  }
}
