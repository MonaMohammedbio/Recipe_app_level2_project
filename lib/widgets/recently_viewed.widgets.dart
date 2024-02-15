import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';

import '../models/recipes.models.dart';
import '../pages/recipe_details.pages.dart';
import '../provider/recipes.provider.dart';

class Recentlyviewed extends StatefulWidget {
  final Recipe? recipe;
  Recentlyviewed({required this.recipe, super.key});

  @override
  State<Recentlyviewed> createState() => _RecentlyviewedState();
}

class _RecentlyviewedState extends State<Recentlyviewed> {
  @override
  Widget build(BuildContext context) {
    return Card(

        borderOnForeground: true,
        margin: const EdgeInsets.only(right: 30,),
        // elevation: 2,
        child: InkWell(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => RecipeDetailsPage(
                      recipe: widget.recipe!,
                    )));
          },
          child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Padding(
                  padding: const EdgeInsets.only(top:10,),
                  child: Image.network(
                      width: 150,
                      height: 70,
                      widget.recipe?.imageUrl ?? "no image found"),
                ),

                Expanded(
                  flex:2 ,

                  child: Column(

                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        Text(
                          widget.recipe?.type ??
                              'No type found',
                          style: TextStyle(
                              fontSize: 12, color: Colors.cyan[600]),
                        ),


                        Text(

                            widget.recipe?.title??
                                "No title found",
                            softWrap: true,
                            maxLines: 2,
                            style: const TextStyle(
                                color: Colors.black,
                                fontFamily: "Hellix",
                                fontSize: 15)),
                        RatingBar.builder(
                          initialRating: ( widget.recipe?.rate??0).toDouble(),
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
                          "${ widget.recipe?.calories ??  'No calories found'}calories",
                          style: const TextStyle(
                              color: Colors.deepOrange, fontSize: 12),
                        ),
                        Row(
                            mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  const Icon(Icons.access_time,
                                      size: 15, color: Colors.grey),
                                  Text(
                                    '${ widget.recipe?.total_time ??  'no data found'}',
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
                                    '${ widget.recipe?.servings ?? 'no data found'}serving',
                                    style: const TextStyle(
                                      fontSize: 11,
                                    ),
                                  ),
                                ],
                              ),
                            ]),]),
                ),

                InkWell(
                  onTap: () {
                    Provider.of<RecipesProvider>(context, listen: false)
                        .removeRecipeToUserRecentlyViewed(
                      widget.recipe!.docId!,

                    );
                  },
                  child: Icon(
                    Icons.close_sharp,
                    size: 30,
                    color: Colors.grey,
                  ),
                ),
              ]),
        ));

  }
}
