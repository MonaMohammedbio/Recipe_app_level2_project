import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:recipe_app_level2/pages/homepage.pages.dart';
import 'package:recipe_app_level2/pages/intro.pages.dart';





class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  StreamSubscription<User?>?_listener;
  @override
  void initState() {
    initSplash();
    super.initState();
  }

  void initSplash() async {
    await Future.delayed(const Duration(seconds: 3));
  _listener= FirebaseAuth.instance.authStateChanges().listen((user) {
     if (user==null){
       Navigator.pushReplacement(
           context, MaterialPageRoute(builder: (_) => const introPage()));
     }else{
       Navigator.pushReplacement(
           context, MaterialPageRoute(builder: (_) => const HomePage()));
     }
   });
  }
  @override
  void dispose(){
    _listener?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Stack(children: [
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
                padding:EdgeInsets.fromLTRB(110, 50,0,0),

                child: Text(
                textAlign: TextAlign.center,
                    style: TextStyle(
                         fontSize: 15, color: Colors.white,fontFamily:"Hellix",fontWeight: FontWeight.w100),
                    "Cooking Done The Easy Way"),
              ),
              CircularProgressIndicator(),
            ],
          ),


          Container(
            child: const Padding(
              padding: EdgeInsets.fromLTRB(60, 160,0,0),
              child: Image(
                color: Colors.black12,
              colorBlendMode: BlendMode.darken,
                  height: 270,
                  width:270,
                  image: AssetImage("images/Logo.png")),
            ),
          )
        ]),
      ),
    );
  }
}
