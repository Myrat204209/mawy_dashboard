import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_expanded_tile/flutter_expanded_tile.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '/global/colors.dart';
import '/global/text_styles.dart';
import '/objects/diagramm_key.dart';

/// ---
///
/// Data Model & Helpers
///
class SellData {
  SellData(this.x, this.y);
  final String x;
  final String y;
}

class TableSum {
  static String total(List<String> numY) {
    int sum = numY.fold(0, (prev, e) => prev + int.parse(e));
    return sum.toString();
  }

  static String middle(List<String> numY) {
    int sum = numY.fold(0, (prev, e) => prev + int.parse(e));
    int mid = sum ~/ numY.length;
    return mid.toString();
  }

  static String maxI(List<String> numY) {
    int maxVal = numY.map((e) => int.parse(e)).fold(0, max);
    return maxVal.toString();
  }

  static String minI(List<String> numY) {
    int minVal = numY
        .map((e) => int.parse(e))
        .fold(0, (prev, e) => min(prev, e));
    return minVal.toString();
  }
}

String numMoney(String diagInfo) {
  return diagInfo.replaceAllMapped(
    RegExp(r"(\d)(?=(\d{3})+(?!\d))"),
    (match) => "${match.group(0)} ",
  );
}

/// ---
///
/// FutureProvider for Diagram Data Processing
///
final previewDiagramProvider = FutureProvider.family<List<dynamic>, dynamic>((
  ref,
  inputData,
) async {
  // inputData: [index, Map<String, dynamic>]
  List<String> header = inputData[1].entries();
  List<DiagrammKey> headers = [];

  String tPY = "${headers[inputData[0]].tpy}";

  List<Map<String, dynamic>> diagrams = inputData[1].values.toList();
  List diagramName = [];
  for (var i = 0; i < diagrams[inputData[0]].length; i++) {
    final diagName = diagrams[inputData[0]].keys.toList();
    diagramName.add(diagName);
  }

  List diagramKey = [];
  for (var i = 0; i < diagramName[0].length; i++) {
    final diagKey = diagrams[inputData[0]].values.toList();
    diagramKey.add(diagKey);
  }

  int sum = 0;
  List maxx = [];
  for (var i = 0; i < diagramKey[0].length; i++) {
    int num = diagramKey[0][i].length;
    maxx.add(num);
  }
  for (var v in maxx) {
    sum = max(sum, v);
  }

  List diagramKeyX = [];
  List diagramKeyY = [];
  const String fillerX = "empty";
  const String fillerY = "0";

  for (var i = 0; i < diagramKey[0].length; i++) {
    List diagKeyX = diagramKey[0][i].keys.toList();
    if (sum != diagramKey[0][i].keys.length) {
      int diff = sum - diagramKey[0][i].keys.length;
      for (var j = 0; j < diff; j++) {
        diagKeyX.add(fillerX);
      }
    }
    diagramKeyX.add(diagKeyX);
  }

  for (var i = 0; i < diagramKey[0].length; i++) {
    List diagKeyY = diagramKey[0][i].values.toList();
    if (sum != diagramKey[0][i].values.length) {
      int diff = sum - diagramKey[0][i].values.length;
      for (var j = 0; j < diff; j++) {
        diagKeyY.add(fillerY);
      }
    }
    diagramKeyY.add(diagKeyY);
  }

  final List<SellData> sellData = [];
  for (var i = 0; i < diagramKey[0][0].length; i++) {
    sellData.add(SellData(diagramKeyX[0][i], diagramKeyY[0][i]));
  }

  final List KeysData = [];
  for (var d = 0; d < diagramKey[0].length; d++) {
    final List<SellData> testData = [];
    for (var i = 0; i < diagramKey[d][0].length; i++) {
      testData.add(SellData(diagramKeyX[d][i], diagramKeyY[d][i]));
    }
    KeysData.add(testData);
  }

  return [tPY, sellData, diagramName[0], diagramKeyX, diagramKeyY, KeysData];
});

/// ---
///
/// Preview Diagram Widgets
///

/// PreviewDiagram uses the FutureProvider to load data and then builds a preview.
class PreviewDiagram extends HookConsumerWidget {
  const PreviewDiagram({super.key, required this.data});
  final dynamic data;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncDiag = ref.watch(previewDiagramProvider(data));
    return asyncDiag.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, st) => Center(child: Text('Error: $e')),
      data: (diagInfo) {
        return SafeArea(
          child: PreviewSyncfusion(diagInfo: diagInfo, index: data[0]),
        );
      },
    );
  }
}

