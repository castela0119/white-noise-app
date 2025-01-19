import 'package:flutter/material.dart';

class TimerDialog extends StatelessWidget {
  final int initialHours;
  final int initialMinutes;
  final Function(int hours, int minutes) onTimerSet;

  const TimerDialog({
    super.key,
    required this.initialHours,
    required this.initialMinutes,
    required this.onTimerSet,
  });

  @override
  Widget build(BuildContext context) {
    int selectedHours = initialHours;
    int selectedMinutes = initialMinutes;

    return StatefulBuilder(
      builder: (context, setState) {
        return AlertDialog(
          title: const Text('Set Timer'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Hours:'),
                  DropdownButton<int>(
                    value: selectedHours,
                    items: List.generate(13, (index) => index)
                        .map((int value) => DropdownMenuItem<int>(
                      value: value,
                      child: Text('$value'),
                    ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedHours = value!;
                      });
                    },
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Minutes:'),
                  DropdownButton<int>(
                    value: selectedMinutes,
                    items: List.generate(60, (index) => index)
                        .map((int value) => DropdownMenuItem<int>(
                      value: value,
                      child: Text('$value'),
                    ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedMinutes = value!;
                      });
                    },
                  ),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                onTimerSet(selectedHours, selectedMinutes);
                Navigator.of(context).pop();
              },
              child: const Text('Set'),
            ),
          ],
        );
      },
    );
  }
}
