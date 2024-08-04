import 'package:eshtreeli_flutter/spinner.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class passChange extends StatefulWidget {
  final phone;

  const passChange({
    required this.phone,
  });

  @override
  State<passChange> createState() => _passChangeState();
}

class _passChangeState extends State<passChange> {
  late TextEditingController controller2;

  String alertext = '';
  String password = '';
  bool isloading = false;

  void initState() {
    super.initState();

    controller2 = TextEditingController();
  }

  void dispose() {
    controller2.dispose();

    super.dispose();
  }

  void check() async {
    {
      isloading = true;

      final response = await http.post(
        Uri.parse('https://e-shtreeli.com/api/reset_password'),
        headers: <String, String>{'Content-Type': 'application/json'},
        body: jsonEncode(<String, dynamic>{
          'customers_mobile': widget.phone,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        if (jsonDecode(response.body)['status'] == 'true') {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => spinner()));
          isloading = false;
        } else {
          setState(() {
            isloading = false;
            alertext = 'لم يتم حفظ كلمة السر نرجوا اعادة المحاولة ';
            openAlert();
          });
        }
      } else {
        throw Exception('error');
      }
    }
  }

  void openAlert() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        actions: [
          Center(
            child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  'تمام',
                  textAlign: TextAlign.center,
                )),
          ),
        ],
        title: Text("!خطأ",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
        contentPadding: EdgeInsets.all(5),
        content: Container(
            margin: EdgeInsets.all(10),
            child: Text(alertext,
                textAlign: TextAlign.center, style: TextStyle())),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
        textDirection: TextDirection.rtl,
        child: Material(
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text(
            alertext,
            style: TextStyle(
              fontSize: 13,
              color: Colors.red,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: 30,
          ),
          Text(
            "قم بوضع كلمة سر جديدة ",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(
            height: 30,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                  margin: EdgeInsets.only(bottom: 5),
                  child: Icon(Icons.mobile_friendly)),
              SizedBox(
                width: 265,
                child: TextField(
                  controller: controller2,
                  onChanged: (String value) {
                    setState(() {
                      if (controller2.text.length < 7) {
                        password = 'e';

                        alertext = 'يجب ادخال كلمة سر لا تقل عن 7 خانات';
                      } else {
                        password = controller2.text.toString();
                        alertext = '';
                      }
                    });
                  },
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 16.0),
                      fillColor: Colors.white,
                      filled: true,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                              color: Color.fromARGB(255, 214, 211, 211),
                              width: 1)),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide(
                              color: Color.fromARGB(255, 37, 203, 8),
                              width: 2)),
                      hintText: 'كلمة السر',
                      hintStyle:
                          TextStyle(color: Color.fromARGB(255, 176, 176, 176))),
                ),
              ),
              SizedBox(
                width: 25,
              )
            ],
          ),
          SizedBox(height: 10),
          isloading
              ? SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    color: Colors.green,
                  ))
              : Container(
                  width: 250,
                  height: 50,
                  margin: EdgeInsets.only(top: 40),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                    ),
                    onPressed: () {
                      setState(() {});
                      check();
                    },
                    child: Text(
                      " احفظ",
                      style: TextStyle(
                          color: const Color.fromARGB(255, 255, 255, 255),
                          fontSize: 17,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
          SizedBox(
            height: 100,
          )
        ])));
  }
}
