import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';


enum AuthenticationMode { login, register }

class AuthenticationRoute extends StatefulWidget {
  const AuthenticationRoute({Key? key}): super(key: key);

  @override
  _AuthenticationRouterState createState() => _AuthenticationRouterState();
}

class _AuthenticationRouterState extends State<AuthenticationRoute> {

  AuthenticationMode loginOrRegister = AuthenticationMode.login;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("注册/登陆")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: (
          RegisterRouter(
            formKey: _formKey,
          )
        ),
      ),
    );
  }
}

class LoginRoute extends StatelessWidget {



  @override
  Widget build(BuildContext context) {
    return Text("123");
  }
}

class RegisterRouter extends StatelessWidget {

  RegisterRouter({Key? key, required this.formKey}): super(key: key);

  GlobalKey<FormState> formKey;

  String email = "";
  String password = "";

  @override
  Widget build(BuildContext context) {

    return Center(
      child: Form(
        key: formKey,
        child: Column(
          children: [
            TextFormField(
              autofocus: true,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(
                icon: Icon(Icons.email, color: Colors.blue),
                labelText: "邮箱",
                hintText: "请输入你的常用邮箱",
              ),
              validator: (v) {
                return EmailValidator.validate(v!.trim()) ? null : "邮箱地址不合法,请重新输入";
              },
              onChanged: (v) {
                email = v!.trim();
              },
            ),
            TextFormField(
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(
                icon: Icon(Icons.password, color: Colors.blue),
                labelText: "密码",
                hintText: "请输入你的密码,密码长度因大于等于6的中英文字符"
              ),
              validator: (v) {
                var reg = RegExp(r"^\w{6,}$");
                return reg.hasMatch(v!) ? null : "密码不合法,请重新输入";
              },
              onChanged: (v) {
                password = v;
              },
            ),
            TextFormField(
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.send,
              decoration: const InputDecoration(
                  icon: Icon(Icons.check, color: Colors.blue),
                  labelText: "重复密码",
                  hintText: "请重复输入你的密码"
              ),
              validator: (v) {
                return (v == password) ? null : "两次密码输入不一致,请重新输入";
              },
            ),
            Padding(
              padding: EdgeInsets.all(16),
              child: Row(
                children: [
                  ElevatedButton(onPressed: (){
                    if(formKey.currentState!.validate()) {
                      print("submitted");
                    }
                  }, child: const Text("注册"))
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}