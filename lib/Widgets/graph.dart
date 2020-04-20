import 'package:covid/Database/cases.dart';
import 'package:covid/Database/country.dart';
import 'package:covid/Widgets/text_box.dart';
import 'package:covid/api.dart';
import 'package:covid/screensize_reducer.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:covid/constants.dart';

class Graph extends StatefulWidget {
  Graph({Key key,
    @required this.country,
  }) : super(key: key);

  final Country country;

  @override
  _GraphState createState() => _GraphState();
}

class _GraphState extends State<Graph> {
  DateTime startDate = DateTime(2020);
  DateTime endDate = DateTime.now();
  String _selectedButton = "I";
  Future<CaseStat> _caseStat;
  CaseStat _countryStat;
  int _numberOfDays = 30;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadData();
  }

  void loadData() {
    _caseStat = fetchDataByCountry(widget.country, _numberOfDays);
    _caseStat.then((value) => _countryStat = value);
  }

  @override
  Widget build(BuildContext context) {

    return Container(
      height: screenHeight(context, dividedBy: propStatBox) + 4*screenHeight(context, dividedBy: propPaddingLarge),
      child: Center(
        child: Column(
          children: <Widget>[
            getTimingRow(),
            getTextButtons(),
            getGraph(),
          ],
        ),
      )
    );
  }

  Widget getTimingRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        getTimingBox("Beginning"),
        getTimingBox("1 Month"),
        getTimingBox("2 Weeks"),
      ],
    );
  }

  Widget getTimingBox(String label){
    int days = 0;
    switch(label){
      case "2 Weeks": days = 14;break;
      case "2 Weeks": days = 14;break;
      default: days = 30;break;
    }
    return GestureDetector(
      onTap: () => setState(() {
        _numberOfDays = days;
      }),
      child: Container(
        height : screenHeight(context, dividedBy: propTextBox),
        margin : EdgeInsets.all(screenHeight(context, dividedBy: propPaddingLarge)),
        decoration: BoxDecoration(
          gradient: box_background,
          boxShadow: inner_shadow,
          borderRadius: BorderRadius.circular(4.0)
        ),
        child: Center(child: Text(label, textScaleFactor: 1.0)),
      ),
    );
  }

  void onBoxSelected(String selected){
    setState(() {
      _selectedButton = selected;
    });
  }

  Widget getTextButtons() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: screenWidth(context, dividedBy: 5)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          TextBox(
            text: "I",
            onBoxSelected: this.onBoxSelected,
            active: _selectedButton == "I"),
          TextBox(
            text: "D",
            onBoxSelected: this.onBoxSelected,
            active: _selectedButton == "D"),
          TextBox(
            text: "R",
            onBoxSelected: this.onBoxSelected,
            active: _selectedButton == "R"),
          TextBox(
            text: "A",
            onBoxSelected: this.onBoxSelected,
            active: _selectedButton == "A"),
        ],
      ),
    );
  }

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
            if(snapshot.hasData){
              return getLineChart();
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
      switch(_selectedButton){
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
        gridData: FlGridData(
          show: true,
          drawVerticalLine: true,
          drawHorizontalLine: true,
          horizontalInterval: (interval/3).toDouble(),
          verticalInterval: 2.0,
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
          ),
        ],
        minY: minCount.toDouble(),
        maxY: maxCount.toDouble() + 5.0,
        titlesData: FlTitlesData(
          bottomTitles: SideTitles(
            showTitles: true,
            textStyle: TextStyle(fontSize: 10, color: primary_text, fontWeight: FontWeight.bold),
            getTitles: (value) => getBottomTitle(value.toInt())
          ),
          leftTitles: SideTitles(
            reservedSize: 30,
            interval: interval.toDouble(),
            showTitles: true,
            textStyle: TextStyle(fontSize: 8, color: primary_text, fontWeight: FontWeight.normal),
            getTitles: (value) => getSideTitle(value.toInt(), minCount, maxCount)
          ),
        ),
//        gridData: FlGridData(
//          show: false
//        )
      ),
      swapAnimationDuration: const Duration(milliseconds: 250),
    );
}

  Color getColorOfLine(){
    Color lineColor = infected_text;
    switch(_selectedButton){
      case "D": lineColor = secondary_text;break;
      case "R": lineColor = recovered_text;break;
      case "A": lineColor = active_text;break;
      default: lineColor = infected_text;
    }
    return lineColor;
  }

  String getBottomTitle(int value){
    int slab = (_numberOfDays/5).floor();
    if(value>=_numberOfDays) return '';
    if(value%slab == 0){
      return _countryStat.cases[value].date;
    }
    return '';
  }

  String getSideTitle(int value, int minCount, int maxCount){
    if(value>=1000){
      double d = value.toDouble()/1000.0;
      return d.toStringAsFixed(2) + "k";
    }
    return '';
  }

}
