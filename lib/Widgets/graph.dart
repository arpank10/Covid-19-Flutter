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
  List<String> selectedButtons = ["I", "R", "D", "A"];
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
            getDatePickers(),
            getTextButtons(),
            getGraph(),
          ],
        ),
      )
    );
  }

  Widget getDatePickers() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        getDatePickerBox(startDate, 0),
        Text("to"),
        getDatePickerBox(endDate, 1),
      ],
    );
  }

  Widget getDatePickerBox(DateTime date, int which){
    String dateString = date.day.toString() + " " + getMonth(date.month) + ", " + date.year.toString();
    return GestureDetector(
      onTap: () => _selectDate(context, which),
      child: Container(
        height : screenHeight(context, dividedBy: propTextBox),
        width : screenWidth(context, dividedBy: 3.0),
        margin : EdgeInsets.all(screenHeight(context, dividedBy: propPaddingLarge)),
        decoration: BoxDecoration(
          gradient: box_background,
          boxShadow: inner_shadow,
          borderRadius: BorderRadius.circular(4.0)
        ),
        child: Center(child: Text(dateString)),
      ),
    );
  }

  void onBoxSelected(String selected){
    setState(() {
      if(selectedButtons.contains(selected))
        selectedButtons.remove(selected);
      else selectedButtons.add(selected);
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
            active: selectedButtons.contains("I")),
          TextBox(
            text: "D",
            onBoxSelected: this.onBoxSelected,
            active: selectedButtons.contains("D")),
          TextBox(
            text: "R",
            onBoxSelected: this.onBoxSelected,
            active: selectedButtons.contains("R")),
          TextBox(
            text: "A",
            onBoxSelected: this.onBoxSelected,
            active: selectedButtons.contains("A")),
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
      flSpots.add(new FlSpot(i.toDouble(), caseCount.infected.toDouble()));
      i++;
    });

    int maxCount = flSpots[flSpots.length - 1].y.toInt();
    int minCount = flSpots[0].y.toInt();
    int interval = ((maxCount - minCount)/100).ceil();
    if(interval == 0) interval++;

    return LineChart(
      LineChartData(
        borderData: FlBorderData(
          show: true,
          border: Border(left: BorderSide(color: primary_text), bottom: BorderSide(color: primary_text))
        ),
        clipToBorder: true,
        lineTouchData: LineTouchData(enabled: false),
        lineBarsData: [
          LineChartBarData(
            spots: flSpots,
            isCurved: true,
            barWidth: 2,
            colors: [
              faded_orange,
            ],
            dotData: FlDotData(
              show: false,
            ),
          ),
/*
          LineChartBarData(
            spots: [
              FlSpot(0, 0),
              FlSpot(1, 3),
              FlSpot(2, 4),
              FlSpot(3, 5),
              FlSpot(4, 8),
              FlSpot(5, 3),
              FlSpot(6, 5),
              FlSpot(7, 8),
              FlSpot(8, 4),
              FlSpot(9, 7),
              FlSpot(10, 7),
              FlSpot(11, 8),
            ],
            isCurved: true,
            barWidth: 2,
            colors: [
              Colors.black,
            ],
            dotData: FlDotData(
              show: false,
            ),
          ),
          LineChartBarData(
            spots: [
              FlSpot(0, 7),
              FlSpot(1, 3),
              FlSpot(2, 4),
              FlSpot(3, 0),
              FlSpot(4, 3),
              FlSpot(5, 4),
              FlSpot(6, 5),
              FlSpot(7, 3),
              FlSpot(8, 2),
              FlSpot(9, 4),
              FlSpot(10, 1),
              FlSpot(11, 3),
            ],
            isCurved: true,
            barWidth: 2,
            colors: [
              Colors.red,
            ],
            dotData: FlDotData(
              show: false,
            ),
          ),
*/
        ],
        minY: minCount.toDouble(),
        maxY: maxCount.toDouble() + 5.0,
        titlesData: FlTitlesData(
          bottomTitles: SideTitles(
            showTitles: true,
            textStyle: TextStyle(fontSize: 10, color: secondary_text, fontWeight: FontWeight.bold),
            getTitles: (value) => getBottomTitle(value.toInt())
          ),
          leftTitles: SideTitles(
            interval: interval.toDouble(),
            showTitles: true,
            textStyle: TextStyle(fontSize: 8, color: secondary_text, fontWeight: FontWeight.normal),
            getTitles: (value) => getSideTitle(value.toInt(), minCount, maxCount)
          ),
        ),
        gridData: FlGridData(
          show: false
        )
      ),
    );
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
    if(value>maxCount) return '';
    int slab = ((maxCount-minCount)/5).floor();
    if((value - minCount) % slab == 0){
      return value.toString();
    }
    return '';
  }

  List<LineChartBarData> getLineChartData(){
    List<LineChartBarData> lines;
    FlSpot f1 = new FlSpot(1, 2);
    FlSpot f2 = new FlSpot(2, 3);
    List<FlSpot> f = [f1, f2];
    LineChartBarData line = new LineChartBarData(
      show: true,
      spots: f
    );
    return lines;
  }


  Future<Null> _selectDate(BuildContext context, int which) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: which == 0?startDate:endDate,
      firstDate: which==1?startDate:DateTime(2020),
      lastDate: which==0?endDate:DateTime.now());

    if (picked != null && picked != startDate)
      setState(() {
        if(which == 0)
          startDate = picked;
        else endDate = picked;
      });
  }

  String getMonth(int month){
    switch(month){
      case 1 : return "Jan";
      case 2 : return "Feb";
      case 3 : return "March";
      case 4 : return "April";
      case 5 : return "May";
      case 6 : return "June";
      case 7 : return "July";
      case 8 : return "Aug";
      case 9 : return "Sept";
      case 10 : return "Oct";
      case 11 : return "Nov";
      case 12 : return "Dec";
    }
    return "Jan";
  }
}
