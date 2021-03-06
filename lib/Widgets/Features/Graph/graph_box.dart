import 'dart:math';

import 'package:covid/Database/cases.dart';
import 'package:covid/Database/country.dart';
import 'package:covid/Helpers/api.dart';
import 'package:covid/Helpers/constants.dart';
import 'package:covid/Helpers/screensize_reducer.dart';
import 'package:covid/Widgets/Core/custom_icons.dart';
import 'package:covid/Widgets/Core/text_box.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

class GraphBox extends StatefulWidget {
  GraphBox({Key key,
    @required this.country,
  }) : super(key: key);

  final Country country;

  @override
  _GraphBoxState createState() => _GraphBoxState();
}

class _GraphBoxState extends State<GraphBox> {

  API api = new API();
  int _selectedButton = 0;
  int _selectedLabel = 1;
  int _selectedChart = 0;
  Future<CaseStat> _caseStat;
  CaseStat _countryStat;
  int _numberOfDays = 30;
  int touchedIndex = -1;

  void loadData() {
    _caseStat = api.fetchDataByCountry(widget.country, _numberOfDays);
    _caseStat.then((value) { setState(() {
      _countryStat = value;
    });
    });
  }

  @override
  void setState(fn) {
    // TODO: implement setState
    if(this.mounted)
      super.setState(fn);
  }

  @override
  void initState() {
    super.initState();
    loadData();
  }

  @override
  void didUpdateWidget(GraphBox oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
    if(oldWidget.country != widget.country){
      setState(() {
        _countryStat = null;
      });
      loadData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: screenHeight(context, dividedBy: propStatBox) + 4*screenHeight(context, dividedBy: propPaddingLarge),
      child: Center(
        child: Column(
          children: <Widget>[
            getTextButtons(),
            getGraph(),
            getTimingRow(),
          ],
        ),
      )
    );
  }
//----------------------------------------Text Buttons------------------------------------------//
  Widget getTextButtons() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: screenWidth(context, dividedBy: propPaddingLarge/10)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          TextBox(
            index: 0,
            onBoxSelected: this.onBoxSelected,
            active: _selectedButton == 0),
          TextBox(
            index: 1,
            onBoxSelected: this.onBoxSelected,
            active: _selectedButton == 1),
          GestureDetector(
            onTap: () {
              setState(() {
                _selectedChart = 1 - _selectedChart;
              });
            },
            child: Container(
              margin: EdgeInsets.all(10.0),
              height: screenHeight(context, dividedBy: propTextBox),
              width: screenHeight(context, dividedBy: propTextBox),
              decoration: BoxDecoration(
                gradient: box_background,
                color: primary,
                border: Border.all(color: getColorOfLine()),
                borderRadius: BorderRadius.circular(2),
              ),
              child: Center(
                child: Icon(
                  _selectedChart == 0?CustomIcon.bar_chart:CustomIcon.line_chart,
                  size: screenHeight(context, dividedBy: propTextBox*2.0),
                  color: getColorOfLine().withOpacity(0.8),
                ),
              ),
            ),
          ),
          TextBox(
            index: 2,
            onBoxSelected: this.onBoxSelected,
            active: _selectedButton == 2),
          TextBox(
            index: 3,
            onBoxSelected: this.onBoxSelected,
            active: _selectedButton == 3),
        ],
      ),
    );
  }

  void onBoxSelected(int selected){
    setState(() {
      _selectedButton = selected;
    });
  }

