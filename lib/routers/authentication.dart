import 'package:flutter/material.dart';


enum AuthenticationMode { login, register }

class AuthenticationRoute extends StatefulWidget {
  const AuthenticationRoute({Key? key}): super(key: key);

  @override
  _AuthenticationRouterState createState() => _AuthenticationRouterState();
}

class _AuthenticationRouterState extends State<AuthenticationRoute> {

  AuthenticationMode loginOrRegister = AuthenticationMode.login;
  GlobalKey _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("注册/登陆")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: (
          Text("2")
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

  @override
  Widget build(BuildContext context) {

    return Center(
      child: Form(
        child: Column(
          children: [
            TextFormField(

            )
          ],
        ),
      ),
    );
  }
}