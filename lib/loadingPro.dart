import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class loadingPro extends StatelessWidget {
  const loadingPro({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Positioned(
        child: Container(
          margin: EdgeInsets.only(bottom: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [
                  Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.all(5),
                    height: 130,
                    width: MediaQuery.of(context).size.width - 10,
                    child: Shimmer.fromColors(
                        baseColor: Color.fromARGB(255, 238, 238, 238),
                        highlightColor: Color.fromARGB(255, 237, 237, 237),
                        child: Container(
                            decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            bottomLeft: Radius.circular(15),
                            topRight: Radius.circular(10),
                            bottomRight: Radius.circular(50),
                          ),
                          color: Color.fromARGB(255, 255, 255, 255),
                        ))),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      Positioned(
        top: 30,
        right: 25,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              children: [
                Container(
                  margin: EdgeInsets.all(5),
                  height: 80,
                  width: 90,
                  child: Shimmer.fromColors(
                      baseColor: Color.fromARGB(255, 218, 218, 218),
                      highlightColor: Color.fromARGB(255, 209, 209, 209),
                      child: Container(
                          decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          bottomLeft: Radius.circular(15),
                          topRight: Radius.circular(10),
                          bottomRight: Radius.circular(25),
                        ),
                        color: Color.fromARGB(255, 255, 255, 255),
                      ))),
                ),
              ],
            ),
          ],
        ),
      ),
      Positioned(
        top: 10,
        left: 70,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 60,
                ),
                Container(
                  margin: EdgeInsets.all(5),
                  height: 20,
                  width: 120,
                  child: Shimmer.fromColors(
                      baseColor: Color.fromARGB(255, 217, 217, 217),
                      highlightColor: Color.fromARGB(255, 225, 225, 225),
                      child: Container(
                          decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(5),
                          bottomLeft: Radius.circular(5),
                          topRight: Radius.circular(5),
                          bottomRight: Radius.circular(5),
                        ),
                        color: Color.fromARGB(255, 255, 255, 255),
                      ))),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    Container(
                      margin: EdgeInsets.all(5),
                      height: 10,
                      width: 15,
                      child: Shimmer.fromColors(
                          baseColor: Color.fromARGB(255, 225, 225, 225),
                          highlightColor: Color.fromARGB(255, 229, 229, 229),
                          child: Container(
                              decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(5),
                              bottomLeft: Radius.circular(5),
                              topRight: Radius.circular(5),
                              bottomRight: Radius.circular(5),
                            ),
                            color: Color.fromARGB(255, 255, 255, 255),
                          ))),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Container(
                      margin: EdgeInsets.all(5),
                      height: 10,
                      width: 160,
                      child: Shimmer.fromColors(
                          baseColor: Color.fromARGB(255, 225, 225, 225),
                          highlightColor: Color.fromARGB(255, 229, 229, 229),
                          child: Container(
                              decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(5),
                              bottomLeft: Radius.circular(5),
                              topRight: Radius.circular(5),
                              bottomRight: Radius.circular(5),
                            ),
                            color: Color.fromARGB(255, 255, 255, 255),
                          ))),
                    ),
                  ],
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    Container(
                      margin: EdgeInsets.all(5),
                      height: 10,
                      width: 15,
                      child: Shimmer.fromColors(
                          baseColor: Color.fromARGB(255, 225, 225, 225),
                          highlightColor: Color.fromARGB(255, 229, 229, 229),
                          child: Container(
                              decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(5),
                              bottomLeft: Radius.circular(5),
                              topRight: Radius.circular(5),
                              bottomRight: Radius.circular(5),
                            ),
                            color: Color.fromARGB(255, 255, 255, 255),
                          ))),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Container(
                      margin: EdgeInsets.all(5),
                      height: 10,
                      width: 160,
                      child: Shimmer.fromColors(
                          baseColor: Color.fromARGB(255, 225, 225, 225),
                          highlightColor: Color.fromARGB(255, 229, 229, 229),
                          child: Container(
                              decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(5),
                              bottomLeft: Radius.circular(5),
                              topRight: Radius.circular(5),
                              bottomRight: Radius.circular(5),
                            ),
                            color: Color.fromARGB(255, 255, 255, 255),
                          ))),
                    ),
                  ],
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    Container(
                      margin: EdgeInsets.all(5),
                      height: 10,
                      width: 15,
                      child: Shimmer.fromColors(
                          baseColor: Color.fromARGB(255, 225, 225, 225),
                          highlightColor: Color.fromARGB(255, 229, 229, 229),
                          child: Container(
                              decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(5),
                              bottomLeft: Radius.circular(5),
                              topRight: Radius.circular(5),
                              bottomRight: Radius.circular(5),
                            ),
                            color: Color.fromARGB(255, 255, 255, 255),
                          ))),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Container(
                      margin: EdgeInsets.all(5),
                      height: 10,
                      width: 160,
                      child: Shimmer.fromColors(
                          baseColor: Color.fromARGB(255, 225, 225, 225),
                          highlightColor: Color.fromARGB(255, 229, 229, 229),
                          child: Container(
                              decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(5),
                              bottomLeft: Radius.circular(5),
                              topRight: Radius.circular(5),
                              bottomRight: Radius.circular(5),
                            ),
                            color: Color.fromARGB(255, 255, 255, 255),
                          ))),
                    ),
                  ],
                )
              ],
            ),
          ],
        ),
      ),
    ]);
  }
}
