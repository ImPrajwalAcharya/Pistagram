import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pistagram/screens/login_screen.dart';
import 'package:pistagram/utils/colors.dart';
import 'package:pistagram/utils/globalvariables.dart';
import 'package:pistagram/utils/utils.dart';
import 'package:pistagram/widgets/text_field_input.dart';
import 'package:pistagram/resources/auth_methods.dart';

import '../responsive/mobile_screen_layout.dart';
import '../responsive/responsive.dart';
import '../responsive/web_screen_layout.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  Uint8List? _img;
  bool isloading = false;
  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _bioController.dispose();
    _usernameController.dispose();
  }

  void selectimage() async {
    Uint8List im = await pickImage(ImageSource.gallery);
    setState(() {
      _img = im;
    });
  }

  void signupuser() async {
    setState(() {
      isloading = true;
    });

    String res = await AuthMethods().signUpUser(
      email: _emailController.text,
      password: _passwordController.text,
      username: _usernameController.text,
      bio: _bioController.text,
      file: _img!,
    );
    setState(() {
      isloading = false;
    });
    showSnackBar(res, context);
    if(res=='Success✅'){
      
    Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (context) =>  ResponsiveLayout(
                    webSccreenLayout: webSccreenLayout(),
                    mobileSccreenLayout: mobileSccreenLayout())));
  
    }
  }
void navigateToLogin() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => LoginScreen()));
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
                height: 64,
              ),
              const SizedBox(
                height: 64,
              ),
              Stack(
                children: [
                  _img != null
                      ? CircleAvatar(
                          radius: 64,
                          backgroundImage: MemoryImage(_img!),
                          // NetworkImage(
                          // 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQOjfKv2jpnvF8QDHGaodU2Fj7cUZE1yTJ6Lg&usqp=CAU'),
                        )
                      : const CircleAvatar(
                          radius: 64,
                          backgroundImage: NetworkImage(
                              'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQOjfKv2jpnvF8QDHGaodU2Fj7cUZE1yTJ6Lg&usqp=CAU'),
                        ),
                  Positioned(
                      bottom: -10,
                      left: 80,
                      child: IconButton(
                        onPressed: () {
                          selectimage();
                        },
                        icon: const Icon(Icons.add_a_photo),
                      ))
                ],
              ),
              const SizedBox(
                height: 24,
              ),
              TextFieldInput(
                  textEditingController: _usernameController,
                  hintText: 'Enter Your Username',
                  textInputType: TextInputType.text),
              const SizedBox(
                height: 24,
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
              TextFieldInput(
                  textEditingController: _bioController,
                  hintText: 'Enter Your Bio',
                  textInputType: TextInputType.text),
              const SizedBox(
                height: 24,
              ),
              InkWell(
                onTap: signupuser,
                child: Container(
                  child: isloading
                      ? const Center(
                          child: CircularProgressIndicator(
                            color: primaryColor,
                          ),
                        )
                      : const Text('SignUp'),
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
                    child: Text("Already have an account?"),
                  ),
                  InkWell(
                    onTap:navigateToLogin,
                    child: Container(
                      child: Text(
                        "Login",
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
