import 'dart:convert';
import 'dart:io';

import 'package:flutter_login_signup/src/model/Event.dart';
import 'package:http/http.dart' as http;


class EventService {
  String _baseUrl;


  static EventService _instance = EventService._privateConstructor();

  EventService._privateConstructor() {
    _baseUrl ='http://localhost:8080/api/';
  }

  static EventService getInstance(){
    if(_instance == null){
      return EventService._privateConstructor();
    }
    else{
      return _instance;
    }
  }

  Future<List<Event>> getposts() async{
    final response = await http.get(Uri.encodeFull("http://10.0.2.2:8080/api/events"), headers: {"Accept": "application/json; charset=utf-8"});
    final jsonResponse = jsonDecode(response.body);
    switch(response.statusCode){
      case HttpStatus.ok:
        final postsList = json.decode(response.body).map<Event>((item) => Event.fromJson(item)).toList();
        return postsList;
        break;


      case HttpStatus.unauthorized:
        throw Exception('Bir hata oluştu');
        break;
    }
  }





}