import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_expanded_tile/flutter_expanded_tile.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mawy_dashboard/theme_provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '/global/colors.dart';
import '/global/text_styles.dart';

class SellData {
  SellData(this.x, this.y);
  final String x;
  final int y;
}

class TableSum {
  static int total(List<String> numY) {
    return numY.fold(0, (prev, e) => prev + int.parse(e));
  }

  static double middle(List<String> numY) {
    return TableSum.total(numY) / numY.length;
  }

  static int maxI(List<String> numY) {
    return numY.map((e) => int.parse(e)).reduce(max);
  }

  static int minI(List<String> numY) {
    return numY.map((e) => int.parse(e)).reduce(min);
  }
}

String numMoney(String diagInfo) {
  return diagInfo.replaceAllMapped(
    RegExp(r"(\d)(?=(\d{3})+(?!\d))"),
    (match) => "${match.group(0)} ",
  );
}

final previewDiagramProvider = FutureProvider.family<DiagramData, DiagramInput>(
  (ref, inputData) async {
    final diagrams = inputData.data.values.toList();

    List<List<String>> diagramKeyX = [];
    List<List<String>> diagramKeyY = [];

    for (var diagram in diagrams) {
      final keys = diagram.keys.toList();
      final values = diagram.values.toList();

      final maxLength = diagrams.map((d) => d.keys.length).reduce(max);
      while (keys.length < maxLength) {
        keys.add("empty");
        values.add("0");
      }

      diagramKeyX.add(keys);
      diagramKeyY.add(values);
    }

    final sellData = [
      for (var i = 0; i < diagramKeyX[0].length; i++)
        SellData(diagramKeyX[0][i], int.parse(diagramKeyY[0][i])),
    ];

    return DiagramData(
      tpy: inputData.tpy,
      sellData: sellData,
      diagramNames: diagrams.map((d) => d.keys.toList()).toList(),
      diagramKeyX: diagramKeyX,
      diagramKeyY: diagramKeyY,
    );
  },
);

class DiagramInput {
  final int tpy;
  final Map<String, Map<String, String>> data;

  DiagramInput({required this.tpy, required this.data});
}

class DiagramData {
  final int tpy;
  final List<SellData> sellData;
  final List<List<String>> diagramNames;
  final List<List<String>> diagramKeyX;
  final List<List<String>> diagramKeyY;

  DiagramData({
    required this.tpy,
    required this.sellData,
    required this.diagramNames,
    required this.diagramKeyX,
    required this.diagramKeyY,
  });
}

class PreviewDiagram extends HookConsumerWidget {
  const PreviewDiagram({super.key, required this.input});

  final DiagramInput input;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncDiag = ref.watch(previewDiagramProvider(input));
    return asyncDiag.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, st) => Center(child: Text('Error: $e')),
      data:
          (diagInfo) => SafeArea(
            child: PreviewSyncfusion(diagInfo: diagInfo, index: input.tpy),
          ),
    );
  }
}

class BuildDiagram extends HookConsumerWidget {
  const BuildDiagram({super.key, required this.input});

  final DiagramInput input;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = ref.watch(themeNotifierProvider.notifier).isDarkTheme();
    final asyncDiag = ref.watch(previewDiagramProvider(input));

    return asyncDiag.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, st) => Center(child: Text('Error: $e')),
      data:
          (diagInfo) => Column(
            children: [
              // Pass isDark to buildSyncfusion
              buildSyncfusion(diagInfo, isDark),
              buildTable(diagInfo, isDark),
            ],
          ),
    );
  }
}

class PreviewSyncfusion extends HookConsumerWidget {
  const PreviewSyncfusion({
    super.key,
    required this.diagInfo,
    required this.index,
  });

