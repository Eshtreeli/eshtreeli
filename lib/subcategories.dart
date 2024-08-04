import 'package:eshtreeli_flutter/loadingSuball.dart';

import 'package:eshtreeli_flutter/products.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:localstorage/localstorage.dart';

class subcat extends StatefulWidget {
  final catid;
  final categories;
  const subcat({required this.catid, required this.categories});

  @override
  State<subcat> createState() => _subcatState();
}

class Scat {
  final int id;
  final sub_cat_name;
  final sub_cat_des;
  final sub_cat_is_empty;
  final date_time;
  final sub_cat_top;
  final sub_cat_color;
  final sub_cat_image;
  final sub_cat_back_image;
  final sub_cat_price;
  final th_time_off;
  final th_time_on;
  final cat_share_with_other;
  final latitude_mart;
  final longitude_mart;
  final sub_rating;
  final count_rating;
  final time;

  const Scat({
    required this.id,
    required this.sub_cat_name,
    required this.sub_cat_is_empty,
    required this.date_time,
    required this.sub_cat_des,
    required this.sub_cat_top,
    required this.sub_cat_color,
    required this.sub_cat_image,
    required this.sub_cat_back_image,
    required this.sub_cat_price,
    required this.th_time_off,
    required this.th_time_on,
    required this.cat_share_with_other,
    required this.latitude_mart,
    required this.longitude_mart,
    required this.sub_rating,
    required this.count_rating,
    required this.time,
  });

  factory Scat.fromJson(Map<String, dynamic> json) {
    //لفك الجيسون
    return Scat(
      id: json['id'],
      sub_cat_name: json['sub_cat_name'],
      sub_cat_is_empty: json['sub_cat_is_empty'],
      date_time: json['date_time'],
      sub_cat_top: json['sub_cat_top'],
      sub_cat_color: json['sub_cat_color'],
      sub_cat_image: json['sub_cat_image'],
      sub_cat_back_image: json['sub_cat_back_image'],
      sub_cat_des: json['sub_cat_des'],
      sub_cat_price: json['sub_cat_price'],
      th_time_off: json['th_time_off'],
      th_time_on: json['th_time_on'],
      cat_share_with_other: json['cat_share_with_other'],
      latitude_mart: json['latitude_mart'],
      longitude_mart: json['longitude_mart'],
      sub_rating: json['sub_rating'],
      count_rating: json['count_rating'],
      time: json['time'],
    );
  }
}

class _subcatState extends State<subcat> {
  TextEditingController controller = new TextEditingController();
  onSearchTextChanged(String text) async {
    _searchResult.clear();
    if (text.isEmpty) {
      setState(() {});
      return;
    }

    list.forEach((item) {
      if (item.sub_cat_name.contains(text) || item.sub_cat_des.contains(text)) {
        _searchResult.add(item);
      }
    });

    setState(() {});
  }

  filterfun(String cat) async {
    _searchResult.clear();
    if (cat.isEmpty) {
      setState(() {});
      return;
    }

    list.forEach((item) {
      if (item.sub_cat_name.contains(cat) || item.sub_cat_des.contains(cat))
        _searchResult.add(item);
    });

    setState(() {});
  }

  bool isloading = false;
  List filter = [
    {'namechoose': "اظهار الكل", 'pressed': true},
    {'namechoose': "شاورما", 'pressed': false},
    {'namechoose': "برجر", 'pressed': false},
    {'namechoose': "بروست", 'pressed': false},
    {'namechoose': "بيتزا", 'pressed': false},
    {'namechoose': "ساندويش", 'pressed': false},
    {'namechoose': "صحي", 'pressed': false},
    {'namechoose': "حلويات", 'pressed': false},
    {'namechoose': "كريب", 'pressed': false},
    {'namechoose': "طبيخ", 'pressed': false},
    {'namechoose': "عصائر", 'pressed': false},
    {'namechoose': "عالمي", 'pressed': false}
  ];

  List<Scat> _searchResult = [];
  List<Scat> data = [];
  List<Scat> list = [];

  late Future<List<Scat>> scat;
  Future<List<Scat>> getSubCat() async {
    setState(() {
      isloading = true;
    });
    final response = await http.post(
      Uri.parse('https://e-shtreeli.com/api/sub_categories'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'id': widget.catid,
        'id_user': localStorage.getItem('id'),
      }),
    );

