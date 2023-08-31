import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:postos_flutter_app/constants/strings.dart';
import 'package:postos_flutter_app/models/schedule.dart';
import 'package:provider/provider.dart';

import '../constants/colors.dart';
import '../constants/constants.dart';
import '../providers/app_provider.dart';

class SchedulesTab extends StatelessWidget {
  const SchedulesTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final appProvider = Provider.of<AppProvider>(context);
    final List<ScheduleModel>? schedules =
        appProvider.schedulesProvider.schedules;

    if (schedules != null && schedules.isNotEmpty) {
      schedules.sort(
          (a, b) => DateTime.parse(b.date).compareTo(DateTime.parse(a.date)));
    }

    return Padding(
      padding: Lists.edgeInsets,
      child: schedules != null && schedules.isNotEmpty
          ? ListView.builder(
              itemCount: schedules.length,
              itemBuilder: (context, index) {
                final schedule = schedules[index];
                return scheduleCard(schedule);
              },
            )
          : noSchedules(),
    );
  }

  Card scheduleCard(ScheduleModel schedule) {
    return Card(
      color: Lists.color,
      elevation: Lists.elevation,
      shape: Lists.shape,
      child: ListTile(
        dense: true,
        contentPadding: Lists.padding,
        title: Row(
          children: [
            scheduleIcon(schedule),
            const SizedBox(width: 8.0),
            Expanded(
              child: scheduleServiceName(schedule),
            ),
            scheduleDate(schedule),
          ],
        ),
      ),
    );
  }

  Icon scheduleIcon(ScheduleModel schedule) {
    String iconName;
    Color iconColor;
    if (schedule.done) {
      iconName = 'check-bold';
      iconColor = Colors.blue;
    } else if (schedule.confirmed) {
      iconName = 'calendar-check';
      iconColor = Colors.green;
    } else {
      iconName = 'calendar-clock';
      iconColor = Colors.grey;
    }
    return Icon(
      MdiIcons.fromString(iconName),
      color: iconColor,
      size: 32.0,
    );
  }

  Column scheduleServiceName(ScheduleModel schedule) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          schedule.scheduleService.name,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: ColorsConstants.textColor,
          ),
        ),
        const SizedBox(height: 4.0),
        Text(
          schedule.gasStation.name,
          style: const TextStyle(
            fontSize: 16,
            color: ColorsConstants.textColor,
          ),
        ),
      ],
    );
  }

  Column scheduleDate(ScheduleModel schedule) {
    final startTime = DateTime.parse(schedule.date);
    final durationParts = schedule.scheduleService.duration.split(':');
    final endTime = startTime.add(Duration(
      hours: int.parse(durationParts[0]),
      minutes: int.parse(durationParts[1]),
    ));
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          DateFormat('dd/MM/yy').format(startTime),
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: ColorsConstants.textColor,
          ),
        ),
        Text(
          '${DateFormat('HH:mm').format(startTime)} - ${DateFormat('HH:mm').format(endTime)}',
          style: const TextStyle(
            fontSize: 16,
            color: ColorsConstants.textColor,
          ),
        ),
      ],
    );
  }

  Center noSchedules() {
    return Center(
      child: SizedBox(
        height: 100,
        child: Card(
          elevation: Lists.elevation,
          shape: Lists.shape,
          child: const Padding(
            padding: EdgeInsets.all(16.0),
            child: Center(
              child: Text(
                SchedulesStrings.noSchedule,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: ColorsConstants.textColor,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
