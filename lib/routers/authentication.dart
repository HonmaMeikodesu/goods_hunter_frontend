import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:goods_hunter/api/index.dart';
import 'package:goods_hunter/utils/popup.dart';


class AuthenticationRoute extends StatefulWidget {
  const AuthenticationRoute({Key? key}): super(key: key);

  @override
  _AuthenticationRouterState createState() => _AuthenticationRouterState();
}

class _AuthenticationRouterState extends State<AuthenticationRoute> {

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
          body: const TabBarView(
              children: <Widget>[
                Padding(padding: EdgeInsets.all(16), child: LoginRouter()),
                Padding(padding: EdgeInsets.all(16), child: RegisterRouter()),
              ]
          ),
        ),
    );
  }
}

class _LoginRouterState extends State<LoginRouter> {

  String email = "";
  String password = "";

  void onLoginSubmitted(BuildContext context) async {
    if(Form.of(context)!.validate()) {
      try {
        showLoading(context, "登录中");
        await loginApi(email: email, password: password, context: context).then((_) {
          showMessage(
              context: context,
              title: "登录成功",
              callback: (){
                Navigator.pop(context);
              });
        });
      } finally {
        Navigator.of(context).pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
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
              setState(() {
                email = v.trim();
              });
            },
          ),
          Builder(builder: (context) {
            return TextFormField(
              keyboardType: TextInputType.visiblePassword,
              textInputAction: TextInputAction.send,
              decoration: const InputDecoration(
                  icon: Icon(Icons.password, color: Colors.blue),
                  labelText: "密码",
                  hintText: "请输入密码"
              ),
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (v) {
                var reg = RegExp(r"^\w{6,}$");
                return (v != null && reg.hasMatch(v)) ? null : "密码不合法";
              },
              onFieldSubmitted: (password) {
                onLoginSubmitted(context);
              },
              obscureText: true,
              onChanged: (v) {
                setState(() {
                  password = v;
                });
              },
            );
          }),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Builder(builder: (context) {
              return ElevatedButton(onPressed: (){
                if(Form.of(context)!.validate()) {
                  onLoginSubmitted(context);
                }
              }, child: const Text("登录"));
            }),
          )
        ],
      ),
    );
  }
}

class LoginRouter extends StatefulWidget {
  const LoginRouter({Key? key}) : super(key: key);

  @override
  State<LoginRouter> createState() => _LoginRouterState();
}


class _RegisterRouterState extends State<RegisterRouter> {
  String email = "";
  String password = "";

  void onRegisterSubmitted(BuildContext context) async {
    if(Form.of(context)!.validate()) {
      showLoading(context, "注册中");
      try {
        await registerApi(email: email, password: password, context: context).then((_) {
          showMessage(context: context, title: "注册成功", callback:  (){
            DefaultTabController.of(context)?.index = 0;
          });
        });
      } finally {
        Navigator.of(context).pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
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
              setState(() {
                email = v.trim();
              });
            },
          ),
          TextFormField(
            keyboardType: TextInputType.visiblePassword,
            textInputAction: TextInputAction.next,
            decoration: const InputDecoration(
                icon: Icon(Icons.password),
                labelText: "密码",
                hintText: "请输入你的密码,密码长度应是大于等于6的中英文字符"
            ),
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: (v) {
              var reg = RegExp(r"^\w{6,}$");
              return (v != null && reg.hasMatch(v)) ? null : "密码不合法,请重新输入";
            },
            obscureText: true,
            onChanged: (v) {
              setState(() {
                password = v;
              });
            },
          ),
          Builder(builder: (context) {
            return TextFormField(
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
              onFieldSubmitted: (password) {
                onRegisterSubmitted(context);
              },
            );
          }),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Builder(builder: (context) {
              return ElevatedButton(onPressed: (){
                if(Form.of(context)!.validate()) {
                  onRegisterSubmitted(context);
                }
              }, child: const Text("注册"));
            }),
          )
        ],
      ),
    );
  }
}
class RegisterRouter extends StatefulWidget {
  const RegisterRouter({Key? key}) : super(key: key);

  @override
  State<RegisterRouter> createState() => _RegisterRouterState();
}