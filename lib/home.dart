import 'package:eshtreeli_flutter/about.dart';
import 'package:eshtreeli_flutter/cart.dart';
import 'package:eshtreeli_flutter/help.dart';

import 'package:eshtreeli_flutter/loadingHome.dart';

import 'package:eshtreeli_flutter/notifications.dart';
import 'package:eshtreeli_flutter/orders.dart';
import 'package:eshtreeli_flutter/policy.dart';
import 'package:eshtreeli_flutter/products.dart';
import 'package:eshtreeli_flutter/provider.dart';
import 'package:eshtreeli_flutter/ratings.dart';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:eshtreeli_flutter/profile.dart';
import 'package:eshtreeli_flutter/signup.dart';

import 'package:eshtreeli_flutter/subcategories.dart';
import 'package:eshtreeli_flutter/welcome.dart';
import 'package:carousel_slider/carousel_slider.dart';

import 'package:flutter/material.dart';
import 'package:flutter_rating_stars/flutter_rating_stars.dart';

import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:localstorage/localstorage.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Adv {
  final int id;
  final String advertisement_title;
  final String advertisement_description;
  final String advertisement_image;
  const Adv(
      {required this.id,
      required this.advertisement_title,
      required this.advertisement_image,
      required this.advertisement_description});

  factory Adv.fromJson(Map<String, dynamic> json) {
    //لفك الجيسون
    return Adv(
        id: json['id'],
        advertisement_title: json['advertisement_title'],
        advertisement_image: json['advertisement_image'],
        advertisement_description: json['advertisement_description']);
  }
}

class home extends StatefulWidget {
  const home({super.key});

  @override
  State<home> createState() => _MyhomeState();
}

class User {
  var id;
  User({
    required this.id,
  });

  factory User.fromJson(json) {
    //تحويل المفكو
    //ك من الجيسون بلغة دارت للمعلومات
    return User(
      id: json['id'],
    );
  }
}

class HomeCat {
  int id;
  String categories_is_empty;
  String categories_icon;
  String categories_name;
  String categories_color;
  HomeCat({
    required this.id,
    required this.categories_is_empty,
    required this.categories_icon,
    required this.categories_name,
    required this.categories_color,
  });

  factory HomeCat.fromJson(json) {
    //تحويل المفكو
    //ك من الجيسون بلغة دارت للمعلومات
    return HomeCat(
      id: json['id'],
      categories_is_empty: json['categories_is_empty'],
      categories_icon: json['categories_icon'],
      categories_name: json['categories_name'],
      categories_color: json['categories_color'],
    );
  }
}

class _MyhomeState extends State<home> {
  int _selectedIndex = 0;

  int _counter = 0;
  String username = '';
  int userRating = 0;
  String userphone = '';
  String userregion = '';
  num countImages = 0;
  String msg = ' ';
  int speed = 0;
  int devider = 1;
  bool isloading = true;
  bool isloadinguser = true;
  int userplaceId = 1;
  List dataNew = [];
  List dataHome = [];
  Future deleteOrder() async {
    final response = await http.post(
      Uri.parse('https://e-shtreeli.com/api/delete_order'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'order_id_unique': 37515,
        'order_name_customer': localStorage.getItem('id'),
      }),
    );

