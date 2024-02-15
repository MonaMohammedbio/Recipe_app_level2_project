class Ad {
  String?docId;
  String? title;
  String? image;
  Ad();
  Ad.fromJason(Map<String,dynamic>data,[String? id]){
    docId=id;
title=data["title"];
image=data["image"];

  }
  Map<String,dynamic> toJson() {
    return {
      "title": title,
      "image": image,
    };
  }
}
