import 'package:flutter/material.dart';
import 'package:flutter_login_signup/src/loginPage.dart';
import 'package:flutter_login_signup/src/model/Member.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';

import 'services/MemberService.dart';

class SignUpPage extends StatefulWidget {
  SignUpPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  String _name;
  String _tc;
  String _email;
  String _password;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  MemberService memberService = MemberService.getInstance();
  List<Member> members = [];

  Widget _entryField(String title, {bool isPassword = false}) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          SizedBox(
            height: 10,
          ),
          TextField(
              obscureText: isPassword,
              decoration: InputDecoration(
                  border: InputBorder.none,
                  fillColor: Color(0xfff3f3f4),
                  filled: true))
        ],
      ),
    );
  }

  signUp() async {
    var member = Member(
        name: _name, tc: _tc, email: _email, password: _password);
    memberService.addposts(member);
  }

  Future<void> redirect() {
// Imagine that this function is fetching user info but encounters a bug
    return Future.delayed(
        Duration(seconds: 1),
        () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => LoginPage()),
            ).then((value) => setState(() {})));
  }

  Widget _submitButton() {
    return InkWell(
        onTap: () {
          //Navigator.push(context, MaterialPageRoute(builder: (context) => WelcomePage()));
          if (!_formKey.currentState.validate()) {
            return;
          }
          _formKey.currentState.save();
          signUp();
          Fluttertoast.showToast(
              msg: "Kayıt başarılı, giriş sayfasına yönlendirileceksiniz.",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              backgroundColor: Colors.blue);
              _formKey.currentState.reset();
              redirect();
        },
        child: Container(
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.symmetric(vertical: 15),
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
            'Kayıt Ol',
            style: TextStyle(fontSize: 20, color: Colors.white),
          ),
        ));
  }

  Widget _loginAccountLabel() {
    return InkWell(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => LoginPage()));
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 20),
        padding: EdgeInsets.all(15),
        alignment: Alignment.bottomCenter,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Hesabınız zaten var mı?',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              'Giris Yap',
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

  Widget _buildName() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Icon(Icons.person),
              Text(
                "    " + "Isim Soyisim",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
            ],
          ),
          SizedBox(
            height: 2,
          ),
          TextFormField(
            decoration: InputDecoration(
                border: InputBorder.none,
                fillColor: Color(0xfff3f3f4),
                filled: true,),
            validator: (String value) {
              if (value.isEmpty) {
                return 'Isim ve soyisim bos bırakılamaz';
              }
            },
            onSaved: (String value) {
              _name = value;
            },
          ),
        ],
      ),
    );
  }

  loadMembers() async {
    members = await memberService.getposts();
  }

  Widget _buildTc() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Icon(Icons.face),
              Text(
                "    " + "Tc Kimlik No",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
            ],
          ),
          SizedBox(
            height: 2,
          ),
          TextFormField(
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              border: InputBorder.none,
              fillColor: Color(0xfff3f3f4),
              filled: true,),
            validator: (String value) {
              if (isValidTckn(value) == false) {
                return "Lütfen geçerli formatta bir tc kimlik numarası giriniz!";
              }

              for (int i = 0; i < members.length; i++) {
                if (members[i].tc == value) {
                  return 'Zaten bu tc kimlik numarasıyla kayıtlı biri var';
                }
              }
            },
            onSaved: (String value) {
              _tc = value;
            },
          ),
        ],
      ),
    );

  }

 bool isValidTckn(String tckn) {
     if (tckn.length == 11) {
       int totalOdd = 0;

       int totalEven = 0;

       for (int i = 0; i < 9; i++) {
         int val = int.parse(tckn.substring(i, i + 1));

         if (i % 2 == 0) {
           totalOdd += val;
         } else {
           totalEven += val;
         }
       }

       int total = totalOdd + totalEven + int.parse(tckn.substring(9, 10));

       int lastDigit = total % 10;

       if (tckn.substring(10) == lastDigit.toString()) {
         int check = (totalOdd * 7 - totalEven) % 10;

         if (tckn.substring(9, 10) == check.toString()) {
           return true;
         }
       }
     }
     return false;
   }

  bool validateEmail(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    return (!regex.hasMatch(value)) ? false : true;
  }

  Widget _buildEmail() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Icon(Icons.email),
              Text(
                "    " + "Email",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
            ],
          ),
          SizedBox(
            height: 2,
          ),
          TextFormField(
            decoration: InputDecoration(
              border: InputBorder.none,
              fillColor: Color(0xfff3f3f4),
              filled: true,),
            validator: (String value) {
              if (validateEmail(value) == false) {
                return "Lütfen geçerli formatta bir mail adresi giriniz!";
              }
              for (int i = 0; i < members.length; i++) {
                if (members[i].email == value) {
                  return 'Zaten bu mail adresiyle kayıtlı biri var';
                }
              }
            },
            onSaved: (String value) {
              _email = value;
            },
          ),
        ],
      ),
    );

  }

  Widget _buildPassword() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Icon(Icons.security),
              Text(
                "    " + "Password",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
            ],
          ),
          SizedBox(
            height: 2,
          ),
          TextFormField(
            decoration: InputDecoration(
              border: InputBorder.none,
              fillColor: Color(0xfff3f3f4),
              filled: true,),
            validator: (String value) {
              if (value.length < 6) {
                return "Password en az 6 karakter olmalıdır";
              }
            },
            onSaved: (String value) {
              _password = value;
            },
            obscureText: true,
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    asyncInitState();
  }

  asyncInitState() async {
    members = await memberService.getposts();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Kayıt Ol"),
        flexibleSpace: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: <Color>[Colors.pinkAccent, Colors.grey])),
        ),
      ),
      body: Container(
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
                    SizedBox(
                      height: 25,
                    ),
                    Form(
                      key: _formKey,
                      child: Column(
                        children: <Widget>[
                          _buildName(),
                          _buildTc(),
                          _buildEmail(),
                          _buildPassword(),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    _submitButton(),
                    _loginAccountLabel(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