//----------------------------------------Graph------------------------------------------//
  Widget getGraph() {
    return Container(
      margin: EdgeInsets.all(screenHeight(context, dividedBy: propPaddingLarge)),
      padding: EdgeInsets.fromLTRB(screenHeight(context, dividedBy: propPaddingSmall),screenHeight(context, dividedBy: propPaddingLarge),
        screenHeight(context, dividedBy: propPaddingLarge),screenHeight(context, dividedBy: propPaddingSmall)),
      width: screenWidth(context) - screenWidth(context, dividedBy: 10.0 ),
      height: screenHeight(context, dividedBy: 3.5),
      decoration: BoxDecoration(
        gradient: box_background,
        boxShadow: outer_icon_shadow,
      ),
      child: FutureBuilder<CaseStat>(
        future: _caseStat,
        builder: (context, snapshot) {
          if(snapshot.connectionState == ConnectionState.waiting){
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          else if(snapshot.hasData && _countryStat!=null){
            return _selectedChart == 0?getLineChart():getBarChart();
          }
          else if(snapshot.hasError){
            final error = snapshot.error;
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text("Please check your internet connection and retry"),
                  IconButton(
                    icon: Icon(Icons.refresh),
                    iconSize: screenHeight(context, dividedBy: propTextBox),
                    onPressed: () {
                      HapticFeedback.lightImpact();
                      setState(() {
                        _countryStat = null;
                      });
                      loadData();
                    },
                    color: faded_orange,
                  ),
                ],
              )
            );
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      )
    );
  }

  LineChart getLineChart(){
    //Construct data points
    List<FlSpot> flSpots = new List();
    int i = 1;
    _countryStat.cases.forEach((caseCount) {
      double yValue = caseCount.infected.toDouble();
      switch(iconBoxTexts[_selectedButton]){
        case "D": yValue = caseCount.deceased.toDouble();break;
        case "R": yValue = caseCount.recovered.toDouble();break;
        case "A": yValue = caseCount.active.toDouble();break;
        default: yValue = caseCount.infected.toDouble();
      }
      flSpots.add(new FlSpot(i.toDouble(), yValue));
      i++;
    });

    int maxCount = flSpots[flSpots.length - 1].y.toInt();
    int minCount = flSpots[0].y.toInt();
    int interval = ((maxCount - minCount)/5).ceil();
    if(interval == 0) interval++;

    return LineChart(
      LineChartData(
        axisTitleData: getAxisTitle(),
        gridData: FlGridData(
          show: false,
          drawVerticalLine: true,
          drawHorizontalLine: true,
          horizontalInterval: (interval/2).toDouble(),
          verticalInterval: _countryStat.cases.length/10,
          getDrawingHorizontalLine: (value) {
            return FlLine(
              color: secondary_text.withOpacity(0.1),
              strokeWidth: 1,
            );
          },
          getDrawingVerticalLine: (value) {
            return FlLine(
              color: secondary_text.withOpacity(0.1),
              strokeWidth: 1,
            );
          },
        ),
        lineTouchData: LineTouchData(
          touchTooltipData: LineTouchTooltipData(
            tooltipBgColor: getColorOfLine(),
            getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
              return touchedBarSpots.map((barSpot) {
                final flSpot = barSpot;
                if (flSpot.x == 0 || flSpot.x == _numberOfDays) {
                  return null;
                }

                return LineTooltipItem(
                  '${_countryStat.cases[flSpot.x.toInt()].date} \n${flSpot.y.toInt()} cases',
                  const TextStyle(color: Colors.white),
                );
              }).toList();
            })),
        borderData: FlBorderData(
          show: true,
          border: Border(left: BorderSide(color: secondary_text), bottom: BorderSide(color: secondary_text))
        ),
        clipToBorder: true,
        lineBarsData: [
          LineChartBarData(
            spots: flSpots,
            isCurved: true,
            barWidth: 3,
            colors: [
              getColorOfLine()
            ],
            dotData: FlDotData(
              show: false,
            ),
            belowBarData: BarAreaData(
              show: true,
              colors: [getColorOfLine().withOpacity(0.2)],
            ),
          ),
        ],
        minY: minCount.toDouble(),
        maxY: maxCount.toDouble() + 5.0,
        titlesData: FlTitlesData(
          bottomTitles: getBottomTitles(),
          leftTitles: getLeftTitles(interval),
        ),
      ),
      swapAnimationDuration: const Duration(milliseconds: 250),
    );
  }

  BarChart getBarChart(){
    //Create bar chart group data
    List<BarChartGroupData> barGroups = new List();
    int i = 0;
    int previous = 0;
    int maxCount = 0;
    int minCount = 10000000000;
    _countryStat.cases.forEach((caseCount) {
      double yValue = caseCount.infected.toDouble();
      switch(iconBoxTexts[_selectedButton]){
        case "D": yValue = (caseCount.deceased - previous).toDouble();previous = caseCount.deceased;break;
        case "R": yValue = (caseCount.recovered - previous).toDouble();previous = caseCount.recovered;break;
        case "A": yValue = (caseCount.active - previous).toDouble();previous = caseCount.active;break;
        default: yValue = (caseCount.infected - previous).toDouble();previous = caseCount.infected;
      }
      if(i!=0){
        BarChartGroupData barGroup = new BarChartGroupData(
          x: i,
          barRods: [
            BarChartRodData(
              y: touchedIndex == i?yValue + 1:yValue,
              color: touchedIndex == i?orange:getColorOfLine(),
              width: screenWidth(context, dividedBy: (_numberOfDays*2).toDouble()),
            )
          ]
        );
        barGroups.add(barGroup);
        maxCount = max(maxCount, yValue.floor());
        minCount = max(minCount, yValue.floor());
      }
      i++;
    });

    int interval = ((maxCount - 0.0)/5).ceil();
    if(interval == 0) interval++;

    return BarChart(
      BarChartData(
        barTouchData: BarTouchData(
          enabled: true,
          touchTooltipData: BarTouchTooltipData(
            tooltipBgColor: getColorOfLine(),
            getTooltipItem: (group, groupIndex, rod, rodIndex){
              return BarTooltipItem(
                '${_countryStat.cases[group.x.toInt()].date} \n${rod.y.toInt()} cases',
                const TextStyle(color: Colors.white),
              );
            }),
          touchCallback: (barTouchResponse) {
            setState(() {
              if (barTouchResponse != null && barTouchResponse.spot != null &&
                barTouchResponse.touchInput is! FlPanEnd &&
                barTouchResponse.touchInput is! FlLongPressEnd) {
                touchedIndex = barTouchResponse.spot.touchedBarGroupIndex;
              } else {
                touchedIndex = -1;
              }
            });
          }
        ),
        axisTitleData: getAxisTitle(),
        barGroups: barGroups,
        gridData: FlGridData(
          show: false,
        ),
        borderData: FlBorderData(
          show: true,
          border: Border(left: BorderSide(color: secondary_text), bottom: BorderSide(color: secondary_text))
        ),
        minY: 0.0,
        maxY: maxCount.toDouble() + 5.0,
        titlesData: FlTitlesData(
          bottomTitles: getBottomTitles(),
          leftTitles: getLeftTitles(interval),
        ),
      ),
      swapAnimationDuration: const Duration(milliseconds: 250),
    );
  }

  FlAxisTitleData getAxisTitle(){
    return FlAxisTitleData(
      show: false,
      topTitle: AxisTitle(
        showTitle: true,
        titleText: selectedChartHeading[_selectedChart],
        textAlign: TextAlign.center,
        reservedSize: 10,
        textStyle: TextStyle(fontSize: 12, color: getColorOfLine(), fontWeight: FontWeight.bold),
      )
    );
  }

  SideTitles getBottomTitles(){
    return SideTitles(
      showTitles: true,
      textStyle: TextStyle(fontSize: 10, color: primary_text, fontWeight: FontWeight.bold),
      getTitles: (value) => getBottomTitle(value.toInt())
    );
  }

  SideTitles getLeftTitles(int interval){
    return SideTitles(
      reservedSize: 30,
      interval: interval.toDouble(),
      showTitles: true,
      textStyle: TextStyle(fontSize: 8, color: primary_text, fontWeight: FontWeight.normal),
      getTitles: (value) => getSideTitle(value.toInt())
    );
  }

  String getBottomTitle(int value){
    int slab = (_countryStat.cases.length/5).floor();
    if(value>=_countryStat.cases.length) return '';
    if(value%slab == 0){
      return _countryStat.cases[value].date;
    }
    return '';
  }

  String getSideTitle(int value){
    if(value>=1000){
      double d = value.toDouble()/1000.0;
      return d.toStringAsFixed(2) + "k";
    } else return value.toString();
//    return '';
  }

