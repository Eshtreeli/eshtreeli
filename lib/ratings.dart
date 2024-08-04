import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_stars/flutter_rating_stars.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class allratings extends StatefulWidget {
  const allratings({super.key});

  @override
  State<allratings> createState() => _allratingsState();
}

bool isloading = false;
List list = [];
//var data = [];
int page = 0;
int currentpage = 0;
bool allisloading = true;

class _allratingsState extends State<allratings> {
  Future getRating() async {
    setState(() {
      page++;
      isloading = true;
    });

    final response = await http.get(Uri.parse(
        'https://e-shtreeli.com/api/get_rating?page=' + (page).toString()));

    if (response.statusCode == 200) {
      setState(() {
        list = list.length > 0
            ? [...list, ...jsonDecode(response.body)['data']['data']]
            : jsonDecode(response.body)['data']['data'];
      });
      setState(() {
        isloading = false;
        allisloading = false;
      });
    } else {
      setState(() {
        page = 0;
        list = [];
        // data = [];

        isloading = true;
      });
      getRating();
      throw Exception('فنكشن التققيمات لا يعمل');
    }
  }

  void _onScroll() {
    if (_scrollController.position.atEdge) {
      bool isTop = _scrollController.position.pixels == 0;
      if (!isTop) {
        getRating();
      }
    }
  }

  @override
  void initState() {
    _scrollController = ScrollController();

    _scrollController.addListener(_onScroll);
    getRating();
    super.initState();
  }

  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  double maxScroll = 1;
  late ScrollController _scrollController;
  //double _scrollPosition = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Center(child: Text('تقييمات الزبائن'))),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: list.length > 0 || allisloading == false
            ? Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                        controller: _scrollController,
                        shrinkWrap: true,
                        itemCount: list.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Container(
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15)),
                                border:
                                    Border.all(width: 2, color: Colors.yellow)),
                            margin:
                                EdgeInsets.only(bottom: 5, right: 10, left: 10),
                            child: ListTile(
                              minLeadingWidth: 10,
                              contentPadding: EdgeInsets.all(15),
                              visualDensity: VisualDensity(vertical: 4),
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20))),
                              tileColor: Color.fromARGB(255, 247, 247, 247),
                              title: Transform.translate(
                                offset: Offset(-5, -7),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          RatingStars(
                                            valueLabelVisibility: false,
                                            starSize: 20,
                                            value: double.parse(list[index]
                                                    ['order_rating']
                                                .toString()),
                                          ),
                                          Text(
                                            list[index]['created_date'],
                                            style: TextStyle(
                                                color: Colors.red,
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Container(
                                      child: Text(
                                        list[index]['resturant_name'],
                                        style: TextStyle(
                                            color:
                                                Color.fromARGB(255, 74, 178, 5),
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Container(
                                      child: Text(
                                        list[index]['order_rating_comment'] !=
                                                null
                                            ? list[index]
                                                ['order_rating_comment']
                                            : '',
                                        style: TextStyle(
                                            color: Color.fromARGB(255, 3, 3, 3),
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Container(
                                      child: Text(
                                        list[index]['location'] != null
                                            ? list[index]['location']
                                                ['governorate_name']
                                            : 'لا يوجد',
                                        style: TextStyle(
                                            color: Color.fromARGB(
                                                255, 168, 168, 168),
                                            fontSize: 13,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Container(
                                      child: Text(
                                        "ترتيب الزبون : " +
                                            list[index]['order_name_customer']
                                                .toString(),
                                        style: TextStyle(
                                            color: Color.fromARGB(255, 3, 3, 3),
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    list[index]['order_rating_repley'] == ''
                                        ? SizedBox()
                                        : DottedBorder(
                                            borderType: BorderType.RRect,
                                            radius: Radius.circular(12),
                                            strokeWidth: 2,
                                            padding: EdgeInsets.all(6),
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(12)),
                                              child: Container(
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                color: Color.fromARGB(
                                                    255, 255, 240, 26),
                                                child: Text(
                                                  list[index]
                                                      ['order_rating_repley'],
                                                  style: TextStyle(
                                                      color: Color.fromARGB(
                                                          255, 3, 3, 3),
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                            ))
                                  ],
                                ),
                              ),
                            ),
                          );
                        }),
                  ),
                  isloading == true
                      ? Container(
                          height: 40,
                          width: 30,
                          padding: EdgeInsets.only(bottom: 10),
                          margin: EdgeInsets.only(bottom: 30),
                          child: CircularProgressIndicator(
                            color: Colors.orange,
                          ),
                        )
                      : SizedBox(),
                ],
              )
            : Center(
                child: Container(
                child: CircularProgressIndicator(
                  color: Colors.orange,
                ),
              )),
      ),
    );
  }
}
