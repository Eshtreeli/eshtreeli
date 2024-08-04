import 'package:eshtreeli_flutter/provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class Profile extends StatefulWidget {
  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  List Places = [];
  String location_Name = '';
  var loc_id;
  var Id;
  String msg = '';
  String userphone = '';
  String username = '';
  String points = '';
  String dept = '';
  bool isloading = false;
  Future getPlaces() async {
    setState(() {
      isloading = true;
    });
    final response = await http.post(
      Uri.parse('https://e-shtreeli.com/api/get_region'),
      headers: <String, String>{'Content-Type': 'application/json'},
      body: jsonEncode(<String, dynamic>{
        'id': 0,
      }),
    );

    if (response.statusCode == 200) {
      setState(() {
        Places = jsonDecode(response.body)['data'];
        setState(() {
          isloading = false;
        });
        Places.forEach((item) {
          if (item['Id'] == loc_id) {
            location_Name = item['Name'];
          }
        });
      });
    } else {
      setState(() {
        isloading = false;
      });

      throw Exception('فنكشن الحذف لا يعمل');
    }
  }

  getuser() async {
    final response = await http.post(
      Uri.parse('https://e-shtreeli.com/api/get_user'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'id': localStorage.getItem('id'),
      }),
    );

    if (response.statusCode == 200) {
      getPlaces();
      setState(() {
        username = jsonDecode(response.body)['data']['customers_name'];
        userphone = jsonDecode(response.body)['data']['customers_mobile'];
        loc_id =
            jsonDecode(response.body)['data']['customers_governorates_user'];
        points = jsonDecode(response.body)['data']['customer_my_point'];
        dept = jsonDecode(response.body)['data']['customer_debt_number'];
      });
    } else {
      throw Exception('error');
    }
  }

  openAlert() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    'تمام',
                    textAlign: TextAlign.center,
                  )),
            ],
          ),
        ],
        title: Text("!تنبيه",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
        contentPadding: EdgeInsets.all(5),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(msg, textAlign: TextAlign.center, style: TextStyle()),
            SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }

  ChangePointToPrice() async {
    setState(() {
      isloading = true;
    });
    final response = await http.post(
      Uri.parse('https://e-shtreeli.com/api/change_point_to_price'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'id': localStorage.getItem('id'),
      }),
    );

    if (response.statusCode == 200) {
      if (jsonDecode(response.body)['data'] == 'true') {
        getuser();
        setState(() {
          isloading = false;
        });
      } else {
        setState(() {
          isloading = false;
          msg = 'عدد النقاط غير كافية للتحويل ';
        });
        openAlert();
      }
    } else {
      throw Exception('فنكشن النقاط لا يعمل');
    }
  }

  Future savePlace() async {
    setState(() {
      isloading = true;
    });
    final response = await http.post(
      Uri.parse('https://e-shtreeli.com/api/change_lcation'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'id': localStorage.getItem('id'),
        'location': loc_id,
      }),
    );

    if (response.statusCode == 200) {
      localStorage.setItem('Id', loc_id.toString());
      getPlaces();
      setState(() {});
    } else {
      throw Exception('فنكشن الحذف لا يعمل');
    }
  }

  void openModalPlace() {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            final provider = Provider.of<HomeProvider>(context, listen: false);
            return Directionality(
                textDirection: TextDirection.rtl,
                child: Container(
                  width: double.infinity,
                  child: Column(children: [
                    Container(
                      margin: EdgeInsets.only(top: 20),
                      child: Text(
                        "اختر موقعك الاساسي للطلب",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                          itemCount: Places.length,
                          itemBuilder: (BuildContext context, int index) {
                            return InkWell(
                              onTap: () {
                                setState(() {
                                  loc_id = Places[index]['Id'];
                                });
                                savePlace();
                                String n = 'x';
                                provider.updateSomeValue(n);
                                Navigator.pop(context);
                              },
                              child: Container(
                                  margin: EdgeInsets.only(bottom: 10),
                                  alignment: Alignment.center,
                                  child: Text(Places[index]['Name'])),
                            );
                          }),
                    )
                  ]),
                ));
          });
        });
  }

  @override
  void initState() {
    setState(() {});
    getuser();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Container(
          alignment: Alignment.center,
          child: Text("الملف الشخصي",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
        ),
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: Column(
          children: [
            Divider(),
            ListTile(
                leading: Text("اسم المستخدم",
                    textAlign: TextAlign.center,
                    style:
                        TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                trailing: Text(username,
                    textAlign: TextAlign.center,
                    style:
                        TextStyle(fontSize: 15, fontWeight: FontWeight.bold))),
            Divider(),
            ListTile(
              leading: Text("رقم الجوال",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
              trailing: Text(userphone,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
            ),
            Divider(),
            if (isloading == false)
              InkWell(
                onTap: () {
                  openModalPlace();
                },
                child: ListTile(
                  leading: Text("المنطقة",
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                  trailing: Container(
                    width: 200,
                    child: Text(location_Name,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold)),
                  ),
                ),
              )
            else
              SizedBox(
                child: CircularProgressIndicator(),
              ),
            Divider(),
            ListTile(
                leading: Text("النقاط",
                    textAlign: TextAlign.center,
                    style:
                        TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                trailing: Text(points,
                    textAlign: TextAlign.center,
                    style:
                        TextStyle(fontSize: 15, fontWeight: FontWeight.bold))),
            Divider(),
            ListTile(
                leading: Text("الرصيد",
                    textAlign: TextAlign.center,
                    style:
                        TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                trailing: Text(dept,
                    textAlign: TextAlign.center,
                    style:
                        TextStyle(fontSize: 15, fontWeight: FontWeight.bold))),
            Divider(),
            if (isloading == false)
              InkWell(
                onTap: () {
                  ChangePointToPrice();
                },
                child: ListTile(
                  title: Text("اضغط لتحويل النقاط الى رصيد",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 17,
                          color: Colors.red,
                          fontWeight: FontWeight.bold)),
                ),
              )
            else
              SizedBox(child: CircularProgressIndicator()),
          ],
        ),
      ),
    );
  }
}
