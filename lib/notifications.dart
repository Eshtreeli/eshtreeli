import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class notification extends StatefulWidget {
  const notification({super.key});

  @override
  State<notification> createState() => _notificationState();
}

bool isloading = true;

class _notificationState extends State<notification> {
  List data = [];
  Future noti() async {
    setState(() {
      isloading = true;
    });
    final response = await http.post(
      Uri.parse('https://e-shtreeli.com/api/get_notification_mobile'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'user_id': localStorage.getItem('id'),
      }),
    );

    if (response.statusCode == 200) {
      setState(() {
        setState(() {
          isloading = false;
        });
        data = jsonDecode(response.body)['data'];
      });
    } else {
      throw Exception('Failed to load cat');
    }
  }

  @override
  void initState() {
    noti();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Center(
            child: Text(
              "الإشعارات",
            ),
          ),
        ),
        body: isloading
            ? Center(
                child: CircularProgressIndicator(
                  color: Colors.orange,
                ),
              )
            : ListView.builder(
                itemCount: data.length,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                      margin: EdgeInsets.only(bottom: 5, right: 10, left: 10),
                      child: ListTile(
                        minLeadingWidth: 10,
                        contentPadding: EdgeInsets.all(5),
                        visualDensity: VisualDensity(vertical: 4),
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(20))),
                        tileColor: Color.fromARGB(255, 239, 235, 229),
                        title: Transform.translate(
                          offset: Offset(-5, 0),
                          child: Text(
                            data[index]['notification_text'],
                            textAlign: TextAlign.end,
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                        ),
                        leading: Text(data[index]['created_date'],
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.grey,
                                fontSize: 14,
                                fontWeight: FontWeight.bold)),
                        trailing: Icon(
                          data[index]['notification_icon'] == 'check-square-o'
                              ? Icons.check_circle
                              : data[index]['notification_icon'] == 'spinner'
                                  ? Icons.timelapse
                                  : data[index]['notification_icon'] ==
                                          'times-circle-o'
                                      ? Icons.error
                                      : Icons.thumb_up,
                          color: Color(int.parse(
                                  data[index]['notification_color']
                                      .substring(1, 7),
                                  radix: 16) +
                              0xFF000000),
                          size: 50,
                        ),
                      ));
                },
              ));
  }
}
