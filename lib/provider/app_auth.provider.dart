import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'dart:typed_data';


import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:overlay_kit/overlay_kit.dart';
import 'package:recipe_app_level2/pages/Register.pages.dart';

import 'package:recipe_app_level2/pages/homepage.pages.dart';
import 'package:recipe_app_level2/pages/signin..pages.dart';

import '../utils/toast_message_status.dart';
import '../widgets/toast_message.widgets.dart';



class AppAuthProvider extends ChangeNotifier {
  GlobalKey<FormState>? formKey;
  TextEditingController? emailController;
  TextEditingController? passwordController;
  TextEditingController? nameController;
  bool obsecureText = true;

  void providerInit() {
    formKey = GlobalKey<FormState>();
    emailController = TextEditingController();
    passwordController = TextEditingController();
    nameController = TextEditingController();
  }

  void providerDispose() {
    emailController = null;
    passwordController = null;
    formKey = null;
    nameController = null;
    obsecureText = false;
  }

  void toggleObsecure() {
    obsecureText = !obsecureText;
    notifyListeners();
  }

  void openRegisterPage(BuildContext context) {
    providerDispose();
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (_) => const registerPage()));
  }

  void openLoginPage(BuildContext context) {
    providerDispose();
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (_) => const SigninPage()));
  }

  Future<void> signin(BuildContext context) async {
    try {
      if (formKey?.currentState?.validate() ?? false) {
        OverlayLoadingProgress.start();
        var credentials = await FirebaseAuth.instance
            .signInWithEmailAndPassword(
            email: emailController!.text,
            password: passwordController!.text);

        if (credentials.user != null) {
          OverlayLoadingProgress.stop();
          providerDispose();
          OverlayToastMessage.show(
            widget: const ToastMessageWidget(
              message: 'You Login Successully',
              toastMessageStatus: ToastMessageStatus.success,
            ),
          );

          if (context.mounted) {
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (_) => const HomePage()));
          }
        }
        OverlayLoadingProgress.stop();
      }
    } on FirebaseAuthException catch (e) {
      OverlayLoadingProgress.stop();

      if (e.code == 'user-not-found') {
        OverlayToastMessage.show(
          widget: const ToastMessageWidget(
            message: 'user not found',
            toastMessageStatus: ToastMessageStatus.failed,
          ),
        );
      } else if (e.code == 'wrong-password') {
        OverlayToastMessage.show(
            widget: const ToastMessageWidget(
              message: 'Wrong password provided for that user.',
              toastMessageStatus: ToastMessageStatus.failed,
            ));
      } else if (e.code == "user-disabled") {
        OverlayToastMessage.show(
            widget: const ToastMessageWidget(
              message: 'This email Account was disabled',
              toastMessageStatus: ToastMessageStatus.failed,
            ));
      } else if (e.code == "invalid-credential") {
        OverlayToastMessage.show(
            widget: const ToastMessageWidget(
              message: 'invalid-credential',
              toastMessageStatus: ToastMessageStatus.failed,
            ));
      }
    } catch (e) {
      OverlayLoadingProgress.stop();
      OverlayToastMessage.show(textMessage: 'General Error $e');
    }
  }
  Future<void> resetPassword(String email) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      OverlayToastMessage.show(
        widget: const ToastMessageWidget(
          message: 'Password reset email sent. Check your email inbox.',
          toastMessageStatus: ToastMessageStatus.success,
        ),
      );
    } catch (e) {
      OverlayToastMessage.show(
        widget: const ToastMessageWidget(
          message: 'Failed to send password reset email. Please try again.',
          toastMessageStatus: ToastMessageStatus.failed,
        ),
      );
    }
  }


  Future<void> signUp(BuildContext context) async {
    try {
      if (formKey?.currentState?.validate() ?? false) {
        OverlayLoadingProgress.start();
        var credentials = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
            email: emailController!.text,
            password: passwordController!.text);

        if (credentials.user != null) {
          await credentials.user?.updateDisplayName(nameController!.text);
          await credentials.user?.updatePhotoURL(FirebaseAuth.instance.currentUser?.photoURL??"no photo");
          OverlayLoadingProgress.stop();
          providerDispose();

          if (context.mounted) {
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (_) =>const SigninPage()));
          }
        }
        OverlayLoadingProgress.stop();
      }
    } catch (e) {
      OverlayLoadingProgress.stop();
    }
  }
  Future<void> editName(BuildContext context, String newName) async {
    try {
      OverlayLoadingProgress.start();
      User? currentUser = FirebaseAuth.instance.currentUser;
      await currentUser?.updateDisplayName(newName);
      OverlayLoadingProgress.stop();
      OverlayToastMessage.show(
        widget: const ToastMessageWidget(
          message: 'Your name has been updated successfully',
          toastMessageStatus: ToastMessageStatus.success,
        ),
      );
    } catch (e) {
      OverlayLoadingProgress.stop();
      OverlayToastMessage.show(
        widget: const ToastMessageWidget(
          message: 'Failed to update name. Please try again.',
          toastMessageStatus: ToastMessageStatus.failed,
        ),
      );
    }
  }
  Future<void> editUserImage(BuildContext context) async {
    try {
      OverlayLoadingProgress.start();
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: false,
      );

      if (result != null && result.files.isNotEmpty) {
        File file = File(result.files.single.path!);
        User? currentUser = FirebaseAuth.instance.currentUser;

        Reference ref = FirebaseStorage.instance
            .ref()
            .child('profile_images/${currentUser?.uid}.jpg');

        UploadTask uploadTask = ref.putFile(file);
        TaskSnapshot snapshot = await uploadTask.whenComplete(() => null);

        if (snapshot.state == TaskState.success) {
          String imageUrl = await ref.getDownloadURL();
          await currentUser?.updatePhotoURL(imageUrl);
          OverlayLoadingProgress.stop();
          OverlayToastMessage.show(
            widget: const ToastMessageWidget(
              message: 'Your profile image has been updated successfully',
              toastMessageStatus: ToastMessageStatus.success,
            ),
          );
        } else {
          throw Exception('Failed to upload image');
        }
      } else {
        OverlayLoadingProgress.stop();
        OverlayToastMessage.show(
          widget: const ToastMessageWidget(
            message: 'No image selected',
            toastMessageStatus: ToastMessageStatus.failed,
          ),
        );
      }
    } catch (e) {
      print('Error updating profile image: $e');
      OverlayLoadingProgress.stop();
      OverlayToastMessage.show(
        widget: const ToastMessageWidget(
          message: 'Failed to update profile image. Please try again.',
          toastMessageStatus: ToastMessageStatus.failed,
        ),
      );
    }
  }

  void signOut(BuildContext context) async {
    OverlayLoadingProgress.start();
    await Future.delayed(const Duration(seconds: 1));
    await FirebaseAuth.instance.signOut();
    if (context.mounted) {
      Navigator.pushAndRemoveUntil(context,
          MaterialPageRoute(builder: (_) =>const SigninPage()), (route) => false);
    }
    OverlayLoadingProgress.stop();
  }
}