/// BuildDiagram builds both the Syncfusion chart and a table.
class BuildDiagram extends HookConsumerWidget {
  const BuildDiagram({super.key, required this.data});
  final dynamic data;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncDiag = ref.watch(previewDiagramProvider(data));
    return asyncDiag.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, st) => Center(child: Text('Error: $e')),
      data: (diagInfo) {
        return Column(
          children: [
            BuildSyncfusion(diagInfo: diagInfo),
            BuildTable(diagInfo: diagInfo),
          ],
        );
      },
    );
  }
}

/// PreviewSyncfusion renders a chart preview based on TPY type.
class PreviewSyncfusion extends HookConsumerWidget {
  const PreviewSyncfusion({
    super.key,
    required this.diagInfo,
    required this.index,
  });
  final List<dynamic> diagInfo;
  final int index;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = ref.watch(themeNotifierProvider) == ThemeMode.dark;
    int tpy = int.parse(diagInfo[0]);
    switch (tpy) {
      case 1:
        return SizedBox(
          height: 130,
          width: 200,
          child: SfCartesianChart(
            plotAreaBorderColor: white,
            primaryXAxis: CategoryAxis(isVisible: false),
            primaryYAxis: CategoryAxis(isVisible: false),
            palette: <Color>[yellow],
            series: <CartesianSeries>[
              ColumnSeries<SellData, String>(
                animationDuration: 0,
                dataSource: diagInfo[1],
                xValueMapper: (SellData data, _) => data.x,
                yValueMapper: (SellData data, _) => int.parse(data.y),
                name: "${diagInfo[2][0]}",
                dataLabelSettings: const DataLabelSettings(isVisible: false),
              ),
            ],
          ),
        );
      case 2:
        return SizedBox(
          height: 130,
          width: 200,
          child: SfCircularChart(
            palette: [
              lightpink,
              green,
              lightblue,
              orange,
              blue,
              yellow,
              forestgreen,
              purple,
              pink,
              lazur,
            ],
            series: <CircularSeries<SellData, String>>[
              DoughnutSeries<SellData, String>(
                animationDuration: 0,
                dataSource: diagInfo[1],
                xValueMapper: (SellData sell, _) => sell.x,
                yValueMapper: (SellData sell, _) => int.parse(sell.y),
                name: "${diagInfo[2][0]}",
                dataLabelSettings: const DataLabelSettings(isVisible: false),
              ),
            ],
          ),
        );
      case 3:
        return SizedBox(
          height: 130,
          width: 200,
          child: SfCircularChart(
            palette: [
              lightpink,
              green,
              lightblue,
              orange,
              blue,
              yellow,
              forestgreen,
              purple,
              pink,
              lazur,
            ],
            series: <CircularSeries<SellData, String>>[
              PieSeries<SellData, String>(
                animationDuration: 0,
                dataSource: diagInfo[1],
                xValueMapper: (SellData sell, _) => sell.x,
                yValueMapper: (SellData sell, _) => int.parse(sell.y),
                name: "${diagInfo[2][0]}",
                dataLabelSettings: const DataLabelSettings(isVisible: false),
              ),
            ],
          ),
        );
      case 4:
        return SizedBox(
          height: 130,
          width: 200,
          child: SfCartesianChart(
            plotAreaBorderColor: white,
            primaryXAxis: CategoryAxis(isVisible: false),
            primaryYAxis: CategoryAxis(isVisible: false),
            palette: <Color>[forestgreen],
            series: <CartesianSeries>[
              ...List.generate(
                diagInfo[3].length,
                (i) => SplineSeries<SellData, String>(
                  animationDuration: 0,
                  dataSource: diagInfo[5][i],
                  xValueMapper: (SellData data, _) => data.x,
                  yValueMapper: (SellData data, _) => int.parse(data.y),
                  name: "${diagInfo[2][i]}",
                  dataLabelSettings: const DataLabelSettings(isVisible: false),
                ),
              ),
            ],
          ),
        );
      case 5:
        return SizedBox(
          height: 130,
          width: 200,
          child: SfCartesianChart(
            plotAreaBorderColor: white,
            primaryXAxis: CategoryAxis(isVisible: false, isInversed: true),
            primaryYAxis: CategoryAxis(isVisible: false),
            palette: <Color>[lazur],
            series: <CartesianSeries>[
              BarSeries<SellData, String>(
                animationDuration: 0,
                dataSource: diagInfo[1],
                xValueMapper: (SellData data, _) => data.x,
                yValueMapper: (SellData data, _) => int.parse(data.y),
                name: "${diagInfo[2][0]}",
                dataLabelSettings: const DataLabelSettings(isVisible: false),
              ),
            ],
          ),
        );
      case 8:
        return Image.asset(
          "assets/table.png",
          height: MediaQuery.of(context).size.height * 0.15,
        );
      default:
        return Center(
          child: Column(
            children: [
              const SizedBox(height: 10.0),
              Text(
                "Grafik verisi mevcut değil",
                style: regular.copyWith(fontSize: 10),
              ),
            ],
          ),
        );
    }
  }
}

