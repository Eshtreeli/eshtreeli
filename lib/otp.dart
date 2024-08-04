import 'package:eshtreeli_flutter/passchange.dart';
import 'package:eshtreeli_flutter/spinner.dart';
import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:localstorage/localstorage.dart';

class Otp {
  var token;
  Otp({required this.token});

  factory Otp.fromJson(json) {
    //تحويل المفكو
    //ك من الجيسون بلغة دارت للمعلومات
    return Otp(
      token: json['token'],
    );
  }
}

class otp extends StatefulWidget {
  final phone;
  final forget;
  const otp({required this.phone, required this.forget});

  @override
  State<otp> createState() => _otpState();
}

class _otpState extends State<otp> {
  bool isloading = false;

  String false_data = '';
  fitchsendcode() async {
    final response = await http.post(
      Uri.parse('https://e-shtreeli.com/api/send_code_v'),
      headers: <String, String>{'Content-Type': 'application/json'},
      body: jsonEncode(<String, dynamic>{
        'customers_mobile': widget.phone,
        'customer_code_active': 1234,
      }),
    );

    if (response.statusCode == 200) {
      // فك الجيسون وتحويله لدارت
    } else {
      throw Exception('error');
    }
  }

  Future<Otp> fitchOtp(verificationCode) async {
    setState(() {
      isloading = true;
    });
    final response = await http.post(
      Uri.parse('https://e-shtreeli.com/api/check_code_ative_user'),
      headers: <String, String>{'Content-Type': 'application/json'},
      body: jsonEncode(<String, dynamic>{
        'customers_mobile': widget.phone,
        'customer_code_active': verificationCode,
      }),
    );

    if (response.statusCode == 200) {
      if (jsonDecode(response.body)['data_false'] != 'لم يتم التفعيل') {
        setState(() {
          isloading = false;
        });
        localStorage.setItem('token', jsonDecode(response.body)['token']);
        localStorage.setItem(
            'id', jsonDecode(response.body)['data']['id'].toString());
        setState(() {
          false_data = '';
        });
        if (widget.forget == 'forget') {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => passChange(phone: widget.phone)));
        } else {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => spinner()),
            (Route<dynamic> route) => false,
          );
        }
      } else {
        setState(() {
          isloading = false;
        });
        setState(() {
          false_data =
              'لم يتم التفعيل! الرمز الذي ادخلته خاطئ اعد ادخاله من جديد( و لوحة المفاتيح انجليزي)';
        });
      }

      //print(jsonDecode(response.body)['token']);

      return Otp.fromJson(jsonDecode(response.body));

      // فك الجيسون وتحويله لدارت
    } else {
      throw Exception('error');
    }
  }

  void initState() {
    super.initState();

    fitchsendcode();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              margin: EdgeInsets.all(40),

              child: Text(
                widget.forget == ''
                    ? 'الرمز الخاص بك هو 1234 قم بادخاله في الخانات ادناه'
                    : ' انتظر لحظات ستصلك رسالة  على الرقم المدخل تحوي رمز التفعيل ،و(الكيبورد انجليزي) ادخل الرمز المرسل في الفراغات ادناه',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.orange,
                    fontSize: 17,
                    fontWeight: FontWeight.bold),
              ),

              //Navigator.pop(context);
            ),
            Container(
              margin: EdgeInsets.all(20),
              child: OtpTextField(
                numberOfFields: 4,
                borderColor: Colors.orange,
                focusedBorderColor: Colors.green,
                // styles: otpTextStyles,
                showFieldAsBox: false,
                borderWidth: 4.0,
                //runs when a code is typed in
                onCodeChanged: (
                  String code,
                ) async {},
                //runs when every textfield is filled
                onSubmit: (String verificationCode) {
                  fitchOtp(verificationCode);
                },
              ),
            ),
            Container(
              margin: EdgeInsets.all(40),
              child: !isloading
                  ? Text(
                      false_data,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.red,
                          fontSize: 13,
                          fontWeight: FontWeight.bold),
                    )
                  : CircularProgressIndicator(),

              //Navigator.pop(context);
            ),
          ],
        ));
  }
}
