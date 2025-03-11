// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:badges/badges.dart';
import 'package:flutter/material.dart' hide Badge;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:mawy_dashboard/hive/hive_objects.dart';
import 'package:mawy_dashboard/theme_provider.dart';

import '/global/colors.dart';
import '/global/values.dart';
import '/main.dart';
import '/objects/datas.dart';
import '/widgets/clipper.dart';
import '../request/get_data.dart';
import '../request/news_get.dart';
// import '../widgets/one_card.dart';
// import 'news.dart';

class HomePage extends ConsumerWidget {
  final String tPY;
  final bool loadStatic;

  const HomePage({super.key, required this.tPY, required this.loadStatic});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    double w = MediaQuery.sizeOf(context).width;
    double h = MediaQuery.sizeOf(context).height;
    var clipper = AppbarClipperLeft();

    return Scaffold(
      backgroundColor:
          ref.read(themeNotifierProvider.notifier).isDarkTheme()
              ? maincolorDark
              : maincolor,
      body: SizedBox(
        height: h,
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            Positioned(
              bottom: 5,
              child: Center(
                child: Padding(
                  padding: EdgeInsets.only(top: 30),
                  child: Text(
                    'Powered by Arassa Nusga ${DateTime.now().year}',
                    style: TextStyle(
                      fontSize: 12,
                      color:
                          ref.read(themeNotifierProvider.notifier).isDarkTheme()
                              ? maincolor.withValues(alpha: 0.7)
                              : darkblue.withValues(alpha: 0.8),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(child: SizedBox(height: h * 0.97, child: OneCard())),
            SizedBox(
              height: h * 0.2,
              child: Stack(
                children: [
                  ClipPath(
                    clipper: clipper,
                    child: Container(
                      width: w,
                      height: h * 0.15,
                      color: mainaccent,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(
                      left: 20,
                      right: 20,
                      top: h * 0.015,
                    ),
                    height: h * 0.14,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Container(
                          width: 100,
                          height: 100,
                          alignment: Alignment.center,
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color:
                                ref
                                        .read(themeNotifierProvider.notifier)
                                        .isDarkTheme()
                                    ? maincolorDark
                                    : maincolor,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                offset: Offset(0, 0),
                                color:
                                    ref
                                            .read(
                                              themeNotifierProvider.notifier,
                                            )
                                            .isDarkTheme()
                                        ? white.withValues(alpha: 0.08)
                                        : black.withValues(alpha: 0.2),
                                blurRadius: 20,
                              ),
                            ],
                          ),
                          child: Image.asset(
                            "assets/logo.png",
                            fit: BoxFit.contain,
                            scale: 1.5,
                          ),
                        ),
                        Row(
                          children: [
                            IconButton(
                              onPressed:
                                  () =>
                                      ref
                                          .read(themeNotifierProvider.notifier)
                                          .toggleTheme(),
                              icon:
                                  ref
                                          .read(themeNotifierProvider.notifier)
                                          .isDarkTheme()
                                      ? Icon(
                                        Icons.dark_mode,
                                        color: maincolor.withValues(alpha: 0.8),
                                        size: 27,
                                      )
                                      : Icon(
                                        Icons.light_mode,
                                        color: maincolor,
                                        size: 27,
                                      ),
                            ),
                            IconButton(
                              onPressed: () async {
                                String connect = await getDatas(
                                  logins,
                                  passwords,
                                  keyCodes,
                                );
                                Map<String, Map<String, Map<String, String>>>
                                initData = datasFromJson(connect);
                                // Hive
                                if (ref
                                        .read(keyBoxProvider)
                                        .containsKey('key') ==
                                    true) {
                                  ref.read(keyBoxProvider).delete('key');
                                }
                                ref
                                    .read(keyBoxProvider)
                                    .put("key", AllKeys(keys: initData));
                                Navigator.pushNamed(context, "/");
                              },
                              icon: Icon(
                                Icons.rotate_left,
                                color:
                                    ref
                                            .read(
                                              themeNotifierProvider.notifier,
                                            )
                                            .isDarkTheme()
                                        ? maincolor.withValues(alpha: 0.8)
                                        : maincolor,
                                size: 27,
                              ),
                              // Image.asset(
                              //   "assets/refresh.png",
                              //   width: 30,
                              //   color: themeController.isDarkTheme.value ? maincolor.withValues(alpha:0.8) : maincolor,
                              // )
                            ),
                            FutureBuilder<Map<String, ArNews>>(
                              future: getNews(),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  int newsCount = 7;
                                  List<String> nIds = [];
                                  for (String nId in snapshot.data!.keys) {
                                    nIds.add(nId);
                                  }
                                  if (ref
                                          .read(newsIdBoxProvider)
                                          .containsKey('count') ==
                                      true) {
                                    for (
                                      var i = 0;
                                      i <
                                          ref
                                              .read(newsIdBoxProvider)
                                              .get("count")!
                                              .nCount
                                              .length;
                                      i++
                                    ) {
                                      for (String nId in snapshot.data!.keys) {
                                        if (nId ==
                                            ref
                                                .read(newsIdBoxProvider)
                                                .get("count")
                                                ?.nCount[i]) {
                                          newsCount -= 1;
                                        }
                                      }
                                    }
                                  }
                                  return IconButton(
                                    onPressed: () async {
                                      await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder:
                                              (BuildContext context) => News(),
                                        ),
                                      );
                                    },
                                    style: ButtonStyle(
                                      backgroundColor: WidgetStateProperty.all(
                                        Colors.transparent,
                                      ),
                                      shadowColor: WidgetStateProperty.all(
                                        Colors.transparent,
                                      ),
                                      padding: WidgetStateProperty.all(
                                        EdgeInsets.zero,
                                      ),
                                    ),
                                    icon: Badge(
                                      badgeStyle: BadgeStyle(
                                        elevation: 0,
                                        badgeColor: thirdaccent,
                                        padding: EdgeInsets.all(5),
                                      ),
                                      position: BadgePosition.custom(
                                        end: -5,
                                        top: -5,
                                      ),
                                      showBadge: newsCount != 0 ? true : false,
                                      badgeContent: Text(
                                        "$newsCount",
                                        style: TextStyle(
                                          color: white,
                                          fontSize: 7,
                                        ),
                                      ),
                                      child: Icon(
                                        Icons.language,
                                        color:
                                            ref
                                                    .read(
                                                      themeNotifierProvider
                                                          .notifier,
                                                    )
                                                    .isDarkTheme()
                                                ? maincolor.withValues(
                                                  alpha: 0.8,
                                                )
                                                : maincolor,
                                        size: 27,
                                      ),
                                    ),
                                  );
                                } else {
                                  return IconButton(
                                    onPressed: () {},
                                    style: ButtonStyle(
                                      backgroundColor: WidgetStateProperty.all(
                                        Colors.transparent,
                                      ),
                                      shadowColor: WidgetStateProperty.all(
                                        Colors.transparent,
                                      ),
                                      padding: WidgetStateProperty.all(
                                        EdgeInsets.zero,
                                      ),
                                    ),
                                    icon: Badge(
                                      showBadge: true,
                                      badgeStyle: BadgeStyle(
                                        elevation: 0,
                                        badgeColor: thirdaccent,
                                        padding: const EdgeInsets.all(5),
                                      ),
                                      position: BadgePosition.custom(
                                        end: -5,
                                        top: -5,
                                      ),
                                      badgeContent: const SpinKitFadingCircle(
                                        color: white,
                                        size: 10.0,
                                      ),
                                      child: Icon(
                                        Icons.language,
                                        color:
                                            ref
                                                    .read(
                                                      themeNotifierProvider
                                                          .notifier,
                                                    )
                                                    .isDarkTheme()
                                                ? maincolor.withValues(
                                                  alpha: 0.8,
                                                )
                                                : maincolor,
                                        size: 27,
                                      ),
                                    ),
                                  );
                                }
                              },
                            ),
                            IconButton(
                              onPressed: () async {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return ExitAlert();
                                  },
                                );
                              },
                              style: ButtonStyle(
                                backgroundColor: WidgetStateProperty.all(
                                  Colors.transparent,
                                ),
                                shadowColor: WidgetStateProperty.all(
                                  Colors.transparent,
                                ),
                                padding: WidgetStateProperty.all(
                                  EdgeInsets.zero,
                                ),
                              ),
                              icon: Icon(
                                Icons.logout,
                                size: 27,
                                color:
                                    ref
                                            .read(
                                              themeNotifierProvider.notifier,
                                            )
                                            .isDarkTheme()
                                        ? maincolor.withValues(alpha: 0.8)
                                        : maincolor,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
