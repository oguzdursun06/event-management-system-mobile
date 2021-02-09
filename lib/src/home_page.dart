import 'dart:async';

import 'package:flutter_login_signup/src/model/Event.dart';
import 'package:flutter_login_signup/src/second_page.dart';
import 'package:flutter_login_signup/src/services/EventService.dart';
import 'package:flutter_login_signup/src/services/UserService.dart';
import 'package:flutter_login_signup/src/welcomePage.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'model/User.dart';
import 'model/local_notification_helper.dart';
import 'sliding_cards.dart';
import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  String name;
  String tc;
  String email;
  bool isExist;
  String password;
  MyHomePage(this.name,this.tc,this.email,this.password,this.isExist){

  }
  @override
  _MyHomePageState createState() => new _MyHomePageState(this.name,this.tc,this.email,this.password,this.isExist);
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  TabController _controller;
  final notifications = FlutterLocalNotificationsPlugin();
  String name;
  String tc;
  bool isExist;
  String email;
  String password;
  UserService userService = UserService.getInstance();
  List<User> users=[];
  EventService eventService = EventService.getInstance();
  List<Event> events=[];
  List<int> names=[];
  List<Event> myEvents=[];
  List<Event> otherPast=[];
  List<Event> others= [];
  var _count;

  _MyHomePageState(this.name,this.tc,this.email,this.password,this.isExist){
    myEvents.clear();
    otherPast.clear();
    others.clear();
    names.clear();
  }


  @override
  void initState() {
    super.initState();
    _controller = new TabController(length: 3, vsync: this);
    asyncInitState();
    final settingsAndroid = AndroidInitializationSettings('app_icon');
    final settingsIOS = IOSInitializationSettings();

    notifications.initialize(
        InitializationSettings(settingsAndroid, settingsIOS));
  }


  asyncInitState() async{
        users = await userService.getposts();
        events = await eventService.getposts();
        DateTime today = new DateTime.now();
        String dateSlug ="${today.year.toString()}-${today.month.toString().padLeft(2,'0')}-${today.day.toString().padLeft(2,'0')}";
        String year = "${today.year.toString()}";
        String month = "${today.month.toString().padLeft(2,'0')}";
        String day = "${today.day.toString().padLeft(2,'0')}";


        for(int i = 0; i < users.length; i++){
          if(tc == users[i].tc && !myEvents.contains(users[i].event)){
            myEvents.add(users[i].event);
            names.add(users[i].event.id);
          }
        }

        for(int i = 0; i < myEvents.length ; i++){
          List splitted = myEvents[i].startEventDate.toString().split(" ")[0].split("-");
          if(splitted[0] == year && splitted[1] == month && splitted[2] == (int.parse(day)+1).toString() && isExist == false){
            showOngoingNotification(notifications, title: "Merhaba "+SlidingCardsView.name, body: myEvents[i].name+" etkinligine 1 gün kaldı. Etkinligi kacırmayın :)", id: i);
          }
        }
        for(int i = 0; i < events.length; i++){
          if(!names.contains(events[i].id) && !otherPast.contains(events[i]) && dateSlug.compareTo(events[i].startEventDate.toString()) == 1){
            otherPast.add(events[i]);
          }
          else{
              if(!names.contains(events[i].id) && !others.contains(events[i])){
                others.add(events[i]);
              }
          }
        }


  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new RefreshIndicator(child: new ListView(
        children: <Widget>[
          Column(
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.green, Colors.blueGrey],
                  ),
                ),
                child: Container(
                  width: double.infinity,
                  height: 200.0,
                  child: Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        CircleAvatar(
                          backgroundImage: NetworkImage(
                              "https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcQX23gnZGjKJpwK7YwZPBkWO1IJsp8QZui6VA&usqp=CAU"),
                          radius: 40.0,
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Text(
                          this.name,
                          style: TextStyle(
                            fontSize: 22.0,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Icon(Icons.email),
                                Text(
                                 this.email,
                                  style: TextStyle(
                                    fontSize: 14.0,
                                    color: Colors.white,
                                  ),
                                )
                              ],
                            ),
                            Row(
                              children: <Widget>[
                                Icon(Icons.face),
                                Text("TC: ",
                                    style: TextStyle(
                                      fontSize: 14.0,
                                      color: Colors.white,
                                    )),
                                Text(
                                  this.tc.toString(),
                                  style: TextStyle(
                                    fontSize: 14.0,
                                    color: Colors.white,
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                        new RaisedButton(
                          onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => WelcomePage())),
                          textColor: Colors.white,
                          color: Colors.redAccent,
                          padding: const EdgeInsets.all(8.0),
                          child: new Text(
                            "Çıkıs Yap",
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          new Container(
            decoration: new BoxDecoration(color: Colors.green),
            child: new TabBar(
              controller: _controller,
              tabs: [
                new Tab(
                  icon: const Icon(Icons.event),
                  text: 'Başvur',
                ),
                new Tab(
                  icon: const Icon(Icons.event_available),
                  text: 'Etkinliklerim',
                ),
                new Tab(
                  icon: const Icon(Icons.event_busy),
                  text: 'Geçmiş Etkinlik',
                ),
              ],
            ),
          ),
          SizedBox(
            height: 5,
          ),
          new Container(
            height: 400.0,
            child: new TabBarView(
              controller: _controller,
              children: <Widget>[
                new SlidingCardsView(name, tc,email, password, others,1),
                new SlidingCardsView(name, tc,email,password, myEvents,2),
                new SlidingCardsView(name, tc,email, password, otherPast,3),
              ],
            ),
          ),

        ],
      ),
        onRefresh: _handleRefresh,
    )
    );
  }

  Future<Null> _handleRefresh() async{
    setState(() {
      Navigator.push(context, MaterialPageRoute(builder: (context) => MyHomePage(name,tc,email,password,true)));
    });
    
    Completer<Null> completer = new Completer<Null>();
    new Future.delayed(new Duration(seconds:2)).then((_){
      completer.complete();
    });

    return completer.future;
  }
}
