import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mawy_dashboard/theme_provider.dart';

import '/global/colors.dart';
import '/global/strings.dart';
import '/global/text_styles.dart';
import '/main.dart';

class ExitAlert extends ConsumerWidget {
  const ExitAlert({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // double w = MediaQuery.of(context).size.width;
    bool isDark = ref.watch(themeNotifierProvider.notifier).isDarkTheme();
    // double h = MediaQuery.of(context).size.height;
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
      contentPadding: EdgeInsets.all(0),
      content: Container(
        width: 250,
        height: 150,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: white.withValues(alpha: 0.2),
                  width: 0.5,
                ),
                borderRadius: BorderRadius.all(Radius.circular(12)),
                color: isDark ? maincolorDark : white,
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 25),
                  child: Text(
                    AppStrings.logoutmessage,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      color: isDark ? white.withValues(alpha: 0.7) : textcolor,
                    ),
                  ),
                ),
                Expanded(
                  child: Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              border: Border(
                                right: BorderSide(
                                  width: 1,
                                  color:
                                      isDark
                                          ? white.withValues(alpha: 0.2)
                                          : textcolor.withValues(alpha: 0.2),
                                ),
                                top: BorderSide(
                                  width: 1,
                                  color:
                                      isDark
                                          ? white.withValues(alpha: 0.2)
                                          : textcolor.withValues(alpha: 0.2),
                                ),
                              ),
                            ),
                            child: Text(
                              AppStrings.no,
                              textAlign: TextAlign.center,
                              style: regular.copyWith(color: red, fontSize: 18),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            if (ref
                                    .read(authCheckBoxProvider)
                                    .containsKey('login') ==
                                true) {
                              ref.read(authCheckBoxProvider).delete('login');
                            }
                            Navigator.pushNamed(context, "/");
                          },
                          child: Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              border: Border(
                                top: BorderSide(
                                  width: 1,
                                  color:
                                      isDark
                                          ? white.withValues(alpha: 0.2)
                                          : textcolor.withValues(alpha: 0.2),
                                ),
                              ),
                            ),
                            child: Text(
                              AppStrings.yes,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 18,
                                color:
                                    isDark
                                        ? white.withValues(alpha: 0.7)
                                        : textcolor,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
