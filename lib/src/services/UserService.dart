import 'dart:convert';
import 'dart:io';

import 'package:flutter_login_signup/src/model/User.dart';
import 'package:http/http.dart' as http;


class UserService {
  String _baseUrl;


  static UserService _instance = UserService._privateConstructor();

  UserService._privateConstructor() {
    _baseUrl ='http://localhost:8080/api/';
  }

  static UserService getInstance(){
    if(_instance == null){
      return UserService._privateConstructor();
    }
    else{
      return _instance;
    }
  }

  Future<List<User>> getposts() async{
    final response = await http.get(Uri.encodeFull("http://10.0.2.2:8080/api/users"), headers: {"Accept": "application/json; charset=utf-8"});
    final jsonResponse = jsonDecode(response.body);
    switch(response.statusCode){
      case HttpStatus.ok:
        final postsList = json.decode(response.body).map<User>((item) => User.fromJson(item)).toList();
        return postsList;
        break;


      case HttpStatus.unauthorized:
        throw Exception('Bir hata oluştu');
        break;
    }
  }

  Future<void> addposts(User user) async {
    final jsonBody =jsonEncode(user.toJson());
    final response = await http.post(Uri.encodeFull("http://10.0.2.2:8080/api/users"), headers: {
      'Accept': 'application/json',
      'Content-Type': 'application/json'},body:jsonBody,);
    switch(response.statusCode){

      case HttpStatus.ok:
        return Future.value(true);
        break;
      case HttpStatus.unauthorized:
        throw Exception('Bir hata olustu ${response.statusCode}');
        break;
    }


  }



}