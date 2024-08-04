import 'package:eshtreeli_flutter/orders.dart';
import 'package:eshtreeli_flutter/policy.dart';
import 'package:eshtreeli_flutter/profile.dart';
import 'package:eshtreeli_flutter/provider.dart';
import 'package:eshtreeli_flutter/signup.dart';
import 'package:eshtreeli_flutter/spinner.dart';
import 'package:eshtreeli_flutter/uncomplishedorders.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:localstorage/localstorage.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:location/location.dart';
import 'package:provider/provider.dart';

class cart extends StatefulWidget {
  const cart({super.key});

  @override
  State<cart> createState() => _cartState();
}

class _cartState extends State<cart> {
  Future _determinePosition() async {
    Location location = new Location();

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    _locationData = await location.getLocation();
    setState(() {
      order_latitude = _locationData.longitude;
      order_longitude = _locationData.latitude;
    });
  }

  openAlertConfirmTime() {
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

  openAlertConfirm() {
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
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => orders()));
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

  openAlertsetRegion() {
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
                    openModal();
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

  openAlertTime() {
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
                    if (time.length > 0) {
                      openModalTime();
                    }
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
                    setState(() {
                      save_location = true;
                    });

                    confirmOrder();

                    Navigator.pop(context);
                  },
                  child: Text(
                    'تمام',
                    textAlign: TextAlign.center,
                  )),
              SizedBox(
                width: 20,
              ),
              ElevatedButton(
                onPressed: () {
                  confirmOrder();
                  Navigator.pop(context);
                },
                child: Text(
                  'لا',
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ],
        title: Text("!تنبيه",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
        contentPadding: EdgeInsets.all(5),
        content: Text(msg, textAlign: TextAlign.center, style: TextStyle()),
      ),
    );
  }

  openAlertCopun() {
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
              SizedBox(
                width: 20,
              ),
            ],
          ),
        ],
        title: Text("!تنبيه",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
        contentPadding: EdgeInsets.all(5),
        content: Column(
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

  late TextEditingController controller;
  late TextEditingController controller1;
  late TextEditingController controller2;
  late TextEditingController controller3;
  late TextEditingController controller4;
  List data = [];
  List Places = [];
  List time = [];
  String location_Name = ' ';
  var del;
  String msg = '';
  String name = '';
  String note = ' ';
  var code = '';
  String region = '';
  String street = '';
  var Id;
  String building = '';
  String home = '';
  int sum_first = 0;
  var delivery_price;
  int sum = 0;
  bool save_location = false;
  int sum_discount = 0;
  var order_longitude;
  var order_latitude;
  String time_delivery = '';
  int price_service = 0;
  String dept = '0';
  var data_false = '';
  var cartAdminNote;
  var cartAdminNoteIstelam;
  bool choose = true;
  bool isloading = false;
  void openModal() {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            return Directionality(
              textDirection: TextDirection.rtl,
              child: Container(
                  height: MediaQuery.of(context).size.height - 50,
                  width: double.infinity,
                  child: Column(
                    children: [
                      SizedBox(
                        height: 5,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        height: 70,
                        width: 265,
                        child: Directionality(
                          textDirection: TextDirection.rtl,
                          child: TextField(
                            controller: controller,
                            onSubmitted: (String value) {
                              setState(() {
                                note = controller.text.toString();
                              });
                            },
                            onChanged: (String value) {
                              setState(() {
                                note = controller.text.toString();
                              });
                            },
                            decoration: InputDecoration(
                                contentPadding:
                                    EdgeInsets.symmetric(vertical: 40.0),
                                fillColor: Colors.white,
                                filled: true,
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(
                                        color:
                                            Color.fromARGB(255, 214, 211, 211),
                                        width: 1)),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    borderSide: BorderSide(
                                        color: Colors.green, width: 2)),
                                hintText: ' ضع ملاحظاتك بخصوص الطلب',
                                hintStyle: TextStyle(
                                    fontSize: 12,
                                    color: Color.fromARGB(255, 176, 176, 176))),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      if (choose)
                        SizedBox(
                          height: 40,
                          width: 250,
                          child: Directionality(
                            textDirection: TextDirection.rtl,
                            child: TextField(
                              textAlignVertical: TextAlignVertical.bottom,
                              controller: controller3..text = region,
                              onSubmitted: (String value) {
                                setState(() {
                                  region = controller3.text.toString();
                                });
                              },
                              onChanged: (String value) {
                                setState(() {
                                  region = controller3.text.toString();
                                });
                              },
                              decoration: InputDecoration(
                                contentPadding:
                                    EdgeInsets.symmetric(vertical: 40.0),
                                fillColor: Colors.white,
                                filled: true,
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5),
                                    borderSide: BorderSide(
                                        color:
                                            Color.fromARGB(255, 214, 211, 211),
                                        width: 1)),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(
                                        color: Colors.green, width: 2)),
                                hintText: 'المنطقة الأساسية التي تتواجد بها',
                                hintStyle: TextStyle(
                                    fontSize: 12,
                                    color: Color.fromARGB(255, 176, 176, 176)),
                              ),
                            ),
                          ),
                        ),
                      if (choose)
                        SizedBox(
                          height: 20,
                        ),
                      if (choose)
                        SizedBox(
                          height: 40,
                          width: 250,
                          child: Directionality(
                            textDirection: TextDirection.rtl,
                            child: TextField(
                              textAlignVertical: TextAlignVertical.bottom,
                              controller: controller2..text = street,
                              onSubmitted: (String value) {
                                setState(() {
                                  street = controller2.text.toString();
                                });
                              },
                              onChanged: (String value) {
                                setState(() {
                                  street = controller2.text.toString();
                                });
                              },
                              decoration: InputDecoration(
                                contentPadding:
                                    EdgeInsets.symmetric(vertical: 40.0),
                                fillColor: Colors.white,
                                filled: true,
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5),
                                    borderSide: BorderSide(
                                        color:
                                            Color.fromARGB(255, 214, 211, 211),
                                        width: 1)),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(
                                        color: Colors.green, width: 2)),
                                hintText: 'اي معلومات اخرى مثل الحي، الشارع',
                                hintStyle: TextStyle(
                                    fontSize: 12,
                                    color: Color.fromARGB(255, 176, 176, 176)),
                              ),
                            ),
                          ),
                        ),
                      if (choose)
                        SizedBox(
                          height: 20,
                        ),
                      if (choose)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              alignment: Alignment.center,
                              width: 80,
                              height: 35,
                              decoration: BoxDecoration(
                                  color: isloading || code == ''
                                      ? const Color.fromARGB(255, 167, 164, 164)
                                      : Colors.orange,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5))),
                              child: InkWell(
                                onTap: () {
                                  setState(() {
                                    if (code != '') {
                                      setCopun();
                                      Navigator.pop(context);
                                    }
                                  });
                                },
                                child: Text("تفعيل الكود",
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13,
                                      color: Colors.white,
                                    )),
                              ),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            SizedBox(
                              height: 40,
                              width: 150,
                              child: Directionality(
                                textDirection: TextDirection.rtl,
                                child: TextField(
                                  textAlignVertical: TextAlignVertical.bottom,
                                  controller: controller1,
                                  onSubmitted: (String value) {
                                    setState(() {
                                      code = controller1.text.toString();
                                    });
                                  },
                                  onChanged: (String value) {
                                    setState(() {
                                      code = controller1.text.toString();
                                    });
                                  },
                                  decoration: InputDecoration(
                                    contentPadding:
                                        EdgeInsets.symmetric(vertical: 40.0),
                                    fillColor: Colors.white,
                                    filled: true,
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(5),
                                        borderSide: BorderSide(
                                            color: Color.fromARGB(
                                                255, 214, 211, 211),
                                            width: 1)),
                                    focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: BorderSide(
                                            color: Colors.green, width: 2)),
                                    hintText: ' ادخل كود الخصم(ان وجد)',
                                    hintStyle: TextStyle(
                                        fontSize: 12,
                                        color:
                                            Color.fromARGB(255, 176, 176, 176)),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        height: 40,
                        width: 250,
                        child: Directionality(
                          textDirection: TextDirection.rtl,
                          child: TextField(
                            textAlignVertical: TextAlignVertical.bottom,
                            controller: controller4..text = name,
                            onSubmitted: (String value) {
                              setState(() {
                                name = controller4.text.toString();
                              });
                            },
                            onChanged: (String value) {
                              setState(() {
                                name = controller4.text.toString();
                              });
                            },
                            decoration: InputDecoration(
                              contentPadding:
                                  EdgeInsets.symmetric(vertical: 40.0),
                              fillColor: Colors.white,
                              filled: true,
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5),
                                  borderSide: BorderSide(
                                      color: Color.fromARGB(255, 214, 211, 211),
                                      width: 1)),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                      color: Colors.green, width: 2)),
                              hintText: 'ضع رقم جوال اخر احتياطا(اختياري)',
                              hintStyle: TextStyle(
                                  fontSize: 12,
                                  color: Color.fromARGB(255, 176, 176, 176)),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Expanded(
                        child: ListView(
                            children:
                                ListTile.divideTiles(context: context, tiles: [
                          ListTile(
                            leading: Text(
                              'مجموع المشتريات',
                              style: TextStyle(
                                  color:
                                      const Color.fromARGB(255, 154, 154, 154),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14),
                              textAlign: TextAlign.center,
                            ),
                            trailing: Text(
                              sum_first.toString(),
                              style: TextStyle(
                                  color: const Color.fromARGB(255, 46, 46, 46),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          ListTile(
                            leading: Text(
                              'رسوم التوصيل',
                              style: TextStyle(
                                  color:
                                      const Color.fromARGB(255, 154, 154, 154),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14),
                              textAlign: TextAlign.center,
                            ),
                            trailing: Text(
                              delivery_price.toString(),
                              style: TextStyle(
                                  color: const Color.fromARGB(255, 46, 46, 46),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          ListTile(
                            leading: Text(
                              'رسوم الخدمة',
                              style: TextStyle(
                                  color:
                                      const Color.fromARGB(255, 154, 154, 154),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14),
                              textAlign: TextAlign.center,
                            ),
                            trailing: Text(
                              price_service.toString(),
                              style: TextStyle(
                                  color: const Color.fromARGB(255, 46, 46, 46),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          ListTile(
                            leading: Text(
                              'الرصيد',
                              style: TextStyle(
                                  color:
                                      const Color.fromARGB(255, 154, 154, 154),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14),
                              textAlign: TextAlign.center,
                            ),
                            trailing: Text(
                              dept.toString(),
                              style: TextStyle(
                                  color: const Color.fromARGB(255, 46, 46, 46),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          ListTile(
                            leading: Text(
                              'الخصم',
                              style: TextStyle(
                                  color:
                                      const Color.fromARGB(255, 154, 154, 154),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14),
                              textAlign: TextAlign.center,
                            ),
                            trailing: Text(
                              sum_discount.toString(),
                              style: TextStyle(
                                  color: const Color.fromARGB(255, 46, 46, 46),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          ListTile(
                              visualDensity: VisualDensity(vertical: -3), // to

                              leading: Text(
                                'المجموع',
                                style: TextStyle(
                                    color: const Color.fromARGB(
                                        255, 154, 154, 154),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14),
                                textAlign: TextAlign.center,
                              ),
                              title: sum_discount > 0
                                  ? Text(
                                      (sum - sum_discount).toString() + "₪",
                                      style: TextStyle(
                                          color: Color.fromARGB(255, 255, 1, 1),
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14),
                                      textAlign: TextAlign.end,
                                    )
                                  : null,
                              trailing: Text(
                                sum.toString() + "₪",
                                style: TextStyle(
                                    decoration: sum_discount > 0
                                        ? TextDecoration.lineThrough
                                        : TextDecoration.none,
                                    color:
                                        const Color.fromARGB(255, 46, 46, 46),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14),
                                textAlign: TextAlign.center,
                              )),
                          ListTile(
                              leading: Text(
                                'وقت التسليم',
                                style: TextStyle(
                                    color: Colors.green,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14),
                                textAlign: TextAlign.center,
                              ),
                              trailing: SizedBox(
                                height: 40,
                                width: 200,
                                child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color.fromARGB(
                                          255, 255, 255, 255),
                                    ),
                                    onPressed: () async {
                                      getTime();
                                      // Navigator.pop(context);
                                      openModalTime();
                                    },
                                    child: Text(
                                      time_delivery == ''
                                          ? 'قائمة اوقات التسليم'
                                          : time_delivery,
                                      style: TextStyle(
                                          color: Colors.orange,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14),
                                      textAlign: TextAlign.center,
                                    )),
                              ))
                        ]).toList()),
                      ),
                    ],
                  )),
            );
          });
        });
  }

  Future confirmOrder() async {
    setState(() {
      isloading = true;
    });

    final response = await http.post(
      Uri.parse('https://e-shtreeli.com/api/add_order'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'name_order_form_mobile': name != '' ? name : ' ',
        'order_name_customer_location_reagion': region,
        'order_name_customer_location_street': street,
        'order_name_customer_location_building': building,
        'order_name_customer_location_home': home,
        'id_user': localStorage.getItem('id'),
        'order_name_note': note,
        'order_sum_first': sum_first,
        'order_delivery_price': delivery_price,
        'order_sum': sum,
        'save_location': save_location,
        'sum_discount': sum_discount,
        'order_longitude': order_longitude,
        'order_latitude': order_latitude,
        'time_delivery': time_delivery,
        'price_service': price_service,
        'dept': dept,
        'code': code
      }),
    );

    if (response.statusCode == 200) {
      if (jsonDecode(response.body)['data_false'] ==
          'لا يمكنك اضافة طلبية جديدة , يرجى تأكيد طلبيتك السابقة') {
        setState(() {
          isloading = false;
          msg = 'يرجى تأكيد استلام طلبيتك السابقة ';
          openAlertConfirm();
        });
      } else {
        var a = 0;
        final provider = Provider.of<HomeProvider>(context, listen: false);
        provider.DeleteCart(a);
//isloading = false;
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => orders()));
      }
    } else {
      throw Exception('فنكشن الطلب لا يعمل');
    }
  }

  Future getCart() async {
    setState(() {
      name = '';
      isloading = true;
    });
    final response = await http.post(
      Uri.parse('https://e-shtreeli.com/api/get_cart'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'id': localStorage.getItem('id'),
      }),
    );

    if (response.statusCode == 200) {
      print('كاااااارت جبناها');

      setState(() {
        isloading = false;
      });
      if (jsonDecode(response.body)['data'] != null) {
        setState(() {
          delivery_price = jsonDecode(response.body)['delivery_price'];
        });
        setState(() {
          cartAdminNote = jsonDecode(response.body)['delivey_time'];
        });
        setState(() {
          cartAdminNoteIstelam = jsonDecode(response.body)['istlam_note'];
        });

        setState(() {
          data = jsonDecode(response.body)['data'];
          sum_first = jsonDecode(response.body)['sum_first'] != null
              ? jsonDecode(response.body)['sum_first']
              : 0;
        });
        setState(() {
          sum = jsonDecode(response.body)['sum'] != null
              ? jsonDecode(response.body)['sum']
              : 0;
        });

        setState(() {
          sum_discount = jsonDecode(response.body)['sum_discount'] != null
              ? jsonDecode(response.body)['sum_discount']
              : 0;
        });
        setState(() {
          order_longitude = jsonDecode(response.body)['order_longitude'] != null
              ? jsonDecode(response.body)['order_longitude']
              : 0;
        });

        setState(() {
          order_latitude = jsonDecode(response.body)['order_latitude'] != null
              ? jsonDecode(response.body)['order_latitude']
              : 0;
        });
        setState(() {
          time_delivery = jsonDecode(response.body)['time_delivery'];
        });
        setState(() {
          price_service = jsonDecode(response.body)['price_service'] != null
              ? jsonDecode(response.body)['price_service']
              : 0;
        });

        setState(() {
          dept = jsonDecode(response.body)['dept'] != null
              ? jsonDecode(response.body)['dept']
              : 0;
        });
        setState(() {
          code = jsonDecode(response.body)['code'] != null
              ? jsonDecode(response.body)['code']
              : '';
        });
      } else {
        setState(() {
          isloading = false;
        });
        var a = 0;
        final provider = Provider.of<HomeProvider>(context, listen: false);
        provider.DeleteCart(a);
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => Policy()));
      }
    } else {
      var a = 0;
      final provider = Provider.of<HomeProvider>(context, listen: false);
      provider.DeleteCart(a);
      print('لم نجيب كارت');

      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => Policy()));
      setState(() {
        isloading = false;
      });

      throw Exception('فنكشن السلة لا يعمل');
    }
  }

  Future decreaseItem(dec) async {
    setState(() {
      isloading = true;
    });
    final response = await http.post(
      Uri.parse('https://e-shtreeli.com/api/derease_item'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'id': localStorage.getItem('id'), 'id_increase': dec}),
    );

    if (response.statusCode == 200) {
      setState(() {
        data = jsonDecode(response.body)['data'];
        sum_first = jsonDecode(response.body)['sum_first'];
        sum = jsonDecode(response.body)['sum'];

        sum_discount = jsonDecode(response.body)['sum_discount'] != null
            ? jsonDecode(response.body)['sum_discount']
            : 0;
        order_longitude = jsonDecode(response.body)['order_longitude'] != null
            ? jsonDecode(response.body)['order_longitude']
            : 32;
        order_latitude = jsonDecode(response.body)['order_latitude'] != null
            ? jsonDecode(response.body)['order_latitude']
            : 32;
        time_delivery = jsonDecode(response.body)['time_delivery'];

        price_service = jsonDecode(response.body)['price_service'];
        delivery_price = jsonDecode(response.body)['delivery_price'];
        dept = jsonDecode(response.body)['dept'] != null
            ? jsonDecode(response.body)['dept']
            : 0;
        code = jsonDecode(response.body)['code'] != null
            ? jsonDecode(response.body)['code']
            : '';
      });
      setState(() {
        isloading = false;
      });
      //print(data);
    } else {
      setState(() {
        isloading = false;
      });
      throw Exception('فنكشن السلة لا يعمل');
    }
  }

  void openModalPlace() {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
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
                                  region = Places[index]['Name'].toString();
                                  Id = Places[index]['Id'];
                                  street = '';
                                });
                                final provider = Provider.of<HomeProvider>(
                                    context,
                                    listen: false);
                                String n = 'x';
                                provider.updateSomeValue(n);
                                savePlace();

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

  void openModalTime() {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            return Directionality(
                textDirection: TextDirection.rtl,
                child: Container(
                  height: MediaQuery.of(context).size.height - 120,
                  width: double.infinity,
                  child: Column(children: [
                    Container(
                      margin: EdgeInsets.only(top: 20, bottom: 20),
                      child: Text(
                        "اختر  وقت استلام الطلب",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    if (time.length > 0)
                      Expanded(
                        child: ListView.builder(
                            itemCount: time.length,
                            itemBuilder: (BuildContext context, int index) {
                              return InkWell(
                                onTap: () {
                                  setState(() {
                                    time_delivery =
                                        time[index]['label'].toString();
                                    msg =
                                        '   وقت توصيل الطلبية هو : ${time_delivery} تمام؟';

                                    Navigator.pop(context);
                                  });
                                  openAlertConfirmTime();
                                },
                                child: Container(
                                    margin: EdgeInsets.only(
                                      bottom: 10,
                                    ),
                                    alignment: Alignment.center,
                                    child: Text(time[index]['label'])),
                              );
                            }),
                      )
                    else
                      Container(
                          margin: EdgeInsets.only(
                            bottom: 10,
                          ),
                          alignment: Alignment.center,
                          child: Text("لا يوجد اوقات متاحة للاختيار")),
                  ]),
                ));
          });
        });
  }

  Future deleteItem() async {
    setState(() {
      isloading = true;
    });
    final response = await http.post(
      Uri.parse('https://e-shtreeli.com/api/delete_cart'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'id_cart': del, 'id': localStorage.getItem('id')}),
    );

    if (response.statusCode == 200) {
      setState(() {
        data = jsonDecode(response.body)['success'];
        isloading = false;
      });
      if (data.length == 0) {
        Navigator.pop(context);
        //localStorage.setItem('cartvalue', '0');
        String n = 'a';

        var a = 0;
        final provider = Provider.of<HomeProvider>(context, listen: false);
        provider.DeleteCart(a);
        provider.updateSomeValue(n);
      } else {
        final pp = Provider.of<HomeProvider>(context, listen: false);
        pp.updateCart();
      }
    } else {
      setState(() {
        isloading = false;
      });

      throw Exception('فنكشن الحذف لا يعمل');
    }
  }

  Future getTime() async {
    setState(() {});
    final response = await http.post(
      Uri.parse('https://e-shtreeli.com/api/get_time_avilable'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'id_user': localStorage.getItem('id')}),
    );

    if (response.statusCode == 200) {
      setState(() {
        time = jsonDecode(response.body)['data'];
        //isloading = false;
      });
    } else {
      setState(() {});

      throw Exception('فنكشن الحذف لا يعمل');
    }
  }

  Future getPlaces() async {
    setState(() {
      //   isloading = true;
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

        Places.forEach((item) {
          if (item['Id'] == int.parse(Id)) {
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

  Future savePlace() async {
    setState(() {
      isloading = true;
    });
    final response = await http.post(
      Uri.parse('https://e-shtreeli.com/api/change_lcation'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'id': localStorage.getItem('id'),
        'location': Id,
      }),
    );

    if (response.statusCode == 200) {
      setState(() {
        Id = jsonDecode(response.body)['data']['customers_governorates_user']
            .toString();
      });

      localStorage.setItem(
          'Id',
          jsonDecode(response.body)['data']['customers_governorates_user']
              .toString());

      getPlaces();
      getCart();
    } else {
      throw Exception('فنكشن تغيير المكان لا يعمل');
    }
  }

  Future setCopun() async {
    setState(() {
      isloading = true;
    });
    final response = await http.post(
      Uri.parse('https://e-shtreeli.com/api/check_code_copuns'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'code': code,
        'sum': sum,
        'id_user': localStorage.getItem('id'),
      }),
    );

    if (response.statusCode == 200) {
      if (jsonDecode(response.body)['success'] == 'true') {
        openAlertCopun();
        setState(() {
          //  data = jsonDecode(response.body);
          msg = 'تمت اضافة الكود بنجاح';
          isloading = false;
          sum_discount = jsonDecode(response.body)['data'];
        });
      }
      if (jsonDecode(response.body)['data_false'] == 'الكود غير صالح') {
        openAlertCopun();
        setState(() {
          //  data = jsonDecode(response.body);
          msg = jsonDecode(response.body)['data_false'];
          isloading = false;
        });
      }
      if (jsonDecode(response.body)['data_false_expire'] ==
          'انتهت صلاحية الكود') {
        openAlertCopun();
        setState(() {
          msg = jsonDecode(response.body)['data_false_expire'];
          isloading = false;
        });
      }
      if (jsonDecode(response.body)['success'] == 'false_categires') {
        openAlertCopun();
        setState(() {
          msg = 'هذا الكوبون غير صالح للمتجر المضاف في السلة';
          isloading = false;
        });
      }
    } else {
      setState(() {
        isloading = false;
      });

      throw Exception('فنكشن الحذف لا يعمل');
    }
  }

  Future CheckLocationChange() async {
    setState(() {
      isloading = true;
    });
    final response = await http.post(
      Uri.parse('https://e-shtreeli.com/api/check_location_change'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'id_user': localStorage.getItem('id'),
        'customer_reagion': region,
        'customer_street': street,
        'customer_building': building,
        'customer_home': home,
      }),
    );

    if (response.statusCode == 200) {
      if (jsonDecode(response.body)['success'] == 'true') {
        setState(() {
          openAlert();
          msg = 'هل تريد حفظ عنوانك الجديد؟';
          isloading = false;
        });
      } else {
        confirmOrder();
      }
    } else {
      //getCart();
      setState(() {
        isloading = false;
      });

      throw Exception('فنكشن الحذف لا يعمل');
    }
  }

  Future increaseItem(inc) async {
    setState(() {
      isloading = true;
    });
    final response = await http.post(
      Uri.parse('https://e-shtreeli.com/api/increase_item'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'id': localStorage.getItem('id'), 'id_increase': inc}),
    );

    if (response.statusCode == 200) {
      setState(() {
        isloading = false;

        data = jsonDecode(response.body)['data'];
        sum_first = jsonDecode(response.body)['sum_first'];
        sum = jsonDecode(response.body)['sum'];

        sum_discount = jsonDecode(response.body)['sum_discount'] != null
            ? jsonDecode(response.body)['sum_discount']
            : 0;
        order_longitude = jsonDecode(response.body)['order_longitude'] != null
            ? jsonDecode(response.body)['order_longitude']
            : 32;
        order_latitude = jsonDecode(response.body)['order_latitude'] != null
            ? jsonDecode(response.body)['order_latitude']
            : 32;
        time_delivery = jsonDecode(response.body)['time_delivery'];
        price_service = jsonDecode(response.body)['price_service'];
        delivery_price = jsonDecode(response.body)['delivery_price'];
        dept = jsonDecode(response.body)['dept'] != null
            ? jsonDecode(response.body)['dept']
            : 0;
        code = jsonDecode(response.body)['code'] != null
            ? jsonDecode(response.body)['code']
            : '';
      });

      //print(data);
    } else {
      setState(() {
        isloading = false;
      });
      throw Exception('فنكشن السلة لا يعمل');
    }
  }

  @override
  void initState() {
    super.initState();
    _determinePosition();

    controller = TextEditingController();
    controller1 = TextEditingController();
    controller2 = TextEditingController();
    controller3 = TextEditingController();
    controller4 = TextEditingController();
    getTime();
    setState(() {
      region = localStorage.getItem('region').toString() != 'null'
          ? localStorage.getItem('region').toString()
          : '';
      street = localStorage.getItem('street').toString() != 'null'
          ? localStorage.getItem('street').toString()
          : '';
      Id = localStorage.getItem('Id').toString();
      ;
    });
    getPlaces();
    getCart();
  }

  void dispose() {
    controller.dispose();
    controller1.dispose();

    super.dispose();
  }

  orderNow() {
    if (time.length > 0) {
      setState(() {
        time_delivery = 'اقرب وقت ممكن';
      });
      if (!choose) {
        confirmOrder();
      } else {
        if (region != '' && street != '') {
          CheckLocationChange();
        } else {
          setState(() {
            msg = 'الرجاء ملء الخانات الخاصة بمنطقة طلبك ';
          });
          openAlertsetRegion();
        }
      }
    } else {
      openAlertTime();
      setState(() {
        msg = 'للاسف لا يمكنك الطلب ، لا يوجد اوقات متاحة للتسليم';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 230, 230, 230),
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Container(
                alignment: Alignment.center,
                width: 80,
                height: 35,
                decoration: BoxDecoration(
                    color: choose ? Colors.white : Colors.orange,
                    border: Border.all(
                        width: 1, color: choose ? Colors.orange : Colors.white),
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        bottomLeft: Radius.circular(10))),
                child: InkWell(
                  onTap: () {
                    setState(() {
                      choose = false;
                      if (!choose) {
                        setState(() {
                          name = 'استلام';
                          sum_discount = 0;
                          delivery_price = 0;
                          save_location = false;
                          order_latitude = null;
                          order_longitude = null;
                          time_delivery = 'استلام الان';
                          price_service = 0;
                          sum = 0;
                        });
                      }
                    });
                  },
                  child: Text("استلام",
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: choose ? Colors.orange : Colors.white,
                      )),
                ),
              ),
            ),
            Container(
              alignment: Alignment.center,
              width: 80,
              height: 35,
              decoration: BoxDecoration(
                  border: Border.all(
                      width: 1, color: choose ? Colors.white : Colors.orange),
                  color: choose ? Colors.orange : Colors.white,
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(10),
                      bottomRight: Radius.circular(10))),
              child: InkWell(
                onTap: () {
                  if (choose) {
                    setState(() {});
                  }
                  setState(() {
                    getCart();
                    choose = true;
                  });
                  //print('توصيل');
                },
                child: Text("توصيل",
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: choose ? Colors.white : Colors.orange,
                    )),
              ),
            ),
          ],
        ),
      ),
      body: !isloading
          ? Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(top: 10),
                    child: ListView.builder(
                        itemCount: data.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Directionality(
                            textDirection: TextDirection.rtl,
                            child: Column(
                              children: [
                                Container(
                                  margin: EdgeInsets.only(
                                      bottom: 10, right: 10, left: 10),
                                  child: ListTile(
                                    minLeadingWidth: 10,
                                    contentPadding: EdgeInsets.all(5),
                                    visualDensity: VisualDensity(vertical: 1),
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20))),
                                    tileColor: const Color.fromARGB(
                                        255, 255, 255, 255),
                                    trailing: InkWell(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(5)),
                                        onTap: () async {
                                          setState(() {
                                            del = data[index]['id'];
                                          });
                                          deleteItem();
                                        },
                                        child: Icon(Icons.delete_outline)),
                                    leading: ClipRRect(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(10)),
                                      child: Image.network(
                                        data[index]['cart_image'],
                                        fit: BoxFit.cover,
                                        width: 50,
                                        height: 50,
                                      ),
                                    ),
                                    title: Transform.translate(
                                        offset: Offset(10, 2),
                                        child: Text(
                                            data[index]['cart_name_product'],
                                            textAlign: TextAlign.start,
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 12,
                                                color: const Color.fromARGB(
                                                    255, 19, 19, 19)))),
                                    subtitle: Column(
                                      children: [
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Transform.translate(
                                                offset: Offset(0, 0),
                                                child: Text(
                                                    data[index]
                                                        ['cart_mininote'],
                                                    textAlign: TextAlign.start,
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 12,
                                                        color: Color.fromARGB(
                                                            255, 243, 7, 7)))),
                                          ],
                                        ),
                                        if (data[index]['cart_adds'] != ' ')
                                          SizedBox(height: 5),
                                        if (data[index]['cart_adds'] != ' ')
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Transform.translate(
                                                  offset: Offset(0, 0),
                                                  child: Text(
                                                      data[index]['cart_adds'],
                                                      textAlign:
                                                          TextAlign.start,
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 9,
                                                          color: Color.fromARGB(
                                                              255,
                                                              48,
                                                              47,
                                                              47)))),
                                              SizedBox(width: 5),
                                              Transform.translate(
                                                  offset: Offset(0, 0),
                                                  child: Text(
                                                      data[index][
                                                              'cart_adds_unit'] +
                                                          '₪' +
                                                          '+',
                                                      textAlign:
                                                          TextAlign.start,
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 9,
                                                          color: Color.fromARGB(
                                                              255,
                                                              255,
                                                              9,
                                                              9)))),
                                            ],
                                          ),
                                        if (data[index]['cart_adds1'] != ' ')
                                          SizedBox(height: 5),
                                        if (data[index]['cart_adds1'] != ' ')
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Transform.translate(
                                                  offset: Offset(0, 0),
                                                  child: Text(
                                                      data[index]['cart_adds1'],
                                                      textAlign:
                                                          TextAlign.start,
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 9,
                                                          color: Color.fromARGB(
                                                              255,
                                                              48,
                                                              47,
                                                              47)))),
                                              SizedBox(width: 5),
                                              Transform.translate(
                                                  offset: Offset(0, 0),
                                                  child: Text(
                                                      data[index][
                                                              'cart_adds_unit1'] +
                                                          '₪' +
                                                          '+',
                                                      textAlign:
                                                          TextAlign.start,
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 9,
                                                          color: Color.fromARGB(
                                                              255,
                                                              255,
                                                              9,
                                                              9)))),
                                            ],
                                          ),
                                        if (data[index]['cart_adds2'] != ' ')
                                          SizedBox(height: 5),
                                        if (data[index]['cart_adds2'] != ' ')
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Transform.translate(
                                                  offset: Offset(0, 0),
                                                  child: Text(
                                                      data[index]['cart_adds2'],
                                                      textAlign:
                                                          TextAlign.start,
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 9,
                                                          color: Color.fromARGB(
                                                              255,
                                                              48,
                                                              47,
                                                              47)))),
                                              SizedBox(width: 5),
                                              Transform.translate(
                                                  offset: Offset(0, 0),
                                                  child: Text(
                                                      data[index][
                                                              'cart_adds_unit2'] +
                                                          '₪' +
                                                          '+',
                                                      textAlign:
                                                          TextAlign.start,
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 9,
                                                          color: Color.fromARGB(
                                                              255,
                                                              255,
                                                              9,
                                                              9)))),
                                            ],
                                          ),
                                        if (data[index]['cart_adds3'] != ' ')
                                          SizedBox(height: 5),
                                        if (data[index]['cart_adds3'] != ' ')
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Transform.translate(
                                                  offset: Offset(0, 0),
                                                  child: Text(
                                                      data[index]['cart_adds3'],
                                                      textAlign:
                                                          TextAlign.start,
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 9,
                                                          color: Color.fromARGB(
                                                              255,
                                                              48,
                                                              47,
                                                              47)))),
                                              SizedBox(width: 5),
                                              Transform.translate(
                                                  offset: Offset(0, 0),
                                                  child: Text(
                                                      data[index][
                                                              'cart_adds_unit3'] +
                                                          '₪' +
                                                          '+',
                                                      textAlign:
                                                          TextAlign.start,
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 9,
                                                          color: Color.fromARGB(
                                                              255,
                                                              255,
                                                              9,
                                                              9)))),
                                            ],
                                          ),
                                        if (data[index]['cart_adds4'] != ' ')
                                          SizedBox(height: 5),
                                        if (data[index]['cart_adds4'] != ' ')
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Transform.translate(
                                                  offset: Offset(0, 0),
                                                  child: Text(
                                                      data[index]['cart_adds4'],
                                                      textAlign:
                                                          TextAlign.start,
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 9,
                                                          color: Color.fromARGB(
                                                              255,
                                                              48,
                                                              47,
                                                              47)))),
                                              SizedBox(width: 5),
                                              Transform.translate(
                                                  offset: Offset(0, 0),
                                                  child: Text(
                                                      data[index][
                                                              'cart_adds_unit4'] +
                                                          '₪' +
                                                          '+',
                                                      textAlign:
                                                          TextAlign.start,
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 9,
                                                          color: Color.fromARGB(
                                                              255,
                                                              255,
                                                              9,
                                                              9)))),
                                            ],
                                          ),
                                        SizedBox(height: 10),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                if (double.parse(data[index]['cart_adds_unit']) + double.parse(data[index]['cart_adds_unit1']) + double.parse(data[index]['cart_adds_unit2']) + double.parse(data[index]['cart_adds_unit3']) + double.parse(data[index]['cart_adds_unit4']) >=
                                                    1)
                                                  Transform.translate(
                                                      offset: Offset(0, 1),
                                                      child: Text(
                                                          ((double.parse(data[index]['cart_adds_unit']) + double.parse(data[index]['cart_adds_unit1']) + double.parse(data[index]['cart_adds_unit2']) + double.parse(data[index]['cart_adds_unit3']) + double.parse(data[index]['cart_adds_unit4'])))
                                                                  .toStringAsFixed(
                                                                      0) +
                                                              '₪  +',
                                                          textAlign:
                                                              TextAlign.start,
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 10,
                                                              color: Color
                                                                  .fromARGB(
                                                                      255,
                                                                      0,
                                                                      161,
                                                                      0)))),
                                                SizedBox(width: 5),
                                                Transform.translate(
                                                    offset: Offset(0, 0),
                                                    child: Text(
                                                        data[index]
                                                                [
                                                                'cart_name_price'] +
                                                            '₪',
                                                        textAlign: TextAlign
                                                            .start,
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 12,
                                                            color:
                                                                Color.fromARGB(
                                                                    255,
                                                                    11,
                                                                    168,
                                                                    0)))),
                                              ],
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                InkWell(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(10)),
                                                  onTap: () {
                                                    setState(() {
                                                      var inc =
                                                          data[index]['id'];
                                                      increaseItem(inc);
                                                    });
                                                  },
                                                  child: Container(
                                                    height: 30,
                                                    width: 40,
                                                    alignment: Alignment.center,
                                                    decoration: BoxDecoration(
                                                        border: Border.all(
                                                            width: 1,
                                                            color:
                                                                Colors.green),
                                                        color: const Color
                                                            .fromARGB(
                                                            255, 255, 255, 255),
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    10))),
                                                    child: Text(
                                                      '+',
                                                      style: TextStyle(
                                                          color: Colors.green,
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                SizedBox(
                                                  child: Text(
                                                    data[index][
                                                        'cart_name_count_product'],
                                                    style: TextStyle(
                                                        color: Color.fromARGB(
                                                            255, 45, 149, 1),
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                InkWell(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(10)),
                                                  onTap: () {
                                                    if (int.parse(data[index][
                                                            'cart_name_count_product']) >
                                                        1) {
                                                      setState(() {
                                                        var dec =
                                                            data[index]['id'];
                                                        decreaseItem(dec);
                                                      });
                                                    }
                                                  },
                                                  child: Container(
                                                    height: 30,
                                                    width: 40,
                                                    alignment: Alignment.center,
                                                    decoration: BoxDecoration(
                                                        border: Border.all(
                                                          width: 1,
                                                          color: int.parse(data[
                                                                          index]
                                                                      [
                                                                      'cart_name_count_product']) >
                                                                  1
                                                              ? Color.fromARGB(
                                                                  255,
                                                                  35,
                                                                  162,
                                                                  0)
                                                              : Color.fromARGB(
                                                                  255,
                                                                  145,
                                                                  145,
                                                                  145),
                                                        ),
                                                        color: const Color
                                                            .fromARGB(
                                                            255, 251, 253, 251),
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    10))),
                                                    child: Text(
                                                      '-',
                                                      style: TextStyle(
                                                          color: int.parse(data[
                                                                          index]
                                                                      [
                                                                      'cart_name_count_product']) >
                                                                  1
                                                              ? Color.fromARGB(
                                                                  255,
                                                                  35,
                                                                  162,
                                                                  0)
                                                              : const Color
                                                                  .fromARGB(
                                                                  255,
                                                                  145,
                                                                  145,
                                                                  145),
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                          );
                        }),
                  ),
                ),
                Container(
                    width: MediaQuery.of(context).size.width,
                    // height: MediaQuery.of(context).size.height * 0.25,
                    decoration: BoxDecoration(
                        //border: Border(top: BorderSide(color: Colors.black)),
                        color: Color.fromARGB(255, 255, 255, 255),
                        borderRadius: BorderRadius.all(Radius.circular(5))),
                    margin: EdgeInsets.all(5),
                    child: Column(
                      children: [
                        new Material(
                          child: InkWell(
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                            onTap: () {
                              openModal();
                            },
                            child: Icon(
                              Icons.more_horiz,
                              size: 35,
                              color: Colors.orange,
                            ),
                          ),
                        ),
                        Text(
                          textAlign: TextAlign.center,
                          choose
                              ? cartAdminNote.toString()
                              : cartAdminNoteIstelam.toString(),
                          style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: Colors.green),
                        ),
                        !choose
                            ? Text(
                                textAlign: TextAlign.center,
                                " ! مع التأكيد انه انت من سيستلم الطلب من المتجر",
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Color.fromARGB(255, 255, 0, 0)),
                              )
                            : SizedBox(
                                height: 5,
                              ),
                        SizedBox(
                          height: 10,
                        ),
                        if (choose == true)
                          SizedBox(
                            height: 45,
                            width: 200,
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      const Color.fromARGB(255, 255, 255, 255),
                                ),
                                onPressed: () async {
                                  // Navigator.pop(context);
                                  openModalPlace();
                                },
                                child: Text(
                                  location_Name,
                                  style: TextStyle(
                                      color: Colors.orange, fontSize: 13),
                                  textAlign: TextAlign.center,
                                )),
                          ),
                        SizedBox(
                          height: 10,
                        ),
                        SizedBox(
                          height: 45,
                          width: 200,
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.orange,
                              ),
                              onPressed: () async {
                                // Navigator.pop(context);
                                orderNow();
                              },
                              child: Text(
                                'اطلب الان',
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              )),
                        ),
                        SizedBox(
                          height: 45,
                        ),
                      ],
                    )),
              ],
            )
          : Container(
              alignment: Alignment.center,
              child: CircularProgressIndicator(
                color: Colors.green,
              ),
            ),
    );
  }
}
