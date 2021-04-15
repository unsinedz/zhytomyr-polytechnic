import 'package:flutter/material.dart';

import 'package:timetable/src/bl/abstractions/text_localizer.dart';
import 'package:timetable/src/bl/models/models.dart';
import 'package:timetable/src/bl/extensions/date_time_extension.dart';
import 'package:timetable/src/widgets/components/components.dart';

class TimetableTabItem extends StatefulWidget {
  final UpdatableTimetableItem updatableTimetableItem;
  final DateTime dateTime;
  final TextLocalizer textLocalizer;

  TimetableTabItem({
    required this.updatableTimetableItem,
    required this.dateTime,
    required this.textLocalizer,
  });

  @override
  _TimetableTabItemState createState() => _TimetableTabItemState();
}

class _TimetableTabItemState extends State<TimetableTabItem> {
  late bool isCurrentClass = false;

  bool get isNew => widget.updatableTimetableItem.isNew;

  bool get isUpdated => widget.updatableTimetableItem.isUpdated;

  Activity get mainActivity =>
      widget.updatableTimetableItem.timetableItem!.activity;

  Activity get activityUpdate => widget
      .updatableTimetableItem.timetableItemUpdate!.timetableItem!.activity;

  @override
  void initState() {
    if (DateTime.now().asDate().isAtSameMomentAs(widget.dateTime.asDate())) {
      Activity activity;

      if (isNew) {
        activity = activityUpdate;
      } else {
        activity = mainActivity;
      }

      List<String> timeStart = activity.time.start.split(':');
      List<String> timeEnd = activity.time.end.split(':');

      DateTime dateTimeStart = DateTime.now().asDate().add(Duration(
          hours: int.parse(timeStart[0]), minutes: int.parse(timeStart[1])));
      DateTime dateTimeEnd = DateTime.now().asDate().add(Duration(
          hours: int.parse(timeEnd[0]), minutes: int.parse(timeEnd[1])));

      if (DateTime.now().isAfter(dateTimeStart) &&
          DateTime.now().isBefore(dateTimeEnd)) {
        isCurrentClass = true;
      }
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        isUpdated
            ? ActivityCard.canceled(
                activity: mainActivity,
                textLocalizer: widget.textLocalizer,
              )
            : isCurrentClass
                ? ActivityCard.current(
                    activity: mainActivity,
                    textLocalizer: widget.textLocalizer,
                  )
                : isNew
                    ? ActivityCard.added(
                        activity: isNew ? activityUpdate : mainActivity,
                        textLocalizer: widget.textLocalizer,
                      )
                    : ActivityCard.simple(
                        activity: mainActivity,
                        textLocalizer: widget.textLocalizer,
                      ),
        if (isUpdated &&
            widget.updatableTimetableItem.timetableItemUpdate!.timetableItem !=
                null) ...[
          Icon(
            Icons.arrow_downward,
            color: Colors.black,
          ),
          isCurrentClass
              ? ActivityCard.current(
                  activity: activityUpdate,
                  textLocalizer: widget.textLocalizer,
                )
              : ActivityCard.added(
                  activity: activityUpdate,
                  textLocalizer: widget.textLocalizer,
                ),
        ],
      ],
    );
  }
}
