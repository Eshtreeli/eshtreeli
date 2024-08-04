// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:eshtreeli_flutter/home.dart';
import 'package:eshtreeli_flutter/login.dart';
import 'package:eshtreeli_flutter/signup.dart';
import 'package:flutter/material.dart';

class wel extends StatefulWidget {
  wel({super.key});

  @override
  State<wel> createState() => _MyWelState();
}

class _MyWelState extends State<wel> {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Color.fromARGB(255, 240, 235, 235),
      child: Column(mainAxisAlignment: MainAxisAlignment.end, children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(20), // Ad
          child: Image.asset(
            "images/icon.png",
            width: 200,
            height: 200,
            fit: BoxFit.cover,
          ),
        ),
        SizedBox(
          height: 70,
        ),
        Text(
          "اشتريلي ،يعني لا تقلق احنا بندبرك!",
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 25, color: Colors.orange, fontWeight: FontWeight.bold),
        ),
        Padding(
          padding: EdgeInsets.all(15),
          child: Text(
            "لاول مرة في فلسطين تطبيق شامل لجميع احتياجاتك  وخدماتك اليومية مطاعم ، سوبرماركت ، تكسي ، خدمات،دعاية ...واخرى ",
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Color.fromARGB(255, 255, 167, 4),
            padding: EdgeInsets.symmetric(horizontal: 60, vertical: 15),
          ),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => signup(),
              ),
            );
          },
          child: Text("انشاء حساب",
              style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.white)),
        ),
        SizedBox(
          height: 10,
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            padding: EdgeInsets.symmetric(horizontal: 60, vertical: 15),
          ),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => login(),
              ),
            );
          },
          child: Text("تسجيل دخول",
              style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.white)),
        ),
        SizedBox(
          height: 5,
        ),
        InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => home(),
                ),
              );
            },
            child: Container(
                alignment: Alignment.center,
                margin: EdgeInsets.symmetric(vertical: 10),
                height: 50,
                width: 200,
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(10)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.arrow_back_ios,
                      color: const Color.fromARGB(255, 132, 130, 127),
                    ),
                    Text(
                      "المتابعة بدون تسجيل",
                      style: TextStyle(
                          color: Color.fromARGB(255, 125, 125, 120),
                          fontSize: 15,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ))),
        SizedBox(
          height: 50,
        ),
      ]),
    );
  }
}
