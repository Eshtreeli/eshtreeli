import 'package:eshtreeli_flutter/home.dart';
import 'package:eshtreeli_flutter/orders.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:localstorage/localstorage.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_rating_stars/flutter_rating_stars.dart';

class finishedOrders extends StatefulWidget {
  const finishedOrders({super.key});

  @override
  State<finishedOrders> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<finishedOrders> {
  List data = [];
  List carts = [];
  String sum_first = '0';
  String order_delivery_price = '0';
  String price_service = '0';
  String sum = '0';
  String dept = '0';
  double value = 3.5;
  String note = '';

  var order_name_status;
  var pick_finish;
  String order_id_unique = '0';
  String sum_discount = '0';
  bool isloading = false;
  var order_id;

  late TextEditingController controller;

  Future getFinishedOrders() async {
    setState(() {
      isloading = true;
    });
    final response = await http.post(
      Uri.parse('https://e-shtreeli.com/api/get_order_confirm'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'user_id': localStorage.getItem('id'),
      }),
    );

    if (response.statusCode == 200) {
      setState(() {
        data = jsonDecode(response.body)['data'].reversed.toList();

        isloading = false;
      });
    } else {
      throw Exception('Failed to load cat');
    }
  }

  Future rateOrder() async {
    setState(() {
      isloading = true;
    });

    final response = await http.post(
      Uri.parse('https://e-shtreeli.com/api/rating_order'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'order_rating': value,
        'order_rating_comment': note,
        'order_id_unique': order_id_unique,
      }),
    );

