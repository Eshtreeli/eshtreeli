import 'package:eshtreeli_flutter/otp.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:math';

class forget extends StatefulWidget {
  const forget({super.key});

  @override
  State<forget> createState() => _forgetState();
}

class _forgetState extends State<forget> {
  late TextEditingController controller2;

  String phone = '';
  String alertext = '';
  String alertextcheck = '';
  String code = '';
  bool isloading = false;
  String forget = '';

  void initState() {
    super.initState();

    controller2 = TextEditingController();
  }

  void dispose() {
    controller2.dispose();

    super.dispose();
  }

  void create() async {
    var rng = new Random();
    var ran = rng.nextInt(9000) + 1000;

    setState(() {
      code = ran.toString();
    });
    isloading = true;
    final response = await http.post(
      Uri.parse('https://e-shtreeli.com/api/forget_password_check'),
      headers: {'Content-Type': 'application/json'},
      body:
          jsonEncode({'customers_mobile': phone, 'customer_code_active': code}),
    );
    if (response.statusCode == 200) {
      if (jsonDecode(response.body)['status'] == 'true') {
        var text = 'The activation code is ' + code;
        final response = await http.post(
          Uri.parse(
              'https://www.hotsms.ps/sendbulksms.php?user_name=E-shtreeli&user_pass=1807989&sender=E-shtreeli&mobile=' +
                  phone +
                  '&type=0&text=' +
                  text +
                  ''),
        );
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => otp(forget: 'forget', phone: phone)));
      } else if (jsonDecode(response.body)['status'] == 'false_repet') {
        setState(() {
          alertext = 'لقد استنفذت  عدد مرات طلب الكود ، عذرا راجع الادارة';
        });
        openAlert();
      } else if (jsonDecode(response.body)['status'] == 'false_not_found') {
        setState(() {
          alertext =
              "الرقم الذي ادخلته غير موجود في سجلاتنا ، اذا كنت تملك الرقم قم بانشاء حساب جديد ";
          openAlert();
        });
      }

      setState(() {
        isloading = false;
      });
    } else {
      setState(() {
        isloading = false;
      });
    }
  }

  check() {
    if (alertextcheck != '' || phone == '') {
      openAlert();
      setState(() {
        alertext = 'يجب ملئ الخانة ادناه برقم جوال صحيح ،غير ناقص ';
      });
    } else {
      create();
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
        title: Container(
          margin: EdgeInsets.all(10),
          child: Text("!خطأ",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
        ),
        contentPadding: EdgeInsets.all(5),
        content:
            Text(alertext, textAlign: TextAlign.center, style: TextStyle()),
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
          Container(
            margin: EdgeInsets.symmetric(horizontal: 25),
            child: Text(
              alertextcheck,
              style: TextStyle(
                fontSize: 13,
                color: Colors.red,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(
            height: 50,
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              "قم بوضع رقم جوالك الذي سجلت به سابقا في الصندوق ادناه ",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(
            height: 30,
          ),
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
                    if (controller2.text.length < 10) {
                      setState(() {
                        alertextcheck =
                            'يجب ادخال رقم جوالك كامل وبشكل صحيح و هو عبارة عن 10 ارقام (بالانجليزي)';
                      });
                    } else {
                      setState(() {
                        alertextcheck = '';
                        phone = controller2.text.toString();
                      });
                    }
                  },
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 16.0),
                      fillColor: Colors.white,
                      filled: true,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide(
                              color: Color.fromARGB(255, 214, 211, 211),
                              width: 1)),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide:
                              BorderSide(color: Colors.orange, width: 2)),
                      hintText: 'رقم الجوال',
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
                  width: 200,
                  height: 50,
                  margin: EdgeInsets.only(top: 10),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                    ),
                    onPressed: () {
                      setState(() {});
                      check();
                    },
                    child: Text(
                      " ارسل الكود",
                      style: TextStyle(
                          color: const Color.fromARGB(255, 255, 255, 255),
                          fontSize: 17,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
          SizedBox(
            height: 80,
          ),
        ])));
  }
}
