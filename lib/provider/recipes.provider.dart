import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:overlay_kit/overlay_kit.dart';

import '../models/recipes.models.dart';
import '../utils/toast_message_status.dart';
import '../widgets/toast_message.widgets.dart';


class RecipesProvider extends ChangeNotifier {

  var selectedUserValue = {};

var data;

  void getFilteredResult(selectedUserValue) async {
    Query<Map<String, dynamic>> ref = FirebaseFirestore.instance.collection('recipes');


    for (var entry in selectedUserValue.entries) {
   data=await ref.where(entry.key, isEqualTo: entry.value);
    }
    print('>>>>>>>>>>>>>Query: $ref');
    try {
      var result = await data.get();
      if (result.docs.isNotEmpty) {
        _filteredRecipesList = List<Recipe>.from(
            result.docs.map((doc) => Recipe.fromJson(doc.data(), doc.id)));
        print(">>>>>>>>>>>>>>>>>>>>.....${filteredRecipesList}");
      } else {
        _filteredRecipesList = [];
      }
      notifyListeners();
    } catch (e) {
      _filteredRecipesList = [];
      notifyListeners();
    }
  }
  List<Recipe>? _filteredRecipesList;

  List<Recipe>? get filteredRecipesList => _filteredRecipesList;

  List<Recipe>? _recipesList;

  List<Recipe>? get recipesList => _recipesList;

  List<Recipe>? _freshRecipesList;

  List<Recipe>? get freshRecipesList => _freshRecipesList;

  List<Recipe>? _recommandedRecipesList;

  List<Recipe>? get recommandedRecipesList => _recommandedRecipesList;

  Recipe? openedRecipe;

  Future<void> getSelectedRecipe(String recipeId) async {
    try {
      var result = await FirebaseFirestore.instance
          .collection('recipes')
          .doc(recipeId)
          .get();
      if (result.data() != null) {
        openedRecipe = Recipe.fromJson(result.data()!, result.id);
      } else {
        return;
      }
      notifyListeners();
    } catch (e) {
      print('>>>>>error in update recipe');
    }
  }




  Future<void> getRecipes() async {
    try {
      var result = await FirebaseFirestore.instance.collection('recipes').get();

      if (result.docs.isNotEmpty) {
        _recipesList = List<Recipe>.from(
            result.docs.map((doc) => Recipe.fromJson(doc.data(), doc.id)));
      } else {
        _recipesList = [];
      }
      notifyListeners();
    } catch (e) {
      _recipesList = [];
      notifyListeners();
    }
  }

  Future<void> getFreshRecipes() async {
    try {
      var result = await FirebaseFirestore.instance
          .collection('recipes')
          .where('isFresh', isEqualTo: true)
          .limit(5)
          .get();

      if (result.docs.isNotEmpty) {
        _freshRecipesList = List<Recipe>.from(
            result.docs.map((doc) => Recipe.fromJson(doc.data(), doc.id)));
      } else {
        _freshRecipesList = [];
      }
      notifyListeners();
    } catch (e) {
      _freshRecipesList = [];
      notifyListeners();
    }
  }

  Future<void> getRecommandedRecipes() async {
    try {
      var result = await FirebaseFirestore.instance
          .collection('recipes')
          .where('isFresh', isEqualTo: false)
          .limit(5)
          .get();
      if (result.docs.isNotEmpty) {
        _recommandedRecipesList = List<Recipe>.from(
            result.docs.map((doc) => Recipe.fromJson(doc.data(), doc.id)));
      } else {
        _recommandedRecipesList = [];
      }
      notifyListeners();
    } catch (e) {
      _recommandedRecipesList = [];
      notifyListeners();
    }
  }

  void addRecipeToUserRecentlyViewed(String recipeId) async {
    try {
      await FirebaseFirestore.instance
          .collection('recipes')
          .doc(recipeId)
          .update({
        "recently_viewd_users_ids":
        FieldValue.arrayUnion([FirebaseAuth.instance.currentUser?.uid])
      });
    } catch (e) {}
  }

  void removeRecipeToUserRecentlyViewed(String recipeId) async {
    try {
      await FirebaseFirestore.instance
          .collection('recipes')
          .doc(recipeId)
          .update({
        "recently_viewd_users_ids":
        FieldValue.arrayRemove([FirebaseAuth.instance.currentUser?.uid])
      });
    } catch (e) {}
  }

  Future<void> addRecipeToUserFavourite(String recipeId, bool isAdd) async {
    try {
      OverlayLoadingProgress.start();
      if (isAdd) {
        await FirebaseFirestore.instance
            .collection('recipes')
            .doc(recipeId)
            .update({
          "favorite_user_ids":
          FieldValue.arrayUnion([FirebaseAuth.instance.currentUser?.uid])
        });
      } else {
        await FirebaseFirestore.instance
            .collection('recipes')
            .doc(recipeId)
            .update({
          "favorite_user_ids":
          FieldValue.arrayRemove([FirebaseAuth.instance.currentUser?.uid])
        });
      }
      await _updateRecipe(recipeId);
      notifyListeners();
      OverlayLoadingProgress.stop();
    } catch (e) {
      OverlayLoadingProgress.stop();

      OverlayToastMessage.show(
        widget: ToastMessageWidget(
          message: 'Error : ${e.toString()}',
          toastMessageStatus: ToastMessageStatus.failed,
        ),
      );
    }
  }

  Future<void> _updateRecipe(String recipeId) async {
    try {
      var result = await FirebaseFirestore.instance
          .collection('recipes')
          .doc(recipeId)
          .get();
      Recipe? updatedRecipe;
      if (result.data() != null) {
        updatedRecipe = Recipe.fromJson(result.data()!, result.id);
      } else {
        return;
      }

      var recipesListIndex =
      recipesList?.indexWhere((recipe) => recipe.docId == recipeId);

      if (recipesListIndex != -1) {
        recipesList?.removeAt(recipesListIndex!);
        recipesList?.insert(recipesListIndex!, updatedRecipe);
      }

      var freshRecipesListIndex =
      freshRecipesList?.indexWhere((recipe) => recipe.docId == recipeId);

      if (freshRecipesListIndex != -1) {
        freshRecipesList?.removeAt(freshRecipesListIndex!);
        freshRecipesList?.insert(freshRecipesListIndex!, updatedRecipe);
      }

      var recommandedRecipesListIndex = recommandedRecipesList
          ?.indexWhere((recipe) => recipe.docId == recipeId);

      if (recommandedRecipesListIndex != -1) {
        recommandedRecipesList?.removeAt(recommandedRecipesListIndex!);
        recommandedRecipesList?.insert(
            recommandedRecipesListIndex!, updatedRecipe);
      }
      var filteredRecipesListIndex = filteredRecipesList
          ?.indexWhere((recipe) => recipe.docId == recipeId);

      if (filteredRecipesListIndex != -1) {
        filteredRecipesList?.removeAt(filteredRecipesListIndex!);
        filteredRecipesList?.insert(
            filteredRecipesListIndex!, updatedRecipe);
      }

      notifyListeners();
    } catch (e) {
      print('>>>>>error in update recipe');


    }
  }
}
