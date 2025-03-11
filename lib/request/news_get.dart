import 'dart:convert';

Map<String, ArNews> arNewsFromJson(String str) => Map.from(json.decode(str))
    .map((k, v) => MapEntry<String, ArNews>(k, ArNews.fromJson(v)));

// String arNewsToJson(Map<String, ArNews> data) => json.encode(Map.from(data).map((k, v) => MapEntry<String, dynamic>(k, v.toJson())));

class ArNews {
  ArNews({this.title, this.introtext, this.images});

  String? title;
  String? introtext;
  String? images;

  factory ArNews.fromJson(Map<String, dynamic> json) => ArNews(
        title: json["title"] ?? "",
        introtext: json["introtext"] ?? "",
        images: json["images"] ?? "",
      );
}

NewsImages newsImagesFromJson(String str) =>
    NewsImages.fromJson(json.decode(str));

class NewsImages {
  NewsImages({
    this.imageIntro,
    this.imageIntroAlt,
    this.imageIntroCaption,
    this.floatIntro,
    this.imageFulltext,
    this.imageFulltextAlt,
    this.imageFulltextCaption,
    this.floatFulltext,
  });

  String? imageIntro;
  String? imageIntroAlt;
  String? imageIntroCaption;
  String? floatIntro;
  String? imageFulltext;
  String? imageFulltextAlt;
  String? imageFulltextCaption;
  String? floatFulltext;

  factory NewsImages.fromJson(Map<String, dynamic> json) => NewsImages(
        imageIntro: json["image_intro"],
        imageIntroAlt: json["image_intro_alt"],
        imageIntroCaption: json["image_intro_caption"],
        floatIntro: json["float_intro"],
        imageFulltext: json["image_fulltext"],
        imageFulltextAlt: json["image_fulltext_alt"],
        imageFulltextCaption: json["image_fulltext_caption"],
        floatFulltext: json["float_fulltext"],
      );
}
