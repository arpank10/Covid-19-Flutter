import 'package:covid/Database/country.dart';
import 'package:covid/Database/database_client.dart';
import 'package:covid/Widgets/Core/box.dart';
import 'package:covid/Widgets/Core/custom_icons.dart';
import 'package:flutter/material.dart';

class StatBox extends StatefulWidget {
  StatBox({Key key,
    @required this.country
  }) : super(key: key);

  final Country country;

  @override
  _StatBoxState createState() => _StatBoxState();
}

class _StatBoxState extends State<StatBox> {
  Future<Country> futureCountry;
  final DatabaseClient db = DatabaseClient.instance;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadStats();
  }

  @override
  void didUpdateWidget(StatBox oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
    if(oldWidget.country != widget.country){
      loadStats();
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Country>(
      future: futureCountry,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return  Column(children: <Widget>[
            Row(
              children: <Widget>[
                DetailBox(
                  category: "Infected",
                  increasedCount: snapshot.data.newConfirmed.toString(),
                  totalCount: snapshot.data.totalConfirmed.toString(),
                  icon: CustomIcon.corona,
                  alignment: TextAlign.left,
                ),
                DetailBox(
                  category: "Deceased",
                  increasedCount: snapshot.data.newDeaths.toString(),
                  totalCount: snapshot.data.totalDeaths.toString(),
                  icon: CustomIcon.dead,
                  alignment: TextAlign.right,
                )
              ],
            ),
            Row(
              children: <Widget>[
                DetailBox(
                  category: "Recovered",
                  increasedCount: snapshot.data.newRecovered.toString(),
                  totalCount: snapshot.data.totalRecovered.toString(),
                  icon: CustomIcon.recovered,
                  alignment: TextAlign.left
                ),
                DetailBox(
                  category: "Active",
                  increasedCount: (snapshot.data.newConfirmed - snapshot.data.newRecovered - snapshot.data.newDeaths).toString(),
                  totalCount: (snapshot.data.totalConfirmed - snapshot.data.totalRecovered - snapshot.data.totalDeaths).toString(),
                  icon: CustomIcon.active,
                  alignment: TextAlign.right,
                )
              ],
            ),
          ]);
        } else {
          return  Column(children: <Widget>[
            Row(
              children: <Widget>[
                DetailBox(
                  category: "Infected",
                  increasedCount: "0",
                  totalCount: "0",
                  icon: CustomIcon.corona,
                  alignment: TextAlign.left,
                ),
                DetailBox(
                  category: "Deceased",
                  increasedCount: "0",
                  totalCount: "0",
                  icon: CustomIcon.dead,
                  alignment: TextAlign.right,
                )
              ],
            ),
            Row(
              children: <Widget>[
                DetailBox(
                  category: "Recovered",
                  increasedCount: "0",
                  totalCount: "0",
                  icon: CustomIcon.recovered,
                  alignment: TextAlign.left
                ),
                DetailBox(
                  category: "Active",
                  increasedCount: "0",
                  totalCount: "0",
                  icon: CustomIcon.active,
                  alignment: TextAlign.right,
                )
              ],
            ),
          ]);
        }
      });
  }

  void loadStats(){
    if(widget.country== null) print("NULL country");
    else print(widget.country.slug);
    if(widget.country == null)
      setState(() {
        futureCountry = db.fetchCountry("global");
      });
    else
      setState(() {
        futureCountry = db.fetchCountry(widget.country.slug);
      });
  }
}
