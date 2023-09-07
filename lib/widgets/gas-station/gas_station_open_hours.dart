import 'package:flutter/material.dart';

import '../../models/gas_station.dart';
import '../../constants/constants.dart';
import '../../constants/strings.dart';

class GasStationOpenHours extends StatelessWidget {
  const GasStationOpenHours({
    super.key,
    required this.gasStation,
  });

  final GasStationModel gasStation;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      title: const Text(GasStationStrings.openHoursTitle),
      content: SingleChildScrollView(
        child: DataTable(
          columns: const [
            DataColumn(label: Text(GasStationStrings.openHoursDay)),
            DataColumn(label: Text(GasStationStrings.openHoursTime)),
          ],
          rows: gasStation.openHours.map((openHour) {
            return DataRow(
              cells: [
                DataCell(Text(translatedWeekDays[openHour.weekDay] ?? '')),
                DataCell(Text(
                    '${openHour.startTime.substring(0, 5)} - ${openHour.endTime.substring(0, 5)}')),
              ],
            );
          }).toList(),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text(GeneralStrings.buttonClose),
        ),
      ],
    );
  }
}
