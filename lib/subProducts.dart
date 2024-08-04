import 'package:eshtreeli_flutter/cart.dart';
import 'package:eshtreeli_flutter/home.dart';
import 'package:eshtreeli_flutter/provider.dart';

import 'package:flutter/material.dart';

import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:localstorage/localstorage.dart';
import 'package:provider/provider.dart';

class subpro extends StatefulWidget {
  final unit_pro;
  final adds_pro;
  final name_pro;
  final name_img;
  final exhibition_categories_id;
  final exhibition_sub_categories_id;
  final exhibition_item_description;
  const subpro({
    required this.unit_pro,
    required this.adds_pro,
    required this.name_pro,
    required this.name_img,
    required this.exhibition_categories_id,
    required this.exhibition_sub_categories_id,
    required this.exhibition_item_description,
  });

  @override
  State<subpro> createState() => _subproState();
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate({
    required this.minHeight,
    required this.maxHeight,
    required this.child,
  });

  final double minHeight;
  final double maxHeight;
  final Widget child;

  @override
  double get minExtent => minHeight;

  @override
  double get maxExtent => maxHeight;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return SizedBox.expand(child: child);
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        child != oldDelegate.child;
  }
}

class _subproState extends State<subpro> {
  List adds = [
    {'add_name': ' ', 'add_price': 0.0001},
    {'add_name': ' ', 'add_price': 0.0001},
    {'add_name': ' ', 'add_price': 0.0001},
    {'add_name': ' ', 'add_price': 0.0001},
    {'add_name': ' ', 'add_price': 0.0001},
  ];
  var selected = '';
  var selectedprice = '';
  String note = ' ';
  String start = '';
  String end = '';
  bool? isloading = false;
  String texAlert = '';
  int count = 1;
  final List list = [];
  late TextEditingController controller;
  late TextEditingController controller2;
  snakFun(context) {
    SnackBar snackBar = SnackBar(
        duration: const Duration(milliseconds: 2500),
        backgroundColor: Color.fromARGB(255, 123, 213, 98),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        margin: EdgeInsets.only(
            bottom: 20, //MediaQuery.of(context).size.height - 100,
            left: 20,
            right: 20),
        content: Text(
          texAlert,
          textAlign: TextAlign.center,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Future addToCart() async {
    setState(() {
      isloading = true;
    });

    final response = await http.post(
      Uri.parse('https://e-shtreeli.com/api/save_cart'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'cart_name_product': widget.name_pro + "(" + selected + ")",
        'cart_name_cat': widget.exhibition_categories_id,
        'cart_name_cat_sub': widget.exhibition_sub_categories_id,
        'cart_name_count_product': count,
        'cart_name_price':
            selectedprice.substring(0, selectedprice.indexOf("_")).trim(),
        'cart_name_customer': localStorage.getItem('id'),
        'cart_image': widget.name_img,
        'cart_mininote': note,
        'cart_adds': adds[0]['add_name'],
        'cart_adds1': adds[1]['add_name'],
        'cart_adds2': adds[2]['add_name'],
        'cart_adds3': adds[3]['add_name'],
        'cart_adds4': adds[4]['add_name'],
        'cart_adds_unit': adds[0]['add_price'],
        'cart_adds_unit1': adds[1]['add_price'],
        'cart_adds_unit2': adds[2]['add_price'],
        'cart_adds_unit3': adds[3]['add_price'],
        'cart_adds_unit4': adds[4]['add_price'],
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      if (data['success'] == 'false_share') {
        setState(() {
          isloading = false;
        });
        openAlert();
      } else if (data['success'] == 'false_time') {
        setState(() {
          isloading = false;
        });
        openAlertFalseTime();
      } else if (data['success'] == 'true') {
        final provider = Provider.of<HomeProvider>(context, listen: false);
        provider.updateCart();
        setState(() {
          isloading = false;
        });
        setState(() {
          texAlert = 'تمت اضافة المنتج بنجاح';
        });
        snakFun(context);
      }

      return list;
    } else {
      throw Exception('فنكشن السلة لا يعمل');
    }
  }

  Future newAddToCart() async {
    setState(() {
      isloading = true;
    });

    final response = await http.post(
      Uri.parse('https://e-shtreeli.com/api/save_cart_new'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'cart_name_product': widget.name_pro + "(" + selected + ")",
        'cart_name_cat': widget.exhibition_categories_id,
        'cart_name_cat_sub': widget.exhibition_sub_categories_id,
        'cart_name_count_product': count,
        'cart_name_price':
            selectedprice.substring(0, selectedprice.indexOf("_")).trim(),
        'cart_name_customer': localStorage.getItem('id'),
        'cart_image': widget.name_img,
        'cart_mininote': note,
        'cart_adds': adds[0]['add_name'],
        'cart_adds1': adds[1]['add_name'],
        'cart_adds2': adds[2]['add_name'],
        'cart_adds3': adds[3]['add_name'],
        'cart_adds4': adds[4]['add_name'],
        'cart_adds_unit': adds[0]['add_price'],
        'cart_adds_unit1': adds[1]['add_price'],
        'cart_adds_unit2': adds[2]['add_price'],
        'cart_adds_unit3': adds[3]['add_price'],
        'cart_adds_unit4': adds[4]['add_price'],
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        isloading = false;
      });

      if (data['success'] == 'true') {
        final provider = Provider.of<HomeProvider>(context, listen: false);
        provider.updateCart();
        setState(() {
          texAlert = 'تمت اضافة المنتج بنجاح';
        });
        snakFun(context);
      }
    } else {
      throw Exception('فنكشن السلة لا يعمل');
    }
  }

  openAlertdescribtion() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: EdgeInsets.only(right: 10, top: 10),
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      'تمام',
                      style:
                          TextStyle(color: Color.fromARGB(255, 253, 255, 253)),
                      textAlign: TextAlign.center,
                    )),
              ),
            ],
          ),
        ],
        title: Text("وصف المنتجات/الخدمات",
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Colors.red, fontWeight: FontWeight.bold, fontSize: 15)),
        contentPadding: EdgeInsets.all(5),
        content: Text(widget.exhibition_item_description,
            textAlign: TextAlign.center,
            style: TextStyle(
                color: const Color.fromARGB(255, 70, 69, 69),
                fontWeight: FontWeight.bold)),
      ),
    );
  }

  openAlertFalseTime() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: EdgeInsets.only(right: 10, top: 10),
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      'تمام',
                      style:
                          TextStyle(color: Color.fromARGB(255, 253, 255, 253)),
                      textAlign: TextAlign.center,
                    )),
              ),
            ],
          ),
        ],
        title: Text("!غير مسموح",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
        contentPadding: EdgeInsets.all(5),
        content: Text(
            'عذرا لا يمكنك اضافة هذا المنتج الى السلة لان التصنيف الخاص به غير متاح، حاول في وقت لاحق',
            textAlign: TextAlign.center,
            style: TextStyle(
                color: const Color.fromARGB(255, 70, 69, 69),
                fontWeight: FontWeight.bold)),
      ),
    );
  }

  openAlert() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: EdgeInsets.only(right: 10, top: 10),
                child: isloading == true
                    ? CircularProgressIndicator()
                    : ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color.fromARGB(255, 0, 185, 15),
                        ),
                        onPressed: () {
                          newAddToCart();
                          Navigator.pop(context);
                        },
                        child: Text(
                          'نعم احذف',
                          style: TextStyle(
                              color: Color.fromARGB(255, 253, 255, 253)),
                          textAlign: TextAlign.center,
                        )),
              ),
              Container(
                margin: EdgeInsets.only(left: 10, top: 10),
                child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      'لا',
                      style: TextStyle(color: Color.fromARGB(255, 245, 179, 0)),
                      textAlign: TextAlign.center,
                    )),
              ),
            ],
          ),
        ],
        title: Text("!غير مسموح",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
        contentPadding: EdgeInsets.all(5),
        content: Text(
            'عذرا هذا المنتج لا يمكن اضافته مع المنتجات الموجودة في السلة ،هل تريد حذف ما هو في السلة واضافة هذا المنتج ؟',
            textAlign: TextAlign.center,
            style: TextStyle(
                color: const Color.fromARGB(255, 70, 69, 69),
                fontWeight: FontWeight.bold)),
      ),
    );
  }

  Future confirmOrder() async {
    setState(() {
      isloading = true;
    });

    final response = await http.post(
      Uri.parse('https://e-shtreeli.com/api/add_order'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'name_order_form_mobile': 'Taxi',
        'order_name_customer_location_reagion': 'region',
        'order_name_customer_location_street': 'street',
        'order_name_customer_location_building': 'building',
        'order_name_customer_location_home': 'home',
        'id_user': localStorage.getItem('id'),
        'order_name_note': ' من' + start + ' الى' + ' ' + end,
        'order_sum_first': 0,
        'order_delivery_price': 0,
        'order_sum': 0,
        'save_location': false,
        'sum_discount': 0,
        'order_longitude': 32,
        'order_latitude': 35,
        'time_delivery': 'تكسي الان',
        'price_service': 0,
        'dept': 0,
        'code': 0
      }),
    );

    if (response.statusCode == 200) {
      setState(() {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => home()));
        isloading = false;
        texAlert = 'سنرسل لك تكسي قريبا';
      });

      snakFun(context);
    } else {
      setState(() {
        isloading = false;
      });
      throw Exception('فنكشن طلب التاكسي لا يعمل');
    }
  }

  List<bool> _selected = List.generate(20, (i) => false);
  openTaxiModal() async {
    orderTaxi() {
      if (start == '' || end == '') {
        setState(() {
          texAlert = 'يجب ملء كلا الحقلين (نقطة الانطلاق ونقطةالوصول النهائية)';
        });
      } else {
        setState(() {
          texAlert = '';
        });
        confirmOrder();
        Navigator.pop(context);
      }
    }

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
                      height: 50,
                    ),
                    if (texAlert != '')
                      Container(
                        width: 265,
                        child: Text(
                          texAlert,
                          style: TextStyle(color: Colors.red, fontSize: 15),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    SizedBox(
                      height: 50,
                    ),
                    Container(
                      alignment: Alignment.centerRight,
                      margin: EdgeInsets.only(right: 70),
                      child: Text(
                        'من',
                        textAlign: TextAlign.start,
                      ),
                    ),
                    SizedBox(
                      height: 100,
                      width: 265,
                      child: TextField(
                        controller: controller,
                        onSubmitted: (String value) {
                          setState(() {
                            start = controller.text.toString();
                          });
                        },
                        onChanged: (String value) {
                          setState(() {
                            start = controller.text.toString();
                            texAlert = '';
                          });
                        },
                        decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 50.0, horizontal: 10.0),
                            fillColor: Colors.white,
                            filled: true,
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide: BorderSide(
                                    color: Color.fromARGB(255, 214, 211, 211),
                                    width: 1)),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide:
                                    BorderSide(color: Colors.orange, width: 2)),
                            hintText: 'ضع نقطة الانطلاق',
                            hintStyle: TextStyle(
                                fontSize: 15,
                                color: Color.fromARGB(255, 176, 176, 176))),
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Container(
                      alignment: Alignment.centerRight,
                      margin: EdgeInsets.only(right: 70),
                      child: Text(
                        'الى',
                        textAlign: TextAlign.start,
                      ),
                    ),
                    SizedBox(
                      height: 100,
                      width: 265,
                      child: TextField(
                        controller: controller2,
                        onSubmitted: (String value) {
                          setState(() {
                            end = controller2.text.toString();
                          });
                        },
                        onChanged: (String value) {
                          setState(() {
                            end = controller2.text.toString();
                            if (start != '') {
                              texAlert = '';
                            }
                          });
                        },
                        decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 50.0, horizontal: 10.0),
                            fillColor: Colors.white,
                            filled: true,
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide: BorderSide(
                                    color: Color.fromARGB(255, 214, 211, 211),
                                    width: 1)),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide:
                                    BorderSide(color: Colors.orange, width: 2)),
                            hintText: 'ضع وجهة الوصول النهائية',
                            hintStyle: TextStyle(
                                fontSize: 15,
                                color: Color.fromARGB(255, 176, 176, 176))),
                      ),
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    Container(
                      width: 250,
                      height: 50,
                      margin: EdgeInsets.only(top: 10),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green),
                        onPressed: () {
                          orderTaxi();
                          setState(() {});
                          ;
                        },
                        child: Text(
                          "اطلب التكسي الان",
                          style: TextStyle(
                              color: const Color.fromARGB(255, 255, 255, 255),
                              fontSize: 17,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 50,
                    ),
                  ],
                ),
              ),
            );
          });
        });
  }

  opemModal() async {
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 250,
                          margin: EdgeInsets.all(10),
                          child: Text(widget.name_pro + "(" + selected + ")",
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                  color: Color.fromARGB(255, 11, 11, 11))),
                        ),
                        Container(
                          margin: EdgeInsets.all(10),
                          child: Text(
                              selectedprice
                                      .substring(0, selectedprice.indexOf("_"))
                                      .trim() +
                                  "₪",
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                  color: Color.fromARGB(255, 3, 174, 8))),
                        ),
                      ],
                    ),
                    Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: () {
                            setState(() {
                              count = count + 1;
                            });
                          },
                          child: Container(
                            height: 30,
                            width: 50,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                color: Colors.green,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                            child: Text(
                              '+',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        SizedBox(
                          child: Text(
                            count.toString(),
                            style: TextStyle(
                                color: Color.fromARGB(255, 45, 149, 1),
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        InkWell(
                          onTap: () {
                            setState(() {
                              if (count > 1) {
                                count = count - 1;
                              }
                            });
                          },
                          child: Container(
                            height: 30,
                            width: 50,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                color: Colors.green,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                            child: Text(
                              '-',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        )
                      ],
                    ),
                    Divider(),
                    Container(
                      margin: EdgeInsets.all(10),
                      child: Text('الاضافات',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color: _selected.contains(true)
                                  ? Colors.orange
                                  : const Color.fromARGB(255, 1, 1, 1))),
                    ),
                    Column(
                      children: widget.adds_pro.map<Widget>((element) {
                        return Container(
                          margin: EdgeInsets.only(top: 3, left: 10, right: 10),
                          child: ListTile(
                            visualDensity: VisualDensity(vertical: -4),
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(50))),

                            tileColor: _selected[
                                    widget.adds_pro.indexOf(element)]
                                ? Colors.orange
                                : const Color.fromARGB(255, 255, 255,
                                    255), // If current item is selected show blue color
                            onTap: () {
                              setState(() {
                                if (_selected[
                                        widget.adds_pro.indexOf(element)] ==
                                    false) {
                                  adds[widget.adds_pro.indexOf(element)] = ({
                                    'add_name': widget.adds_pro[widget.adds_pro
                                        .indexOf(element)]['add_name'],
                                    'add_price': widget.adds_pro[widget.adds_pro
                                            .indexOf(element)]['add_price']
                                        .toString()
                                  });
                                  //  print(adds);
                                }
                                if (_selected[
                                        widget.adds_pro.indexOf(element)] ==
                                    true) {
                                  adds[widget.adds_pro.indexOf(element)] = ({
                                    'add_name': ' ',
                                    'add_price': '0.0001'
                                  });
                                  // print(adds);
                                }

                                _selected[widget.adds_pro.indexOf(element)] =
                                    !_selected[
                                        widget.adds_pro.indexOf(element)];
                              });
                            },
                            title: Text(element['add_name'],
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color: _selected[
                                          widget.adds_pro.indexOf(element)]
                                      ? Color.fromARGB(255, 236, 240, 237)
                                      : Colors.orange,
                                )),

                            trailing: Text(
                                "₪" + element['add_price'].toString(),
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    color: Color.fromARGB(255, 24, 24, 24))),
                          ),
                        );
                      }).toList(),
                    ),
                    Divider(),
                    Column(
                      children: [
                        Text('الملاحظات',
                            textAlign: TextAlign.start,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                                color: _selected.contains(true)
                                    ? Colors.orange
                                    : const Color.fromARGB(255, 1, 1, 1))),
                        SizedBox(
                          height: 10,
                        ),
                        SizedBox(
                          height: 100,
                          width: 265,
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
                                    borderSide: BorderSide(
                                        color:
                                            Color.fromARGB(255, 214, 211, 211),
                                        width: 1)),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    borderSide: BorderSide(
                                        color: Colors.orange, width: 2)),
                                hintText:
                                    'ضع ملاحظاتك هنا حول هذا المنتج لتظهر في طلبك',
                                hintStyle: TextStyle(
                                    fontSize: 12,
                                    color: Color.fromARGB(255, 176, 176, 176))),
                          ),
                        ),
                        SizedBox(height: 20),
                        SizedBox(
                          height: 45,
                          width: 180,
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.orange,
                              ),
                              onPressed: () async {
                                addToCart();

                                Navigator.pop(context);
                              },
                              child: Text(
                                'اضف  الى السلة',
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              )),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            );
          });
        }).whenComplete(() {});
  }

  @override
  void initState() {
    super.initState();

    controller2 = TextEditingController();
    controller = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            //automaticallyImplyLeading: false, // This removes the back button
            title: Container(
              alignment: Alignment.centerRight,
              child: IconButton(
                icon: Consumer<HomeProvider>(builder: (context, value, child) {
                  return value.cartValue == 0
                      ? SizedBox()
                      : Stack(
                          children: [
                            Positioned(
                              child: Container(
                                decoration: BoxDecoration(
                                    color: const Color.fromARGB(
                                        255, 244, 242, 242),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(25))),
                                height: 45,
                                width: 45,
                                child: Icon(
                                  Icons.shopping_basket_rounded,
                                  //color: Colors.green,
                                  size: 35,
                                ),
                              ),
                            ),
                            Positioned(
                                top: 23,
                                left: 14,
                                child: Container(
                                  height: 17,
                                  width: 17,
                                  decoration: BoxDecoration(
                                      color: Colors.red,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10))),
                                  child: Text(
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 9),
                                    value.cartValue.toString(),
                                  ),
                                )),
                          ],
                        );
                }),
                onPressed: () => Navigator.push(
                    context, MaterialPageRoute(builder: (context) => cart())),
              ),
            ),

            titleSpacing: 5,
            backgroundColor: Color.fromARGB(255, 240, 237, 237),
            pinned: true,
            expandedHeight: 300.0,
            flexibleSpace: FlexibleSpaceBar(
              background: Hero(
                tag: widget.name_img,
                child: Container(
                  // للصورة الكبيرة
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.symmetric(horizontal: 0),

                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color:
                            Color.fromARGB(255, 142, 142, 142).withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 7,
                        offset: Offset(0, 3), // changes position of shadow
                      ),
                    ],
                    borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(20),
                        bottomLeft: Radius.circular(20)),
                    image: DecorationImage(
                      fit: BoxFit.fill,
                      image: NetworkImage(widget.name_img),
                    ),
                  ),
                ),
              ),
            ),
          ),
          SliverPersistentHeader(
            pinned: true,
            delegate: _SliverAppBarDelegate(
              minHeight: 50.0, // Minimum height of the title bar
              maxHeight: 50.0, // Maximum height of the title bar
              child: isloading == true
                  ? Container(
                      alignment: Alignment.center,
                      child: CircularProgressIndicator(
                        color: Color.fromARGB(255, 75, 195, 0),
                      ))
                  : Container(
                      margin: EdgeInsets.symmetric(horizontal: 10),
                      color: Colors.white,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                            borderRadius: BorderRadius.circular(10),
                            onTap: () {
                              openAlertdescribtion();
                            },
                            child: Container(
                                alignment: Alignment.center,
                                //margin: EdgeInsets.only(left: 50, top: 220),
                                height: 35,
                                width: 80,
                                decoration: BoxDecoration(
                                  color: Color.fromARGB(255, 254, 254, 254)
                                      .withOpacity(0.9),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey,
                                      spreadRadius: 3,
                                      blurRadius: 2,
                                      offset: Offset(
                                          1, 2), // changes position of shadow
                                    ),
                                  ],
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(20),
                                    bottomLeft: Radius.circular(20),
                                    topRight: Radius.circular(20),
                                    bottomRight: Radius.circular(20),
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.info_outline,
                                      color: Color.fromARGB(255, 3, 185, 0),
                                    ),
                                    Text('الوصف',
                                        style: TextStyle(
                                            fontSize: 13,
                                            color:
                                                Color.fromARGB(255, 42, 42, 41),
                                            fontWeight: FontWeight.bold)),
                                  ],
                                )),
                          ),
                          Text(
                            widget.name_pro,
                            style: TextStyle(
                                color: const Color.fromARGB(255, 13, 13, 13),
                                fontWeight: FontWeight.bold,
                                fontSize: 20.0),
                          ),
                        ],
                      ),
                    ),
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.only(bottom: 20.0), // S
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  return Column(
                    children: [
                      Container(
                        margin: EdgeInsets.only(left: 10, right: 10, top: 10),
                        child: ListTile(
                          tileColor: Color.fromARGB(255, 240, 237, 237),
                          contentPadding: EdgeInsets.only(right: 10, left: 10),
                          onTap: () {
                            setState(() {
                              selected = widget.unit_pro[index]['label'];
                              selectedprice = widget.unit_pro[index]['value'];
                            });

                            widget.exhibition_categories_id == 74
                                ? openTaxiModal()
                                : opemModal();
                          },
                          enabled: widget.unit_pro[index]['status'] == 'yes'
                              ? true
                              : false,
                          shape: RoundedRectangleBorder(
                            side: BorderSide(
                                color: const Color.fromARGB(255, 255, 255, 255),
                                width: 1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          visualDensity: VisualDensity(vertical: 3),
                          title: Column(children: [
                            Text(
                              widget.unit_pro[index]['label'],
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                  color:
                                      widget.unit_pro[index]['status'] == 'yes'
                                          ? Color.fromARGB(255, 34, 35, 34)
                                          : Color.fromARGB(255, 190, 190, 190)),
                            ),
                          ]),
                          leading: Text(
                            widget.unit_pro[index]['value']
                                    .substring(
                                        0,
                                        widget.unit_pro[index]['value']
                                            .indexOf("_"))
                                    .trim() +
                                "₪",
                            style: TextStyle(
                                fontSize: 15,
                                color: widget.unit_pro[index]['status'] == 'yes'
                                    ? Color.fromARGB(255, 0, 231, 8)
                                    : Color.fromARGB(255, 203, 203, 203)),
                          ),
                        ),
                      ),
                    ],
                  );
                },
                childCount: widget.unit_pro.length,
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              padding: EdgeInsets.all(16.0),
              color: Color.fromARGB(255, 255, 255, 255),
              child: Center(
                child: Text(
                  'نهاية القائمة',
                  style: TextStyle(
                      color: const Color.fromARGB(255, 158, 158, 158),
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SlowPageRoute<T> extends MaterialPageRoute<T> {
  SlowPageRoute({required WidgetBuilder builder}) : super(builder: builder);

  @override
  Duration get transitionDuration =>
      Duration(seconds: 2); // Slow down the transition
}
