import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Policy extends StatefulWidget {
  const Policy({super.key});

  @override
  State<Policy> createState() => _PolicyState();
}

var policie_title = '';
var policie_description = '';
bool isloading = true;

class _PolicyState extends State<Policy> {
  Future fetchPlicey() async {
    final response =
        await http.get(Uri.parse('https://e-shtreeli.com/api/policies'));

    if (response.statusCode == 200) {
      setState(() {
        policie_title = jsonDecode(response.body)['data'][0]['policie_title'];
        policie_description =
            jsonDecode(response.body)['data'][0]['policie_description'];
        isloading = false;
      });
    } else {
      throw Exception('Failed to load Policy');
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
          title: Center(child: Text(policie_title)),
        ),
        body: !isloading
            ? SingleChildScrollView(
                child: Directionality(
                  textDirection: TextDirection.rtl,
                  child: Container(
                      margin: EdgeInsets.all(15),
                      child: Text(policie_description)),
                ),
              )
            : Center(
                child: CircularProgressIndicator(
                  color: Colors.orange,
                ),
              ));
  }
}
