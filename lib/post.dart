import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

class User {
  final String about_title;
  final String about_description;
  const User({
    required this.about_title,
    required this.about_description,
  });
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      about_title: json['about_title'],
      about_description: json['about_description'],
    );
  }
}

class UserService {
  Future<User> fetchAlbum() async {
    final response =
        await http.get(Uri.parse('https://e-shtreeli.com/api/abouts'));

    if (response.statusCode == 200) {
      return User.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
  }
}
