import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:timetable_screen/src/abstractions/text_localizer.dart';
import 'package:timetable_screen/src/components/timetable_tab.dart';

import 'abstractions/timetable_loader.dart';
import 'bl/bloc/timetable_bloc.dart';
import 'models/models.dart';

class TimetableScreen extends StatefulWidget {
  final TextLocalizer textLocalizer;
  final TimetableLoader timetableLoader;

  TimetableScreen({required this.textLocalizer, required this.timetableLoader})
      : super();

  @override
  _TimetableScreenState createState() => _TimetableScreenState();
}

class _TimetableScreenState extends State<TimetableScreen> {
  MediaQueryData get mediaQuery => MediaQuery.of(context);
  late TimetableBloc timetableBloc;
  int initialIndex = (DateTime.now().weekday - 1) % 6;

  @override
  void initState() {
    timetableBloc = TimetableBloc(timetableLoader: widget.timetableLoader);

    timetableBloc.loadTimetable(WeekDetermination.Odd);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: initialIndex,
      length: 6,
      child: StreamBuilder<Timetable>(
        stream: timetableBloc.timetable,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Scaffold(
              appBar: AppBar(
                bottom: TabBar(
                  indicatorColor: Colors.amberAccent,
                  labelColor: Colors.white,
                  unselectedLabelColor: Color(0xc3ffffff),
                  // labelStyle: Theme.of(context).textTheme.headline2,
                  // unselectedLabelStyle: Theme.of(context).textTheme.headline2,
                  tabs: [
                    Tab(
                      text: 'ПН',
                    ),
                    Tab(
                      text: 'ВТ',
                    ),
                    Tab(
                      text: 'СР',
                    ),
                    Tab(
                      text: 'ЧТ',
                    ),
                    Tab(
                      text: 'ПТ',
                    ),
                    Tab(
                      text: 'СБ',
                    ),
                  ],
                ),
                leading: IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                title: Text(widget.textLocalizer.localize('Timetable'), style: Theme.of(context).textTheme.headline1,),
              ),
              body: TabBarView(
                children: [
                  TimetableTab(
                      timetable: snapshot.data!,
                      weekNumber: 1,
                      dateTime: DateTime.now().add(Duration(days: -initialIndex))),
                  TimetableTab(
                      timetable: snapshot.data!,
                      weekNumber: 2,
                      dateTime: DateTime.now().add(Duration(days: -initialIndex + 1))),
                  TimetableTab(
                      timetable: snapshot.data!,
                      weekNumber: 3,
                      dateTime: DateTime.now().add(Duration(days: -initialIndex + 2))),
                  TimetableTab(
                      timetable: snapshot.data!,
                      weekNumber: 4,
                      dateTime: DateTime.now().add(Duration(days: -initialIndex + 3))),
                  TimetableTab(
                      timetable: snapshot.data!,
                      weekNumber: 5,
                      dateTime: DateTime.now().add(Duration(days: -initialIndex + 4))),
                  TimetableTab(
                      timetable: snapshot.data!,
                      weekNumber: 6,
                      dateTime: DateTime.now().add(Duration(days: -initialIndex + 5))),
                ],
              ),
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
