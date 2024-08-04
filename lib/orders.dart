import 'package:eshtreeli_flutter/finishedOrders.dart';
import 'package:eshtreeli_flutter/uncomplishedorders.dart';
import 'package:flutter/material.dart';

class orders extends StatefulWidget {
  const orders({super.key});

  @override
  State<orders> createState() => _ordersState();
}

class _ordersState extends State<orders> {
  bool choose = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: Container(
                    margin: EdgeInsets.only(top: 15, bottom: 5),
                    alignment: Alignment.center,
                    width: 120,
                    height: 45,
                    decoration: BoxDecoration(
                        color: choose ? Colors.white : Colors.green,
                        border: Border.all(
                            width: 1,
                            color: choose ? Colors.green : Colors.white),
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            bottomLeft: Radius.circular(10))),
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          choose = false;
                          if (!choose) {
                            setState(() {});
                          }
                        });
                      },
                      child: Text("طلبات منجزة",
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: choose ? Colors.green : Colors.white,
                          )),
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.only(top: 15, bottom: 5),
                  width: 120,
                  height: 45,
                  decoration: BoxDecoration(
                      border: Border.all(
                          width: 1,
                          color: choose ? Colors.white : Colors.green),
                      color: choose ? Colors.green : Colors.white,
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(10),
                          bottomRight: Radius.circular(10))),
                  child: InkWell(
                    onTap: () {
                      if (choose) {
                        setState(() {});
                      }
                      setState(() {
                        choose = true;
                      });
                      //print('توصيل');
                    },
                    child: Text(" قيد الانجاز",
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: choose ? Colors.white : Colors.green,
                        )),
                  ),
                ),
                Divider(
                  color: Colors.green,
                  height: 10,
                )
              ],
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: !choose ? finishedOrders() : uncomplishedorders(),
        ));
  }
}
