import 'dart:async';


import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_login_signup/src/home_page.dart';
import 'dart:math' as math;

import 'package:flutter_login_signup/src/model/Event.dart';
import 'package:flutter_login_signup/src/model/User.dart';
import 'package:flutter_login_signup/src/services/UserService.dart';
import 'package:flutter_login_signup/src/welcomePage.dart';
import 'package:qr_flutter/qr_flutter.dart';

class SlidingCardsView extends StatefulWidget {
  static String name;
  static String tc;
  static String email;
  static String password;
  List<Event> events;
  int style;

  SlidingCardsView(String fullName, String tcKim, String emailAdd,String psw, this.events, int style) {
    events = this.events;
    this.style = style;
    name = fullName;
    tc = tcKim;
    email = emailAdd;
    password = psw;
  }

  @override
  _SlidingCardsViewState createState() =>
      _SlidingCardsViewState(this.events, this.style);
}

class _SlidingCardsViewState extends State<SlidingCardsView> {
  List<Event> events;
  int style;

  _SlidingCardsViewState(this.events, style) {
    this.events = events;
    this.style = style;
  }

  PageController pageController;
  double pageOffset = 0;
  Timer timer;
  int counter = 0;

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(Duration(milliseconds: 1), (Timer t) {
      addValue();
    });
    pageController = PageController(viewportFraction: 0.8);
    pageController.addListener(() {
      setState(() => pageOffset = pageController.page);
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    pageController.dispose();
    super.dispose();
  }

  addValue() {
    setState(() {});
  }


  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.55,
      child: (events.length != 0)
          ? PageView.builder(
              itemCount: events.length,
              controller: pageController,
              itemBuilder: (context, position) {
                return SlidingCard(
                  name: events[position].name,
                  startDate: events[position].startEventDate.toString(),
                  finishDate: events[position].finishEventDate.toString(),
                  capacity: events[position].capacity,
                  style: this.style,
                  id: events[position].id,
                  assetName: events[position].category == "yazilim"
                      ? 'software.jpg'
                      : events[position].category == "sanat"
                          ? 'art.jpg'
                          : events[position].category == "egitim"
                              ? 'education.jpg'
                              : events[position].category == "eglence"
                                  ? 'fun.jpg'
                                  : events[position].category == "spor"
                                      ? 'sports.jpg'
                                      : events[position].category == "gezi"
                                          ? 'travel.jpg'
                                          : 'other.jpg',
                  offset: pageOffset,
                );
              })
          : Container(
              width: 200,
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                color: Colors.white,
                elevation: 10,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    const ListTile(
                      title: Icon(
                        Icons.error,
                        size: 150,
                        color: Colors.pinkAccent,
                      ),
                    ),
                    SizedBox(height: 40),
                    Text(
                      'Bu kategoride gösterilebilecek etkinlik yok!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontFamily: 'RobotoCondensed',
                          fontWeight: FontWeight.w700,
                          fontSize: 24.0,
                          color: Colors.black54),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}

class SlidingCard extends StatelessWidget {
  final String name;
  final String startDate;
  final String finishDate;
  final int capacity;
  final int style;
  final String assetName;
  final int id;
  final double offset;
  final AlertDialog alert;

   SlidingCard({
    Key key,
    @required this.name,
    @required this.startDate,
    @required this.finishDate,
    @required this.alert,
    @required this.capacity,
    @required this.id,
    @required this.style,
    @required this.assetName,
    @required this.offset,
  }) : super(key: key){
   }

  @override
  Widget build(BuildContext context) {
    double gauss = math.exp(-(math.pow((offset.abs() - 0.5), 2) / 0.08));
    return Transform.translate(
      offset: Offset(-32 * gauss * offset.sign, 0),
      child: Card(
        margin: EdgeInsets.only(left: 8, right: 8, bottom: 24),
        elevation: 8,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
        child: Column(
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
              child: Image.asset(
                'assets/$assetName',
                height: MediaQuery.of(context).size.height * 0.3,
                alignment: Alignment(-offset.abs(), 0),
                fit: BoxFit.fill,
              ),
            ),
            SizedBox(height: 8),
            Expanded(
              child: CardContent(
                name: name,
                startDate: startDate,
                finishDate: finishDate,
                capacity: capacity,
                id: id,
                style: style,
                offset: gauss,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CardContent extends StatelessWidget {
  final String name;
  final String startDate;
  final String finishDate;
  final int capacity;
  final int id;
  final int style;
  final double offset;
  UserService userService = UserService.getInstance();

   CardContent(
      {Key key,
      @required this.name,
      @required this.startDate,
        @required this.finishDate,
        @required this.id,
      @required this.style,
      @required this.capacity,
      @required this.offset})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Transform.translate(
            offset: Offset(8 * offset, 0),
            child: Text(name, style: TextStyle(fontSize: 20)),
          ),
          SizedBox(height: 8),
          Transform.translate(
            offset: Offset(32 * offset, 0),
            child: Text(
              startDate.split(" ")[0].split("-")[2]+"/"+startDate.split(" ")[0].split("-")[1]+"/"+startDate.split(" ")[0].split("-")[0]+"   -   "+finishDate.split(" ")[0].split("-")[2]+"/"+finishDate.split(" ")[0].split("-")[1]+"/"+finishDate.split(" ")[0].split("-")[0],
              style: TextStyle(color: Colors.grey, fontSize: 22.0),
            ),
          ),
          Spacer(),
          Column(
            children: <Widget>[
              Transform.translate(
                offset: Offset(48 * offset, 0),
                child: RaisedButton(
                  onPressed: this.style == 1 && this.capacity != 0
                      ? () {
                          showDialog(
                              context: context,
                              builder: (_) {
                                return AlertDialog(
                                  title: Text('Emin misiniz?'),
                                  content: Text('Etkinlige katılmak istediginizden emin misiniz?'),

                                  actions: [
                                    FlatButton(
                                      onPressed: ()
                                {
                                  Navigator.pop(context);
                                  showDialog(context: context,
                                  builder: (_){
                                    var height = MediaQuery.of(context).size.height;
                                    var width = MediaQuery.of(context).size.width;
                                    var eventTemp = Event(id: id); var user = User(name: SlidingCardsView.name,email: SlidingCardsView.email, tc: SlidingCardsView.tc,event: eventTemp);
                                    userService.addposts(user);

                                    return AlertDialog(title: Text("Tebrikler!"),content: Text("QR CODE giris kartınız ${SlidingCardsView.email} mail adresinize gönderilmistir. Etkinlik girisinde göstererek giris yapabilirsiniz."),actions: <Widget>[
                                      Container(height: 200, width: 450,
                                      child: QrImage(data:SlidingCardsView.name+" ismiyle "+this.name+" etkinliğine kayıt oldunuz!",),),
                                      FlatButton(
                                        onPressed: (){
                                          Navigator.pop(context);
                                          Navigator.push(context, MaterialPageRoute(builder: (context) => MyHomePage(SlidingCardsView.name,SlidingCardsView.tc,SlidingCardsView.email,SlidingCardsView.password,true)));
                                        },
                                        child: Text("Kapat"),
                                      ),
                                    ],);
                                  });

                                // passing true
                                },
                                      child: Text('Yes'),
                                      textColor: Colors.white,
                                    ),
                                    FlatButton(
                                      onPressed: () =>
                                          Navigator.pop(context),
                                      // passing false
                                      child: Text('No'),
                                      textColor: Colors.white,
                                    ),

                                  ],
                                  elevation: 24.0,
                                  backgroundColor: Colors.greenAccent,
                                );
                              });
                        }
                      : null,
                  color: Color(0xFF162A49),
                  child: this.style == 1
                      ? this.capacity != 0 ? Text("KATIL") : Text("KONTENJAN YOK")
                      : this.style == 2
                          ? Text("ZATEN KAYDINIZ BULUNMAKTA")
                          : Text("ETKINLIK GEÇMIS"),
                  textColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(32),
                  ),
                ),
              ),
              Transform.translate(
                offset: Offset(32 * offset, 0),
                child: Text(
                  this.capacity.toString() + " kontenjanımız var!",
                  style: TextStyle(
                    fontWeight: FontWeight.w100,
                    fontSize: 18,
                  ),
                ),
              ),
              SizedBox(height: 16),
            ],
          )
        ],
      ),
    );
  }
}
