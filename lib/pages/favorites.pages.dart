import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flexible_grid_view/flexible_grid_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:recipe_app_level2/pages/recently_viewed.pages.dart';
import 'package:recipe_app_level2/pages/setting.pages.dart';
import 'package:recipe_app_level2/widgets/fresh_recipes.widgets.dart';
import 'package:recipe_app_level2/widgets/recommended.widgets.dart';

import '../models/recipes.models.dart';
import '../provider/app_auth.provider.dart';
import '../provider/recipes.provider.dart';
import 'filter.pages.dart';
import 'homepage.pages.dart';
import 'ingredients.pages.dart';

class FavouritesPage extends StatefulWidget {
  const FavouritesPage({super.key});

  @override
  State<FavouritesPage> createState() => _FavouritesPageState();
}

class _FavouritesPageState extends State<FavouritesPage> {

  late ZoomDrawerController?controller;
  String searchText = '';
  @override
  void initState() {
    controller= ZoomDrawerController();
    Provider.of<RecipesProvider>(context, listen: false).getFreshRecipes();

    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return ZoomDrawer(
      menuBackgroundColor: Colors.white,
      disableDragGesture: true,
      mainScreenTapClose: true,
      controller: controller,
      menuScreen: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(15),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundImage: NetworkImage(FirebaseAuth.instance.currentUser?.photoURL ?? "no photo"),


                    ),
                    Text("${FirebaseAuth.instance.currentUser?.displayName ?? "no name"}",style: TextStyle(fontSize: 25),),
                  ],
                ),
              ),
              ListTile(
                  onTap: () {
                    controller?.close?.call();
                    Navigator.push(
                        context, MaterialPageRoute(builder: (_) => HomePage()));
                  },
                  leading: const Icon(Icons.home),
                  title: const Text('Home')),
              ListTile(
                  onTap: () {
                    controller?.close?.call();
                    Navigator.push(context,
                        MaterialPageRoute(builder: (_) => FavouritesPage()));
                  },
                  leading: const Icon(Icons.favorite_outline_rounded),
                  title: const Text('Favorites')),
              ListTile(
                  onTap: () {
                    controller?.close?.call();
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => RecentlyViewedPage()));
                  },
                  leading: const Icon(
                    Icons.play_arrow_outlined,
                    size: 35,
                  ),
                  title: Text(
                    'Recently Viewed',
                  )),
              ListTile(
                onTap: () {
                  controller?.close?.call();
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const IngredientPage()));
                },
                leading: const Icon(Icons.food_bank),
                title: const Text('Ingredients'),
              ),
              ListTile(
                onTap: () {
                  controller?.close?.call();
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SettingPage()));
                },
                leading: const Icon(Icons.settings_outlined),
                title: const Text('Settings'),
              ),

              ListTile(
                onTap: () {
                  Provider.of<AppAuthProvider>(context, listen: false)
                      .signOut(context);
                },
                leading: const Icon(Icons.logout),
                title: const Text('Sign Out'),
              ),

            ],
          ),
        ),
      ),
      mainScreen: Scaffold(
        appBar: AppBar(
            leading: IconButton(
                onPressed: () {
                  controller!.toggle!();
                },

                icon: const FaIcon(FontAwesomeIcons.barsStaggered)),
           ),

        body:  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: Text(
                          "Favorites",
                          style: const TextStyle(
                            fontSize: 25,
                            color: Colors.black,
                            fontFamily: "Hellix",
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 18),
                            child: SizedBox(
                              height: 40,
                              width: 280,
                              child: TextFormField(
                                onChanged: (value) {
                                  setState(() {
                                    searchText = value;
                                  });
                                },
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide.none,
                                  ),
                                  prefixIcon: const Icon(Icons.search),
                                  filled: true,
                                  labelText: 'Search for recipes',
                                  labelStyle: const TextStyle(
                                    fontSize: 15,
                                    color: Colors.grey,
                                    fontFamily: "Hellix",
                                  ),
                                  fillColor: Colors.grey[200],
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(10),
                              ),
                              alignment: AlignmentDirectional.centerStart,
                              height: 40,
                              width: 50,
                              child: IconButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => FilterPage()));
                                },
                                icon: const FaIcon(
                                  FontAwesomeIcons.sliders,
                                  color: Colors.black54,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
      StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('recipes')
            .where("favorite_user_ids",
            arrayContains: FirebaseAuth.instance.currentUser!.uid)
            .snapshots(),
        builder: (context, snapshots) {
          if (snapshots.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else {
            if (snapshots.hasError) {
              return const Text('ERROR WHEN GET DATA');
            } else {
              if (snapshots.hasData) {
                List<Recipe> recipesList = snapshots.data!.docs
                    .map((e) => Recipe.fromJson(e.data(), e.id))
                    .where((recipe) => recipe.title!
                    .toLowerCase()
                    .contains(searchText.toLowerCase()))
                    .toList();
                return
                    Flexible(
                      child: ListView.separated(
                        addRepaintBoundaries: true,
                        padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        itemCount: recipesList.length,
                        separatorBuilder: (context, index) {

                          return SizedBox(height: 15);
                        },
                        itemBuilder: (context, index) {
                          return SizedBox(height:110,width:360,child: Recommendedrecipes(recipe: recipesList[index]));
                        },
                      ),
                    );


                } else {
                  return const Text('No Data Found');
                }
              }
            }
          },
        ),
     ] ),),


      borderRadius:5.0,
      showShadow: true,
      angle: -12.0,
      drawerShadowsBackgroundColor: Colors.grey.shade300,
      slideWidth: MediaQuery.of(context).size.width * 0.65,
    );

  }
}
