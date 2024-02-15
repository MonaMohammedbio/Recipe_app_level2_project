class Recipe {
  String? docId;
  num? calories;
  String? describtion;
  Map<String, String>? directions;
  String? imageUrl;
  List<String>? ingredients;
  List<String>? favorite_user_ids;
  List<String>? recently_viewd_users_ids;
  num? rate;
  num? servings;
  String? title;
  num? total_time;
  String? type;

  Recipe();

  Recipe.fromJson(Map<String, dynamic> data, [String? id]) {
    docId = id;
    calories = data['calories'];
    describtion = data['describtion'];
    directions = data['directions'] != null
        ? Map<String, String>.from(data['directions'])
        : null;
    imageUrl = data['imageUrl'];
    ingredients = data['ingredients'] != null
        ? List<String>.from(data['ingredients'].map((e) => e.toString()))
        : null;
    favorite_user_ids = data['favorite_user_ids'] != null
        ? List<String>.from(
        data['favorite_user_ids'].map((e) => e.toString()))
        : null;
    recently_viewd_users_ids= data['recently_viewd_users_ids'] != null
        ? List<String>.from(
        data['recently_viewd_users_ids'].map((e) => e.toString()))
        : null;
    rate = data['rate'];
    servings = data['servings'];
    title = data['title'];
    total_time = data['total_time'];
    type = data['type'];
  }

  Map<String, dynamic> toJson() {
    return {
      "calories": calories,
      "describtion": describtion,
      "directions": directions,
      "imageUrl": imageUrl,
      "ingredients": ingredients,
      "favorite_user_ids": favorite_user_ids,
      "recently_viewd_users_ids":recently_viewd_users_ids,
      "rate": rate,
      "servings": servings,
      "title": title,
      "total_time": total_time,
      "type": type,
    };
  }
}