//----------------------------------------Timing Buttons------------------------------------------//
  Widget getTimingRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        getTimingBox(0),
        getTimingBox(1),
        getTimingBox(2),
      ],
    );
  }

  Widget getTimingBox(int index){
    int days = 0;
    switch(index){
      case 0: days = getDaysFromBeginning();break;
      case 1: days = 31;break;
      case 2: days = 15;break;
      default: days = 31;break;
    }
    return GestureDetector(
      onTap: () {
        setState(() {
          _numberOfDays = days;
          _selectedLabel = index;
          _countryStat = null;
        });
        loadData();
      },
      child: Container(
        height : screenHeight(context, dividedBy: propTimingBox),
        padding : EdgeInsets.symmetric(horizontal: screenHeight(context, dividedBy: propPaddingSmall)),
        margin : EdgeInsets.symmetric(vertical: screenHeight(context, dividedBy: propPaddingSmall)),
        decoration: BoxDecoration(
          color: _selectedLabel == index?background:getColorOfLine(),
          boxShadow: _selectedLabel == index?inner_icon_shadow:outer_icon_shadow,
          borderRadius: BorderRadius.circular(4.0)
        ),
        child: Center(
          child: Text(
            timingBoxTexts[index],
            style: TextStyle(color: primary_text),
            textScaleFactor: 1.0)),
      ),
    );
  }

//----------------------------------------Other Functions------------------------------------------//

  Color getColorOfLine(){
    Color lineColor = infected_text;
    switch(iconBoxTexts[_selectedButton]){
      case "D": lineColor = secondary_text;break;
      case "R": lineColor = recovered_text;break;
      case "A": lineColor = active_text;break;
      default: lineColor = infected_text;
    }
    return lineColor;
  }

  int getDaysFromBeginning(){
    DateTime current = DateTime.now();
    DateTime beginning = DateTime(2020, DateTime.january, 22);
    int days = current.difference(beginning).inDays;
    return days+1;
  }
}
