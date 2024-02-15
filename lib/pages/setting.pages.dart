import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:recipe_app_level2/pages/recently_viewed.pages.dart';

import '../provider/app_auth.provider.dart';
import '../provider/recipes.provider.dart';
import 'favorites.pages.dart';
import 'homepage.pages.dart';
import 'ingredients.pages.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  late ZoomDrawerController? controller;
  late TextEditingController _newNameController;
  late TextEditingController _newImageUrlController;
  @override
  void initState() {
    controller = ZoomDrawerController();
    _newNameController = TextEditingController();
    _newImageUrlController = TextEditingController();
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
                  Navigator.push(context,
                      MaterialPageRoute(builder: (_) => const SettingPage()));
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
          body: Padding(
            padding: const EdgeInsets.all(9.0),
            child:
                SingleChildScrollView(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Text(
                    "Settings",
                    style: const TextStyle(
                      fontSize: 25,
                      color: Colors.black,
                      fontFamily: "Hellix",
                    ),
                  ),
                                ),
                                Container(
                  width: 350,
                  height: 80,
                  margin: EdgeInsets.all(16),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.grey[200]),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      children: [
                        Icon(
                          Icons.language,
                          size: 30,
                          color: Colors.black54,
                        ),
                        Text(
                          "Language",
                          style: TextStyle(fontSize: 18),
                        ),
                        SizedBox(
                          width: 120,
                        ),
                        Text("English",
                            style:
                                TextStyle(fontSize: 17, color: Colors.deepOrange))
                      ],
                    ),
                  ),
                                ),
                                Divider(
                  color: Colors.grey[200],
                  endIndent: 15,
                  indent: 15,
                                ),
                                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Text(
                    "Profile",
                    style: const TextStyle(
                      fontSize: 25,
                      color: Colors.black,
                      fontFamily: "Hellix",
                    ),
                  ),
                                ),
                                Container(
                  width: 350,
                  height: 150,
                  margin: EdgeInsets.all(16),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.grey[200]),
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Column(
                      children: [
                        Row(children: [
                          Text("Edit your Name", style: TextStyle(fontSize: 18)),
                          SizedBox(
                            width: 80,
                          ),
                          TextButton(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (context) => SingleChildScrollView(
                                    child: AlertDialog(
                                      title: Text('Edit Your Name'),
                                      content: TextField(
                                        controller: _newNameController,
                                        decoration: InputDecoration(
                                          hintText: 'Enter your new name',
                                        ),
                                      ),
                                      actions: <Widget>[
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context)
                                                .pop(); 
                                          },
                                          child: Text('Cancel',style: TextStyle(color: Colors.deepOrange),),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                    
                                            Provider.of<AppAuthProvider>(context,
                                                    listen: false)
                                                .editName(context,
                                                    _newNameController.text);
                                            Navigator.of(context)
                                                .pop();
                                          },
                                          child: Text('Save',style: TextStyle(color: Colors.deepOrange),),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                              child: Icon(
                                Icons.title_sharp,
                                color: Colors.deepOrange,
                              )),
                        ]),
                        Divider(
                          color: Colors.grey[300],
                          endIndent: 15,
                          indent: 15,
                          thickness: 1,
                        ),
                        Row(
                          children: [
                            Text("Edit your Image",
                                style: TextStyle(fontSize: 18)),
                            SizedBox(
                              width: 80,
                            ),
                            TextButton(
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) => SingleChildScrollView(
                                      child: AlertDialog(
                                        title: Text('Edit Your Image'),
                                        content: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text('Upload an Image'),
                                            SizedBox(height: 10),
                                            ElevatedButton(
                                              onPressed: () {
                                                Provider.of<AppAuthProvider>(context, listen: false).editUserImage(context);
                                              },
                                              child: Text('Upload',style: TextStyle(color: Colors.deepOrange),),
                                            ),
                                          ],
                                        ),
                                        actions: <Widget>[
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: Text('Cancel',style: TextStyle(color: Colors.deepOrange),),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                                child: Icon(
                                  Icons.image,
                                  color: Colors.deepOrange,
                                )),
                          ],
                        ),
                      ],
                    ),
                  ),
                                ),
                              ]),
                ),
          )),
      borderRadius: 5.0,
      showShadow: true,
      angle: -12.0,
      drawerShadowsBackgroundColor: Colors.grey.shade300,
      slideWidth: MediaQuery.of(context).size.width * 0.65,
    );
  }
}
