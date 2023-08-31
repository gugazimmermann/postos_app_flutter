import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../constants/colors.dart';
import '../../constants/strings.dart';
import '../../models/schedule.dart';

class ScheduleDialog extends StatelessWidget {
  final ScheduleModel schedule;

  const ScheduleDialog({Key? key, required this.schedule}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              SchedulesStrings.title,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 21.0,
                  color: ColorsConstants.textColor),
            ),
            const SizedBox(height: 16.0),
            scheduleStatusText(schedule),
            const SizedBox(height: 16.0),
            Text(
              schedule.scheduleService.name,
              style: const TextStyle(
                  fontSize: 21.0,
                  color: ColorsConstants.textColor,
                  fontWeight: FontWeight.bold),
            ),
            Text(
              schedule.gasStation.name,
              style: const TextStyle(
                  fontSize: 18.0, color: ColorsConstants.textColor),
            ),
            const SizedBox(height: 16.0),
            Row(
              children: [
                scheduleIcon(schedule),
                scheduleDate(schedule),
              ],
            ),
            const SizedBox(height: 16.0),
            scheduleServices(),
            const SizedBox(height: 16.0),
            closeButton(context),
          ],
        ),
      ),
    );
  }

  Text scheduleStatusText(ScheduleModel schedule) {
    String status;
    Color statusColor;

    if (schedule.confirmed) {
      status = 'Confirmado';
      statusColor = ColorsConstants.success;
    } else if (schedule.done) {
      status = 'Realizado';
      statusColor = ColorsConstants.info;
    } else {
      status = 'Aguardando Confirmação';
      statusColor = ColorsConstants.primaryColor;
    }

    return Text(
      status,
      style: TextStyle(
        fontSize: 21.0,
        color: statusColor,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Expanded scheduleIcon(ScheduleModel schedule) {
    String iconName;
    Color iconColor;
    if (schedule.confirmed) {
      iconName = 'calendar-check';
      iconColor = ColorsConstants.success;
    } else if (schedule.done) {
      iconName = 'check-bold';
      iconColor = ColorsConstants.info;
    } else {
      iconName = 'calendar-clock';
      iconColor = ColorsConstants.inactive;
    }
    return Expanded(
        child: Icon(
      MdiIcons.fromString(iconName),
      color: iconColor,
      size: 42.0,
    ));
  }

  Expanded scheduleDate(ScheduleModel schedule) {
    final startTime = DateTime.parse(schedule.date);
    final durationParts = schedule.scheduleService.duration.split(':');
    final endTime = startTime.add(Duration(
      hours: int.parse(durationParts[0]),
      minutes: int.parse(durationParts[1]),
    ));
    return Expanded(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
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
    ));
  }

  Widget scheduleServices() {
    final services =
        schedule.scheduleServiceOptions.map((option) => option.name).join(', ');
    return Text(
      services,
      style: const TextStyle(fontSize: 18.0, color: ColorsConstants.textColor),
    );
  }

  Align closeButton(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: ElevatedButton(
        onPressed: () {
          Navigator.pop(context);
        },
        child: const Text(
          GeneralStrings.buttonClose,
          style: TextStyle(fontSize: 18.0, color: ColorsConstants.textColor),
        ),
      ),
    );
  }
}
