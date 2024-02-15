import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:recipe_app_level2/pages/all_recipes.pages.dart';
import 'package:recipe_app_level2/pages/filter.pages.dart';
import 'package:recipe_app_level2/pages/recently_viewed.pages.dart';
import 'package:recipe_app_level2/pages/setting.pages.dart';

import 'package:recipe_app_level2/provider/app_auth.provider.dart';
import 'package:recipe_app_level2/widgets/fresh_recipes.widgets.dart';
import 'package:recipe_app_level2/widgets/recommended.widgets.dart';

import '../provider/recipes.provider.dart';
import '../widgets/ads_widgets.dart';
import 'favorites.pages.dart';
import 'ingredients.pages.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late ZoomDrawerController? controller;

  @override
  void initState() {
    controller = ZoomDrawerController();
    Provider.of<RecipesProvider>(context, listen: false).getFreshRecipes();
    Provider.of<RecipesProvider>(context, listen: false)
        .getRecommandedRecipes();
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
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundImage: NetworkImage(
                          FirebaseAuth.instance.currentUser?.photoURL ?? "no photo"),
                    ),


                Expanded(
                  child: Text(
                    "${FirebaseAuth.instance.currentUser?.displayName ?? "no name"}",
                    style: TextStyle(fontSize: 20),
                    softWrap: true,

                  ),
                ),]),
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
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => SettingPage()));
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
          // actions: [
          // Padding(
          //   padding: const EdgeInsets.symmetric(horizontal: 10),
          //   child: IconButton(
          //       onPressed: () {},
          //       icon: const Icon(
          //         Icons.notifications_none,
          //         size: 30,
          //       )),
          // )
          // ]
        ),
        body: SafeArea(
            child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(children: [
                  Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          "Bonjour,${FirebaseAuth.instance.currentUser?.displayName ?? "no name"}",
                          style:
                              const TextStyle(color: Colors.grey, fontSize: 16),
                        )),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: const Text(
                      "What would you like to cook today?",
                      style: TextStyle(
                          fontFamily: "LibreBaskerville",
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: Colors.black),
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
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide.none),
                                  prefixIcon: InkWell(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    FilterPage()));
                                      },
                                      child: Icon(Icons.search)),
                                  filled: true,
                                  labelText: 'Search for recipes',
                                  labelStyle: const TextStyle(
                                      fontSize: 15,
                                      color: Colors.grey,
                                      fontFamily: "Hellix"),
                                  fillColor: Colors.grey[200])),
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
                                ))),
                      )
                    ],
                  ),
                  AdsWidget(),
                  Row(
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(left: 20),
                        child: Text("Today's Fresh Recipes",
                            style: TextStyle(
                                fontFamily: "Hellix",
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.black)),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 60),
                        child: TextButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => AllRecipesPage()));
                            },
                            child: const Text("See All",
                                style: TextStyle(
                                    fontFamily: "Hellix",
                                    fontWeight: FontWeight.w500,
                                    fontSize: 15,
                                    color: Colors.deepOrange))),
                      )
                    ],
                  ),
                  SizedBox(
                      width: 360,
                      height: 200,
                      child: Consumer<RecipesProvider>(
                          builder: (ctx, recipesProvider, _) =>
                              recipesProvider.freshRecipesList == null
                                  ? const CircularProgressIndicator()
                                  : (recipesProvider
                                              .freshRecipesList?.isEmpty ??
                                          false)
                                      ? const Text('No Data Found')
                                      : ListView.builder(
                                          shrinkWrap: true,
                                          scrollDirection: Axis.horizontal,
                                          itemCount: recipesProvider
                                              .freshRecipesList!.length,
                                          itemBuilder: (ctx, index) => Recipes(
                                            recipe: recipesProvider
                                                .freshRecipesList![index],
                                          ),
                                        ))),
                  Row(
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(left: 20),
                        child: Text("Recommended",
                            style: TextStyle(
                                fontFamily: "Hellix",
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.black)),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 110),
                        child: TextButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => AllRecipesPage()));
                            },
                            child: const Text("See All",
                                style: TextStyle(
                                    fontFamily: "Hellix",
                                    fontWeight: FontWeight.w500,
                                    fontSize: 15,
                                    color: Colors.deepOrange))),
                      )
                    ],
                  ),
                  SizedBox(
                      width: 380,
                      height: 110,
                      child: Consumer<RecipesProvider>(
                          builder: (ctx, recipesProvider, _) =>
                              recipesProvider.recommandedRecipesList == null
                                  ? const CircularProgressIndicator()
                                  : (recipesProvider.recommandedRecipesList
                                              ?.isEmpty ??
                                          false)
                                      ? const Text('No Data Found')
                                      : ListView.separated(
                                          shrinkWrap: true,
                                          itemCount: recipesProvider
                                              .recommandedRecipesList!.length,
                                          separatorBuilder: (context, index) {
                                            return SizedBox(
                                                height:
                                                    15); // Adjust the height as needed
                                          },
                                          itemBuilder: (ctx, index) =>
                                              Recommendedrecipes(
                                            recipe: recipesProvider
                                                .recommandedRecipesList![index],
                                          ),
                                        ))),
                ]))),
      ),
      borderRadius: 5.0,
      showShadow: true,
      angle: -12.0,
      drawerShadowsBackgroundColor: Colors.grey.shade300,
      slideWidth: MediaQuery.of(context).size.width * 0.65,
    );
  }
}
