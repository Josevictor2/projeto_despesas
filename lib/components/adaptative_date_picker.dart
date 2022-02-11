import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:universal_platform/universal_platform.dart';

class AdaptativeDate extends StatelessWidget {
  final DateTime? selectedDate;
  final Function(DateTime)? onChanged;
  const AdaptativeDate(
      {Key? key, required this.selectedDate, required this.onChanged})
      : super(key: key);

  _showDatePicker(BuildContext context) {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2018),
      lastDate: DateTime.now(),
    ).then((pickedDate) {
      if (pickedDate == null) {
        return;
      }

      onChanged!(pickedDate);
    });
  }

  @override
  Widget build(BuildContext context) {
    return UniversalPlatform.isIOS
        ? SizedBox(
            height: 180,
            child: CupertinoDatePicker(
              onDateTimeChanged: onChanged!,
              mode: CupertinoDatePickerMode.date,
              initialDateTime: DateTime.now(),
              minimumDate: DateTime(2019),
              maximumDate: DateTime.now(),
            ),
          )
        : SizedBox(
            height: 70,
            child: Row(
              children: [
                Expanded(
                  // ignore: unnecessary_null_comparison
                  child: Text(selectedDate == null
                      ? 'Nenhuma data selecionada'
                      : 'Data selecionada: ${DateFormat('dd/MM/y').format(selectedDate!)}'),
                ),
                TextButton(
                  onPressed: () => _showDatePicker(context),
                  child: const Text(
                    'Selecionar Data',
                    style: TextStyle(
                      color: Colors.purple,
                      fontSize: 14,
                    ),
                  ),
                )
              ],
            ),
          );
  }
}