/// ---
///
/// BuildSyncfusion and BuildTable widgets
///

class BuildSyncfusion extends HookConsumerWidget {
  const BuildSyncfusion({super.key, required this.diagInfo});
  final List<dynamic> diagInfo;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Use theme mode via Riverpod.
    final isDark = ref.watch(themeNotifierProvider) == ThemeMode.dark;
    // For brevity, we handle only case 1 here; add other cases as needed.
    switch (int.parse(diagInfo[0][0])) {
      case 1:
        return SfCartesianChart(
          plotAreaBorderWidth: 1,
          primaryXAxis: CategoryAxis(
            isVisible: true,
            labelRotation: 45,
            interval: 1,
            labelStyle: TextStyle(
              fontSize: 8,
              color: isDark ? white.withValues(alpha: 0.7) : textcolor,
            ),
            interactiveTooltip: InteractiveTooltip(enable: true),
            initialZoomFactor: 1,
          ),
          zoomPanBehavior: ZoomPanBehavior(
            enablePanning: true,
            enablePinching: true,
            zoomMode: ZoomMode.x,
          ),
          legend: Legend(
            isVisible: true,
            position: LegendPosition.top,
            overflowMode: LegendItemOverflowMode.scroll,
            textStyle: TextStyle(
              color: isDark ? white.withValues(alpha: 0.7) : textcolor,
            ),
          ),
          primaryYAxis: NumericAxis(
            labelStyle: TextStyle(
              fontSize: 8,
              color: isDark ? white.withValues(alpha: 0.7) : textcolor,
            ),
          ),
          palette: <Color>[orange],
          series: <CartesianSeries>[
            ColumnSeries<SellData, String>(
              dataSource: diagInfo[1],
              xValueMapper:
                  (SellData data, _) =>
                      (data.x != "empty" && data.x.length >= 3)
                          ? data.x.substring(0, 3)
                          : data.x,
              yValueMapper: (SellData data, _) => int.parse(data.y),
              name: "${diagInfo[2][0]}",
              animationDuration: 0,
              dataLabelSettings: DataLabelSettings(
                isVisible: false,
                textStyle: TextStyle(
                  color: isDark ? white.withValues(alpha: 0.7) : textcolor,
                ),
              ),
            ),
          ],
        );
      default:
        return const SizedBox();
    }
  }
}

class BuildTable extends HookConsumerWidget {
  const BuildTable({super.key, required this.diagInfo});
  final List<dynamic> diagInfo;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = ref.watch(themeNotifierProvider) == ThemeMode.dark;
    return FutureBuilder<List<dynamic>>(
      future: Future.value(diagInfo),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          final diagData = snapshot.data as List<dynamic>;
          final tileController = useMemoized(
            () => ExpandedTileController(isExpanded: false),
          );
          switch (int.parse(diagData[0][1])) {
            case 0:
              return Column(
                children: List.generate(
                  diagData[3].length,
                  (index) => BuildExpandedTable(
                    tableName: diagData[2][index],
                    tableX: diagData[3][index],
                    tableY: diagData[4][index],
                    totalText: "Tutar",
                    totalNum: TableSum.total(diagData[4][index]),
                    tableTPY: int.parse(diagData[0][0]),
                    tileController: tileController,
                    isDark: isDark,
                  ),
                ),
              );
            case 1:
              return Column(
                children: List.generate(
                  diagData[3].length,
                  (index) => BuildExpandedTable(
                    tableName: diagData[2][index],
                    tableX: diagData[3][index],
                    tableY: diagData[4][index],
                    totalText: "Ortalama",
                    totalNum: TableSum.middle(diagData[4][index]),
                    tableTPY: int.parse(diagData[0][0]),
                    tileController: tileController,
                    isDark: isDark,
                  ),
                ),
              );
            case 2:
              return Column(
                children: List.generate(
                  diagData[3].length,
                  (index) => BuildExpandedTable(
                    tableName: diagData[2][index],
                    tableX: diagData[3][index],
                    tableY: diagData[4][index],
                    totalText: "Maks",
                    totalNum: TableSum.maxI(diagData[4][index]),
                    tableTPY: int.parse(diagData[0][0]),
                    tileController: tileController,
                    isDark: isDark,
                  ),
                ),
              );
            case 3:
              return Column(
                children: List.generate(
                  diagData[3].length,
                  (index) => BuildExpandedTable(
                    tableName: diagData[2][index],
                    tableX: diagData[3][index],
                    tableY: diagData[4][index],
                    totalText: "Min",
                    totalNum: TableSum.minI(diagData[4][index]),
                    tableTPY: int.parse(diagData[0][0]),
                    tileController: tileController,
                    isDark: isDark,
                  ),
                ),
              );
            case 9:
              return Column(
                children: List.generate(
                  diagData[3].length,
                  (index) => BuildExpandedTable(
                    tableName: diagData[2][index],
                    tableX: diagData[3][index],
                    tableY: diagData[4][index],
                    totalText: "",
                    totalNum: 0,
                    tableTPY: int.parse(diagData[0][0]),
                    tileController: tileController,
                    isDark: isDark,
                  ),
                ),
              );
            default:
              return const Text("");
          }
        }
      },
    );
  }
}

