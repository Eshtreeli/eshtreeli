import 'package:eshtreeli_flutter/finishedOrders.dart';
import 'package:eshtreeli_flutter/home.dart';
import 'package:flutter/material.dart';

import 'package:localstorage/localstorage.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class uncomplishedorders extends StatefulWidget {
  const uncomplishedorders({
    super.key,
  });

  @override
  State<uncomplishedorders> createState() => _uncomplishedordersState();
}

class _uncomplishedordersState extends State<uncomplishedorders>
    with TickerProviderStateMixin {
  late AnimationController myAnimation;
  late Animation<double> _animation;

  List data = [];
  String sum_first = '0';
  String order_delivery_price = '0';
  String price_service = '0';
  String sum = '0';
  String dept = '0';
  var order_name_status;
  var pick_finish;
  String order_id_unique = '0';
  String sum_discount = '0';
  bool isloading = false;
  var order_id;

  Future getUnderReview() async {
    setState(() {
      isloading = true;
    });
    final response = await http.post(
      Uri.parse('https://e-shtreeli.com/api/get_order_under_review'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'user_id': localStorage.getItem('id'),
      }),
    );

    if (response.statusCode == 200) {
      setState(() {
        isloading = false;
      });
      if (jsonDecode(response.body)['data'] != [] &&
          jsonDecode(response.body)['data'] != null) {
        setState(() {
          data = jsonDecode(response.body)['data']['order_carts'];
          sum = jsonDecode(response.body)['sum'];
          sum_discount = jsonDecode(response.body)['data']['sum_discount'];
          sum_first = jsonDecode(response.body)['data']['order_sum_first'];
          dept = jsonDecode(response.body)['data']['dept'];
          price_service = jsonDecode(response.body)['data']['price_service'];
          order_delivery_price =
              jsonDecode(response.body)['data']['order_delivery_price'];
          order_id_unique =
              jsonDecode(response.body)['data']['order_id_unique'];
        });
      }
    } else {
      throw Exception('Failed to load cat');
    }
  }

  Future getApproved() async {
    setState(() {
      isloading = true;
    });
    final response = await http.post(
      Uri.parse('https://e-shtreeli.com/api/get_order_approved'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'user_id': localStorage.getItem('id'),
      }),
    );

    if (response.statusCode == 200) {
      setState(() {
        isloading = false;
      });
      if (jsonDecode(response.body)['data'] != [] &&
          jsonDecode(response.body)['data'] != null) {
        setState(() {
          order_name_status =
              jsonDecode(response.body)['data']['order_name_status'];
          pick_finish = jsonDecode(response.body)['data']['pick_finish'];
          data = jsonDecode(response.body)['data']['order_carts'];
          sum = jsonDecode(response.body)['sum'];
          sum_discount = jsonDecode(response.body)['data']['sum_discount'];
          sum_first = jsonDecode(response.body)['data']['order_sum_first'];
          dept = jsonDecode(response.body)['data']['dept'];
          price_service = jsonDecode(response.body)['data']['price_service'];
          order_delivery_price =
              jsonDecode(response.body)['data']['order_delivery_price'];
          order_id_unique =
              jsonDecode(response.body)['data']['order_id_unique'];
          order_id = jsonDecode(response.body)['data']['id'];
        });
      }
    } else {
      throw Exception('Failed to load cat');
    }
  }

  Future deleteOrder() async {
    setState(() {
      isloading = true;
    });
    final response = await http.post(
      Uri.parse('https://e-shtreeli.com/api/delete_order'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'order_name_customer': localStorage.getItem('id'),
        'order_id_unique': order_id_unique,
      }),
    );

    if (response.statusCode == 200) {
      setState(() {
        isloading = false;
      });
      Navigator.push(context, MaterialPageRoute(builder: (context) => home()));
    } else {
      throw Exception('Failed to load cat');
    }
  }

  openAlert() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 10,
              ),
              ElevatedButton(
                  onPressed: () {
                    setState(() {});

                    Navigator.pop(context);
                  },
                  child: Text(
                    'تمام',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.black),
                  )),
            ],
          ),
        ],
        title: Text("!تنبيه",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
        contentPadding: EdgeInsets.all(5),
        content: Text('! انت لم تستلم طلبك بعد',
            textAlign: TextAlign.center, style: TextStyle()),
      ),
    );
  }

  Future confirmApproved() async {
    setState(() {
      isloading = true;
    });
    final response = await http.post(
      Uri.parse('https://e-shtreeli.com/api/confirm_order_approved'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'user_id': localStorage.getItem('id'),
        'id_order': order_id,
      }),
    );

    if (response.statusCode == 200) {
      if (jsonDecode(response.body)['success'] == 'false_time') {
        setState(() {
          isloading = false;
        });
        openAlert();
      } else {
        setState(() {
          isloading = false;
        });

        Navigator.push(
            context, MaterialPageRoute(builder: (context) => finishedOrders()));
      }
    } else {
      throw Exception('Failed to load cat');
    }
  }

  @override
  void initState() {
    getUnderReview();
    getApproved();
    myAnimation = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1500),
    );

    _animation = Tween(
      begin: 0.0,
      end: 1.0,
    ).animate(myAnimation);
    super.initState();
  }

  @override
  void dispose() {
    myAnimation.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    myAnimation.repeat();
    return Scaffold(
      body: isloading
          ? Container(
              alignment: Alignment.center,
              child: CircularProgressIndicator(
                color: Colors.orange,
              ),
            )
          : Container(
              margin: EdgeInsets.only(top: 10),
              child: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                        itemCount: data.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Directionality(
                            textDirection: TextDirection.rtl,
                            child: Column(
                              children: [
                                Container(
                                  margin: EdgeInsets.only(
                                      bottom: 10, right: 10, left: 10),
                                  child: ListTile(
                                    minLeadingWidth: 10,
                                    contentPadding: EdgeInsets.all(5),
                                    visualDensity: VisualDensity(vertical: 1),
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20))),
                                    tileColor:
                                        Color.fromARGB(255, 250, 248, 231),
                                    title: Transform.translate(
                                        offset: Offset(0, 0),
                                        child: Text(
                                            data[index]['cart_name_product'],
                                            textAlign: TextAlign.start,
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 12,
                                                color: const Color.fromARGB(
                                                    255, 19, 19, 19)))),
                                    subtitle: Column(
                                      children: [
                                        SizedBox(
                                          height: 5,
                                        ),
                                        if (data[index]['cart_mininote'] != ' ')
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Transform.translate(
                                                  offset: Offset(0, 0),
                                                  child: Text(
                                                      data[index]
                                                          ['cart_mininote'],
                                                      textAlign:
                                                          TextAlign.start,
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 12,
                                                          color: Color.fromARGB(
                                                              255,
                                                              243,
                                                              7,
                                                              7)))),
                                            ],
                                          ),
                                        if (data[index]['cart_adds'] != ' ')
                                          SizedBox(height: 5),
                                        if (data[index]['cart_adds'] != ' ')
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Transform.translate(
                                                  offset: Offset(0, 0),
                                                  child: Text(
                                                      data[index]['cart_adds'],
                                                      textAlign:
                                                          TextAlign.start,
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 9,
                                                          color: Color.fromARGB(
                                                              255,
                                                              48,
                                                              47,
                                                              47)))),
                                              SizedBox(width: 5),
                                              Transform.translate(
                                                  offset: Offset(0, 0),
                                                  child: Text(
                                                      data[index][
                                                              'cart_adds_unit'] +
                                                          '₪' +
                                                          '+',
                                                      textAlign:
                                                          TextAlign.start,
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 9,
                                                          color: Color.fromARGB(
                                                              255,
                                                              255,
                                                              9,
                                                              9)))),
                                            ],
                                          ),
                                        if (data[index]['cart_adds1'] != ' ')
                                          SizedBox(height: 5),
                                        if (data[index]['cart_adds1'] != ' ')
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Transform.translate(
                                                  offset: Offset(0, 0),
                                                  child: Text(
                                                      data[index]['cart_adds1'],
                                                      textAlign:
                                                          TextAlign.start,
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 9,
                                                          color: Color.fromARGB(
                                                              255,
                                                              48,
                                                              47,
                                                              47)))),
                                              SizedBox(width: 5),
                                              Transform.translate(
                                                  offset: Offset(0, 0),
                                                  child: Text(
                                                      data[index][
                                                              'cart_adds_unit1'] +
                                                          '₪' +
                                                          '+',
                                                      textAlign:
                                                          TextAlign.start,
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 9,
                                                          color: Color.fromARGB(
                                                              255,
                                                              255,
                                                              9,
                                                              9)))),
                                            ],
                                          ),
                                        if (data[index]['cart_adds2'] != ' ')
                                          SizedBox(height: 5),
                                        if (data[index]['cart_adds2'] != ' ')
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Transform.translate(
                                                  offset: Offset(0, 0),
                                                  child: Text(
                                                      data[index]['cart_adds2'],
                                                      textAlign:
                                                          TextAlign.start,
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 9,
                                                          color: Color.fromARGB(
                                                              255,
                                                              48,
                                                              47,
                                                              47)))),
                                              SizedBox(width: 5),
                                              Transform.translate(
                                                  offset: Offset(0, 0),
                                                  child: Text(
                                                      data[index][
                                                              'cart_adds_unit2'] +
                                                          '₪' +
                                                          '+',
                                                      textAlign:
                                                          TextAlign.start,
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 9,
                                                          color: Color.fromARGB(
                                                              255,
                                                              255,
                                                              9,
                                                              9)))),
                                            ],
                                          ),
                                        if (data[index]['cart_adds3'] != ' ')
                                          SizedBox(height: 5),
                                        if (data[index]['cart_adds3'] != ' ')
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Transform.translate(
                                                  offset: Offset(0, 0),
                                                  child: Text(
                                                      data[index]['cart_adds3'],
                                                      textAlign:
                                                          TextAlign.start,
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 9,
                                                          color: Color.fromARGB(
                                                              255,
                                                              48,
                                                              47,
                                                              47)))),
                                              SizedBox(width: 5),
                                              Transform.translate(
                                                  offset: Offset(0, 0),
                                                  child: Text(
                                                      data[index][
                                                              'cart_adds_unit3'] +
                                                          '₪' +
                                                          '+',
                                                      textAlign:
                                                          TextAlign.start,
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 9,
                                                          color: Color.fromARGB(
                                                              255,
                                                              255,
                                                              9,
                                                              9)))),
                                            ],
                                          ),
                                        if (data[index]['cart_adds4'] != ' ')
                                          SizedBox(height: 5),
                                        if (data[index]['cart_adds4'] != ' ')
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Transform.translate(
                                                  offset: Offset(0, 0),
                                                  child: Text(
                                                      data[index]['cart_adds4'],
                                                      textAlign:
                                                          TextAlign.start,
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 9,
                                                          color: Color.fromARGB(
                                                              255,
                                                              48,
                                                              47,
                                                              47)))),
                                              SizedBox(width: 5),
                                              Transform.translate(
                                                  offset: Offset(0, 0),
                                                  child: Text(
                                                      data[index][
                                                              'cart_adds_unit4'] +
                                                          '₪' +
                                                          '+',
                                                      textAlign:
                                                          TextAlign.start,
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 9,
                                                          color: Color.fromARGB(
                                                              255,
                                                              255,
                                                              9,
                                                              9)))),
                                            ],
                                          ),
                                        SizedBox(height: 5),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                if (double.parse(data[index]['cart_adds_unit']) + double.parse(data[index]['cart_adds_unit1']) + double.parse(data[index]['cart_adds_unit2']) + double.parse(data[index]['cart_adds_unit3']) + double.parse(data[index]['cart_adds_unit4']) >=
                                                    1)
                                                  Transform.translate(
                                                      offset: Offset(0, 1),
                                                      child: Text(
                                                          ((double.parse(data[index]['cart_adds_unit']) + double.parse(data[index]['cart_adds_unit1']) + double.parse(data[index]['cart_adds_unit2']) + double.parse(data[index]['cart_adds_unit3']) + double.parse(data[index]['cart_adds_unit4'])))
                                                                  .toStringAsFixed(
                                                                      0) +
                                                              '₪  +',
                                                          textAlign:
                                                              TextAlign.start,
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 10,
                                                              color: Color
                                                                  .fromARGB(
                                                                      255,
                                                                      0,
                                                                      161,
                                                                      0)))),
                                                SizedBox(width: 5),
                                                Transform.translate(
                                                    offset: Offset(0, 0),
                                                    child: Text(
                                                        data[index]
                                                                [
                                                                'cart_name_price'] +
                                                            '₪',
                                                        textAlign: TextAlign
                                                            .start,
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 12,
                                                            color:
                                                                Color.fromARGB(
                                                                    255,
                                                                    11,
                                                                    168,
                                                                    0)))),
                                              ],
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
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
                                                            color:
                                                                Color.fromARGB(
                                                                    255,
                                                                    45,
                                                                    149,
                                                                    1),
                                                            fontSize: 15,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      SizedBox(
                                                        width: 5,
                                                      ),
                                                      Text(
                                                        data[index][
                                                            'cart_name_count_product'],
                                                        style: TextStyle(
                                                            color:
                                                                Color.fromARGB(
                                                                    255,
                                                                    45,
                                                                    149,
                                                                    1),
                                                            fontSize: 15,
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
                        }),
                  ),
                  if (data.length > 0)
                    Column(
                      children: [
                        Divider(),
                        ListTile(
                          visualDensity: VisualDensity(vertical: -3), // to

                          trailing: Text(
                            'مجموع المشتريات',
                            style: TextStyle(
                                color: const Color.fromARGB(255, 154, 154, 154),
                                fontWeight: FontWeight.bold,
                                fontSize: 14),
                            textAlign: TextAlign.center,
                          ),
                          leading: Text(
                            sum_first + "₪",
                            style: TextStyle(
                                color: const Color.fromARGB(255, 46, 46, 46),
                                fontWeight: FontWeight.bold,
                                fontSize: 14),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        ListTile(
                          visualDensity: VisualDensity(vertical: -3), // to

                          trailing: Text(
                            'رسوم التوصيل',
                            style: TextStyle(
                                color: const Color.fromARGB(255, 154, 154, 154),
                                fontWeight: FontWeight.bold,
                                fontSize: 14),
                            textAlign: TextAlign.center,
                          ),
                          leading: Text(
                            (order_delivery_price + "₪"),
                            style: TextStyle(
                                color: const Color.fromARGB(255, 46, 46, 46),
                                fontWeight: FontWeight.bold,
                                fontSize: 14),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        ListTile(
                          visualDensity: VisualDensity(vertical: -3), // to

                          trailing: Text(
                            'رسوم الخدمة',
                            style: TextStyle(
                                color: const Color.fromARGB(255, 154, 154, 154),
                                fontWeight: FontWeight.bold,
                                fontSize: 14),
                            textAlign: TextAlign.center,
                          ),
                          leading: Text(
                            (price_service + "₪"),
                            style: TextStyle(
                                color: const Color.fromARGB(255, 46, 46, 46),
                                fontWeight: FontWeight.bold,
                                fontSize: 14),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        ListTile(
                          visualDensity: VisualDensity(vertical: -3), // to

                          trailing: Text(
                            'الرصيد',
                            style: TextStyle(
                                color: const Color.fromARGB(255, 154, 154, 154),
                                fontWeight: FontWeight.bold,
                                fontSize: 14),
                            textAlign: TextAlign.center,
                          ),
                          leading: Text(
                            (dept + "₪"),
                            style: TextStyle(
                                color: const Color.fromARGB(255, 46, 46, 46),
                                fontWeight: FontWeight.bold,
                                fontSize: 14),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        ListTile(
                          visualDensity: VisualDensity(vertical: -3), // to

                          trailing: Text(
                            'مجموع الخصم',
                            style: TextStyle(
                                color: const Color.fromARGB(255, 154, 154, 154),
                                fontWeight: FontWeight.bold,
                                fontSize: 14),
                            textAlign: TextAlign.center,
                          ),
                          leading: Text(
                            sum_discount + "₪",
                            style: TextStyle(
                                color: const Color.fromARGB(255, 46, 46, 46),
                                fontWeight: FontWeight.bold,
                                fontSize: 14),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        ListTile(
                            visualDensity: VisualDensity(vertical: -3), // to

                            trailing: Text(
                              'المجموع',
                              style: TextStyle(
                                  color:
                                      const Color.fromARGB(255, 154, 154, 154),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14),
                              textAlign: TextAlign.center,
                            ),
                            title: int.parse(sum_discount) > 0
                                ? Text(
                                    (int.parse(sum) - int.parse(sum_discount))
                                            .toString() +
                                        "₪",
                                    style: TextStyle(
                                        color: Color.fromARGB(255, 255, 1, 1),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14),
                                    textAlign: TextAlign.start,
                                  )
                                : null,
                            leading: Text(
                              sum + "₪",
                              style: TextStyle(
                                  decoration: int.parse(sum_discount) > 0
                                      ? TextDecoration.lineThrough
                                      : TextDecoration.none,
                                  color: const Color.fromARGB(255, 46, 46, 46),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14),
                              textAlign: TextAlign.center,
                            )),
                        SizedBox(
                          height: 10,
                        ),
                        if (order_name_status == null)
                          FadeTransition(
                              opacity: _animation,
                              child: Text(
                                "الرجاء الانتظار لحين الموافقة على طلبك",
                                style: TextStyle(
                                    color: Color.fromARGB(255, 255, 0, 0),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15),
                                textAlign: TextAlign.center,
                              )),
                        if (order_name_status == 1 && pick_finish == 0)
                          Text(
                            " ✔️ تمت الموافقة على طلبك",
                            style: TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.bold,
                                fontSize: 15),
                            textAlign: TextAlign.center,
                          ),
                        if (pick_finish == 2)
                          FadeTransition(
                              opacity: _animation,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.timer_outlined,
                                    color: Color.fromARGB(255, 0, 119, 255),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    "طلبك قيد التجهيز",
                                    style: TextStyle(
                                        color: Color.fromARGB(255, 0, 119, 255),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              )),
                        if (pick_finish == 3)
                          FadeTransition(
                              opacity: _animation,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.delivery_dining,
                                    color: Color.fromARGB(255, 20, 194, 8),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    "طلبك قيد التوصيل",
                                    style: TextStyle(
                                        color: Color.fromARGB(255, 0, 208, 21),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              )),
                        if (pick_finish == 4)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                  width: 250,
                                  child: Text(
                                    "  تم الانتهاء من طلبك ، يرجى تقييم عملية الشراء",
                                    style: TextStyle(
                                        color: Colors.orange,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15),
                                    textAlign: TextAlign.center,
                                  )),
                            ],
                          ),
                        SizedBox(
                          height: 10,
                        ),
                        if (order_name_status == null)
                          ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    const Color.fromARGB(255, 255, 0, 0),
                              ),
                              onPressed: () async {
                                deleteOrder();
                              },
                              child: Text(
                                "الغاء الطلب",
                                style: TextStyle(
                                    color: const Color.fromARGB(
                                        255, 255, 254, 254),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15),
                                textAlign: TextAlign.center,
                              )),
                        if (pick_finish == 4)
                          ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                              ),
                              onPressed: () async {
                                confirmApproved();
                              },
                              child: Text(
                                "اضغط للتأكيد انك استلمت طلبك ",
                                style: TextStyle(
                                    color: const Color.fromARGB(
                                        255, 255, 254, 254),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15),
                                textAlign: TextAlign.center,
                              )),
                        SizedBox(
                          height: 50,
                        ),
                      ],
                    )
                  else
                    Column(
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
                ],
              ),
            ),
    );
  }
}
