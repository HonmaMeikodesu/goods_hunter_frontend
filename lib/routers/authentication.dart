import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:goods_hunter/api/index.dart';


enum AuthenticationMode { login, register }

class AuthenticationRoute extends StatefulWidget {
  const AuthenticationRoute({Key? key}): super(key: key);

  @override
  _AuthenticationRouterState createState() => _AuthenticationRouterState();
}

void _showLoading(BuildContext context, String title) {
  showDialog(context: context, barrierDismissible: false, builder: (context) {
    return AlertDialog(
      content: Column(
        children: [
          const CircularProgressIndicator(),
          Padding(
            padding: const EdgeInsets.only(top: 26.0),
            child: Text(title),
          )
        ],
      ),
    );
  });
}

void _showSuccess({required BuildContext context,required String title, required void callback()}) {
  ScaffoldMessenger.of(context)
    .showSnackBar(SnackBar(content: Text(title)))
      .closed.then((value) => callback());
}

class _AuthenticationRouterState extends State<AuthenticationRoute> {

  AuthenticationMode loginOrRegister = AuthenticationMode.login;

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
          body: const Padding(
            padding: EdgeInsets.all(16),
            child: (
              TabBarView(
                  children: <Widget>[
                    LoginRouter(),
                    RegisterRouter(),
                  ]
              )
            ),
          ),
        ),
    );
  }
}

class _LoginRouterState extends State<LoginRouter> {

  String email = "";
  String password = "";

  void onLoginSubmitted(BuildContext context) {
    if(Form.of(context)!.validate()) {
      loginApi(email: email, password: password).then((value) => print("success"));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Form(
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
                setState(() {
                  password = v;
                });
              },
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Builder(builder: (context) {
                    return ElevatedButton(onPressed: (){
                      if(Form.of(context)!.validate()) {
                        onLoginSubmitted(context);
                      }
                    }, child: const Text("登录"));
                  })
                ],
              ),
            )
          ],
        ),
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

  void onRegisterSubmitted(BuildContext context) {
    if(Form.of(context)!.validate()) {
      _showLoading(context, "登录中");
      registerApi(email: email, password: password).then((_) {
        Navigator.of(context).pop();
        _showSuccess(context: context, title: "登录成功", callback:  (){ Navigator.pop(context); });
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    return Center(
      child: Form(
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
                  Builder(builder: (context) {
                    return ElevatedButton(onPressed: (){
                      if(Form.of(context)!.validate()) {
                        onRegisterSubmitted(context);
                      }
                    }, child: const Text("注册"));
                  })

                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
class RegisterRouter extends StatefulWidget {
  const RegisterRouter({Key? key}) : super(key: key);

  @override
  State<RegisterRouter> createState() => _RegisterRouterState();
}