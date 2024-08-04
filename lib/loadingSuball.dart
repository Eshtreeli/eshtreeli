import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class loadingSuball extends StatelessWidget {
  loadingSuball({super.key});
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
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3, // Number of columns
          crossAxisSpacing: 10.0, // Spacing between the columns
          mainAxisSpacing: 20.0,
          childAspectRatio: 2 / 2.5 // Spacing between the rows
          ),
      itemCount: items.length,
      itemBuilder: (BuildContext context, int index) {
        return GridTile(
            child: Container(
          width: MediaQuery.of(context).size.width,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [
                  Container(
                    margin: EdgeInsets.all(2),
                    height: 110,
                    width: 110,
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
        ));
      },
    );
  }
}
