import 'package:flutter_login_signup/src/model/Event.dart';

class User{
  String name;
  String tc;
  String email;
  Event event;
  String eventName;


  User({this.name, this.tc, this.email, this.event, this.eventName});

  User.fromJson(Map<String,dynamic>json){
    name = json['name'];
    tc = json['tc'];
    email = json['email'];
    eventName = json['eventName'];
    event = Event.fromJson(json["event"]);
  }

  Map<String,dynamic>toJson(){
    final Map<String,dynamic> data = new Map<String,dynamic>();
    data['name'] = this.name;
    data['tc'] = this.tc;
    data['email'] = this.email;
    data['event'] = event.toJson();

    return data;
  }

}


class UserList{
  List<User> users=[];

  UserList.fromJsonList(Map value){
    value.forEach((key, value) {
      var post = User.fromJson(value);
      users.add(post);
    });

  }
}
