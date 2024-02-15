import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


import '../provider/recipes.provider.dart';
import 'filter_result.pages.dart';

class FilterPage extends StatefulWidget {
  const FilterPage({super.key});

  @override
  State<FilterPage> createState() => _FilterPageState();
}

class _FilterPageState extends State<FilterPage> {
  var selectedUserValue = {

  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(leading: BackButton(onPressed: (){  Navigator.pop(context);},),),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: Row(
                  children: [
                    Text(
                      "Filter",
                      style: const TextStyle(
                        fontSize: 25,
                        color: Colors.black,
                        fontFamily: "Hellix",
                      ),
                    ),
                    SizedBox(width: 170,),
                    TextButton(onPressed: (){
                      setState(() {
                        selectedUserValue.clear();
                      });
                    }, child: Text("Reset",style: TextStyle(fontSize: 18,color: Colors.deepOrange),))
                  ],
                ),
              ),
              Text(
                "Meal",
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontFamily: "Hellix",
                ),
                textAlign: TextAlign.left,
              ),
              Wrap(


                  spacing: 10,

                  children: [
                    InkWell(
                      onTap: () {
                        selectedUserValue['type'] = "breakfast";
                        setState(() {});
                      },
                      child: Chip(
                        label: Text(
                          'Breakfast',
                          style: TextStyle(
                            color: selectedUserValue['type'] == "breakfast"
                                ? Colors
                                    .deepOrange
                                : Colors.grey,
                          ),
                        ),
                        backgroundColor:
                            selectedUserValue['type'] == "breakfast"
                                ? Colors.deepOrange[100]
                                : Colors.grey[300],
                        padding:
                            EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        selectedUserValue['type'] = "lunch";
                        setState(() {});
                      },
                      child: Chip(
                        label: Text(
                          'Lunch',
                          style: TextStyle(
                            color: selectedUserValue['type'] == "lunch"
                                ? Colors
                                    .deepOrange // Change text color to orange when chip is orange
                                : Colors.grey, // Default text color
                          ),
                        ),
                        backgroundColor: selectedUserValue['type'] == "lunch"
                            ? Colors.deepOrange[100]
                            : Colors.grey[300],
                        padding:
                            EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        selectedUserValue['type'] = "dinner";
                        setState(() {});
                      },
                      child: Chip(
                        label: Text(
                          'Dinner',
                          style: TextStyle(
                            color: selectedUserValue['type'] == "dinner"
                                ? Colors
                                    .deepOrange // Change text color to orange when chip is orange
                                : Colors.grey, // Default text color
                          ),
                        ),
                        backgroundColor: selectedUserValue['type'] == "dinner"
                            ? Colors.deepOrange[100]
                            : Colors.grey[300],
                        padding:
                            EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                      ),
                    ),
                  ]),
              Divider(
                endIndent: 18,
                color: Colors.grey,
                thickness: 1,
                height: 50,
              ),
              Text(
                "Serving",
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontFamily: "Hellix",
                ),
              ),
              Slider(
                activeColor: Colors.deepOrange,
                value: (selectedUserValue['servings'] as int?)?.toDouble() ?? 1,
                min: 1,
                max: 20,
                divisions: 20,
                label: ((selectedUserValue['servings'] as int?)?.round() ?? 1)
                    .toString(),
                onChanged: (newValue) {
                  setState(() {
                    selectedUserValue['servings'] = newValue.round();
                  });
                },
              ),
              SizedBox(
                height: 30,
              ),
              Text(
                "Total_Time",
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontFamily: "Hellix",
                ),
              ),
              Slider(
                activeColor: Colors.deepOrange,
                value:
                    (selectedUserValue['total_time'] as int?)?.toDouble() ?? 1,
                min: 1,
                max: 60,
                divisions: 60,
                label:
                    "${(selectedUserValue['total_time'] as int?)?.round()} min",
                onChanged: (newValue) {
                  setState(() {
                    selectedUserValue['total_time'] = newValue.round();
                  });
                },
              ),
              SizedBox(
                height: 30,
              ),
              Text(
                "Calories",
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontFamily: "Hellix",
                ),
              ),
              Slider(
                activeColor: Colors.deepOrange,
                value: (selectedUserValue['calories'] as int?)?.toDouble() ?? 1,
                min: 1,
                max: 1000,
                divisions: 1000,
                label: "${(selectedUserValue['calories'] as int?)?.round()}cal",
                onChanged: (newValue) {
                  setState(() {
                    selectedUserValue['calories'] = newValue.round();
                  });
                },
              ),
              Padding(
                padding: const EdgeInsets.only(top: 50),
                child: SizedBox(
                  width: 320,
                  height: 50,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          backgroundColor: Colors.deepOrange),
                      onPressed: () {
                        print("Selected Filters: $selectedUserValue");
                        Provider.of<RecipesProvider>(context, listen: false)
                            .getFilteredResult(selectedUserValue);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => FilterResult()));
                      },
                      child: const Text("Apply",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontFamily: "Hellix",
                              fontWeight: FontWeight.bold))),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
