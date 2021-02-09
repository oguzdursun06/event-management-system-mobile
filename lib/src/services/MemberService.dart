import 'dart:convert';
import 'dart:io';

import 'package:flutter_login_signup/src/model/Member.dart';
import 'package:http/http.dart' as http;




class MemberService {
  String _baseUrl;


  static MemberService _instance = MemberService._privateConstructor();

  MemberService._privateConstructor() {
    _baseUrl ='http://localhost:8080/api/';
  }

  static MemberService getInstance(){
    if(_instance == null){
      return MemberService._privateConstructor();
    }
    else{
      return _instance;
    }
  }

  Future<List<Member>> getposts() async{
    final response = await http.get(Uri.encodeFull("http://10.0.2.2:8080/api/members"), headers: {"Accept": "application/json; charset=utf-8"});
    final jsonResponse = jsonDecode(response.body);
    switch(response.statusCode){
      case HttpStatus.ok:
        final postsList = json.decode(response.body).map<Member>((item) => Member.fromJson(item)).toList();
        return postsList;
        break;


      case HttpStatus.unauthorized:
        throw Exception('Bir hata oluştu');
        break;
    }
  }

  Future<void> addposts(Member member) async {
    final jsonBody =jsonEncode(member.toJson());
    final response = await http.post(Uri.encodeFull("http://10.0.2.2:8080/api/members"), headers: {
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