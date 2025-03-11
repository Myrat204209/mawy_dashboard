import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mawy_dashboard/theme_provider.dart';

import '/global/colors.dart';
import '/main.dart';
import '/objects/diagramm_key.dart';

class OneCard extends ConsumerWidget {
  const OneCard({super.key});
  // List<String> header = r!.get('key')!.keys.keys.toList();
  // List<DiagramKey> headers = [];
  // List datas = [];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    double w = MediaQuery.sizeOf(context).width;
    double h = MediaQuery.sizeOf(context).height;

    return ListView.builder(
      itemBuilder: (context, index) {
        return Container(
          margin: EdgeInsets.only(bottom: 20),
          padding: EdgeInsets.only(top: 10, left: 5, right: 5),
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                offset: Offset(0, 0),
                color: black.withValues(alpha: 0.08),
                blurRadius: 15,
              ),
            ],
            color:
                ref.read(themeNotifierProvider.notifier).isDarkTheme()
                    ? white.withValues(alpha: 0.2)
                    : Color(0xffF8F8F8),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Text(
                  headers[i].hdr,
                  style: TextStyle(
                    fontSize: 18,
                    color:
                        ref.read(themeNotifierProvider.notifier).isDarkTheme()
                            ? white.withValues(alpha: 0.7)
                            : textcolor.withValues(alpha: 0.8),
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Container(
                width: w * 0.8,
                // width: w * 0.5,
                height: 1,
                color: grey,
                margin: EdgeInsets.only(bottom: 10),
              ),
              buildDiagram(datas = [i, keyBox!.get('key')!.keys]),
            ],
          ),
        );
      },
      padding: EdgeInsets.only(top: h * 0.2, left: 20, right: 20, bottom: 20),
      physics: BouncingScrollPhysics(),
    );
  }
}
