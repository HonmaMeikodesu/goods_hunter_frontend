import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:goods_hunter/api/index.dart';


enum AuthenticationMode { login, register }

class AuthenticationRoute extends StatefulWidget {
  const AuthenticationRoute({Key? key}): super(key: key);

  @override
  _AuthenticationRouterState createState() => _AuthenticationRouterState();
}

class _AuthenticationRouterState extends State<AuthenticationRoute> {

  AuthenticationMode loginOrRegister = AuthenticationMode.login;
  final GlobalKey<FormState> _registerFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _loginFormKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
              title: const Text("Welcome to goods hunter!"),
              bottom: const TabBar(
                tabs: <Widget>[
                  Tab(text: "登录"),
                  Tab(text: "注册")
                ],
              )
          ),
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: (
              TabBarView(
                  children: <Widget>[
                    LoginRouter(formKey: _loginFormKey),
                    RegisterRouter(
                      formKey: _registerFormKey,
                    ),
                  ]
              )
            ),
          ),
        ),
    );
  }
}

class LoginRouter extends StatelessWidget {

  LoginRouter({Key? key, required this.formKey}): super(key: key);

  GlobalKey<FormState> formKey;

  String email = "";
  String password = "";

  void onLoginSubmitted() {
    if(formKey.currentState!.validate()) {
      loginApi(email: email, password: password).then((value) => print("success"));
    }
  }

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
                hintText: "请输入邮箱地址",
              ),
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (v) {
                return (v != null && EmailValidator.validate(v.trim())) ? null : "邮箱地址不合法";
              },
              onChanged: (v) {
                email = v.trim();
              },
            ),
            TextFormField(
              keyboardType: TextInputType.visiblePassword,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(
                  icon: Icon(Icons.password, color: Colors.blue),
                  labelText: "密码",
                  hintText: "请输入密码"
              ),
              autovalidateMode: AutovalidateMode.onUserInteraction,
              onFieldSubmitted: (value) {
                print(value);
              },
              validator: (v) {
                var reg = RegExp(r"^\w{6,}$");
                return (v != null && reg.hasMatch(v)) ? null : "密码不合法";
              },
              obscureText: true,
              onChanged: (v) {
                password = v;
              },
            ),
            Padding(
              padding: EdgeInsets.all(16),
              child: Row(
                children: [
                  ElevatedButton(onPressed: (){
                    if(formKey.currentState!.validate()) {
                      onLoginSubmitted();
                    }
                  }, child: const Text("登录"))
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class RegisterRouter extends StatelessWidget {

  RegisterRouter({Key? key, required this.formKey}): super(key: key);

  GlobalKey<FormState> formKey;

  String email = "";
  String password = "";

  void onRegisterSubmitted() {
    if(formKey.currentState!.validate()) {
      registerApi(email: email, password: password).then((value) => print("success"));
    }
  }

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
                icon: Icon(Icons.email),
                labelText: "邮箱",
                hintText: "请输入你的常用邮箱",
              ),
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (v) {
                return (v != null &&  EmailValidator.validate(v.trim())) ? null : "邮箱地址不合法,请重新输入";
              },
              onChanged: (v) {
                email = v.trim();
              },
            ),
            TextFormField(
              keyboardType: TextInputType.visiblePassword,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(
                icon: Icon(Icons.password),
                labelText: "密码",
                hintText: "请输入你的密码,密码长度因大于等于6的中英文字符"
              ),
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (v) {
                var reg = RegExp(r"^\w{6,}$");
                return (v != null && reg.hasMatch(v)) ? null : "密码不合法,请重新输入";
              },
              obscureText: true,
              onChanged: (v) {
                password = v;
              },
            ),
            TextFormField(
              keyboardType: TextInputType.visiblePassword,
              textInputAction: TextInputAction.send,
              decoration: const InputDecoration(
                  icon: Icon(Icons.check),
                  labelText: "重复密码",
                  hintText: "请重复输入你的密码"
              ),
              obscureText: true,
              autovalidateMode: AutovalidateMode.onUserInteraction,
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
                      onRegisterSubmitted();
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