  final DiagramData diagInfo;
  final int index;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chartType = diagInfo.tpy ~/ 10; // First digit for chart type
    switch (chartType) {
      case 1:
        return SizedBox(
          height: 130,
          width: 200,
          child: SfCartesianChart(
            plotAreaBorderColor: white,
            primaryXAxis: CategoryAxis(isVisible: false),
            primaryYAxis: CategoryAxis(isVisible: false),
            palette: [yellow],
            series: <CartesianSeries>[
              ColumnSeries<SellData, String>(
                animationDuration: 0,
                dataSource: diagInfo.sellData,
                xValueMapper: (SellData data, _) => data.x,
                yValueMapper: (SellData data, _) => data.y,
                name: diagInfo.diagramNames[0][0],
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
            series: <CircularSeries<SellData, String>>[
              DoughnutSeries<SellData, String>(
                animationDuration: 0,
                dataSource: diagInfo.sellData,
                xValueMapper: (SellData sell, _) => sell.x,
                yValueMapper: (SellData sell, _) => sell.y,
                name: diagInfo.diagramNames[0][0],
                dataLabelSettings: const DataLabelSettings(isVisible: false),
              ),
            ],
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
          ),
        );
      case 3:
        return SizedBox(
          height: 130,
          width: 200,
          child: SfCircularChart(
            series: <CircularSeries<SellData, String>>[
              PieSeries<SellData, String>(
                animationDuration: 0,
                dataSource: diagInfo.sellData,
                xValueMapper: (SellData sell, _) => sell.x,
                yValueMapper: (SellData sell, _) => sell.y,
                name: diagInfo.diagramNames[0][0],
                dataLabelSettings: const DataLabelSettings(isVisible: false),
              ),
            ],
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
            palette: [forestgreen],
            series: <CartesianSeries>[
              for (int i = 0; i < diagInfo.diagramKeyX.length; i++)
                SplineSeries<SellData, String>(
                  animationDuration: 0,
                  dataSource: [
                    for (int j = 0; j < diagInfo.diagramKeyX[i].length; j++)
                      SellData(
                        diagInfo.diagramKeyX[i][j],
                        int.parse(diagInfo.diagramKeyY[i][j]),
                      ),
                  ],
                  xValueMapper: (SellData data, _) => data.x,
                  yValueMapper: (SellData data, _) => data.y,
                  name: diagInfo.diagramNames[i][0],
                  dataLabelSettings: const DataLabelSettings(isVisible: false),
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
            palette: [lazur],
            series: <CartesianSeries>[
              BarSeries<SellData, String>(
                animationDuration: 0,
                dataSource: diagInfo.sellData,
                xValueMapper: (SellData data, _) => data.x,
                yValueMapper: (SellData data, _) => data.y,
                name: diagInfo.diagramNames[0][0],
                dataLabelSettings: const DataLabelSettings(isVisible: false),
              ),
            ],
          ),
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

Widget buildSyncfusion(DiagramData diagInfo, bool isDark) {
  final chartType = diagInfo.tpy ~/ 10; // Example logic for chart type

  switch (chartType) {
    case 1:
      return SfCartesianChart(
        plotAreaBorderWidth: 1,
        primaryXAxis: CategoryAxis(
          isVisible: true,
          labelRotation: 45,
          interval: 1,
          labelStyle: TextStyle(
            fontSize: 8,
            // Use isDark to set color
            color: isDark ? Colors.white.withAlpha(7) : Colors.black,
          ),
          interactiveTooltip: const InteractiveTooltip(enable: true),
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
            // Use isDark to set legend text color
            color: isDark ? Colors.white.withAlpha(7) : Colors.black,
          ),
        ),
        primaryYAxis: NumericAxis(
          labelStyle: TextStyle(
            fontSize: 8,
            // Use isDark to set Y-axis label color
            color: isDark ? Colors.white.withAlpha(7) : Colors.black,
          ),
        ),
        palette: [Colors.orange], // Example color
        series: <CartesianSeries>[
          ColumnSeries<SellData, String>(
            dataSource: diagInfo.sellData,
            xValueMapper:
                (SellData data, _) =>
                    data.x.length >= 3 ? data.x.substring(0, 3) : data.x,
            yValueMapper: (SellData data, _) => data.y,
            name: diagInfo.diagramNames[0][0],
            animationDuration: 0,
            dataLabelSettings: DataLabelSettings(
              isVisible: false,
              textStyle: TextStyle(
                // Use isDark to set data label color
                color: isDark ? Colors.white.withAlpha(7) : Colors.black,
              ),
            ),
          ),
        ],
      );
    default:
      return const SizedBox.shrink();
  }
}

Widget buildTable(DiagramData diagInfo, bool isDark) {
  final tableType = diagInfo.tpy % 10; // Second digit for table type
  switch (tableType) {
    case 0:
      return Column(
        children: [
          for (int index = 0; index < diagInfo.diagramNames.length; index++)
            BuildExpandedTable(
              tableName: diagInfo.diagramNames[index][0],
              tableX: diagInfo.diagramKeyX[index],
              tableY: diagInfo.diagramKeyY[index],
              totalText: "Tutar",
              totalNum: TableSum.total(diagInfo.diagramKeyY[index]),
              tableTPY: diagInfo.tpy,
              tileController: ExpandedTileController(isExpanded: false),
              isDark: isDark,
            ),
        ],
      );
    case 1:
      return Column(
        children: [
          for (int index = 0; index < diagInfo.diagramNames.length; index++)
            BuildExpandedTable(
              tableName: diagInfo.diagramNames[index][0],
              tableX: diagInfo.diagramKeyX[index],
              tableY: diagInfo.diagramKeyY[index],
              totalText: "Ortalama",
              totalNum: TableSum.middle(diagInfo.diagramKeyY[index]),
              tableTPY: diagInfo.tpy,
              tileController: ExpandedTileController(isExpanded: false),
              isDark: isDark,
            ),
        ],
      );
    case 2:
      return Column(
        children: [
          for (int index = 0; index < diagInfo.diagramNames.length; index++)
            BuildExpandedTable(
              tableName: diagInfo.diagramNames[index][0],
              tableX: diagInfo.diagramKeyX[index],
              tableY: diagInfo.diagramKeyY[index],
              totalText: "Maks",
              totalNum: TableSum.maxI(diagInfo.diagramKeyY[index]),
              tableTPY: diagInfo.tpy,
              tileController: ExpandedTileController(isExpanded: false),
              isDark: isDark,
            ),
        ],
      );
    case 3:
      return Column(
        children: [
          for (int index = 0; index < diagInfo.diagramNames.length; index++)
            BuildExpandedTable(
              tableName: diagInfo.diagramNames[index][0],
              tableX: diagInfo.diagramKeyX[index],
              tableY: diagInfo.diagramKeyY[index],
              totalText: "Min",
              totalNum: TableSum.minI(diagInfo.diagramKeyY[index]),
              tableTPY: diagInfo.tpy,
              tileController: ExpandedTileController(isExpanded: false),
              isDark: isDark,
            ),
        ],
      );
    case 9:
      return Column(
        children: [
          for (int index = 0; index < diagInfo.diagramNames.length; index++)
            BuildExpandedTable(
              tableName: diagInfo.diagramNames[index][0],
              tableX: diagInfo.diagramKeyX[index],
              tableY: diagInfo.diagramKeyY[index],
              totalText: "",
              totalNum: 0,
              tableTPY: diagInfo.tpy,
              tileController: ExpandedTileController(isExpanded: false),
              isDark: isDark,
            ),
        ],
      );
    default:
      return const SizedBox.shrink();
  }
}

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
  final List<String> tableX;
  final List<String> tableY;
  final String totalText;
  final num totalNum; // Use num to handle both int and double from TableSum
  final int tableTPY;
  final ExpandedTileController tileController;
  final bool isDark;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
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
              isDark ? maincolorDark.withAlpha(5) : darkgrey.withAlpha(1),
          contentBackgroundColor: Colors.transparent,
          headerSplashColor: isDark ? secondaccent : mainaccent,
          contentPadding: const EdgeInsets.symmetric(horizontal: 10),
        ),
        title: Text(
          tableName,
          style: TextStyle(
            fontSize: 16,
            color: isDark ? white.withAlpha(7) : textcolor,
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
                                tableX[i],
                                overflow: TextOverflow.clip,
                                style: TextStyle(
                                  fontSize: 14,
                                  color:
                                      isDark ? white.withAlpha(7) : textcolor,
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
                                          ? const Color(0xff9EB5DD)
                                          : mainaccent,
                                ),
                              ),
                            ),
                          ],
                        )
                        : const SizedBox(),
              ),
            ),
            if (totalText.isNotEmpty)
              Container(
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
                          color: isDark ? white.withAlpha(7) : textcolor,
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
                          color: isDark ? const Color(0xff9EB5DD) : mainaccent,
                          fontWeight: FontWeight.w800,
                        ),
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
