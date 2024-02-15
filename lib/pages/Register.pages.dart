
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipe_app_level2/pages/signin..pages.dart';

import '../provider/app_auth.provider.dart';



class registerPage extends StatefulWidget {
  const registerPage({super.key});

  @override
  State<registerPage> createState() => _registerPageState();
}

class _registerPageState extends State<registerPage> {
  @override
  void initState() {
    Provider.of<AppAuthProvider>(context, listen: false).providerInit();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Consumer<AppAuthProvider>(
      builder: (context, authProvider, _) =>
        Form(
          key:authProvider.formKey
          ,child: Stack(children: [
            const SizedBox(
              width: 400,
              height: 1900,
              child: Image(
                  fit: BoxFit.cover,
                  color: Colors.black38,
                  colorBlendMode: BlendMode.darken,
                  image: AssetImage("images/splash.jpg")),
            ),
            const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(150, 60, 0, 240),
                  child: Text(
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontFamily: "Hellix"),
                      "Register"),
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(60, 40, 0, 0),
              child: const Image(
                  color: Colors.black12,
                  colorBlendMode: BlendMode.difference,
                  height: 270,
                  width: 270,
                  image: AssetImage("images/Logo.png")),
            ),
            Column(children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(50, 330, 0, 0),
                        child: SizedBox(
                          width: 285,
                          height: 50,
                          child: TextFormField(
                            controller: authProvider.nameController,
                            style: const TextStyle(color: Colors.white),
                            decoration: const InputDecoration(
                                prefixIcon: Icon(Icons.person_4_outlined,
                                    color: Colors.white, size: 30),
                                floatingLabelStyle: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    fontFamily: "Hellix"),
                                filled: false,
                                border: UnderlineInputBorder(),
                                hintStyle: TextStyle(color: Colors.white60),
                                hintText: "Full Name"),
                          ),
                        ),
                      ),
            ]),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(50, 395, 0, 0),
                        child: SizedBox(
                          width: 285,
                          height: 50,
                          child: TextFormField(
                              controller: authProvider.emailController,
                              style: const TextStyle(color: Colors.white),
                              decoration: const InputDecoration(
                                  prefixIcon: Icon(
                                    Icons.email_outlined,
                                    color: Colors.white,
                                    size: 30,
                                  ),
                                  floatingLabelStyle: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      fontFamily: "Hellix"),
                                  filled: false,
                                  border: UnderlineInputBorder(),
                                  hintStyle: TextStyle(color: Colors.white60),
                                  hintText: "Email Adress"),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'email is required';
                                }

                                if (!EmailValidator.validate(value)) {
                                  return 'Not Valid Email';
                                }
                                return null;
                              }
                           ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(50, 460, 0, 0),
                        child: SizedBox(
                          width: 285,
                          height: 50,
                          child: TextFormField(
                              obscureText: authProvider.obsecureText,
                              controller: authProvider.passwordController,
                              style: const TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                  prefixIcon: const Icon(
                                    Icons.lock_outline_rounded,
                                    color: Colors.white,
                                    size: 30,
                                  ),
                                  suffixIcon: InkWell(
                                      onTap: () => authProvider.toggleObsecure(),
                                      child: authProvider.obsecureText
                                      ?const Icon(
                                            Icons.visibility_off_outlined
                                        ,color: Colors.white, size: 30,)
                                      :const Icon(
                                             Icons.visibility,
                                        size: 30,
                                        color: Colors.white,
                                      ),),
                                  floatingLabelStyle: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      fontFamily: "Hellix"),
                                  filled: false,
                                  border: const UnderlineInputBorder(),
                                  hintStyle: const TextStyle(color: Colors.white60),
                                  hintText: "Password"),
                              validator: (value) {
                                if (value == null || (value?.isEmpty??false)) {
                                  return 'password is required';
                                }

                                if (value.length < 6) {
                                  return 'password too short';
                                }
                                return null;
                              }
                             ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(40, 590, 0, 0),
                        child: SizedBox(
                          width: 320,
                          height: 50,
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  backgroundColor: Colors.deepOrange),
                              onPressed: () {
                           authProvider.signUp(context);

                                }

                              ,child: const Text("Register",
                                  style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.white,
                                      fontFamily: "Hellix",
                                      fontWeight: FontWeight.bold))),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(80, 710, 0, 0),
                        child: Row(
                          children: [
                            const Text(
                              "Already registered?",
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                  fontFamily: "Hellix"),
                            ),
                            TextButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (contxt) => const SigninPage()));
                                },
                                child: const Text(
                                  "Sign in",
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.deepOrange,
                                      fontFamily: "Hellix",
                                      fontWeight: FontWeight.w100),
                                )),
                          ],
                        ),
                      )
                    ])
        )
      ),

        ),

    );
  }
}
