import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/recipes.provider.dart';
import '../widgets/recommended.widgets.dart';

class FilterResult extends StatefulWidget {
 FilterResult({super. key});


  @override
  State<FilterResult> createState() => _FilterResultState();
}

class _FilterResultState extends State<FilterResult> {



  @override
  Widget build(BuildContext context) {
    return 
      Scaffold(
        appBar: AppBar(
          leading: BackButton(onPressed: (){  Navigator.pop(context);},)
        ),
        body:
           SafeArea(
             child: Consumer<RecipesProvider>(
                  builder: (ctx, recipesProvider, _) =>
                  recipesProvider.filteredRecipesList == null
                      ? const CircularProgressIndicator()
                      : (recipesProvider.filteredRecipesList
                      ?.isEmpty ??
                      false)
                      ? const Text('No Data Found')
                      : ListView.separated(

                    scrollDirection:Axis.vertical,
                    shrinkWrap: true,
                    itemCount: recipesProvider
                        .filteredRecipesList!.length,
                    separatorBuilder: (context, index) {
                       
                      return SizedBox(height: 15);
                    },
                    itemBuilder: (ctx, index) =>
                        Recommendedrecipes(
                          recipe: recipesProvider
                              .filteredRecipesList![index],
                        ),
                  )),
           ));


  }
}
