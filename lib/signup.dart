import 'package:eshtreeli_flutter/login.dart';
import 'package:eshtreeli_flutter/otp.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class SignUp {
  final false_phone;
  final false_name;
  final false_password;
  const SignUp({
    required this.false_phone,
    required this.false_name,
    required this.false_password,
  });

  factory SignUp.fromJson(json) {
    //تحويل المفكو
    //ك من الجيسون بلغة دارت للمعلومات
    return SignUp(
      false_phone: json['false_phone'],
      false_name: json['false_name'],
      false_password: json['false_password'],
    );
  }
}

Future<List<Reagion>> fetchPlace(String id) async {
  final response = await http.post(
    Uri.parse('https://e-shtreeli.com/api/get_region'),
    headers: <String, String>{'Content-Type': 'application/json'},
    body: jsonEncode(<String, dynamic>{
      'id': id,
    }),
  );
  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);

    final List<Reagion> re = [];
    for (var i = 0; i < data['data'].length; i++) {
      final entry = data['data'][i];

      re.add(Reagion.fromJson(entry));
    }
    return re;
  } else {
    throw Exception('Failed to load City');
  }
}

Future<List<City>> fetchMainPlace() async {
  final response =
      await http.get(Uri.parse('https://e-shtreeli.com/api/get_region_main'));

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);

    final List<City> list = [];
    for (var i = 0; i < data['data_r_m'].length; i++) {
      final entry = data['data_r_m'][i];
      list.add(City.fromJson(entry));
    }
    return list;
  } else {
    throw Exception('Failed to load City');
  }
}

Future<List<Policey>> fetchPlicey() async {
  final response =
      await http.get(Uri.parse('https://e-shtreeli.com/api/policies'));

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);

    final List<Policey> list = [];
    for (var i = 0; i < data['data'].length; i++) {
      final entry = data['data'][i];
      list.add(Policey.fromJson(entry));
    }
    return list;
  } else {
    throw Exception('Failed to load City');
  }
}

class Reagion {
  final int idd;
  final String nameRe;

  const Reagion({required this.idd, required this.nameRe});

  factory Reagion.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'Id': int idd,
        'Name': String nameRe,
      } =>
        Reagion(
          idd: idd,
          nameRe: nameRe,
        ),
      _ => throw const FormatException('Failed to load album.'),
    };
  }
}

class City {
  final int id;
  final String name;

  const City({
    required this.id,
    required this.name,
  });

  factory City.fromJson(Map<String, dynamic> json) {
    //لفك الجيسون
    return City(
      id: json['Id'],
      name: json['Name'],
    );
  }
}

class Policey {
  final String policie_title;
  final String policie_description;

  const Policey({
    required this.policie_title,
    required this.policie_description,
  });

  factory Policey.fromJson(Map<String, dynamic> json) {
    //لفك الجيسون
    return Policey(
      policie_title: json['policie_title'],
      policie_description: json['policie_description'],
    );
  }
}

class signup extends StatefulWidget {
  const signup({super.key});

  @override
  State<signup> createState() => _signupState();
}

class _signupState extends State<signup> {
  Future<SignUp> fitchSignup(String username, String phone, String password,
      String nameRe, String job) async {
    var code = 1234;

    final response = await http.post(
      Uri.parse('https://e-shtreeli.com/api/register'),
      headers: <String, String>{'Content-Type': 'application/json'},
      body: jsonEncode(<String, dynamic>{
        'customers_name': username,
        'customers_mobile': phone,
        'password': password,
        'customers_email': '',
        'customers_governorates_user': nameRe,
        'customer_code_active': code,
        'job': job,
      }),
    );

    if (response.statusCode == 200) {
      if (jsonDecode(response.body)['false_name'] == 'تحقق من الاسم') {
        setState(() {
          alertext = "لقد قمت بادخال اسم مستخدم تم استخدامه مسبقا";
        });
        openAlert();
      } else if (jsonDecode(response.body)['false_phone'] ==
          'تحقق من رقم الهاتف') {
        setState(() {
          alertext =
              "لقد قمت بادخال رقم جوال تم استخدامه سابقا ، اذا كنت صاحب الرقم قم بتسجيل الدخول بدل انشاء الحساب";
        });
        openAlert();
      } else if (jsonDecode(response.body)['false_password'] ==
          'تحقق من كلمة المرور') {
        setState(() {
          alertext = "يجب ان تكون كلمة السر مكونة من 7 خانات على الاقل";
        });
        openAlert();
      } else {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => otp(
                      phone: phone,
                      forget: '',
                    )));
      }
      setState(() {
        isloading = false;
      });
      return SignUp.fromJson(jsonDecode(response.body));

