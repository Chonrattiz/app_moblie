import 'dart:developer';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:my_first_app/config/config.dart';
import 'package:my_first_app/config/internal_config.dart';
import 'package:my_first_app/model/request/customer_login_post_req.dart';
import 'package:my_first_app/model/response/customer_login_post_res.dart';
import 'package:my_first_app/pages/RegisterPage.dart';
import 'package:my_first_app/pages/ShowTropPage.dart';

class LoginPage extends StatefulWidget {
  LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String text = '';
  int number = 0;
  String phoneNum = '';
  var phoneCtl = TextEditingController();
  var passwordCtl = TextEditingController();

  String url = '';

  @override
  void initState() {
    super.initState();
    Configuration.getConfig().then((config) {
      url = config['apiEndpoint'];
    });
  }

  //UI
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login Page')),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ListView(
              children: [
                InkWell(
                  onTap: () => login(),
                  child: Image.asset('assets/images/4444.jpg'),
                ),

                Padding(
                  padding: EdgeInsetsGeometry.only(
                    right: 30,
                    left: 30,
                    top: 30,
                  ),
                  child: Text(
                    "หมายเลขโทรศัพท์",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: EdgeInsetsGeometry.only(
                    right: 30,
                    left: 30,
                    bottom: 30,
                  ),
                  child: TextField(
                    controller: phoneCtl,
                    keyboardType: TextInputType.numberWithOptions(),
                    // onChanged: (value) {
                    //   log(value);
                    //   value = phoneNum;
                    // },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderSide: BorderSide(width: 5),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsetsGeometry.only(right: 30, left: 30),
                  child: Text(
                    "รหัสผ่าน",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: EdgeInsetsGeometry.only(
                    right: 30,
                    left: 30,
                    bottom: 30,
                  ),
                  child: TextField(
                    obscureText: true,
                    controller: passwordCtl,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderSide: BorderSide(width: 5),
                      ),
                    ),
                  ),
                ),
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        TextButton(
                          onPressed: register,
                          child: const Text('ลงทะเบียน'),
                        ),
                        FilledButton(
                          onPressed: login,
                          child: const Text('เข้าสูระบบ'),
                        ),
                      ],
                    ),
                    Text(text, style: TextStyle(fontSize: 20)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void register() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Registerpage()),
    );
  }

  void login() {
    // var data = {"phone": "0817399999", "password": "1111"};
    CustomerLoginPostRequest req = CustomerLoginPostRequest(
      phone: phoneCtl.text,
      password: passwordCtl.text,
      // phone: "0817399999",
      // password: "1111",
    );
    http
        .post(
          Uri.parse("$apiEndpoint/customers/login"),
          headers: {"Content-Type": "application/json; charset=utf-8"},
          body: customerLoginPostRequestToJson(req),
        )
        .then((value) {
          CustomerLoginPostResponse customerLoginPostResponse =
              customerLoginPostResponseFromJson(value.body);
          log(customerLoginPostResponse.customer.fullname);
          log(customerLoginPostResponse.customer.email);
          log(customerLoginPostResponse.customer.idx.toString());
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  Showtroppage(cid: customerLoginPostResponse.customer.idx),
            ),
          );
        })
        .catchError((error) {
          log('Error $error');
        });
  }
}
