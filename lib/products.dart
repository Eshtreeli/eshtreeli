import 'dart:ui';

import 'package:eshtreeli_flutter/cart.dart';
import 'package:eshtreeli_flutter/loadingPro.dart';
import 'package:eshtreeli_flutter/provider.dart';

import 'package:eshtreeli_flutter/subProducts.dart';
import 'package:eshtreeli_flutter/welcome.dart';

import 'package:flutter/material.dart';

import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:localstorage/localstorage.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class products extends StatefulWidget {
  final id;
  final subcatname;
  final clockoff;
  final subcatprice;
  final clockon;
  final share;
  final subimage;
  final backimage;
  final timedelevery;
  final dis;
  final lat;
  final long;
  final catcolor;
  final sub_rating;
  final count_rating;
  const products({
    required this.subcatname,
    required this.sub_rating,
    required this.count_rating,
    required this.clockoff,
    required this.subcatprice,
    required this.clockon,
    required this.share,
    required this.subimage,
    required this.backimage,
    required this.long,
    required this.lat,
    required this.dis,
    required this.id,
    required this.timedelevery,
    required this.catcolor,
  });

  @override
  State<products> createState() => _productsState();
}

class _productsState extends State<products> {
  var delivery_price;
  var delivery_price_withdis;
  var delivery_time;
  bool isloading = true;
  final List list = [];
  Future<void> openLink() async {
    if (!await launchUrl(Uri.parse(
        ("https://www.google.com/maps/dir/${widget.long},${widget.lat}")))) {
      throw Exception('Could not launch');
    }
  }

