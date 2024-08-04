import 'package:eshtreeli_flutter/forget.dart';
import 'package:eshtreeli_flutter/signup.dart';
import 'package:eshtreeli_flutter/spinner.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:localstorage/localstorage.dart';

class login extends StatefulWidget {
  const login({super.key});

  @override
  State<login> createState() => _loginState();
}

class _loginState extends State<login> {
  late TextEditingController controller2;
  late TextEditingController controller4;

  String phone = '';
  String alertext = '';
  String alertextpass = '';
  String password = '';
  bool isloading = false;
  String false_data = '';
  void initState() {
    super.initState();

    controller2 = TextEditingController();
    controller4 = TextEditingController();
  }

  void dispose() {
    controller4.dispose();
    controller2.dispose();

    super.dispose();
  }

  void create() async {
    isloading = true;
    final response = await http.post(
      Uri.parse('https://e-shtreeli.com/api/login'),
      headers: <String, String>{'Content-Type': 'application/json'},
      body: jsonEncode(<String, dynamic>{
        'customers_mobile': phone,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      if (jsonDecode(response.body)['error'] !=
          'اسم المستخدم او كلمة المرور خاطئة') {
        setState(() {
          isloading = false;
        });
        localStorage.setItem('token', jsonDecode(response.body)['token']);
        localStorage.setItem(
            'id', jsonDecode(response.body)['user']['id'].toString());
        setState(() {
          false_data = '';
        });

        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => spinner()));
      } else {
        setState(() {
          isloading = false;
        });
        setState(() {
          openAlert();
          false_data =
              'رقم الجوال الذي ادخلته او كلمة المرور خطأ ، يرجى اعادة المحاولة';
        });
      }

      //print(jsonDecode(response.body)['token']);

      // فك الجيسون وتحويله لدارت
    } else {
      throw Exception('error');
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
        content:
            Text(false_data, textAlign: TextAlign.center, style: TextStyle()),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
            backgroundColor: Color.fromARGB(255, 255, 253, 250),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: Text(
                      "تسجيل دخول ",
                      style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.green),
                    ),
                  ),
                  Container(
                      padding: EdgeInsets.only(bottom: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "ان كنت لا تملك حساب يجب عليك ",
                            style: TextStyle(
                              fontSize: 15,
                              //  fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => signup()));
                            },
                            child: Text(
                              "انشاء حساب",
                              style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.orange),
                            ),
                          ),
                        ],
                      )),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                          margin: EdgeInsets.only(bottom: 25),
                          child: Icon(Icons.mobile_friendly)),
                      SizedBox(
                        width: 265,
                        child: TextField(
                          controller: controller2,
                          maxLength: 10,
                          keyboardType: TextInputType.number,
                          onChanged: (String value) {
                            setState(() {
                              if (controller2.text.length < 10) {
                                phone = 'e';

                                alertext =
                                    'يجب ادخال رقم جوالك كامل وبشكل صحيح و هو عبارة عن 10 ارقام (بالانجليزي)';
                              } else {
                                phone = controller2.text.toString();
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
                                      color: Colors.orange, width: 2)),
                              hintText: 'رقم الجوال',
                              hintStyle: TextStyle(
                                  color: Color.fromARGB(255, 176, 176, 176))),
                        ),
                      ),
                      SizedBox(
                        width: 30,
                      )
                    ],
                  ),
                  if (alertext != '')
                    Container(
                      width: 265,
                      child: Text(alertext,
                          style: TextStyle(color: Colors.red, fontSize: 11)),
                    ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 5, left: 3),
                        child: Icon(Icons.lock),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 10),
                        width: 265,
                        child: TextField(
                          controller: controller4,
                          onChanged: (String value) {
                            setState(() {
                              password = controller4.text;
                            });
                          },
                          decoration: InputDecoration(
                              fillColor: Colors.white,
                              filled: true,
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 10.0, horizontal: 16.0),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                      color: Color.fromARGB(255, 214, 211, 211),
                                      width: 1)),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide: BorderSide(
                                      color: Colors.orange, width: 2)),
                              hintText: 'كلمة المرور',
                              hintStyle: TextStyle(
                                  color: Color.fromARGB(255, 176, 176, 176))),
                        ),
                      ),
                      SizedBox(width: 30)
                    ],
                  ),
                  SizedBox(height: 30),
                  isloading
                      ? SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            color: Colors.green,
                          ))
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 250,
                              height: 50,
                              margin: EdgeInsets.only(top: 10),
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green),
                                onPressed: () {
                                  setState(() {});
                                  create();
                                },
                                child: Text(
                                  "اضغط للمتابعة",
                                  style: TextStyle(
                                      color: const Color.fromARGB(
                                          255, 255, 255, 255),
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ],
                        ),
                  false_data != ''
                      ? Container(
                          padding: EdgeInsets.only(top: 50),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "هل نسيت كلمة المرور؟ ",
                                style: TextStyle(
                                  fontSize: 15,
                                  //  fontWeight: FontWeight.bold,
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => forget()));
                                },
                                child: Text(
                                  "اضغط هنا",
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ))
                      : Container(),
                ],
              ),
            )));
  }
}
