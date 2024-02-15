import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../models/recipes.models.dart';
import '../pages/recipe_details.pages.dart';
import '../provider/recipes.provider.dart';

class Recipes extends StatefulWidget {
  final Recipe? recipe;

  const Recipes({required this.recipe, super.key});
  @override
  State<Recipes> createState() => _RecipesState();
}

class _RecipesState extends State<Recipes> {
  @override
  Widget build(BuildContext context) {
    return Card(
        borderOnForeground: true,
        margin: const EdgeInsets.only(right: 30),
        //elevation: 2,
        child: InkWell(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => RecipeDetailsPage(
                          recipe: widget.recipe!,
                        )));
          },
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            InkWell(
                onTap: () {
                  Provider.of<RecipesProvider>(context, listen: false)
                      .addRecipeToUserFavourite(
                          widget.recipe!.docId!,
                          !(widget.recipe?.favorite_user_ids?.contains(
                                  FirebaseAuth.instance.currentUser?.uid) ??
                              false));
                },
                child: (widget.recipe?.favorite_user_ids?.contains(
                            FirebaseAuth.instance.currentUser?.uid) ??
                        false
                    ? const Icon(
                        Icons.favorite_rounded,
                        size: 30,
                        color: Colors.red,
                      )
                    : const Icon(
                        Icons.favorite_rounded,
                        size: 30,
                        color: Colors.grey,
                      ))),
            Image.network(
                width: 150,
                height: 70,
                widget.recipe?.imageUrl ?? "no image found"),
            Text(
              widget.recipe?.type ?? 'No type found',
              style: TextStyle(fontSize: 12, color: Colors.cyan[600]),
            ),
            Text(widget.recipe?.title ?? "No title found",
                style: const TextStyle(
                    color: Colors.black, fontFamily: "Hellix", fontSize: 15), softWrap: true,
              maxLines: 2,),
            RatingBar.builder(
              initialRating: (widget.recipe?.rate ?? 0).toDouble(),
              minRating: 1,
              direction: Axis.horizontal,
              allowHalfRating: true,
              updateOnDrag: false,
              unratedColor: Colors.grey,
              itemCount: 5,
              itemSize: 15,
              itemBuilder: (context, _) => const Icon(
                Icons.star,
                color: Colors.deepOrange,
              ),
              onRatingUpdate: (rating) {
                print(rating);
              },
            ),
            Text(
              "${widget.recipe?.calories ?? 'No calories found'}calories",
              style: const TextStyle(color: Colors.deepOrange, fontSize: 12),
            ),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Row(
                children: [
                  const Icon(Icons.access_time, size: 15, color: Colors.grey),
                  Text(
                    '${widget.recipe?.total_time ?? 'no data found'}',
                    style: const TextStyle(
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                width: 30,
              ),
              Row(
                children: [
                  const Icon(
                    Icons.room_service_outlined,
                    size: 15,
                    color: Colors.grey,
                  ),
                  Text(
                    '${widget.recipe?.servings ?? 'no data found'}serving',
                    style: const TextStyle(
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ]),
          ]),
        ));
  }
}