    if (response.statusCode == 200) {
      setState(() {
        for (var i = 0; i < jsonDecode(response.body)['data'].length; i++) {
          final entry = jsonDecode(response.body)['data'][i];
          list.add(Scat.fromJson(entry));
        }
      });

      setState(() {
        isloading = false;
      });
      return list;
    } else {
      setState(() {
        isloading = false;
      });
      throw Exception('Failed to load album');
    }
  }

  Future<void> refresh() async {
    await Future.delayed(Duration(milliseconds: 500));
    list = [];
    getSubCat();
  }

  @override
  void initState() {
    super.initState();

    getSubCat();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
            // toolbarHeight: 100,
            title: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  widget.categories,
                  textAlign: TextAlign.end,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                )
              ],
            ),
            SizedBox(
              height: 10,
            ),
          ],
        )),
        body: RefreshIndicator(
            onRefresh: refresh,
            child: isloading
                ? loadingSuball()
                : Column(
                    children: [
                      Container(
                        padding: EdgeInsets.all(12),
                        height: 80,
                        child: Directionality(
                          textDirection: TextDirection.rtl,
                          child: TextField(
                            onChanged: onSearchTextChanged,
                            cursorColor: Colors.grey,
                            decoration: InputDecoration(
                                fillColor: Colors.white,
                                filled: true,
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30),
                                    borderSide: BorderSide(
                                      color: Color.fromARGB(255, 214, 214,
                                          214), // Border color when the TextField is enabled
                                      width: 1.0,
                                    )),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(
                                        color: Color.fromARGB(255, 74, 212, 0),
                                        width: 3)),
                                hintText: 'بحث',
                                hintStyle:
                                    TextStyle(color: Colors.grey, fontSize: 18),
                                prefixIcon: Container(
                                  padding: EdgeInsets.only(bottom: 1),
                                  child: Icon(Icons.search),
                                  width: 18,
                                )),
                          ),
                        ),
                      ),
                      if (widget.catid == 67) //لتظهر الفلترة للمطاعم
                        Container(
                          height: 45,
                          child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: filter.length,
                              reverse: true,
                              itemBuilder: (BuildContext context, int index) {
                                return Container(
                                    padding: EdgeInsets.only(
                                        bottom: 5, left: 5, right: 5),
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: filter[index]
                                                  ['pressed']
                                              ? Colors.orange
                                              : Colors.white,
                                          elevation: 0,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(20),
                                            ),
                                            side: BorderSide(
                                                color: filter[index]['pressed']
                                                    ? Colors.orange
                                                    : Color.fromARGB(
                                                        255, 210, 210, 210)),
                                          )),
                                      onPressed: () {
                                        filterfun(filter[index]['namechoose']);
                                        filter.forEach((element) {
                                          if (element == filter[index]) {
                                            setState(() {
                                              element['pressed'] = true;
                                            });
                                          } else {
                                            setState(() {
                                              element['pressed'] = false;
                                            });
                                          }
                                        });
                                      },
                                      child: Text(
                                        filter[index]['namechoose'],
                                        style: TextStyle(
                                            fontSize: 15,
                                            color: filter[index]['pressed']
                                                ? Colors.white
                                                : const Color.fromARGB(
                                                    255, 139, 139, 139),
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ));
                              }),
                        ),
                      SizedBox(
                        height: 10,
                      ),
                      Expanded(
                          child: _searchResult.length != 0 ||
                                  controller.text.isNotEmpty
                              ? GridView.builder(
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                          childAspectRatio: 2 /
                                              2.7, // Width to height ratio of each item
                                          crossAxisCount: 3,
                                          mainAxisSpacing: 5,
                                          crossAxisSpacing: 5),
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    Scat data = _searchResult[index];

                                    if (data.sub_cat_is_empty == 'close' ||
                                        data.date_time == 'close') {
                                      return Stack(
                                          alignment: Alignment.center,
                                          children: [
                                            Positioned(
                                                child: Column(children: [
                                              Container(
                                                width: 110,
                                                child: Container(
                                                  width: MediaQuery.of(context)
                                                      .size
                                                      .width,
                                                  height: 105,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    color: const Color.fromARGB(
                                                        255, 140, 138, 138),
                                                    image: DecorationImage(
                                                      opacity: 0.5,
                                                      fit: BoxFit.fill,
                                                      image: NetworkImage(
                                                          data.sub_cat_image),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Text(
                                                data.sub_cat_name,
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w800,
                                                  fontSize: 11,
                                                ),
                                                textAlign: TextAlign.center,
                                              )
                                            ])),
                                            Positioned(
                                              child: Container(
                                                margin: EdgeInsets.only(
                                                  bottom: 40,
                                                ),
                                                height: 40,
                                                width: 55,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                  color: Color.fromARGB(
                                                      255, 34, 33, 33),
                                                ),
                                                child: Text(
                                                  'غير متاح حاليا',
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                            )
                                          ]);
                                    } else {
                                      return InkWell(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          onTap: () => {
                                                Navigator.push(
                                                  context,
                                                  PageRouteBuilder(
                                                    pageBuilder: (context,
                                                            animation,
                                                            secondaryAnimation) =>
                                                        products(
                                                      id: data.id,
                                                      catcolor:
                                                          data.sub_cat_color,
                                                      subcatname:
                                                          data.sub_cat_name,
                                                      clockoff:
                                                          data.th_time_off,
                                                      subcatprice:
                                                          data.sub_cat_price,
                                                      clockon: data.th_time_on,
                                                      share: data
                                                          .cat_share_with_other,
                                                      subimage:
                                                          data.sub_cat_image,
                                                      backimage: data
                                                          .sub_cat_back_image,
                                                      timedelevery: data.time,
                                                      dis: data.sub_cat_des,
                                                      lat: data.latitude_mart,
                                                      long: data.longitude_mart,
                                                      sub_rating:
                                                          data.sub_rating,
                                                      count_rating:
                                                          data.count_rating,
                                                    ),
                                                    transitionsBuilder:
                                                        (context,
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
                                                            500), // Slow down the transition
                                                  ),
                                                ),
                                              },
                                          child: Column(children: [
                                            Container(
                                              width: 115,
                                              child: Container(
                                                height: 105,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(15),
                                                  image: DecorationImage(
                                                    fit: BoxFit.fill,
                                                    image: NetworkImage(
                                                        data.sub_cat_image),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Text(
                                              data.sub_cat_name,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w800,
                                                  fontSize: 11),
                                              textAlign: TextAlign.center,
                                            )
                                          ]));
                                    }
                                  },
                                  itemCount: _searchResult.length,
                                )
                              : GridView.builder(
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                          childAspectRatio: 2 /
                                              2.7, // Width to height ratio of each item
                                          crossAxisCount: 3,
                                          mainAxisSpacing: 5,
                                          crossAxisSpacing: 5),
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    Scat data = list[index];

                                    if (data.sub_cat_is_empty == 'close' ||
                                        data.date_time == 'close') {
                                      return InkWell(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              PageRouteBuilder(
                                                pageBuilder: (context,
                                                        animation,
                                                        secondaryAnimation) =>
                                                    products(
                                                  id: data.id,
                                                  catcolor: data.sub_cat_color,
                                                  subcatname: data.sub_cat_name,
                                                  clockoff: data.th_time_off,
                                                  subcatprice:
                                                      data.sub_cat_price,
                                                  clockon: data.th_time_on,
                                                  share:
                                                      data.cat_share_with_other,
                                                  subimage: data.sub_cat_image,
                                                  backimage:
                                                      data.sub_cat_back_image,
                                                  timedelevery: data.time,
                                                  dis: data.sub_cat_des,
                                                  lat: data.latitude_mart,
                                                  long: data.longitude_mart,
                                                  sub_rating: data.sub_rating,
                                                  count_rating:
                                                      data.count_rating,
                                                ),
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
                                                        500), // Slow down the transition
                                              ),
                                            );
                                          },
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          child: Stack(
                                              alignment: Alignment.center,
                                              children: [
                                                Positioned(
                                                    child: Column(children: [
                                                  Container(
                                                    width: 115,
                                                    height: 115,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      color:
                                                          const Color.fromARGB(
                                                              255,
                                                              140,
                                                              138,
                                                              138),
                                                      image: DecorationImage(
                                                        opacity: 0.5,
                                                        fit: BoxFit.fill,
                                                        image: NetworkImage(
                                                            data.sub_cat_image),
                                                      ),
                                                    ),
                                                  ),
                                                  Container(
                                                    width: 120,
                                                    child: Text(
                                                      data.sub_cat_name,
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w800,
                                                        fontSize: 11,
                                                      ),
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                  )
                                                ])),
                                                Positioned(
                                                  child: Container(
                                                    margin: EdgeInsets.only(
                                                      bottom: 60,
                                                    ),
                                                    height: 50,
                                                    width: 65,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8),
                                                      color: Color.fromARGB(
                                                          255, 34, 33, 33),
                                                    ),
                                                    child: Text(
                                                      'غير متاح حاليا',
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                  ),
                                                )
                                              ]));
                                    } else {
                                      return InkWell(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          onTap: () => {
                                                Navigator.push(
                                                  context,
                                                  PageRouteBuilder(
                                                    pageBuilder: (context,
                                                            animation,
                                                            secondaryAnimation) =>
                                                        products(
                                                            id: data.id,
                                                            catcolor: data
                                                                .sub_cat_color,
                                                            subcatname:
                                                                data
                                                                    .sub_cat_name,
                                                            clockoff: data
                                                                .th_time_off,
                                                            subcatprice: data
                                                                .sub_cat_price,
                                                            clockon:
                                                                data.th_time_on,
                                                            share: data
                                                                .cat_share_with_other,
                                                            subimage: data
                                                                .sub_cat_image,
                                                            backimage: data
                                                                .sub_cat_back_image,
                                                            timedelevery:
                                                                data.time,
                                                            dis: data
                                                                .sub_cat_des,
                                                            lat: data
                                                                .latitude_mart,
                                                            long: data
                                                                .longitude_mart,
                                                            count_rating: data
                                                                .count_rating,
                                                            sub_rating: data
                                                                .sub_rating),
                                                    transitionsBuilder:
                                                        (context,
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
                                                            500), // Slow down the transition
                                                  ),
                                                ),
                                              },
                                          child: Container(
                                            child: Stack(
                                              alignment: Alignment.center,
                                              children: [
                                                Positioned(
                                                  child: Column(children: [
                                                    Hero(
                                                      tag:
                                                          '${data.sub_cat_image}-subimage',
                                                      child: Container(
                                                        height: 115,
                                                        width: 115,
                                                        decoration:
                                                            BoxDecoration(
                                                          border: Border.all(
                                                              width: 1.5,
                                                              color: data.sub_cat_top !=
                                                                      null
                                                                  ? Colors
                                                                      .yellow
                                                                  : Color(int.parse(
                                                                          data.sub_cat_color.substring(
                                                                              1,
                                                                              7),
                                                                          radix:
                                                                              16) +
                                                                      0xFF000000)),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(15),
                                                          image:
                                                              DecorationImage(
                                                            fit: BoxFit.fill,
                                                            image: NetworkImage(
                                                                data.sub_cat_image),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    Hero(
                                                      tag: data.sub_cat_name,
                                                      child: Container(
                                                        margin: EdgeInsets.only(
                                                            bottom: 15),
                                                        child: Text(
                                                          data.sub_cat_name,
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w800,
                                                              fontSize: 11),
                                                          textAlign:
                                                              TextAlign.center,
                                                        ),
                                                      ),
                                                    )
                                                  ]),
                                                ),
                                                Positioned(
                                                    child: data.sub_cat_top !=
                                                            null
                                                        ? Container(
                                                            alignment: Alignment
                                                                .center,
                                                            child: Text(
                                                              data.sub_cat_top,
                                                              style: TextStyle(
                                                                  fontSize: 11,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                            ),
                                                            margin:
                                                                EdgeInsets.only(
                                                                    right: 7,
                                                                    left: 35,
                                                                    bottom:
                                                                        140),
                                                            height: 30,
                                                            decoration: BoxDecoration(
                                                                color: Colors
                                                                    .yellow,
                                                                borderRadius: BorderRadius.only(
                                                                    bottomLeft:
                                                                        Radius.circular(
                                                                            20),
                                                                    topRight: Radius
                                                                        .circular(
                                                                            15))),
                                                          )
                                                        : SizedBox()),
                                              ],
                                            ),
                                          ));
                                    }
                                  },
                                  itemCount: list.length,
                                ))
                    ],
                  )));
  }
}
