import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:mawy_dashboard/theme_provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '/global/colors.dart';
import '../request/get_data.dart';
import '../request/news_get.dart';

class OneNews extends StatefulWidget {
  int id;
  OneNews({super.key, required this.id});

  @override
  State<OneNews> createState() => OneNewsState(id: id);
}

class OneNewsState extends State<OneNews> {
  int id;
  final Uri _url = Uri.parse(
    'https://arassanusga.com/index.php/ru/services-ru',
  );
  OneNewsState({Key? key, required this.id});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Consumer(
      builder: (context, ref, child) {
        final isDark = ref.watch(themeNotifierProvider.notifier).isDarkTheme();
        return Scaffold(
          backgroundColor: isDark ? maincolorDark : maincolor,
          body: FutureBuilder<Map<String, ArNews>>(
            future: getNews(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List<ArNews> newsContent = snapshot.data!.values.toList();
                // String newsImage = newsContent[0].images.toString().replaceAll(
                //   RegExp('[^A-Za-z0-9({}_:".,-/)]'),
                //   '',
                // );
                // NewsImages nImages = newsImagesFromJson(newsImage);
                return Stack(
                  children: [
                    // background(width, height),
                    news(
                      width,
                      height,
                      newsContent[id].introtext,
                      newssImage(newsContent[id].images).imageIntro,
                      id,
                      isDark,
                    ),
                    appBar(width, height, context, newsContent[id].title, id),
                  ],
                );
              } else {
                return Stack(
                  alignment: AlignmentDirectional.center,
                  children: [
                    // background(width, height),
                    SpinKitRipple(color: darkblue, size: 50.0),
                  ],
                );
              }
            },
          ),
        );
      },
    );
  }

  Container background(double width, double height) {
    return Container(
      width: width,
      height: height,
      alignment: Alignment.bottomCenter,
      decoration: BoxDecoration(color: white),
    );
  }

  Widget appBar(
    double width,
    double height,
    BuildContext context,
    String? title,
    int id,
  ) {
    return Container(
      width: width,
      height: height * 0.12,
      alignment: Alignment.bottomCenter,
      padding: EdgeInsets.symmetric(horizontal: width * 0.05, vertical: 10),
      decoration: BoxDecoration(
        color: darkblue,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(25),
          bottomRight: Radius.circular(25),
        ),
        boxShadow: [
          BoxShadow(
            offset: Offset(0, 2),
            blurRadius: 2,
            color: black.withValues(alpha: 0.35),
          ),
        ],
      ),
      child: Stack(
        alignment: AlignmentDirectional.centerStart,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: width * 0.65,
                child: Text(
                  "$title",
                  textAlign: TextAlign.right,
                  style: TextStyle(color: white, fontSize: 16),
                ),
              ),
            ],
          ),
          IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back_ios_new_rounded,
              color: white,
              size: 18,
            ),
          ),
        ],
      ),
    );
  }

  Widget news(
    double width,
    double height,
    String? text,
    String? image,
    int id,
    bool isDark,
  ) {
    return Padding(
      padding: EdgeInsets.only(top: height * 0.12),
      child: ListView(
        shrinkWrap: true,
        physics: BouncingScrollPhysics(),
        padding: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 20),
        children: [
          // Padding(
          //   padding: EdgeInsets.only(bottom: 10),
          //   child: Text(
          //     "${newsContent[1].title}",
          //     style: TextStyle(color: white, fontSize: 16),
          //   ),
          // ),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: FadeInImage.assetNetwork(
              placeholder: "assets/placeholder.png",
              image: "https://arassanusga.com/$image",
            ),
          ),
          Container(
            width: width,
            // height: height * 0.05,
            margin: EdgeInsets.only(top: 10),
            child: Html(
              // "Панели данных (data dashboards) — это популярный инструмент, используемый в веб-приложениях, интрасетях и других системах бизнес-аналитики для отображения регулярно обновляемых показателей, отслеживание которых крайне важно для пользователя. Их главное предназначение состоит в визуализации данных в таком их компактном размещении и отображении, при котором на интерпретацию информации тратится минимальное количество времени.",
              data: "$text",
              style: {
                "*": Style(
                  // fontFamily: 'serif',
                  // backgroundColor: Colors.black,
                  padding: HtmlPaddings.all(0),
                  margin: Margins.only(top: 5),
                  textAlign: TextAlign.justify,
                  color: isDark ? white.withValues(alpha: 0.7) : darkblue,
                ),
              },
            ),
          ),
          GestureDetector(
            onTap: _launchUrl,
            child: Padding(
              padding: EdgeInsets.only(top: 10),
              child: Text(
                "Подробнее о наших услугах",
                style: TextStyle(
                  color: darkblue,
                  fontSize: 18,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _launchUrl() async {
    if (!await launchUrl(_url, mode: LaunchMode.externalApplication)) {
      throw 'Could not launch $_url';
    }
  }
}
