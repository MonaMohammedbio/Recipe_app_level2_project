import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';

import '../models/ingredients.models.dart';
import '../models/recipes.models.dart';
import '../provider/recipes.provider.dart';

class RecipeDetailsPage extends StatefulWidget {
  final Recipe recipe;
  const RecipeDetailsPage({required this.recipe, super.key});

  @override
  State<RecipeDetailsPage> createState() => _RecipeDetailsPageState();
}

class _RecipeDetailsPageState extends State<RecipeDetailsPage> {
  @override
  void initState() {
    Provider.of<RecipesProvider>(context, listen: false)
        .addRecipeToUserRecentlyViewed(widget.recipe.docId!);
    super.initState();
  }

  bool get isInList => (widget.recipe.favorite_user_ids
          ?.contains(FirebaseAuth.instance.currentUser?.uid) ??
      false);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        title: Text('Recipe Details page'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: SingleChildScrollView(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(widget.recipe.type ?? 'No Type',
                style: TextStyle(fontSize: 15, color: Colors.cyan[600])),
            Row(
              children: [
                Expanded(
                  child: Text(
                    widget.recipe.title ?? 'No Title',
                    style: TextStyle(
                        fontFamily: "LibreBaskerville",
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Colors.black),
                    softWrap: true,
                    maxLines: 2,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: InkWell(
                      onTap: () {
                        Provider.of<RecipesProvider>(context, listen: false)
                            .addRecipeToUserFavourite(
                                widget.recipe.docId!, !isInList);

                        if (isInList) {
                          widget.recipe.favorite_user_ids
                              ?.remove(FirebaseAuth.instance.currentUser?.uid);
                        } else {
                          widget.recipe.favorite_user_ids
                              ?.add(FirebaseAuth.instance.currentUser!.uid);
                        }

                        setState(() {});
                      },
                      child: isInList
                          ? const Icon(
                              Icons.favorite_rounded,
                              size: 30,
                              color: Colors.red,
                            )
                          : const Icon(
                              Icons.favorite_rounded,
                              size: 30,
                              color: Colors.grey,
                            )),
                )
              ],
            ),
            Text(
              "${widget.recipe?.calories ?? 'No calories found'}Calories",
              style: TextStyle(color: Colors.deepOrange.shade600, fontSize: 15),
            ),
            RatingBar.builder(
              initialRating: (widget.recipe?.rate ?? 0).toDouble(),
              minRating: 1,
              direction: Axis.horizontal,
              allowHalfRating: true,
              updateOnDrag: false,
              unratedColor: Colors.grey,
              itemCount: 5,
              itemSize: 25,
              itemBuilder: (context, _) => const Icon(
                Icons.star,
                color: Colors.deepOrange,
              ),
              onRatingUpdate: (rating) {
                print(rating);
              },
            ),
            Row(
              children: [
                const Icon(Icons.access_time, size: 25, color: Colors.grey),
                SizedBox(
                  width: 20,
                ),
                Text(
                  '${widget.recipe?.total_time ?? 'no data found'}mins',
                  style: const TextStyle(fontSize: 15, color: Colors.grey),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(130, 0, 0, 0),
                  child: Image.network(
                      fit: BoxFit.cover,
                      width: 100,
                      height: 90,
                      widget.recipe?.imageUrl ?? "no image found"),
                ),
              ],
            ),
            Row(
              children: [
                const Icon(
                  Icons.room_service_outlined,
                  size: 25,
                  color: Colors.grey,
                ),
                SizedBox(
                  width: 20,
                ),
                Text(
                  '${widget.recipe?.servings ?? 'no data found'}serving',
                  style: const TextStyle(fontSize: 15, color: Colors.grey),
                ),
              ],
            ),
            SizedBox(
              height: 15,
            ),
            Text("Ingredients",
                style: TextStyle(
                    fontFamily: "Hellix",
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black)),
            FutureBuilder(
                future: FirebaseFirestore.instance
                    .collection('ingredients')
                    .where('users_ids',
                        arrayContains: FirebaseAuth.instance.currentUser!.uid)
                    .get(),
                builder: (context, snapShot) {
                  if (snapShot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else {
                    if (snapShot.hasError) {
                      return Text('Error: ${snapShot.error}');
                    } else {
                      var userIngredients = List<Ingredient>.from(snapShot
                          .data!.docs
                          .map((e) => Ingredient.fromJson(e.data(), e.id))
                          .toList());

                      var userIngredientsTitles =
                          userIngredients.map((e) => e.name).toList();
                      Widget checkIngredientWidget(String recipeIngredient) {
                        bool isExsist = false;
                        for (var userIngredientsTitle
                            in userIngredientsTitles) {
                          if (recipeIngredient
                              .contains(userIngredientsTitle!)) {
                            isExsist = true;
                            break;
                          } else {
                            isExsist = false;
                          }
                        }

                        if (isExsist) {
                          return Icon(Icons.check);
                        } else {
                          return Icon(Icons.close);
                        }
                      }

                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: widget.recipe.ingredients
                                  ?.map((e) => Row(
                                        children: [
                                          Expanded(
                                              child: Text(
                                            e,
                                            softWrap: true,
                                          )),
                                          checkIngredientWidget(e)
                                        ],
                                      ))
                                  .toList() ??
                              [],
                        ),
                      );
                    }
                  }
                }),
            Text("Directions",
                style: TextStyle(
                    fontFamily: "Hellix",
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black)),
            FutureBuilder(
              future: FirebaseFirestore.instance
                  .collection('recipes')
                  .doc(widget.recipe.docId)
                  .get(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else {
                  // Check if the data has been fetched successfully
                  if (snapshot.hasData) {
                    DocumentSnapshot<Map<String, dynamic>>? recipeSnapshot =
                        snapshot.data
                            as DocumentSnapshot<Map<String, dynamic>>?;
                    if (recipeSnapshot != null &&
                        recipeSnapshot.exists &&
                        recipeSnapshot.data() != null &&
                        recipeSnapshot.data()!['directions'] != null) {
                      Map<String, dynamic> directions =
                          recipeSnapshot.data()!['directions'];

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: directions.entries.map((entry) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Text("Step ${entry.key}: ${entry.value}",),
                          );
                        }).toList(),
                      );
                    } else {
                      return Text("No directions found");
                    }
                  } else {
                    // Handle the case where data fetching failed
                    return Text("Failed to fetch directions");
                  }
                }
              },
            ),
          ]),
        ),
      ),
    );
  }
}
