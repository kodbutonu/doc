import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:shared_preferences/shared_preferences.dart';

import 'Login.dart';
import 'menu.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var EmailAddress = "";
  var UserPassword = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange,
      appBar: AppBar(
        backgroundColor: Colors.orange,
        automaticallyImplyLeading: false,
        title: Text(
          "Kullanıcı Girişi",
          style: TextStyle(
            fontSize: 24,
            fontStyle: FontStyle.italic,
            color: Colors.white,
          ),
        ),
      ),
      body: ListView(
        children: <Widget>[
          Container(
            child: Image.asset(
              "images/cook.png",
            ),
            margin: EdgeInsets.only(top: 10),
            height: 80,
            width: 80,
          ),
          SizedBox(
            height: 15,
          ),
          FractionallySizedBox(
            widthFactor: 0.7,
            child: TextField(
//              margin: EdgeInsets.all(20),
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.done,
              autofocus: true,
              onChanged: (text) => setState(() {
                EmailAddress = text;
              }),
              decoration: InputDecoration(
                fillColor: Colors.white,
                filled: true,
                labelText: "E-posta Adresi",
                labelStyle: TextStyle(fontSize: 10, color: Colors.black),
                hintText: "",
                icon: Icon(Icons.email),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(4.0))),
              ),
            ),
          ),
          Text(" "),
          SizedBox(
            height: 4,
          ),
          FractionallySizedBox(
              widthFactor: 0.7,
              child: TextField(
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.done,
                  onChanged: (text) => setState(() {
                        UserPassword = text;
                      }),
                  decoration: InputDecoration(
                    fillColor: Colors.white,
                    filled: true,
                    labelText: "Şifre",
                    labelStyle: TextStyle(fontSize: 10, color: Colors.black),
                    hintText: "",
                    icon: Icon(Icons.password),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(4.0))),
                  ))),
          Container(
            alignment: Alignment.center,
            margin: const EdgeInsets.only(left: 80.0, right: 80.0),
            height: 64,
            width: 80,
            child: ElevatedButton(
                onPressed: () async {
                  var post_data = new Map<String, dynamic>();
                  post_data['email'] = EmailAddress;
                  post_data['password'] = UserPassword;

                  final response = await http.post(
                      Uri.parse(
                          'http://flutter-api.fatihsari.net/giris_yap.php'),
                      body: post_data);

                  LoginResponse login_result =
                      LoginResponse.fromJson(jsonDecode(response.body));

                  if (login_result.result) {
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();

                    prefs.setBool("isLoggedIn", true);
                    prefs.setString("userName", login_result.name);
                    prefs.setString("userId", login_result.user_id);

                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => menu()));
                  } else {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text("Giriş Başarısız"),
                          content: Text(
                              "Girmiş olduğunuz e-posta adresi ve şifreyi kontrol ederek yeniden deeneyiniz."),
                        );
                      },
                    );
                  }
                },
                style: ElevatedButton.styleFrom(primary: Colors.black),
                child: Text(
                  "Giriş yap",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                )),
          ),
          SizedBox(
            height: 4,
          ),
          Center(
            child: ElevatedButton(
              onPressed: () {},
              child: Text('Uye ol',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          )
        ],
      ),
    );
  }
}
