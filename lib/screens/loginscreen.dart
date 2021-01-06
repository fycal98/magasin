import 'package:flutter/material.dart';
import 'dart:math';
import 'package:provider/provider.dart';
import '../authentication.dart';

class LoginScreen extends StatelessWidget {
  static const String route = 'LoginScreen';
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    bool islandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(children: [
          Container(
            width: size.width,
            height: islandscape ? size.height * 1.3 : size.height,
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Colors.purpleAccent, Colors.amber.shade200])),
          ),
          Center(
            child: Padding(
              padding: EdgeInsets.only(
                top: islandscape ? size.height * 0.1 : size.height * 0.2,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    transform: Matrix4.rotationZ(-8 * pi / 180)
                      ..translate(-10.0),
                    alignment: Alignment.center,
                    child: Text(
                      'MYSHOP',
                      style: TextStyle(
                          fontFamily: 'Anton',
                          fontSize: 40.0,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                    decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 8,
                            color: Colors.black26,
                            offset: Offset(0, 2),
                          )
                        ],
                        color: Colors.deepOrange.shade900,
                        borderRadius: BorderRadius.circular(15.0)),
                    width: islandscape ? size.width * 0.4 : size.width * 0.8,
                    height:
                        islandscape ? size.height * 0.15 : size.height * 0.1,
                  ),
                  AuthCard(size: size),
                ],
              ),
            ),
          )
        ]),
      ),
    );
  }
}

class AuthCard extends StatefulWidget {
  const AuthCard({
    Key key,
    @required this.size,
  }) : super(key: key);

  final Size size;

  @override
  _AuthCardState createState() => _AuthCardState();
}

class _AuthCardState extends State<AuthCard> with TickerProviderStateMixin {
  var authe = auth.login;
  TextEditingController emailcontroller = TextEditingController();
  TextEditingController passwordcontroller = TextEditingController();
  TextEditingController confirmcontroller = TextEditingController();
  var form = GlobalKey<FormState>();
  void authenticate() {
    if (form.currentState.validate()) {
      var p = Provider.of<Auth>(context, listen: false).authenticat(
          emailcontroller.value.text, passwordcontroller.value.text, authe);
    }
  }

  AnimationController confirmcontroler;
  Animation<double> confirmanimation;
  @override
  void dispose() {
    // TODO: implement dispose
    confirmcontroler.dispose();
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    confirmcontroler = AnimationController(
      duration: Duration(milliseconds: 600),
      vsync: this,
    );
    confirmanimation = CurvedAnimation(
      parent: confirmcontroler,
      curve: Curves.linear,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool islandscap =
        MediaQuery.of(context).orientation == Orientation.landscape;
    return AnimatedContainer(
      duration: Duration(milliseconds: 600),
      height: authe == auth.login
          ? islandscap
              ? widget.size.height * 0.6
              : widget.size.height * 0.35
          : islandscap
              ? widget.size.height * 0.7
              : widget.size.height * 0.4,
      child: Padding(
        padding: EdgeInsets.all(widget.size.width * 0.04),
        child: SingleChildScrollView(
          child: Form(
            key: form,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: emailcontroller,
                  textInputAction: TextInputAction.next,
                  validator: (value) {
                    if (!value.contains('@')) {
                      return 'Enter a valid Email';
                    }
                    return null;
                  },
                  decoration: InputDecoration(labelText: 'E-Mail'),
                ),
                TextFormField(
                  controller: passwordcontroller,
                  textInputAction: TextInputAction.next,
                  validator: (value) {
                    if (value.length < 6) {
                      return 'Enter a strong Password';
                    }
                    return null;
                  },
                  obscureText: true,
                  decoration: InputDecoration(labelText: 'Password'),
                ),
                authe == auth.login
                    ? SizedBox()
                    : SizeTransition(
                        sizeFactor: confirmanimation,
                        child: Container(
                          child: TextFormField(
                            controller: confirmcontroller,
                            textInputAction: TextInputAction.done,
                            validator: (value) {
                              if (confirmcontroller.value.text !=
                                  passwordcontroller.value.text) {
                                return 'Invalid Password';
                              }
                              return null;
                            },
                            obscureText: true,
                            decoration:
                                InputDecoration(labelText: 'Confirm Password'),
                          ),
                        ),
                      ),
                SizedBox(
                  height: widget.size.height * 0.02,
                ),
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: widget.size.width * 0.2),
                  child: RaisedButton(
                    onPressed: authenticate,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    color: Colors.purple,
                    elevation: 5,
                    child: Text(
                      authe == auth.login ? 'LOGIN' : 'SIGN UP',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      if (authe == auth.login) {
                        confirmcontroler.forward();
                      } else
                        confirmcontroler.reverse();
                      authe = authe == auth.login ? auth.signin : auth.login;
                    });
                  },
                  child: Text(
                    authe == auth.login ? 'SIGN IN INSTEAD' : 'LOGIN INSTEAD',
                    style: TextStyle(color: Colors.purple),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      margin: EdgeInsets.only(
        top: widget.size.height * 0.05,
      ),
      // height: size.height * 0.5,
      width: widget.size.width * 0.75,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15.0),
        boxShadow: [
          BoxShadow(
            blurRadius: 8,
            color: Colors.black26,
            offset: Offset(0, 2),
          )
        ],
      ),
    );
  }
}
