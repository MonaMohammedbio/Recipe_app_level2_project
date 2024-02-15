import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/app_auth.provider.dart';

class ForgetPasswordPage extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Forget Password"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                  border: const UnderlineInputBorder(borderSide: BorderSide(color:Colors.deepOrange)),
                  labelText: "Email",
                  labelStyle: TextStyle(color: Colors.deepOrange)),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Please enter your email";
                }
                return null;
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Provider.of<AppAuthProvider>(context, listen: false)
                    .resetPassword(emailController.text);
              },
              child: Text("Reset Password",
                  style: TextStyle(color: Colors.deepOrange)),
            ),
          ],
        ),
      ),
    );
  }
}