/// Expanded Table Widget
class BuildExpandedTable extends HookConsumerWidget {
  const BuildExpandedTable({
    super.key,
    required this.tableName,
    required this.tableX,
    required this.tableY,
    required this.totalText,
    required this.totalNum,
    required this.tableTPY,
    required this.tileController,
    required this.isDark,
  });

  final String tableName;
  final List tableX;
  final List tableY;
  final String totalText;
  final dynamic totalNum;
  final int tableTPY;
  final ExpandedTileController tileController;
  final bool isDark;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: ExpandedTile(
        trailing: Icon(
          Icons.arrow_drop_down_outlined,
          color: isDark ? maincolor : secondaccent,
        ),
        trailingRotation: 180,
        contentseparator: 0,
        expansionDuration: const Duration(milliseconds: 300),
        theme: ExpandedTileThemeData(
          headerColor:
              isDark
                  ? maincolorDark.withValues(alpha: 0.5)
                  : darkgrey.withValues(alpha: 0.1),
          contentBackgroundColor: Colors.transparent,
          headerSplashColor: isDark ? secondaccent : mainaccent,
          contentPadding: const EdgeInsets.symmetric(horizontal: 10),
        ),
        title: Text(
          tableName,
          style: TextStyle(
            fontSize: 16,
            color: isDark ? white.withValues(alpha: 0.7) : textcolor,
          ),
        ),
        controller: tileController,
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ...List.generate(
              tableX.length,
              (i) => Container(
                decoration: BoxDecoration(
                  border:
                      tableX[i] != "empty"
                          ? Border(
                            bottom: BorderSide(color: textcolor, width: 1),
                          )
                          : null,
                ),
                child:
                    tableX[i] != "empty"
                        ? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width * 0.5,
                              alignment: Alignment.centerLeft,
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: Text(
                                "$tableX[i]",
                                overflow: TextOverflow.clip,
                                style: TextStyle(
                                  fontSize: 14,
                                  color:
                                      isDark
                                          ? white.withValues(alpha: 0.7)
                                          : textcolor,
                                ),
                              ),
                            ),
                            Container(
                              alignment: Alignment.centerRight,
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: Text(
                                numMoney(tableY[i]),
                                style: TextStyle(
                                  fontSize: 14,
                                  color:
                                      isDark
                                          ? white.withValues(alpha: 0.7)
                                          : textcolor,
                                ),
                              ),
                            ),
                          ],
                        )
                        : const SizedBox(),
              ),
            ),
            totalText != ""
                ? Container(
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: textcolor, width: 1),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * 0.5,
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Text(
                          totalText,
                          overflow: TextOverflow.clip,
                          style: TextStyle(
                            fontSize: 14,
                            color:
                                isDark
                                    ? white.withValues(alpha: 0.7)
                                    : textcolor,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      Container(
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Text(
                          numMoney(totalNum.toString()),
                          style: TextStyle(
                            fontSize: 14,
                            color:
                                isDark ? const Color(0xff9EB5DD) : mainaccent,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ],
                  ),
                )
                : const SizedBox(),
          ],
        ),
      ),
    );
  }
}
