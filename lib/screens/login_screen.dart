import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/constant.dart';
import 'package:shop_app/helpers/fade_animation.dart';
import 'package:shop_app/models/http_exception.dart';
import 'package:shop_app/providers/auth.dart';
import 'package:shop_app/screens/signUp_screen.dart';

class LoginTest extends StatefulWidget {
  const LoginTest({Key? key}) : super(key: key);

  @override
  _LoginTestState createState() => _LoginTestState();
}

class _LoginTestState extends State<LoginTest> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  var _isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Map<String, String> _authData = {
    'email': '',
    'password': '',
  };

  final _passwordController = TextEditingController();

  void _showErrorDialog(String? message) {
    showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20.0))),
              contentPadding: EdgeInsets.only(top: 8),
              titlePadding: EdgeInsets.only(top: 16),
              backgroundColor: Colors.white,
              elevation: 8,
              title: Text(
                'There\'s an error, try again!',
                style: Theme.of(context).textTheme.bodyText1!.copyWith(
                      fontSize: 16,
                      letterSpacing: 0.3,
                      fontWeight: FontWeight.w600,
                      color: colorCustom,
                    ),
                textAlign: TextAlign.center,
              ),
              content: Text(
                message!,
                style: Theme.of(context).textTheme.bodyText1!.copyWith(
                      fontSize: 16,
                      letterSpacing: 0.3,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                textAlign: TextAlign.center,
              ),
              actions: [
                TextButton(
                    onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
                    child: Text(
                      'OK',
                      style: Theme.of(context).textTheme.bodyText1!.copyWith(
                            fontSize: 14,
                            letterSpacing: 0.3,
                            fontWeight: FontWeight.w800,
                            color: colorCustom,
                          ),
                      textAlign: TextAlign.center,
                    ))
              ],
            ));
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      _showErrorDialog("Login Error");
      return;
    }
    _formKey.currentState!.save();
    setState(() {
      _isLoading = true;
    });

    try {
      await Provider.of<Auth>(context, listen: false)
          .login(_authData['email'], _authData['password']);
    } on HttpException catch (error) {
      var errorMessage = 'Authentication failed';
      if (error.toString().contains('EMAIL_EXISTS')) {
        errorMessage = 'Email is already use';
      } else if (error.toString().contains('INVALID_EMAIL')) {
        errorMessage = 'Invalid email or password';
      } else if (error.toString().contains('WEAK_PASSWORD')) {
        errorMessage = 'Invalid email or password';
      } else if (error.toString().contains('EMAIL_NOT_FOUND')) {
        errorMessage = 'Invalid email or password';
      } else if (error.toString().contains('INVALID_PASSWORD')) {
        errorMessage = 'Invalid email or password';
      }
      _showErrorDialog(errorMessage);
    } catch (error) {
      const errorMessage =
          'Could not authenticate you, please try again later.';
      _showErrorDialog(errorMessage);
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
              gradient: LinearGradient(begin: Alignment.topCenter, colors: [
            colorCustom,
            colorCustom,
            colorCustom,
          ])),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: 80,
              ),
              Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    FadeAnimation(
                        1,
                        Text(
                          "Welcome to TaniKu",
                          style: TextStyle(
                              // color: Colors.white,
                              fontSize: 40,
                              fontWeight: FontWeight.bold),
                        )),
                    SizedBox(
                      height: 10,
                    ),
                    FadeAnimation(
                        1.3,
                        Text(
                          "Sign in to your account",
                          style: TextStyle(
                            // color: Colors.white,
                            fontSize: 18,
                          ),
                        )),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(60),
                          topRight: Radius.circular(60))),
                  child: Padding(
                    padding: EdgeInsets.only(
                        left: 30, right: 30, top: 20, bottom: 8),
                    child: Column(
                      children: <Widget>[
                        const Spacer(),
                        FadeAnimation(
                          1.4,
                          Form(
                            key: _formKey,
                            child: Column(
                              children: <Widget>[
                                Container(
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(20),
                                      boxShadow: [
                                        BoxShadow(
                                          blurRadius: 3,
                                          spreadRadius: 3,
                                          offset: const Offset(1, 1),
                                          color: Colors.grey.withOpacity(0.4),
                                        )
                                      ]),
                                  child: TextFormField(
                                    autofocus: false,
                                    decoration: InputDecoration(
                                      hintText: 'Your email',
                                      prefixIcon:
                                          Icon(Icons.email, color: colorCustom),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                          color: Colors.white,
                                          width: 1.0,
                                        ),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                          color: Colors.white,
                                          width: 1.0,
                                        ),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                    ),
                                    keyboardType: TextInputType.emailAddress,
                                    validator: (value) {
                                      if (value!.isEmpty ||
                                          !value.contains('@')) {
                                        // return "Email invalid";
                                      }
                                      print(value);
                                      return null;
                                    },
                                    onSaved: (value) {
                                      _authData['email'] = value!;
                                    },
                                  ),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(20),
                                      boxShadow: [
                                        BoxShadow(
                                          blurRadius: 3,
                                          spreadRadius: 3,
                                          offset: const Offset(1, 1),
                                          color: Colors.grey.withOpacity(0.4),
                                        )
                                      ]),
                                  child: TextFormField(
                                    autofocus: false,
                                    decoration: InputDecoration(
                                      hintText: 'Your password',
                                      prefixIcon:
                                          Icon(Icons.lock, color: colorCustom),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                          color: Colors.white,
                                          width: 1.0,
                                        ),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                          color: Colors.white,
                                          width: 1.0,
                                        ),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                    ),
                                    obscureText: true,
                                    controller: _passwordController,
                                    validator: (value) {
                                      if (value!.isEmpty || value.length < 5) {
                                        // return "Password at least 6 character";
                                      }
                                      print(value);
                                      return null;
                                    },
                                    onSaved: (value) {
                                      _authData['password'] = value!;
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const Spacer(),
                        FadeAnimation(
                          1.6,
                          _isLoading
                              ? CircularProgressIndicator.adaptive()
                              : InkWell(
                                  borderRadius: BorderRadius.circular(20),
                                  child: Container(
                                    height: 50,
                                    width:
                                        MediaQuery.of(context).size.width * 0.4,
                                    decoration: BoxDecoration(
                                      color: colorCustom,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: const Center(
                                      child: Text(
                                        'Sign in',
                                        style: TextStyle(
                                          // color: Colors.white,
                                          fontSize: 22,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                  ),
                                  onTap: () {
                                    _submit();
                                  }),
                        ),
                        const Spacer(),
                        FadeAnimation(
                          1.7,
                          Container(
                            margin: EdgeInsets.only(bottom: 8),
                            child: RichText(
                              text: TextSpan(
                                text: 'Don\'t have an account?',
                                style: TextStyle(
                                  color: Colors.black.withOpacity(0.5),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                                children: [
                                  TextSpan(
                                    text: ' Sign Up',
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        Navigator.of(context)
                                            .pushNamed(SignUpTest.routeName);
                                      },
                                    style: TextStyle(
                                      color: colorCustom,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
