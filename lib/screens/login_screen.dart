import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pistagram/resources/auth_methods.dart';
import 'package:pistagram/screens/signup_screen.dart';
import 'package:pistagram/utils/colors.dart';
import 'package:pistagram/utils/globalvariables.dart';
import 'package:pistagram/utils/utils.dart';
import 'package:pistagram/widgets/text_field_input.dart';

import '../responsive/mobile_screen_layout.dart';
import '../responsive/responsive.dart';
import '../responsive/web_screen_layout.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool isLoading = false;
  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  void loginUser() async {
    setState(() {
      isLoading = true;
    });
    String res = await AuthMethods().loginUser(
        email: _emailController.text, password: _passwordController.text);
    setState(() {
      isLoading = false;
    });
    showSnackBar(res, context);
     if(res=='Success✅'){
      
    Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (context) =>  ResponsiveLayout(
                    webSccreenLayout: webSccreenLayout(),
                    mobileSccreenLayout: mobileSccreenLayout())));
  
    }
  }

  void navigateToSignup() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => SignUpScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
            child: Container(
          padding:MediaQuery.of(context).size.width>webScreenSize?EdgeInsets.symmetric(horizontal:MediaQuery.of(context).size.width/3 )
          : EdgeInsets.symmetric(horizontal: 32),
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 64,
              ),
              // Image.asset('assets/ic_pistagram.png'),
              SvgPicture.asset(
                'assets/ic_pistagram.svg',
                color: primaryColor,
                height: 150,
              ),
              const SizedBox(
                height: 64,
              ),
              TextFieldInput(
                
                  textEditingController: _emailController,
                  hintText: 'Enter Your Email',
                  textInputType: TextInputType.emailAddress),
              const SizedBox(
                height: 24,
              ),
              TextFieldInput(
                  textEditingController: _passwordController,
                  hintText: 'Enter Your Password',
                  isPass: true,
                  textInputType: TextInputType.text),
              const SizedBox(
                height: 24,
              ),
              InkWell(
                onTap: loginUser,
                child: Container(
                  child: isLoading
                      ? Center(
                          child: CircularProgressIndicator(color: primaryColor),
                        )
                      : const Text('Login'),
                  width: double.infinity,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: const ShapeDecoration(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(4),
                        ),
                      ),
                      color: blueColor),
                ),
              ),
              const SizedBox(
                height: 12,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    child: Text("Don't have an account?"),
                  ),
                  InkWell(
                    onTap: navigateToSignup,
                    child: Container(
                      child: Text(
                        "Sign Up",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        )),
      ),
    );
  }
}
