import 'package:flutter/material.dart';
import 'package:flutter_login_signup/src/home_page.dart';
import 'package:flutter_login_signup/src/model/Member.dart';
import 'package:flutter_login_signup/src/services/MemberService.dart';
import 'package:flutter_login_signup/src/signup.dart';
import 'package:flutter_login_signup/src/welcomePage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fluttertoast/fluttertoast.dart';


class LoginPage extends StatefulWidget {
  LoginPage({Key key, this.title}) : super(key: key);

  final String title;


  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String _name;
  String _tc;
  String _email;
  String _password;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  MemberService memberService = MemberService.getInstance();
  List<Member> members=[];

  Widget _backButton() {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(left: 0, top: 10, bottom: 10),
              child: Icon(Icons.keyboard_arrow_left, color: Colors.black),
            ),
            Text('Back',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500))
          ],
        ),
      ),
    );
  }

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('HATA'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Hatali giris, lutfen bilgilerinizi dogru girdiginizden emin olun.'),

              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Kapat'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  signIn() async{
  List list = await memberService.getposts();
  int control = 0;
  for(int i = 0; i < list.length; i++){
      if(list[i].password == _password && list[i].email == _email){
            control = 1;
            _name = list[i].name;
            _tc = list[i].tc;
            break;
        }
  }
  if(control == 0){
    _showMyDialog();

  }
  else{
    Navigator.push(context, MaterialPageRoute(builder: (context) => MyHomePage(_name,_tc,_email,_password,false)));
  }
}

  Widget _submitButton() {
    return InkWell(
        onTap: () {
          //Navigator.push(context, MaterialPageRoute(builder: (context) => WelcomePage()));
          signIn();
        },
    child: Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.symmetric(vertical: 10),
      alignment: Alignment.center,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(5)),
          boxShadow: <BoxShadow>[
            BoxShadow(
                color: Colors.grey.shade200,
                offset: Offset(2, 4),
                blurRadius: 5,
                spreadRadius: 2)
          ],
          gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [Colors.pinkAccent, Colors.blueGrey])),
      child: Text(
        'Login',
        style: TextStyle(fontSize: 20, color: Colors.white),
      ),
    )
    );

  }


  Widget _createAccountLabel() {
    return InkWell(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => SignUpPage()));
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 20),
        padding: EdgeInsets.all(15),
        alignment: Alignment.bottomCenter,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Hesabınız yok mu?',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              'Buradan üye olabilirsiniz.',
              style: TextStyle(
                  color: Colors.pinkAccent,
                  fontSize: 13,
                  fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }

  Widget _title() {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
          text: 'Etkinlik',
          style: GoogleFonts.portLligatSans(
            textStyle: Theme.of(context).textTheme.display1,
            fontSize: 30,
            fontWeight: FontWeight.w700,
            color: Colors.pinkAccent,
          ),
          children: [
            TextSpan(
              text: 'Yönetim',
              style: TextStyle(color: Colors.blueGrey, fontSize: 30),
            ),
            TextSpan(
              text: 'Sistemi',
              style: TextStyle(color: Colors.pinkAccent, fontSize: 30),
            ),
          ]),
    );
  }

  Widget _entryField(String title, {bool isPassword = false}) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Icon(title == "Email" ? Icons.email : Icons.security),
              Text(
                "    "+title,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
            ],
          ),


          SizedBox(
            height: 2,
          ),
          TextFormField(
              obscureText: isPassword,
              decoration: InputDecoration(
                  border: InputBorder.none,
                  fillColor: Color(0xfff3f3f4),
                  filled: true),
                  onChanged: (String value){

                    if(title == "Email"){
                      _email = value;
                    }
                    else{
                      _password = value;
                    }
                    _formKey.currentState.save();
                  },
           ),

        ],
      ),
    );
  }

  Widget _emailPasswordWidget() {
    return Column(
      children: <Widget>[
        _entryField("Email"),
        _entryField("Password", isPassword: true),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Giriş Yap"),
        flexibleSpace: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: <Color>[
                    Colors.pinkAccent,
                    Colors.grey
                  ])
          ),
        ),
      ),
        body:
        Container(
      height: height,
      child: Stack(
        children: <Widget>[
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(height: height * .05),
                  _title(),
                  SizedBox(height: 25),
                  _emailPasswordWidget(),
                  SizedBox(height: 10),
                  _submitButton(),
                  SizedBox(height: height * .005),
                  _createAccountLabel(),
                ],
              ),
            ),
          ),
        ],
      ),
    ));
  }
}
