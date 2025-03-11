import 'package:flutter/material.dart';
import 'package:flutter_bounce/flutter_bounce.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mawy_dashboard/hive/hive_objects.dart';
import 'package:mawy_dashboard/objects/custom_text_field.dart';
import 'package:mawy_dashboard/theme_provider.dart';
import 'package:mawy_dashboard/widgets/clipper.dart' show AppbarClipper;

import '/global/colors.dart';
import '/global/methods.dart';
import '/global/strings.dart';
import '/global/values.dart';
import '/main.dart';
import '/objects/datas.dart';
import '../request/get_data.dart';

class LoginPage extends HookConsumerWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Text controllers using flutter_hooks.
    final loginController = useTextEditingController();
    final passwordController = useTextEditingController();
    final keyCodeController = useTextEditingController();
    // Local state managed by hooks.
    final isCheck = useState(false);
    final isLoad = useState(false);

    // Initialize text controllers from Hive data (if available).
    useEffect(() {
      if (ref.read(loginBoxProvider).containsKey('login') == true) {
        final saved = ref.read(loginBoxProvider).get("login");
        loginController.text = saved.logins;
        passwordController.text = saved.passwords;
        keyCodeController.text = saved.keys;
        isCheck.value = saved.check;
      }
      return null;
    }, []);

    // Build list of custom textfields.
    final textfields = [
      CustomTextField(
        controller: loginController,
        label: AppStrings.loginplaceholder,
      ),
      CustomTextField(
        controller: passwordController,
        label: AppStrings.passplaceholder,
      ),
      CustomTextField(
        controller: keyCodeController,
        label: AppStrings.keyplaceholder,
      ),
    ];

    // Watch the current theme from Riverpod.
    final currentTheme = ref.watch(themeNotifierProvider);
    final isDark = currentTheme == ThemeMode.dark;

    final w = MediaQuery.sizeOf(context).width;
    final h = MediaQuery.sizeOf(context).height;
    final clipper = AppbarClipper();

    return Scaffold(
      backgroundColor: isDark ? maincolorDark : maincolor,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(
            child: SizedBox(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  ClipPath(
                    clipper: clipper,
                    child: Container(width: w, height: 200, color: mainaccent),
                  ),
                  Positioned(
                    right: 20,
                    bottom: 30,
                    child: Container(
                      width: 100,
                      height: 100,
                      padding: const EdgeInsets.all(10),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: isDark ? maincolorDark : maincolor,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            offset: const Offset(0, 0),
                            color:
                                isDark
                                    ? white.withValues(alpha: 0.08)
                                    : black.withValues(alpha: 0.2),
                            blurRadius: 15,
                          ),
                        ],
                      ),
                      child: Image.asset(
                        "assets/logo.png",
                        fit: BoxFit.contain,
                        scale: 1.5,
                      ),
                    ),
                  ),
                  const Positioned(
                    left: 20,
                    child: Text(
                      "Dashboards",
                      style: TextStyle(
                        fontSize: 30,
                        color: maincolor,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Login form section.
          SliverToBoxAdapter(
            child: Container(
              margin: EdgeInsets.only(left: 20, right: 20, top: h * 0.025),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(bottom: h * 0.05),
                        child: Text(
                          AppStrings.login,
                          style: TextStyle(
                            fontSize: 25,
                            color:
                                isDark
                                    ? white.withValues(alpha: 0.7)
                                    : textcolor,
                          ),
                        ),
                      ),
                      ...textfields,

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            onPressed: () {
                              ref
                                  .read(themeNotifierProvider.notifier)
                                  .toggleTheme();
                            },
                            icon:
                                isDark
                                    ? const Icon(
                                      Icons.dark_mode,
                                      color: secondaccent,
                                      size: 30,
                                    )
                                    : const Icon(
                                      Icons.light_mode,
                                      color: mainaccent,
                                      size: 30,
                                    ),
                          ),
                          Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  isCheck.value = !isCheck.value;
                                },
                                child: Container(
                                  height: 20,
                                  width: 20,
                                  margin: const EdgeInsets.only(right: 10),
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color:
                                        isCheck.value
                                            ? secondaccent
                                            : Colors.transparent,
                                    border: Border.all(
                                      width: 2,
                                      color:
                                          isCheck.value
                                              ? secondaccent
                                              : isDark
                                              ? white.withValues(alpha: 0.7)
                                              : textcolor.withValues(
                                                alpha: 0.6,
                                              ),
                                    ),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: Icon(
                                    Icons.check,
                                    color:
                                        isCheck.value
                                            ? maincolor
                                            : Colors.transparent,
                                    size: 13,
                                  ),
                                ),
                              ),
                              Text(
                                AppStrings.rememberme,
                                style: TextStyle(
                                  fontSize: 16,
                                  color:
                                      isDark
                                          ? white.withValues(alpha: 0.7)
                                          : textcolor.withValues(alpha: 0.6),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                  Bounce(
                    duration: const Duration(milliseconds: 150),
                    onPressed: () async {
                      isLoad.value = true;
                      logins = loginController.text;
                      passwords = passwordController.text;
                      keyCodes = keyCodeController.text;

                      ref
                          .read(authCheckBoxProvider)
                          .put(
                            "login",
                            AuthCheck(
                              check: true,
                              logins: logins,
                              passwords: passwords,
                              keys: keyCodes,
                            ),
                          );
                      if (isCheck.value) {
                        ref
                            .read(loginBoxProvider)
                            .put(
                              "login",
                              Logins(
                                logins: logins,
                                passwords: passwords,
                                keys: keyCodes,
                                check: isCheck.value,
                              ),
                            );
                      } else {
                        if (ref.read(loginBoxProvider).containsKey('login')) {
                          ref.read(loginBoxProvider).delete('login');
                        }
                      }
                      try {
                        connCheck();
                        String connect = await getDatas(
                          logins,
                          passwords,
                          keyCodes,
                        );
                        final initData = datasFromJson(connect);
                        ref
                            .read(keyBoxProvider)
                            .put("key", AllKeys(keys: initData));
                        Navigator.pushReplacementNamed(context, "/");
                      } catch (e) {
                        String connect = await getDatas(
                          logins,
                          passwords,
                          keyCodes,
                        );
                        if (connect.isEmpty) {
                          showToast("Неверный логин или пароль");
                        } else if (e.toString() ==
                            "type 'Null' is not a subtype of type 'String'") {
                          showToast("Неверный ключ");
                        }
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.only(
                        right: 20,
                        top: 20,
                        bottom: 20,
                        left: 87,
                      ),
                      margin: EdgeInsets.only(bottom: h * 0.05),
                      decoration: BoxDecoration(
                        color: mainaccent,
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(right: 58),
                            child: Text(
                              AppStrings.loginbtn,
                              style: TextStyle(
                                fontSize: 22,
                                color: maincolor,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                          Icon(
                            Icons.arrow_forward_ios_rounded,
                            color: maincolor,
                            size: 20,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
