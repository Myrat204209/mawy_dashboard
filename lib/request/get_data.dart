import 'package:http/http.dart' as http;

import 'news_get.dart';

Future<String> getDatas(String login, String password, String key) async {
  String result = "";
  // HttpOverrides.global = MyHttpOverrides();

  var headersList = {
    'Accept': '*/*',
    'login': login,
    'pass': password,
    'key': key,
  };

  //mawy ip - user1 13246857mu 13246857
  var url = Uri.parse(
    'https://turkmentelekeci.com/dashboards/mawy_umman/getDatas.php',
  );

  var req = http.Request('POST', url);
  req.headers.addAll(headersList);

  var res = await req.send();
  final resBody = await res.stream.bytesToString();

  if (res.statusCode >= 200 && res.statusCode < 300) {
    if (resBody != "null") result = resBody;
  } else {}

  return result;
}

Future<String> syncNews() async {
  String result = "";
  var headersList = {'Accept': '*/*'};
  var url = Uri.parse('https://arassanusga.com/getArticles.php');

  var req = http.Request('GET', url);
  req.headers.addAll(headersList);

  var res = await req.send();
  final resBody = await res.stream.bytesToString();

  if (res.statusCode >= 200 && res.statusCode < 300) {
    result = resBody;
  } else {}
  return result;
}

Future<Map<String, ArNews>> getNews() async {
  String allnews = await syncNews();
  Map<String, ArNews> finnews = arNewsFromJson(allnews);

  return finnews;
}

NewsImages newssImage(imageContent) {
  String newsImage = imageContent.replaceAll(
    RegExp('[^A-Za-z0-9({}_:".,-/)]'),
    '',
  );
  NewsImages nImages = newsImagesFromJson(newsImage);
  return nImages;
}
