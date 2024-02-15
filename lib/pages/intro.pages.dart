import 'package:flutter/material.dart';
import 'package:recipe_app_level2/pages/Register.pages.dart';
import 'package:recipe_app_level2/pages/signin..pages.dart';

class introPage extends StatefulWidget {
  const introPage({super.key});

  @override
  State<introPage> createState() => _introPageState();
}

class _introPageState extends State<introPage> {
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
                padding: EdgeInsets.fromLTRB(110, 0,0,0),
                child: Text(
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 15, color: Colors.white,
                        fontFamily: "Hellix",
                        fontWeight: FontWeight.w100),
                    "Cooking Done The Easy Way"),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(60, 160,0,0),
            child: const Image(
                color: Colors.black12,
                colorBlendMode: BlendMode.darken,
                height: 270,
                width: 270,
                image: AssetImage("images/Logo.png")),
          ),
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(40, 610, 0, 0),
                child: SizedBox(
                  width: 330,
                  height: 50,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          backgroundColor: Colors.deepOrange),
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (contxt)=>const registerPage()));
                      },
                      child: const Text("Register",
                          style: TextStyle(
                            fontSize: 18,
                              color: Colors.white,
                              fontFamily: "Hellix",

                              fontWeight: FontWeight.w100))),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 0, 25),
                child: TextButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (contxt)=>const SigninPage()));
                    },
                    child: const Text(
                      "Sign in",style: TextStyle(fontSize:18,color: Colors.white,fontFamily: "Hellix",fontWeight: FontWeight.w100),
                    )),
              )
            ],
          )
        ]),
      ),
    );
  }
}