  void openModal() {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (ctx) => Directionality(
              textDirection: TextDirection.rtl,
              child: Container(
                height: MediaQuery.of(context).size.height - 100,
                width: double.infinity,
                child: Column(children: [
                  Container(
                    margin: EdgeInsets.only(top: 20, bottom: 20),
                    child: Text(
                      " معلومات عن " + widget.subcatname,
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width - 20,
                    child: Column(
                      children: [
                        Divider(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Expanded(
                              child: Container(
                                child: Text(
                                  "وصف المتجر",
                                  style: TextStyle(
                                      color: Colors.red,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                margin: EdgeInsets.only(top: 5),
                                child: Text(
                                  widget.dis,
                                  style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Divider(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Expanded(
                              child: Container(
                                child: Text(
                                  "كم سعر التوصيل؟",
                                  style: TextStyle(
                                      color: Colors.red,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                margin: EdgeInsets.only(top: 5),
                                child: Text(
                                  "سعر التوصيل من هذا المتجر لمنطقتك هو " +
                                      delivery_price +
                                      "شيقل",
                                  style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Divider(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Expanded(
                              child: Container(
                                child: Text(
                                  "هل يمكن الشراء مع متاجر اخرى بطلب واحد؟",
                                  style: TextStyle(
                                      color: Colors.red,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                margin: EdgeInsets.only(top: 5),
                                child: Text(
                                  widget.share == 'yes'
                                      ? 'نعم يمكن شراء منتجات هذا المتجر مع منتجات متجر اخر بنفس الطلب'
                                      : 'لا يمكن شراء منتجات هذا المتجر مع منتجات متجر اخر بنفس الطلب',
                                  style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Divider(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Expanded(
                              child: Container(
                                child: Text(
                                  "كم زمن التوصيل المتوقع لمنطقتي ؟",
                                  style: TextStyle(
                                      color: Colors.red,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                alignment: Alignment.center,
                                margin: EdgeInsets.only(top: 5),
                                child: Text(
                                  delivery_time,
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Divider(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Expanded(
                              child: Container(
                                child: Text(
                                  "ما اوقات دوام هذا المتجر عادة؟",
                                  style: TextStyle(
                                      color: Colors.red,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                alignment: Alignment.center,
                                margin: EdgeInsets.only(top: 5),
                                child: Text(
                                  widget.clockon +
                                      "ص" +
                                      ' - ' +
                                      widget.clockoff +
                                      "م",
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Divider(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Expanded(
                              child: Container(
                                child: Text(
                                  "موقع المتجر على الخريطة",
                                  style: TextStyle(
                                      color: Colors.red,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            Expanded(
                                child: InkWell(
                              onTap: () {
                                openLink();
                              },
                              child: Container(
                                  alignment: Alignment.center,
                                  margin: EdgeInsets.only(top: 5),
                                  child: Icon(
                                    Icons.location_pin,
                                    size: 30,
                                    color: Colors.green,
                                  )),
                            )),
                          ],
                        ),
                      ],
                    ),
                  )
                ]),
              ),
            ));
  }

  Future<List> getpro() async {
    final response = await http.post(
      Uri.parse('https://e-shtreeli.com/api/single_categories_product'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'id': widget.id,
        'id_user': localStorage.getItem('id'),
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      // print(data);
      setState(() {
        for (var i = 0; i < data['data']['data'].length; i++) {
          final entry = data['data']['data'][i];
          list.add((entry));
        }
      });

      return list;
    } else {
      throw Exception('Failed to load album');
    }
  }

  Future getdelivery() async {
    setState(() {
      isloading = true;
    });
    final response = await http.post(
      Uri.parse('https://e-shtreeli.com/api/pricedevivery'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'cat_id': widget.id,
        'id_user': localStorage.getItem('id'),
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        delivery_price = data['data_price']['delivery_price_final'].toString();
        delivery_time = data['data_price']['deliver_time'].toString();
        if (data['data_price']['delivery_price_final2'] != null) {
          delivery_price_withdis =
              data['data_price']['delivery_price_final2'].toString();
        }
      });
    } else {
      setState(() {
        isloading = false;
      });
      throw Exception('Failed to load album');
    }
  }

  double maxScroll = 1;
  late ScrollController _scrollController;
  double _scrollPosition = 0;
  _scrollListener() {
    setState(() {
      _scrollPosition = _scrollController.position.pixels;
    });
    // print(_scrollPosition);
  }

  @override
  void initState() {
    super.initState();

    _scrollController = ScrollController();
    _scrollController.addListener(
      _scrollListener,
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {});
    getpro();
    getdelivery();
    Future.delayed(Duration(seconds: 2), () {
      setState(() {
        isloading = false;
      });
    });
  }

  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: localStorage.getItem('id') != null &&
              localStorage.getItem('id') != ''
          ? Stack(
              children: [
                Positioned(
                  child: Column(
                    children: [
                      Expanded(
                        child: ListView.builder(
                          controller: _scrollController,
                          itemCount: list.length + 1,
                          itemBuilder: (BuildContext context, int index) {
                            if (index == 0) {
                              // return the header
                              return Opacity(
                                opacity: 1 - _scrollPosition / 95 <= 0
                                    ? 0
                                    : 1 - _scrollPosition / 95,
                                child: Container(
                                  color: Colors.white,
                                  child: Column(
                                    children: [
                                      Stack(
                                        children: [
                                          Positioned(
                                            child: Container(
                                              height: (280 -
                                                          _scrollPosition *
                                                              (2) >=
                                                      0
                                                  ? 280 - _scrollPosition * (2)
                                                  : 0),
                                              margin:
                                                  EdgeInsets.only(bottom: 20),
                                              child: Container(
                                                // للصورة الكبيرة
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                margin: EdgeInsets.symmetric(
                                                    horizontal: 0),

                                                decoration: BoxDecoration(
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Color.fromARGB(255,
                                                              142, 142, 142)
                                                          .withOpacity(0.5),
                                                      spreadRadius: 2,
                                                      blurRadius: 7,
                                                      offset: Offset(0,
                                                          3), // changes position of shadow
                                                    ),
                                                  ],
                                                  borderRadius:
                                                      BorderRadius.only(
                                                          bottomRight:
                                                              Radius.circular(
                                                                  150),
                                                          bottomLeft:
                                                              Radius.circular(
                                                                  20)),
                                                  image: DecorationImage(
                                                    fit: BoxFit.fill,
                                                    image: NetworkImage(
                                                        widget.backimage),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Positioned(
                                            top: 175,
                                            right: 5,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                Hero(
                                                  tag:
                                                      '${widget.subimage}-subimage',
                                                  child: Opacity(
                                                    opacity: ((1 -
                                                                _scrollPosition /
                                                                    50) <=
                                                            0
                                                        ? 0
                                                        : (1 -
                                                            _scrollPosition /
                                                                50)),
                                                    child: Container(
                                                      width: 100,
                                                      margin:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 5),
                                                      height: 100,
                                                      decoration: BoxDecoration(
                                                        boxShadow: [
                                                          BoxShadow(
                                                            color: Color(int.parse(
                                                                        widget
                                                                            .catcolor
                                                                            .substring(1,
                                                                                7),
                                                                        radix:
                                                                            16) +
                                                                    0xFF000000)
                                                                .withOpacity(
                                                                    0.7),
                                                            spreadRadius: 4,
                                                            blurRadius: 7,
                                                            offset: Offset(1,
                                                                3), // changes position of shadow
                                                          ),
                                                        ],
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    50)),
                                                        image: DecorationImage(
                                                          fit: BoxFit.fill,
                                                          image: NetworkImage(
                                                              widget.subimage),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Positioned(
                                            top: 260,
                                            left: 30,
                                            child: InkWell(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              onTap: () {
                                                openModal();
                                              },
                                              child: Container(
                                                  alignment: Alignment.center,
                                                  //margin: EdgeInsets.only(left: 50, top: 220),
                                                  height: 35,
                                                  width: 120,
                                                  decoration: BoxDecoration(
                                                    color: Color.fromARGB(
                                                            255, 254, 254, 254)
                                                        .withOpacity(0.9),
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: Color(int.parse(
                                                                    widget
                                                                        .catcolor
                                                                        .substring(
                                                                            1,
                                                                            7),
                                                                    radix: 16) +
                                                                0xFF000000)
                                                            .withOpacity(0.4),
                                                        spreadRadius: 3,
                                                        blurRadius: 2,
                                                        offset: Offset(1,
                                                            2), // changes position of shadow
                                                      ),
                                                    ],
                                                    borderRadius:
                                                        BorderRadius.only(
                                                      topLeft:
                                                          Radius.circular(15),
                                                      bottomLeft:
                                                          Radius.circular(25),
                                                      topRight:
                                                          Radius.circular(5),
                                                      bottomRight:
                                                          Radius.circular(10),
                                                    ),
                                                  ),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Icon(
                                                        Icons.info_outline,
                                                        color: Color.fromARGB(
                                                            255, 3, 185, 0),
                                                      ),
                                                      SizedBox(
                                                        width: 5,
                                                      ),
                                                      Text('تفاصيل',
                                                          style: TextStyle(
                                                              fontSize: 14,
                                                              color: Color
                                                                  .fromARGB(
                                                                      255,
                                                                      42,
                                                                      42,
                                                                      41),
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold)),
                                                    ],
                                                  )),
                                            ),
                                          ),
                                          Positioned(
                                            top: delivery_price_withdis == null
                                                ? 260
                                                : 230,
                                            left: 147,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Container(
                                                    //height: 40,
                                                    alignment: Alignment.center,
                                                    margin:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 5),
                                                    decoration: BoxDecoration(
                                                      color: Color.fromARGB(255,
                                                              251, 250, 247)
                                                          .withOpacity(0.9),
                                                      boxShadow: [
                                                        BoxShadow(
                                                          color: Color(int.parse(
                                                                      widget
                                                                          .catcolor
                                                                          .substring(
                                                                              1,
                                                                              7),
                                                                      radix:
                                                                          16) +
                                                                  0xFF000000)
                                                              .withOpacity(0.4),

                                                          spreadRadius: 3,
                                                          blurRadius: 2,
                                                          offset: Offset(1,
                                                              2), // changes position of shadow
                                                        ),
                                                      ],
                                                      borderRadius:
                                                          BorderRadius.only(
                                                        topRight:
                                                            Radius.circular(15),
                                                        bottomRight:
                                                            Radius.circular(25),
                                                        topLeft:
                                                            Radius.circular(5),
                                                        bottomLeft:
                                                            Radius.circular(10),
                                                      ),
                                                    ),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Container(
                                                            padding:
                                                                EdgeInsets.all(
                                                                    6),
                                                            child: Icon(
                                                              Icons
                                                                  .delivery_dining,
                                                              color: Color
                                                                  .fromARGB(
                                                                      255,
                                                                      31,
                                                                      31,
                                                                      31),
                                                            )),
                                                        if (delivery_price_withdis ==
                                                            null)
                                                          Container(
                                                            padding:
                                                                EdgeInsets.all(
                                                                    6),
                                                            child: Text(
                                                              delivery_price !=
                                                                      null
                                                                  ? delivery_price +
                                                                      "₪"
                                                                  : '',
                                                              style: TextStyle(
                                                                  fontSize: 15,
                                                                  color: Color
                                                                      .fromARGB(
                                                                          255,
                                                                          41,
                                                                          40,
                                                                          40),
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            ),
                                                          ),
                                                        if (delivery_price_withdis !=
                                                            null)
                                                          Container(
                                                            padding:
                                                                EdgeInsets.all(
                                                                    5),
                                                            child: Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                Text(
                                                                  delivery_price !=
                                                                          null
                                                                      ? delivery_price +
                                                                          "₪"
                                                                      : '',
                                                                  style:
                                                                      TextStyle(
                                                                    decoration:
                                                                        TextDecoration
                                                                            .lineThrough,
                                                                    fontSize:
                                                                        15,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                  ),
                                                                ),
                                                                Text(
                                                                  delivery_price_withdis !=
                                                                          null
                                                                      ? delivery_price_withdis +
                                                                          "₪"
                                                                      : '',
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          16,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      color: Colors
                                                                          .red),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                      ],
                                                    )),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Hero(
                                            tag: widget.subcatname,
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                top: 5.0,
                                                right: 15,
                                                bottom: 5,
                                              ),
                                              child: Container(
                                                child: Text(
                                                  widget.subcatname,
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      color: Color.fromARGB(
                                                          255, 56, 56, 56),
                                                      fontSize: 17,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Directionality(
                                        textDirection: TextDirection.rtl,
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              bottom: 15.0, right: 15),
                                          child: Row(children: [
                                            Text(
                                              "(${widget.count_rating}",
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w800,
                                                  color: Color.fromARGB(
                                                      255, 72, 72, 72)),
                                            ),
                                            Text(
                                              " تقييم)",
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w800,
                                                  color: Color.fromARGB(
                                                      255, 118, 116, 116)),
                                            ),
                                            Text(
                                              widget.sub_rating,
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w800,
                                                  color: Color.fromARGB(
                                                      255, 0, 0, 0)),
                                            ),
                                            Icon(
                                              Icons.star,
                                              size: 20,
                                              color: const Color.fromARGB(
                                                  255, 252, 227, 1),
                                            ),
                                            SizedBox(
                                              height: 2,
                                            ),
                                          ]),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }
                            index -= 1;

                            return isloading
                                ? loadingPro()
                                : Column(
                                    children: [
                                      Directionality(
                                        textDirection: TextDirection.rtl,
                                        child: Container(
                                          margin: EdgeInsets.only(
                                              top: 5, left: 10, right: 10),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            boxShadow: [
                                              BoxShadow(
                                                color: const Color.fromARGB(
                                                        255, 98, 98, 98)
                                                    .withOpacity(0.5),
                                                spreadRadius: 2,
                                                blurRadius: 7,
                                                offset: Offset(0,
                                                    3), // changes position of shadow
                                              ),
                                            ],
                                            borderRadius: BorderRadius.only(
                                                bottomRight:
                                                    Radius.circular(50),
                                                bottomLeft: Radius.circular(20),
                                                topRight: Radius.circular(10),
                                                topLeft: Radius.circular(10)),
                                          ),
                                          // height: 100,

                                          child: ListTile(
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                PageRouteBuilder(
                                                  pageBuilder: (context, animation, secondaryAnimation) => subpro(
                                                      unit_pro: list[index]
                                                          ['unit'],
                                                      adds_pro: list[index]
                                                          ['adel'],
                                                      name_pro: list[index]
                                                          ['exhibition_name'],
                                                      name_img: list[index]
                                                          ['exhibition_image'],
                                                      exhibition_categories_id:
                                                          list[index][
                                                              'exhibition_categories_id'],
                                                      exhibition_sub_categories_id:
                                                          list[index][
                                                              'exhibition_sub_categories_id'],
                                                      exhibition_item_description:
                                                          list[index][
                                                              'exhibition_item_description']),
                                                  transitionsBuilder: (context,
                                                      animation,
                                                      secondaryAnimation,
                                                      child) {
                                                    return FadeTransition(
                                                      opacity: animation,
                                                      child: child,
                                                    );
                                                  },
                                                  transitionDuration: Duration(
                                                      milliseconds:
                                                          700), // Slow down the transition
                                                ),
                                              );
                                            },
                                            enabled: list[index][
                                                        'exhibitions_is_empty'] ==
                                                    'no'
                                                ? false
                                                : true,
                                            visualDensity:
                                                VisualDensity(vertical: 4),
                                            shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(50))),
                                            title: Container(
                                              margin:
                                                  EdgeInsets.only(bottom: 1),
                                              child: Text(
                                                list[index]['exhibition_name'],
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                            subtitle: Container(
                                              padding: const EdgeInsets.only(
                                                  bottom: 8.0),
                                              child: Column(
                                                children: list[index]['unit']
                                                    .map<Widget>((element) {
                                                  return Container(
                                                    margin: EdgeInsets.only(
                                                      top: 5,
                                                    ),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: [
                                                        Container(
                                                          width: 160,
                                                          child: Text(
                                                              element['label'],
                                                              textAlign:
                                                                  TextAlign
                                                                      .start,
                                                              style: TextStyle(
                                                                  fontSize: 10,
                                                                  color: Color
                                                                      .fromARGB(
                                                                          255,
                                                                          102,
                                                                          102,
                                                                          102))),
                                                        ),
                                                        Container(
                                                          width: 40,
                                                          child: Text(
                                                              element['value']
                                                                      .substring(
                                                                          0,
                                                                          element['value'].indexOf(
                                                                              "_"))
                                                                      .trim() +
                                                                  '₪ ',
                                                              textAlign:
                                                                  TextAlign
                                                                      .start,
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize: 11,
                                                                  color: list[index]['exhibitions_is_empty'] == 'yes'
                                                                      ? Color.fromARGB(
                                                                          255,
                                                                          0,
                                                                          224,
                                                                          0)
                                                                      : Color.fromARGB(
                                                                          255,
                                                                          193,
                                                                          193,
                                                                          193))),
                                                        ),
                                                      ],
                                                    ),
                                                  );
                                                }).toList(),
                                              ),
                                            ),
                                            trailing: list[index][
                                                        'exhibitions_is_empty'] ==
                                                    'no'
                                                ? RotatedBox(
                                                    quarterTurns:
                                                        1, // Rotates the text 90 degrees clockwise
                                                    child: Text(
                                                      'غير متاح',
                                                      style: TextStyle(
                                                        fontSize: 12,
                                                        color: Colors.grey,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                  )
                                                : Icon(Icons.arrow_forward_ios,
                                                    color: Colors.grey),
                                            contentPadding: EdgeInsets.only(
                                                right: 0, left: 5),
                                            leading: AspectRatio(
                                              aspectRatio: 1.2,
                                              child: Container(
                                                child: ClipRRect(
                                                  borderRadius:
                                                      const BorderRadius.only(
                                                    bottomRight:
                                                        Radius.circular(35),
                                                    topLeft:
                                                        Radius.circular(10),
                                                    topRight:
                                                        Radius.circular(10),
                                                    bottomLeft:
                                                        Radius.circular(10),
                                                  ),
                                                  child: list[index][
                                                              'exhibitions_is_empty'] ==
                                                          'yes'
                                                      ? Hero(
                                                          tag: list[index][
                                                              'exhibition_image'],
                                                          child: Image.network(
                                                            list[index][
                                                                'exhibition_image'],
                                                            fit: BoxFit.cover,
                                                          ),
                                                        )
                                                      : Hero(
                                                          tag: list[index][
                                                              'exhibition_image'],
                                                          child: Container(
                                                            width:
                                                                MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width,
                                                            height: 70,
                                                            decoration:
                                                                BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10),
                                                              color: Color
                                                                  .fromARGB(
                                                                      255,
                                                                      239,
                                                                      236,
                                                                      236),
                                                              image:
                                                                  DecorationImage(
                                                                opacity: 0.2,
                                                                fit:
                                                                    BoxFit.fill,
                                                                image: NetworkImage(
                                                                    list[index][
                                                                        'exhibition_image']),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                ),
                                              ),
                                            ),
                                            tileColor: Color.fromARGB(
                                                255, 240, 237, 237),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                    ],
                                  );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: 0,
                  left: 0,
                  child: Opacity(
                    opacity: (_scrollPosition >= 110
                        ? 1
                        : _scrollPosition <= 110 && _scrollPosition >= 90
                            ? _scrollPosition / 150
                            : 0),
                    child: Container(
                      alignment: Alignment.center,
                      //margin: EdgeInsets.only(left: 50, top: 220),
                      height: 90,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 0, 0, 0),
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(30),
                          bottomRight: Radius.circular(30),
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  //bottom: 18,
                  top: 35,
                  right: 20,

                  child: Opacity(
                    opacity: (_scrollPosition >= 110
                        ? 1
                        : _scrollPosition <= 110 && _scrollPosition >= 90
                            ? _scrollPosition / 110
                            : 0),
                    child: Container(
                      width: 80,
                      margin: EdgeInsets.symmetric(horizontal: 5),
                      height: 80,
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black,
                            spreadRadius: 3,
                            // blurRadius: 7,
                            // offset: Offset(0, 3), // // changes position of shadow
                          ),
                        ],
                        borderRadius: BorderRadius.all(Radius.circular(50)),
                        image: DecorationImage(
                          fit: BoxFit.fill,
                          image: NetworkImage(widget.subimage),
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 50,
                  left: 10,
                  child: Container(
                    alignment: Alignment.centerRight,
                    child: IconButton(
                      icon: Consumer<HomeProvider>(
                          builder: (context, value, child) {
                        return value.cartValue == 0
                            ? SizedBox()
                            : Stack(
                                children: [
                                  Positioned(
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: Color.fromARGB(255, 0, 0, 0),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(25))),
                                      height: 45,
                                      width: 45,
                                      child: Icon(
                                        Icons.shopping_basket_rounded,
                                        color: Colors.white,
                                        size: 35,
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                      top: 23,
                                      left: 14,
                                      child: Container(
                                        height: 17,
                                        width: 17,
                                        decoration: BoxDecoration(
                                            color: Colors.red,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10))),
                                        child: Text(
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: Colors.white, fontSize: 9),
                                          value.cartValue.toString(),
                                        ),
                                      )),
                                ],
                              );
                      }),
                      onPressed: () => Navigator.push(context,
                          MaterialPageRoute(builder: (context) => cart())),
                    ),
                  ),
                ),
                Positioned(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        alignment: Alignment.center,
                        margin: EdgeInsets.only(left: 10, top: 35),
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 0, 0, 0).withOpacity(0.5),
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(10),
                            topLeft: Radius.circular(10),
                            bottomRight: Radius.circular(10),
                            topRight: Radius.circular(10),
                          ),
                        ),
                        child: InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Container(
                              alignment: Alignment.center,
                              child: Icon(
                                Icons.arrow_back_ios,
                                color: Colors.white,
                              )),
                        ),
                      ),
                      Transform.translate(
                          offset: Offset(
                            _scrollPosition >= 180
                                ? -155
                                : 180 - _scrollPosition * 1.85,
                            3,
                            // -160,
                            // _scrollPosition <= 260 ? 65 - _scrollPosition / 4 : 0,
                          ),
                          //
                          child: Container(
                            margin: EdgeInsets.only(right: 5, top: 15),
                            child: Opacity(
                              opacity: (((_scrollPosition / 150)) >= 1
                                  ? 1
                                  : ((_scrollPosition / 2000))),
                              child: Text(
                                widget.subcatname,
                                style: TextStyle(
                                    color: Color.fromARGB(255, 255, 255, 255),
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          )),
                    ],
                  ),
                ),
              ],
            )
          : Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => wel(),
                        ),
                      );
                    },
                    child: Container(
                        height: 50,
                        width: 250,
                        decoration: BoxDecoration(
                            border: Border.all(
                                width: 1,
                                color: Color.fromARGB(255, 14, 14, 14)),
                            borderRadius: BorderRadius.circular(12)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "انشاء حساب",
                              style: TextStyle(
                                  color: Color.fromARGB(255, 125, 125, 120),
                                  fontSize: 19,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        )),
                  ),
                ],
              )
            ]),
    );
  }
}