    if (response.statusCode == 200) {
      // final data = jsonDecode(response.body);
    } else {
      throw Exception('Failed to load cat');
    }
  }

  Future deleteAccount() async {
    final response = await http.post(
      Uri.parse('https://e-shtreeli.com/api/addel'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'user_id': localStorage.getItem('id'),
      }),
    );

    if (response.statusCode == 200) {
      if (jsonDecode(response.body)['success'] == 'حذف') {
        logout();
      } else {
        openAlert();
        msg =
            'لا يمكن لك حذف حسابك طالما يوجد دين لصالحنا في  ذمتك، من فضلك تواصل مع الادارة';
      }
    } else {
      throw Exception('Failed to load cat');
    }
  }

  late Future<List<HomeCat>> homecat;
  Future<List<HomeCat>> getHomeCat() async {
    final response = await http.post(
      Uri.parse('https://e-shtreeli.com/api/home_categories'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'id_user':
            localStorage.getItem('id') != '' ? localStorage.getItem('id') : 1
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      final List<HomeCat> list = [];
      for (var i = 0; i < data['data'].length; i++) {
        final entry = data['data'][i];
        list.add(HomeCat.fromJson(entry));
      }
      return list;
    } else {
      throw Exception('Failed to load cat');
    }
  }

  late Future<List<Adv>> adv;
  Future<List<Adv>> getAdvertise() async {
    final response =
        await http.get(Uri.parse('https://e-shtreeli.com/api/advertisement'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        speed = data['speed'] ~/ 1000; //تقسيم الانتجر على انتجر
      });

      setState(() {
        countImages = data['data'].length;
      });
      final List<Adv> list = [];
      for (var i = 0; i < data['data'].length; i++) {
        final entry = data['data'][i];
        list.add(Adv.fromJson(entry));
      }
      return list;
    } else {
      throw Exception('Failed to load album');
    }
  }

  Future getNewCat() async {
    final response = await http.post(
        Uri.parse('https://e-shtreeli.com/api/single_categories_home_new'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'id':
              localStorage.getItem('id') != '' ? localStorage.getItem('id') : 1,
          'token': localStorage.getItem('token'),
        }));
    if (response.statusCode == 200) {
      setState(() {
        if (jsonDecode(response.body)['data_new'] != null) {
          dataNew = jsonDecode(response.body)['data_new'];
        }
      });
    } else {
      throw Exception('Failed to load album');
    }
  }

  Future getHomeSub() async {
    setState(() {
      isloading = true;
    });
    final response = await http.post(
        Uri.parse('https://e-shtreeli.com/api/single_categories_home'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'id':
              localStorage.getItem('id') != '' ? localStorage.getItem('id') : 1,
        }));
    if (response.statusCode == 200) {
      setState(() {
        if (jsonDecode(response.body)['data_cat'] != null) {
          dataHome = jsonDecode(response.body)['data_cat'];
        }

        isloading = false;
      });
      //print(dataHome);
      // print(jsonDecode(response.body)['data_cat'][0]['sub_rating']);
    } else {
      throw Exception('Failed to load album');
    }
  }

  Future<void> refresh() async {
    // Simulate a delay
    await Future.delayed(Duration(milliseconds: 500));
    adv = getAdvertise();
    getNewCat();
    getuser();
    homecat = getHomeCat();
    getHomeSub();
  }

  void didChangeDependencies() {
    super.didChangeDependencies();

    final appState = Provider.of<HomeProvider>(
      context,
    );
    if (appState.someValue == 'x') {
      appState.addListener(refresh);
    }
  }

  void initState() {
    super.initState();

    final provider = Provider.of<HomeProvider>(context, listen: false);
    provider.updateCart();
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      // Check if the message contains data and handle it
      // Navigate to the desired screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => orders()),
      );
      // Call any specific function you want on the DesiredScreen
    });
    adv = getAdvertise();
    getNewCat();
    getuser();
    getHomeSub();

    // print(      "هي التوكن انحفظ ${localStorage.getItem('token')}",);

    homecat = getHomeCat();
  }

  void dispose() {
    final appState = Provider.of<HomeProvider>(context, listen: false);
    appState.removeListener(refresh);
    super.dispose();
  }

  Future saveToken() async {
    final response = await http.post(
      Uri.parse('https://e-shtreeli.com/api/save_token_expo'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'id': localStorage.getItem('id'),
        'token': localStorage.getItem('token'),
      }),
    );

    if (response.statusCode == 200) {
      //print("هيو  التوكن صار على الداتا بيز");
    } else {
      throw Exception('Failed to load cat');
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
      saveToken();
      localStorage.setItem(
          'id', jsonDecode(response.body)['data']['id'].toString());

      localStorage.setItem('region',
          jsonDecode(response.body)['data']['customer_reagion'].toString());
      localStorage.setItem('street',
          jsonDecode(response.body)['data']['customer_street'].toString());
      setState(() {
        userRating = jsonDecode(response.body)['data']['customer_rating'];
        username = jsonDecode(response.body)['data']['customers_name'];
        userphone = jsonDecode(response.body)['data']['customers_mobile'];
        userplaceId =
            jsonDecode(response.body)['data']['customers_governorates_user'];
      });
      localStorage.setItem(
          'Id',
          jsonDecode(response.body)['data']['customers_governorates_user']
              .toString());
    } else {
      throw Exception('error');
    }
  }

  logout() {
    localStorage.setItem('region', '');
    localStorage.setItem('street', '');
    localStorage.setItem('Id', '');
    localStorage.setItem('id', '');
    localStorage.setItem('token', '');
    if (localStorage.getItem('id') == '') {
      Navigator.push(context, MaterialPageRoute(builder: (context) => wel()));
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

  openAlertDelete() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                  onPressed: () {
                    deleteAccount();
                    Navigator.pop(context);
                  },
                  child: Text(
                    'نعم احذف',
                    textAlign: TextAlign.center,
                  )),
              SizedBox(
                width: 20,
              ),
              ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    'لا',
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

  Future<void> _launchURL() async {
    final Uri url =
        Uri.parse('whatsapp://send?text=مرحبا &phone=+970569071301');
    setState(() {
      msg = 'يجب ان يكون على جهازك تطبيق واتس اب';
    });
    if (!await launchUrl(url)) {
      openAlert();
      throw Exception('Could not launch');
    }
  }

  Future<void> _launchURL2() async {
    final Uri url =
        Uri.parse('whatsapp://send?text=e-shtreeli.com &phone=+970569071301');
    setState(() {
      msg = 'يجب ان يكون على جهازك تطبيق واتس اب';
    });
    if (!await launchUrl(url)) {
      openAlert();
      throw Exception('Could not launch');
    }
  }

  @override
  Widget build(BuildContext context) {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      // Check if the message contains data and handle it
      // Navigate to the desired screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => orders()),
      );
      // Call any specific function you want on the DesiredScreen
    });

    return Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            // refresh();
          },
          child: Icon(
            Icons.favorite,
            color: Colors.white,
          ),
          backgroundColor: const Color.fromARGB(255, 255, 171, 61),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: NavigationBar(
          backgroundColor: Colors.white,
          indicatorColor: Color.fromARGB(255, 255, 232, 183),
          selectedIndex: _selectedIndex,
          onDestinationSelected: (int index) {
            setState(() {
              _selectedIndex = index;
            });

            if (index == 0) {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Profile()));
            }
            if (index == 1) {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => orders()));
            }
            if (index == 2) {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => notification()));
            }
            if (index == 3) {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => allratings()));
            }
          },
          destinations: const <NavigationDestination>[
            NavigationDestination(
                icon: Icon(Icons.person_outlined),
                selectedIcon: Icon(
                  Icons.person,
                  color: const Color.fromARGB(255, 255, 171, 61),
                ),
                label: 'حسابي'),
            NavigationDestination(
                icon: Icon(Icons.folder_copy_outlined),
                selectedIcon: Icon(Icons.folder,
                    color: const Color.fromARGB(255, 255, 171, 61)),
                label: 'طلباتي'),
            NavigationDestination(
                icon: Icon(Icons.notifications_outlined),
                selectedIcon: Icon(
                  Icons.notifications,
                  color: const Color.fromARGB(255, 255, 171, 61),
                ),
                label: 'اشعارات'),
            NavigationDestination(
                icon: Icon(Icons.star_border_outlined),
                selectedIcon: Icon(Icons.star,
                    color: const Color.fromARGB(255, 255, 171, 61)),
                label: 'التقييمات'),
          ],
        ),
        appBar: AppBar(
            automaticallyImplyLeading: false,
            leading: Consumer<HomeProvider>(builder: (context, value, child) {
              return value.cartValue == 0
                  ? SizedBox()
                  : IconButton(
                      icon: Stack(
                        children: [
                          Positioned(
                            child: Container(
                              decoration: BoxDecoration(
                                  color:
                                      const Color.fromARGB(255, 244, 242, 242),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20))),
                              height: 70,
                              width: 70,
                              child: Icon(
                                Icons.shopping_basket_rounded,
                                //color: Colors.green,
                                size: 35,
                              ),
                            ),
                          ),
                          Positioned(
                              top: 19,
                              left: 12,
                              child: Container(
                                height: 17,
                                width: 17,
                                decoration: BoxDecoration(
                                    color: Colors.red,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                child: Text(
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 9),
                                  value.cartValue.toString(),
                                ),
                              )),
                        ],
                      ),
                      onPressed: () => Navigator.push(context,
                          MaterialPageRoute(builder: (context) => cart())),
                    );
            })),
        endDrawer: Drawer(
            child: Container(
          color: Color.fromARGB(255, 248, 248, 248),
          child: localStorage.getItem('id') == ''
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color.fromARGB(255, 255, 255, 255)),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => signup()));
                        },
                        child: Text(
                          "انشاء حساب",
                          style: TextStyle(
                              color: Color.fromARGB(255, 106, 106, 106),
                              fontSize: 19,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                )
              : ListView(
                  children: [
                    SizedBox(
                      height: 180,
                      child: DrawerHeader(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              margin: EdgeInsets.only(top: 20),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Colors.black,
                              ),
                              height: 50,
                              width: 50,
                              child: Image.asset(
                                'images/icon-1.png',
                                fit: BoxFit.cover,
                              ),
                            ),
                            Container(
                                child: Text(
                              '!اهلا ' + username,
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            )),
                            RatingStars(
                              value: userRating.toDouble(),
                              starSize: 25,
                              valueLabelVisibility: false,
                              valueLabelColor: const Color(0xff9b9b9b),
                              valueLabelTextStyle: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w400,
                                  fontStyle: FontStyle.normal,
                                  fontSize: 12.0),
                              valueLabelRadius: 10,
                              maxValue: 5,
                            ),
                          ],
                        ),
                      ),
                    ),
                    ListTile(
                        title: Text(
                          'الرئيسية',
                          textAlign: TextAlign.end,
                        ),
                        leading: Icon(Icons.home),
                        onTap: () {
                          Navigator.pop(context);
                        }),
                    InkWell(
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => Profile()));
                      },
                      child: ListTile(
                        title: Text(
                          'حسابي',
                          textAlign: TextAlign.end,
                        ),
                        leading: Icon(Icons.person),
                      ),
                    ),
                    ListTile(
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => orders()));
                      },
                      title: Text(
                        'طلباتي',
                        textAlign: TextAlign.end,
                      ),
                      leading: Icon(Icons.folder),
                    ),
                    ListTile(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => notification()));
                      },
                      title: Text(
                        'الإشعارات',
                        textAlign: TextAlign.end,
                      ),
                      leading: Icon(Icons.notifications),
                    ),
                    ListTile(
                      title: Text(
                        'تقييمات الزبائن',
                        textAlign: TextAlign.end,
                      ),
                      leading: Icon(Icons.star),
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => allratings()));
                      },
                    ),
                    ListTile(
                      onTap: () {
                        _launchURL();
                      },
                      title: Text(
                        'محادثة فورية',
                        textAlign: TextAlign.end,
                      ),
                      leading: Icon(Icons.chat),
                    ),
                    ListTile(
                      title: Text(
                        'مشاركة التطبيق',
                        textAlign: TextAlign.end,
                      ),
                      leading: Icon(Icons.share),
                      onTap: () async {
                        _launchURL2();
                      },
                    ),
                    ListTile(
                      title: Text(
                        'سياسة التطبيق',
                        textAlign: TextAlign.end,
                      ),
                      leading: Icon(Icons.policy),
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => Policy()));
                      },
                    ),
                    ListTile(
                      title: Text(
                        'اسئلة شائعة',
                        textAlign: TextAlign.end,
                      ),
                      leading: Icon(Icons.question_answer),
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => help()));
                      },
                    ),
                    ListTile(
                      title: Text(
                        'عن التطبيق',
                        textAlign: TextAlign.end,
                      ),
                      leading: Icon(Icons.info),
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => about()));
                      },
                    ),
                    ListTile(
                      title: Text(
                        'تسجيل خروج',
                        textAlign: TextAlign.end,
                      ),
                      leading: Icon(Icons.exit_to_app),
                      onTap: () {
                        logout();
                      },
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    ListTile(
                      title: Text(
                        'حذف الحساب',
                        style: TextStyle(color: Colors.red),
                        textAlign: TextAlign.end,
                      ),
                      leading: Icon(
                        Icons.delete_forever,
                        color: Colors.red,
                      ),
                      onTap: () {
                        setState(() {
                          msg =
                              'انتبه ! سيتم حذف حسابك بشكل نهائي وللابد! ، هل انت موافق';
                        });
                        openAlertDelete();
                      },
                    ),
                    SizedBox(
                      height: 50,
                    ),
                  ],
                ),
        )),
        body: RefreshIndicator(
          onRefresh: refresh,
          child: SingleChildScrollView(
            child: isloading
                ? loadingHome()
                : Column(
                    children: [
                      Container(
                          margin: EdgeInsets.all(1.0),
                          height: 270,
                          child: FutureBuilder<List<Adv>>(
                              future: adv,
                              builder: (context, AsyncSnapshot snapshot) {
                                if (snapshot.hasData) {
                                  return CarouselSlider.builder(
                                      itemCount: snapshot.data!.length,
                                      itemBuilder: (BuildContext context,
                                          int index, int pageViewIndex) {
                                        Adv data = snapshot.data?[index];
                                        return InkWell(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10)),
                                            onTap: () {},
                                            child: Container(
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                margin: EdgeInsets.symmetric(
                                                    horizontal: 5.0),
                                                decoration: BoxDecoration(
                                                    shape: BoxShape.rectangle,
                                                    boxShadow: [
                                                      BoxShadow(
                                                          color: Color.fromARGB(
                                                              255,
                                                              224,
                                                              213,
                                                              213),
                                                          spreadRadius: 1,
                                                          blurRadius: 2,
                                                          offset: Offset(2, 3)),
                                                    ],
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                    color: Color.fromARGB(
                                                        255, 255, 241, 91)),
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                  child: Image.network(
                                                      fit: BoxFit.cover,
                                                      data.advertisement_image),
                                                )));
                                      },
                                      options: CarouselOptions(
                                        height: 250,
                                        aspectRatio: 20 / 8,
                                        viewportFraction: 1,
                                        initialPage: 0,
                                        enableInfiniteScroll: true,
                                        reverse: false,
                                        autoPlay: true,
                                        autoPlayInterval:
                                            Duration(seconds: speed),
                                        autoPlayAnimationDuration:
                                            Duration(milliseconds: 1500),
                                        autoPlayCurve: Curves.fastOutSlowIn,
                                        enlargeCenterPage: true,
                                        enlargeFactor: 0.3,
                                        onPageChanged: (index, reason) {
                                          setState(() {
                                            _counter = index;
                                          });
                                        },
                                        scrollDirection: Axis.horizontal,
                                      ));
                                } else if (snapshot.hasError) {
                                  return Text('Error:${snapshot.error}');
                                }
                                return SizedBox();
                              })),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          for (int i = 0; i < countImages; i++)
                            Container(
                              width: _counter == i ? 13 : 8,
                              height: _counter == i ? 13 : 8,
                              margin: EdgeInsets.symmetric(horizontal: 3.0),
                              decoration: BoxDecoration(
                                  // borderRadius: BorderRadius.circular(10),
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                        color:
                                            Color.fromARGB(255, 224, 213, 213),
                                        blurRadius: 1,
                                        offset: Offset(4, 4)),
                                  ],
                                  color: _counter == i
                                      ? Color.fromARGB(255, 255, 174, 0)
                                      : const Color.fromARGB(
                                          255, 173, 168, 168)),
                            ),
                        ],
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Column(
                            children: [
                              //Container(
                              //      margin: EdgeInsets.symmetric(horizontal: 10),
                              // alignment: Alignment.centerRight,
                              //   child: Text(
                              //     "التصنيفات",
                              //      style: TextStyle(
                              //          fontSize: 17, fontWeight: FontWeight.w800),
                              //     ),
                              //)
                            ],
                          )
                        ],
                      ),
                      Container(
                          alignment: Alignment.center,

                          //color: Colors.black 26,
                          height: 135,
                          margin: EdgeInsets.all(15),
                          child: FutureBuilder<List<HomeCat>>(
                              future: homecat,
                              builder: (context, AsyncSnapshot snapshot) {
                                if (snapshot.hasData) {
                                  return ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    reverse: true,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      HomeCat data = snapshot.data?[index];
                                      if (data.categories_is_empty == 'yes') {
                                        return InkWell(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(16)),
                                            onTap: () => {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              subcat(
                                                                catid: data.id,
                                                                categories: data
                                                                    .categories_name,
                                                              )))
                                                },
                                            child: Column(children: [
                                              Container(
                                                width: 110,
                                                height: 100,
                                                margin: EdgeInsets.only(
                                                    bottom: 5,
                                                    right: 7,
                                                    left: 7),
                                                child: Container(
                                                  width: MediaQuery.of(context)
                                                      .size
                                                      .width,
                                                  height: 80,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                10)),
                                                    image: DecorationImage(
                                                      fit: BoxFit.fill,
                                                      image: NetworkImage(
                                                          data.categories_icon),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Text(
                                                data.categories_name,
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w800,
                                                    fontSize: 14),
                                              )
                                            ]));
                                      } else {
                                        return Stack(
                                            alignment: Alignment.center,
                                            children: [
                                              Positioned(
                                                  child: Column(children: [
                                                Container(
                                                  width: 110,
                                                  height: 100,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            50),
                                                  ),
                                                  margin: EdgeInsets.only(
                                                      bottom: 5,
                                                      left: 7,
                                                      right: 7),
                                                  child: Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                            .size
                                                            .width,
                                                    height: 80,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  20)),
                                                      color:
                                                          const Color.fromARGB(
                                                              255,
                                                              140,
                                                              138,
                                                              138),
                                                      image: DecorationImage(
                                                        opacity: 0.5,
                                                        fit: BoxFit.fill,
                                                        image: NetworkImage(data
                                                            .categories_icon),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Text(
                                                  data.categories_name,
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w800,
                                                      fontSize: 14),
                                                )
                                              ])),
                                              Positioned(
                                                bottom: 30,
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                      color: Color.fromARGB(
                                                          255, 100, 98, 98),
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  10))),
                                                  alignment: Alignment.center,
                                                  margin: EdgeInsets.only(
                                                      bottom: 20),
                                                  height: 60,
                                                  width: 70,
                                                  child: Text(
                                                    'غير متاح حاليا',
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ),
                                              )
                                            ]);
                                      }
                                    },
                                    itemCount: snapshot.data.length,
                                    //  scrollDirection: Axis.horizontal,
                                  );
                                } else if (snapshot.hasError) {
                                  return Text('Error:${snapshot.error}');
                                }
                                return SizedBox();
                              })),
                      Divider(),
                      if (dataNew.length > 0)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Column(
                              children: [
                                Container(
                                  padding:
                                      EdgeInsets.only(right: 10, bottom: 10),
                                  child: Text(
                                    "!يلا نجربهم",
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                      if (dataNew.length > 0)
                        Container(
                          height: 270,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            reverse: true,
                            itemCount: dataNew.length,
                            itemBuilder: (context, index) {
                              return InkWell(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                                onTap: () => {
                                  Navigator.push(
                                    context,
                                    PageRouteBuilder(
                                      pageBuilder: (context, animation,
                                              secondaryAnimation) =>
                                          products(
                                              id: dataNew[index]['id'],
                                              catcolor: dataNew[index]
                                                  ['sub_cat_color'],
                                              subcatname: dataNew[index]
                                                  ['sub_cat_name'],
                                              clockoff: dataNew[index]
                                                  ['th_time_off'],
                                              subcatprice: dataNew[index]
                                                  ['sub_cat_price'],
                                              clockon: dataNew[index]
                                                  ['th_time_on'],
                                              share: dataNew[index]
                                                  ['cat_share_with_other'],
                                              subimage: dataNew[index]
                                                  ['sub_cat_image'],
                                              backimage: dataNew[index]
                                                  ['sub_cat_back_image'],
                                              timedelevery: dataNew[index]
                                                  ['time'],
                                              dis: dataNew[index]
                                                  ['sub_cat_des'],
                                              lat: dataNew[index]
                                                  ['latitude_mart'],
                                              long: dataNew[index]
                                                  ['longitude_mart'],
                                              sub_rating: dataNew[index]
                                                  ['sub_rating'],
                                              count_rating: dataNew[index]
                                                  ['count_rating']),

                                      transitionsBuilder: (context, animation,
                                          secondaryAnimation, child) {
                                        return FadeTransition(
                                          opacity: animation,
                                          child: child,
                                        );
                                      },
                                      transitionDuration: Duration(
                                          milliseconds:
                                              500), // Slow down the transition
                                    ),
                                  ),
                                },
                                child: Container(
                                  width:
                                      MediaQuery.of(context).size.width / 1.4,
                                  margin: EdgeInsets.only(
                                      top: 5, bottom: 20, left: 15, right: 15),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Colors.white,
                                      boxShadow: [
                                        BoxShadow(
                                            color: Color.fromARGB(
                                                255, 173, 176, 181),
                                            blurRadius: 6,
                                            spreadRadius: 3,
                                            offset: Offset(4, 5))
                                      ]),
                                  child: Column(
                                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: Image.network(
                                            dataNew[index]
                                                ['sub_cat_back_image'],
                                            height: 150,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                1.4,
                                            fit: BoxFit.cover),
                                      ),
                                      Directionality(
                                        textDirection: TextDirection.rtl,
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                              right: 10, top: 5, left: 10),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                dataNew[index]['sub_cat_name'],
                                                style: TextStyle(
                                                    fontSize: 17,
                                                    fontWeight:
                                                        FontWeight.w800),
                                              ),
                                              Container(
                                                width: 300,
                                                height: 50,
                                                child: Text(
                                                  dataNew[index]['sub_cat_des'],
                                                  style: TextStyle(
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w800,
                                                      color: Colors.grey),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      SizedBox(
                        height: 20,
                      ),
                      if (dataHome.length > 0)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Column(
                              children: [
                                Container(
                                  padding:
                                      EdgeInsets.only(right: 10, bottom: 10),
                                  child: Text(
                                    "مميز",
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                      if (dataHome.length > 0)
                        Container(
                          height: 300,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            reverse: true,
                            itemCount: dataHome.length,
                            itemBuilder: (context, index) {
                              return InkWell(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                                onTap: () => {
                                  Navigator.push(
                                    context,
                                    PageRouteBuilder(
                                      pageBuilder: (context, animation,
                                              secondaryAnimation) =>
                                          products(
                                              id: dataHome[index]['id'],
                                              catcolor: dataHome[index]
                                                  ['sub_cat_color'],
                                              subcatname: dataHome[index]
                                                  ['sub_cat_name'],
                                              clockoff: dataHome[index]
                                                  ['th_time_off'],
                                              subcatprice: dataHome[index]
                                                  ['sub_cat_price'],
                                              clockon: dataHome[index]
                                                  ['th_time_on'],
                                              share: dataHome[index]
                                                  ['cat_share_with_other'],
                                              subimage: dataHome[index]
                                                  ['sub_cat_image'],
                                              backimage: dataHome[index]
                                                  ['sub_cat_back_image'],
                                              timedelevery: dataHome[index]
                                                  ['time'],
                                              dis: dataHome[index]
                                                  ['sub_cat_des'],
                                              lat: dataHome[index]
                                                  ['latitude_mart'],
                                              long: dataHome[index]
                                                  ['longitude_mart'],
                                              sub_rating: dataHome[index]
                                                  ['sub_rating'],
                                              count_rating: dataHome[index]
                                                  ['count_rating']),
                                      transitionsBuilder: (context, animation,
                                          secondaryAnimation, child) {
                                        return FadeTransition(
                                          opacity: animation,
                                          child: child,
                                        );
                                      },
                                      transitionDuration: Duration(
                                          milliseconds:
                                              500), // Slow down the transition
                                    ),
                                  ),
                                },
                                child: Container(
                                  width:
                                      MediaQuery.of(context).size.width / 1.4,
                                  margin: EdgeInsets.only(
                                      top: 5, bottom: 20, left: 15, right: 15),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Colors.white,
                                      boxShadow: [
                                        BoxShadow(
                                            color: Color.fromARGB(
                                                255, 173, 176, 181),
                                            blurRadius: 6,
                                            spreadRadius: 3,
                                            offset: Offset(4, 5))
                                      ]),
                                  child: Column(
                                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: Image.network(
                                            dataHome[index]
                                                ['sub_cat_back_image'],
                                            height: 150,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                1.4,
                                            fit: BoxFit.cover),
                                      ),
                                      Directionality(
                                        textDirection: TextDirection.rtl,
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                              right: 10, top: 5, left: 10),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                dataHome[index]['sub_cat_name'],
                                                style: TextStyle(
                                                    fontSize: 17,
                                                    fontWeight:
                                                        FontWeight.w800),
                                              ),
                                              Container(
                                                width: 300,
                                                height: 50,
                                                child: Text(
                                                  dataHome[index]
                                                      ['sub_cat_des'],
                                                  style: TextStyle(
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w800,
                                                      color: Colors.grey),
                                                ),
                                              ),
                                              Row(children: [
                                                Text(
                                                  "(${dataHome[index]['count_rating']}",
                                                  style: TextStyle(
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w800,
                                                      color: Color.fromARGB(
                                                          255, 72, 72, 72)),
                                                ),
                                                Text(
                                                  " تقييم)",
                                                  style: TextStyle(
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w800,
                                                      color: Color.fromARGB(
                                                          255, 118, 116, 116)),
                                                ),
                                                Text(
                                                  dataHome[index]['sub_rating'],
                                                  style: TextStyle(
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w800,
                                                      color: Color.fromARGB(
                                                          255, 0, 0, 0)),
                                                ),
                                                Icon(
                                                  Icons.star,
                                                  size: 20,
                                                  color: const Color.fromARGB(
                                                      255, 252, 227, 1),
                                                ),
                                                SizedBox(
                                                  height: 2,
                                                ),
                                              ]),
                                            ],
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      SizedBox(
                        height: 40,
                      ),
                    ],
                  ),
          ),
        ));
  }
}
