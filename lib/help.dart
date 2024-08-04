import 'package:accordion/accordion.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class help extends StatefulWidget {
  const help({super.key});

  @override
  State<help> createState() => _helpState();
}

bool isloading = true;
List data = [];

class _helpState extends State<help> {
  Future fetchPlicey() async {
    final response =
        await http.get(Uri.parse('https://e-shtreeli.com/api/help'));

    if (response.statusCode == 200) {
      setState(() {
        data = jsonDecode(response.body)['data'];
        isloading = false;
      });
      print(data);
    } else {
      setState(() {
        isloading = false;
      });
      throw Exception('Failed to load he;p');
    }
  }

  @override
  void initState() {
    fetchPlicey();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Center(child: Text('اسئلة شائعة')),
        ),
        body: data.length > 0 || isloading == false
            ? Directionality(
                textDirection: TextDirection.rtl,
                child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: data.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                          margin: EdgeInsets.only(bottom: 5),
                          child: Accordion(
                              headerBackgroundColor:
                                  const Color.fromARGB(255, 243, 181, 87),
                              paddingListBottom: 0,
                              paddingListTop: 0,
                              children: [
                                AccordionSection(
                                    header: Container(
                                        height: 60,
                                        margin: EdgeInsets.all(10),
                                        child: Text(
                                          data[index]['help_question'],
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold),
                                        )),
                                    content: Text(data[index]['help_answer']))
                              ]));
                    }),
              )
            : Center(
                child: CircularProgressIndicator(
                  color: Colors.orange,
                ),
              ));
  }
}
//data[index]['help_question']