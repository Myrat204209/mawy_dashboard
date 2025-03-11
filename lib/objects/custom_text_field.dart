import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mawy_dashboard/global/colors.dart';
import 'package:mawy_dashboard/theme_provider.dart';

class CustomTextField extends ConsumerWidget {
  CustomTextField({super.key, required this.label, required this.controller});
  // final CustomTextF data;
  final String label;
  final TextEditingController controller;

  final ValueNotifier<bool> obscuretext = ValueNotifier<bool>(true);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 30),
      child: ValueListenableBuilder(
        valueListenable: obscuretext,
        builder: (context, obscure, _) {
          return TextField(
            controller: controller,
            cursorColor:
                ref.read(themeNotifierProvider.notifier).isDarkTheme()
                    ? white
                    : textcolor,

            style:
            // regular.copyWith(fontSize: 16),
            TextStyle(
              fontSize: 16,
              color:
                  ref.read(themeNotifierProvider.notifier).isDarkTheme()
                      ? white
                      : textcolor,
            ),
            obscureText: obscuretext.value,
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.all(20),
              labelText: label,
              suffixIcon:
                  obscuretext.value
                      ? IconButton(
                        onPressed: () {
                          obscuretext.value = !obscuretext.value;
                        },
                        icon: Icon(
                          obscure ? Icons.visibility : Icons.visibility_off,
                          color:
                              ref
                                      .read(themeNotifierProvider.notifier)
                                      .isDarkTheme()
                                  ? obscure
                                      ? secondaccent
                                      : mainaccent
                                  : obscure
                                  ? textcolor
                                  : textcolor.withValues(alpha: 0.7),
                          size: 27,
                        ),
                      )
                      : null,
              floatingLabelBehavior: FloatingLabelBehavior.always,
              labelStyle:
              // regular.copyWith(fontSize: 18, color: textcolor.withValues(alpha:0.6)),
              TextStyle(
                fontSize: 16,
                color:
                    ref.read(themeNotifierProvider.notifier).isDarkTheme()
                        ? white.withValues(alpha: 0.7)
                        : textcolor,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide(
                  color:
                      ref.read(themeNotifierProvider.notifier).isDarkTheme()
                          ? white.withValues(alpha: 0.5)
                          : textcolor.withValues(alpha: 0.2),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide(
                  color:
                      ref.read(themeNotifierProvider.notifier).isDarkTheme()
                          ? white.withValues(alpha: 0.7)
                          : textcolor.withValues(alpha: 0.5),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