    if (response.statusCode == 200) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => home()));

      isloading = false;
    } else {
      setState(() {
        isloading = false;
      });
      throw Exception('Failed to load cat');
    }
  }

  openAlert() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        actions: [
          Center(
            child: ElevatedButton(
                onPressed: () {
                  setState(() {});
                  rateOrder();
                  Navigator.pop(context);
                },
                child: Text(
                  'ارسال',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.green),
                )),
          ),
        ],
        title: Text('! قيِّم الان',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
        contentPadding: EdgeInsets.all(5),
        content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
          return Container(
            width: MediaQuery.of(context).size.width,
            height: 180,
            child: Column(
              children: [
                RatingStars(
                  value: value,
                  onValueChanged: (v) {
                    //
                    setState(() {
                      value = v;
                    });
                  },
                  starSize: 30,
                  valueLabelColor: const Color(0xff9b9b9b),
                  valueLabelTextStyle: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w400,
                      fontStyle: FontStyle.normal,
                      fontSize: 12.0),
                  valueLabelRadius: 10,
                  maxValue: 5,
                ),
                SizedBox(
                  height: 15,
                ),
                Container(
                  width: 270,
                  child: Directionality(
                    textDirection: TextDirection.rtl,
                    child: TextField(
                      controller: controller,
                      onSubmitted: (String value) {
                        setState(() {
                          note = controller.text.toString();
                        });
                      },
                      onChanged: (String value) {
                        setState(() {
                          note = controller.text.toString();
                        });
                      },
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(vertical: 40.0),
                        fillColor: Colors.white,
                        filled: true,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                                color: Color.fromARGB(255, 214, 211, 211),
                                width: 1)),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide:
                                BorderSide(color: Colors.green, width: 2)),
                        hintText:
                            'نرجوا منك تقييم عملية الشراء بشكل العام، المتجر الكابتن ..',
                        hintStyle: TextStyle(
                            fontSize: 12,
                            color: Color.fromARGB(255, 176, 176, 176)),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }

  @override
  void initState() {
    getFinishedOrders();
    controller = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isloading
          ? Container(
              alignment: Alignment.center,
              child: CircularProgressIndicator(
                color: Colors.green,
              ))
          : data.length > 0
              ? Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                          itemCount: data.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Container(
                              margin: EdgeInsets.only(top: 10),
                              child: Column(
                                children: [
                                  Text('تفاصيل الطلبية',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                          color: const Color.fromARGB(
                                              255, 19, 19, 19))),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        margin: EdgeInsets.only(
                                            left: 20, bottom: 10),
                                        child: Text(data[index]['created_at'],
                                            textAlign: TextAlign.start,
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 12,
                                                color: Colors.red)),
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(
                                            right: 10, bottom: 10),
                                        child: Text(
                                            data[index]['id'].toString(),
                                            textAlign: TextAlign.start,
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 12,
                                                color: const Color.fromARGB(
                                                    255, 101, 101, 101))),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  ...data[index]['order_carts']
                                      .map<Widget>((carts) {
                                    return Directionality(
                                      textDirection: TextDirection.rtl,
                                      child: Column(
                                        children: [
                                          Container(
                                            margin: EdgeInsets.only(
                                                bottom: 10,
                                                right: 10,
                                                left: 10),
                                            child: ListTile(
                                              minLeadingWidth: 10,
                                              contentPadding: EdgeInsets.all(5),
                                              visualDensity:
                                                  VisualDensity(vertical: 1),
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(20))),
                                              tileColor: Color.fromARGB(
                                                  255, 250, 248, 231),
                                              title: Transform.translate(
                                                  offset: Offset(0, 0),
                                                  child: Text(
                                                      carts[
                                                          'cart_name_product'],
                                                      textAlign:
                                                          TextAlign.start,
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 14,
                                                          color: const Color
                                                              .fromARGB(255, 19,
                                                              19, 19)))),
                                              subtitle: Column(
                                                children: [
                                                  SizedBox(
                                                    height: 5,
                                                  ),
                                                  if (carts['cart_mininote'] !=
                                                          ' ' &&
                                                      carts['cart_mininote'] !=
                                                          null)
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: [
                                                        Transform.translate(
                                                            offset:
                                                                Offset(0, 0),
                                                            child: Text(
                                                                carts[
                                                                    'cart_mininote'],
                                                                textAlign:
                                                                    TextAlign
                                                                        .start,
                                                                style: TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontSize:
                                                                        12,
                                                                    color: Color
                                                                        .fromARGB(
                                                                            255,
                                                                            243,
                                                                            7,
                                                                            7)))),
                                                      ],
                                                    ),
                                                  if (carts['cart_adds'] !=
                                                          ' ' &&
                                                      carts['cart_adds'] !=
                                                          null)
                                                    SizedBox(height: 5),
                                                  if (carts['cart_adds'] !=
                                                          ' ' &&
                                                      carts['cart_adds'] !=
                                                          null)
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: [
                                                        Transform.translate(
                                                            offset:
                                                                Offset(0, 0),
                                                            child: Text(
                                                                carts[
                                                                    'cart_adds'],
                                                                textAlign:
                                                                    TextAlign
                                                                        .start,
                                                                style: TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontSize: 9,
                                                                    color: Color
                                                                        .fromARGB(
                                                                            255,
                                                                            48,
                                                                            47,
                                                                            47)))),
                                                        SizedBox(width: 5),
                                                        Transform.translate(
                                                            offset:
                                                                Offset(0, 0),
                                                            child: Text(
                                                                carts['cart_adds_unit'] +
                                                                    '₪' +
                                                                    '+',
                                                                textAlign:
                                                                    TextAlign
                                                                        .start,
                                                                style: TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontSize: 9,
                                                                    color: Color
                                                                        .fromARGB(
                                                                            255,
                                                                            255,
                                                                            9,
                                                                            9)))),
                                                      ],
                                                    ),
                                                  if (carts['cart_adds1'] !=
                                                          ' ' &&
                                                      carts['cart_adds1'] !=
                                                          null)
                                                    SizedBox(height: 5),
                                                  if (carts['cart_adds1'] !=
                                                          ' ' &&
                                                      carts['cart_adds1'] !=
                                                          null)
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: [
                                                        Transform.translate(
                                                            offset:
                                                                Offset(0, 0),
                                                            child: Text(
                                                                carts[
                                                                    'cart_adds1'],
                                                                textAlign:
                                                                    TextAlign
                                                                        .start,
                                                                style: TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontSize: 9,
                                                                    color: Color
                                                                        .fromARGB(
                                                                            255,
                                                                            48,
                                                                            47,
                                                                            47)))),
                                                        SizedBox(width: 5),
                                                        Transform.translate(
                                                            offset:
                                                                Offset(0, 0),
                                                            child: Text(
                                                                carts['cart_adds_unit1'] +
                                                                    '₪' +
                                                                    '+',
                                                                textAlign:
                                                                    TextAlign
                                                                        .start,
                                                                style: TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontSize: 9,
                                                                    color: Color
                                                                        .fromARGB(
                                                                            255,
                                                                            255,
                                                                            9,
                                                                            9)))),
                                                      ],
                                                    ),
                                                  if (carts['cart_adds2'] !=
                                                          ' ' &&
                                                      carts['cart_adds2'] !=
                                                          null)
                                                    SizedBox(height: 5),
                                                  if (carts['cart_adds2'] !=
                                                          ' ' &&
                                                      carts['cart_adds2'] !=
                                                          null)
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: [
                                                        Transform.translate(
                                                            offset:
                                                                Offset(0, 0),
                                                            child: Text(
                                                                carts[
                                                                    'cart_adds2'],
                                                                textAlign:
                                                                    TextAlign
                                                                        .start,
                                                                style: TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontSize: 9,
                                                                    color: Color
                                                                        .fromARGB(
                                                                            255,
                                                                            48,
                                                                            47,
                                                                            47)))),
                                                        SizedBox(width: 5),
                                                        Transform.translate(
                                                            offset:
                                                                Offset(0, 0),
                                                            child: Text(
                                                                carts['cart_adds_unit2'] +
                                                                    '₪' +
                                                                    '+',
                                                                textAlign:
                                                                    TextAlign
                                                                        .start,
                                                                style: TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontSize: 9,
                                                                    color: Color
                                                                        .fromARGB(
                                                                            255,
                                                                            255,
                                                                            9,
                                                                            9)))),
                                                      ],
                                                    ),
                                                  if (carts['cart_adds3'] !=
                                                          ' ' &&
                                                      carts['cart_adds3'] !=
                                                          null)
                                                    SizedBox(height: 5),
                                                  if (carts['cart_adds3'] !=
                                                          ' ' &&
                                                      carts['cart_adds3'] !=
                                                          null)
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: [
                                                        Transform.translate(
                                                            offset:
                                                                Offset(0, 0),
                                                            child: Text(
                                                                carts[
                                                                    'cart_adds3'],
                                                                textAlign:
                                                                    TextAlign
                                                                        .start,
                                                                style: TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontSize: 9,
                                                                    color: Color
                                                                        .fromARGB(
                                                                            255,
                                                                            48,
                                                                            47,
                                                                            47)))),
                                                        SizedBox(width: 5),
                                                        Transform.translate(
                                                            offset:
                                                                Offset(0, 0),
                                                            child: Text(
                                                                carts['cart_adds_unit3'] +
                                                                    '₪' +
                                                                    '+',
                                                                textAlign:
                                                                    TextAlign
                                                                        .start,
                                                                style: TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontSize: 9,
                                                                    color: Color
                                                                        .fromARGB(
                                                                            255,
                                                                            255,
                                                                            9,
                                                                            9)))),
                                                      ],
                                                    ),
                                                  if (carts['cart_adds4'] !=
                                                          ' ' &&
                                                      carts['cart_adds4'] !=
                                                          null)
                                                    SizedBox(height: 5),
                                                  if (carts['cart_adds4'] !=
                                                          ' ' &&
                                                      carts['cart_adds4'] !=
                                                          null)
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: [
                                                        Transform.translate(
                                                            offset:
                                                                Offset(0, 0),
                                                            child: Text(
                                                                carts[
                                                                    'cart_adds4'],
                                                                textAlign:
                                                                    TextAlign
                                                                        .start,
                                                                style: TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontSize: 9,
                                                                    color: Color
                                                                        .fromARGB(
                                                                            255,
                                                                            48,
                                                                            47,
                                                                            47)))),
                                                        SizedBox(width: 5),
                                                        Transform.translate(
                                                            offset:
                                                                Offset(0, 0),
                                                            child: Text(
                                                                data[index][
                                                                        'cart_adds_unit4'] +
                                                                    '₪' +
                                                                    '+',
                                                                textAlign:
                                                                    TextAlign
                                                                        .start,
                                                                style: TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontSize: 9,
                                                                    color: Color
                                                                        .fromARGB(
                                                                            255,
                                                                            255,
                                                                            9,
                                                                            9)))),
                                                      ],
                                                    ),
                                                  SizedBox(height: 5),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        children: [
                                                          if (carts['cart_adds_unit'] != null &&
                                                              carts['cart_adds_unit1'] !=
                                                                  null &&
                                                              carts['cart_adds_unit2'] !=
                                                                  null &&
                                                              carts['cart_adds_unit3'] !=
                                                                  null &&
                                                              carts['cart_adds_unit4'] !=
                                                                  null &&
                                                              double.parse(carts['cart_adds_unit']) + double.parse(carts['cart_adds_unit1']) + double.parse(carts['cart_adds_unit2']) + double.parse(carts['cart_adds_unit3']) + double.parse(carts['cart_adds_unit4']) >=
                                                                  1)
                                                            Transform.translate(
                                                                offset: Offset(
                                                                    0, 1),
                                                                child: Text(((double.parse(carts['cart_adds_unit']) + double.parse(carts['cart_adds_unit1']) + double.parse(carts['cart_adds_unit2']) + double.parse(carts['cart_adds_unit3']) + double.parse(carts['cart_adds_unit4']))).toStringAsFixed(0) + '₪  +',
                                                                    textAlign:
                                                                        TextAlign
                                                                            .start,
                                                                    style: TextStyle(
                                                                        fontWeight: FontWeight
                                                                            .bold,
                                                                        fontSize:
                                                                            10,
                                                                        color: Color.fromARGB(
                                                                            255,
                                                                            0,
                                                                            161,
                                                                            0)))),
                                                          SizedBox(width: 5),
                                                          Transform.translate(
                                                              offset:
                                                                  Offset(0, 0),
                                                              child: Text(
                                                                  carts['cart_name_price'] +
                                                                      '₪',
                                                                  textAlign:
                                                                      TextAlign
                                                                          .start,
                                                                  style: TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      fontSize:
                                                                          12,
                                                                      color: Color.fromARGB(
                                                                          255,
                                                                          11,
                                                                          168,
                                                                          0)))),
                                                        ],
                                                      ),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          SizedBox(
                                                            width: 5,
                                                          ),
                                                          SizedBox(
                                                            child: Row(
                                                              children: [
                                                                Text(
                                                                  "العدد",
                                                                  style: TextStyle(
                                                                      color: Color.fromARGB(
                                                                          255,
                                                                          45,
                                                                          149,
                                                                          1),
                                                                      fontSize:
                                                                          15,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold),
                                                                ),
                                                                SizedBox(
                                                                  width: 5,
                                                                ),
                                                                Text(
                                                                  carts[
                                                                      'cart_name_count_product'],
                                                                  style: TextStyle(
                                                                      color: Color.fromARGB(
                                                                          255,
                                                                          45,
                                                                          149,
                                                                          1),
                                                                      fontSize:
                                                                          15,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    );
                                  }).toList(),
                                  ListTile(
                                    visualDensity:
                                        VisualDensity(vertical: -3), // to

                                    trailing: Text(
                                      'مجموع المشتريات',
                                      style: TextStyle(
                                          color: const Color.fromARGB(
                                              255, 154, 154, 154),
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14),
                                      textAlign: TextAlign.center,
                                    ),
                                    leading: Text(
                                      data[index]['order_sum_first'] + "₪",
                                      style: TextStyle(
                                          color: const Color.fromARGB(
                                              255, 46, 46, 46),
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  ListTile(
                                    visualDensity:
                                        VisualDensity(vertical: -3), // to

                                    trailing: Text(
                                      'رسوم التوصيل',
                                      style: TextStyle(
                                          color: const Color.fromARGB(
                                              255, 154, 154, 154),
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14),
                                      textAlign: TextAlign.center,
                                    ),
                                    leading: Text(
                                      (data[index]['order_delivery_price'] +
                                          "₪"),
                                      style: TextStyle(
                                          color: const Color.fromARGB(
                                              255, 46, 46, 46),
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  ListTile(
                                    visualDensity:
                                        VisualDensity(vertical: -3), // to

                                    trailing: Text(
                                      'رسوم الخدمة',
                                      style: TextStyle(
                                          color: const Color.fromARGB(
                                              255, 154, 154, 154),
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14),
                                      textAlign: TextAlign.center,
                                    ),
                                    leading: Text(
                                      (data[index]['price_service'] + "₪"),
                                      style: TextStyle(
                                          color: const Color.fromARGB(
                                              255, 46, 46, 46),
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  ListTile(
                                    visualDensity:
                                        VisualDensity(vertical: -3), // to

                                    trailing: Text(
                                      'الرصيد',
                                      style: TextStyle(
                                          color: const Color.fromARGB(
                                              255, 154, 154, 154),
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14),
                                      textAlign: TextAlign.center,
                                    ),
                                    leading: Text(
                                      (data[index]['dept'] + "₪"),
                                      style: TextStyle(
                                          color: const Color.fromARGB(
                                              255, 46, 46, 46),
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  ListTile(
                                    visualDensity:
                                        VisualDensity(vertical: -3), // to

                                    trailing: Text(
                                      'مجموع الخصم',
                                      style: TextStyle(
                                          color: const Color.fromARGB(
                                              255, 154, 154, 154),
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14),
                                      textAlign: TextAlign.center,
                                    ),
                                    leading: Text(
                                      data[index]['sum_discount'] + "₪",
                                      style: TextStyle(
                                          color: const Color.fromARGB(
                                              255, 46, 46, 46),
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  ListTile(
                                      visualDensity:
                                          VisualDensity(vertical: -3), // to

                                      trailing: Text(
                                        'المجموع',
                                        style: TextStyle(
                                            color: const Color.fromARGB(
                                                255, 154, 154, 154),
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14),
                                        textAlign: TextAlign.center,
                                      ),
                                      title: int.parse(
                                                  data[index]['sum_discount']) >
                                              0
                                          ? Text(
                                              (int.parse(data[index]['sum']) -
                                                          int.parse(data[index]
                                                              ['sum_discount']))
                                                      .toString() +
                                                  "₪",
                                              style: TextStyle(
                                                  color: Color.fromARGB(
                                                      255, 255, 1, 1),
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 14),
                                              textAlign: TextAlign.start,
                                            )
                                          : null,
                                      leading: Text(
                                        data[index]['order_sum'] + "₪",
                                        style: TextStyle(
                                            decoration:
                                                int.parse(sum_discount) > 0
                                                    ? TextDecoration.lineThrough
                                                    : TextDecoration.none,
                                            color: const Color.fromARGB(
                                                255, 46, 46, 46),
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14),
                                        textAlign: TextAlign.center,
                                      )),
                                  data[index]['order_rating'] == null
                                      ? ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.green,
                                          ),
                                          onPressed: () async {
                                            setState(() {
                                              order_id_unique =
                                                  data[index]['id'].toString();
                                            });
                                            openAlert();
                                          },
                                          child: Text(
                                            "اضغط لتقييم الطلبية",
                                            style: TextStyle(
                                                color: const Color.fromARGB(
                                                    255, 255, 254, 254),
                                                fontWeight: FontWeight.bold,
                                                fontSize: 15),
                                            textAlign: TextAlign.center,
                                          ))
                                      : Column(
                                          children: [
                                            RatingStars(
                                              valueLabelVisibility: false,
                                              starSize: 25,
                                              value: double.parse(data[index]
                                                      ['order_rating']
                                                  .toString()),
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Text(
                                                style: TextStyle(
                                                    color: Colors.green,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 17.0),
                                                data[index]['order_rating_comment'] !=
                                                        null
                                                    ? data[index][
                                                            'order_rating_comment']
                                                        .toString()
                                                    : '')
                                          ],
                                        ),
                                  Divider(
                                    color: Colors.black,
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                ],
                              ),
                            );
                          }),
                    ),
                  ],
                )
              : Column(
                  children: [
                    Center(
                        child: Text(
                      "!لايوجد طلبات قيد التنفيذ",
                      style: TextStyle(
                          color: Color.fromARGB(255, 109, 109, 109),
                          fontWeight: FontWeight.bold,
                          fontSize: 18),
                      textAlign: TextAlign.center,
                    )),
                    SizedBox(
                      height: 400,
                    ),
                  ],
                ),
    );
  }
}