      // فك الجيسون وتحويله لدارت
    } else {
      throw Exception('');
    }
  }

  bool? isChecked = false;
  late Future<List<City>> city;
  Future<List<Reagion>>? region;
  Future<List<Policey>>? policy;
  Future<SignUp>? sign;
  late TextEditingController controller;
  late TextEditingController controller2;
  late TextEditingController controller3;
  late TextEditingController controller4;
  String username = '';
  String alertext = '';
  String name = '';
  String nameRe = '';
  String adel = '';
  String state = '';
  String phone = '';
  String password = '';
  String id = '';
  String Idd = '';
  bool isloading = false;
  String job = 'لم يدخل';

  String alertextphone = '';
  String alertextPolicy = '';
  String alertextpass = '';
  String alertextmain = '';
  String alertextarea = '';
  String alertextName = '';
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

  void create() async {
    if (username == '') {
      setState(() {
        alertext = "يجب عليك ادخل اسم المستخدم يجب ان يكون اسمك الحقيقي";
      });
      openAlert();
    } else if (phone == '' || phone == 'e') {
      setState(() {
        alertext =
            'يجب ادخال رقم جوالك كامل وبشكل صحيح و هو عبارة عن 10 ارقام (بالانجليزي)';
      });
      openAlert();
    } else if (password == '' || alertextpass != '') {
      setState(() {
        alertext = '  يجب ادخال كملة المرور كاملة من 8 خانات على الاقل';
      });
      openAlert();
    } else if (name == '') {
      setState(() {
        alertext = 'الرجاء اخيار منطقتك الرئيسية';
      });
      openAlert();
    } else if (nameRe == '') {
      setState(() {
        alertext =
            'الرجاء اخيار منطقتك التفصيلية علما ان سعر التوصيل يعتمد عليها';
      });
      openAlert();
    } else if (isChecked == false) {
      openAlert();

      alertext = 'الرجاء الموافقة على سياسة الاستخدام';
    } else {
      sign = fitchSignup(username, phone, password, nameRe, job);
      setState(() {
        isloading = true;
      });
    }
  }

  void getRigeon(id) {
    setState(() {
      id = id;
    });
    region = fetchPlace(id);
  }

  void openModal() {
    setState(() {
      nameRe = '';
    });
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (ctx) => Container(
              width: double.infinity,
              child: Column(children: [
                Container(
                  margin: EdgeInsets.only(top: 20, bottom: 20),
                  child: Text(
                    "اختر منطقتك الأساسية",
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                ),
                FutureBuilder<List<City>>(
                    future: city,
                    builder: (context, AsyncSnapshot snapshot) {
                      if (snapshot.hasData) {
                        return ListView.builder(
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            City data = snapshot.data?[index];
                            return Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        // padding: EdgeInsets.all(5),

                                        TextButton(
                                          onPressed: () async {
                                            Navigator.pop(context);
                                            setState(() {
                                              name = data.name;
                                            });
                                            getRigeon(data.id.toString());
                                          },
                                          child: Text(
                                            data.name,
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                            textAlign: TextAlign.end,
                                          ),
                                        )
                                      ]),
                                ]);
                          },
                          itemCount: snapshot.data!.length,
                        );
                      } else if (snapshot.hasError) {
                        return Text('Error :${snapshot.error}');
                      }
                      return Container(
                          height: 50,
                          width: 50,
                          child: CircularProgressIndicator());
                    })
              ]),
            ));
  }

  void openModal3() {
    policy = fetchPlicey();
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (ctx) => _showModalBottomSheet2());
  }

  Widget _showModalBottomSheet2() => DraggableScrollableSheet(
        expand: false,
        key: UniqueKey(),
        initialChildSize: 0.8,
        maxChildSize: 0.9,
        minChildSize: .5,
        builder: (context, controller) => Column(
          children: [
            Container(
              margin: EdgeInsets.only(top: 20, bottom: 20),
              child: Text(
                "سياسات التطبيق ",
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
            ),
            Directionality(
              textDirection: TextDirection.rtl,
              child: Expanded(
                child: FutureBuilder<List<Policey>>(
                    future: policy,
                    builder: (context, AsyncSnapshot snapshot) {
                      if (snapshot.hasData) {
                        return ListView.builder(
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            Policey data = snapshot.data?[index];
                            return Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  //
                                  Container(
                                    margin: EdgeInsets.only(
                                        right: 15, left: 15, bottom: 5),
                                    child: Text(
                                      data.policie_description,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                      textAlign: TextAlign.start,
                                    ),
                                  ),
                                  ElevatedButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                        setState(() {
                                          isChecked = true;
                                        });
                                      },
                                      child: Text("موافق")),

                                  SizedBox(height: 60)
                                ]);
                          },
                          itemCount: snapshot.data!.length,
                        );
                      } else if (snapshot.hasError) {
                        return Text('Error :${snapshot.error}');
                      }
                      return Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  // padding: EdgeInsets.all(5),
                                  SizedBox(
                                    height: 50,
                                  ),
                                  Container(
                                      width: 40,
                                      child: CircularProgressIndicator(
                                        color: Colors.orange,
                                      )),
                                ]),
                          ]);
                    }),
              ),
            ),
          ],
        ),
      );
  Widget _showModalBottomSheet() => DraggableScrollableSheet(
        expand: false,
        key: UniqueKey(),
        initialChildSize: 0.8,
        maxChildSize: 0.9,
        minChildSize: .5,
        builder: (context, controller) => Column(
          children: [
            Container(
              margin: EdgeInsets.only(top: 20, bottom: 20),
              child: Text(
                "اختر مكانك بالتحديد ",
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(
              child: FutureBuilder<List<Reagion>>(
                  future: region,
                  builder: (context, AsyncSnapshot snapshot) {
                    if (snapshot.hasData) {
                      return ListView.builder(
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          Reagion data = snapshot.data?[index];
                          return Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      // padding: EdgeInsets.all(5),

                                      Container(
                                        width: 300,
                                        child: TextButton(
                                          onPressed: () async {
                                            Navigator.pop(context);
                                            setState(() {
                                              nameRe = data.nameRe;
                                            });
                                          },
                                          child: Text(
                                            data.nameRe,
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 60)
                                    ]),
                                SizedBox(width: 40)
                              ]);
                        },
                        itemCount: snapshot.data!.length,
                      );
                    } else if (snapshot.hasError) {
                      return Text('Error :${snapshot.error}');
                    }
                    return Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // padding: EdgeInsets.all(5),
                                SizedBox(
                                  height: 50,
                                ),
                                Container(
                                    width: 50,
                                    child: CircularProgressIndicator(
                                      color: Colors.orange,
                                    )),
                              ]),
                        ]);
                  }),
            ),
          ],
        ),
      );

  void openModal2() {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (ctx) => _showModalBottomSheet());
  }

  @override
  void initState() {
    super.initState();

    city = fetchMainPlace();
    controller = TextEditingController();
    controller2 = TextEditingController();
    controller3 = TextEditingController();
    controller4 = TextEditingController();
  }

  void dispose() {
    controller.dispose();
    controller4.dispose();
    controller2.dispose();
    controller3.dispose();

    super.dispose();
  }

  Widget build(BuildContext context) {
    return Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
            backgroundColor: Color.fromARGB(255, 255, 253, 250),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "إنشاء حساب جديد ",
                    style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.orange),
                  ),
                  Container(
                      child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "هل لديك حساب مسبقا؟ ",
                        style: TextStyle(
                          fontSize: 15,
                          //  fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) => login()));
                        },
                        child: Text(
                          "تسجيل دخول",
                          style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              color: Colors.green),
                        ),
                      ),
                    ],
                  )),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: 10, left: 3),
                        child: Icon(Icons.person),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 10),
                        child: SizedBox(
                          width: 265,
                          child: TextField(
                            controller: controller,
                            onChanged: (String value) {
                              setState(() {
                                username = controller.text;
                              });
                            },
                            decoration: InputDecoration(
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 10.0, horizontal: 16.0),
                                fillColor: Colors.white,
                                filled: true,
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15),
                                    borderSide: BorderSide(
                                        color: const Color.fromARGB(
                                            255, 38, 37, 37),
                                        width: 2)),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(
                                        color: Colors.orange, width: 2)),
                                hintText: 'الإسم باكامل',
                                hintStyle: TextStyle(
                                    color: Color.fromARGB(255, 176, 176, 176))),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 40,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
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
                            setState(() {
                              if (controller2.text.length < 10) {
                                phone = 'e';

                                alertextphone =
                                    'يجب ادخال رقم جوالك كامل وبشكل صحيح و هو عبارة عن 10 ارقام (بالانجليزي)';
                              } else {
                                phone = controller2.text.toString();
                                alertextphone = '';
                              }
                            });
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
                                  borderSide: BorderSide(
                                      color: Colors.orange, width: 2)),
                              hintText: 'رقم الجوال',
                              hintStyle: TextStyle(
                                  color: Color.fromARGB(255, 176, 176, 176))),
                        ),
                      ),
                      SizedBox(
                        width: 36,
                      )
                    ],
                  ),
                  if (alertextphone != '')
                    Container(
                      width: 265,
                      child: Text(alertextphone,
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
                        child: SizedBox(
                          width: 265,
                          child: TextField(
                            controller: controller4,
                            onChanged: (String value) {
                              if (controller4.text.length >= 8) {
                                setState(() {
                                  alertextpass = '';
                                  password = controller4.text;
                                });
                              } else {
                                setState(() {
                                  alertextpass =
                                      'كلمة المرور يجب ان تكون من 8 خانات على الاقل';
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
                                        color: const Color.fromARGB(
                                            255, 38, 37, 37),
                                        width: 2)),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(
                                        color: Colors.orange, width: 2)),
                                hintText: 'كلمة المرور',
                                hintStyle: TextStyle(
                                    color: Color.fromARGB(255, 176, 176, 176))),
                          ),
                        ),
                      ),
                      SizedBox(width: 40)
                    ],
                  ),
                  if (alertextpass != '')
                    Container(
                      width: 265,
                      child: Text(alertextpass,
                          style: TextStyle(color: Colors.red, fontSize: 11)),
                    ),
                  SizedBox(height: 10),
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Container(
                      margin: EdgeInsets.only(left: 3),
                      child: Icon(Icons.map),
                    ),
                    Container(
                      width: 265,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: const Color.fromARGB(255, 255, 255, 255),
                          border: Border.all(
                            width: 1,
                          )),
                      child: TextButton(
                        onPressed: () {
                          openModal();
                        },
                        child: Text(name == '' ? "منطقتك الرئيسية" : name),
                      ),
                    ),
                    SizedBox(width: 40),
                  ]),
                  SizedBox(
                    height: 10,
                  ),
                  if (name != '')
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          margin: EdgeInsets.only(left: 3),
                          child: Icon(Icons.place),
                        ),
                        Container(
                          width: 265,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: const Color.fromARGB(255, 255, 255, 255),
                              border: Border.all(
                                width: 1,
                              )),
                          child: TextButton(
                            onPressed: () {
                              openModal2();
                            },
                            child: Text(nameRe == ''
                                ? "اضغط لاختيار منطقتك التفصيلية(يعتمدعليها سعر التوصيل)"
                                : nameRe),
                          ),
                        ),
                        SizedBox(width: 40)
                      ],
                    ),
                  SizedBox(height: 10),
                  if (name != '')
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                            margin: EdgeInsets.only(left: 3),
                            child: Checkbox(
                              value: isChecked,
                              activeColor: Colors.green,
                              onChanged: (newBool) {
                                setState(() {
                                  isChecked = newBool;
                                });
                              },
                            )),
                        Container(
                          //width: 265,
                          margin: EdgeInsets.only(),
                          child: TextButton(
                            onPressed: () {
                              openModal3();
                            },
                            child: Text(
                              "الموافقة على سياسة الاستخدام",
                              style: TextStyle(
                                  color: isChecked == true
                                      ? Colors.green
                                      : Colors.black),
                            ),
                          ),
                        ),
                        SizedBox(width: 40),
                      ],
                    ),
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
                          margin: EdgeInsets.only(top: 10),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: username != '' &&
                                      (phone != '' && phone != 'e') &&
                                      (password != '' && alertextpass == '') &&
                                      name != '' &&
                                      nameRe != '' &&
                                      isChecked != false
                                  ? Colors.green
                                  : Colors.grey,
                            ),
                            onPressed: () {
                              setState(() {});
                              create();
                            },
                            child: Text(
                              "اضغط للمتابعة",
                              style: TextStyle(
                                  color:
                                      const Color.fromARGB(255, 255, 255, 255),
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                ],
              ),
            )));
  }
}
