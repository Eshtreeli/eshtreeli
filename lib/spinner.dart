import 'package:eshtreeli_flutter/home.dart';
import 'package:eshtreeli_flutter/welcome.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:localstorage/localstorage.dart';

class spinner extends StatefulWidget {
  const spinner({super.key});

  @override
  State<spinner> createState() => _spinnerState();
}

class _spinnerState extends State<spinner> with SingleTickerProviderStateMixin {
  var enterToken;
  @override
  void initState() {
    super.initState();

    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);

    Future.delayed(const Duration(seconds: 3), () {
      if (localStorage.getItem('id') != null &&
          localStorage.getItem('id') != '') {
        print('enter token ${localStorage.getItem('token')}');
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => home()),
          (Route<dynamic> route) => false,
        );
      } else {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => wel()));
      }
      ;
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromARGB(255, 255, 174, 1),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: EdgeInsets.only(top: 50),
                height: 200,
                child: Image.asset('images/icon-3.png'),
              ),
              Container(
                padding: EdgeInsets.only(top: 20),
                margin: EdgeInsets.only(top: 20),
                child: CircularProgressIndicator(
                    valueColor: new AlwaysStoppedAnimation<Color>(
                        const Color.fromARGB(255, 255, 255, 255))),
              ),
            ],
          ),
        ));
  }
}
