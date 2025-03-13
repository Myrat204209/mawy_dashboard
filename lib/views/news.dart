import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mawy_dashboard/hive/hive_objects.dart';
import 'package:mawy_dashboard/theme_provider.dart';
import 'package:mawy_dashboard/views/one_news.dart';

import '/global/colors.dart';
import '/global/strings.dart';
import '/main.dart';
import '../request/get_data.dart';
import '../request/news_get.dart';
import 'auth.dart';

class News extends ConsumerStatefulWidget {
  const News({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _NewsState();
}

class _NewsState extends ConsumerState<News> {
  int id = 0;
  bool isFirst = true;

  @override
  void initState() {
    if (ref.read(keyBoxProvider).containsKey('key') == true) {
      isFirst = false;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = ref.watch(themeNotifierProvider.notifier).isDarkTheme();
    double width = MediaQuery.sizeOf(context).width;
    double height = MediaQuery.sizeOf(context).height;
    return Scaffold(
      backgroundColor: isDark ? maincolorDark : maincolor,
      body: Stack(
        children: [
          // background(width, height),
          news(width, height),
          appBar(width, height, context),
        ],
      ),
    );
  }

  Container appBar(double width, double height, BuildContext context) {
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
              Padding(
                padding: EdgeInsets.only(right: 10),
                child: SvgPicture.asset("assets/planet.svg", width: 22),
              ),
              Text(
                AppStrings.news,
                style: TextStyle(color: white, fontSize: 25),
              ),
            ],
          ),
          isFirst
              ? GestureDetector(
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => LoginPage(),
                    ),
                  );
                },
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.login_rounded, color: white, size: 25),
                    ),
                    Text("Giriş", style: TextStyle(color: white, fontSize: 18)),
                  ],
                ),
              )
              : IconButton(
                onPressed: () {
                  Navigator.of(context).pop(true);
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

  Widget news(double width, double height) {
    return FutureBuilder<Map<String, ArNews>>(
      future: getNews(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<ArNews> newsContent = snapshot.data!.values.toList();
          List<String> nIds = [];
          for (var nId in snapshot.data!.keys) {
            nIds.add(nId);
          }

          ref.read(newsIdBoxProvider).put('count', NewsId(nCount: nIds));
          return Padding(
            padding: EdgeInsets.only(top: height * 0.12),
            child: ListView(
              shrinkWrap: true,
              physics: BouncingScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              children: [
                ...List.generate(
                  snapshot.data!.length,
                  (index) => GestureDetector(
                    onTap: () {
                      id = index;
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) => OneNews(id: id),
                        ),
                      );
                    },
                    child: Container(
                      width: width,
                      padding: EdgeInsets.all(10),
                      margin: EdgeInsets.only(bottom: 15),
                      decoration: BoxDecoration(
                        color: darkblue.withValues(alpha: 0.8),
                        boxShadow: [
                          BoxShadow(
                            color: black.withValues(alpha: 0.4),
                            blurRadius: 8,
                            offset: Offset(0, 2),
                          ),
                        ],
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(bottom: 10),
                            child: Text(
                              "${newsContent[index].title}",
                              style: TextStyle(color: white, fontSize: 16),
                            ),
                          ),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: FadeInImage.assetNetwork(
                              fadeInDuration: Duration(milliseconds: 200),
                              placeholder: "assets/placeholder.png",
                              image:
                                  "https://arassanusga.com/${newssImage(newsContent[index].images).imageIntro}",
                            ),
                          ),
                          // ClipRRect(
                          //     borderRadius: BorderRadius.circular(10),
                          //     child: Image.network(
                          //       "https://arassanusga.com/${newssImage(newsContent[index].images).imageIntro}",
                          //     )),
                          Container(
                            width: width,
                            height: height * 0.05,
                            margin: EdgeInsets.only(top: 10),
                            child: Html(
                              // "Панели данных (data dashboards) — это популярный инструмент, используемый в веб-приложениях, интрасетях и других системах бизнес-аналитики для отображения регулярно обновляемых показателей, отслеживание которых крайне важно для пользователя. Их главное предназначение состоит в визуализации данных в таком их компактном размещении и отображении, при котором на интерпретацию информации тратится минимальное количество времени.",
                              data: "${newsContent[index].introtext}",
                              style: {
                                "*": Style(
                                  // fontFamily: 'serif',
                                  // backgroundColor: Colors.black,
                                  padding: HtmlPaddings.all(0),
                                  margin: Margins.all(0),
                                  textAlign: TextAlign.left,
                                  color: Colors.white,
                                ),
                              },
                              // style: TextStyle(
                              //     color: white,
                              //     fontSize: 13,
                              //     overflow: TextOverflow.fade),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  AppStrings.read,
                                  style: TextStyle(color: white),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        } else {
          return Center(child: SpinKitRipple(color: darkblue, size: 50.0));
        }
      },
    );
  }
}
