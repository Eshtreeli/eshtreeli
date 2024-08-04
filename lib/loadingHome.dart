import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class loadingHome extends StatelessWidget {
  loadingHome({super.key});
  final List<String> items = [
    'Item 1',
    'Item 2',
    'Item 3',
    'Item 4',
    'Item 5',
    'Item 6',
    'Item 7',
    'Item 8',
    'Item 9',
    'Item 10',
    'Item 1',
    'Item 2',
    'Item 3',
    'Item 4',
    'Item 5',
    'Item 6',
    'Item 7',
    'Item 8',
    'Item 9',
    'Item 10',
  ];
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          child: Container(
            margin: EdgeInsets.all(5),
            height: 270,
            width: MediaQuery.of(context).size.width,
            child: Shimmer.fromColors(
                baseColor: Color.fromARGB(255, 223, 223, 223),
                highlightColor: Color.fromARGB(255, 203, 203, 203),
                child: Container(
                    decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  color: Color.fromARGB(255, 255, 255, 255),
                ))),
          ),
        ),
        SizedBox(
          height: 40,
        ),
        Container(
          margin: EdgeInsets.only(bottom: 20),
          width: MediaQuery.of(context).size.width,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [
                  Container(
                    margin: EdgeInsets.all(5),
                    height: 95,
                    width: 105,
                    child: Shimmer.fromColors(
                        baseColor: Color.fromARGB(255, 223, 223, 223),
                        highlightColor: Color.fromARGB(255, 203, 203, 203),
                        child: Container(
                            decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          color: Color.fromARGB(255, 255, 255, 255),
                        ))),
                  ),
                  Container(
                    margin: EdgeInsets.all(5),
                    height: 10,
                    width: 100,
                    child: Shimmer.fromColors(
                        baseColor: Color.fromARGB(255, 223, 223, 223),
                        highlightColor: Color.fromARGB(255, 203, 203, 203),
                        child: Container(
                            decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          color: Color.fromARGB(255, 255, 255, 255),
                        ))),
                  ),
                ],
              ),
              SizedBox(
                width: 5,
              ),
              Column(
                children: [
                  Container(
                    margin: EdgeInsets.all(5),
                    height: 95,
                    width: 105,
                    child: Shimmer.fromColors(
                        baseColor: Color.fromARGB(255, 223, 223, 223),
                        highlightColor: Color.fromARGB(255, 203, 203, 203),
                        child: Container(
                            decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          color: Color.fromARGB(255, 255, 255, 255),
                        ))),
                  ),
                  Container(
                    margin: EdgeInsets.all(5),
                    height: 10,
                    width: 100,
                    child: Shimmer.fromColors(
                        baseColor: Color.fromARGB(255, 223, 223, 223),
                        highlightColor: Color.fromARGB(255, 203, 203, 203),
                        child: Container(
                            decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          color: Color.fromARGB(255, 255, 255, 255),
                        ))),
                  ),
                ],
              ),
              SizedBox(
                width: 5,
              ),
              Column(
                children: [
                  Container(
                    margin: EdgeInsets.all(5),
                    height: 95,
                    width: 105,
                    child: Shimmer.fromColors(
                        baseColor: Color.fromARGB(255, 223, 223, 223),
                        highlightColor: Color.fromARGB(255, 203, 203, 203),
                        child: Container(
                            decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          color: Color.fromARGB(255, 255, 255, 255),
                        ))),
                  ),
                  Container(
                    margin: EdgeInsets.all(5),
                    height: 10,
                    width: 100,
                    child: Shimmer.fromColors(
                        baseColor: Color.fromARGB(255, 223, 223, 223),
                        highlightColor: Color.fromARGB(255, 203, 203, 203),
                        child: Container(
                            decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          color: Color.fromARGB(255, 255, 255, 255),
                        ))),
                  ),
                ],
              ),
            ],
          ),
        ),
        Container(
          height: 300,
          child: ListView.builder(
            reverse: true,
            itemCount: items.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (BuildContext context, int index) {
              return Container(
                margin: EdgeInsets.only(bottom: 5),
                // width: MediaQuery.of(context).size.width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Column(
                      children: [
                        Container(
                          margin: EdgeInsets.all(10),
                          height: 200,
                          width: 300,
                          child: Shimmer.fromColors(
                              baseColor: Color.fromARGB(255, 223, 223, 223),
                              highlightColor:
                                  Color.fromARGB(255, 203, 203, 203),
                              child: Container(
                                  decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                                color: Color.fromARGB(255, 255, 255, 255),
                              ))),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        Container(
          height: 300,
          child: ListView.builder(
            reverse: true,
            itemCount: items.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (BuildContext context, int index) {
              return Container(
                margin: EdgeInsets.only(bottom: 20),
                // width: MediaQuery.of(context).size.width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Column(
                      children: [
                        Container(
                          margin: EdgeInsets.all(10),
                          height: 200,
                          width: 300,
                          child: Shimmer.fromColors(
                              baseColor: Color.fromARGB(255, 223, 223, 223),
                              highlightColor:
                                  Color.fromARGB(255, 203, 203, 203),
                              child: Container(
                                  decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                                color: Color.fromARGB(255, 255, 255, 255),
                              ))),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        )
      ],
    );
  }
}
